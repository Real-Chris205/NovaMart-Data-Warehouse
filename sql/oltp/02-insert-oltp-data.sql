-- =====================================================
-- NovaMart OLTP Database
-- Data Insertion Script
-- =====================================================

-- 1. Insert Brand Data
INSERT INTO brand (brand_id, brand_name)
VALUES
    (1, 'Nike'),
    (2, 'Samsung'),
    (3, 'Apple'),
    (4, 'Adidas'),
    (5, 'Sony'),
    (6, 'Puma'),
    (7, 'Huwaei'),
    (8, 'Xaoimi'),
    (9, 'Gucci'),
    (10, 'Hp');

UPDATE brand
SET brand_name = 'Huawei'
WHERE brand_id = 7;

UPDATE brand
SET brand_name = 'Xiaomi'
WHERE brand_id = 8;


-- 2. Insert Category Data
INSERT INTO category (category_id, category_name)
VALUES
    (1, 'Electronics'),
    (2, 'Clothing'),
    (3, 'Footwear'),
    (4, 'Groceries'),
    (5, 'Beauty'),
    (6, 'fUrnitures'),
    (7, 'Sports'),
    (8, 'Accessories'),
    (9, 'Cars');

INSERT INTO category (category_id, category_name)
VALUES
    (10, 'Kitchen_utensils');


-- 3. Insert Supplier Data
INSERT INTO supplier (
    supplier_id,
    supplier_name,
    email,
    phone,
    address
)
VALUES
    (1, 'manga_autos', 'manga@gmail.com', '+1378829273', '1 bright street'),
    (2, 'smart_gadgets', 'smart@gmail.com', '+2399847555', '30 joint mark street'),
    (3, 'sport_wears', 'sports_w@gmail.com', '+4009586947', '28 london Street'),
    (4, 'fashion_store', 'fas_st@gmail.com', '+4678906533', '22 bridge street'),
    (5, 'foot_wears_ltd', 'foot@gmail.com', '+52467564444', '4 lookman street'),
    (6, 'best_cars', 'best@gmail.com', '+125678975654', '9 crescent street'),
    (7, 'beauty_store', 'beauty@gmail.com', '+1234545342', '10 landmark street'),
    (8, 'phone_hub_ind', 'phonehub@gmail.com', '+781635217383', '10 birmighan street'),
    (9, 'sports_world', 'sportsworld@gmail.com', '+917356286364', '11 oxford street'),
    (10, 'shoe_first', 'shoefirst@gmail.com', '+3783682638233', '5 mascot street');


-- 4. Insert Store Data
INSERT INTO store (
    store_id,
    store_name,
    city,
    state,
    country,
    region
)
VALUES
    (1, 'gadget store', 'Chicago', 'illinois', 'USA', 'North america'),
    (2, 'sports store', 'Houston', 'Texas', 'USA', 'North america'),
    (3, 'car garage', 'Lazio', 'Rome', 'Italy', 'Europe'),
    (4, 'clothe store', 'Grand Est', 'Strasbourg', 'France', 'Europe'),
    (5, 'shoe store', 'Guangzhou', 'Guangdong', 'China', 'Asia');

UPDATE store
SET city = 'Rome'
WHERE store_id = 3;

UPDATE store
SET state = 'Lazio'
WHERE store_id = 3;

UPDATE store
SET city = 'Strasbourg'
WHERE store_id = 4;

UPDATE store
SET state = 'Grand Est'
WHERE store_id = 4;


-- 5. Insert Job Data
INSERT INTO job (job_id, job_title)
VALUES
    (1, 'Store Manager'),
    (2, 'Cashier'),
    (3, 'Sales Associate'),
    (4, 'Accountant'),
    (5, 'HR Manager'),
    (6, 'Inventory Clerk'),
    (7, 'Customer Service Representative'),
    (8, 'IT Support');


-- 6. Insert Department Data
INSERT INTO department (department_id, department_name)
VALUES
    (1, 'Management'),
    (2, 'Sales'),
    (3, 'Finance'),
    (4, 'Human Resources'),
    (5, 'Inventory'),
    (6, 'Customer Service'),
    (7, 'IT'),
    (8, 'Operations');


-- 7. Insert Customer Segment Data
INSERT INTO customer_segment (segment_id, segment_name)
VALUES
    (1, 'Bronze'),
    (2, 'Silver'),
    (3, 'Gold'),
    (4, 'Platinum'),
    (5, 'Diamond');


