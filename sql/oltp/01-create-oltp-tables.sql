-- =====================================================
-- NovaMart OLTP Database
-- Table Creation Script
-- =====================================================

-- 1. Customer Segment
CREATE TABLE customer_segment (
    segment_id INT PRIMARY KEY,
    segment_name VARCHAR(20) NOT NULL UNIQUE
);

-- 2. Brand
CREATE TABLE brand (
    brand_id INT PRIMARY KEY,
    brand_name VARCHAR(100) NOT NULL UNIQUE
);

-- 3. Category
CREATE TABLE category (
    category_id INT PRIMARY KEY,
    category_name VARCHAR(100) NOT NULL UNIQUE
);

-- 4. Supplier
CREATE TABLE supplier (
    supplier_id INT PRIMARY KEY,
    supplier_name VARCHAR(100) NOT NULL UNIQUE,
    email VARCHAR(100) NOT NULL UNIQUE,
    phone VARCHAR(25) NOT NULL UNIQUE,
    address VARCHAR(225) NOT NULL
);

-- 5. Job
CREATE TABLE job (
    job_id INT PRIMARY KEY,
    job_title VARCHAR(100) NOT NULL UNIQUE
);

-- 6. Department
CREATE TABLE department (
    department_id INT PRIMARY KEY,
    department_name VARCHAR(100) NOT NULL UNIQUE
);

-- 7. Store
CREATE TABLE store (
    store_id INT PRIMARY KEY,
    store_name VARCHAR(200) NOT NULL UNIQUE,
    city VARCHAR(200) NOT NULL,
    state VARCHAR(200) NOT NULL,
    country VARCHAR(200) NOT NULL,
    region VARCHAR(200)
);

-- 8. Customers
CREATE TABLE customers (
    customer_id INT PRIMARY KEY,
    customer_name VARCHAR(200) NOT NULL,
    email VARCHAR(300) UNIQUE,
    phone VARCHAR(30) UNIQUE,
    gender VARCHAR(10)
        CHECK (gender IN ('Male', 'Female')),
    city VARCHAR(100) NOT NULL,
    country VARCHAR(100) NOT NULL,
    registration_date DATE NOT NULL,
    segment_id INT,

    FOREIGN KEY (segment_id)
        REFERENCES customer_segment(segment_id)
);

-- 9. Products
CREATE TABLE products (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(200) NOT NULL,
    brand_id INT NOT NULL,
    category_id INT NOT NULL,
    supplier_id INT NOT NULL,
    unit_cost DECIMAL(10,2) NOT NULL,
    unit_price DECIMAL(10,2) NOT NULL,
    color VARCHAR(100) NULL,
    size VARCHAR(100) NULL,
    launch_date DATE NOT NULL,
    discontinued_flag CHAR(1) NOT NULL
        CHECK (discontinued_flag IN ('Y', 'N')),

    FOREIGN KEY (brand_id)
        REFERENCES brand(brand_id),

    FOREIGN KEY (category_id)
        REFERENCES category(category_id),

    FOREIGN KEY (supplier_id)
        REFERENCES supplier(supplier_id)
);

-- 10. Employee
CREATE TABLE employee (
    employee_id INT PRIMARY KEY,
    employee_name VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    phone VARCHAR(100) NOT NULL UNIQUE,
    job_id INT NOT NULL,
    hire_date DATE NOT NULL,
    department_id INT NOT NULL,

    FOREIGN KEY (job_id)
        REFERENCES job(job_id),

    FOREIGN KEY (department_id)
        REFERENCES department(department_id)
);

-- 11. Orders
CREATE TABLE orders (
    order_id INT PRIMARY KEY,
    customer_id INT NOT NULL,
    employee_id INT NOT NULL,
    store_id INT NOT NULL,
    order_date DATE NOT NULL,
    order_status VARCHAR(50) NOT NULL
        CHECK (order_status IN (
            'Pending',
            'Processing',
            'Shipped',
            'Delivered',
            'Cancelled'
        )),

    FOREIGN KEY (customer_id)
        REFERENCES customers(customer_id),

    FOREIGN KEY (employee_id)
        REFERENCES employee(employee_id),

    FOREIGN KEY (store_id)
        REFERENCES store(store_id)
);

-- 12. Order Item
CREATE TABLE order_item (
    order_item_id INT PRIMARY KEY,
    order_id INT NOT NULL,
    product_id INT NOT NULL,
    quantity INT NOT NULL
        CHECK (quantity > 0),
    unit_price DECIMAL(10,2) NOT NULL,
    discount DECIMAL(10,2)
        CHECK (discount >= 0),

    FOREIGN KEY (order_id)
        REFERENCES orders(order_id),

    FOREIGN KEY (product_id)
        REFERENCES products(product_id)
);

-- 13. Payment
CREATE TABLE payment (
    payment_id INT PRIMARY KEY,
    order_id INT NOT NULL,
    payment_method VARCHAR(50) NOT NULL
        CHECK (payment_method IN (
            'Cash',
            'Card',
            'Bank Transfer'
        )),
    payment_amount DECIMAL(10,2) NOT NULL
        CHECK (payment_amount > 0),
    payment_date DATE NOT NULL,
    payment_status VARCHAR(50) NOT NULL
        CHECK (payment_status IN (
            'Pending',
            'Completed',
            'Failed',
            'Refunded'
        )),

    FOREIGN KEY (order_id)
        REFERENCES orders(order_id)
);

-- 14. Product Price History
CREATE TABLE product_price_history (
    price_history_id INT PRIMARY KEY,
    product_id INT NOT NULL,
    unit_price DECIMAL(10,2) NOT NULL
        CHECK (unit_price > 0),
    effective_from DATE NOT NULL,
    effective_to DATE,
    effective_status CHAR(1) NOT NULL
        CHECK (effective_status IN ('Y', 'N')),

    CHECK (
        effective_to IS NULL
        OR effective_to >= effective_from
    ),

    CHECK (
        (effective_status = 'Y' AND effective_to IS NULL)
        OR
        (effective_status = 'N' AND effective_to IS NOT NULL)
    ),

    FOREIGN KEY (product_id)
        REFERENCES products(product_id)
);
