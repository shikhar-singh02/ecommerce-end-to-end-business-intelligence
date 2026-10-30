-- E-COMMERCE BUSINESS INTELLIGENCE & CUSTOMER ANALYTICS
-- DATABASE AND RAW TABLE SETUP
-- Queries retained from the supplied source script.

-- Create the project database to keep all e-commerce tables in one place.
CREATE DATABASE ecommerce_bi_project;

-- Select the project database so the following statements run against the correct schema.
USE ecommerce_bi_project;

-- Confirm which database is currently selected.
SELECT DATABASE();

-- Create the raw customers table using the fields available in the source data.
CREATE TABLE customers_raw (
    Customer_ID VARCHAR(20),
    Customer_Name VARCHAR(100),
    Segment VARCHAR(30),
    Region VARCHAR(30),
    State VARCHAR(50),
    City VARCHAR(50)
);

-- Inspect the table structure and confirm the column data types.
DESCRIBE customers_raw;

-- Count the records imported into customers_raw.
SELECT COUNT(*) AS Total_Customers
FROM customers_raw;

-- Review a sample of 10 records from customers_raw.
SELECT *
FROM customers_raw
LIMIT 10;

-- Create the raw products table to store the imported product data.
CREATE TABLE products_raw (
    Product_ID VARCHAR(20),
    Product_Name VARCHAR(150),
    Category VARCHAR(50),
    Sub_Category VARCHAR(50)
);

-- Count the records imported into products_raw.
SELECT COUNT(*) AS Total_Products
FROM products_raw;

-- Review a sample of 5 records from products_raw.
SELECT *
FROM products_raw
LIMIT 5;

-- Create the raw orders table using the fields available in the source data.
CREATE TABLE orders_raw (
    Order_ID VARCHAR(20),
    Order_Date VARCHAR(20),
    Ship_Date VARCHAR(20),
    Customer_ID VARCHAR(20),
    Product_ID VARCHAR(20),
    Quantity INT,
    Sales DECIMAL(12,2),
    Discount DECIMAL(6,4),
    Profit DECIMAL(12,2),
    Ship_Mode VARCHAR(50),
    Payment_Mode VARCHAR(50)
);

-- Inspect the table structure and confirm the column data types.
DESCRIBE orders_raw;

-- Count the records imported into orders_raw.
SELECT COUNT(*) AS Total_Orders
FROM orders_raw;

-- Review a sample of 5 records from orders_raw.
SELECT *
FROM orders_raw
LIMIT 5;