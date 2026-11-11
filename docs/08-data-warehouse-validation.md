# NovaMart Data Warehouse Validation

## 1. Overview

The data warehouse validation stage assessed the integrity, completeness, consistency, and accuracy of the dimensional warehouse after ETL execution.

SQL validation queries were executed in PostgreSQL through pgAdmin 4.

The validation covered:

- Dimension table integrity.
- Fact table loading and grain.
- Surrogate key and business key uniqueness.
- Slowly Changing Dimension Type 2 (SCD Type 2) integrity.
- Fact-to-dimension referential integrity.
- Source-to-warehouse completeness.
- Date dimension coverage.
- Fact measures and calculations.
- Historical price-history consistency.

The objective was to establish whether the warehouse accurately represented the available operational data and to identify any limitations that needed to remain documented.

## 2. Dimension Table Validation

The six dimension tables were checked for expected row counts, key integrity, and source coverage.

### Dimension row counts

| Dimension table | Actual rows |
|---|---:|
| `dim_customer` | 20 |
| `dim_supplier` | 10 |
| `dim_employee` | 15 |
| `dim_store` | 5 |
| `dim_product` | 21 |
| `dim_date` | 730 |

### 2.1 Source-to-Dimension Completeness

Both directions of source coverage were checked:

- Source-to-dimension: every expected source entity had a corresponding dimension record.
- Dimension-to-source: every dimension entity had a corresponding operational source record.

The checks returned no missing source entities and no additional dimension entities across the five business dimensions.

### 2.2 Surrogate Key Integrity

Surrogate key uniqueness was checked to ensure that dimension records could be referenced unambiguously.

The validation results recorded no duplicate surrogate keys in the checked dimensions.

## 3. SCD Type 2 Validation

Five dimensions were implemented with SCD Type 2 tracking:

- `dim_customer`
- `dim_product`
- `dim_employee`
- `dim_store`
- `dim_supplier`

The dimensions were checked for historical version consistency.

### Validation results

| Validation check | Customer | Product | Employee | Store | Supplier |
|---|---:|---:|---:|---:|---:|
| Multiple current versions | 0 | 0 | 0 | 0 | 0 |
| Current flag/date inconsistencies | 0 | 0 | 0 | 0 | 0 |
| Invalid validity periods | 0 | 0 | 0 | 0 | 0 |
| Overlapping versions | 0 | 0 | 0 | 0 | 0 |
| Duplicate business key and `valid_from` combinations | 0 | 0 | 0 | 0 | 0 |
| Source-to-dimension missing entities | 0 | 0 | 0 | 0 | 0 |
| Dimension-to-source extra entities | 0 | 0 | 0 | 0 | 0 |

The checks found no reported violations of the implemented SCD Type 2 validity rules.

The initial baseline date of 2025-06-01 remains an important historical limitation: the warehouse does not reconstruct dimension history before that date.

## 4. Fact Table Validation

The three fact tables were validated against their expected source records and defined grain.

### 4.1 Fact Table Row Counts

| Fact table | Expected rows | Actual rows | Result |
|---|---:|---:|---|
| `fact_sales` | 50 | 50 | Passed |
| `fact_payment` | 31 | 31 | Passed |
| `fact_product_pricehistory` | 18 | 18 | Passed |

All three fact tables contained the expected number of records.

### 4.2 Fact Table Integrity Results

| Validation check | `fact_sales` | `fact_payment` | `fact_product_pricehistory` |
|---|---:|---:|---:|
| Duplicate business keys | 0 | 0 | 0 |
| Missing required keys | 0 | 0 | 0* |
| Invalid measures | 0 | 0 | 0 |
| Source-to-fact missing records | 0 | 0 | 0 |
| Extra warehouse records | 0 | 0 | 0 |
| Relationship mismatches | 0 | 0 | 0 |

*The three `NULL` product keys in `fact_product_pricehistory` are documented historical exceptions, not ordinary missing-key failures.*

### 4.3 Fact Grain and Uniqueness

The fact tables were checked against their intended grain:

- `fact_sales`: one record per order item.
- `fact_payment`: one record per payment record.
- `fact_product_pricehistory`: one record per product price-history record.

The validation checks found no duplicate business keys in the three fact tables.

## 5. Fact-to-Dimension Referential Integrity

The fact tables were checked to ensure that their foreign-key references resolved to the appropriate dimension records.

### Validation results

| Fact table | Dimension relationships checked | Orphan records |
|---|---|---:|
| `fact_sales` | Customer, product, employee, store, date | 0 |
| `fact_payment` | Customer, employee, store, date | 0 |
| `fact_product_pricehistory` | Product, effective-from date, effective-to date | 0 |

