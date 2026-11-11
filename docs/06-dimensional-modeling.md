# NovaMart Dimensional Modelling

## 1. Overview

The NovaMart dimensional data warehouse was designed to transform operational retail data into a structure suitable for historical analysis, reporting queries, and data validation.

The dimensional model consists of:

- 6 dimension tables
- 3 fact tables
- 5 dimensions implementing Slowly Changing Dimension Type 2 (SCD Type 2)
- 1 shared calendar dimension

The warehouse was implemented using PostgreSQL and SQL within the same database as the OLTP tables.

## 2. Dimensional Modelling Approach

The warehouse uses dimensional modelling principles to separate descriptive business attributes from measurable business events.

**Dimension tables** describe business entities such as customers, products, employees, stores, suppliers, and dates.

**Fact tables** capture business events such as sales transactions, payments, and product price-history records.

The model uses surrogate keys to identify dimension records independently of their operational business identifiers.

This supports historical tracking and enables fact records to reference the appropriate dimensional records.

## 3. Dimension Tables

| Dimension | Business key | Surrogate key | Historical tracking |
|---|---|---|---|
| `dim_customer` | `customer_id` | `customer_key` | SCD Type 2 |
| `dim_product` | `product_id` | `product_key` | SCD Type 2 |
| `dim_supplier` | `supplier_id` | `supplier_key` | SCD Type 2 |
| `dim_employee` | `employee_id` | `employee_key` | SCD Type 2 |
| `dim_store` | `store_id` | `store_key` | SCD Type 2 |
| `dim_date` | Calendar date | `date_key` | Not applicable |

### 3.1 Customer Dimension

`dim_customer` stores descriptive information about customers.

The dimension uses `customer_key` as its surrogate primary key and retains `customer_id` as the source business identifier.

SCD Type 2 columns allow multiple historical versions of a customer to be represented when tracked attributes change.

### 3.2 Product Dimension

`dim_product` stores product-related descriptive information.

It uses `product_key` as the surrogate key and `product_id` as the operational identifier.

The product dimension also supports historical tracking of product attributes and supplier associations.

### 3.3 Supplier Dimension

`dim_supplier` stores supplier information.

Each supplier is identified by a surrogate key, while the original `supplier_id` is retained for source-system traceability.

Supplier information can be associated with product records through the dimensional model.

### 3.4 Employee Dimension

`dim_employee` stores descriptive employee information.

It supports historical tracking of employee attributes using SCD Type 2.

The dimension is referenced by the sales and payment fact tables.

### 3.5 Store Dimension

`dim_store` stores descriptive information about NovaMart stores.

It supports analysis of sales and payment activity by store while preserving historical versions of tracked store attributes.

### 3.6 Date Dimension

`dim_date` is a shared calendar dimension.

It contains 730 calendar records covering:

- Start date: 2025-01-01
- End date: 2026-12-31

The date dimension provides consistent calendar references for warehouse fact tables.

Unlike the five business dimensions, `dim_date` does not use SCD Type 2.

## 4. Fact Tables and Grain

The grain defines what one row in a fact table represents.

Establishing the grain is important because it determines how measures can be aggregated and how fact records relate to dimensions.

| Fact table | Grain | Source identifier |
|---|---|---|
| `fact_sales` | One row per order item | `order_item_id` |
| `fact_payment` | One row per payment record | `payment_id` |
| `fact_product_pricehistory` | One row per product price-history record | `price_history_id` |

### 4.1 Sales Fact

`fact_sales` records individual order-item transactions.

**Grain:** One row per order item.

Key columns include:

- `sales_key`
- `order_id`
- `order_item_id`
- `customer_key`
- `product_key`
- `employee_key`
- `store_key`
- `date_key`

Measures include:

- `quantity`
- `unit_price`
- `discount_amount`
- `sales_amount`

The sales amount is calculated as:

`quantity × unit_price − COALESCE(discount_amount, 0)`

The source `order_item_id` is unique within the sales fact, preventing the same order item from being represented more than once.

### 4.2 Payment Fact

`fact_payment` records payment transactions associated with orders.

**Grain:** One row per payment record.

Key columns include:

- `payment_key`
- `payment_id`
- `order_id`
- `customer_key`
- `employee_key`
- `store_key`
- `date_key`

Other attributes include:

- `payment_amount`
- `payment_method`
- `payment_status`

The model retains payment statuses such as Completed, Pending, Failed, and Refunded.

