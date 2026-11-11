# NovaMart Analytical Validation

## 1. Overview

Following the successful validation of the dimensional warehouse, four SQL-based analytical queries were performed to demonstrate that the warehouse supports business-oriented analysis.

The queries used the dimensional model to analyse sales performance across different business perspectives:

1. Monthly revenue.
2. Product revenue.
3. Store revenue.
4. Category revenue.

The purpose of this stage was to demonstrate the practical use of the fact and dimension tables and verify that the aggregated revenue consistently reconciled with the validated sales fact.

This stage focuses on SQL-based analytical validation rather than dashboard development or BI reporting.

## 2. Monthly Revenue Analysis

**Analysis:** Monthly revenue aggregation.

**Tables used:** `fact_sales` and `dim_date`.

The query joined the sales fact to the shared date dimension to aggregate sales revenue by year and month.

### Results

| Metric | Result |
|---|---:|
| Monthly records returned | 10 |
| Total revenue | ₦302,918 |

### Validation

The aggregated monthly revenue reconciled with the previously validated total in `fact_sales`.

### Conclusion

The warehouse successfully supports time-based revenue aggregation through its shared date dimension.

## 3. Product Revenue Analysis

**Analysis:** Product sales aggregation.

**Tables used:** `fact_sales` and `dim_product`.

The query joined the sales fact to the product dimension to calculate revenue by product.

### Results

| Metric | Result |
|---|---:|
| Products returned | 21 |
| Highest revenue product | Xiaomi SU7 Ultra |
| Highest product revenue | ₦157,000 |
| Second-highest product | Xiaomi SU7 Pro |
| Second-highest product revenue | ₦87,100 |
| Lowest revenue product | iPhone 16 Pro Max Case |
| Lowest product revenue | ₦10 |
| Total revenue | ₦302,918 |

### Validation

The total product revenue reconciled with the validated `fact_sales` total.

### Conclusion

The warehouse successfully supports product-level revenue aggregation through the relationship between `fact_sales` and `dim_product`.

## 4. Store Revenue Analysis

**Analysis:** Store sales aggregation.

**Tables used:** `fact_sales` and `dim_store`.

The query joined the sales fact to the store dimension to calculate revenue by store.

### Results

| Metric | Result |
|---|---:|
| Stores returned | 5 |
| Highest revenue store | Sports store |
| Highest store revenue | ₦174,740 |
| Lowest revenue store | Shoe store |
| Lowest store revenue | ₦7,088 |
| Total revenue | ₦302,918 |

### Validation

The total store revenue reconciled with the validated `fact_sales` total.

### Conclusion

The warehouse successfully supports store-level revenue aggregation through the relationship between `fact_sales` and `dim_store`.

## 5. Category Revenue Analysis

**Analysis:** Category sales aggregation.

**Tables used:** `fact_sales` and `dim_product`.

The query joined the sales fact to the product dimension and grouped the sales revenue by product category.

### Results

| Metric | Result |
|---|---:|
| Categories returned | 7 |
| Highest revenue category | Cars |
| Highest category revenue | ₦244,100 |
| Lowest revenue category | Accessories |
| Lowest category revenue | ₦25 |
| Total revenue | ₦302,918 |

### Validation

The total category revenue reconciled with the validated `fact_sales` total.

### Conclusion

The warehouse successfully supports category-level revenue aggregation through the product dimension.

## 6. Cross-Analysis Revenue Reconciliation

The four analytical queries were independently aggregated using different business perspectives.

Their total revenue values were compared against the validated sales fact total.

| Analytical query | Total revenue |
|---|---:|
| Monthly revenue | ₦302,918 |
| Product revenue | ₦302,918 |
| Store revenue | ₦302,918 |
| Category revenue | ₦302,918 |
| Validated `fact_sales` total | ₦302,918 |

### Reconciliation result

All four analytical aggregations returned the same total revenue as the validated sales fact.

This confirmed consistency across the four analytical groupings.

## 7. Scope and Limitations

These queries were designed to demonstrate the functionality of the dimensional warehouse using SQL.

They were not intended to constitute a full business intelligence or dashboard reporting solution.

The analyses used `fact_sales` and its related dimensions. They did not attempt to reconstruct historical dimension information before the 2025-06-01 SCD Type 2 baseline.

The results should therefore be interpreted within the documented historical coverage of the warehouse.

## 8. Conclusion

The analytical validation stage demonstrated that the NovaMart dimensional warehouse supports revenue aggregation across time, products, stores, and product categories.

Each analytical query reconciled with the validated `fact_sales` total of ₦302,918.

This provided additional evidence that the fact and dimension relationships were functioning as expected for the tested analytical queries.

The project therefore demonstrated an end-to-end Data Engineering workflow, from operational database design and data-quality investigation through dimensional modelling, SQL-based ETL, warehouse validation, and analytical validation.
