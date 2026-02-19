-- ============================================================================
-- Stack Overflow Developer Survey 2025 - Supplementary Tables
-- ============================================================================

-- ============================================================================
-- Table 1: country_stats
-- Aggregated statistics by country with dates and numeric summaries
-- Enables: Date arithmetic, AVG/SUM calculations, percentage calculations
-- ============================================================================
DROP TABLE IF EXISTS country_stats;

CREATE TABLE country_stats (
    country_code        CHAR(3) PRIMARY KEY,
    country_name        VARCHAR(100) NOT NULL,
    region              VARCHAR(50),
    respondent_count    INTEGER NOT NULL,
    avg_salary_usd      NUMERIC(12, 2),
    median_salary_usd   NUMERIC(12, 2),
    min_salary_usd      NUMERIC(12, 2),
    max_salary_usd      NUMERIC(12, 2),
    avg_experience_yrs  NUMERIC(4, 1),
    avg_job_satisfaction NUMERIC(3, 1),
    pct_remote          NUMERIC(5, 2),
    pct_using_ai_daily  NUMERIC(5, 2),
    survey_start_date   DATE,
    survey_end_date     DATE,
    last_updated        TIMESTAMP
);

INSERT INTO country_stats VALUES
('USA', 'United States of America', 'North America', 12847, 145000.00, 135000.00, 25000.00, 750000.00, 11.2, 7.1, 42.50, 38.20, '2025-01-15', '2025-02-28', '2025-03-15 14:30:00'),
('DEU', 'Germany', 'Europe', 4521, 85000.00, 78000.00, 28000.00, 280000.00, 9.8, 7.4, 28.30, 41.50, '2025-01-15', '2025-02-28', '2025-03-15 14:30:00'),
('GBR', 'United Kingdom', 'Europe', 3892, 92000.00, 85000.00, 30000.00, 320000.00, 10.1, 6.9, 35.70, 44.20, '2025-01-15', '2025-02-28', '2025-03-15 14:30:00'),
('IND', 'India', 'Asia', 8234, 28000.00, 22000.00, 5000.00, 180000.00, 6.4, 7.8, 31.20, 52.30, '2025-01-15', '2025-02-28', '2025-03-15 14:30:00'),
('CAN', 'Canada', 'North America', 2156, 115000.00, 105000.00, 35000.00, 350000.00, 10.5, 7.2, 38.90, 39.80, '2025-01-15', '2025-02-28', '2025-03-15 14:30:00'),
('BRA', 'Brazil', 'South America', 1823, 35000.00, 28000.00, 8000.00, 150000.00, 7.2, 7.0, 45.60, 48.70, '2025-01-15', '2025-02-28', '2025-03-15 14:30:00'),
('FRA', 'France', 'Europe', 1654, 72000.00, 65000.00, 32000.00, 220000.00, 9.1, 6.5, 22.40, 36.90, '2025-01-15', '2025-02-28', '2025-03-15 14:30:00'),
('AUS', 'Australia', 'Oceania', 1432, 105000.00, 98000.00, 40000.00, 280000.00, 10.8, 7.3, 36.80, 42.10, '2025-01-15', '2025-02-28', '2025-03-15 14:30:00'),
('NLD', 'Netherlands', 'Europe', 1287, 82000.00, 75000.00, 35000.00, 240000.00, 9.5, 7.6, 33.50, 45.60, '2025-01-15', '2025-02-28', '2025-03-15 14:30:00'),
('POL', 'Poland', 'Europe', 1198, 48000.00, 42000.00, 15000.00, 160000.00, 7.8, 7.2, 52.30, 44.80, '2025-01-15', '2025-02-28', '2025-03-15 14:30:00'),
('UKR', 'Ukraine', 'Europe', 987, 42000.00, 36000.00, 10000.00, 140000.00, 7.1, 6.8, 68.50, 51.20, '2025-01-15', '2025-02-28', '2025-03-15 14:30:00'),
('ESP', 'Spain', 'Europe', 892, 55000.00, 48000.00, 22000.00, 180000.00, 8.4, 6.7, 29.80, 38.40, '2025-01-15', '2025-02-28', '2025-03-15 14:30:00'),
('SWE', 'Sweden', 'Europe', 845, 78000.00, 72000.00, 38000.00, 200000.00, 10.2, 7.5, 41.20, 43.70, '2025-01-15', '2025-02-28', '2025-03-15 14:30:00'),
('JPN', 'Japan', 'Asia', 756, 62000.00, 55000.00, 28000.00, 190000.00, 11.5, 5.8, 18.90, 29.30, '2025-01-15', '2025-02-28', '2025-03-15 14:30:00'),
('ISR', 'Israel', 'Middle East', 623, 125000.00, 115000.00, 45000.00, 380000.00, 9.8, 7.0, 34.60, 47.80, '2025-01-15', '2025-02-28', '2025-03-15 14:30:00'),
('CHE', 'Switzerland', 'Europe', 587, 138000.00, 130000.00, 55000.00, 350000.00, 11.0, 7.4, 26.70, 40.50, '2025-01-15', '2025-02-28', '2025-03-15 14:30:00'),
('ITA', 'Italy', 'Europe', 534, 52000.00, 45000.00, 24000.00, 150000.00, 8.7, 6.2, 24.30, 35.80, '2025-01-15', '2025-02-28', '2025-03-15 14:30:00'),
('ARG', 'Argentina', 'South America', 478, 32000.00, 26000.00, 6000.00, 120000.00, 6.9, 6.5, 58.40, 46.90, '2025-01-15', '2025-02-28', '2025-03-15 14:30:00'),
('MEX', 'Mexico', 'North America', 423, 38000.00, 32000.00, 10000.00, 130000.00, 7.5, 7.1, 42.80, 44.20, '2025-01-15', '2025-02-28', '2025-03-15 14:30:00'),
('SGP', 'Singapore', 'Asia', 389, 98000.00, 88000.00, 42000.00, 280000.00, 8.9, 7.2, 28.50, 49.60, '2025-01-15', '2025-02-28', '2025-03-15 14:30:00');


