
-- ============================================================
-- NovaMart Data Warehouse
-- Dimension Table Creation
-- ============================================================

-- Required extension for SCD Type 2 exclusion constraints
CREATE EXTENSION IF NOT EXISTS btree_gist;


-- 1. CUSTOMER DIMENSION

CREATE TABLE Dim_customer (
    customer_key INT PRIMARY KEY,
    customer_id INT NOT NULL,
    customer_name VARCHAR(200) NOT NULL,
    email VARCHAR(200) NOT NULL,
    phone VARCHAR(100) NOT NULL,
    gender VARCHAR(100)
        CHECK (gender IN ('Male', 'Female')),
    city VARCHAR(100) NOT NULL,
    country VARCHAR(100) NOT NULL,
    registration_date DATE NOT NULL,
    customer_segment VARCHAR(100) NULL,
    valid_from TIMESTAMP NOT NULL,
    valid_to TIMESTAMP NULL,
    is_current CHAR(1) NOT NULL
        CHECK (is_current IN ('Y', 'N')),

    CONSTRAINT chk_dim_customer_valid_period
        CHECK (
            valid_to IS NULL
            OR valid_to > valid_from
        ),

    CONSTRAINT chk_dim_customer_current_status
        CHECK (
            (is_current = 'Y' AND valid_to IS NULL)
            OR
            (is_current = 'N' AND valid_to IS NOT NULL)
        ),

    CONSTRAINT ex_dim_customer_no_overlapping_periods
        EXCLUDE USING gist (
            customer_id WITH =,
            (tsrange(
                valid_from,
                COALESCE(valid_to, 'infinity'::timestamp),
                '[)'
            )) WITH &&
        )
);


-- 2. SUPPLIER DIMENSION

CREATE TABLE Dim_supplier (
    supplier_key INT PRIMARY KEY,
    supplier_id INT NOT NULL,
    supplier_name VARCHAR(200) NOT NULL,
    email VARCHAR(200) NULL,
    phone VARCHAR(100) NULL,
    address VARCHAR(200) NOT NULL,
    valid_from TIMESTAMP NOT NULL,
    valid_to TIMESTAMP NULL,
    is_current CHAR(1) NOT NULL
        CHECK (is_current IN ('Y', 'N')),

    CONSTRAINT chk_dim_supplier_valid_period
        CHECK (
            valid_to IS NULL
            OR valid_to > valid_from
        ),

    CONSTRAINT chk_dim_supplier_current_status
        CHECK (
            (is_current = 'Y' AND valid_to IS NULL)
            OR
            (is_current = 'N' AND valid_to IS NOT NULL)
        ),

    CONSTRAINT ex_dim_supplier_no_overlapping_periods
        EXCLUDE USING gist (
            supplier_id WITH =,
            (tsrange(
                valid_from,
                COALESCE(valid_to, 'infinity'::timestamp),
                '[)'
            )) WITH &&
        )
);


-- 3. EMPLOYEE DIMENSION

CREATE TABLE Dim_employee (
    employee_key INT PRIMARY KEY,
    employee_id INT NOT NULL,
    employee_name VARCHAR(200) NOT NULL,
    job_title VARCHAR(200) NOT NULL,
    department_name VARCHAR(200) NOT NULL,
    email VARCHAR(100) NOT NULL,
    phone VARCHAR(100) NOT NULL,
    hire_date DATE NOT NULL,
    valid_from TIMESTAMP NOT NULL,
    valid_to TIMESTAMP NULL,
    is_current CHAR(1) NOT NULL
        CHECK (is_current IN ('Y', 'N')),

    CONSTRAINT chk_dim_employee_valid_period
        CHECK (
            valid_to IS NULL
            OR valid_to > valid_from
        ),

    CONSTRAINT chk_dim_employee_current_status
        CHECK (
            (is_current = 'Y' AND valid_to IS NULL)
            OR
            (is_current = 'N' AND valid_to IS NOT NULL)
        ),

    CONSTRAINT ex_dim_employee_no_overlapping_periods
        EXCLUDE USING gist (
            employee_id WITH =,
            (tsrange(
                valid_from,
                COALESCE(valid_to, 'infinity'::timestamp),
                '[)'
            )) WITH &&
        )
);


