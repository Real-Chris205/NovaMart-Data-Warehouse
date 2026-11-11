# NovaMart Data Cleaning and Remediation

## 1. Overview

Following the NovaMart OLTP data-quality audit, the identified exceptions were investigated to determine their causes, potential business impact, and appropriate remediation actions.

The objective of this stage was not simply to modify records that failed validation. Instead, each finding was assessed using the available operational evidence, including order dates, customer registration dates, product launch dates, historical prices, discounts, order statuses, and payment records.

A key principle guided this stage:

**Data should only be corrected when sufficient evidence establishes the correct replacement value.**

Where the available data could not establish the correct value, the record was retained and flagged for source verification.

## 2. Remediation Decision Framework

Each finding was assessed using four possible remediation outcomes.

| Outcome | Description |
|---|---|
| Correct in OLTP | Apply a correction when the authoritative value is known and supported by evidence. |
| Source verification required | Retain the record until the original source data or business records establish the correct value. |
| Business-rule or schema change | Consider a model or rule change when the data represents a legitimate scenario not supported by the current design. |
| Accept / no correction | Retain records that represent valid business scenarios or checks that passed. |

This approach prevents unsupported changes to operational data.

## 3. Severity Classification

The following severity levels were used to assess the potential impact of each finding.

### Critical

A data issue that could cause major financial, operational, or regulatory consequences.

### High

A data issue that affects transactional integrity or could materially affect downstream reporting and analytics.

### Medium

A data inconsistency that affects data reliability but has limited immediate business impact.

### Low

A data inconsistency with little or no completed financial or operational impact.

## 4. Chronology Findings

### DQ-001 — Product Ordered Before Product Launch

**Area:** Order/Product Chronology

**Affected tables:**
- `orders`
- `order_item`
- `products`

**Evidence:**

| Attribute | Value |
|---|---|
| Order ID | 10 |
| Product ID | 18 |
| Product | Huawei Mate X7 |
| Order date | 2025-09-09 |
| Recorded launch date | 2026-04-11 |
| Order status | Delivered |
| Payment status | Completed |

Order 10 contains Product 18, although the order date precedes the product's recorded launch date.

Further investigation established that the order was delivered and the payment was completed. The payment amount reconciled with the order total, so the issue was not classified as a payment reconciliation problem.

The product was also ordered later, after its recorded launch date.

**Root-cause category:** Temporal / Transaction Integrity

**Severity:** High

**Potential business impact:**
- Unreliable historical sales analysis.
- Incorrect product lifecycle reporting.
- Inaccurate product availability chronology.

**Remediation decision:** Source verification required.

**Recommended action:**

Verify the original Order 10 date and Product 18 launch date against authoritative source records.

Do not update either value without supporting evidence.

### DQ-002 — Orders Before Customer Registration

**Area:** Customer/Order Chronology

**Affected tables:**
- `customers`
- `orders`

**Evidence:**

Five orders were identified with order dates earlier than their customers' recorded registration dates.

| Order ID | Customer ID | Investigation outcome |
|---:|---:|---|
| 3 | 10 | Cancelled / Refunded |
| 10 | 4 | Delivered / Payment completed |
| 20 | 15 | Cancelled / Refunded |
| 27 | 16 | Shipped / Payment completed |
| 30 | 16 | Delivered / Payment completed |

**Additional investigation**

**Customers 10 and 15**

Their affected orders were cancelled, and the associated payment records had a `Refunded` status.

- Order 3 had a refunded payment of ₦2,857.
- Order 20 had a refunded payment of ₦900.

These records indicate that the transactions reached the refund stage. Therefore, they should not be described as failed payments or as transactions with no payment activity.

Although the payments were refunded, the chronology inconsistency remains and requires source verification.

**Customer 4**

Order 10 was delivered and had completed payment activity. This makes the chronology inconsistency more significant.

**Customer 16**

The recorded registration date was 2026-10-21.

The affected orders were:

- Order 27: 2026-07-15
- Order 30: 2026-07-20

Both had completed payment activity, and Order 30 was delivered.

**Root-cause category:** Temporal / Customer Lifecycle Integrity

**Severity:** High

