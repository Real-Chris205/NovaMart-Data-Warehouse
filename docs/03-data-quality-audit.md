# NovaMart Data Quality Audit

## 1. Overview

Following the design of the NovaMart OLTP database, a series of SQL-based data quality audits were performed using PostgreSQL.

The purpose of the audit was to evaluate the reliability, consistency, and validity of the operational data before transforming it into a dimensional data warehouse.

Rather than assuming that the operational data was clean, the audit process focused on identifying potential violations of business rules, investigating suspicious records, and distinguishing genuine data-quality issues from valid business scenarios.

The audit covered customer records, products, orders, order items, payments, and product price history.

## 2. Audit Objectives

The audit was designed to:

- Identify transactions that violate business chronology.
- Validate customer registration and order dates.
- Compare transaction prices with applicable product price history.
- Check the consistency of product price-history periods.
- Identify invalid or incomplete price-history records.
- Validate relationships between operational records.
- Investigate exceptions using related order, customer, product, and payment information.

## 3. Audit Scope

The primary operational tables covered were:

| Table | Audit purpose |
|---|---|
| `customers` | Customer registration dates and segment assignments |
| `products` | Product launch dates and product information |
| `orders` | Order chronology and transaction status |
| `order_item` | Product ordering and transaction prices |
| `payment` | Payment status and transaction investigation |
| `product_price_history` | Historical prices and effective date periods |

Related tables were joined where necessary to investigate the records returned by the audit queries.

## 4. Business Rules and Validation Checks

### 4.1 Product Launch Date Validation

**Business rule**

A product should not be ordered before its recorded launch date.

**Validation approach**

The order date was compared with the launch date of the product associated with each order item.

**SQL validation logic**

```sql
SELECT
    oi.order_item_id,
    oi.order_id,
    oi.product_id,
    o.order_date,
    p.product_name,
    p.launch_date
FROM order_item oi
JOIN orders o
    ON oi.order_id = o.order_id
JOIN products p
    ON oi.product_id = p.product_id
WHERE o.order_date < p.launch_date;
```

**Result**

One violation was identified.

- Order item: 24
- Order: 10
- Product: 18 — Huawei Mate X7
- Order date: 2025-09-09
- Recorded launch date: 2026-04-11

The order occurred before the product's recorded launch date.

The order was subsequently investigated alongside its order items, product information, payment records, and product price history.

### 4.2 Customer Registration Date Validation

**Business rule**

A customer should not place an order before their recorded registration date.

**Validation approach**

The order date was compared with the registration date of the customer associated with each order.

**SQL validation logic**

```sql
SELECT
    o.order_id,
    o.customer_id,
    c.registration_date,
    o.order_date,
    o.order_status
FROM orders o
JOIN customers c
    ON o.customer_id = c.customer_id
WHERE o.order_date < c.registration_date
ORDER BY o.order_id;
```

**Result**

Five orders were identified where the order date preceded the customer's registration date.

| Order ID | Customer ID |
|---:|---:|
| 3 | 10 |
| 10 | 4 |
| 20 | 15 |
| 27 | 16 |
| 30 | 16 |

Further investigation considered the order status and associated payment activity.

The findings included both cancelled/refunded orders and orders with completed transactional activity.

### 4.3 Future Customer Registration Date Validation

**Business rule**

A customer registration date should not occur after the audit reference date unless a future-dated registration is intentionally supported by the business process.

**Validation approach**

Customer registration dates were compared with the project's audit reference date of 2026-09-10.

**Result**

Customer ID 16 had a recorded registration date of 2026-10-21, which was later than the audit reference date.

This record was flagged for investigation.

### 4.4 Order Item and Historical Price Validation

**Business rule**

The transaction price recorded on an order item should be consistent with the applicable historical product price, unless an authorized promotion, negotiated price, or price override explains the difference.

**Validation approach**

The order date was used to identify the applicable product price-history period. The order item's recorded unit price was then compared with the historical unit price.

**SQL validation logic**

```sql
SELECT
    oi.order_item_id,
    oi.order_id,
    p.product_name,
    o.order_date,
    oi.unit_price AS charged_price,
    pph.unit_price AS historical_price,
    oi.discount,
    o.order_status
FROM orders o
JOIN order_item oi
    ON oi.order_id = o.order_id
JOIN products p
    ON p.product_id = oi.product_id
JOIN product_price_history pph
    ON pph.product_id = oi.product_id
    AND o.order_date >= pph.effective_from
    AND (
        o.order_date <= pph.effective_to
        OR pph.effective_to IS NULL
    )
WHERE oi.unit_price <> pph.unit_price
ORDER BY oi.order_item_id;
```

