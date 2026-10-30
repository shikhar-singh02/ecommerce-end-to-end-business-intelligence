-- E-COMMERCE BUSINESS INTELLIGENCE & CUSTOMER ANALYTICS
-- CUSTOMER, PRODUCT AND ORDER DATA CLEANING
-- Source queries preserved from the supplied SQL script.

-- CUSTOMERS CLEAN TABLE
-- ============================================================

-- Create customers_clean and standardize the customer fields during the cleaning process.
CREATE TABLE customers_clean AS
SELECT
    TRIM(Customer_ID) AS Customer_ID,

    NULLIF(TRIM(Customer_Name), '') AS Customer_Name,

    NULLIF(TRIM(Segment), '') AS Segment,

    TRIM(Region) AS Region,

    TRIM(State) AS State,

    NULLIF(TRIM(City), '') AS City

FROM customers_raw;

-- ============================================================
-- VERIFYING CUSTOMERS CLEAN TABLE
-- ============================================================

-- Review the related records and values for this data-quality or business check.
SELECT
    COUNT(*) AS Total_Rows,
    COUNT(DISTINCT Customer_ID) AS Unique_Customers,
    SUM(Customer_Name IS NULL) AS Missing_Customer_Name,
    SUM(Segment IS NULL) AS Missing_Segment,
    SUM(Region IS NULL) AS Missing_Region,
    SUM(State IS NULL) AS Missing_State,
    SUM(City IS NULL) AS Missing_City
FROM customers_clean;

-- ============================================================
-- PRODUCTS CLEAN TABLE
-- ============================================================

-- Create products_clean and standardize the product fields during the cleaning process.
CREATE TABLE products_clean AS
SELECT
    TRIM(Product_ID) AS Product_ID,

    NULLIF(TRIM(Product_Name), '') AS Product_Name,

    NULLIF(TRIM(Category), '') AS Category,

    NULLIF(TRIM(Sub_Category), '') AS Sub_Category

FROM products_raw;

-- ============================================================
-- VERIFYING PRODUCTS CLEAN TABLE
-- ============================================================

-- Use ROW_NUMBER() to number repeated records and identify potential duplicates.
SELECT
    COUNT(*) AS Total_Rows,
    COUNT(DISTINCT Product_ID) AS Unique_Products,
    SUM(Product_Name IS NULL) AS Missing_Product_Name,
    SUM(Category IS NULL) AS Missing_Category,
    SUM(Sub_Category IS NULL) AS Missing_Sub_Category
FROM products_clean;

-- ============================================================
-- ORDERS CLEANING
-- RULE 1: REMOVE EXACT DUPLICATE ROWS
-- ============================================================

-- Use ROW_NUMBER() to number repeated records and identify potential duplicates.
WITH Deduplicated_Orders AS (
    SELECT
        *,
        ROW_NUMBER() OVER (
            PARTITION BY
                Order_ID,
                Order_Date,
                Ship_Date,
                Customer_ID,
                Product_ID,
                Quantity,
                Sales,
                Discount,
                Profit,
                Ship_Mode,
                Payment_Mode
            ORDER BY Order_ID
        ) AS rn
    FROM orders_raw
)
SELECT
    COUNT(*) AS Rows_To_Remove
FROM Deduplicated_Orders
WHERE rn > 1;

-- ============================================================
-- RULE 2: CHECK CONFLICTING DUPLICATE ORDER_IDs
-- ============================================================

-- Compare Order_Date and Ship_Date to identify records where the shipping date is earlier than the order date.
SELECT
    Order_ID,
    Order_Date,
    Ship_Date,
    Customer_ID,
    Product_ID,
    Quantity,
    Sales,
    Discount,
    Profit,
    Ship_Mode,
    Payment_Mode
FROM orders_raw
WHERE Order_ID IN (
    'ORD0001138',
    'ORD0031517',
    'ORD0036654'
)
ORDER BY Order_ID;

-- ============================================================
-- E-COMMERCE BUSINESS INTELLIGENCE & CUSTOMER ANALYTICS
-- ORDERS CLEANING — CORRECTED VERSION
-- ============================================================

