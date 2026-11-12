
-- =========================================================
-- NovaMart Data Warehouse
-- Product Launch Date Investigation
-- =========================================================


-- 1. Identify orders placed before product launch dates

SELECT
    oi.order_item_id,
    oi.order_id,
    p.product_id,
    p.product_name,
    o.order_date,
    p.launch_date
FROM products AS p
JOIN order_item AS oi
    ON p.product_id = oi.product_id
JOIN orders AS o
    ON oi.order_id = o.order_id
WHERE o.order_date < p.launch_date;


-- 2. Inspect the affected order item (Order Item 24)

SELECT
    oi.order_item_id,
    oi.order_id,
    oi.product_id,
    o.order_date,
    p.product_name,
    p.launch_date
FROM order_item oi
JOIN orders o
    ON oi.order_id = o.order_id
JOIN products p
    ON oi.product_id = p.product_id
WHERE oi.order_item_id = 24;


-- 3. Inspect Order 10 and its payment evidence

SELECT
    o.order_id,
    o.order_date,
    o.order_status,
    oi.order_item_id,
    oi.product_id,
    p.product_name,
    p.launch_date,
    pay.payment_id,
    pay.payment_amount,
    pay.payment_date,
    pay.payment_status
FROM orders o
JOIN order_item oi
    ON o.order_id = oi.order_id
JOIN products p
    ON oi.product_id = p.product_id
LEFT JOIN payment pay
    ON o.order_id = pay.order_id
WHERE oi.order_item_id = 24;


-- 4. Inspect Product 18's complete product record
-- and Order Item 24's pricing and quantity

SELECT
    p.product_id,
    p.product_name,
    p.brand_id,
    p.category_id,
    p.supplier_id,
    p.unit_cost,
    p.unit_price,
    p.launch_date,
    p.discontinued_flag,
    oi.order_item_id,
    oi.order_id,
    oi.quantity,
    oi.unit_price AS charged_unit_price,
    oi.discount
FROM products p
JOIN order_item oi
    ON p.product_id = oi.product_id
WHERE oi.order_item_id = 24;


-- 5. Inspect all items belonging to Order 10

SELECT
    oi.order_item_id,
    oi.order_id,
    oi.product_id,
    p.product_name,
    oi.quantity,
    oi.unit_price,
    oi.discount,
    (oi.quantity * oi.unit_price - COALESCE(oi.discount, 0)) AS item_total
FROM order_item oi
JOIN products p
    ON oi.product_id = p.product_id
WHERE oi.order_id = 10
ORDER BY oi.order_item_id;


-- 6. Inspect Product 18's complete price history

SELECT
    p.product_id,
    p.product_name,
    p.launch_date,
    pph.price_history_id,
    pph.unit_price,
    pph.effective_from,
    pph.effective_to,
    pph.effective_status
FROM products p
LEFT JOIN product_price_history pph
    ON p.product_id = pph.product_id
WHERE p.product_id = 18
ORDER BY pph.effective_from;
