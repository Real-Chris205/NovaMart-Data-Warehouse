# NovaMart ETL Pipeline Implementation

## 1. Overview

The ETL stage of the NovaMart project involved extracting data from the operational OLTP tables, transforming it into the structure required by the dimensional warehouse, and loading it into the dimension and fact tables.

The implementation was carried out using SQL in PostgreSQL through pgAdmin 4.

The OLTP database and dimensional warehouse were implemented within the same PostgreSQL database. Therefore, the transformations accessed the operational tables directly without requiring a separate database connection or external data extraction tool.

The ETL implementation used SQL `INSERT INTO ... SELECT` statements, joins, date lookups, and calculated measures.

## 2. ETL Architecture

The pipeline followed three main stages:

1. **Extract:** Retrieve operational records from the OLTP tables.
2. **Transform:** Map source attributes, resolve dimension keys, apply date lookups, and calculate measures.
3. **Load:** Insert the transformed records into the dimensional warehouse.

### Data flow

```text
             OLTP SOURCE TABLES
                     |
                     v
               EXTRACTION
                     |
                     v
              TRANSFORMATION
                     |
          +----------+----------+
          |                     |
          v                     v
    DIMENSION TABLES       FACT TABLES
          |                     |
          +----------+----------+
                     |
                     v
             WAREHOUSE DATA
                     |
                     v
                VALIDATION
```

## 3. Dimension Loading

The dimension tables were populated before the fact tables so that the fact-loading queries could resolve the required surrogate keys.

Six dimension tables were loaded.

| Dimension | Source tables | Loaded rows |
|---|---|---:|
| `dim_customer` | customers, customer_segment | 20 |
| `dim_supplier` | supplier | 10 |
| `dim_employee` | employee, job, department | 15 |
| `dim_store` | store | 5 |
| `dim_product` | products, brand, category, dim_supplier | 21 |
| `dim_date` | PostgreSQL `generate_series()` | 730 |

### 3.1 Customer Dimension

Customer records were extracted from the `customers` table and enriched with customer segment descriptions from `customer_segment`.

A `LEFT JOIN` was used to retrieve the corresponding segment name.

The transformed records were inserted into `dim_customer`.

### 3.2 Supplier Dimension

Supplier records were extracted from the operational `supplier` table and mapped into `dim_supplier`.

The supplier attributes included supplier name, email, phone, and address.

### 3.3 Employee Dimension

Employee records were enriched using the `job` and `department` tables.

The transformation retrieved job titles and department names before inserting the records into `dim_employee`.

### 3.4 Store Dimension

Store records were extracted from the operational `store` table and loaded into `dim_store`.

The transformation retained store attributes such as store name, city, state, country, and region.

### 3.5 Product Dimension

Product records were enriched using the `brand`, `category`, and `dim_supplier` tables.

The transformation resolved the supplier surrogate key and included product attributes such as product name, brand, category, unit cost, unit price, colour, size, launch date, and discontinued flag.

### 3.6 Date Dimension

Unlike the other dimensions, `dim_date` was generated directly in PostgreSQL rather than extracted from an OLTP source table.

PostgreSQL's `generate_series()` function generated consecutive dates from **2025-01-01 to 2026-12-31**.

The date transformation generated:

- Date key in `YYYYMMDD` format.
- Full date.
- Day and month numbers.
- Month name.
- Quarter number and quarter name.
- Year.
- Day name and day of week.
- Week of year.
- Weekend indicator.
- Year-month attribute.

The resulting date dimension contained 730 records and served as a shared calendar dimension for the fact tables.

## 4. Surrogate Key Generation

The dimensional warehouse uses surrogate keys to identify dimension and fact records independently of their original operational identifiers.

The surrogate keys were configured to generate automatically using PostgreSQL identity columns.

During fact loading, the ETL queries retrieved the appropriate dimension surrogate keys by joining source business identifiers to their corresponding dimension records.

This allowed the fact tables to reference warehouse dimension records rather than relying solely on operational identifiers.

## 5. Fact Table Loading

After loading the dimensions, the three fact tables were populated.

| Fact table | Source table | Grain | Loaded rows |
|---|---|---|---:|
| `fact_sales` | orders, order_item | One row per order item | 50 |
| `fact_payment` | payment, orders | One row per payment record | 31 |
| `fact_product_pricehistory` | product_price_history | One row per product price-history record | 18 |

