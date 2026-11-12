
-- ============================================================
-- NovaMart Data Warehouse
-- Order and Payment Audits
-- ============================================================


-- 1. Check for negative discounts

SELECT
    order_item_id,
    discount
FROM order_item
WHERE discount < 0;


-- 2. Compare order totals against completed payment totals

WITH cte_order AS
(
    SELECT
        order_id,
        SUM(quantity * unit_price - COALESCE(discount, 0)) AS order_total
    FROM order_item
    GROUP BY order_id
),
cte_payment AS
(
    SELECT
        order_id,
        SUM(payment_amount) AS payment_total
    FROM payment
    WHERE payment_status = 'Completed'
    GROUP BY order_id
)
SELECT
    co.order_id,
    co.order_total,
    cp.payment_total
FROM cte_order AS co
LEFT JOIN cte_payment AS cp
    ON co.order_id = cp.order_id
WHERE cp.payment_total <> co.order_total
   OR cp.payment_total IS NULL;


-- 3. Check pending orders with completed payments

SELECT
    o.order_id,
    o.order_status,
    p.payment_status
FROM orders AS o
LEFT JOIN payment AS p
    ON o.order_id = p.order_id
WHERE o.order_status = 'Pending'
  AND p.payment_status = 'Completed';


-- 4. Inspect payment records for Orders 7 and 13

SELECT
    order_id,
    payment_id,
    payment_amount,
    payment_status,
    payment_date
FROM payment
WHERE order_id IN (7, 13)
ORDER BY order_id, payment_id;


-- 5. Check cancelled orders with completed payments

SELECT
    o.order_id,
    o.order_status,
    p.payment_status
FROM orders AS o
LEFT JOIN payment AS p
    ON o.order_id = p.order_id
WHERE o.order_status = 'Cancelled'
  AND p.payment_status = 'Completed';


-- 6. Check for missing order and payment statuses

SELECT order_id
FROM orders
WHERE order_status IS NULL;

SELECT order_id
FROM payment
WHERE payment_status IS NULL;


-- 7. Review available payment statuses

SELECT DISTINCT payment_status
FROM payment;


-- 8. Check whether payment dates precede order dates

SELECT
    o.order_id,
    o.order_date,
    p.payment_date
FROM orders AS o
LEFT JOIN payment AS p
    ON o.order_id = p.order_id
WHERE o.order_date > p.payment_date;


-- 9. Check for non-positive payment amounts

SELECT
    order_id,
    payment_amount
FROM payment
WHERE payment_amount <= 0;


-- 10. Check for multiple completed payments per order

SELECT
    order_id,
    COUNT(*) AS total
FROM payment
WHERE payment_status = 'Completed'
GROUP BY order_id
HAVING COUNT(*) > 1;


-- 11. Check for non-positive order quantities

SELECT
    order_item_id,
    quantity
FROM order_item
WHERE quantity <= 0;


-- 12. Check for non-positive order-item prices

SELECT
    order_id,
    unit_price
FROM order_item
WHERE unit_price <= 0;


-- 13. Check for missing order-item information

SELECT
    order_id
FROM order_item
WHERE order_id IS NULL
   OR product_id IS NULL
   OR quantity IS NULL
   OR unit_price IS NULL;


-- 14. Review available payment methods

SELECT DISTINCT payment_method
FROM payment;


-- 15. Check for invalid payment methods

SELECT
    payment_id,
    payment_method
FROM payment
WHERE payment_method NOT IN ('Bank Transfer', 'Cash', 'Card');


-- 16. Check for missing payment methods

SELECT
    payment_id,
    payment_method
FROM payment
WHERE payment_method IS NULL;


-- 17. Check completed payments with non-positive amounts

SELECT
    order_id,
    payment_id,
    payment_amount,
    payment_method
FROM payment
WHERE payment_status = 'Completed'
  AND payment_amount <= 0;


-- 18. Check for missing payment dates

SELECT
    payment_id,
    order_id,
    payment_date
FROM payment
WHERE payment_date IS NULL;


-- 19. Check for missing payment amounts

SELECT
    payment_id,
    order_id,
    payment_amount
FROM payment
WHERE payment_amount IS NULL;


-- 20. Check for missing payment statuses

SELECT
    payment_id,
    order_id,
    payment_status
FROM payment
WHERE payment_status IS NULL;


-- 21. Summarise payment methods and statuses

SELECT
    payment_method,
    payment_status,
    COUNT(*) AS total
FROM payment
GROUP BY payment_method, payment_status;
