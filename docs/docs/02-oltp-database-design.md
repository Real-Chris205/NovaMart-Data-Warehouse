# 02. OLTP Database Design

## 1. Introduction

The NovaMart OLTP (Online Transaction Processing) database was designed and implemented from scratch using PostgreSQL.

The database represents the operational data environment of a fictional e-commerce business, NovaMart. It was designed to support core business operations, including customer management, product management, supplier relationships, store operations, employee records, order processing, payments, and product price history.

The OLTP database serves as the source system for the downstream dimensional data warehouse developed in this project.

## 2. Design Objectives

The primary objectives of the OLTP database design were to:

- Model the core operational activities of an e-commerce business.
- Establish clear relationships between business entities.
- Enforce data integrity through primary keys and foreign keys.
- Define appropriate constraints and business rules.
- Reduce unnecessary data duplication through relational modelling.
- Provide a structured source database for subsequent data quality assessment and warehouse development.

## 3. Database Technology

| Component | Technology |
|---|---|
| Database Management System | PostgreSQL |
| Database Administration Tool | pgAdmin 4 |
| Query Language | SQL |
| Database Type | Relational OLTP Database |

## 4. Operational Data Model

The database was structured around key business entities and transactional processes.

The major entities include:

- Customers
- Products
- Suppliers
- Employees
- Stores
- Orders
- Order Items
- Payments
- Product Price History

These entities establish the operational relationships required to represent NovaMart's business activities.

## 5. Relational Database Design

The database uses primary keys to uniquely identify records and foreign keys to establish relationships between related entities.

Examples of these relationships include:

- A customer can place multiple orders.
- An order can contain multiple order items.
- A product can appear in multiple order items.
- A supplier can supply multiple products.
- A store can be associated with multiple orders.
- An order can have multiple payment records.
- A product can have multiple price-history records.

These relationships establish the foundation for maintaining referential integrity across the operational database.

## 6. Data Integrity and Business Rules

The OLTP schema incorporates relational integrity through primary keys and foreign keys, alongside business rules governing operational records.

The design also accounts for product pricing history, order processing, customer registration, and product launch dates.

These rules later formed the basis of the data quality audit performed before warehouse development.

## 7. Role in the Data Engineering Pipeline

The OLTP database serves as the source layer of the NovaMart Data Engineering project.

Its operational records were used for:

1. Data quality assessment.
2. Identification of data inconsistencies.
3. Root-cause investigation.
4. Remediation decisions.
5. Extraction and transformation.
6. Loading into the dimensional data warehouse.

## 8. Engineering Outcome

The OLTP database established a relational foundation for the NovaMart project.

Designing the database from scratch provided control over the business entities, relationships, constraints, and operational rules required for subsequent data quality assessment and data warehouse implementation.