-- ============================================================================
-- Table 2: role_benchmarks
-- Salary and satisfaction benchmarks by developer role
-- Enables: Comparisons, percentage difference calculations, CASE categorization
-- ============================================================================
DROP TABLE IF EXISTS role_benchmarks;

CREATE TABLE role_benchmarks (
    role_id             SERIAL PRIMARY KEY,
    role_name           VARCHAR(100) NOT NULL,
    role_category       VARCHAR(50),
    sample_size         INTEGER NOT NULL,
    avg_salary_usd      NUMERIC(12, 2),
    salary_25th_pctl    NUMERIC(12, 2),
    salary_75th_pctl    NUMERIC(12, 2),
    avg_years_exp       NUMERIC(4, 1),
    avg_job_satisfaction NUMERIC(3, 1),
    pct_remote          NUMERIC(5, 2),
    pct_ai_favorable    NUMERIC(5, 2),
    yoy_salary_change   NUMERIC(5, 2),
    demand_score        NUMERIC(3, 1)
);

INSERT INTO role_benchmarks (role_name, role_category, sample_size, avg_salary_usd, salary_25th_pctl, salary_75th_pctl, avg_years_exp, avg_job_satisfaction, pct_remote, pct_ai_favorable, yoy_salary_change, demand_score) VALUES
('Developer, full-stack', 'Development', 15234, 95000.00, 65000.00, 125000.00, 8.2, 7.1, 42.30, 68.50, 4.20, 8.5),
('Developer, back-end', 'Development', 12456, 105000.00, 72000.00, 138000.00, 9.1, 7.0, 38.70, 65.20, 3.80, 8.2),
('Developer, front-end', 'Development', 9823, 85000.00, 58000.00, 112000.00, 7.4, 6.8, 45.60, 72.30, 3.50, 7.8),
('Developer, mobile', 'Development', 5432, 98000.00, 68000.00, 128000.00, 7.8, 7.2, 41.20, 71.80, 5.10, 7.9),
('DevOps specialist', 'Operations', 4521, 118000.00, 85000.00, 152000.00, 9.5, 7.3, 48.90, 62.40, 6.20, 9.1),
('Data scientist', 'Data', 3892, 125000.00, 88000.00, 165000.00, 6.8, 7.5, 52.30, 78.90, 7.50, 9.4),
('Data engineer', 'Data', 3456, 122000.00, 85000.00, 158000.00, 7.2, 7.2, 49.80, 74.60, 8.20, 9.2),
('Machine learning engineer', 'Data', 2345, 145000.00, 105000.00, 185000.00, 5.9, 7.8, 54.60, 85.20, 12.30, 9.7),
('Site reliability engineer', 'Operations', 1987, 135000.00, 98000.00, 172000.00, 10.2, 7.1, 46.70, 58.30, 5.80, 8.8),
('Security engineer', 'Security', 1654, 128000.00, 92000.00, 165000.00, 9.8, 7.0, 38.40, 52.10, 6.50, 8.9),
('Database administrator', 'Data', 1432, 95000.00, 68000.00, 122000.00, 11.5, 6.5, 32.10, 48.70, 2.10, 6.8),
('QA/Test engineer', 'Quality', 1287, 78000.00, 55000.00, 102000.00, 8.4, 6.4, 35.80, 58.90, 2.80, 6.5),
('Engineering manager', 'Management', 2156, 165000.00, 125000.00, 210000.00, 14.2, 7.4, 38.90, 61.20, 4.50, 8.3),
('Product manager', 'Management', 1823, 142000.00, 105000.00, 180000.00, 10.8, 7.2, 42.30, 72.40, 5.20, 8.6),
('Designer', 'Design', 987, 82000.00, 55000.00, 108000.00, 7.1, 7.0, 48.50, 69.80, 3.20, 7.4);


