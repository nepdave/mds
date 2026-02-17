# Database Normalization and Relationship Documentation

## Overview
This document outlines the architectural rationale for the current schema. The primary goal of this design is to achieve **3rd Normal Form (3NF)** to ensure data integrity, reduce redundancy, and eliminate update anomalies.

---

## 3NF Normalization Rationale
By moving from a flat-file structure (CSV) to this relational model, we have successfully implemented the following normalization rules:

* **1NF (Atomic Values):** Eliminated repeating groups and ensured every cell contains only one value.
* **2NF (Partial Dependencies):** Ensured every column depends on the *entire* primary key.
* **3NF (Transitive Dependencies):** Removed attributes that rely on other non-key columns (e.g., separating species names from observation records).

**Key Improvement:** Eliminating repeating Personally Identifiable Information (PII) from the original source was a priority for both security and efficiency.

---

## Relationship Definitions

### 1. Submitters to Submissions
* **Type:** One to Zero or Many
* **Rationale:** We only need one record of the Submitter to maintain data integrity. A single Submitter may have zero submissions (new account) or many submissions over time.

### 2. Submissions to Observations
* **Type:** One to One or Many
* **Rationale:** One record defines the submission event (header). Each submission must have at least one observation, but can contain multiple sightings for a single event.

### 3. Submissions to Submission Status History
* **Type:** One to Zero or Many
* **Rationale:** Tracks the lifecycle of a report. One submission can have many status changes (e.g., Pending -> Reviewed -> Approved).

### 4. Submissions to Locations
* **Type:** Zero or Many to One
* **Rationale:** The `submissions` table captures raw latitude/longitude. A submission can exist without being linked to an "official" predefined location in the lookup table.

---

## Lookup Table Rationale (Many-to-One)
The following relationships utilize a "Lookup" pattern to move descriptive data into separate tables where they can be managed independently.

| Relationship | Type | Rationale |
| :--- | :--- | :--- |
| **Submission → Action Taken** | Many-to-One | Maps to a standardized code. Centralizes the management of possible intervention types. |
| **Observations → Species** | Many-to-One | Maps `species_id` to a master list. Eliminates redundant species names and scientific data in observation rows. |
| **Observations → Behavior** | Many-to-One | Maps to a behavior code. Ensures consistent terminology for animal actions. |
| **Status History → Status** | Many-to-One | Links history logs to standardized status definitions (e.g., "Draft", "Submitted"). |

---
