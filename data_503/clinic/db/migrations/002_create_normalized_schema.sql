-- +goose Up
CREATE TABLE owners (
    owner_id    SERIAL PRIMARY KEY,
    name        TEXT        NOT NULL,
    email       TEXT        NOT NULL UNIQUE,
    phone       TEXT
);

CREATE INDEX idx_owners_email ON owners (email);

CREATE TABLE species (
    species_id   SERIAL PRIMARY KEY,
    name         TEXT NOT NULL UNIQUE
);

CREATE TABLE pets (
    pet_id      SERIAL PRIMARY KEY,
    owner_id    INTEGER     NOT NULL REFERENCES owners(owner_id) ON DELETE CASCADE,
    species_id  INTEGER     NOT NULL REFERENCES species(species_id) ON DELETE RESTRICT,
    name        TEXT        NOT NULL,
    breed       TEXT        NOT NULL,
    UNIQUE (owner_id, name, species_id)
);

CREATE INDEX idx_pets_owner_id ON pets (owner_id);

CREATE TABLE visits (
    visit_id    SERIAL PRIMARY KEY,
    pet_id      INTEGER     NOT NULL REFERENCES pets(pet_id) ON DELETE CASCADE,
    visit_date  DATE        NOT NULL,
    reason      TEXT        NOT NULL,
    cost        NUMERIC(8,2) NOT NULL CHECK (cost >= 0),
    UNIQUE (pet_id, visit_date, reason, cost)
);

CREATE INDEX idx_visits_pet_id ON visits (pet_id);
CREATE INDEX idx_visits_visit_date ON visits (visit_date);

-- +goose Down
DROP TABLE IF EXISTS visits;
DROP TABLE IF EXISTS pets;
DROP TABLE IF EXISTS species;
DROP TABLE IF EXISTS owners;