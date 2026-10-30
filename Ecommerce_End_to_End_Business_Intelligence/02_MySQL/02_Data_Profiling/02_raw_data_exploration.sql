-- E-COMMERCE BUSINESS INTELLIGENCE & CUSTOMER ANALYTICS
-- RAW DATA PROFILING AND EXPLORATORY CHECKS
-- Queries retained from the supplied source script.

-- Group by CUSTOMER_ID to compare record counts and relevant business metrics.
SELECT 
    COUNT(*) AS Total_Rows,
    COUNT(DISTINCT Order_ID) AS Unique_Orders,
    COUNT(DISTINCT Customer_ID) AS Unique_Customers,
    COUNT(DISTINCT Product_ID) AS Unique_Products
FROM orders_raw;
 
-- Group by CUSTOMER_ID to compare record counts and relevant business metrics.
SELECT 
    Customer_ID,
    COUNT(*) AS Order_Count
FROM orders_raw
GROUP BY Customer_ID
HAVING Customer_ID NOT IN (
    SELECT Customer_ID
    FROM customers_raw
)
OR Customer_ID IS NULL;

-- Display Customer_ID values inside brackets to make leading/trailing spaces and blank values easier to spot.
SELECT 
    CONCAT('[', Customer_ID, ']') AS Customer_ID_Check,
    COUNT(*) AS Row_Count
FROM orders_raw
GROUP BY Customer_ID
ORDER BY Row_Count DESC;

-- Group by PRODUCT_ID to compare record counts and relevant business metrics.
SELECT 
    Product_ID,
    COUNT(*) AS Order_Count
FROM orders_raw
GROUP BY Product_ID
HAVING Product_ID NOT IN (
    SELECT Product_ID
    FROM products_raw
)
OR Product_ID IS NULL;

-- Display Product_ID values inside brackets to make leading/trailing spaces and blank values easier to spot.
SELECT 
    CONCAT('[', Product_ID, ']') AS Product_ID_Check,
    COUNT(*) AS Row_Count
FROM orders_raw
GROUP BY Product_ID
ORDER BY Row_Count DESC;

-- Display Payment_Mode values inside brackets to identify extra spaces or inconsistent text.
SELECT 
    CONCAT('[', Payment_Mode, ']') AS Payment_Mode_Check,
    COUNT(*) AS Row_Count
FROM orders_raw
GROUP BY Payment_Mode
ORDER BY Row_Count DESC;

-- Use ROW_NUMBER() to number repeated records and identify potential duplicates.
WITH Duplicate_Rows AS (
   SELECT *,
      ROW_NUMBER() OVER ( PARTITION BY 
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
       Payment_Mode) AS rn
    FROM orders_raw)

SELECT COUNT(*)
FROM Duplicate_Rows
WHERE rn > 1;
 
-- Compare Order_Date and Ship_Date to identify records where the shipping date is earlier than the order date.
SELECT
    Order_ID,
    COUNT(*) AS Row_Count,
    COUNT(DISTINCT Order_Date) AS Order_Date_Variations,
    COUNT(DISTINCT Ship_Date) AS Ship_Date_Variations,
    COUNT(DISTINCT Customer_ID) AS Customer_ID_Variations,
    COUNT(DISTINCT Product_ID) AS Product_ID_Variations,
    COUNT(DISTINCT Quantity) AS Quantity_Variations,
    COUNT(DISTINCT Sales) AS Sales_Variations,
    COUNT(DISTINCT Discount) AS Discount_Variations,
    COUNT(DISTINCT Profit) AS Profit_Variations,
    COUNT(DISTINCT Ship_Mode) AS Ship_Mode_Variations,
    COUNT(DISTINCT Payment_Mode) AS Payment_Mode_Variations
FROM orders_raw
GROUP BY Order_ID
HAVING COUNT(*) > 1
   AND (
       COUNT(DISTINCT Order_Date) > 1
       OR COUNT(DISTINCT Ship_Date) > 1
       OR COUNT(DISTINCT Customer_ID) > 1
       OR COUNT(DISTINCT Product_ID) > 1
       OR COUNT(DISTINCT Quantity) > 1
       OR COUNT(DISTINCT Sales) > 1
       OR COUNT(DISTINCT Discount) > 1
       OR COUNT(DISTINCT Profit) > 1
       OR COUNT(DISTINCT Ship_Mode) > 1
       OR COUNT(DISTINCT Payment_Mode) > 1
   );
   
-- Check the minimum and maximum quantities and identify zero or negative quantity records.
SELECT *
FROM orders_raw
WHERE Order_ID IN (
    'ORD0001138',
    'ORD0031517',
    'ORD0036654'
)
ORDER BY Order_ID;

