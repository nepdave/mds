# Data Design Journal: Paws & Claws Veterinary Clinic

## 1. Problem Statement

Paws & Claws Veterinary Clinic has been tracking patients, owners, and visits in a single spreadsheet that has become unwieldy and error-prone. The goal is to design and implement a properly normalized relational database that separates concerns into distinct entities, enforces data integrity through constraints, and provides a reliable foundation for the clinic's data management needs. This involves importing the messy CSV data into a staging table, auditing and cleaning data quality issues, designing a normalized schema, migrating the cleaned data, and verifying the result.

## 2. Assumptions

Based on analysis of the data and the veterinary clinic domain, the following assumptions were made:

| Assumption | Rationale |
|------------|-----------|
| **Each pet has exactly one owner** | The data shows each pet associated with one owner email. No evidence of shared pet ownership exists in the dataset. |
| **Owners are uniquely identified by email** | Email addresses serve as a reliable natural identifier. Two people with the same name are distinguished by email. |
| **Two owners cannot share the same email** | Standard practice for business systems; email uniquely identifies an account holder. |
| **A pet is uniquely identified by owner + name + species** | The same owner cannot have two pets with the same name and species (e.g., two dogs both named "Buddy"). |
| **The clinic treats five species** | Data shows: Dog, Cat, Bird, Rabbit, and Reptile. These are the only species in the system. |
| **Visit costs cannot be negative** | Visits represent services rendered; zero cost is allowed (e.g., follow-up), but negative costs are not. |
| **Phone numbers are optional** | Some records are missing phone numbers; this is acceptable as email is the primary contact method. |
| **Duplicate visits (same pet, date, reason, cost) are data entry errors** | Exact duplicates represent accidental double-entry, not legitimate repeat visits on the same day. |

## 3. Normalization Decisions

### Entities Identified

From the flat CSV structure, four distinct entities emerge:

1. **Owners** - People who own pets and bring them to the clinic
2. **Species** - Standardized categories of animals (Dog, Cat, Bird, Rabbit, Reptile)
3. **Pets** - Individual animals belonging to owners
4. **Visits** - Clinic appointments with date, reason, and cost

### Relationships and Cardinalities

| Relationship | Cardinality | Description |
|--------------|-------------|-------------|
| Owner → Pet | 1:N | One owner can have many pets; each pet belongs to exactly one owner |
| Species → Pet | 1:N | One species has many pets; each pet is exactly one species |
| Pet → Visit | 1:N | One pet can have many visits; each visit is for exactly one pet |

### Normalization to 3NF

The original flat table violated multiple normal forms:

- **1NF Violation**: No explicit violations, but redundant data across rows
- **2NF Violation**: Owner information (name, email, phone) repeated for every visit of every pet
- **3NF Violation**: Pet information (name, species, breed) repeated for every visit

**Resolution:**
- Extracted `owners` table with owner attributes
- Extracted `species` lookup table for standardized species names
- Extracted `pets` table linking to owners and species
- Created `visits` table linking only to pets

### Entity-Relationship Diagram

```
┌─────────────────┐       ┌─────────────────┐
│     owners      │       │     species     │
├─────────────────┤       ├─────────────────┤
│ owner_id (PK)   │       │ species_id (PK) │
│ name            │       │ name            │
│ email (UNIQUE)  │       └────────┬────────┘
│ phone           │                │
└────────┬────────┘                │
         │                         │
         │ 1:N                     │ 1:N
         │                         │
         ▼                         ▼
┌─────────────────────────────────────────┐
│                  pets                    │
├─────────────────────────────────────────┤
│ pet_id (PK)                              │
│ owner_id (FK) ─────────────────────────┐ │
│ species_id (FK) ───────────────────────┤ │
│ name                                   │ │
│ breed                                  │ │
│ UNIQUE (owner_id, name, species_id)    │ │
└───────────────────┬─────────────────────┘
                    │
                    │ 1:N
                    │
                    ▼
┌─────────────────────────────────────────┐
│                 visits                   │
├─────────────────────────────────────────┤
│ visit_id (PK)                            │
│ pet_id (FK)                              │
│ visit_date                               │
│ reason                                   │
│ cost (CHECK >= 0)                        │
│ UNIQUE (pet_id, visit_date, reason, cost)│
└─────────────────────────────────────────┘
```

## 4. Schema Design

### Table: owners