-- ============================================================================
-- Table 3: currency_rates
-- IMPORTANT: This table has been moved to a separate file: currency_rates_2025.sql
-- The new version contains monthly exchange rates for all of 2025 (12 months x 20 currencies = 240 rows)
-- This enables date interval calculations and historical currency analysis
-- Run currency_rates_2025.sql to create and populate the currency_rates table
-- ============================================================================
-- See currency_rates_2025.sql and currency_rates_2025.csv for full data


-- ============================================================================
-- Table 4: response_timeline
-- Individual response metadata with timestamps
-- Enables: Date/time functions, EXTRACT, AGE, INTERVAL arithmetic
-- ============================================================================
DROP TABLE IF EXISTS response_timeline;

CREATE TABLE response_timeline (
    response_id         INTEGER PRIMARY KEY,
    submitted_at        TIMESTAMP NOT NULL,
    started_at          TIMESTAMP NOT NULL,
    completion_time_sec INTEGER,
    respondent_timezone VARCHAR(50),
    career_start_date   DATE,
    current_job_start   DATE,
    last_promotion_date DATE
);

-- Generate sample data for the first 100 response_ids
INSERT INTO response_timeline VALUES
(1, '2025-01-18 14:32:15', '2025-01-18 14:12:45', 1170, 'Europe/Kiev', '2017-03-15', '2022-08-01', '2024-06-15'),
(2, '2025-01-19 09:45:22', '2025-01-19 09:22:10', 1392, 'Europe/Amsterdam', '2023-06-01', '2023-06-01', NULL),
(3, '2025-01-19 16:08:33', '2025-01-19 15:48:12', 1221, 'Europe/Kiev', '2013-09-10', '2020-03-15', '2023-11-01'),
(4, '2025-01-20 11:22:41', '2025-01-20 10:58:30', 1451, 'Europe/Kiev', '2021-01-15', '2024-02-01', NULL),
(5, '2025-01-20 18:55:08', '2025-01-20 18:32:45', 1343, 'America/New_York', '2015-08-20', '2019-11-01', '2023-03-15'),
(6, '2025-01-21 08:12:33', '2025-01-21 07:48:22', 1451, 'America/Los_Angeles', '2018-06-15', '2021-09-01', '2024-01-15'),
(7, '2025-01-21 14:28:45', '2025-01-21 14:05:18', 1407, 'Europe/London', '2012-04-01', '2018-07-15', '2022-09-01'),
(8, '2025-01-22 10:15:22', '2025-01-22 09:52:10', 1392, 'Asia/Kolkata', '2020-07-01', '2023-01-15', '2024-08-01'),
(9, '2025-01-22 16:42:18', '2025-01-22 16:18:45', 1413, 'Europe/Berlin', '2016-02-15', '2020-06-01', '2023-12-15'),
(10, '2025-01-23 09:08:55', '2025-01-23 08:45:30', 1405, 'America/Toronto', '2014-11-01', '2019-04-15', '2022-07-01'),
(11, '2025-01-23 15:33:12', '2025-01-23 15:08:45', 1467, 'Australia/Sydney', '2017-08-15', '2022-02-01', '2024-05-15'),
(12, '2025-01-24 11:48:30', '2025-01-24 11:22:15', 1575, 'Asia/Tokyo', '2010-04-01', '2015-09-15', '2020-03-01'),
(13, '2025-01-24 17:22:45', '2025-01-24 16:58:30', 1455, 'Europe/Paris', '2019-01-15', '2022-05-01', '2024-02-15'),
(14, '2025-01-25 08:55:18', '2025-01-25 08:32:05', 1393, 'America/Sao_Paulo', '2018-03-01', '2021-08-15', '2023-11-01'),
(15, '2025-01-25 14:18:42', '2025-01-25 13:52:30', 1572, 'Europe/Warsaw', '2016-09-15', '2020-12-01', '2024-04-15'),
(16, '2025-01-26 10:42:55', '2025-01-26 10:18:22', 1473, 'America/Chicago', '2013-05-01', '2017-10-15', '2021-06-01'),
(17, '2025-01-26 16:08:33', '2025-01-26 15:45:10', 1403, 'Europe/Stockholm', '2015-12-15', '2019-03-01', '2022-08-15'),
(18, '2025-01-27 09:35:22', '2025-01-27 09:12:45', 1357, 'Asia/Singapore', '2019-07-01', '2023-04-15', NULL),
(19, '2025-01-27 15:52:18', '2025-01-27 15:28:30', 1428, 'Europe/Madrid', '2017-02-15', '2021-06-01', '2024-01-15'),
(20, '2025-01-28 11:18:45', '2025-01-28 10:55:22', 1403, 'America/Denver', '2014-08-01', '2018-11-15', '2022-04-01'),
(21, '2025-01-28 17:42:33', '2025-01-28 17:18:10', 1463, 'Europe/Zurich', '2011-03-15', '2016-07-01', '2020-12-15'),
(22, '2025-01-29 08:08:55', '2025-01-29 07:45:30', 1405, 'Asia/Tel_Aviv', '2016-10-01', '2020-02-15', '2023-07-01'),
(23, '2025-01-29 14:35:22', '2025-01-29 14:12:45', 1357, 'America/Mexico_City', '2018-05-15', '2022-09-01', '2024-03-15'),
(24, '2025-01-30 10:55:18', '2025-01-30 10:32:05', 1393, 'Europe/Rome', '2015-01-01', '2019-05-15', '2022-10-01'),
(25, '2025-01-30 16:22:45', '2025-01-30 15:58:30', 1455, 'America/Buenos_Aires', '2019-11-15', '2023-03-01', NULL),
(26, '2025-01-31 09:48:33', '2025-01-31 09:25:10', 1403, 'Pacific/Auckland', '2017-06-01', '2021-10-15', '2024-02-01'),
(27, '2025-01-31 15:15:22', '2025-01-31 14:52:45', 1350, 'Europe/Amsterdam', '2013-12-15', '2018-04-01', '2021-09-15'),
(28, '2025-02-01 11:42:18', '2025-02-01 11:18:30', 1428, 'Asia/Kolkata', '2020-02-01', '2023-07-15', '2024-11-01'),
(29, '2025-02-01 17:08:55', '2025-02-01 16:45:22', 1413, 'America/New_York', '2016-07-15', '2020-11-01', '2023-05-15'),
(30, '2025-02-02 10:35:33', '2025-02-02 10:12:10', 1403, 'Europe/London', '2014-04-01', '2018-08-15', '2022-01-01'),
(31, '2025-02-02 16:02:45', '2025-02-02 15:38:30', 1455, 'Australia/Melbourne', '2018-09-15', '2022-01-01', '2024-06-15'),
(32, '2025-02-03 09:28:22', '2025-02-03 09:05:45', 1357, 'Europe/Berlin', '2015-06-01', '2019-10-15', '2023-02-01'),
(33, '2025-02-03 14:55:18', '2025-02-03 14:32:05', 1393, 'America/Los_Angeles', '2012-11-15', '2017-03-01', '2021-08-15'),
(34, '2025-02-04 11:22:33', '2025-02-04 10:58:10', 1463, 'Asia/Tokyo', '2019-04-01', '2023-08-15', NULL),
(35, '2025-02-04 17:48:45', '2025-02-04 17:25:22', 1403, 'Europe/Paris', '2016-01-15', '2020-05-01', '2023-10-15'),
(36, '2025-02-05 08:15:22', '2025-02-05 07:52:45', 1350, 'America/Toronto', '2013-08-01', '2017-12-15', '2021-05-01'),
(37, '2025-02-05 14:42:18', '2025-02-05 14:18:30', 1428, 'Europe/Warsaw', '2017-11-15', '2021-03-01', '2024-08-15'),
(38, '2025-02-06 10:08:55', '2025-02-06 09:45:22', 1413, 'Asia/Singapore', '2020-05-01', '2024-01-15', NULL),
(39, '2025-02-06 16:35:33', '2025-02-06 16:12:10', 1403, 'America/Sao_Paulo', '2015-10-15', '2019-02-01', '2022-07-15'),
(40, '2025-02-07 09:02:45', '2025-02-07 08:38:30', 1455, 'Europe/Stockholm', '2018-02-01', '2022-06-15', '2024-12-01'),
(41, '2025-02-07 15:28:22', '2025-02-07 15:05:45', 1357, 'America/Chicago', '2014-07-15', '2018-11-01', '2022-04-15'),
(42, '2025-02-08 11:55:18', '2025-02-08 11:32:05', 1393, 'Europe/Madrid', '2016-12-01', '2020-04-15', '2023-09-01'),
(43, '2025-02-08 17:22:33', '2025-02-08 16:58:10', 1463, 'Asia/Kolkata', '2019-09-15', '2023-02-01', '2024-07-15'),
(44, '2025-02-09 08:48:45', '2025-02-09 08:25:22', 1403, 'Europe/Zurich', '2012-02-01', '2016-06-15', '2020-11-01'),
(45, '2025-02-09 14:15:22', '2025-02-09 13:52:45', 1350, 'America/Denver', '2017-05-15', '2021-09-01', '2024-02-15'),
(46, '2025-02-10 10:42:18', '2025-02-10 10:18:30', 1428, 'Europe/Rome', '2015-08-01', '2019-12-15', '2023-05-01'),
(47, '2025-02-10 16:08:55', '2025-02-10 15:45:22', 1413, 'Asia/Tel_Aviv', '2018-01-15', '2022-05-01', '2024-10-15'),
(48, '2025-02-11 09:35:33', '2025-02-11 09:12:10', 1403, 'America/Mexico_City', '2020-08-01', '2024-02-15', NULL),
(49, '2025-02-11 15:02:45', '2025-02-11 14:38:30', 1455, 'Europe/Amsterdam', '2014-03-15', '2018-07-01', '2022-12-15'),
(50, '2025-02-12 11:28:22', '2025-02-12 11:05:45', 1357, 'Pacific/Auckland', '2016-06-01', '2020-10-15', '2024-03-01');


