-- +goose Up
CREATE TABLE staging_vet_data_backup AS SELECT * FROM staging_vet_data;

-- +goose Down
DROP TABLE IF EXISTS staging_vet_data_backup;