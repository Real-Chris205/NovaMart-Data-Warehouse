
-- =========================================================
-- NovaMart Data Warehouse
-- Order Price History Investigation
-- DQ-003 to DQ-010: Order Item Price Discrepancies
-- =========================================================


-- 1. Identify order items whose charged prices differ
-- from the applicable historical product prices

SELECT
    oi.order_item_id,
    oi.order_id,
    oi.product_id,
    p.product_name,
    o.order_date,
    oi.unit_price AS order_item_price,
    pph.unit_price AS historical_price,
    oi.discount,
    o.order_status
FROM orders AS o
JOIN order_item AS oi
    ON oi.order_id = o.order_id
JOIN products AS p
    ON oi.product_id = p.product_id
JOIN product_price_history AS pph
    ON oi.product_id = pph.product_id
    AND o.order_date >= pph.effective_from
    AND (
        o.order_date <= pph.effective_to
        OR pph.effective_to IS NULL
    )
WHERE oi.unit_price <> pph.unit_price
ORDER BY oi.order_item_id;


-- 2. Inspect all eight affected order items

SELECT
    oi.order_item_id,
    oi.order_id,
    oi.product_id,
    p.product_name,
    oi.quantity,
    oi.unit_price,
    oi.discount,
    o.order_date,
    o.order_status
FROM order_item AS oi
JOIN orders AS o
    ON oi.order_id = o.order_id
JOIN products AS p
    ON oi.product_id = p.product_id
WHERE oi.order_item_id IN (27, 28, 30, 38, 42, 43, 46, 49)
ORDER BY oi.order_item_id;


-- 3. Inspect the corresponding historical prices

SELECT
    oi.order_item_id,
    oi.order_id,
    oi.product_id,
    p.product_name,
    o.order_date,
    pph.price_history_id,
    pph.unit_price AS historical_price,
    pph.effective_from,
    pph.effective_to,
    pph.effective_status
FROM order_item AS oi
JOIN orders AS o
    ON oi.order_id = o.order_id
JOIN products AS p
    ON oi.product_id = p.product_id
JOIN product_price_history AS pph
    ON oi.product_id = pph.product_id
    AND o.order_date >= pph.effective_from
    AND (
        o.order_date <= pph.effective_to
        OR pph.effective_to IS NULL
    )
WHERE oi.order_item_id IN (27, 28, 30, 38, 42, 43, 46, 49)
ORDER BY oi.order_item_id;


-- 4. Inspect payment evidence for the affected orders

SELECT
    o.order_id,
    o.order_date,
    o.order_status,
    p.payment_id,
    p.payment_amount,
    p.payment_date,
    p.payment_status
FROM orders AS o
LEFT JOIN payment AS p
    ON o.order_id = p.order_id
WHERE o.order_id IN (12, 13, 15, 23, 27, 28, 30, 7)
ORDER BY o.order_id;


-- 5. Inspect Order Item 46 and its discount details

SELECT
    oi.order_item_id,
    oi.order_id,
    oi.product_id,
    oi.quantity,
    oi.unit_price,
    oi.discount,
    (oi.quantity * oi.unit_price) AS gross_item_value,
    o.order_date,
    o.order_status
FROM order_item AS oi
JOIN orders AS o
    ON oi.order_id = o.order_id
WHERE oi.order_item_id = 46;


-- 6. Inspect the complete price history for Product 7

SELECT
    price_history_id,
    product_id,
    unit_price,
    effective_from,
    effective_to,
    effective_status
FROM product_price_history
WHERE product_id = 7
ORDER BY effective_from;


-- 7. Inspect Order 7 and its payment record

SELECT *
FROM orders
WHERE order_id = 7;

SELECT *
FROM payment
WHERE order_id = 7;