**Potential business impact:**
- Distorted customer lifetime analysis.
- Incorrect acquisition reporting.
- Unreliable customer cohort analysis.
- Inaccurate customer activity timelines.

**Remediation decision:** Source verification required.

**Recommended action:**

Verify the customer registration dates and original order timestamps against the source system.

Do not automatically modify customer registration dates or order dates.

## 5. Historical Pricing Findings

The audit identified eight order items whose recorded transaction prices differed from the applicable historical product prices.

Each finding was investigated separately.

### DQ-003 — Sony FX2 Historical Price Discrepancy

**Affected record:** Order item 27

| Attribute | Value |
|---|---|
| Order ID | 12 |
| Product | Sony FX2 |
| Order date | 2026-08-19 |
| Charged price | ₦1,900 |
| Historical price | ₦2,000 |
| Discount | NULL |
| Order status | Shipped |

**Investigation**

The payment amount was consistent with the order-item charge.

Therefore, the discrepancy was between the recorded transaction price and historical product price, not payment reconciliation.

Possible explanations include an unrecorded promotion, negotiated price, or manual price override.

**Root-cause category:** Historical Pricing / Transaction Price Mismatch

**Severity:** Medium

**Remediation decision:** Source verification required.

**Recommended action:** Verify whether an authorized promotion, negotiated price, or price override existed.

### DQ-004 — iPhone 15 Historical Price Discrepancy

**Affected record:** Order item 28

| Attribute | Value |
|---|---|
| Order ID | 13 |
| Product | iPhone 15 |
| Order date | 2026-08-23 |
| Charged price | ₦900 |
| Historical price | ₦950 |
| Discount | NULL |
| Order status | Pending |

**Investigation**

The investigation notes record that the payment amount matched the transaction amount and describe the payment as completed.

However, the order status was recorded as Pending. This status detail should remain visible for further verification rather than being silently treated as resolved.

Possible explanations for the price difference include:
- An unrecorded promotion.
- A negotiated price.
- A manual price override.
- A pricing rule not represented in the current schema.

**Root-cause category:** Historical Pricing / Transaction Price Mismatch

**Severity:** Medium

**Remediation decision:** Source verification required.

**Recommended action:** Verify the original transaction and any promotional or price-override rules. Confirm the order and payment status from the source records.

### DQ-005 — Redmi Note 15 Discrepancy on Cancelled Order

**Affected record:** Order item 30

| Attribute | Value |
|---|---|
| Order ID | 15 |
| Product | Redmi Note 15 |
| Order date | 2026-02-09 |
| Charged price | ₦350 |
| Historical price | ₦370 |
| Discount | NULL |
| Order status | Cancelled |
| Payment status | Failed |

**Investigation**

The payment record was marked as Refunded. Based on the investigation, no outstanding financial impact remained from this transaction.

**Root-cause category:** Historical Pricing / Transaction Price Mismatch

**Severity:** Low

**Remediation decision:** Source verification required.

**Recommended action:** Retain the discrepancy for historical accuracy and verify the source if necessary. No financial correction is currently required.

### DQ-006 — Adidas V-Collar Historical Price Discrepancy

**Affected record:** Order item 38

| Attribute | Value |
|---|---|
| Order ID | 23 |
| Product | Adidas V-Collar |
| Charged price | ₦90 |
| Historical price | ₦100 |
| Discount | NULL |
| Order status | Pending |
| Payment amount | ₦90 |
| Payment status | Pending |

**Investigation**

The payment amount matched the transaction amount, but the payment had not completed.

An authorized promotion or price override could explain the difference.

**Root-cause category:** Historical Pricing / Transaction Price Mismatch

**Severity:** Low

**Remediation decision:** Source and business-rule verification required.

**Recommended action:** Verify whether a promotion or price override existed. Do not modify the order price without evidence.

### DQ-007 — HP Elitebook 845 Historical Price Discrepancy

**Affected record:** Order item 42

| Attribute | Value |
|---|---|
| Order ID | 27 |
| Product | HP Elitebook 845 |
| Charged price | ₦600 |
| Historical price | ₦650 |
| Discount | NULL |
| Order status | Shipped |
| Payment status | Completed |

**Investigation**

The order amount and payment amount reconciled.

Therefore, the discrepancy was not a payment reconciliation issue.

