-- =====================================================
-- NovaMart Data Warehouse
-- Fact Payment ETL
-- =====================================================

-- Load payment records into the fact_payment table

INSERT INTO fact_payment (
    payment_id,
    order_id,
    customer_key,
    employee_key,
    store_key,
    date_key,
    payment_amount,
    payment_method,
    payment_status
)

SELECT
    p.payment_id,
    o.order_id,
    dc.customer_key,
    de.employee_key,
    ds.store_key,
    dd.date_key,
    p.payment_amount,
    p.payment_method,
    p.payment_status

FROM payment AS p

INNER JOIN orders AS o
    ON p.order_id = o.order_id

LEFT JOIN dim_customer AS dc
    ON o.customer_id = dc.customer_id
    AND o.order_date >= dc.valid_from
    AND o.order_date < COALESCE(
        dc.valid_to,
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
    ON p.payment_date = dd.full_date;
