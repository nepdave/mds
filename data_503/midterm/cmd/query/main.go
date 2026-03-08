package main

import (
	"database/sql"
	"fmt"
	"log"
	"os"
	"text/tabwriter"

	_ "github.com/lib/pq"
)

func main() {
	dsn := os.Getenv("DATABASE_URL")
	if dsn == "" {
		dsn = "postgres://localhost:5432/midterm?sslmode=disable"
	}

	db, err := sql.Open("postgres", dsn)
	if err != nil {
		log.Fatal(err)
	}
	defer db.Close()

	fmt.Println("=== Query 1: Reconstruct original dataset ===")
	if err := queryOriginal(db); err != nil {
		log.Fatal(err)
	}

	fmt.Println("\n=== Query 2: Total revenue per customer ===")
	if err := queryRevenuePerCustomer(db); err != nil {
		log.Fatal(err)
	}

	fmt.Println("\n=== Query 3: Oregon customers and what they bought ===")
	if err := queryOregonOrders(db); err != nil {
		log.Fatal(err)
	}
}

// queryOriginal reconstructs the full denormalized CSV using JOINs.
func queryOriginal(db *sql.DB) error {
	const q = `
SELECT
    o.order_id,
    o.order_date,
    c.name        AS customer_name,
    c.email       AS customer_email,
    c.city        AS customer_city,
    c.state       AS customer_state,
    p.name        AS product_name,
    cat.name      AS product_category,
    oi.unit_price AS product_price,
    oi.quantity,
    s.name        AS supplier_name,
    s.country     AS supplier_country
FROM order_items oi
JOIN orders     o   ON o.order_id    = oi.order_id
JOIN customers  c   ON c.customer_id = o.customer_id
JOIN products   p   ON p.product_id  = oi.product_id
JOIN categories cat ON cat.category_id = p.category_id
JOIN suppliers  s   ON s.supplier_id = p.supplier_id
ORDER BY o.order_id, oi.order_item_id`

	rows, err := db.Query(q)
	if err != nil {
		return err
	}
	defer rows.Close()

	w := tabwriter.NewWriter(os.Stdout, 0, 0, 2, ' ', 0)
	fmt.Fprintln(w, "order_id\tdate\tcustomer\temail\tcity\tstate\tproduct\tcategory\tprice\tqty\tsupplier\tcountry")
	for rows.Next() {
		var (
			orderID                                                          int
			orderDate, custName, custEmail, city, state                      string
			prodName, category, supplierName, supplierCountry                string
			price                                                            float64
			qty                                                              int
		)
		if err := rows.Scan(&orderID, &orderDate, &custName, &custEmail, &city, &state,
			&prodName, &category, &price, &qty, &supplierName, &supplierCountry); err != nil {
			return err
		}
		fmt.Fprintf(w, "%d\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%.2f\t%d\t%s\t%s\n",
			orderID, orderDate[:10], custName, custEmail, city, state,
			prodName, category, price, qty, supplierName, supplierCountry)
	}
	w.Flush()
	return rows.Err()
}

// queryRevenuePerCustomer shows total revenue per customer.
func queryRevenuePerCustomer(db *sql.DB) error {
	const q = `
SELECT
    c.name,
    COUNT(DISTINCT o.order_id) AS total_orders,
    SUM(oi.quantity)           AS total_items,
    SUM(oi.unit_price * oi.quantity) AS total_revenue
FROM customers c
JOIN orders     o  ON o.customer_id = c.customer_id
JOIN order_items oi ON oi.order_id  = o.order_id
GROUP BY c.customer_id, c.name
ORDER BY total_revenue DESC`

	rows, err := db.Query(q)
	if err != nil {
		return err
	}
	defer rows.Close()

	w := tabwriter.NewWriter(os.Stdout, 0, 0, 2, ' ', 0)
	fmt.Fprintln(w, "customer\torders\titems\trevenue")
	for rows.Next() {
		var (
			name    string
			orders  int
			items   int
			revenue float64
		)
		if err := rows.Scan(&name, &orders, &items, &revenue); err != nil {
			return err
		}
		fmt.Fprintf(w, "%s\t%d\t%d\t$%.2f\n", name, orders, items, revenue)
	}
	w.Flush()
	return rows.Err()
}

// queryOregonOrders shows all orders placed by Oregon customers with product details.
func queryOregonOrders(db *sql.DB) error {
	const q = `
SELECT
    c.name       AS customer,
    c.city,
    o.order_id,
    o.order_date,
    p.name       AS product,
    cat.name     AS category,
    oi.quantity,
    oi.unit_price * oi.quantity AS line_total
FROM customers c
JOIN orders      o   ON o.customer_id  = c.customer_id
JOIN order_items oi  ON oi.order_id    = o.order_id
JOIN products    p   ON p.product_id   = oi.product_id
JOIN categories  cat ON cat.category_id = p.category_id
WHERE c.state = 'OR'
ORDER BY c.name, o.order_id, p.name`

	rows, err := db.Query(q)
	if err != nil {
		return err
	}
	defer rows.Close()

	w := tabwriter.NewWriter(os.Stdout, 0, 0, 2, ' ', 0)
	fmt.Fprintln(w, "customer\tcity\torder_id\tdate\tproduct\tcategory\tqty\tline_total")
	for rows.Next() {
		var (
			customer, city, product, category string
			orderID, qty                      int
			orderDate                         string
			lineTotal                         float64
		)
		if err := rows.Scan(&customer, &city, &orderID, &orderDate, &product, &category, &qty, &lineTotal); err != nil {
			return err
		}
		fmt.Fprintf(w, "%s\t%s\t%d\t%s\t%s\t%s\t%d\t$%.2f\n",
			customer, city, orderID, orderDate[:10], product, category, qty, lineTotal)
	}
	w.Flush()
	return rows.Err()
}
