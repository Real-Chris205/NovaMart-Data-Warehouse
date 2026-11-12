
-- ============================================================
-- NovaMart Data Warehouse
-- Product Price History Audits
-- ============================================================

-- 1. Check required price-history fields
SELECT product_id
FROM product_price_history
WHERE product_id IS NULL
   OR unit_price IS NULL
   OR effective_from IS NULL
   OR effective_status IS NULL;

-- 2. Check active and historical status consistency
SELECT product_id
FROM product_price_history
WHERE (effective_status = 'Y' AND effective_to IS NOT NULL)
   OR (effective_status = 'N' AND effective_to IS NULL);

-- 3. Check invalid effective date ranges
SELECT product_id
FROM product_price_history
WHERE effective_to IS NOT NULL
  AND effective_to < effective_from;

-- 4. Check overlapping price-history periods
SELECT a.product_id, b.product_id
FROM product_price_history AS a
JOIN product_price_history AS b
    ON a.product_id = b.product_id
WHERE a.price_history_id < b.price_history_id
  AND (
      a.effective_from < b.effective_to
      OR b.effective_to IS NULL
  )
  AND (
      b.effective_from < a.effective_to
      OR a.effective_to IS NULL
  );

-- 5. Check non-positive historical prices
SELECT product_id
FROM product_price_history
WHERE unit_price <= 0;

-- 6. Check price history before product launch
SELECT p.product_id, p.launch_date, pph.effective_from
FROM products AS p
LEFT JOIN product_price_history AS pph
    ON p.product_id = pph.product_id
WHERE pph.effective_from < p.launch_date;

-- 7. Check price-history records with missing products
SELECT pph.product_id
FROM product_price_history AS pph
LEFT JOIN products AS p
    ON p.product_id = pph.product_id
WHERE p.product_id IS NULL;