-- Review the quantity range and count records with zero or negative quantities.
SELECT
    MIN(Quantity) AS Min_Quantity,
    MAX(Quantity) AS Max_Quantity,
    SUM(CASE WHEN Quantity = 0 THEN 1 ELSE 0 END) AS Zero_Quantity_Rows,
    SUM(CASE WHEN Quantity < 0 THEN 1 ELSE 0 END) AS Negative_Quantity_Rows
FROM orders_raw;

-- Review the sales range and identify records with zero or negative sales values.
SELECT
	MIN(Sales) AS Min_Sales,
	MAX(Sales) AS Max_Sales,
	SUM(CASE WHEN Sales < 0 THEN 1 ELSE 0 END) AS Negative_Sales_Rows,
	SUM(CASE WHEN Sales = 0 THEN 1 ELSE 0 END) AS Zero_Sales_Rows
FROM orders_raw;

-- Group discount values into bands and compare sales and profitability across those bands.
SELECT
    MIN(Discount) AS Min_Discount,
    MAX(Discount) AS Max_Discount,
    SUM(CASE WHEN Discount < 0 THEN 1 ELSE 0 END) AS Negative_Discount_Rows,
    SUM(CASE WHEN Discount > 1 THEN 1 ELSE 0 END) AS Discount_Above_100_Pct
FROM orders_raw;

-- Review profit values, including loss-making orders. A negative profit is treated as a business result, not automatically as invalid data.
SELECT
    MIN(Profit) AS Min_Profit,
    MAX(Profit) AS Max_Profit,
    SUM(CASE WHEN Profit < 0 THEN 1 ELSE 0 END) AS Negative_Profit_Rows,
    SUM(CASE WHEN Profit = 0 THEN 1 ELSE 0 END) AS Zero_Profit_Rows
FROM orders_raw;

-- Compare Order_Date and Ship_Date to identify records where the shipping date is earlier than the order date.
SELECT
    SUM(CASE 
        WHEN TRIM(Order_Date) = '' THEN 1 
        ELSE 0 
    END) AS Missing_Order_Date,
    
    SUM(CASE 
        WHEN TRIM(Ship_Date) = '' THEN 1 
        ELSE 0 
    END) AS Missing_Ship_Date
FROM orders_raw;

-- Compare Order_Date and Ship_Date to identify records where the shipping date is earlier than the order date.
SELECT
    COUNT(*) AS Ship_Before_Order
FROM orders_raw
WHERE TRIM(Ship_Date) <> ''
  AND STR_TO_DATE(Ship_Date, '%Y-%m-%d')
      < STR_TO_DATE(Order_Date, '%Y-%m-%d');
      
-- Compare Order_Date and Ship_Date to identify records where the shipping date is earlier than the order date.
SELECT
    Order_ID,
    Order_Date,
    Ship_Date
FROM orders_raw
WHERE TRIM(Ship_Date) <> ''
  AND STR_TO_DATE(Ship_Date, '%Y-%m-%d')
      < STR_TO_DATE(Order_Date, '%Y-%m-%d')
ORDER BY Order_Date;
      
-- Compare Order_Date and Ship_Date to identify records where the shipping date is earlier than the order date.
SELECT
    MIN(STR_TO_DATE(Order_Date, '%Y-%m-%d')) AS Min_Order_Date,
    MAX(STR_TO_DATE(Order_Date, '%Y-%m-%d')) AS Max_Order_Date,
    MIN(
        CASE 
            WHEN TRIM(Ship_Date) <> ''
            THEN STR_TO_DATE(Ship_Date, '%Y-%m-%d')
        END
    ) AS Min_Ship_Date,
    MAX(
        CASE 
            WHEN TRIM(Ship_Date) <> ''
            THEN STR_TO_DATE(Ship_Date, '%Y-%m-%d')
        END
    ) AS Max_Ship_Date
    FROM orders_raw;

-- Compare order count, sales, and profit across shipping modes.
SELECT
    Ship_Mode,
    COUNT(*) AS Row_Count
FROM orders_raw
GROUP BY Ship_Mode
ORDER BY Ship_Mode;

-- Group Ship_Mode using its exact text value to reveal differences in capitalization or spacing.
SELECT
    BINARY Ship_Mode AS Ship_Mode_Exact,
    COUNT(*) AS Row_Count
FROM orders_raw
GROUP BY BINARY Ship_Mode
ORDER BY Ship_Mode_Exact;

-- Review the related records and values for this data-quality or business check.
SELECT
    Payment_Mode,
    COUNT(*) AS Row_Count
FROM orders_raw
GROUP BY Payment_Mode
ORDER BY Payment_Mode;

