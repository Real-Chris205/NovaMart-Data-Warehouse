
-- =========================================================
-- NovaMart Data Warehouse
-- Fact Payment Validation
-- =========================================================


-- 1. Confirm the row count

SELECT COUNT(*)
FROM fact_payment;


-- 2. Validate payment amount

SELECT payment_amount
FROM fact_payment
WHERE payment_amount <= 0;


-- 3. Validate payment method

SELECT payment_method
FROM fact_payment
WHERE payment_method IS NULL;


-- 4. Validate payment status

SELECT payment_status
FROM fact_payment
WHERE payment_status IS NULL;


-- 5. Validate dimension keys

SELECT
    COUNT(*) FILTER (WHERE date_key IS NULL) AS missing_date_key,
    COUNT(*) FILTER (WHERE customer_key IS NULL) AS missing_customer,
    COUNT(*) FILTER (WHERE employee_key IS NULL) AS missing_employee,
    COUNT(*) FILTER (WHERE store_key IS NULL) AS missing_store
FROM fact_payment;


-- 6. Check for duplicate payment records

SELECT COUNT(*), payment_id
FROM fact_payment
GROUP BY payment_id
HAVING COUNT(*) > 1;


-- 7. Validate payment ID completeness

SELECT *
FROM fact_payment
WHERE payment_id IS NULL;


-- 8. Validate payment amount consistency with source

SELECT
    p.payment_id,
    p.payment_amount,
    fp.payment_amount
FROM payment AS p
LEFT JOIN fact_payment AS fp
    ON p.payment_id = fp.payment_id
WHERE p.payment_amount IS DISTINCT FROM fp.payment_amount;


-- 9. Validate payment method consistency with source

SELECT
    p.payment_id,
    p.payment_method,
    fp.payment_method
FROM payment AS p
LEFT JOIN fact_payment AS fp
    ON p.payment_id = fp.payment_id
WHERE p.payment_method IS DISTINCT FROM fp.payment_method;


-- 10. Validate payment status consistency with source

SELECT
    p.payment_id,
    p.payment_status,
    fp.payment_status
FROM payment AS p
LEFT JOIN fact_payment AS fp
    ON p.payment_id = fp.payment_id
WHERE p.payment_status IS DISTINCT FROM fp.payment_status;


-- 11. Validate payment date consistency

SELECT
    p.payment_id,
    p.payment_date,
    fp.date_key
FROM payment AS p
LEFT JOIN fact_payment AS fp
    ON p.payment_id = fp.payment_id
LEFT JOIN dim_date AS dd
    ON dd.date_key = fp.date_key
WHERE p.payment_date IS DISTINCT FROM dd.full_date;


-- 12. Check source-to-fact completeness

SELECT p.payment_id
FROM payment AS p
LEFT JOIN fact_payment AS fp
    ON p.payment_id = fp.payment_id
WHERE fp.payment_id IS NULL;


-- 13. Check fact-to-source completeness

SELECT fp.payment_id
FROM fact_payment AS fp
LEFT JOIN payment AS p
    ON fp.payment_id = p.payment_id
WHERE p.payment_id IS NULL;
