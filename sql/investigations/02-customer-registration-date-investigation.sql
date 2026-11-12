
-- =========================================================
-- NovaMart Data Warehouse
-- Customer Registration Date Investigation
-- DQ-002: Orders Before Customer Registration
-- =========================================================


-- 1. Identify all orders placed before customer registration

SELECT
    o.order_id,
    o.customer_id,
    c.registration_date,
    o.order_date,
    o.order_status
FROM orders AS o
JOIN customers AS c
    ON o.customer_id = c.customer_id
WHERE o.order_date < c.registration_date
ORDER BY o.order_id;


-- 2. Inspect the affected customer records

SELECT
    customer_id,
    customer_name,
    registration_date
FROM customers
WHERE customer_id IN (10, 4, 15, 16)
ORDER BY customer_id;


-- 3. Inspect all orders belonging to the affected customers

SELECT
    o.order_id,
    o.customer_id,
    o.order_date,
    o.order_status
FROM orders AS o
WHERE o.customer_id IN (10, 4, 15, 16)
ORDER BY o.customer_id, o.order_date;


-- 4. Inspect payment records for all five affected orders

SELECT
    o.order_id,
    o.customer_id,
    o.order_date,
    p.payment_id,
    p.payment_amount,
    p.payment_date,
    p.payment_status
FROM orders AS o
JOIN payment AS p
    ON o.order_id = p.order_id
WHERE o.order_id IN (3, 10, 20, 27, 30)
ORDER BY o.order_id;


-- 5. Inspect the order items belonging to Order 3

SELECT *
FROM order_item
WHERE order_id = 3;


-- 6. Inspect the complete order and payment records
-- for Customer 16

SELECT
    o.order_id,
    o.customer_id,
    o.order_date,
    o.order_status,
    p.payment_id,
    p.payment_amount,
    p.payment_date,
    p.payment_status
FROM orders AS o
JOIN payment AS p
    ON o.order_id = p.order_id
WHERE o.customer_id = 16
ORDER BY o.order_id;
