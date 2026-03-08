package main

import (
	"database/sql"
	"encoding/csv"
	"fmt"
	"log"
	"os"
	"strconv"

	_ "github.com/lib/pq"
	"github.com/pressly/goose/v3"
)

type rawRow struct {
	OrderID         int
	OrderDate       string
	CustomerName    string
	CustomerEmail   string
	CustomerCity    string
	CustomerState   string
	ProductName     string
	ProductCategory string
	ProductPrice    float64
	Quantity        int
	SupplierName    string
	SupplierCountry string
}

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

	if err := db.Ping(); err != nil {
		log.Fatal("cannot reach database:", err)
	}

	// Run migrations.
	goose.SetBaseFS(os.DirFS("migrations"))
	if err := goose.SetDialect("postgres"); err != nil {
		log.Fatal(err)
	}
	if err := goose.Up(db, "."); err != nil {
		log.Fatal(err)
	}

	// Read CSV.
	rows, err := readCSV("orders_raw.csv")
	if err != nil {
		log.Fatal(err)
	}
	fmt.Printf("read %d rows from CSV\n", len(rows))

	// Ingest into normalized tables inside a transaction.
	tx, err := db.Begin()
	if err != nil {
		log.Fatal(err)
	}
	defer tx.Rollback()

	if err := ingest(tx, rows); err != nil {
		log.Fatal(err)
	}

	if err := tx.Commit(); err != nil {
		log.Fatal(err)
	}
	fmt.Println("ingestion complete")
}

func readCSV(path string) ([]rawRow, error) {
	f, err := os.Open(path)
	if err != nil {
		return nil, err
	}
	defer f.Close()

	r := csv.NewReader(f)
	records, err := r.ReadAll()
	if err != nil {
		return nil, err
	}

	var rows []rawRow
	for _, rec := range records[1:] { // skip header
		price, err := strconv.ParseFloat(rec[8], 64)
		if err != nil {
			return nil, fmt.Errorf("bad price %q: %w", rec[8], err)
		}
		qty, err := strconv.Atoi(rec[9])
		if err != nil {
			return nil, fmt.Errorf("bad quantity %q: %w", rec[9], err)
		}
		orderID, err := strconv.Atoi(rec[0])
		if err != nil {
			return nil, fmt.Errorf("bad order_id %q: %w", rec[0], err)
		}
		rows = append(rows, rawRow{
			OrderID:         orderID,
			OrderDate:       rec[1],
			CustomerName:    rec[2],
			CustomerEmail:   rec[3],
			CustomerCity:    rec[4],
			CustomerState:   rec[5],
			ProductName:     rec[6],
			ProductCategory: rec[7],
			ProductPrice:    price,
			Quantity:        qty,
			SupplierName:    rec[10],
			SupplierCountry: rec[11],
		})
	}
	return rows, nil
}

func ingest(tx *sql.Tx, rows []rawRow) error {
	// Lookup caches to avoid duplicate inserts; map display value -> DB id.
	customers := make(map[string]int)  // email -> customer_id
	suppliers := make(map[string]int)  // name -> supplier_id
	categories := make(map[string]int) // name -> category_id
	products := make(map[string]int)   // name -> product_id
	orders := make(map[int]bool)       // order_id -> inserted

	for _, r := range rows {
		// Supplier
		if _, ok := suppliers[r.SupplierName]; !ok {
			var id int
			err := tx.QueryRow(
				`INSERT INTO suppliers (name, country) VALUES ($1, $2) RETURNING supplier_id`,
				r.SupplierName, r.SupplierCountry,
			).Scan(&id)
			if err != nil {
				return fmt.Errorf("insert supplier: %w", err)
			}
			suppliers[r.SupplierName] = id
		}

		// Category
		if _, ok := categories[r.ProductCategory]; !ok {
			var id int
			err := tx.QueryRow(
				`INSERT INTO categories (name) VALUES ($1) RETURNING category_id`,
				r.ProductCategory,
			).Scan(&id)
			if err != nil {
				return fmt.Errorf("insert category: %w", err)
			}
			categories[r.ProductCategory] = id
		}

		// Product
		if _, ok := products[r.ProductName]; !ok {
			var id int
			err := tx.QueryRow(
				`INSERT INTO products (name, price, category_id, supplier_id) VALUES ($1, $2, $3, $4) RETURNING product_id`,
				r.ProductName, r.ProductPrice, categories[r.ProductCategory], suppliers[r.SupplierName],
			).Scan(&id)
			if err != nil {
				return fmt.Errorf("insert product: %w", err)
			}
			products[r.ProductName] = id
		}

		// Customer
		if _, ok := customers[r.CustomerEmail]; !ok {
			var id int
			err := tx.QueryRow(
				`INSERT INTO customers (name, email, city, state) VALUES ($1, $2, $3, $4) RETURNING customer_id`,
				r.CustomerName, r.CustomerEmail, r.CustomerCity, r.CustomerState,
			).Scan(&id)
			if err != nil {
				return fmt.Errorf("insert customer: %w", err)
			}
			customers[r.CustomerEmail] = id
		}

		// Order
		if !orders[r.OrderID] {
			_, err := tx.Exec(
				`INSERT INTO orders (order_id, order_date, customer_id) VALUES ($1, $2, $3)`,
				r.OrderID, r.OrderDate, customers[r.CustomerEmail],
			)
			if err != nil {
				return fmt.Errorf("insert order: %w", err)
			}
			orders[r.OrderID] = true
		}

		// Order item
		_, err := tx.Exec(
			`INSERT INTO order_items (order_id, product_id, quantity, unit_price) VALUES ($1, $2, $3, $4)`,
			r.OrderID, products[r.ProductName], r.Quantity, r.ProductPrice,
		)
		if err != nil {
			return fmt.Errorf("insert order_item: %w", err)
		}
	}
	return nil
}