This distinction is important because not every payment record represents successfully collected revenue.

### 4.3 Product Price-History Fact

`fact_product_pricehistory` preserves historical product-pricing records.

**Grain:** One row per product price-history record.

Key columns include:

- `price_history_key`
- `price_history_id`
- `product_key`
- `effective_from_date_key`
- `effective_to_date_key`

Other attributes include:

- `unit_price`
- `effective_status`

The start and end date keys reference the shared date dimension.

The end date is nullable for currently effective price records.

The warehouse preserves three price-history records with NULL product surrogate keys because their effective dates precede the available product-dimension baseline. These are documented exceptions rather than invented historical product versions.

## 5. Slowly Changing Dimension Type 2

SCD Type 2 is used to preserve historical changes to descriptive business attributes.

NovaMart implements SCD Type 2 across five dimensions:

1. `dim_customer`
2. `dim_product`
3. `dim_supplier`
4. `dim_employee`
5. `dim_store`

The historical tracking structure uses:

| Column | Purpose |
|---|---|
| `valid_from` | Beginning of a dimension version's validity |
| `valid_to` | End of the version's validity |
| `is_current` | Identifies the current version |

The implementation uses a half-open validity interval:

`[valid_from, valid_to)`

This means the start timestamp is included, while the end timestamp is excluded.

The initial dimension load uses the baseline timestamp:

`2025-06-01 00:00:00`

The initial loaded versions are marked current.

**Historical limitation:** This baseline does not represent a reconstruction of every historical attribute change before the initial load.

The SCD Type 2 design supports historical versioning, but the initial dataset should not be described as containing historical snapshots that were never available in the source.

## 6. Fact-to-Dimension Relationships

The warehouse fact tables reference their corresponding dimensions through surrogate keys.

| Fact table | Referenced dimensions |
|---|---|
| `fact_sales` | Customer, Product, Employee, Store, Date |
| `fact_payment` | Customer, Employee, Store, Date |
| `fact_product_pricehistory` | Product, Date |

The product-to-supplier association is represented through the product dimension.

Consequently, supplier-related sales analysis can follow the relationship:

`fact_sales → dim_product → dim_supplier`

The sales fact does not contain a separate `supplier_key`.

The date dimension plays multiple roles in the price-history fact through effective-start and effective-end date references.

## 7. Warehouse Load Results

The initial warehouse load produced the following record counts.

### Dimensions

| Dimension | Loaded records |
|---|---:|
| `dim_customer` | 20 |
| `dim_product` | 21 |
| `dim_supplier` | 10 |
| `dim_employee` | 15 |
| `dim_store` | 5 |
| `dim_date` | 730 |

### Facts

| Fact table | Loaded records |
|---|---:|
| `fact_sales` | 50 |
| `fact_payment` | 31 |
| `fact_product_pricehistory` | 18 |

The sales fact contains a validated total sales amount of **₦302,918**.

These counts describe the documented initial warehouse load, not a continuously refreshed production environment.

## 8. Data Integrity Considerations

The dimensional design incorporates several integrity controls.

These include:

- Primary keys for dimension and fact records.
- Unique source transaction identifiers within fact tables.
- Foreign-key relationships between facts and dimensions.
- Constraints on numerical measures and permitted status values.
- SCD Type 2 current-version and validity-period checks.
- Validation of dimension-key references.

The product price-history fact also retains documented exceptions where a historical product version cannot be matched to the available dimension baseline.

These exceptions are preserved rather than assigned unsupported surrogate keys.

## 9. Design Considerations

The dimensional model makes several deliberate design choices.

**Surrogate keys:** Dimension versions can be identified independently of operational business identifiers.

**Fact grain:** Each fact table has an explicitly defined grain to reduce ambiguity during aggregation.

**Historical tracking:** Five dimensions support SCD Type 2 validity periods.

**Shared dates:** A single date dimension provides consistent calendar references across fact tables.

**Source traceability:** Operational identifiers are retained where necessary to connect warehouse records to their sources.

**Known limitations:** Unresolved source-data exceptions and incomplete pre-baseline historical coverage remain documented.

## 10. Conclusion

The NovaMart dimensional model provides a structured foundation for transforming operational retail data into a queryable warehouse.

The implementation separates descriptive dimensions from transactional facts, defines fact-table grain, supports historical attribute tracking, and maintains referential relationships.

This dimensional design forms the foundation for the subsequent SQL ETL implementation, warehouse validation, and analytical validation stages.
