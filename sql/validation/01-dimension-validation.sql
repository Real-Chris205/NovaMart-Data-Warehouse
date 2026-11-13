-- =====================================================
-- NovaMart Data Warehouse
-- Dimension Validation
-- =====================================================

-- 1. Validate dimension table row counts

SELECT COUNT(*) AS total_customers
FROM dim_customer;

SELECT COUNT(*) AS total_products
FROM dim_product;

SELECT COUNT(*) AS total_employees
FROM dim_employee;

SELECT COUNT(*) AS total_stores
FROM dim_store;

SELECT COUNT(*) AS total_suppliers
FROM dim_supplier;

SELECT COUNT(*) AS total_dates
FROM dim_date;


-- 2. Validate customer source-to-dimension completeness

SELECT c.customer_id
FROM customers AS c
LEFT JOIN dim_customer AS dc
    ON c.customer_id = dc.customer_id
WHERE dc.customer_id IS NULL;


-- 3. Validate product source-to-dimension completeness

SELECT p.product_id
FROM products AS p
LEFT JOIN dim_product AS dp
    ON p.product_id = dp.product_id
WHERE dp.product_id IS NULL;


-- 4. Validate employee source-to-dimension completeness

SELECT e.employee_id
FROM employee AS e
LEFT JOIN dim_employee AS de
    ON e.employee_id = de.employee_id
WHERE de.employee_id IS NULL;


-- 5. Validate store source-to-dimension completeness

SELECT s.store_id
FROM store AS s
LEFT JOIN dim_store AS ds
    ON s.store_id = ds.store_id
WHERE ds.store_id IS NULL;


-- 6. Validate supplier source-to-dimension completeness

SELECT s.supplier_id
FROM supplier AS s
LEFT JOIN dim_supplier AS ds
    ON s.supplier_id = ds.supplier_id
WHERE ds.supplier_id IS NULL;


-- 7. Validate date dimension coverage for source dates

SELECT o.order_date
FROM orders AS o
LEFT JOIN dim_date AS dd
    ON o.order_date = dd.full_date
WHERE dd.date_key IS NULL;


SELECT p.payment_date
FROM payment AS p
LEFT JOIN dim_date AS dd
    ON p.payment_date = dd.full_date
WHERE dd.date_key IS NULL;


SELECT pph.effective_from
FROM product_price_history AS pph
LEFT JOIN dim_date AS dd
    ON pph.effective_from = dd.full_date
WHERE dd.date_key IS NULL;


-- Validate effective end dates against the date dimension
SELECT pph.effective_to
FROM product_price_history AS pph
LEFT JOIN dim_date AS dd
    ON pph.effective_to = dd.full_date
WHERE dd.date_key IS NULL
  AND pph.effective_to IS NOT NULL;