An undocumented promotion, negotiated price, or price override could explain the difference.

**Root-cause category:** Historical Pricing / Transaction Price Mismatch

**Severity:** Medium

**Remediation decision:** Source and business-rule verification required.

**Recommended action:** Verify whether an authorized price override or promotion existed before considering any correction.

### DQ-008 — Redmi Note 15 Discrepancy on Cancelled/Refunded Order

**Affected record:** Order item 43

| Attribute | Value |
|---|---|
| Order ID | 28 |
| Product | Redmi Note 15 |
| Charged price | ₦350 |
| Historical price | ₦370 |
| Discount | NULL |
| Order status | Cancelled |
| Payment status | Refunded |

**Investigation**

The transaction was cancelled and refunded. The investigation found no completed financial impact remaining from this transaction.

**Root-cause category:** Historical Pricing / Transaction Price Mismatch

**Severity:** Low

**Remediation decision:** Source verification required.

**Recommended action:** Retain the discrepancy for historical accuracy. No financial correction is currently required.

### DQ-009 — Redmi Note 15 Historical Price and Discount Case

**Affected record:** Order item 46

| Attribute | Value |
|---|---|
| Order ID | 30 |
| Product | Redmi Note 15 |
| Quantity | 5 |
| Charged unit price | ₦350 |
| Historical unit price | ₦370 |
| Discount | ₦75 |
| Order status | Delivered |

**Investigation**

The payment reconciliation was valid.

The remaining question was why the transaction unit price differed from the historical product price despite the recorded discount.

**Root-cause category:** Historical Pricing / Discount Business Rule

**Severity:** Medium

**Remediation decision:** Source and business-rule verification required.

**Recommended action:**

Determine how the discount field is intended to interact with historical pricing and transaction pricing.

Do not modify the order item without confirming the intended pricing rule.

### DQ-010 — Adidas V-Collar Sold at an Expired Historical Price

**Affected record:** Order item 49

| Attribute | Value |
|---|---|
| Order ID | 7 |
| Product | Adidas V-Collar |
| Order date | 2026-08-22 |
| Charged price | ₦90 |
| Discount | NULL |
| Order status | Pending |

**Historical price records**

| Effective period | Unit price | Status |
|---|---:|---|
| 2026-02-12 to 2026-02-28 | ₦90 | Expired |
| 2026-03-01 onward | ₦100 | Active |

On 2026-08-22, the applicable historical price was ₦100, but the order item recorded ₦90.

There was no recorded discount explaining the difference.

**Root-cause category:** Historical Pricing / Expired Price Usage

**Severity:** High

**Remediation decision:** Source and business-rule verification required.

**Recommended action:**

Verify the source transaction and determine why the expired ₦90 price was used.

If the source confirms that ₦90 was intentional, the pricing model may need to support an explicit promotion or price-override mechanism.

If the source confirms that ₦100 should have applied, determine the appropriate correction using authoritative evidence.

## 6. Remediation Summary

The ten findings were assessed individually.

| Remediation outcome | Number of findings |
|---|---:|
| Correct immediately | 0 |
| Source verification required | 10 |
| Confirmed schema/business-rule changes | 0 |

All ten findings remained unresolved pending verification against authoritative source records
The absence of immediate corrections was intentional.

The available evidence established inconsistencies, but it did not establish the authoritative replacement values needed to safely modify the affected operational records.

## 7. OLTP Remediation Decision

The OLTP records were retained without speculative updates.

The unresolved findings were documented for source verification.

This decision protects the integrity of the original transactional data and prevents assumptions from being introduced into the operational database.

The outcome was not that every OLTP record had become clean. Rather, the known exceptions were identified, investigated, classified, and documented with explicit remediation decisions.

## 8. Conclusion

The NovaMart remediation stage demonstrated an evidence-based approach to data cleaning.

Instead of automatically updating every record returned by a validation query, each finding was assessed using its surrounding business context.

The investigation considered transaction status, payment activity, historical pricing, discounts, and business chronology.

Where authoritative evidence was unavailable, the original records were retained and flagged.

This ensured that the downstream data engineering process could proceed with documented knowledge of unresolved source-data limitations, rather than silently introducing unsupported corrections.
