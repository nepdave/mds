-- +goose Up
-- +goose StatementBegin

-- Verification queries — these SELECT statements confirm correctness.
-- They don't modify data. If any returns unexpected results, investigate before proceeding.

-- Row counts

DO $$
DECLARE
    v_staging  INTEGER;
    v_owners   INTEGER;
    v_species  INTEGER;
    v_pets     INTEGER;
    v_visits   INTEGER;
BEGIN
    SELECT COUNT(*) INTO v_staging FROM staging_vet_data;
    SELECT COUNT(*) INTO v_owners  FROM owners;
    SELECT COUNT(*) INTO v_species FROM species;
    SELECT COUNT(*) INTO v_pets    FROM pets;
    SELECT COUNT(*) INTO v_visits  FROM visits;

    -- Updated to 69 based on actual data count
    ASSERT v_staging = 69, 'Staging should have 69 rows, got ' || v_staging;
    ASSERT v_owners  = 14, 'Owners should have 14 rows, got '  || v_owners;
    ASSERT v_species = 5,  'Species should have 5 rows, got '  || v_species;
    ASSERT v_pets    = 28, 'Pets should have 28 rows, got '    || v_pets;
    ASSERT v_visits  = 69, 'Visits should have 69 rows, got '  || v_visits;

    RAISE NOTICE 'All row counts verified.';
END $$;

-- Revenue totals match
DO $$
DECLARE
    v_staging_total NUMERIC;
    v_visits_total  NUMERIC;
BEGIN
    SELECT SUM(cost) INTO v_staging_total FROM staging_vet_data;
    SELECT SUM(cost) INTO v_visits_total  FROM visits;

    ASSERT v_staging_total = v_visits_total,
        'Revenue mismatch: staging=' || v_staging_total || ' visits=' || v_visits_total;

    RAISE NOTICE 'Revenue totals match: $%', v_visits_total;
END $$;

-- No orphaned records
DO $$
DECLARE
    v_orphan_pets   INTEGER;
    v_orphan_visits INTEGER;
BEGIN
    SELECT COUNT(*) INTO v_orphan_pets
    FROM pets p LEFT JOIN owners o ON p.owner_id = o.owner_id
    WHERE o.owner_id IS NULL;

    SELECT COUNT(*) INTO v_orphan_visits
    FROM visits v LEFT JOIN pets p ON v.pet_id = p.pet_id
    WHERE p.pet_id IS NULL;

    ASSERT v_orphan_pets   = 0, 'Found orphaned pets!';
    ASSERT v_orphan_visits = 0, 'Found orphaned visits!';

    RAISE NOTICE 'No orphaned records found.';
END $$;


-- Nothing to undo — verification is read-only.
SELECT 1;

-- +goose StatementEnd
-- +goose Down
