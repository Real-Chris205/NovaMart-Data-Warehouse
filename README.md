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

The documentation is organised into stages so readers can follow the project from its initial database design through warehouse implementation.

| No. | Documentation | Description |
|---|---|---|
| 01 | [Project Overview](docs/01-project-overview.md) | Project background, objectives, and scope. |
| 02 | [OLTP Database Design](docs/02-oltp-database-design.md) | Operational database structure, tables, and relationships. |
| 03 | [Data Quality Audit](docs/03-data-quality-audit.md) | SQL-based data-quality checks and audit findings. |
| 04 | [Data Cleaning and Remediation](docs/04-data-cleaning-and-remediation.md) | Investigation, root-cause assessment, and remediation decisions. |
| 05 | [Data Warehouse Architecture](docs/05-data-warehouse-architecture.md) | Warehouse architecture, dimensions, facts, and relationships. |

*Further documentation will be added as the remaining implementation stages are documented.*

## Key Implementation Highlights

- 14 operational OLTP tables.
- 6 dimension tables.
- 3 fact tables.
- SCD Type 2 implemented across 5 dimensions.
- A shared calendar dimension.
- SQL-based ETL transformations.
- Fact and dimension validation.
- SQL analytical validation.

## Project Scope

This repository focuses on Data Engineering.

The main deliverables are database design, data-quality investigation, dimensional modelling, ETL implementation, and warehouse validation.

Analytical SQL queries are included as a way to demonstrate that the warehouse supports consistent business queries. Dashboard development and BI reporting are outside the project's scope.

## Repository Structure

```text
NovaMart-Data-Warehouse/
│
├── README.md
│
└── docs/
    ├── 01-project-overview.md
    ├── 02-oltp-database-design.md
    ├── 03-data-quality-audit.md
    ├── 04-data-cleaning-and-remediation.md
    └── 05-data-warehouse-architecture.md
```

## Project Status

<badge>In Progress</badge>

The project documentation and implementation evidence are being organised stage by stage. Additional SQL scripts, diagrams, ETL documentation, and validation evidence will be added as the repository develops.</textarea>
