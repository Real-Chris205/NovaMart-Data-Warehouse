-- =====================================================
-- NovaMart Data Warehouse
-- Fact Product Price History ETL
-- =====================================================

-- Load product price-history records into the fact table

INSERT INTO Fact_Product_PriceHistory (
    price_history_id,
    product_key,
    effective_from_date_key,
    effective_to_date_key,
    unit_price,
    effective_status
)

SELECT
    pph.price_history_id,
    dp.product_key,
    dd.date_key,
    ds.date_key,
    pph.unit_price,
    pph.effective_status

FROM product_price_history AS pph

LEFT JOIN dim_product AS dp
    ON pph.product_id = dp.product_id
    AND pph.effective_from >= dp.valid_from
    AND pph.effective_from < COALESCE(
        dp.valid_to,
        'infinity'::TIMESTAMP
    )

LEFT JOIN dim_date AS dd
    ON pph.effective_from = dd.full_date

LEFT JOIN dim_date AS ds
    ON pph.effective_to = ds.full_date;