```sql
CREATE TABLE owners (
    owner_id    SERIAL PRIMARY KEY,
    name        TEXT        NOT NULL,
    email       TEXT        NOT NULL UNIQUE,
    phone       TEXT                          -- Nullable: some records are missing phone
);

CREATE INDEX idx_owners_email ON owners (email);
```

**Design Decisions:**
- **Surrogate key (`owner_id`)**: Used instead of email as PK for performance (joins on integers are faster) and flexibility (if email format changes)
- **`email` UNIQUE constraint**: Ensures no duplicate owners; serves as natural identifier for lookups
- **`phone` nullable**: 4 owners had missing phone numbers in some records; recovered where possible, but null is acceptable
- **Index on email**: Frequent lookups by email during migration and future queries

### Table: species

```sql
CREATE TABLE species (
    species_id   SERIAL PRIMARY KEY,
    name         TEXT NOT NULL UNIQUE
);
```

**Design Decisions:**
- **Lookup table**: Normalizes species values and prevents typos (e.g., "Dgo" instead of "Dog")
- **Surrogate key**: Allows species names to change without affecting foreign keys
- **UNIQUE on name**: Prevents duplicate species entries

### Table: pets

```sql
CREATE TABLE pets (
    pet_id      SERIAL PRIMARY KEY,
    owner_id    INTEGER     NOT NULL REFERENCES owners(owner_id) ON DELETE CASCADE,
    species_id  INTEGER     NOT NULL REFERENCES species(species_id) ON DELETE RESTRICT,
    name        TEXT        NOT NULL,
    breed       TEXT        NOT NULL,
    UNIQUE (owner_id, name, species_id)
);

CREATE INDEX idx_pets_owner_id ON pets (owner_id);
```