-- Count the records imported into customers_raw.
SELECT
    COUNT(*) AS Total_Customers,
    COUNT(DISTINCT Customer_ID) AS Unique_Customer_IDs,
    SUM(CASE WHEN TRIM(Customer_Name) = '' THEN 1 ELSE 0 END) AS Missing_Customer_Name,
    SUM(CASE WHEN TRIM(Segment) = '' THEN 1 ELSE 0 END) AS Missing_Segment,
    SUM(CASE WHEN TRIM(Region) = '' THEN 1 ELSE 0 END) AS Missing_Region,
    SUM(CASE WHEN TRIM(State) = '' THEN 1 ELSE 0 END) AS Missing_State,
    SUM(CASE WHEN TRIM(City) = '' THEN 1 ELSE 0 END) AS Missing_City
FROM customers_raw;

-- Group by CUSTOMER_ID to compare record counts and relevant business metrics.
SELECT
    Customer_ID,
    COUNT(*) AS Row_Count
FROM customers_raw
GROUP BY Customer_ID
HAVING COUNT(*) > 1;

-- Group by SEGMENT to compare record counts and relevant business metrics.
SELECT
    Segment,
    COUNT(*) AS Customer_Count
FROM customers_raw
GROUP BY Segment
ORDER BY Customer_Count DESC;

-- Review the related records and values for this data-quality or business check.
SELECT
    Region,
    COUNT(*) AS Customer_Count
FROM customers_raw
GROUP BY Region
ORDER BY Customer_Count DESC;

-- Group by STATE to compare record counts and relevant business metrics.
SELECT
    State,
    COUNT(*) AS Customer_Count
FROM customers_raw
GROUP BY State
ORDER BY Customer_Count DESC;

-- Group by CITY to compare record counts and relevant business metrics.
SELECT
    City,
    COUNT(*) AS Customer_Count
FROM customers_raw
GROUP BY City
ORDER BY Customer_Count DESC;

-- Compare sales and profit at the category and sub-category levels.
SELECT
    COUNT(*) AS Total_Products,
    COUNT(DISTINCT Product_ID) AS Unique_Product_IDs,
    SUM(CASE WHEN TRIM(Product_Name) = '' THEN 1 ELSE 0 END) AS Missing_Product_Name,
    SUM(CASE WHEN TRIM(Category) = '' THEN 1 ELSE 0 END) AS Missing_Category,
    SUM(CASE WHEN TRIM(Sub_Category) = '' THEN 1 ELSE 0 END) AS Missing_Sub_Category
FROM products_raw;

-- Group by PRODUCT_ID to compare record counts and relevant business metrics.
SELECT
    Product_ID,
    COUNT(*) AS Row_Count
FROM products_raw
GROUP BY Product_ID
HAVING COUNT(*) > 1;

-- Group by CATEGORY to compare record counts and relevant business metrics.
SELECT
    Category,
    COUNT(*) AS Product_Count
FROM products_raw
GROUP BY Category
ORDER BY Product_Count DESC;

-- Compare sales and profit at the category and sub-category levels.
SELECT
    Sub_Category,
    COUNT(*) AS Product_Count
FROM products_raw
GROUP BY Sub_Category
ORDER BY Product_Count DESC;

-- Check the discount range and identify values below 0 or above 1.
SELECT
    Order_ID,
    Customer_ID,
    Product_ID,
    Quantity,
    Sales,
    Discount,
    Profit
FROM orders_raw
WHERE Quantity = 0
ORDER BY Order_ID;

-- Check the discount range and identify values below 0 or above 1.
SELECT
    Order_ID,
    Customer_ID,
    Product_ID,
    Quantity,
    Sales,
    Discount,
    Profit
FROM orders_raw
WHERE Sales < 0
ORDER BY Sales;

-- Check the discount range and identify values below 0 or above 1.
SELECT
    Order_ID,
    Quantity,
    Sales,
    Discount,
    Profit
FROM orders_raw
WHERE Discount > 1
ORDER BY Discount DESC;

-- Compare Order_Date and Ship_Date to identify records where the shipping date is earlier than the order date.
SELECT
    Order_ID,
    Order_Date,
    Ship_Date,
    DATEDIFF(
        STR_TO_DATE(Ship_Date, '%Y-%m-%d'),
        STR_TO_DATE(Order_Date, '%Y-%m-%d')
    ) AS Shipping_Days
FROM orders_raw
WHERE TRIM(Ship_Date) <> ''
  AND STR_TO_DATE(Ship_Date, '%Y-%m-%d')
      < STR_TO_DATE(Order_Date, '%Y-%m-%d')
ORDER BY Shipping_Days;

