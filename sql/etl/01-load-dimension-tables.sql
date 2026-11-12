
-- =========================================================
-- NovaMart Data Warehouse
-- Dimension Table Loading
-- =========================================================


-- 1. LOAD DIM_CUSTOMER

INSERT INTO dim_customer (
    customer_id,
    customer_name,
    email,
    phone,
    gender,
    city,
    country,
    registration_date,
    customer_segment,
    valid_from,
    valid_to,
    is_current
)
SELECT
    c.customer_id,
    c.customer_name,
    c.email,
    c.phone,
    c.gender,
    c.city,
    c.country,
    c.registration_date,
    cs.segment_name,
    TIMESTAMP '2025-06-01 00:00:00',
    NULL,
    'Y'
FROM customers AS c
LEFT JOIN customer_segment AS cs
    ON c.segment_id = cs.segment_id;


-- 2. LOAD DIM_SUPPLIER

INSERT INTO dim_supplier (
    supplier_id,
    supplier_name,
    email,
    phone,
    address,
    valid_from,
    valid_to,
    is_current
)
SELECT
    supplier_id,
    supplier_name,
    email,
    phone,
    address,
    TIMESTAMP '2025-06-01 00:00:00',
    NULL,
    'Y'
FROM supplier;


-- 3. LOAD DIM_EMPLOYEE

INSERT INTO dim_employee (
    employee_id,
    employee_name,
    job_title,
    department_name,
    email,
    phone,
    hire_date,
    valid_from,
    valid_to,
    is_current
)
SELECT
    e.employee_id,
    e.employee_name,
    j.job_title,
    d.department_name,
    e.email,
    e.phone,
    e.hire_date,
    TIMESTAMP '2025-06-01 00:00:00',
    NULL,
    'Y'
FROM employee AS e
LEFT JOIN job AS j
    ON e.job_id = j.job_id
LEFT JOIN department AS d
    ON e.department_id = d.department_id;


-- 4. LOAD DIM_STORE

INSERT INTO dim_store (
    store_id,
    store_name,
    city,
    state,
    country,
    region,
    valid_from,
    valid_to,
    is_current
)
SELECT
    store_id,
    store_name,
    city,
    state,
    country,
    region,
    TIMESTAMP '2025-06-01 00:00:00',
    NULL,
    'Y'
FROM store;


-- 5. LOAD DIM_PRODUCT

INSERT INTO dim_product (
    product_id,
    product_name,
    brand_name,
    category_name,
    supplier_key,
    unit_cost,
    unit_price,
    color,
    size,
    launch_date,
    discontinued_flag,
    valid_from,
    valid_to,
    is_current
)
SELECT
    p.product_id,
    p.product_name,
    b.brand_name,
    c.category_name,
    ds.supplier_key,
    p.unit_cost,
    p.unit_price,
    p.color,
    p.size,
    p.launch_date,
    p.discontinued_flag,
    TIMESTAMP '2025-06-01 00:00:00',
    NULL,
    'Y'
FROM products AS p
LEFT JOIN brand AS b
    ON p.brand_id = b.brand_id
LEFT JOIN category AS c
    ON p.category_id = c.category_id
LEFT JOIN dim_supplier AS ds
    ON p.supplier_id = ds.supplier_id;


-- 6. LOAD DIM_DATE

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
