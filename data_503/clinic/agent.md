Pet Clinic Database: End-to-End Pipeline
In this assignment, you will apply the entire data engineering pipeline from start to finish. You will take a messy CSV of veterinary clinic records, import it into a staging table, design a normalized schema, build the tables with proper constraints, audit and fix data quality issues, migrate the data, and verify the result.

This is the same pipeline we walked through together with the music catalog. This time, you do it on your own.

Submission Requirements
Your submission should include:

SQL file — All SQL statements, in order, from staging table creation through verification. It should be runnable top-to-bottom on a clean PostgreSQL database.
Data Design Journal — A written document (Markdown or PDF) covering your entire process, decisions, and reflections. See the Data Design Journal section below for required parts.
Note: This is an individual assignment.

🐶
Background: Paws & Claws Veterinary Clinic
Paws & Claws is a small veterinary clinic that has been tracking patients, owners, and visits in a single spreadsheet for the past several months. The spreadsheet has grown unwieldy, and the clinic has hired you to design and populate a proper relational database.

The data covers:

14 pet owners across the Salem and Portland metro areas
22 pets including dogs, cats, birds, rabbits, and reptiles
71 visit records spanning January through March 2026
The data has problems. Some were introduced by different staff members entering records with inconsistent formatting. Some are simple typos. Some are missing values. Finding and fixing these problems is part of the assignment.

📊
About the Data
The CSV file contains denormalized data where owner information, pet information, and visit information are all combined into a single flat table. Owner and pet details are repeated across every visit row.

Column Descriptions
Column	Description
owner_name	Full name of the pet owner
owner_email	Owner's email address
owner_phone	Owner's phone number (may be missing)
pet_name	Name of the pet
species	Species of the pet (Dog, Cat, Bird, Rabbit, Reptile)
breed	Breed of the pet
visit_date	Date of the clinic visit
reason	Reason for the visit
cost	Cost of the visit in USD
A Word of Warning
The data is not clean. Multiple staff members entered records over several months, and consistency was not a priority. You should expect to find issues with casing, missing values, and duplicates. Part of your job is to find them, document them, and fix them before migration.

🛠
Your Task
Complete the entire data engineering pipeline:

Import — Create a staging table and load the CSV using \COPY.
Normalize — Identify entities and relationships. Design a normalized schema (3NF).
Build Tables — Write CREATE TABLE statements with appropriate primary keys, foreign keys, CHECK, UNIQUE, and NOT NULL constraints.
Audit — Inspect the staging data for quality issues. Use GROUP BY, HAVING, IS NULL, and other techniques to find problems.
Fix — Clean the data using UPDATE and DELETE. Back up before modifying.
Migrate — Move data from the staging table into your normalized tables using INSERT INTO ... SELECT. Use transactions.
Verify — Confirm the migration is correct with row counts, JOINs, and constraint checks.
Considerations
As you design your schema and clean the data, consider:

How many entities do you see in this data? What are the relationships between them?
Should you use natural keys or surrogate keys? Why?
Which columns should be NOT NULL? Which can be nullable, and why?
What CHECK constraints make sense for this domain?
What data quality issues exist, and how will you detect each one?
In what order must you populate your normalized tables, and why?
How do you handle missing phone numbers — can you recover them from other rows?
How do you handle duplicate visit records?
📝
The Data Design Journal
The Data Design Journal documents your process, decisions, and reasoning. You wrote a brief version of this for the normalization assignment. This time, it covers the full pipeline.

The journal is not a formality. Two engineers can look at the same data and make different design decisions. The journal explains why you made yours.

Required Sections
Section	What to Include
1. Problem Statement	A brief description of the scenario and your goal. One paragraph. What are you building and why?
2. Assumptions	What did you assume about the data and the business domain? For example: Can a pet have multiple owners? Can two owners share the same email? What species does the clinic treat? Can a visit have zero cost?
3. Normalization Decisions	How did you go from one flat table to multiple related tables? Identify the entities, relationships (with cardinalities), and the normal form you targeted. Include an ERD.
4. Schema Design	Your CREATE TABLE statements with annotations explaining key choices: natural vs. surrogate keys, which columns are NOT NULL and why, what CHECK constraints you added, your ON DELETE behavior, and which indexes you created.
5. Migration Steps	What quality issues you found during the audit, how you fixed each one, and how you migrated the data. Include whether you used transactions and backups.
6. Verification	How you confirmed the migration was correct. Row count comparisons, JOIN queries that reconstruct the original data, constraint validation, edge case checks.
7. Reflection	What went well? What surprised you? What would you do differently next time? Graded on thoughtfulness, not perfection.
📦
Deliverables
Submit the following to Canvas:

SQL File (.sql)
All SQL statements in order: staging table creation, normalized table creation, audit queries, data fixes, migration, and verification
Must be runnable top-to-bottom on a clean PostgreSQL database (except for the file path to the CSV, that will likely be unique on your system
Include comments explaining each major step
Data Design Journal (PDF or Markdown)
All seven sections described above
Include an ERD (embedded image or separate file)
No minimum page count, but thoroughness matters
📐
Grading Rubric
Criteria	Points
Schema Design — Properly normalized tables with appropriate primary keys, foreign keys, constraints, and indexes	20
Data Audit — Quality issues identified and documented with appropriate queries	15
Data Cleaning — Issues fixed correctly using UPDATE and DELETE with backups or transactions	15
Migration — Data migrated correctly using INSERT INTO ... SELECT in proper order with transactions	15
Verification — Row counts, JOIN queries, and constraint checks confirm correctness	10
SQL Quality — File is runnable, well-commented, and follows naming conventions	10
Journal Quality — All seven sections present with clear reasoning, assumptions, and honest reflection	15
Total	100