### 5.1 Fact Sales

The sales fact table was populated using `order_item` as the primary transaction source, joined to `orders`.

The transformation resolved the customer, product, employee, store, and date surrogate keys.

For the five dimensions with SCD Type 2 tracking, the dimension lookup used the order date to identify the version valid at the time of the transaction.

The sales measure was calculated using:

```sql
quantity * unit_price - COALESCE(discount, 0)
```

A missing discount was treated as zero during the calculation.

The resulting records were inserted into `fact_sales`.

### 5.2 Fact Payment

The payment fact table was populated from the operational `payment` table, joined to `orders`.

The transformation retrieved the related customer, employee, and store dimension keys using the associated order.

The payment date was used to resolve the corresponding date key from `dim_date`.

Payment attributes, including payment amount, payment method, and payment status, were retained.

The resulting records were inserted into `fact_payment`.

### 5.3 Fact Product Price History

The product price-history fact table was populated from `product_price_history`.

The transformation resolved:

- The applicable product dimension version.
- The effective-from date key.
- The effective-to date key.
- The historical unit price.
- The effective status.

The product dimension lookup used the historical price record's `effective_from` date against the dimension's validity interval.

Three historical price records predated the product dimension's baseline validity date of 2025-06-01. These records could not resolve to a valid product surrogate key.

Their source records were retained, and the `product_key` column was configured to allow NULL values for these exceptions rather than assigning unsupported surrogate keys.

## 6. SCD Type 2 Lookup Logic

The five historical dimensions were designed with the following metadata:

- `valid_from`
- `valid_to`
- `is_current`

The initial dimension records used a baseline of:

- `valid_from = 2025-06-01 00:00:00`
- `valid_to = NULL`
- `is_current = 'Y'`

During fact loading, the ETL used temporal lookup conditions to identify the dimension version applicable to a transaction.

The lookup logic followed a half-open validity interval:

```sql
order_date >= valid_from
AND order_date < COALESCE(
    valid_to,
    'infinity'::timestamp
)
```

This ensured that the fact record referenced the dimension version valid at the relevant transaction date.

**Implementation note:** The project established the SCD Type 2 dimension structure and temporal lookup logic using an initial baseline load. It did not implement a scheduled incremental change-capture process for automatically creating new historical dimension versions.

## 7. ETL Loading Order

The implementation followed this logical loading sequence:

1. Load `dim_customer`.
2. Load `dim_supplier`.
3. Load `dim_employee`.
4. Load `dim_store`.
5. Generate and load `dim_date`.
6. Load `dim_product` after resolving supplier keys.
7. Load `fact_sales`.
8. Load `fact_payment`.
9. Load `fact_product_pricehistory`.

The dimensions were populated before the fact tables to support surrogate-key lookups and maintain referential relationships.

## 8. Post-Load Validation

After loading the warehouse tables, SQL validation queries were executed to assess the results.

The checks included:

- Dimension and fact row counts.
- Surrogate key uniqueness.
- Source-to-dimension completeness.
- Dimension-to-source completeness.
- Fact-to-dimension referential integrity.
- Fact grain enforcement.
- SCD Type 2 validity consistency.
- Date-key coverage.
- Fact measure calculations.
- Historical price-history integrity.

These checks helped establish whether the transformed records were correctly represented in the warehouse.

The detailed validation results are documented in the subsequent warehouse validation stage.

## 9. Implementation Scope and Limitations

The ETL implementation was developed using PostgreSQL SQL statements executed through pgAdmin 4.

The project demonstrates relational extraction, SQL-based transformation, surrogate-key resolution, temporal dimension lookups, fact loading, and post-load validation.

The implementation did not include an external ETL platform, workflow scheduler, orchestration framework, or automated recurring execution.

The documented pipeline therefore represents the SQL-based ETL process implemented in the project, rather than a production-scheduled pipeline.

## 10. Conclusion

The ETL stage transformed NovaMart's operational data into a dimensional warehouse structure.

The implementation loaded six dimensions and three fact tables, resolved surrogate keys, applied temporal lookups for SCD Type 2 dimensions, generated a shared calendar dimension, and calculated sales measures.

Post-load SQL checks were then used to assess completeness, key integrity, and the accuracy of the loaded warehouse records.

This stage established the foundation for the subsequent data warehouse validation process.