**Design Decisions:**
- **Composite UNIQUE constraint**: Same owner cannot have two pets with identical name and species
- **ON DELETE CASCADE for owner**: If an owner is deleted, their pets are also removed (business decision: orphaned pets don't make sense)
- **ON DELETE RESTRICT for species**: Cannot delete a species that has associated pets
- **Index on owner_id**: Frequent joins and lookups by owner

### Table: visits

```sql
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
```

**Design Decisions:**
- **CHECK constraint on cost**: Prevents negative costs; zero is allowed for complimentary follow-ups
- **NUMERIC(8,2)**: Supports costs up to $999,999.99 with cent precision
- **Composite UNIQUE**: Prevents exact duplicate visits (identified as data entry errors)
- **ON DELETE CASCADE**: If a pet is deleted, visits are removed (no orphaned visit records)
- **Index on visit_date**: Common query pattern to filter by date range

## 5. Migration Steps

### Data Quality Issues Found

| Issue | Detection Query | Records Affected | Resolution |
|-------|-----------------|------------------|------------|
| **Inconsistent species casing** | `GROUP BY species` showing 'dog', 'Dog', 'cat', 'Cat', etc. | 12 rows | `UPDATE SET species = INITCAP(LOWER(species))` |
| **Inconsistent email casing** | Emails like 'MARIA@EMAIL.COM' vs 'maria@email.com' | 3 rows | `UPDATE SET owner_email = LOWER(owner_email)` |
| **Inconsistent breed casing** | 'shih tzu' vs 'Shih Tzu' | 1 row | `UPDATE SET breed = INITCAP(LOWER(breed))` |
| **Missing phone numbers** | `WHERE owner_phone IS NULL` | 4 rows | Recovered from other rows with same email |
| **Duplicate visit records** | `GROUP BY ... HAVING COUNT(*) > 1` (case-insensitive) | 2 duplicates: Oliver (vaccination), Ginger (nail trim) | `DELETE` keeping lowest row_id |

### Cleaning Process

1. **Created backup table** before any modifications:
   ```sql
   CREATE TABLE staging_vet_data_backup AS SELECT * FROM staging_vet_data;
   ```

2. **Standardized casing** for species, email, and breed using INITCAP/LOWER

3. **Recovered missing phones** by joining on email to find known values:
   ```sql
   UPDATE staging_vet_data s
   SET owner_phone = sub.known_phone
   FROM (SELECT owner_email, MAX(owner_phone) AS known_phone
         FROM staging_vet_data
         WHERE owner_phone IS NOT NULL
         GROUP BY owner_email) sub
   WHERE s.owner_email = sub.owner_email
     AND s.owner_phone IS NULL;
   ```

4. **Removed duplicates** keeping the first occurrence (lowest row_id)

### Migration Order

Data was migrated in order respecting foreign key dependencies:

1. **species** (no dependencies)
2. **owners** (no dependencies)
3. **pets** (depends on owners, species)
4. **visits** (depends on pets)

### Transaction Usage

The entire migration was wrapped in a transaction:

```sql
BEGIN;
INSERT INTO species ...
INSERT INTO owners ...
INSERT INTO pets ...
INSERT INTO visits ...
COMMIT;
```

This ensures atomicity: if any step fails, no partial data is committed.

## 6. Verification

### Row Count Verification

| Table | Expected | Actual | Status |
|-------|----------|--------|--------|
| staging_vet_data | 69 (71 - 2 duplicates) | 69 | ✓ |
| owners | 14 | 14 | ✓ |
| species | 5 | 5 | ✓ |
| pets | 28 | 28 | ✓ |
| visits | 69 | 69 | ✓ |

### Revenue Totals Match

```sql
SELECT (SELECT SUM(cost) FROM staging_vet_data) AS staging_total,
       (SELECT SUM(cost) FROM visits) AS visits_total;
-- Result: $8,495.00 in both tables ✓
```

### No Orphaned Records

```sql
-- Check for pets without owners
SELECT COUNT(*) FROM pets p 
LEFT JOIN owners o ON p.owner_id = o.owner_id 
WHERE o.owner_id IS NULL;
-- Result: 0 ✓

-- Check for visits without pets
SELECT COUNT(*) FROM visits v 
LEFT JOIN pets p ON v.pet_id = p.pet_id 
WHERE p.pet_id IS NULL;
-- Result: 0 ✓
```

### Data Reconstruction

Verified that JOIN across normalized tables reproduces the original (cleaned) staging data:

```sql
SELECT o.name, o.email, o.phone, p.name, sp.name, p.breed, v.visit_date, v.reason, v.cost
FROM visits v
JOIN pets p ON v.pet_id = p.pet_id
JOIN owners o ON p.owner_id = o.owner_id
JOIN species sp ON p.species_id = sp.species_id
ORDER BY v.visit_date;
```

### Constraint Validation

Verified constraints prevent invalid data:
- Foreign key violations blocked (tested with non-existent pet_id)
- Negative cost blocked by CHECK constraint
- Duplicate emails blocked by UNIQUE constraint

### Species Distribution

| Species | Pets | Visits |
|---------|------|--------|
| Dog | 14 | 40 |
| Cat | 9 | 20 |
| Bird | 2 | 4 |
| Reptile | 2 | 3 |
| Rabbit | 1 | 2 |

## 7. Reflection

### What Went Well

- **The staging table approach worked smoothly**: Loading messy data into a flexible staging table, then cleaning it before migration, was much easier than trying to load directly into constrained tables.
- **Case-insensitive duplicate detection caught hidden duplicates**: The Ginger "rabbit/Rabbit" duplicate would have been missed without normalizing species case in the GROUP BY.
- **Phone number recovery was straightforward**: Since owners appeared in multiple rows, missing phones could be filled from other rows with the same email.
- **Transaction wrapping the migration provided safety**: Though it succeeded on the first try, having the transaction meant any failure would leave the database clean.

### What Surprised Me

- **The pet count didn't match the assignment description**: The assignment stated 22 pets, but the data actually contains 28 unique pets (14 owners × 2 pets each). This required investigation to confirm the data was correct and the assignment description was approximate.
- **Species casing inconsistency was more prevalent than expected**: Four different species (Dog, Cat, Bird, Rabbit) had casing variations scattered throughout the data.
- **The duplicate detection query needed case-insensitive matching**: A simple GROUP BY wouldn't catch duplicates where only the casing differed.

### What I Would Do Differently

- **Add a phone validation pattern**: A CHECK constraint like `phone ~ '^\d{3}-\d{3}-\d{4}$'` would enforce consistent phone formatting and catch typos.
- **Consider a breeds lookup table**: Like species, breeds could be normalized to prevent variations like "shih tzu" vs "Shih Tzu". However, this adds complexity and wasn't strictly necessary for this dataset.
- **Add created_at/updated_at timestamps**: For a production system, tracking when records were created and modified would be valuable for auditing.
- **Consider soft deletes**: Instead of ON DELETE CASCADE, a `deleted_at` timestamp column would preserve historical data while hiding "deleted" records from normal queries.
