-- Drop the table if it exists to allow for "clean" re-runs
DROP TABLE IF EXISTS exchange_rates;

-- Create the table to match your CSV headers
CREATE TABLE exchange_rates (
    rate_date              DATE,
    currency_code          VARCHAR(3),
    currency_name          VARCHAR(50),
    exchange_rate          NUMERIC,
    is_major_currency      BOOLEAN
);

-- Import the data (assuming you moved the file to /tmp/ as instructed)
\copy exchange_rates FROM './exchange_rates.csv' WITH (FORMAT csv, HEADER true);
