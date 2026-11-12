-- =====================================================
-- NovaMart Data Warehouse
-- Date Dimension Generation
-- =====================================================

-- Populate the date dimension with calendar dates
-- covering January 1, 2025 to December 31, 2026.

INSERT INTO dim_date (
    date_key,
    full_date,
    day,
    month,
    month_name,
    quarter,
    quarter_name,
    year,
    day_name,
    day_of_week,
    week_of_year,
    is_weekend,
    year_month
)
SELECT
    TO_CHAR(full_date, 'YYYYMMDD')::int AS date_key,
    full_date::date AS full_date,
    EXTRACT(DAY FROM full_date) AS day,
    EXTRACT(MONTH FROM full_date) AS month,
    TO_CHAR(full_date, 'FMMonth') AS month_name,
    CEIL(EXTRACT(MONTH FROM full_date) / 3.0) AS quarter,
    'Q' || CEIL(EXTRACT(MONTH FROM full_date) / 3.0)::text AS quarter_name,
    EXTRACT(YEAR FROM full_date) AS year,
    TO_CHAR(full_date, 'FMDay') AS day_name,
    EXTRACT(ISODOW FROM full_date) AS day_of_week,
    EXTRACT(WEEK FROM full_date) AS week_of_year,
    CASE
        WHEN EXTRACT(ISODOW FROM full_date) BETWEEN 1 AND 5 THEN 'N'
        WHEN EXTRACT(ISODOW FROM full_date) BETWEEN 6 AND 7 THEN 'Y'
        ELSE 'N'
    END AS is_weekend,
    TO_CHAR(full_date, 'YYYY-MM') AS year_month
FROM generate_series(
    DATE '2025-01-01',
    DATE '2026-12-31',
    INTERVAL '1 day'
) AS dates(full_date);

-- Verify the row count and date range
SELECT
    COUNT(*) AS total,
    MAX(full_date) AS latest_date,
    MIN(full_date) AS earliest_date
FROM dim_date;
