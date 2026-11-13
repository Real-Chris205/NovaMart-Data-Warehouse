
-- =========================================================
-- NovaMart Data Warehouse
-- Fact Product Price History Validation
-- =========================================================


-- 1. Verify the total number of records

SELECT COUNT(*) AS total_records
FROM fact_product_pricehistory;


-- 2. Validate product keys

SELECT COUNT(*)
FROM fact_product_pricehistory
WHERE product_key IS NULL;


-- 3. Validate effective-to date keys

SELECT COUNT(*)
FROM fact_product_pricehistory
WHERE effective_to_date_key IS NULL;

SELECT COUNT(*)
FROM fact_product_pricehistory
WHERE effective_to_date_key IS NOT NULL;


-- 4. Check for duplicate price-history records

SELECT COUNT(*), price_history_id
FROM fact_product_pricehistory
GROUP BY price_history_id
HAVING COUNT(*) > 1;


-- 5. Check for NULL source identifiers

SELECT COUNT(*)
FROM fact_product_pricehistory
WHERE price_history_id IS NULL;


-- 6. Validate unit prices

SELECT COUNT(*)
FROM fact_product_pricehistory
WHERE unit_price IS NULL;

SELECT COUNT(*)
FROM fact_product_pricehistory
WHERE unit_price <= 0;


-- 7. Validate effective status values

SELECT price_history_id
FROM fact_product_pricehistory
WHERE effective_status NOT IN ('Y','N');


-- 8. Verify status and ending-date consistency

SELECT effective_to_date_key, effective_status
FROM fact_product_pricehistory
WHERE effective_to_date_key IS NOT NULL
  AND effective_status = 'Y'
   OR effective_to_date_key IS NULL
  AND effective_status = 'N';


-- 9. Validate effective-from date keys

SELECT fph.effective_from_date_key
FROM fact_product_pricehistory AS fph
LEFT JOIN product_price_history AS pph
    ON pph.price_history_id = fph.price_history_id
LEFT JOIN dim_date AS dd
    ON fph.effective_from_date_key = dd.date_key
WHERE pph.effective_from IS DISTINCT FROM dd.full_date;


-- 10. Validate effective-to date keys

SELECT fph.effective_to_date_key
FROM fact_product_pricehistory AS fph
LEFT JOIN product_price_history AS pph
    ON pph.price_history_id = fph.price_history_id
LEFT JOIN dim_date AS dd
    ON fph.effective_to_date_key = dd.date_key
WHERE pph.effective_to IS DISTINCT FROM dd.full_date
  AND pph.effective_to IS NOT NULL;


-- 11. Validate product relationship accuracy

SELECT dp.product_name, fph.product_key
FROM fact_product_pricehistory AS fph
LEFT JOIN product_price_history AS pph
    ON fph.price_history_id = pph.price_history_id
LEFT JOIN dim_product AS dp
    ON fph.product_key = dp.product_key
WHERE fph.product_key IS NOT NULL
  AND pph.product_id IS DISTINCT FROM dp.product_id;


-- 12. Validate source-to-fact completeness

SELECT pph.price_history_id
FROM product_price_history AS pph
LEFT JOIN fact_product_pricehistory AS fph
    ON pph.price_history_id = fph.price_history_id
WHERE fph.price_history_id IS NULL;


-- 13. Validate fact-to-source completeness

SELECT fph.price_history_id
FROM fact_product_pricehistory AS fph
LEFT JOIN product_price_history AS pph
    ON pph.price_history_id = fph.price_history_id
WHERE pph.price_history_id IS NULL;
