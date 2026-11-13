
-- ============================================================
-- NovaMart Data Warehouse
-- Business Analytical Queries
-- ============================================================


-- 1. Monthly Revenue Analysis
-- Business Question:
-- How much revenue did NovaMart generate each month?

SELECT
    SUM(fs.sales_amount) AS total_revenue,
    dd.month_name,
    dd.month,
    dd.year
FROM fact_sales AS fs
LEFT JOIN dim_date AS dd
    ON fs.date_key = dd.date_key
GROUP BY
    dd.year,
    dd.month,
    dd.month_name
ORDER BY
    dd.year ASC,
    dd.month ASC;


-- 2. Product Revenue Analysis
-- Business Question:
-- Which products generate the highest sales revenue in NovaMart?

SELECT
    SUM(fs.sales_amount) AS total_revenue,
    dp.product_key,
    dp.product_name
FROM fact_sales AS fs
LEFT JOIN dim_product AS dp
    ON fs.product_key = dp.product_key
GROUP BY
    dp.product_key,
    dp.product_name
ORDER BY
    total_revenue DESC;


-- 3. Store Revenue Analysis
-- Business Question:
-- Which stores generate the highest sales revenue?

SELECT
    SUM(fs.sales_amount) AS total_revenue,
    ds.store_key,
    ds.store_name
FROM fact_sales AS fs
LEFT JOIN dim_store AS ds
    ON fs.store_key = ds.store_key
GROUP BY
    ds.store_key,
    ds.store_name
ORDER BY
    total_revenue DESC;


-- 4. Product Category Revenue Analysis
-- Business Question:
-- How much revenue does each product category generate?

SELECT
    SUM(fs.sales_amount) AS total_revenue,
    dp.category_name
FROM fact_sales AS fs
LEFT JOIN dim_product AS dp
    ON fs.product_key = dp.product_key
GROUP BY
    dp.category_name
ORDER BY
    total_revenue DESC;
