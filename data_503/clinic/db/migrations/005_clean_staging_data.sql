-- +goose Up

-- Fix 1: Standardize species to Title Case
UPDATE staging_vet_data SET species = INITCAP(LOWER(TRIM(species)));

-- Fix 2: Standardize email to lowercase
UPDATE staging_vet_data SET owner_email = LOWER(TRIM(owner_email));

-- Fix 3: Standardize breed to Title Case
UPDATE staging_vet_data SET breed = INITCAP(LOWER(TRIM(breed)));

-- Fix 4: Recover missing phone numbers from other rows for the same owner
UPDATE staging_vet_data s
SET owner_phone = sub.known_phone
FROM (
    SELECT owner_email, MAX(owner_phone) AS known_phone
    FROM staging_vet_data
    WHERE owner_phone IS NOT NULL AND owner_phone <> ''
    GROUP BY owner_email
) sub
WHERE s.owner_email = sub.owner_email
  AND (s.owner_phone IS NULL OR s.owner_phone = '');

-- Fix 5: Remove exact duplicate rows (keep lowest row_id)
DELETE FROM staging_vet_data
WHERE row_id NOT IN (
    SELECT MIN(row_id)
    FROM staging_vet_data
    GROUP BY owner_name, owner_email, pet_name, species, breed, visit_date, reason, cost
);

-- +goose Down
-- Restore from backup
DROP TABLE IF EXISTS staging_vet_data;
CREATE TABLE staging_vet_data AS SELECT * FROM staging_vet_data_backup;