-- ============================================================================
-- Table 5: industry_metrics
-- Industry-level statistics for comparison and categorization
-- Enables: JOINs, percentage calculations, CASE for industry tiers
-- ============================================================================
DROP TABLE IF EXISTS industry_metrics;

CREATE TABLE industry_metrics (
    industry_id         SERIAL PRIMARY KEY,
    industry_name       VARCHAR(100) NOT NULL,
    sector              VARCHAR(50),
    total_respondents   INTEGER NOT NULL,
    avg_salary_usd      NUMERIC(12, 2),
    salary_growth_pct   NUMERIC(5, 2),
    avg_team_size       NUMERIC(4, 1),
    avg_job_satisfaction NUMERIC(3, 1),
    ai_adoption_pct     NUMERIC(5, 2),
    remote_friendly_pct NUMERIC(5, 2),
    avg_hours_per_week  NUMERIC(4, 1),
    turnover_rate_pct   NUMERIC(5, 2)
);

INSERT INTO industry_metrics (industry_name, sector, total_respondents, avg_salary_usd, salary_growth_pct, avg_team_size, avg_job_satisfaction, ai_adoption_pct, remote_friendly_pct, avg_hours_per_week, turnover_rate_pct) VALUES
('Software Development', 'Technology', 18234, 115000.00, 5.20, 8.5, 7.2, 72.50, 52.30, 42.5, 15.20),
('Fintech', 'Finance', 4521, 135000.00, 6.80, 12.3, 7.0, 68.90, 45.80, 45.2, 18.50),
('Healthcare Technology', 'Healthcare', 2892, 108000.00, 7.50, 10.2, 7.4, 58.30, 38.60, 41.8, 12.30),
('E-commerce', 'Retail', 3156, 98000.00, 4.20, 9.8, 6.8, 65.20, 48.90, 43.5, 19.80),
('Gaming', 'Entertainment', 1823, 92000.00, 3.80, 15.6, 6.5, 71.80, 42.10, 48.2, 22.50),
('Cybersecurity', 'Technology', 1654, 128000.00, 8.20, 6.4, 7.1, 52.40, 44.30, 44.8, 14.20),
('Cloud Services', 'Technology', 2432, 125000.00, 7.10, 7.8, 7.3, 78.60, 58.20, 42.2, 13.80),
('AI/Machine Learning', 'Technology', 1987, 148000.00, 12.50, 5.2, 7.8, 92.30, 62.40, 43.5, 16.50),
('Consulting', 'Services', 1432, 105000.00, 3.50, 4.5, 6.4, 58.70, 35.80, 47.5, 24.30),
('Government/Public Sector', 'Government', 987, 85000.00, 2.10, 12.8, 6.2, 42.50, 28.90, 40.2, 8.50),
('Education Technology', 'Education', 756, 88000.00, 4.80, 8.2, 7.5, 68.40, 55.60, 41.5, 14.80),
('Telecommunications', 'Technology', 623, 102000.00, 2.80, 14.5, 6.6, 55.80, 32.40, 42.8, 11.20),
('Manufacturing', 'Industrial', 534, 95000.00, 3.20, 18.2, 6.3, 48.20, 22.50, 43.2, 10.50),
('Media/Entertainment', 'Entertainment', 478, 98000.00, 4.50, 11.3, 6.9, 72.30, 48.70, 44.5, 20.80),
('Nonprofit', 'Services', 312, 72000.00, 2.50, 6.8, 7.6, 45.60, 42.30, 39.8, 12.40);


-- ============================================================================
-- Table 6: experience_bands
-- Reference table for converting experience to bands/categories
-- Enables: CASE statement practice, JOIN for categorization
-- ============================================================================
DROP TABLE IF EXISTS experience_bands;

CREATE TABLE experience_bands (
    band_id         SERIAL PRIMARY KEY,
    band_name       VARCHAR(30) NOT NULL,
    min_years       INTEGER NOT NULL,
    max_years       INTEGER,
    salary_multiplier NUMERIC(4, 2),
    typical_title   VARCHAR(50)
);

INSERT INTO experience_bands (band_name, min_years, max_years, salary_multiplier, typical_title) VALUES
('Entry Level', 0, 2, 0.70, 'Junior Developer'),
('Early Career', 3, 5, 0.85, 'Developer'),
('Mid-Level', 6, 10, 1.00, 'Senior Developer'),
('Senior', 11, 15, 1.20, 'Staff Engineer'),
('Lead', 16, 20, 1.40, 'Principal Engineer'),
('Executive', 21, NULL, 1.60, 'Distinguished Engineer');