**Result**

Eight order-item price discrepancies were identified.

| Order item ID | Product | Charged price | Historical price | Order status |
|---:|---|---:|---:|---|
| 27 | Sony FX2 | ₦1,900 | ₦2,000 | Shipped |
| 28 | iPhone 15 | ₦900 | ₦950 | Pending |
| 30 | Redmi Note 15 | ₦350 | ₦370 | Cancelled |
| 38 | Adidas V-Collar | ₦90 | ₦100 | Pending |
| 42 | HP Elitebook 845 | ₦600 | ₦650 | Shipped |
| 43 | Redmi Note 15 | ₦350 | ₦370 | Cancelled |
| 46 | Redmi Note 15 | ₦350 | ₦370 | Delivered |
| 49 | Adidas V-Collar | ₦90 | ₦100 | Pending |

These records were investigated individually using order details, payment information, discounts, and historical price periods.

A price difference was treated as an exception requiring investigation, not automatic proof that the transaction price was incorrect.

### 4.5 Product Price History Overlap Validation

**Business rule**

Effective price periods belonging to the same product should not overlap.

**Validation approach**

Price-history records for the same product were compared to identify intersecting effective date intervals.

**Result**

The overlap validation returned zero records.

No overlapping product price-history periods were identified.

### 4.6 Invalid Historical Price Validation

**Business rule**

A historical product unit price must be greater than zero.

**Validation approach**

Price-history records were checked for unit prices less than or equal to zero.

**Result**

No invalid historical unit prices were identified.

### 4.7 Price History Before Product Launch

**Business rule**

A product's historical price record should not begin before its recorded launch date.

**Validation approach**

The effective start dates in `product_price_history` were compared with the corresponding product launch dates.

**Result**

No violations were identified.

### 4.8 Orphaned Product Price History Validation

**Business rule**

Every product price-history record must reference an existing product.

**Validation approach**

The product identifiers in `product_price_history` were checked against the `products` table.

**Result**

No orphaned product price-history records were identified.

## 5. Valid Business Scenarios Identified

Not every unusual record was classified as a data-quality problem.

The investigation confirmed several scenarios that were valid under the established NovaMart business rules.

### 5.1 NULL Customer Segments

Customers 5 and 17 had NULL values in `segment_id`.

This was accepted as a valid business scenario because customer segments may be assigned over time.

**Disposition:** Valid business rule. No correction required.

### 5.2 Multiple Products per Order

An order can contain multiple order items and therefore multiple products.

For example, Order 30 contains more than one product.

**Disposition:** Valid business rule.

### 5.3 Products from Different Stores

Under the established NovaMart business rule, an order can contain products associated with different stores.

**Disposition:** Valid business rule. This scenario was not classified as a data-quality violation.

## 6. Audit Results Summary

| Audit area | Result | Outcome |
|---|---:|---|
| Product ordered before launch | 1 | Exception identified |
| Orders before customer registration | 5 | Exceptions identified |
| Future customer registration | 1 | Exception identified |
| Historical price discrepancies | 8 | Exceptions identified |
| Product price-history overlaps | 0 | Passed |
| Invalid historical prices | 0 | Passed |
| Price history before product launch | 0 | Passed |
| Orphaned price-history records | 0 | Passed |

## 7. Investigation Principles

The audit process followed an evidence-based approach.

When a validation query returned an exception, the record was not automatically modified.

Instead, the investigation considered:

1. The affected operational records.
2. Related customer, product, and order information.
3. Order and payment statuses.
4. Transaction amounts and recorded discounts.
5. Applicable historical price periods.
6. The established business rules.

This distinction was particularly important for historical price discrepancies.

A transaction price that differs from the historical list price may have resulted from a promotion, negotiated price, manual override, or another pricing rule not represented in the current database.

Therefore, further investigation was required before deciding whether a correction was appropriate.

## 8. Audit Outcome

The NovaMart OLTP audit identified chronology inconsistencies and historical pricing discrepancies, while several structural and price-history checks passed.

The audit established a documented set of findings for further investigation and remediation.

The results were not treated as automatic permission to modify the operational data. Records requiring authoritative source verification were retained and flagged rather than changed using assumptions.

The next stage documents the detailed investigation findings, severity classifications, and remediation decisions.
