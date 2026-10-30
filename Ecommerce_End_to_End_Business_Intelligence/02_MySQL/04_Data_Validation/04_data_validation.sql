-- E-COMMERCE BUSINESS INTELLIGENCE & CUSTOMER ANALYTICS
-- CLEAN TABLE AND BUSINESS RULE VALIDATION
-- Source queries preserved from the supplied SQL script.

-- VERIFY ORDERS CLEAN TABLE
-- STEP 1: ROW COUNT & UNIQUE ORDER_ID
-- ============================================================

-- Group by ORDER_ID to compare record counts and relevant business metrics.
SELECT
    COUNT(*) AS Total_Rows,
    COUNT(DISTINCT Order_ID) AS Unique_Order_IDs
FROM orders_clean;

-- ============================================================
-- STEP 2: CHECK REMAINING DUPLICATE ORDER_IDs
-- ============================================================

-- Group by ORDER_ID to compare record counts and relevant business metrics.
SELECT
    Order_ID,
    COUNT(*) AS Row_Count
FROM orders_clean
GROUP BY Order_ID
HAVING COUNT(*) > 1;

-- ============================================================
-- VERIFY ORDERS CLEAN TABLE
-- STEP 3: CHECK INVALID TRANSACTIONS
-- ============================================================

-- Check the discount range and identify values below 0 or above 1.
SELECT
    SUM(Quantity <= 0) AS Invalid_Quantity,
    SUM(Sales < 0) AS Negative_Sales,
    SUM(Discount > 1) AS Invalid_Discount
FROM orders_clean;


-- ============================================================
-- VERIFY ORDERS CLEAN TABLE
-- STEP 4: CHECK MISSING VALUES
-- ============================================================

-- Compare Order_Date and Ship_Date to identify records where the shipping date is earlier than the order date.
SELECT
    SUM(Order_Date IS NULL) AS Missing_Order_Date,
    SUM(Ship_Date IS NULL) AS Missing_Ship_Date,
    SUM(Customer_ID IS NULL) AS Missing_Customer_ID,
    SUM(Product_ID IS NULL) AS Missing_Product_ID,
    SUM(Payment_Mode IS NULL) AS Missing_Payment_Mode
FROM orders_clean;

-- ============================================================
-- VERIFY ORDERS CLEAN TABLE
-- STEP 5: CHECK INVALID SHIP DATES
-- ============================================================

-- Compare Order_Date and Ship_Date to identify records where the shipping date is earlier than the order date.
SELECT
    COUNT(*) AS Invalid_Ship_Date_Rows
FROM orders_clean
WHERE Ship_Date < Order_Date;

-- ============================================================
-- VERIFY ORDERS CLEAN TABLE
-- STEP 6: VERIFY NEGATIVE PROFIT IS RETAINED
-- ============================================================

-- Review profit values, including loss-making orders. A negative profit is treated as a business result, not automatically as invalid data.
SELECT
    COUNT(*) AS Negative_Profit_Rows
FROM orders_clean
WHERE Profit < 0;

-- ============================================================
-- FINAL CHECK: CONFLICTING DUPLICATE ORDERS
-- ============================================================

-- Compare order count, sales, and profit across shipping modes.
SELECT
    Order_ID,
    Customer_ID,
    Ship_Mode,
    Payment_Mode
FROM orders_clean
WHERE Order_ID IN (
    'ORD0001138',
    'ORD0031517',
    'ORD0036654'
)
ORDER BY Order_ID;

-- ============================================================
-- DATA VALIDATION & RELATIONSHIP CHECKS
-- STEP 1: ORDERS → CUSTOMERS
-- ============================================================

-- Review the related records and values for this data-quality or business check.
SELECT
    COUNT(*) AS Invalid_Customer_IDs
FROM orders_clean o
LEFT JOIN customers_clean c
    ON o.Customer_ID = c.Customer_ID
WHERE o.Customer_ID IS NOT NULL
  AND c.Customer_ID IS NULL;

-- ============================================================
-- DATA VALIDATION & RELATIONSHIP CHECKS
-- STEP 2: ORDERS → PRODUCTS
-- ============================================================

-- Rule: Every non-NULL Product_ID in orders_clean
-- must exist in products_clean.

-- Review the related records and values for this data-quality or business check.
SELECT
    COUNT(*) AS Invalid_Product_IDs
FROM orders_clean o
LEFT JOIN products_clean p
    ON o.Product_ID = p.Product_ID
WHERE o.Product_ID IS NOT NULL
  AND p.Product_ID IS NULL;

