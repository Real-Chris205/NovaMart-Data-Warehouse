
-- =========================================================
-- NovaMart Data Warehouse
-- Warehouse-Wide Validation
-- =========================================================


-- 1. Surrogate Key Integrity

-- Customer

SELECT COUNT(*), customer_key
FROM dim_customer
GROUP BY customer_key
HAVING COUNT(*) > 1;


-- Product

SELECT COUNT(*), product_key
FROM dim_product
GROUP BY product_key
HAVING COUNT(*) > 1;


-- Employee

SELECT COUNT(*), employee_key
FROM dim_employee
GROUP BY employee_key
HAVING COUNT(*) > 1;


-- Store

SELECT COUNT(*), store_key
FROM dim_store
GROUP BY store_key
HAVING COUNT(*) > 1;


-- Date

SELECT COUNT(*), date_key
FROM dim_date
GROUP BY date_key
HAVING COUNT(*) > 1;


-- 2. SCD Type 2: Multiple Current Versions

-- Customer

SELECT COUNT(*), customer_id
FROM dim_customer
WHERE is_current = 'Y'
GROUP BY customer_id
HAVING COUNT(*) > 1;


-- Product

SELECT COUNT(*), product_id
FROM dim_product
WHERE is_current = 'Y'
GROUP BY product_id
HAVING COUNT(*) > 1;


-- Employee

SELECT COUNT(*), employee_id
FROM dim_employee
WHERE is_current = 'Y'
GROUP BY employee_id
HAVING COUNT(*) > 1;


-- Store

SELECT COUNT(*), store_id
FROM dim_store
WHERE is_current = 'Y'
GROUP BY store_id
HAVING COUNT(*) > 1;


-- Supplier

SELECT COUNT(*), supplier_id
FROM dim_supplier
WHERE is_current = 'Y'
GROUP BY supplier_id
HAVING COUNT(*) > 1;


-- 3. SCD Type 2: Validity Consistency

-- Customer

SELECT COUNT(*), customer_id
FROM dim_customer
WHERE valid_to IS NULL
AND is_current = 'N'
OR valid_to IS NOT NULL
AND is_current = 'Y'
GROUP BY customer_id;


-- Product

SELECT COUNT(*), product_id
FROM dim_product
WHERE (valid_to IS NULL AND is_current = 'N')
   OR (valid_to IS NOT NULL AND is_current = 'Y')
GROUP BY product_id;


-- Employee

SELECT COUNT(*), employee_id
FROM dim_employee
WHERE (valid_to IS NULL AND is_current = 'N')
   OR (valid_to IS NOT NULL AND is_current = 'Y')
GROUP BY employee_id;


-- Store

SELECT COUNT(*), store_id
FROM dim_store
WHERE (valid_to IS NULL AND is_current = 'N')
   OR (valid_to IS NOT NULL AND is_current = 'Y')
GROUP BY store_id;


-- Supplier

SELECT COUNT(*), supplier_id
FROM dim_supplier
WHERE (valid_to IS NULL AND is_current = 'N')
   OR (valid_to IS NOT NULL AND is_current = 'Y')
GROUP BY supplier_id;


-- 4. Validity Period Integrity

-- Customer

SELECT customer_key
FROM dim_customer
WHERE valid_to IS NOT NULL
AND valid_to <= valid_from;


-- Product

SELECT product_key
FROM dim_product
WHERE valid_to IS NOT NULL
AND valid_to <= valid_from;


-- Employee

SELECT employee_key
FROM dim_employee
WHERE valid_to IS NOT NULL
AND valid_to <= valid_from;


-- Store

SELECT store_key
FROM dim_store
WHERE valid_to IS NOT NULL
AND valid_to <= valid_from;


-- Supplier

SELECT supplier_key
FROM dim_supplier
WHERE valid_to IS NOT NULL
AND valid_to <= valid_from;


-- 5. SCD Type 2 Temporal Overlap Validation

-- Customer

SELECT a.customer_id, b.customer_id
FROM dim_customer AS a
JOIN dim_customer AS b
    ON a.customer_id = b.customer_id
WHERE a.customer_key < b.customer_key
  AND (
      a.valid_from < b.valid_to
      OR b.valid_to IS NULL
  )
  AND (
      b.valid_from < a.valid_to
      OR a.valid_to IS NULL
  );


-- Product

SELECT a.product_id, b.product_id
FROM dim_product AS a
JOIN dim_product AS b
    ON a.product_id = b.product_id
WHERE a.product_key < b.product_key
  AND (
      a.valid_from < b.valid_to
      OR b.valid_to IS NULL
  )
  AND (
      b.valid_from < a.valid_to
      OR a.valid_to IS NULL
  );


-- Employee

SELECT a.employee_id, b.employee_id
FROM dim_employee AS a
JOIN dim_employee AS b
    ON a.employee_id = b.employee_id
WHERE a.employee_key < b.employee_key
  AND (
      a.valid_from < b.valid_to
      OR b.valid_to IS NULL
  )
  AND (
      b.valid_from < a.valid_to
      OR a.valid_to IS NULL
  );


