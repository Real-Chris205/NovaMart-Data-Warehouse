
-- =========================================================
-- NovaMart Data Warehouse
-- SCD Type 2 Validation
-- =========================================================


-- 1. Check for multiple current versions

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


-- 2. Check SCD Type 2 current flag and validity consistency

-- Customer
SELECT COUNT(*), customer_id
FROM dim_customer
WHERE (valid_to IS NULL AND is_current = 'N')
   OR (valid_to IS NOT NULL AND is_current = 'Y')
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


-- 3. Check validity period integrity

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


-- 4. SCD Type 2 temporal overlap validation

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


-- 5. Check duplicate business key and valid_from combinations

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
