-- =====================================================
-- NovaMart Data Warehouse
-- Fact Table Creation
-- =====================================================


-- 1. FACT PRODUCT PRICE HISTORY

CREATE TABLE Fact_Product_PriceHistory (
    price_history_key INT PRIMARY KEY,
    price_history_id INT NOT NULL UNIQUE,
    product_key INT NULL,
    effective_from_date_key INT NOT NULL,
    effective_to_date_key INT NULL,

    unit_price DECIMAL(10,2) NOT NULL
        CHECK (unit_price > 0),

    effective_status CHAR(1) NOT NULL
        CHECK (effective_status IN ('Y', 'N')),

    CONSTRAINT chk_fact_price_history_status
        CHECK (
            (effective_status = 'Y'
                AND effective_to_date_key IS NULL)
            OR
            (effective_status = 'N'
                AND effective_to_date_key IS NOT NULL)
        ),

    CONSTRAINT fk_fact_price_history_product
        FOREIGN KEY (product_key)
        REFERENCES Dim_product(product_key),

    CONSTRAINT fk_fact_price_history_effective_from
        FOREIGN KEY (effective_from_date_key)
        REFERENCES Dim_date(date_key),

    CONSTRAINT fk_fact_price_history_effective_to
        FOREIGN KEY (effective_to_date_key)
        REFERENCES Dim_date(date_key)
);


-- 2. FACT PAYMENT

CREATE TABLE Fact_payment (
    payment_key INT PRIMARY KEY,
    payment_id INT NOT NULL UNIQUE,
    order_id INT NOT NULL,
    customer_key INT NOT NULL,
    employee_key INT NOT NULL,
    store_key INT NOT NULL,
    date_key INT NOT NULL,

    payment_amount DECIMAL(10,2) NOT NULL
        CHECK (payment_amount > 0),

    payment_method VARCHAR(50) NOT NULL
        CHECK (payment_method IN (
            'Cash',
            'Card',
            'Bank Transfer'
        )),

    payment_status VARCHAR(50) NOT NULL
        CHECK (payment_status IN (
            'Pending',
            'Completed',
            'Failed',
            'Refunded'
        )),

    FOREIGN KEY (customer_key)
        REFERENCES Dim_customer(customer_key),

    FOREIGN KEY (employee_key)
        REFERENCES Dim_employee(employee_key),

    FOREIGN KEY (store_key)
        REFERENCES Dim_store(store_key),

    FOREIGN KEY (date_key)
        REFERENCES Dim_date(date_key)
);


-- 3. FACT SALES

CREATE TABLE Fact_sales (
    sales_key INT PRIMARY KEY,
    order_id INT NOT NULL,
    order_item_id INT NOT NULL UNIQUE,

    customer_key INT NOT NULL,
    product_key INT NOT NULL,
    employee_key INT NOT NULL,
    store_key INT NOT NULL,
    date_key INT NOT NULL,

    quantity INT NOT NULL
        CHECK (quantity > 0),

    unit_price DECIMAL(10,2) NOT NULL
        CHECK (unit_price > 0),

    discount_amount DECIMAL(10,2) NULL,

    sales_amount DECIMAL(10,2) NOT NULL
        CHECK (sales_amount > 0),

    FOREIGN KEY (customer_key)
        REFERENCES Dim_customer(customer_key),

    FOREIGN KEY (product_key)
        REFERENCES Dim_product(product_key),

    FOREIGN KEY (employee_key)
        REFERENCES Dim_employee(employee_key),

    FOREIGN KEY (store_key)
        REFERENCES Dim_store(store_key),

    FOREIGN KEY (date_key)
        REFERENCES Dim_date(date_key)
);