For `fact_product_pricehistory`, the product relationship check excluded the three intentionally `NULL` product keys.

The effective-to date check also excluded legitimate `NULL` ending dates.

`dim_supplier` was validated independently because none of the three fact tables directly references it.

The checks found no unexpected orphan records.

## 6. Date Dimension Coverage

The shared date dimension was checked for row count, date coverage, and surrogate key uniqueness.

### Validation results

| Attribute | Result |
|---|---|
| Total records | 730 |
| Start date | 2025-01-01 |
| End date | 2026-12-31 |
| Duplicate date keys | 0 |
| Missing source dates used by fact tables | 0 |

The source dates used by the three fact tables were successfully matched to records in `dim_date`.

This confirmed that the date dimension covered the date references required by the loaded warehouse records.

## 7. Fact Measure and Attribute Validation

The fact tables were also checked to ensure that their stored measures and attributes agreed with their source records and transformation rules.

### 7.1 Sales Fact

The sales fact validation included:

- Checking for non-positive sales amounts.
- Checking for negative discounts.
- Checking whether discounts exceeded gross item value.
- Checking for non-positive quantities.
- Checking for non-positive unit prices.
- Recalculating sales amounts and comparing them with stored values.
- Comparing source and warehouse sales records.
- Verifying date and dimension relationships.

The sales amount calculation was:

```sql
unit_price * quantity - COALESCE(discount_amount, 0)
```

The validation checks found no reported invalid measures or calculation mismatches.

The total `fact_sales` amount was ₦302,918.00.

### 7.2 Payment Fact

The payment fact validation included:

- Payment ID uniqueness and completeness.
- Payment amount consistency.
- Payment method consistency.
- Payment status consistency.
- Payment date consistency.
- Source-to-fact completeness.
- Fact-to-source completeness.

The payment attributes were compared against the original `payment` records.

The validation checks found no reported discrepancies.

All payment statuses were retained in the fact table. A `Completed` payment must be distinguished from `Pending`, `Failed`, and `Refunded` when analysing successfully collected money.

### 7.3 Product Price-History Fact

The price-history fact validation included:

- Price-history record uniqueness.
- Source-to-fact completeness.
- Fact-to-source completeness.
- Historical unit price consistency.
- Effective status validation.
- Effective-from date consistency.
- Effective-to date consistency.
- Product relationship accuracy.

The validation checks found no reported price-history attribute mismatches.

## 8. Documented Exception — DQ-PH-01

### Product Price-History Records Predating the Dimension Baseline

Three historical price-history records could not be assigned a product surrogate key through the implemented temporal lookup.

| Price-history ID | Product ID | Effective-from date |
|---|---:|---|
| 1 | 4 | 2025-05-11 |
| 11 | 5 | 2025-01-11 |
| 13 | 10 | 2025-01-01 |

The product dimension's initial baseline validity date was 2025-06-01.

These three records predated that baseline.

### Decision

The original price-history records and effective dates were preserved.

Their `product_key` values remained `NULL` rather than being assigned unsupported surrogate keys.

No artificial historical product versions were created to force a temporal match.

### Analytical limitation

Historical price analysis for these three records cannot reliably be attributed to a product dimension version.

This exception must remain visible in downstream analysis and should not be silently interpreted as an ordinary missing product.

## 9. Final Validation Summary

The warehouse validation results were recorded as follows:

| Validation area | Final result |
|---|---|
| Fact table loading | Passed |
| Fact table grain and uniqueness | Passed |
| Fact measure calculations | Passed |
| Dimension integrity | Passed |
| SCD Type 2 integrity | Passed |
| Referential integrity | Passed |
| Source-to-warehouse coverage | Passed |
| Date dimension coverage | Passed |
| Documented exceptions | 1 finding, 3 affected records |

## 10. Conclusion

The NovaMart data warehouse passed the recorded fact-table, dimension, referential-integrity, source-coverage, and date-coverage validation checks.

The validation process established that the expected fact records were loaded, the defined fact grains were maintained, the implemented dimension relationships resolved correctly, and the stored measures passed the recorded checks.

One documented exception remains: three product price-history records predate the initial product dimension baseline and therefore retain `NULL` product surrogate keys.

The warehouse does not reconstruct complete historical dimension information before 2025-06-01.

The final decision was to retain this limitation transparently rather than introduce unsupported historical records or surrogate-key assignments.

Within the validation checks performed, the warehouse was considered ready to proceed to SQL-based analytical validation, provided downstream analysis respects the documented historical limitation.
