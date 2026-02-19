-- +goose Up

-- 1. Species
INSERT INTO species (name)
SELECT DISTINCT species
FROM staging_vet_data
ORDER BY species;

-- 2. Owners
INSERT INTO owners (name, email, phone)
SELECT DISTINCT owner_name, owner_email, owner_phone
FROM staging_vet_data
ORDER BY owner_name;

-- 3. Pets
INSERT INTO pets (owner_id, species_id, name, breed)
SELECT DISTINCT o.owner_id, sp.species_id, s.pet_name, s.breed
FROM staging_vet_data s
JOIN owners o   ON s.owner_email = o.email
JOIN species sp ON s.species = sp.name
ORDER BY o.owner_id, s.pet_name;

-- 4. Visits
INSERT INTO visits (pet_id, visit_date, reason, cost)
SELECT p.pet_id, s.visit_date, s.reason, s.cost
FROM staging_vet_data s
JOIN owners o   ON s.owner_email = o.email
JOIN species sp ON s.species = sp.name
JOIN pets p     ON p.owner_id = o.owner_id
                AND p.species_id = sp.species_id
                AND p.name = s.pet_name
ORDER BY s.visit_date, p.pet_id;

-- +goose Down
DELETE FROM visits;
DELETE FROM pets;
DELETE FROM species;
DELETE FROM owners;