-- ============================================================
-- DATA VALIDATION & RELATIONSHIP CHECKS
-- STEP 3: CUSTOMERS → ORDERS
-- ============================================================

-- Rule: Identify customers who do not have any order
-- in orders_clean.

-- Review the related records and values for this data-quality or business check.
SELECT
    COUNT(*) AS Customers_Without_Orders
FROM customers_clean c
LEFT JOIN orders_clean o
    ON c.Customer_ID = o.Customer_ID
WHERE o.Customer_ID IS NULL;

-- ============================================================
-- DATA VALIDATION & RELATIONSHIP CHECKS
-- STEP 3: CUSTOMERS → ORDERS
-- ============================================================

-- Rule: Identify customers who do not have any order
-- in orders_clean.

-- Review the related records and values for this data-quality or business check.
SELECT
    COUNT(*) AS Customers_Without_Orders
FROM customers_clean c
LEFT JOIN orders_clean o
    ON c.Customer_ID = o.Customer_ID
WHERE o.Customer_ID IS NULL;

-- ============================================================
-- DATA VALIDATION & RELATIONSHIP CHECKS
-- STEP 4: PRODUCTS → ORDERS
-- ============================================================

-- Rule: Identify products that do not have any order
-- in orders_clean.

-- Review the related records and values for this data-quality or business check.
SELECT
    COUNT(*) AS Products_Without_Orders
FROM products_clean p
LEFT JOIN orders_clean o
    ON p.Product_ID = o.Product_ID
WHERE o.Product_ID IS NULL;

-- ============================================================
-- DATA VALIDATION & RELATIONSHIP CHECKS
-- STEP 5: ORDER DATE vs SHIP DATE
-- ============================================================

-- Rule: Ship_Date must be greater than or equal to Order_Date.
-- NULL Ship_Date is allowed because some orders have missing
-- or invalid shipping dates.

-- Compare Order_Date and Ship_Date to identify records where the shipping date is earlier than the order date.
SELECT
    COUNT(*) AS Invalid_Ship_Dates
FROM orders_clean
WHERE Ship_Date IS NOT NULL
  AND Ship_Date < Order_Date;

-- ============================================================
-- DATA VALIDATION & BUSINESS RULE CHECKS
-- STEP 6: QUANTITY vs SALES
-- ============================================================

-- Rule: A valid order should have positive Quantity
-- and positive Sales.

-- Review the sales range and identify records with zero or negative sales values.
SELECT
    COUNT(*) AS Zero_Sales_Orders
FROM orders_clean
WHERE Quantity > 0
  AND Sales = 0;

-- ============================================================
-- DATA VALIDATION & BUSINESS RULE CHECKS
-- STEP 7: DISCOUNT VALIDATION
-- ============================================================

-- Rule: Discount cannot be negative.

-- Check the discount range and identify values below 0 or above 1.
SELECT
    COUNT(*) AS Negative_Discount_Orders
FROM orders_clean
WHERE Discount < 0;

-- ============================================================
-- DATA VALIDATION & BUSINESS RULE CHECKS
-- STEP 8: PROFIT vs SALES
-- ============================================================

-- Rule: Profit should not be greater than Sales.

-- Review the related records and values for this data-quality or business check.
SELECT
    COUNT(*) AS Invalid_Profit_Orders
FROM orders_clean
WHERE Profit > Sales;

-- ============================================================
-- DATA VALIDATION & BUSINESS RULE CHECKS
-- STEP 9: PAYMENT MODE VALIDATION
-- ============================================================

-- Rule: Payment_Mode must be one of the approved values.
-- NULL is allowed because some payment modes were missing
-- in the raw data.

-- Review the related records and values for this data-quality or business check.
SELECT
    COUNT(*) AS Invalid_Payment_Modes
FROM orders_clean
WHERE Payment_Mode IS NOT NULL
  AND Payment_Mode NOT IN (
      'Cash on Delivery',
      'Credit Card',
      'Debit Card',
      'Net Banking',
      'UPI'
  );

-- ============================================================
-- DATA VALIDATION & BUSINESS RULE CHECKS
-- STEP 10: SHIP MODE VALIDATION
-- ============================================================

-- Rule: Ship_Mode must be one of the approved standardized values.

-- Compare order count, sales, and profit across shipping modes.
SELECT
    COUNT(*) AS Invalid_Ship_Modes
FROM orders_clean
WHERE Ship_Mode IS NOT NULL
  AND Ship_Mode NOT IN (
      'First Class',
      'Second Class',
      'Standard Class',
      'Same Day'
  );

-- ============================================================