# 10. Conclusion and Recommendations

## 1. Project Conclusion

The NovaMart Data Warehouse project demonstrates the process of designing a relational OLTP database, investigating data-quality issues, developing a dimensional data warehouse, implementing SQL-based ETL, and validating the resulting warehouse.

The project began with the design of a 14-table OLTP database. Data-quality audits were then performed to identify inconsistencies and investigate their possible causes. Rather than modifying records without sufficient evidence, findings were assessed and documented, with source verification recommended where the correct values could not be established.

The dimensional warehouse was subsequently designed using six dimensions and three fact tables. Five dimensions use Slowly Changing Dimension Type 2 (SCD Type 2) to support historical attribute tracking from the established baseline.

SQL-based ETL was implemented in PostgreSQL to populate the dimensions and fact tables. Validation checks were then performed to assess fact-table loading, grain, uniqueness, measures, dimension integrity, SCD Type 2 consistency, referential integrity, and source-to-warehouse coverage.

The final analytical validation demonstrated that the warehouse supports monthly, product, store, and category sales aggregations. Each aggregation reconciled to the validated `fact_sales` total of **₦302,918**.

## 2. Key Project Outcomes

The project achieved the following:

- Designed a relational OLTP database containing 14 tables.
- Performed data-quality audits and investigated identified inconsistencies.
- Documented findings and remediation decisions without making unsupported source-data corrections.
- Designed a dimensional warehouse containing six dimensions and three fact tables.
- Implemented five SCD Type 2 dimensions.
- Created a shared date dimension containing 730 dates, covering 1 January 2025 to 31 December 2026.
- Implemented SQL-based ETL using PostgreSQL.
- Loaded and validated 50 sales records, 31 payment records, and 18 product price-history records.
- Performed warehouse integrity and source-to-warehouse reconciliation checks.
- Executed four analytical SQL queries to demonstrate dimensional aggregation.

## 3. Known Limitations

The following limitations remain important when interpreting the warehouse results.

### 3.1 Historical Dimension Baseline

The five SCD Type 2 dimensions use a baseline date of 1 June 2025. The design does not reconstruct complete historical changes to customers, products, employees, stores, or suppliers before that date.

### 3.2 Product Price-History Exception

Three product price-history records have effective dates before the product dimension baseline. These records were preserved in `fact_product_pricehistory` with NULL product surrogate keys rather than being assigned invented historical dimension versions.

Consequently, those three records cannot be reliably attributed to a product dimension version for historical analysis.

### 3.3 Unresolved OLTP Data-Quality Findings

Some source-data inconsistencies remain unresolved because authoritative source information was not available to establish the correct values.

These findings were documented and retained for source verification rather than being changed speculatively.

### 3.4 ETL Implementation Scope

The ETL was implemented using SQL statements executed in PostgreSQL. The project does not currently implement a scheduled incremental loading process, automated orchestration, or a production change-data-capture mechanism.

## 4. Recommendations and Future Improvements

The following improvements are recommended for a future version of the project.

### 4.1 Strengthen Source-System Data Quality

- Verify unresolved data-quality findings against authoritative source records.
- Introduce appropriate business rules and validation constraints where confirmed.
- Maintain a record of data-quality findings and their resolution status.

### 4.2 Improve Historical Data Capture

- Obtain reliable historical source records where available.
- Extend the SCD Type 2 implementation when trustworthy historical changes become available.
- Review the product price-history baseline so that older records can be associated with valid historical product versions when evidence supports doing so.

### 4.3 Develop Incremental ETL

- Extend the current SQL loading process to support incremental data loading.
- Track newly inserted and updated source records.
- Implement controlled SCD Type 2 change handling for future dimension changes.
- Add mechanisms to prevent duplicate fact loading during repeated executions.

### 4.4 Improve Pipeline Reliability and Monitoring

- Introduce automated execution and scheduling.
- Add ETL logging and error handling.
- Record load timestamps, row counts, and failed operations.
- Introduce monitoring to make pipeline failures easier to identify and investigate.

### 4.5 Expand Warehouse Testing

- Add repeatable validation tests for future ETL runs.
- Test incremental loads and historical dimension changes.
- Continue checking fact-table grain, dimensional relationships, and source-to-warehouse reconciliation after each load.

## 5. Final Assessment

The NovaMart project demonstrates an end-to-end data engineering workflow, from relational database design and data-quality investigation to dimensional modeling, SQL-based ETL, and warehouse validation.

The recorded warehouse validation checks passed, subject to the documented product price-history exception and the historical baseline limitation.

The project also demonstrates an important data-engineering principle: data should not be changed simply because a query identifies an inconsistency. Findings must be investigated, business context considered, and corrections supported by reliable evidence.

The resulting warehouse provides a validated foundation for dimensional SQL analysis within the documented scope and limitations.

**Project status:** Core warehouse design, ETL implementation, validation, and analytical validation completed. Future improvements remain as recommendations rather than implemented features.
