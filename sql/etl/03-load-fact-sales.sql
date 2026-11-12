
-- =====================================================
-- NovaMart Data Warehouse
-- Fact Sales ETL
-- =====================================================

-- Load sales records into the fact_sales table

INSERT INTO fact_sales (
    order_id,
    order_item_id,
    customer_key,
    product_key,
    employee_key,
    store_key,
    date_key,
    quantity,
    unit_price,
    discount_amount,
    sales_amount
)

SELECT
    o.order_id,
    oi.order_item_id,
    dc.customer_key,
    dp.product_key,
    de.employee_key,
    ds.store_key,
    dd.date_key,
    oi.quantity,
    oi.unit_price,
    COALESCE(oi.discount, 0),
    oi.unit_price * oi.quantity - COALESCE(oi.discount, 0) AS sales_amount

FROM order_item AS oi

INNER JOIN orders AS o
    ON o.order_id = oi.order_id

LEFT JOIN dim_customer AS dc
    ON o.customer_id = dc.customer_id
    AND o.order_date >= dc.valid_from
    AND o.order_date < COALESCE(
        dc.valid_to,
        'infinity'::timestamp
    )

LEFT JOIN dim_product AS dp
    ON oi.product_id = dp.product_id
    AND o.order_date >= dp.valid_from
    AND o.order_date < COALESCE(
        dp.valid_to,
        'infinity'::timestamp
    )

LEFT JOIN dim_employee AS de
    ON o.employee_id = de.employee_id
    AND o.order_date >= de.valid_from
    AND o.order_date < COALESCE(
        de.valid_to,
        'infinity'::timestamp
    )

LEFT JOIN dim_store AS ds
    ON o.store_id = ds.store_id
    AND o.order_date >= ds.valid_from
    AND o.order_date < COALESCE(
        ds.valid_to,
        'infinity'::timestamp
    )

LEFT JOIN dim_date AS dd
    ON o.order_date = dd.full_date;