-- 8. Insert Customer Data
INSERT INTO customers (
    customer_id,
    customer_name,
    email,
    phone,
    gender,
    city,
    country,
    registration_date,
    segment_id
)
VALUES
    (1, 'Ann Lucius', 'annkonilucius@gmail.com', '+2134523554', 'Female', 'Chicago', 'USA', '2025-01-07', 2),
    (2, 'Christian Onwuka', 'christianonwuka34@gmail.com', '+223422323453', 'Male', 'Nebraska', 'USA', '2025-04-06', 5),
    (3, 'Priscila Lucius', 'prisclucius@gmail.com', '+4435342467886', 'Female', 'Merida', 'Mexico', '2026-06-24', 3),
    (4, 'Lana Michael', 'lanamichael@gmail.com', '+7123435632', NULL, 'Leeds', 'England', '2026-01-04', 1),
    (5, 'Joe Hart', 'joeharty@gmail.com', '+21342442452', 'Male', 'Liverpool', 'England', '2025-03-18', NULL),
    (6, 'Rukoyat Muhammed', 'rukkymuhammed@gmail.com', '+32455473778', 'Female', 'Sydney', 'Australia', '2025-07-17', 5),
    (7, 'Olivia Syrel', 'oliviasyl@gmail.com', '+624533663678', 'Female', 'Helsinki', 'Finland', '2026-01-10', 4),
    (8, 'Morgana Richards', 'morganrich@gmail.com', '+254254256', 'Female', 'Dublin', 'Ireland', '2025-08-17', 2),
    (9, 'John Murphy', 'johnmurp@gmail.com', '+124523264563', 'Male', 'Galway', 'Ireland', '2025-11-16', 3),
    (10, 'Jeff Robert', 'jeffrobert@gmail.com', '+3214524523', 'Male', 'Dundee', 'Scotland', '2025-10-11', 2),
    (11, 'Gabriel Lopez', 'gablopez@gmail.com', '+21345646232', 'Male', 'Madrid', 'Spain', '2025-12-03', 3),
    (12, 'Raphael Scot', 'raphaelscot@gmail.com', '+14456564533', 'Male', 'Barcelona', 'Spain', '2025-09-03', 4),
    (13, 'Judith Blessing', 'judbless@gmail.com', '+43245534266', 'Female', 'Lagos', 'Nigeria', '2025-10-07', 2),
    (14, 'Maurice Kent', 'maukent@gmail.com', '+134633422447', NULL, 'Berlin', 'Germany', '2025-11-11', 5),
    (15, 'Deborah Bridge', 'debbridge@gmail.com', '+14656753675', 'Female', 'Munich', 'Germany', '2025-12-25', 1),
    (16, 'Paul Heyman', 'paulhey@gmail.com', '+245284423274', 'Male', 'Malmo', 'Sweden', '2026-10-21', 4),
    (17, 'Michelle Jackson', 'michjack@gmail.com', '+834423424551', NULL, 'Antwerp', 'Belgium', '2025-09-11', NULL),
    (18, 'Solomon David', 'soldav@gmail.com', '+1345345422', 'Male', 'Toronto', 'Canada', '2025-06-23', 2),
    (19, 'Monday Kwame', 'kwamon@gmail.com', '+233423424564', 'Male', 'Accra', 'Ghana', '2025-09-07', 4),
    (20, 'Lucky Dell', 'luckydell@gmail.com', '+876484638364', NULL, 'Vienna', 'Austria', '2026-01-09', 2);


-- 9. Insert Employee Data
INSERT INTO employee (
    employee_id,
    employee_name,
    email,
    phone,
    job_id,
    hire_date,
    department_id
)
VALUES
    (1, 'John Brocks', 'johnbrocks@gmail.com', '+2525563477', 1, '2025-01-12', 1),
    (2, 'Yusuf Bello', 'yusufbel@gmail.com', '+132456411775', 4, '2025-10-10', 3),
    (3, 'Margery Stark', 'margest@gmail.com', '+46342421566', 5, '2025-09-03', 4),
    (4, 'Joe Hart', 'joehart@gmail.com', '+153456453466', 2, '2025-10-09', 2),
    (5, 'Lucy White', 'lucywhite@gmail.com', '+1645377543', 8, '2026-07-09', 7),
    (6, 'Bright Wayne', 'brightwayne@gmail.com', '+142456367', 3, '2025-04-08', 2),
    (7, 'Sarah Talli', 'sarahtalli@gmail.com', '+9134256342', 6, '2026-04-17', 5),
    (8, 'Benjamin Gentle', 'gentben@gmail.com', '+2767845342', 7, '2025-09-16', 6),
    (9, 'Alvin Onwuka', 'alvinonwuka@gmail.com', '+16785678535', 3, '2025-08-12', 2),
    (10, 'Bridget Clent', 'bridgecle@gmail.com', '+213544524332', 4, '2026-01-20', 3),
    (11, 'Jason Mark', 'jasonmark@gmail.com', '+1324231134244', 8, '2026-08-03', 7),
    (12, 'Elorah Esther', 'elorahes@gmail.com', '+54231345234123', 5, '2026-01-22', 4),
    (13, 'Roy Keane', 'roykeane@gmail.com', '+234242313244', 2, '2025-03-05', 2),
    (14, 'Sam Allyarce', 'samallayrce@gmail.com', '+52634525244', 7, '2026-02-18', 6),
    (15, 'Mark Tony', 'markanth@gmail.com', '+747846746744', 6, '2026-03-14', 5);


