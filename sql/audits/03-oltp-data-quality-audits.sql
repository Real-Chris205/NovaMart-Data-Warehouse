-- =========================================================
-- NovaMart Data Warehouse
-- OLTP Data Quality Audits
-- =========================================================


-- 1. Check for missing required customer information

SELECT
    customer_id,
    customer_name,
    city,
    country,
    registration_date
FROM customers
WHERE customer_name IS NULL
   OR city IS NULL
   OR country IS NULL
   OR registration_date IS NULL;


-- 2. Check for duplicate customer email addresses

SELECT
    email,
    COUNT(*) AS total
FROM customers
WHERE email IS NOT NULL
GROUP BY email
HAVING COUNT(*) > 1;


-- 3. Check for duplicate customer phone numbers

SELECT
    phone,
    COUNT(*) AS total
FROM customers
WHERE phone IS NOT NULL
GROUP BY phone
HAVING COUNT(*) > 1;


-- 4. Identify customers without an assigned segment

SELECT
    customer_id
FROM customers
WHERE segment_id IS NULL;


-- 5. Check for customer registration dates after the audit date

SELECT
    customer_id,
    registration_date
FROM customers
WHERE registration_date > DATE '2026-09-10';


-- 6. Inspect the distinct gender values

SELECT DISTINCT
    gender
FROM customers;


-- 7. Check for unexpected gender values

SELECT
    customer_id,
    gender
FROM customers
WHERE gender IS NOT NULL
  AND gender NOT IN ('Male', 'Female');


-- 8. Check for missing required product information

SELECT
    product_id
FROM products
WHERE product_name IS NULL
   OR brand_id IS NULL
   OR category_id IS NULL
   OR supplier_id IS NULL
   OR unit_cost IS NULL
   OR unit_price IS NULL
   OR launch_date IS NULL
   OR discontinued_flag IS NULL;


-- 9. Check for products selling below their unit cost

SELECT
    product_id,
    product_name,
    unit_cost,
    unit_price
FROM products
WHERE unit_price < unit_cost;


-- 10. Check for product launch dates after the audit date

SELECT
    product_id,
    product_name,
    launch_date
FROM products
WHERE launch_date > DATE '2026-09-10';
