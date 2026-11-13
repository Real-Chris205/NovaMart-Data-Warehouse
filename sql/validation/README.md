# Data Warehouse Validation Scripts

This directory contains SQL scripts used to validate the integrity, consistency, and reliability of the NovaMart Data Warehouse.

The validation process checks whether the dimensional model, fact tables, historical records, and relationships between warehouse tables meet the expected data quality requirements.

## Validation Scripts

| File | Description |
|---|---|
| `01-dimension-validation.sql` | Validates dimension tables, including surrogate keys, business keys, and historical records. |
| `02-fact-sales-validation.sql` | Validates the Fact Sales table and its measures and relationships. |
| `03-fact-payment-validation.sql` | Validates payment fact records and payment-related measures. |
| `04-fact-price-history-validation.sql` | Validates product price history records and their dimensional mappings. |
| `05-scd-type-2-validation.sql` | Checks SCD Type 2 implementation, including current records, validity periods, and historical versions. |
| `06-referential-integrity-validation.sql` | Checks relationships between fact tables and their related dimension tables. |
| `07-warehouse-wide-validation.sql` | Performs broader validation across the warehouse to assess overall data integrity and consistency. |

## Validation Scope

The scripts cover:

- Dimension table integrity.
- Fact table validation.
- Surrogate key uniqueness.
- SCD Type 2 historical tracking.
- Referential integrity.
- Date dimension relationships.
- Warehouse-wide data consistency.

## Validation Outcome

The warehouse validation process confirmed that the core dimensional model and fact table relationships passed the implemented checks, subject to the documented historical product price limitation (DQ-PH-01).