-- 10. Insert Product Data
INSERT INTO products (
    product_id,
    product_name,
    brand_id,
    category_id,
    supplier_id,
    unit_cost,
    unit_price,
    color,
    size,
    launch_date,
    discontinued_flag
)
VALUES
    (1, 'samsung S20', 2, 1, 2, 500, 650, 'black', NULL, '2025-01-02', 'N'),
    (2, 'Xiaomi SU7 Pro', 8, 9, 1, 25000, 29000, 'Blue', NULL, '2025-09-22', 'Y'),
    (3, 'Air Jordan', 1, 3, 5, 25, 35, 'white', '31', '2025-06-11', 'Y'),
    (4, 'Sony Alpha 7V', 5, 1, 2, 3000, 4000, 'Titanium Black', NULL, '2025-05-11', 'Y'),
    (5, 'Iphone 15', 3, 1, 8, 800, 900, 'White', NULL, '2025-01-11', 'Y'),
    (6, 'Iphone 16', 3, 1, 8, 900, 1000, 'Gold', NULL, '2025-11-12', 'Y'),
    (7, 'Adidas V-Collar', 4, 2, 4, 70, 90, 'Red', 'XL', '2026-02-12', 'N'),
    (8, 'Sony FX2', 5, 1, 2, 1700, 1900, 'Black', NULL, '2026-03-11', 'Y'),
    (9, 'Xiaomi SU7 Ultra', 8, 9, 6, 35000, 40000, 'Black', NULL, '2025-03-23', 'Y'),
    (10, 'Redmi Note 15', 8, 1, 8, 270, 350, 'Orange', NULL, '2025-01-01', 'Y'),
    (11, 'Men Loafers', 9, 3, 10, 60, 75, 'Brown', '30', '2026-04-08', 'Y'),
    (12, 'Hp Elitebook 845', 10, 1, 2, 400, 600, 'Silver', NULL, '2025-09-01', 'Y'),
    (13, 'Puma Ultra 6 Match', 6, 7, 9, 150, 250, 'Purple', '29', '2025-05-10', 'Y'),
    (14, 'Huwaei Pura 8 Ultra', 7, 1, 2, 700, 899, 'White', NULL, '2025-09-01', 'Y'),
    (15, 'Samsung S23 Phone Case', 2, 8, 8, 2, 5, 'Black', NULL, '2025-01-01', 'N'),
    (16, 'Iphone 16 Pro Max', 3, 8, 2, 3, 5, 'Orange', NULL, '2025-05-01', 'Y'),
    (17, 'Mens Vomero', 1, 3, 7, 101, 160, 'Brown', '38', '2025-01-10', 'Y'),
    (18, 'Huwaei Mate X7', 7, 1, 8, 1400, 1600, NULL, NULL, '2025-09-09', 'Y'),
    (19, 'GG Jersey Polo', 9, 5, 7, 1000, 1250, 'Green', 'XXL', '2026-09-04', 'Y'),
    (20, 'Pieced Dyed Cotton Polo', 9, 5, 7, 1200, 1500, 'Yellow', 'XXXL', '2026-01-05', 'Y'),
    (21, 'Puma King Football', 6, 7, 3, 20, 27, 'Pink', NULL, '2025-08-08', 'Y');

UPDATE products
SET product_name = 'Iphone 16 Pro Max Case'
WHERE product_id = 16;


