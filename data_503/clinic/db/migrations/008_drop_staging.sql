-- +goose Up
-- Clean up staging tables now that migration is verified.
DROP TABLE IF EXISTS staging_vet_data_backup;
DROP TABLE IF EXISTS staging_vet_data;

-- +goose Down
-- If we need to rollback, recreate the staging table (data will be lost).
CREATE TABLE staging_vet_data (
    row_id        SERIAL PRIMARY KEY,
    owner_name    TEXT,
    owner_email   TEXT,
    owner_phone   TEXT,
    pet_name      TEXT,
    species       TEXT,
    breed         TEXT,
    visit_date    DATE,
    reason        TEXT,
    cost          NUMERIC(8,2)
);