-- Group discount values into bands and compare sales and profitability across those bands.
SELECT
    COUNT(*) AS Negative_Profit_Rows,
    SUM(CASE WHEN Discount > 1 THEN 1 ELSE 0 END) AS Negative_Profit_With_Invalid_Discount,
    SUM(CASE WHEN Sales < 0 THEN 1 ELSE 0 END) AS Negative_Profit_With_Negative_Sales,
    SUM(CASE WHEN Quantity = 0 THEN 1 ELSE 0 END) AS Negative_Profit_With_Zero_Quantity
FROM orders_raw
WHERE Profit < 0;

-- Review the related records and values for this data-quality or business check.
SELECT
    Customer_ID,
    Customer_Name,
    Segment,
    Region,
    State,
    City
FROM customers_raw
WHERE Customer_Name = '';

-- Review the related records and values for this data-quality or business check.
SELECT
    Customer_ID,
    Customer_Name,
    Segment,
    Region,
    State,
    City
FROM customers_raw
WHERE Segment = '';

-- Review the related records and values for this data-quality or business check.
SELECT
    Customer_ID,
    Customer_Name,
    Segment,
    Region,
    State,
    City
FROM customers_raw
WHERE City = '';

-- Group by CITY to compare record counts and relevant business metrics.
SELECT
    City,
    COUNT(*) AS Row_Count
FROM customers_raw
WHERE City <> ''
GROUP BY City
ORDER BY City;

-- Group by LOWER(TRIM(CITY)) to compare record counts and relevant business metrics.
SELECT
    LOWER(TRIM(City)) AS Normalized_City,
    COUNT(DISTINCT City) AS Different_Forms,
    GROUP_CONCAT(DISTINCT City ORDER BY City SEPARATOR ' | ') AS Actual_Forms
FROM customers_raw
WHERE City <> ''
GROUP BY LOWER(TRIM(City))
HAVING COUNT(DISTINCT City) > 1;

-- Group by LOWER(TRIM(SEGMENT)) to compare record counts and relevant business metrics.
SELECT
    LOWER(TRIM(Segment)) AS Normalized_Segment,
    COUNT(DISTINCT Segment) AS Different_Forms,
    GROUP_CONCAT(
        DISTINCT Segment
        ORDER BY Segment
        SEPARATOR ' | '
    ) AS Actual_Forms
FROM customers_raw
WHERE Segment <> ''
GROUP BY LOWER(TRIM(Segment))
HAVING COUNT(DISTINCT Segment) > 1;

-- Review the related records and values for this data-quality or business check.
SELECT
    LOWER(TRIM(Region)) AS Normalized_Region,
    COUNT(DISTINCT Region) AS Different_Forms,
    GROUP_CONCAT(
        DISTINCT Region
        ORDER BY Region
        SEPARATOR ' | '
    ) AS Actual_Forms
FROM customers_raw
WHERE Region <> ''
GROUP BY LOWER(TRIM(Region))
HAVING COUNT(DISTINCT Region) > 1;

-- Compare sales and profit at the category and sub-category levels.
SELECT
    Product_ID,
    Product_Name,
    Category,
    Sub_Category
FROM products_raw
WHERE Product_Name = '';

-- Compare sales and profit at the category and sub-category levels.
SELECT
    Product_ID,
    Product_Name,
    Category,
    Sub_Category
FROM products_raw
WHERE Category = '';

-- Compare sales and profit at the category and sub-category levels.
SELECT
    Product_ID,
    Product_Name,
    Category,
    Sub_Category
FROM products_raw
WHERE Sub_Category = '';

-- Group by LOWER(TRIM(CATEGORY)) to compare record counts and relevant business metrics.
SELECT
    LOWER(TRIM(Category)) AS Normalized_Category,
    COUNT(DISTINCT Category) AS Different_Forms,
    GROUP_CONCAT(
        DISTINCT Category
        ORDER BY Category
        SEPARATOR ' | '
    ) AS Actual_Forms
FROM products_raw
WHERE Category <> ''
GROUP BY LOWER(TRIM(Category))
HAVING COUNT(DISTINCT Category) > 1;

-- Compare sales and profit at the category and sub-category levels.
SELECT
    LOWER(TRIM(Sub_Category)) AS Normalized_Sub_Category,
    COUNT(DISTINCT Sub_Category) AS Different_Forms,
    GROUP_CONCAT(
        DISTINCT Sub_Category
        ORDER BY Sub_Category
        SEPARATOR ' | '
    ) AS Actual_Forms
FROM products_raw
WHERE Sub_Category <> ''
GROUP BY LOWER(TRIM(Sub_Category))
HAVING COUNT(DISTINCT Sub_Category) > 1;

-- ============================================================