-- Store

SELECT a.store_id, b.store_id
FROM dim_store AS a
JOIN dim_store AS b
    ON a.store_id = b.store_id
WHERE a.store_key < b.store_key
  AND (
      a.valid_from < b.valid_to
      OR b.valid_to IS NULL
  )
  AND (
      b.valid_from < a.valid_to
      OR a.valid_to IS NULL
  );


-- Supplier

SELECT a.supplier_id, b.supplier_id
FROM dim_supplier AS a
JOIN dim_supplier AS b
    ON a.supplier_id = b.supplier_id
WHERE a.supplier_key < b.supplier_key
  AND (
      a.valid_from < b.valid_to
      OR b.valid_to IS NULL
  )
  AND (
      b.valid_from < a.valid_to
      OR a.valid_to IS NULL
  );


-- 6. Dimension Business-Key Integrity
-- Duplicate (business key, valid_from) combinations

-- Customer

SELECT COUNT(*), customer_id, valid_from
FROM dim_customer
GROUP BY customer_id, valid_from
HAVING COUNT(*) > 1;


-- Product

SELECT COUNT(*), product_id, valid_from
FROM dim_product
GROUP BY product_id, valid_from
HAVING COUNT(*) > 1;


-- Employee

SELECT COUNT(*), employee_id, valid_from
FROM dim_employee
GROUP BY employee_id, valid_from
HAVING COUNT(*) > 1;


-- Store

SELECT COUNT(*), store_id, valid_from
FROM dim_store
GROUP BY store_id, valid_from
HAVING COUNT(*) > 1;


-- Supplier

SELECT COUNT(*), supplier_id, valid_from
FROM dim_supplier
GROUP BY supplier_id, valid_from
HAVING COUNT(*) > 1;


-- 7. Source-to-Dimension and Dimension-to-Source Coverage

-- Customer: Source to Dimension

SELECT c.customer_id
FROM customers AS c
LEFT JOIN dim_customer AS dc
    ON c.customer_id = dc.customer_id
WHERE dc.customer_id IS NULL;


-- Customer: Dimension to Source

SELECT dc.customer_id
FROM dim_customer AS dc
LEFT JOIN customers AS c
    ON c.customer_id = dc.customer_id
WHERE c.customer_id IS NULL;


-- Product: Source to Dimension

SELECT p.product_id
FROM products AS p
LEFT JOIN dim_product AS dp
    ON p.product_id = dp.product_id
WHERE dp.product_id IS NULL;


-- Product: Dimension to Source

SELECT dp.product_id
FROM dim_product AS dp
LEFT JOIN products AS p
    ON dp.product_id = p.product_id
WHERE p.product_id IS NULL;


-- Employee: Source to Dimension

SELECT e.employee_id
FROM employee AS e
LEFT JOIN dim_employee AS de
    ON e.employee_id = de.employee_id
WHERE de.employee_id IS NULL;


-- Employee: Dimension to Source

SELECT de.employee_id
FROM dim_employee AS de
LEFT JOIN employee AS e
    ON de.employee_id = e.employee_id
WHERE e.employee_id IS NULL;


-- Store: Source to Dimension

SELECT s.store_id
FROM store AS s
LEFT JOIN dim_store AS ds
    ON s.store_id = ds.store_id
WHERE ds.store_id IS NULL;


-- Store: Dimension to Source

SELECT ds.store_id
FROM dim_store AS ds
LEFT JOIN store AS s
    ON ds.store_id = s.store_id
WHERE s.store_id IS NULL;


-- Supplier: Source to Dimension

SELECT s.supplier_id
FROM supplier AS s
LEFT JOIN dim_supplier AS ds
    ON s.supplier_id = ds.supplier_id
WHERE ds.supplier_id IS NULL;


-- Supplier: Dimension to Source

SELECT ds.supplier_id
FROM dim_supplier AS ds
LEFT JOIN supplier AS s
    ON ds.supplier_id = s.supplier_id
WHERE s.supplier_id IS NULL;


-- 8. Date Dimension Coverage

-- Orders

SELECT o.order_date
FROM orders AS o
LEFT JOIN dim_date AS dd
    ON o.order_date = dd.full_date
WHERE dd.date_key IS NULL;


-- Payments

SELECT p.payment_date
FROM payment AS p
LEFT JOIN dim_date AS dd
    ON p.payment_date = dd.full_date
WHERE dd.date_key IS NULL;


-- Product Price History: Effective From

SELECT pph.effective_from
FROM product_price_history AS pph
LEFT JOIN dim_date AS dd
    ON pph.effective_from = dd.full_date
WHERE dd.date_key IS NULL;


-- Product Price History: Effective To

SELECT pph.effective_to
FROM product_price_history AS pph
LEFT JOIN dim_date AS dd
    ON pph.effective_to = dd.full_date
WHERE dd.date_key IS NULL
AND pph.effective_to IS NOT NULL;