-- 11. Insert Order Data
INSERT INTO orders (
    order_id,
    customer_id,
    employee_id,
    store_id,
    order_date,
    order_status
)
VALUES
    (1, 17, 6, 4, '2026-07-22', 'Delivered'),
    (2, 9, 9, 1, '2026-08-19', 'Shipped'),
    (3, 10, 9, 3, '2025-09-10', 'Cancelled'),
    (4, 7, 6, 1, '2026-04-07', 'Delivered'),
    (5, 15, 9, 5, '2026-04-19', 'Delivered'),
    (6, 11, 6, 2, '2026-08-20', 'Processing'),
    (7, 9, 6, 3, '2026-08-22', 'Pending'),
    (8, 3, 9, 1, '2026-07-01', 'Cancelled'),
    (9, 20, 9, 4, '2026-08-19', 'Processing'),
    (10, 4, 6, 2, '2025-09-09', 'Delivered'),
    (11, 7, 6, 1, '2026-05-01', 'Delivered'),
    (12, 4, 6, 2, '2026-08-19', 'Shipped'),
    (13, 6, 9, 3, '2026-08-23', 'Pending'),
    (14, 2, 9, 1, '2026-03-09', 'Delivered'),
    (15, 19, 6, 4, '2026-02-09', 'Cancelled'),
    (16, 17, 9, 3, '2026-06-04', 'Delivered'),
    (17, 14, 6, 2, '2026-08-20', 'Shipped'),
    (18, 12, 9, 1, '2026-08-22', 'Pending'),
    (19, 11, 6, 5, '2026-02-18', 'Cancelled'),
    (20, 15, 9, 3, '2025-06-09', 'Cancelled'),
    (21, 18, 6, 2, '2026-04-14', 'Delivered'),
    (22, 1, 9, 3, '2025-09-19', 'Delivered'),
    (23, 8, 9, 5, '2026-08-23', 'Pending'),
    (24, 6, 6, 1, '2026-08-23', 'Pending'),
    (25, 13, 9, 4, '2026-01-09', 'Cancelled'),
    (26, 14, 6, 2, '2026-08-12', 'Shipped'),
    (27, 16, 9, 5, '2026-07-15', 'Shipped'),
    (28, 13, 6, 2, '2026-03-11', 'Cancelled'),
    (29, 12, 9, 1, '2026-08-19', 'Processing'),
    (30, 16, 9, 1, '2026-07-20', 'Delivered');


-- 12. Insert Order Item Data
INSERT INTO order_item (
    order_item_id,
    order_id,
    product_id,
    quantity,
    unit_price,
    discount
)
VALUES
    (1, 1, 2, 1, 29000, 900),
    (2, 1, 2, 1, 29000, NULL),
    (3, 1, 4, 1, 4100, NULL),
    (4, 2, 6, 2, 1000, NULL),
    (5, 2, 21, 1, 29, NULL),
    (6, 2, 3, 1, 35, NULL),
    (7, 3, 17, 1, 160, NULL),
    (8, 3, 14, 3, 899, NULL),
    (9, 4, 17, 2, 160, NULL),
    (10, 4, 12, 1, 650, NULL),
    (11, 4, 7, 2, 100, NULL),
    (12, 4, 1, 1, 650, NULL),
    (13, 5, 8, 2, 2000, NULL),
    (14, 6, 5, 4, 950, NULL),
    (15, 6, 19, 5, 1250, 75),
    (16, 6, 9, 1, 40000, NULL),
    (17, 7, 10, 1, 370, NULL),
    (18, 7, 13, 1, 250, NULL),
    (19, 7, 11, 2, 75, NULL),
    (20, 8, 16, 1, 5, NULL),
    (21, 8, 13, 2, 250, NULL),
    (22, 9, 15, 1, 5, NULL),
    (23, 9, 20, 1, 1500, NULL),
    (24, 10, 18, 1, 1600, NULL),
    (25, 10, 3, 2, 35, NULL),
    (26, 11, 4, 1, 4500, NULL),
    (27, 12, 8, 3, 1900, NULL),
    (28, 13, 5, 1, 900, NULL),
    (29, 14, 16, 1, 5, NULL),
    (30, 15, 10, 1, 350, NULL),
    (31, 16, 2, 1, 30000, NULL),
    (32, 17, 9, 1, 40000, NULL),
    (33, 18, 18, 1, 1600, NULL),
    (34, 19, 14, 2, 899, NULL),
    (35, 20, 5, 1, 900, NULL),
    (36, 21, 9, 2, 40000, 3000),
    (37, 22, 4, 1, 4000, NULL),
    (38, 23, 7, 1, 90, NULL),
    (39, 24, 6, 3, 1000, NULL),
    (40, 25, 14, 1, 899, NULL),
    (41, 26, 15, 2, 5, NULL),
    (42, 27, 12, 2, 600, NULL),
    (43, 28, 10, 1, 350, NULL),
    (44, 29, 13, 1, 250, NULL),
    (45, 30, 17, 1, 160, NULL),
    (46, 30, 10, 5, 350, 75),
    (47, 8, 1, 2, 650, NULL),
    (48, 10, 3, 1, 35, NULL),
    (49, 7, 7, 2, 90, NULL),
    (50, 15, 1, 1, 650, NULL);