-- Review the related records and values for this data-quality or business check.
CREATE TABLE orders_clean AS
WITH Standardized_Raw AS (

    -- ========================================================
    -- STEP 1: STANDARDIZE RAW VALUES
    -- ========================================================

    SELECT

        TRIM(Order_ID) AS Order_ID,

        NULLIF(TRIM(Order_Date), '') AS Order_Date,

        NULLIF(TRIM(Ship_Date), '') AS Ship_Date,

        NULLIF(TRIM(Customer_ID), '') AS Customer_ID,

        NULLIF(TRIM(Product_ID), '') AS Product_ID,

        Quantity,
        Sales,
        Discount,
        Profit,

        -- RULE 2:
        -- Resolve ORD0001138 to Standard Class.
        TRIM(
            CASE
                WHEN Order_ID = 'ORD0001138'
                    THEN 'Standard Class'
                ELSE Ship_Mode
            END
        ) AS Ship_Mode,

        -- RULE 2:
        -- Keep UPI for ORD0031517.
        NULLIF(
            TRIM(
                CASE
                    WHEN Order_ID = 'ORD0031517'
                        THEN 'UPI'
                    ELSE Payment_Mode
                END
            ),
            ''
        ) AS Payment_Mode

    FROM orders_raw
),

Ranked_Orders AS (

    -- ========================================================
    -- RULE 1: REMOVE EXACT DUPLICATES
    --
    -- Standardization happens BEFORE ROW_NUMBER(),
    -- so ORD0001138 is correctly recognized as one record.
    -- ========================================================

    SELECT
        *,
        ROW_NUMBER() OVER (
            PARTITION BY
                Order_ID,
                Order_Date,
                Ship_Date,
                Customer_ID,
                Product_ID,
                Quantity,
                Sales,
                Discount,
                Profit,
                Ship_Mode,
                Payment_Mode
            ORDER BY Order_ID
        ) AS rn

    FROM Standardized_Raw
),

Filtered_Orders AS (

    -- ========================================================
    -- RULE 2:
    -- Resolve incomplete conflicting duplicate records.
    --
    -- ORD0031517:
    -- Keep the populated UPI record.
    --
    -- ORD0036654:
    -- Keep the populated Customer_ID record.
    -- ========================================================

    SELECT
        Order_ID,
        Order_Date,
        Ship_Date,
        Customer_ID,
        Product_ID,
        Quantity,
        Sales,
        Discount,
        Profit,
        Ship_Mode,
        Payment_Mode

    FROM Ranked_Orders

    WHERE rn = 1

      AND NOT (
          Order_ID = 'ORD0036654'
          AND Customer_ID IS NULL
      )
),

Valid_Orders AS (

    -- ========================================================
    -- RULE 7: REMOVE Quantity = 0
    -- RULE 8: REMOVE Negative Sales
    -- RULE 9: REMOVE Discount > 100%
    --
    -- Negative Profit is KEPT intentionally.
    -- ========================================================

    SELECT *
    FROM Filtered_Orders

    WHERE Quantity > 0
      AND Sales >= 0
      AND Discount <= 1
)

-- ============================================================
-- FINAL CLEAN TABLE
-- ============================================================

SELECT

    Order_ID,

    STR_TO_DATE(
        Order_Date,
        '%Y-%m-%d'
    ) AS Order_Date,

    -- RULE 10:
    -- Invalid Ship_Date (< Order_Date) → NULL
    CASE
        WHEN Ship_Date IS NULL
            THEN NULL

        WHEN STR_TO_DATE(Ship_Date, '%Y-%m-%d')
             < STR_TO_DATE(Order_Date, '%Y-%m-%d')
            THEN NULL

        ELSE STR_TO_DATE(Ship_Date, '%Y-%m-%d')
    END AS Ship_Date,

    -- RULE 3
    Customer_ID,

    -- RULE 4
    Product_ID,

    Quantity,
    Sales,
    Discount,
    Profit,

    Ship_Mode,

    -- RULE 5
    Payment_Mode

FROM Valid_Orders;

-- ============================================================