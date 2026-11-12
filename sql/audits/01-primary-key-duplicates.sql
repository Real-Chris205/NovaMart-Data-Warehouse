
-- ============================================================
-- NovaMart Data Warehouse
-- Primary Key / Duplicate ID Audit
-- ============================================================

-- 1. Check for duplicate supplier IDs

SELECT
    supplier_id,
    COUNT(*) AS total
FROM supplier
GROUP BY supplier_id
HAVING COUNT(*) > 1;


-- 2. Check for duplicate employee IDs

SELECT
    COUNT(*) AS total,
    employee_id
FROM employee
GROUP BY employee_id
HAVING COUNT(*) > 1;


-- 3. Check for duplicate store IDs

SELECT
    COUNT(*),
    store_id
FROM store
GROUP BY store_id
HAVING COUNT(*) > 1;


-- 4. Check for duplicate product IDs

SELECT
    COUNT(*),
    product_id
FROM products
GROUP BY product_id
HAVING COUNT(*) > 1;


-- 5. Check for duplicate product price-history IDs

SELECT
    price_history_id,
    COUNT(*) AS record_count
FROM product_price_history
GROUP BY price_history_id
HAVING COUNT(*) > 1;
