-- +goose Up
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

-- +goose Down
DROP TABLE IF EXISTS staging_vet_data;