-- 13. Insert Payment Data
INSERT INTO payment (
    payment_id,
    order_id,
    payment_method,
    payment_amount,
    payment_date,
    payment_status
)
VALUES
    (1, 1, 'Card', 61200, '2026-07-22', 'Failed'),
    (2, 1, 'Bank Transfer', 61200, '2026-07-22', 'Completed'),
    (3, 2, 'Card', 2064, '2026-08-19', 'Completed'),
    (4, 3, 'Card', 2857, '2025-09-10', 'Refunded'),
    (5, 4, 'Bank Transfer', 1820, '2026-04-07', 'Completed'),
    (6, 5, 'Card', 4000, '2026-04-19', 'Completed'),
    (7, 6, 'Bank Transfer', 49975, '2026-08-20', 'Pending'),
    (8, 7, 'Card', 950, '2026-08-22', 'Completed'),
    (9, 8, 'Bank Transfer', 1805, '2026-07-01', 'Refunded'),
    (10, 9, 'Bank Transfer', 1505, '2026-08-19', 'Completed'),
    (11, 10, 'Card', 1705, '2025-09-09', 'Completed'),
    (12, 11, 'Card', 4500, '2026-05-01', 'Completed'),
    (13, 12, 'Bank Transfer', 5700, '2026-08-19', 'Completed'),
    (14, 13, 'Bank Transfer', 900, '2026-08-23', 'Completed'),
    (15, 14, 'Card', 5, '2026-03-09', 'Completed'),
    (16, 15, 'Card', 1000, '2026-02-09', 'Failed'),
    (17, 16, 'Bank Transfer', 30000, '2026-06-04', 'Completed'),
    (18, 17, 'Bank Transfer', 40000, '2026-08-20', 'Completed'),
    (19, 18, 'Card', 1600, '2026-08-22', 'Pending'),
    (20, 19, 'Bank Transfer', 1798, '2026-02-18', 'Refunded'),
    (21, 20, 'Bank Transfer', 900, '2025-06-09', 'Refunded'),
    (22, 21, 'Card', 77000, '2026-04-14', 'Completed'),
    (23, 22, 'Bank Transfer', 4000, '2025-09-19', 'Completed'),
    (24, 23, 'Bank Transfer', 90, '2026-08-23', 'Pending'),
    (25, 24, 'Card', 3000, '2026-08-23', 'Pending'),
    (26, 25, 'Bank Transfer', 899, '2026-01-09', 'Refunded'),
    (27, 26, 'Card', 10, '2026-08-12', 'Completed'),
    (28, 27, 'Card', 1200, '2026-07-15', 'Completed'),
    (29, 28, 'Bank Transfer', 350, '2026-03-11', 'Refunded'),
    (30, 29, 'Cash', 250, '2026-08-20', 'Pending'),
    (31, 30, 'Bank Transfer', 1835, '2026-07-20', 'Completed');


-- 14. Insert Product Price History Data
INSERT INTO product_price_history (
    price_history_id,
    product_id,
    unit_price,
    effective_from,
    effective_to,
    effective_status
)
VALUES
    (1, 4, 4000, '2025-05-11', '2025-12-31', 'N'),
    (2, 4, 4100, '2026-07-01', NULL, 'Y'),
    (3, 21, 27, '2025-08-08', '2025-12-31', 'N'),
    (4, 21, 29, '2026-01-01', NULL, 'Y'),
    (5, 12, 600, '2025-09-01', '2025-12-31', 'N'),
    (6, 12, 650, '2026-01-01', NULL, 'Y'),
    (7, 7, 90, '2026-02-12', '2026-02-28', 'N'),
    (8, 7, 100, '2026-03-01', NULL, 'Y'),
    (9, 8, 1900, '2026-03-11', '2026-03-31', 'N'),
    (10, 8, 2000, '2026-04-01', NULL, 'Y'),
    (11, 5, 900, '2025-01-11', '2025-12-31', 'N'),
    (12, 5, 950, '2026-01-01', NULL, 'Y'),
    (13, 10, 350, '2025-01-01', '2025-12-31', 'N'),
    (14, 10, 370, '2026-01-01', NULL, 'Y'),
    (15, 4, 4500, '2026-01-01', '2026-06-30', 'N'),
    (16, 2, 29000, '2025-09-22', '2025-12-31', 'N'),
    (17, 2, 30000, '2026-01-01', '2026-06-30', 'N'),
    (18, 2, 29000, '2026-07-01', NULL, 'Y');
