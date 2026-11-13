
-- =========================================================
-- NovaMart Data Warehouse
-- Referential Integrity Validation
-- =========================================================


-- 1. Fact Sales Referential Integrity


-- Fact Sales to Dimension Customer

SELECT fs.customer_key
FROM fact_sales AS fs
LEFT JOIN dim_customer AS dc
    ON fs.customer_key = dc.customer_key
WHERE dc.customer_key IS NULL;


-- Fact Sales to Dimension Product

SELECT fs.product_key
FROM fact_sales AS fs
LEFT JOIN dim_product AS dp
    ON fs.product_key = dp.product_key
WHERE dp.product_key IS NULL;


-- Fact Sales to Dimension Employee

SELECT fs.employee_key
FROM fact_sales AS fs
LEFT JOIN dim_employee AS de
    ON fs.employee_key = de.employee_key
WHERE de.employee_key IS NULL;


-- Fact Sales to Dimension Store

SELECT fs.store_key
FROM fact_sales AS fs
LEFT JOIN dim_store AS ds
    ON fs.store_key = ds.store_key
WHERE ds.store_key IS NULL;


-- Fact Sales to Dimension Date

SELECT fs.date_key
FROM fact_sales AS fs
LEFT JOIN dim_date AS dd
    ON fs.date_key = dd.date_key
WHERE dd.date_key IS NULL;


-- 2. Fact Payment Referential Integrity


-- Fact Payment to Dimension Customer

SELECT fp.customer_key
FROM fact_payment AS fp
LEFT JOIN dim_customer AS dc
    ON fp.customer_key = dc.customer_key
WHERE dc.customer_key IS NULL;


-- Fact Payment to Dimension Employee

SELECT fp.employee_key
FROM fact_payment AS fp
LEFT JOIN dim_employee AS de
    ON fp.employee_key = de.employee_key
WHERE de.employee_key IS NULL;


-- Fact Payment to Dimension Store

SELECT fp.store_key
FROM fact_payment AS fp
LEFT JOIN dim_store AS ds
    ON fp.store_key = ds.store_key
WHERE ds.store_key IS NULL;


-- Fact Payment to Dimension Date

SELECT fp.date_key
FROM fact_payment AS fp
LEFT JOIN dim_date AS dd
    ON fp.date_key = dd.date_key
WHERE dd.date_key IS NULL;


-- 3. Fact Product Price History Referential Integrity


-- Fact Product Price History to Dimension Product

SELECT fph.product_key
FROM fact_product_pricehistory AS fph
LEFT JOIN dim_product AS dp
    ON fph.product_key = dp.product_key
WHERE dp.product_key IS NULL
  AND fph.product_key IS NOT NULL;


-- Fact Product Price History Starting Date to Dimension Date

SELECT fph.effective_from_date_key
FROM fact_product_pricehistory AS fph
LEFT JOIN dim_date AS dd
    ON fph.effective_from_date_key = dd.date_key
WHERE dd.date_key IS NULL;


-- Fact Product Price History Ending Date to Dimension Date

SELECT fph.effective_to_date_key
FROM fact_product_pricehistory AS fph
LEFT JOIN dim_date AS dd
    ON fph.effective_to_date_key = dd.date_key
WHERE dd.date_key IS NULL
  AND fph.effective_to_date_key IS NOT NULL;
