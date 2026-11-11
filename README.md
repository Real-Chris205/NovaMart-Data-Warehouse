# NovaMart Data Warehouse

An end-to-end Data Engineering project built with PostgreSQL and SQL, covering OLTP database design, data-quality auditing, dimensional modelling, ETL implementation, and data warehouse validation.

## Project Overview

NovaMart is a fictional retail business used to demonstrate the design and implementation of a relational operational database and a dimensional data warehouse.

The project follows a structured data engineering workflow, beginning with the operational database and progressing through data-quality investigations, warehouse design, SQL-based transformations, and validation.

The OLTP and dimensional warehouse tables were implemented within the same PostgreSQL database.

## Project Objectives

- Design a relational OLTP database from scratch.
- Identify data-quality issues through SQL-based audits.
- Investigate exceptions and document remediation decisions.
- Design a dimensional data warehouse.
- Implement historical tracking using Slowly Changing Dimension Type 2 (SCD Type 2).
- Build SQL-based ETL transformations.
- Validate dimension and fact table integrity.
- Perform SQL analytical queries to demonstrate warehouse functionality.

## Technology Stack

| Technology | Purpose |
|---|---|
| PostgreSQL | Database management system |
| SQL | Database design, auditing, transformations, and validation |
| pgAdmin 4 | Database administration and SQL execution |
| GitHub | Version control and project documentation |

## Project Architecture

The project follows this end-to-end workflow:

1. **OLTP Database Design** – Design and implement the operational relational database.
2. **Data Quality Auditing** – Run SQL checks to identify inconsistencies and integrity issues.
3. **Investigation and Remediation** – Investigate findings, assess their impact, and document remediation decisions.
4. **Data Warehouse Design** – Develop the dimensional model with fact and dimension tables.
5. **ETL Implementation** – Transform and load operational data into the warehouse using SQL.
6. **Data Warehouse Validation** – Validate dimensions, facts, relationships, and data consistency.
7. **Analytical Validation** – Run SQL queries to demonstrate warehouse functionality.

## Project Documentation

The documentation is organised into stages so readers can follow the project from its initial database design through warehouse implementation and analytical validation.

| No. | Documentation | Description |
|---|---|---|
| 01 | [Project Overview](docs/01-project-overview.md) | Project background, objectives, and scope. |
| 02 | [OLTP Database Design](docs/02-oltp-database-design.md) | Operational database structure, tables, and relationships. |
| 03 | [Data Quality Audit](docs/03-data-quality-audit.md) | SQL-based data-quality checks and audit findings. |
| 04 | [Data Cleaning and Remediation](docs/04-data-cleaning-and-remediation.md) | Investigation, root-cause assessment, and remediation decisions. |
| 05 | [Data Warehouse Architecture](docs/05-data-warehouse-architecture.md) | Warehouse architecture, dimensions, facts, and relationships. |
| 06 | [Dimensional Modeling](docs/06-dimensional-modeling.md) | Dimensional model, fact-table grain, and dimension design. |
| 07 | [ETL Pipeline](docs/07-etl-pipeline.md) | SQL-based extraction, transformation, and loading process. |
| 08 | [Data Validation](docs/08-data-validation.md) | Fact, dimension, SCD Type 2, and referential-integrity validation. |
| 09 | [Analytical Validation](docs/09-analytical-validation.md) | SQL-based monthly, product, store, and category sales validation. |
| 10 | [Conclusion and Recommendations](docs/10-conclusion-and-recommendations.md) | Overall project findings, limitations, and recommendations. |

## Key Implementation Highlights

- 14 operational OLTP tables.
- 6 dimension tables.
- 3 fact tables.
- SCD Type 2 implemented across 5 dimensions.
- A shared calendar dimension.
- SQL-based ETL transformations.
- Fact and dimension validation.
- SQL analytical validation across monthly revenue, product sales, store sales, and category sales.

## Data Warehouse Validation Results

The warehouse validation checks passed within the scope of the tests performed.

The three fact tables contained the expected records:

| Fact table | Validated records |
|---|---:|
| fact_sales | 50 |
| fact_payment | 31 |
| fact_product_pricehistory | 18 |

The four analytical validations also passed, with each aggregation reconciling to the validated FactSales total of **₦302,918.00**.

### Documented Limitation

One warehouse exception, DQ-PH-01, remains documented.

Three product price-history records predate the `dim_product` baseline of 1 June 2025. Their product surrogate keys remain `NULL` because no valid historical dimension versions were available for the temporal lookup.

The original source records and dates were preserved rather than inventing historical dimension versions.

## Project Scope

This repository focuses on Data Engineering.

The main deliverables are database design, data-quality investigation, dimensional modelling, ETL implementation, and warehouse validation.

Analytical SQL queries are included as a way to demonstrate that the warehouse supports consistent business queries.

Dashboard development and BI reporting are outside the project's scope.

## Repository Structure

```text
NovaMart-Data-Warehouse/
│
├── README.md
│
├── docs/
│   ├── 01-project-overview.md
│   ├── 02-oltp-database-design.md
│   ├── 03-data-quality-audit.md
│   ├── 04-data-cleaning-and-remediation.md
│   ├── 05-data-warehouse-architecture.md
│   ├── 06-dimensional-modeling.md
│   ├── 07-etl-pipeline.md
│   ├── 08-data-validation.md
│   ├── 09-analytical-validation.md
│   └── 10-conclusion-and-recommendations.md
│
├── sql/
│   ├── oltp/
│   ├── audits/
│   ├── transformations/
│   ├── dimensions/
│   ├── facts/
│   └── validation/
│
└── screenshots/
```

## Project Status

**Core project implementation and validation completed.**

The OLTP audit, warehouse design, SQL-based ETL, warehouse validation, and four analytical validation exercises have been documented.

The outstanding OLTP findings and the DQ-PH-01 warehouse limitation remain explicitly documented for transparency.
