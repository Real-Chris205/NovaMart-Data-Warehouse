-- =====================================================
-- NovaMart Data Warehouse
-- Fact Sales Validation
-- =====================================================


-- 1. Verify fact_sales row count

SELECT COUNT(*) AS total_fact_sales
FROM fact_sales;


-- 2. Check for invalid sales amounts

SELECT order_item_id, sales_amount
FROM fact_sales
WHERE sales_amount <= 0;


-- 3. Check for missing dimension keys

SELECT
    COUNT(*) FILTER (WHERE date_key IS NULL) AS missing_date_key,
    COUNT(*) FILTER (WHERE customer_key IS NULL) AS missing_customer,
    COUNT(*) FILTER (WHERE product_key IS NULL) AS missing_product,
    COUNT(*) FILTER (WHERE employee_key IS NULL) AS missing_employee,
    COUNT(*) FILTER (WHERE store_key IS NULL) AS missing_store
FROM fact_sales;


-- 4. Check for duplicate order items
-- Fact grain: one row per order item

SELECT
    COUNT(*) AS record_count,
    order_item_id
FROM fact_sales
GROUP BY order_item_id
HAVING COUNT(*) > 1;


-- 5. Validate the sales amount calculation

SELECT order_item_id, sales_amount
FROM fact_sales
WHERE sales_amount <>
      unit_price * quantity - COALESCE(discount_amount, 0);


-- 6. Verify total revenue

SELECT SUM(sales_amount) AS total_revenue
FROM fact_sales;


-- 7. Verify average sales amount per order item

SELECT AVG(sales_amount) AS average_sales_amount
FROM fact_sales;


-- 8. Check for negative discounts

SELECT discount_amount
FROM fact_sales
WHERE discount_amount < 0;


-- 9. Check whether discounts exceed the gross item value

SELECT discount_amount
FROM fact_sales
WHERE discount_amount >= unit_price * quantity;


-- 10. Validate quantity

SELECT quantity
FROM fact_sales
WHERE quantity <= 0;


-- 11. Validate unit price

SELECT unit_price
FROM fact_sales
WHERE unit_price <= 0;


-- 12. Validate the date dimension relationship

SELECT
    o.order_date,
    dd.full_date,
    dd.date_key
FROM orders AS o
LEFT JOIN fact_sales AS fs
    ON o.order_id = fs.order_id
LEFT JOIN dim_date AS dd
    ON fs.date_key = dd.date_key
WHERE o.order_date <> dd.full_date;


-- 13. Validate customer relationship accuracy

SELECT
    fs.order_id,
    fs.customer_key,
    o.customer_id
FROM fact_sales AS fs
LEFT JOIN orders AS o
    ON fs.order_id = o.order_id
LEFT JOIN dim_customer AS dc
    ON fs.customer_key = dc.customer_key
WHERE dc.customer_id <> o.customer_id;


-- 14. Validate product relationship accuracy

SELECT
    fs.order_id,
    fs.product_key,
    oi.product_id,
    dp.product_id
FROM fact_sales AS fs
LEFT JOIN order_item AS oi
    ON fs.order_item_id = oi.order_item_id
LEFT JOIN dim_product AS dp
    ON fs.product_key = dp.product_key
WHERE dp.product_id <> oi.product_id;


-- 15. Validate employee relationship accuracy

SELECT
    fs.order_id,
    o.employee_id,
    de.employee_id
FROM fact_sales AS fs
LEFT JOIN orders AS o
    ON fs.order_id = o.order_id
LEFT JOIN dim_employee AS de
    ON fs.employee_key = de.employee_key
WHERE de.employee_id <> o.employee_id;


-- 16. Validate store relationship accuracy

SELECT
    fs.order_id,
    o.store_id,
    ds.store_id
FROM fact_sales AS fs
LEFT JOIN orders AS o
    ON fs.order_id = o.order_id
LEFT JOIN dim_store AS ds
    ON fs.store_key = ds.store_key
WHERE ds.store_id <> o.store_id;


-- 17. Check source-to-fact completeness
-- Every source order item should appear in fact_sales

SELECT
    oi.order_item_id
FROM order_item AS oi
LEFT JOIN fact_sales AS fs
    ON fs.order_item_id = oi.order_item_id
WHERE fs.order_item_id IS NULL;


-- 18. Check fact-to-source completeness
-- Every fact record should have a matching source order item

SELECT
    fs.order_item_id
FROM fact_sales AS fs
LEFT JOIN order_item AS oi
    ON fs.order_item_id = oi.order_item_id
WHERE oi.order_item_id IS NULL;


-- 19. Fact sales referential integrity:
-- Customer dimension

SELECT fs.customer_key
FROM fact_sales AS fs
LEFT JOIN dim_customer AS dc
    ON fs.customer_key = dc.customer_key
WHERE dc.customer_key IS NULL;


-- 20. Product dimension

SELECT fs.product_key
FROM fact_sales AS fs
LEFT JOIN dim_product AS dp
    ON fs.product_key = dp.product_key
WHERE dp.product_key IS NULL;


-- 21. Employee dimension

SELECT fs.employee_key
FROM fact_sales AS fs
LEFT JOIN dim_employee AS de
    ON fs.employee_key = de.employee_key
WHERE de.employee_key IS NULL;


-- 22. Store dimension

SELECT fs.store_key
FROM fact_sales AS fs
LEFT JOIN dim_store AS ds
    ON fs.store_key = ds.store_key
WHERE ds.store_key IS NULL;


-- 23. Date dimension

SELECT fs.date_key
FROM fact_sales AS fs
LEFT JOIN dim_date AS dd
    ON fs.date_key = dd.date_key
WHERE dd.date_key IS NULL;
