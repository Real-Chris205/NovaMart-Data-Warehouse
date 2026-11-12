-- ============================================================
-- NovaMart Data Warehouse
-- Foreign Key Integrity Audit
-- ============================================================

-- 1. Check customer segment references

SELECT c.customer_id, c.segment_id
FROM customers AS c
LEFT JOIN customer_segment AS cs
    ON cs.segment_id = c.segment_id
WHERE c.segment_id IS NOT NULL
  AND cs.segment_id IS NULL;


-- 2. Check employee job references

SELECT e.job_id, j.job_id
FROM employee AS e
LEFT JOIN job AS j
    ON e.job_id = j.job_id
WHERE e.job_id IS NOT NULL
  AND j.job_id IS NULL;


-- 3. Check employee department references

SELECT e.department_id, d.department_id
FROM employee AS e
LEFT JOIN department AS d
    ON e.department_id = d.department_id
WHERE e.department_id IS NOT NULL
  AND d.department_id IS NULL;


-- 4. Check product brand references

SELECT p.brand_id, b.brand_id
FROM products AS p
LEFT JOIN brand AS b
    ON p.brand_id = b.brand_id
WHERE p.brand_id IS NOT NULL
  AND b.brand_id IS NULL;


-- 5. Check product category references

SELECT p.category_id, c.category_id
FROM products AS p
LEFT JOIN category AS c
    ON p.category_id = c.category_id
WHERE p.category_id IS NOT NULL
  AND c.category_id IS NULL;


-- 6. Check product supplier references

SELECT p.supplier_id, s.supplier_id
FROM products AS p
LEFT JOIN supplier AS s
    ON p.supplier_id = s.supplier_id
WHERE p.supplier_id IS NOT NULL
  AND s.supplier_id IS NULL;


-- 7. Check order customer references

SELECT o.customer_id, c.customer_id
FROM orders AS o
LEFT JOIN customers AS c
    ON o.customer_id = c.customer_id
WHERE o.customer_id IS NOT NULL
  AND c.customer_id IS NULL;


-- 8. Check order employee references

SELECT o.employee_id, e.employee_id
FROM orders AS o
LEFT JOIN employee AS e
    ON o.employee_id = e.employee_id
WHERE o.employee_id IS NOT NULL
  AND e.employee_id IS NULL;


-- 9. Check order store references

SELECT o.store_id, s.store_id
FROM orders AS o
LEFT JOIN store AS s
    ON o.store_id = s.store_id
WHERE o.store_id IS NOT NULL
  AND s.store_id IS NULL;


-- 10. Check order item order references

SELECT oi.order_id, o.order_id
FROM order_item AS oi
LEFT JOIN orders AS o
    ON oi.order_id = o.order_id
WHERE oi.order_id IS NOT NULL
  AND o.order_id IS NULL;


-- 11. Check order item product references

SELECT oi.product_id, p.product_id
FROM order_item AS oi
LEFT JOIN products AS p
    ON oi.product_id = p.product_id
WHERE oi.product_id IS NOT NULL
  AND p.product_id IS NULL;


-- 12. Check payment order references

SELECT p.order_id, o.order_id
FROM payment AS p
LEFT JOIN orders AS o
    ON p.order_id = o.order_id
WHERE p.order_id IS NOT NULL
  AND o.order_id IS NULL;


-- 13. Check product price history references

SELECT pph.product_id, p.product_id
FROM product_price_history AS pph
LEFT JOIN products AS p
    ON pph.product_id = p.product_id
WHERE pph.product_id IS NOT NULL
  AND p.product_id IS NULL;