-- 4. STORE DIMENSION

CREATE TABLE Dim_store (
    store_key INT PRIMARY KEY,
    store_id INT NOT NULL,
    store_name VARCHAR(200) NOT NULL,
    city VARCHAR(100) NOT NULL,
    state VARCHAR(200) NOT NULL,
    country VARCHAR(200) NOT NULL,
    region VARCHAR(200) NOT NULL,
    valid_from TIMESTAMP NOT NULL,
    valid_to TIMESTAMP NULL,
    is_current CHAR(1) NOT NULL
        CHECK (is_current IN ('Y', 'N')),

    CONSTRAINT chk_dim_store_valid_period
        CHECK (
            valid_to IS NULL
            OR valid_to > valid_from
        ),

    CONSTRAINT chk_dim_store_current_status
        CHECK (
            (is_current = 'Y' AND valid_to IS NULL)
            OR
            (is_current = 'N' AND valid_to IS NOT NULL)
        ),

    CONSTRAINT ex_dim_store_no_overlapping_periods
        EXCLUDE USING gist (
            store_id WITH =,
            (tsrange(
                valid_from,
                COALESCE(valid_to, 'infinity'::timestamp),
                '[)'
            )) WITH &&
        )
);


-- 5. PRODUCT DIMENSION

CREATE TABLE Dim_product (
    product_key INT PRIMARY KEY,
    product_id INT NOT NULL,
    product_name VARCHAR(200) NOT NULL,
    brand_name VARCHAR(200) NOT NULL,
    category_name VARCHAR(100) NOT NULL,
    supplier_key INT NOT NULL,
    unit_cost DECIMAL(10,2) NOT NULL,
    unit_price DECIMAL(10,2) NOT NULL,
    color VARCHAR(50),
    size VARCHAR(50),
    launch_date DATE NOT NULL,
    discontinued_flag CHAR(1) NOT NULL
        CHECK (discontinued_flag IN ('Y', 'N')),
    valid_from TIMESTAMP NOT NULL,
    valid_to TIMESTAMP NULL,
    is_current CHAR(1) NOT NULL
        CHECK (is_current IN ('Y', 'N')),

    CONSTRAINT chk_dim_product_valid_period
        CHECK (
            valid_to IS NULL
            OR valid_to > valid_from
        ),

    CONSTRAINT chk_dim_product_current_status
        CHECK (
            (is_current = 'Y' AND valid_to IS NULL)
            OR
            (is_current = 'N' AND valid_to IS NOT NULL)
        ),

    CONSTRAINT ex_dim_product_no_overlapping_periods
        EXCLUDE USING gist (
            product_id WITH =,
            (tsrange(
                valid_from,
                COALESCE(valid_to, 'infinity'::timestamp),
                '[)'
            )) WITH &&
        ),

    FOREIGN KEY (supplier_key)
        REFERENCES Dim_supplier(supplier_key)
);


-- 6. DATE DIMENSION

CREATE TABLE Dim_date (
    date_key INT PRIMARY KEY,
    full_date DATE NOT NULL,
    day INT NOT NULL
        CHECK (day BETWEEN 1 AND 31),
    month INT NOT NULL
        CHECK (month BETWEEN 1 AND 12),
    month_name VARCHAR(100) NOT NULL,
    quarter INT NOT NULL
        CHECK (quarter BETWEEN 1 AND 4),
    quarter_name VARCHAR(50) NOT NULL,
    year INT NOT NULL,
    day_name VARCHAR(50) NOT NULL,
    day_of_week INT NOT NULL
        CHECK (day_of_week BETWEEN 1 AND 7),
    week_of_year INT NOT NULL
        CHECK (week_of_year BETWEEN 1 AND 53),
    is_weekend CHAR(1) NOT NULL
        CHECK (is_weekend IN ('Y', 'N')),
    year_month VARCHAR(50) NOT NULL,

    CONSTRAINT uq_dim_date_full_date
        UNIQUE (full_date)
);

-- NOTE:
-- Y = Weekend
-- N = Weekday
