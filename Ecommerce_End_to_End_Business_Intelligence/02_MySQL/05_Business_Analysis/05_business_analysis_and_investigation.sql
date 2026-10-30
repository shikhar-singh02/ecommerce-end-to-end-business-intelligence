-- E-COMMERCE BUSINESS INTELLIGENCE & CUSTOMER ANALYTICS
-- BUSINESS ANALYSIS AND FURNITURE DISCOUNT INVESTIGATION
-- Source queries preserved from the supplied SQL script.

-- BUSINESS ANALYSIS
-- STEP 1: EXECUTIVE KPIs
-- ============================================================

-- Calculate order count, sales, profit, and average order value at the customer level.
SELECT
    ROUND(SUM(Sales), 2) AS Total_Sales,
    ROUND(SUM(Profit), 2) AS Total_Profit,
    COUNT(DISTINCT Order_ID) AS Total_Orders,
    COUNT(DISTINCT Customer_ID) AS Total_Customers,
    SUM(Quantity) AS Total_Quantity,
    ROUND(SUM(Sales) / COUNT(DISTINCT Order_ID), 2) AS Average_Order_Value,
    ROUND(SUM(Profit) / SUM(Sales) * 100, 2) AS Profit_Margin_Pct
FROM orders_clean;

-- ============================================================
-- BUSINESS ANALYSIS
-- STEP 2: CATEGORY PERFORMANCE
-- ============================================================

-- Group by CATEGORY to compare record counts and relevant business metrics.
SELECT
    p.Category,
    ROUND(SUM(o.Sales), 2) AS Total_Sales,
    ROUND(SUM(o.Profit), 2) AS Total_Profit,
    SUM(o.Quantity) AS Total_Quantity,
    COUNT(DISTINCT o.Order_ID) AS Total_Orders,
    ROUND(
        SUM(o.Profit) / SUM(o.Sales) * 100,
        2
    ) AS Profit_Margin_Pct
FROM orders_clean o
LEFT JOIN products_clean p
    ON o.Product_ID = p.Product_ID
GROUP BY
    p.Category
ORDER BY
    Total_Sales DESC;

-- ============================================================
-- BUSINESS ANALYSIS
-- STEP 3: SUB-CATEGORY PERFORMANCE
-- ============================================================

-- Compare sales and profit at the category and sub-category levels.
SELECT
    p.Sub_Category,
    ROUND(SUM(o.Sales), 2) AS Total_Sales,
    ROUND(SUM(o.Profit), 2) AS Total_Profit,
    SUM(o.Quantity) AS Total_Quantity,
    COUNT(DISTINCT o.Order_ID) AS Total_Orders,
    ROUND(
        SUM(o.Profit) / SUM(o.Sales) * 100,
        2
    ) AS Profit_Margin_Pct
FROM orders_clean o
LEFT JOIN products_clean p
    ON o.Product_ID = p.Product_ID
GROUP BY
    p.Sub_Category
ORDER BY
    Total_Sales DESC;
    
-- ============================================================
-- BUSINESS ANALYSIS
-- STEP 4: REGIONAL PERFORMANCE
-- ============================================================

-- Calculate order count, sales, profit, and average order value at the customer level.
SELECT
    c.Region,
    ROUND(SUM(o.Sales), 2) AS Total_Sales,
    ROUND(SUM(o.Profit), 2) AS Total_Profit,
    SUM(o.Quantity) AS Total_Quantity,
    COUNT(DISTINCT o.Order_ID) AS Total_Orders,
    COUNT(DISTINCT o.Customer_ID) AS Total_Customers,
    ROUND(
        SUM(o.Profit) / SUM(o.Sales) * 100,
        2
    ) AS Profit_Margin_Pct
FROM orders_clean o
LEFT JOIN customers_clean c
    ON o.Customer_ID = c.Customer_ID
GROUP BY
    c.Region
ORDER BY
    Total_Sales DESC;
    
-- ============================================================
-- BUSINESS ANALYSIS
-- STEP 5: CUSTOMER SEGMENT PERFORMANCE
-- ============================================================

-- Calculate order count, sales, profit, and average order value at the customer level.
SELECT
    c.Segment,
    ROUND(SUM(o.Sales), 2) AS Total_Sales,
    ROUND(SUM(o.Profit), 2) AS Total_Profit,
    COUNT(DISTINCT o.Order_ID) AS Total_Orders,
    COUNT(DISTINCT o.Customer_ID) AS Total_Customers,
    SUM(o.Quantity) AS Total_Quantity,
    ROUND(
        SUM(o.Profit) / SUM(o.Sales) * 100,
        2
    ) AS Profit_Margin_Pct,
    ROUND(
        SUM(o.Sales) / COUNT(DISTINCT o.Order_ID),
        2
    ) AS Average_Order_Value
FROM orders_clean o
LEFT JOIN customers_clean c
    ON o.Customer_ID = c.Customer_ID
GROUP BY
    c.Segment
ORDER BY
    Total_Sales DESC;
    
-- ============================================================
-- BUSINESS ANALYSIS
-- STEP 6: TOP 10 CUSTOMERS BY SALES
-- ============================================================

-- Group by CUSTOMER_ID to compare record counts and relevant business metrics.
SELECT
    c.Customer_ID,
    c.Customer_Name,
    ROUND(SUM(o.Sales), 2) AS Total_Sales
FROM orders_clean o
INNER JOIN customers_clean c
    ON o.Customer_ID = c.Customer_ID
GROUP BY
    c.Customer_ID,
    c.Customer_Name
ORDER BY
    Total_Sales DESC
LIMIT 10;
    
-- ============================================================
-- BUSINESS ANALYSIS
-- STEP 7: TOP 10 CUSTOMERS BY PROFIT
-- ============================================================

-- Group by CUSTOMER_ID to compare record counts and relevant business metrics.
SELECT
    c.Customer_ID,
    c.Customer_Name,
    ROUND(SUM(o.Profit), 2) AS Total_Profit
FROM orders_clean o
INNER JOIN customers_clean c
    ON o.Customer_ID = c.Customer_ID
GROUP BY
    c.Customer_ID,
    c.Customer_Name
ORDER BY
    Total_Profit DESC
LIMIT 10;

-- ============================================================
-- BUSINESS ANALYSIS
-- STEP 8: TOP 10 CUSTOMERS BY PROFIT MARGIN
-- ============================================================

-- Group by CUSTOMER_ID to compare record counts and relevant business metrics.
SELECT
    c.Customer_ID,
    c.Customer_Name,
    ROUND(SUM(o.Sales), 2) AS Total_Sales,
    ROUND(SUM(o.Profit), 2) AS Total_Profit,
    ROUND(
        SUM(o.Profit) / SUM(o.Sales) * 100,
        2
    ) AS Profit_Margin_Pct
FROM orders_clean o
INNER JOIN customers_clean c
    ON o.Customer_ID = c.Customer_ID
GROUP BY
    c.Customer_ID,
    c.Customer_Name
ORDER BY
    Profit_Margin_Pct DESC
LIMIT 10;

-- ============================================================
-- BUSINESS ANALYSIS
-- STEP 9: DISCOUNT vs PROFITABILITY
-- ============================================================

-- Group discount values into bands and compare sales and profitability across those bands.
SELECT
    CASE
        WHEN Discount > 0.30 THEN 'Extreme High Discount'
        WHEN Discount > 0.20 AND Discount <= 0.30 THEN 'High Discount'
        WHEN Discount > 0.10 AND Discount <= 0.20 THEN 'Medium Discount'
        WHEN Discount > 0 AND Discount <= 0.10 THEN 'Low Discount'
        ELSE 'No Discount'
    END AS Discount_Band,
    ROUND(SUM(Sales), 2) AS Total_Sales,
    ROUND(SUM(Profit), 2) AS Total_Profit,
    ROUND(
        SUM(Profit) / SUM(Sales) * 100,
        2
    ) AS Profit_Margin_Pct
FROM orders_clean
GROUP BY
    Discount_Band;

-- ============================================================
-- BUSINESS ANALYSIS
-- STEP 10: CATEGORY PROFITABILITY & DISCOUNT
-- ============================================================

-- Group discount values into bands and compare sales and profitability across those bands.
SELECT
    p.Category,
    ROUND(SUM(o.Sales), 2) AS Total_Sales,
    ROUND(SUM(o.Profit), 2) AS Total_Profit,
    ROUND(AVG(o.Discount), 2) AS Avg_Discount,
    ROUND(
        SUM(o.Profit) / SUM(o.Sales) * 100,
        2
    ) AS Profit_Margin_Pct
FROM orders_clean o
INNER JOIN products_clean p
    ON o.Product_ID = p.Product_ID
GROUP BY
    p.Category
ORDER BY
    Total_Sales DESC;

-- ============================================================
-- BUSINESS ANALYSIS
-- STEP 11: MONTHLY SALES & PROFITABILITY TREND
-- ============================================================

-- Group by DATE_FORMAT(ORDER_DATE to compare record counts and relevant business metrics.
SELECT
    DATE_FORMAT(Order_Date, '%Y-%m') AS Year_Months,
    ROUND(SUM(Sales), 2) AS Total_Sales,
    ROUND(SUM(Profit), 2) AS Total_Profit,
    COUNT(DISTINCT Order_ID) AS Total_Orders,
    ROUND(
        SUM(Profit) / SUM(Sales) * 100,
        2
    ) AS Profit_Margin_Pct
FROM orders_clean
GROUP BY
    DATE_FORMAT(Order_Date, '%Y-%m')
ORDER BY
    Year_Months;


-- ============================================================
-- BUSINESS ANALYSIS
-- STEP 12: TOP 10 PRODUCTS BY SALES
-- ============================================================

-- Group by PRODUCT_ID to compare record counts and relevant business metrics.
SELECT
    p.Product_ID,
    p.Product_Name,
    ROUND(SUM(o.Sales), 2) AS Total_Sales,
    ROUND(SUM(o.Profit), 2) AS Total_Profit,
    SUM(o.Quantity) AS Total_Quantity,
    ROUND(
        SUM(o.Profit) / SUM(o.Sales) * 100,
        2
    ) AS Profit_Margin_Pct
FROM orders_clean o
INNER JOIN products_clean p
    ON o.Product_ID = p.Product_ID
GROUP BY
    p.Product_ID,
    p.Product_Name
ORDER BY
    Total_Sales DESC
LIMIT 10;

-- ============================================================
-- BUSINESS ANALYSIS
-- STEP 13: LOWEST-PROFIT PRODUCTS
-- ============================================================

-- Group by PRODUCT_ID to compare record counts and relevant business metrics.
SELECT
    p.Product_ID,
    p.Product_Name,
    ROUND(SUM(o.Sales), 2) AS Total_Sales,
    ROUND(SUM(o.Profit), 2) AS Total_Profit,
    SUM(o.Quantity) AS Total_Quantity,
    ROUND(
        SUM(o.Profit) / SUM(o.Sales) * 100,
        2
    ) AS Profit_Margin_Pct
FROM orders_clean o
INNER JOIN products_clean p
    ON o.Product_ID = p.Product_ID
GROUP BY
    p.Product_ID,
    p.Product_Name
ORDER BY
    Total_Profit ASC
LIMIT 10;

-- ============================================================
-- BUSINESS ANALYSIS
-- STEP 14: LOSS-MAKING PRODUCTS
-- ============================================================

-- Group by PRODUCT_ID to compare record counts and relevant business metrics.
SELECT
    p.Product_ID,
    p.Product_Name,
    ROUND(SUM(o.Sales), 2) AS Total_Sales,
    ROUND(SUM(o.Profit), 2) AS Total_Profit,
    SUM(o.Quantity) AS Total_Quantity,
    ROUND(
        SUM(o.Profit) / SUM(o.Sales) * 100,
        2
    ) AS Profit_Margin_Pct
FROM orders_clean o
INNER JOIN products_clean p
    ON o.Product_ID = p.Product_ID
GROUP BY
    p.Product_ID,
    p.Product_Name
HAVING
    SUM(o.Profit) < 0
ORDER BY
    Total_Profit ASC;

-- ============================================================
-- BUSINESS ANALYSIS
-- STEP 15: REGIONAL & CATEGORY PERFORMANCE
-- ============================================================

-- Review the related records and values for this data-quality or business check.
SELECT
    c.Region,
    p.Category,
    ROUND(SUM(o.Sales), 2) AS Total_Sales,
    ROUND(SUM(o.Profit), 2) AS Total_Profit,
    ROUND(
        SUM(o.Profit) / SUM(o.Sales) * 100,
        2
    ) AS Profit_Margin_Pct
FROM orders_clean o
INNER JOIN customers_clean c
    ON o.Customer_ID = c.Customer_ID
INNER JOIN products_clean p
    ON o.Product_ID = p.Product_ID
GROUP BY
    c.Region,
    p.Category
ORDER BY
    Total_Sales DESC;

-- ============================================================
-- BUSINESS ANALYSIS
-- STEP 16: SHIPPING MODE PERFORMANCE
-- ============================================================

-- Compare order count, sales, and profit across shipping modes.
SELECT
    Ship_Mode,
    COUNT(DISTINCT Order_ID) AS Total_Orders,
    ROUND(SUM(Sales), 2) AS Total_Sales,
    ROUND(SUM(Profit), 2) AS Total_Profit,
    ROUND(
        SUM(Profit) / SUM(Sales) * 100,
        2
    ) AS Profit_Margin_Pct
FROM orders_clean
GROUP BY
    Ship_Mode
ORDER BY
    Total_Sales DESC;

-- ============================================================
-- BUSINESS ANALYSIS
-- STEP 17: SHIPPING TIME BY SHIP MODE
-- ============================================================

-- Compare Order_Date and Ship_Date to identify records where the shipping date is earlier than the order date.
SELECT
    Ship_Mode,
    COUNT(DISTINCT Order_ID) AS Total_Orders,
    ROUND(
        AVG(DATEDIFF(Ship_Date, Order_Date)),
        2
    ) AS Avg_Shipping_Days
FROM orders_clean
GROUP BY
    Ship_Mode
ORDER BY
    Total_Orders DESC;

-- ============================================================
-- BUSINESS ANALYSIS
-- STEP 18: PAYMENT MODE PERFORMANCE
-- ============================================================

-- Review the related records and values for this data-quality or business check.
SELECT
    Payment_Mode,
    COUNT(DISTINCT Order_ID) AS Total_Orders,
    ROUND(SUM(Sales), 2) AS Total_Sales,
    ROUND(SUM(Profit), 2) AS Total_Profit,
    ROUND(
        SUM(Profit) / SUM(Sales) * 100,
        2
    ) AS Profit_Margin_Pct
FROM orders_clean
GROUP BY
    Payment_Mode
ORDER BY
    Total_Sales DESC;

-- ============================================================
-- BUSINESS ANALYSIS
-- STEP 19: CUSTOMER PURCHASE FREQUENCY
-- ============================================================

-- Group by CUSTOMER_ID to compare record counts and relevant business metrics.
SELECT
    c.Customer_ID,
    c.Customer_Name,
    COUNT(DISTINCT o.Order_ID) AS Total_Orders,
    ROUND(SUM(o.Sales), 2) AS Total_Sales,
    ROUND(SUM(o.Profit), 2) AS Total_Profit,
    ROUND(
        SUM(o.Sales) / COUNT(DISTINCT o.Order_ID),
        2
    ) AS Average_Order_Value
FROM orders_clean o
INNER JOIN customers_clean c
    ON o.Customer_ID = c.Customer_ID
GROUP BY
    c.Customer_ID,
    c.Customer_Name
ORDER BY
    Total_Orders DESC
LIMIT 10;

-- ============================================================
-- BUSINESS ANALYSIS
-- STEP 20: REPEAT vs ONE-TIME CUSTOMERS
-- ============================================================

-- Group by CUSTOMER_ID to compare record counts and relevant business metrics.
WITH Customer_Summary AS (
    SELECT
        Customer_ID,
        COUNT(DISTINCT Order_ID) AS Total_Orders,
        ROUND(SUM(Sales), 2) AS Total_Sales,
        ROUND(SUM(Profit), 2) AS Total_Profit
    FROM orders_clean
    WHERE Customer_ID IS NOT NULL
    GROUP BY
        Customer_ID
)

SELECT
    CASE
        WHEN Total_Orders = 1 THEN 'One-Time'
        ELSE 'Repeat'
    END AS Customer_Type,

    COUNT(*) AS Total_Customers,

    ROUND(SUM(Total_Sales), 2) AS Total_Sales,

    ROUND(SUM(Total_Profit), 2) AS Total_Profit,

    ROUND(AVG(Total_Sales), 2) AS Average_Customer_Sales

FROM Customer_Summary
GROUP BY
    Customer_Type
ORDER BY
    Total_Sales DESC;

-- ============================================================
-- BUSINESS ANALYSIS
-- STEP 21: CUSTOMER RECENCY ANALYSIS
-- ============================================================

-- Review the related records and values for this data-quality or business check.
WITH Customer_Summary AS (
    SELECT
        c.Customer_ID,
        c.Customer_Name,
        MAX(o.Order_Date) AS Last_Order_Date
    FROM customers_clean c
    INNER JOIN orders_clean o
        ON c.Customer_ID = o.Customer_ID
    GROUP BY
        c.Customer_ID,
        c.Customer_Name
),
Latest_Date AS (
    SELECT
        MAX(Order_Date) AS Latest_Order_Date
    FROM orders_clean
)

SELECT
    cs.Customer_ID,
    cs.Customer_Name,
    cs.Last_Order_Date,
    DATEDIFF(
        ld.Latest_Order_Date,
        cs.Last_Order_Date
    ) AS Recency_Days
FROM Customer_Summary cs
CROSS JOIN Latest_Date ld
ORDER BY
    Recency_Days;

-- ============================================================
-- BUSINESS ANALYSIS
-- STEP 22: CUSTOMER RFM BASE ANALYSIS
-- ============================================================

-- Review the related records and values for this data-quality or business check.
WITH Customer_Summary AS (
    SELECT
        c.Customer_ID,
        c.Customer_Name,
        MAX(o.Order_Date) AS Last_Order_Date,
        COUNT(DISTINCT o.Order_ID) AS Frequency,
        ROUND(SUM(o.Sales), 2) AS Monetary
    FROM customers_clean c
    INNER JOIN orders_clean o
        ON c.Customer_ID = o.Customer_ID
    GROUP BY
        c.Customer_ID,
        c.Customer_Name
),
Latest_Date AS (
    SELECT
        MAX(Order_Date) AS Latest_Order_Date
    FROM orders_clean
)

SELECT
    cs.Customer_ID,
    cs.Customer_Name,
    DATEDIFF(
        ld.Latest_Order_Date,
        cs.Last_Order_Date
    ) AS Recency_Days,
    cs.Frequency,
    cs.Monetary
FROM Customer_Summary cs
CROSS JOIN Latest_Date ld
ORDER BY
    Recency_Days;

-- ============================================================
-- BUSINESS ANALYSIS
-- STEP 23: RFM SCORING
-- ============================================================

-- Review the related records and values for this data-quality or business check.
WITH Customer_Summary AS (
    SELECT
        c.Customer_ID,
        c.Customer_Name,
        MAX(o.Order_Date) AS Last_Order_Date,
        COUNT(DISTINCT o.Order_ID) AS Frequency,
        ROUND(SUM(o.Sales), 2) AS Monetary
    FROM customers_clean c
    INNER JOIN orders_clean o
        ON c.Customer_ID = o.Customer_ID
    GROUP BY
        c.Customer_ID,
        c.Customer_Name
),
Latest_Date AS (
    SELECT
        MAX(Order_Date) AS Latest_Order_Date
    FROM orders_clean
),
RFM AS (
    SELECT
        cs.Customer_ID,
        cs.Customer_Name,
        DATEDIFF(
            ld.Latest_Order_Date,
            cs.Last_Order_Date
        ) AS Recency_Days,
        cs.Frequency,
        cs.Monetary
    FROM Customer_Summary cs
    CROSS JOIN Latest_Date ld
)

SELECT
    *,
    NTILE(5) OVER (
        ORDER BY Recency_Days DESC
    ) AS Recency_Scoring,

    NTILE(5) OVER (
        ORDER BY Frequency ASC
    ) AS Frequency_Scoring,

    NTILE(5) OVER (
        ORDER BY Monetary ASC
    ) AS Monetary_Scoring

FROM RFM;

-- ============================================================
-- BUSINESS ANALYSIS
-- STEP 24: RFM TOTAL SCORE
-- ============================================================

-- Review the related records and values for this data-quality or business check.
WITH Customer_Summary AS (
    SELECT
        c.Customer_ID,
        c.Customer_Name,
        MAX(o.Order_Date) AS Last_Order_Date,
        COUNT(DISTINCT o.Order_ID) AS Frequency,
        ROUND(SUM(o.Sales), 2) AS Monetary
    FROM customers_clean c
    INNER JOIN orders_clean o
        ON c.Customer_ID = o.Customer_ID
    GROUP BY
        c.Customer_ID,
        c.Customer_Name
),
Latest_Date AS (
    SELECT
        MAX(Order_Date) AS Latest_Order_Date
    FROM orders_clean
),
RFM AS (
    SELECT
        cs.Customer_ID,
        cs.Customer_Name,
        DATEDIFF(
            ld.Latest_Order_Date,
            cs.Last_Order_Date
        ) AS Recency_Days,
        cs.Frequency,
        cs.Monetary
    FROM Customer_Summary cs
    CROSS JOIN Latest_Date ld
),
RFM_Scoring AS (
    SELECT
        *,
        NTILE(5) OVER (
            ORDER BY Recency_Days DESC
        ) AS Recency_Scoring,

        NTILE(5) OVER (
            ORDER BY Frequency ASC
        ) AS Frequency_Scoring,

        NTILE(5) OVER (
            ORDER BY Monetary ASC
        ) AS Monetary_Scoring
    FROM RFM
)

SELECT
    *,
    Recency_Scoring
        + Frequency_Scoring
        + Monetary_Scoring AS RFM_Total_Score
FROM RFM_Scoring;

-- ============================================================
-- BUSINESS ANALYSIS
-- STEP 25: RFM CUSTOMER SEGMENT PERFORMANCE
-- ============================================================

-- Review the related records and values for this data-quality or business check.
WITH Customer_Summary AS (
    SELECT
        c.Customer_ID,
        c.Customer_Name,
        MAX(o.Order_Date) AS Last_Order_Date,
        COUNT(DISTINCT o.Order_ID) AS Frequency,
        ROUND(SUM(o.Sales), 2) AS Monetary,
        ROUND(SUM(o.Profit), 2) AS Total_Profit
    FROM customers_clean c
    INNER JOIN orders_clean o
        ON c.Customer_ID = o.Customer_ID
    GROUP BY
        c.Customer_ID,
        c.Customer_Name
),
Latest_Date AS (
    SELECT
        MAX(Order_Date) AS Latest_Order_Date
    FROM orders_clean
),
RFM AS (
    SELECT
        cs.Customer_ID,
        cs.Customer_Name,
        DATEDIFF(
            ld.Latest_Order_Date,
            cs.Last_Order_Date
        ) AS Recency_Days,
        cs.Frequency,
        cs.Monetary,
        cs.Total_Profit
    FROM Customer_Summary cs
    CROSS JOIN Latest_Date ld
),
RFM_Scoring AS (
    SELECT
        *,
        NTILE(5) OVER (
            ORDER BY Recency_Days DESC
        ) AS Recency_Scoring,

        NTILE(5) OVER (
            ORDER BY Frequency ASC
        ) AS Frequency_Scoring,

        NTILE(5) OVER (
            ORDER BY Monetary ASC
        ) AS Monetary_Scoring
    FROM RFM
),
RFM_Total AS (
    SELECT
        *,
        Recency_Scoring
            + Frequency_Scoring
            + Monetary_Scoring AS RFM_Total_Score
    FROM RFM_Scoring
),
Customer_Segment AS (
    SELECT
        *,
        CASE
            WHEN RFM_Total_Score BETWEEN 13 AND 15
                THEN 'High Value'
            WHEN RFM_Total_Score BETWEEN 10 AND 12
                THEN 'Medium Value'
            WHEN RFM_Total_Score BETWEEN 7 AND 9
                THEN 'Low Value'
            ELSE 'At Risk'
        END AS Customer_Segment
    FROM RFM_Total
)

SELECT
    Customer_Segment,
    COUNT(*) AS Total_Customers,
    ROUND(SUM(Monetary), 2) AS Total_Sales,
    ROUND(SUM(Total_Profit), 2) AS Total_Profit,
    ROUND(AVG(Monetary), 2) AS Avg_Customer_Sales
FROM Customer_Segment
GROUP BY
    Customer_Segment
ORDER BY
    Total_Sales DESC;

-- ============================================================
-- BUSINESS ANALYSIS
-- STEP 26: CUSTOMER RETENTION / REPEAT PURCHASE RATE
-- ============================================================

-- Group by CUSTOMER_ID to compare record counts and relevant business metrics.
WITH Customer_Summary AS (
    SELECT
        Customer_ID,
        COUNT(DISTINCT Order_ID) AS Total_Orders
    FROM orders_clean
    WHERE Customer_ID IS NOT NULL
    GROUP BY
        Customer_ID
),
Customer_Type AS (
    SELECT
        CASE
            WHEN Total_Orders = 1 THEN 'One-Time'
            ELSE 'Repeat'
        END AS Customer_Type
    FROM Customer_Summary
)

SELECT
    Customer_Type,
    COUNT(*) AS Total_Customers,
    ROUND(
        COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (),
        2
    ) AS Customer_Percentage
FROM Customer_Type
GROUP BY
    Customer_Type
ORDER BY
    Customer_Percentage DESC;

-- ============================================================
-- BUSINESS ANALYSIS
-- STEP 27: CUSTOMER LIFETIME VALUE (BASIC)
-- ============================================================

-- Group by CUSTOMER_ID to compare record counts and relevant business metrics.
WITH Customer_Summary AS (
    SELECT
        c.Customer_ID,
        c.Customer_Name,
        COUNT(DISTINCT o.Order_ID) AS Total_Orders,
        ROUND(SUM(o.Sales), 2) AS Total_Sales,
        ROUND(SUM(o.Profit), 2) AS Total_Profit,
        ROUND(
            SUM(o.Profit) / SUM(o.Sales) * 100,
            2
        ) AS Profit_Margin_Pct
    FROM customers_clean c
    INNER JOIN orders_clean o
        ON c.Customer_ID = o.Customer_ID
    GROUP BY
        c.Customer_ID,
        c.Customer_Name
)

SELECT
    *
FROM Customer_Summary
ORDER BY
    Total_Sales DESC;
    
-- ============================================================
-- BUSINESS ANALYSIS
-- STEP 28: TOP 10 CUSTOMERS BY PROFIT
-- ============================================================

-- Group by CUSTOMER_ID to compare record counts and relevant business metrics.
WITH Customer_Summary AS (
    SELECT
        c.Customer_ID,
        c.Customer_Name,
        COUNT(DISTINCT o.Order_ID) AS Total_Orders,
        ROUND(SUM(o.Sales), 2) AS Total_Sales,
        ROUND(SUM(o.Profit), 2) AS Total_Profit,
        ROUND(
            SUM(o.Profit) / SUM(o.Sales) * 100,
            2
        ) AS Profit_Margin_Pct
    FROM customers_clean c
    INNER JOIN orders_clean o
        ON c.Customer_ID = o.Customer_ID
    GROUP BY
        c.Customer_ID,
        c.Customer_Name
)

SELECT
    *
FROM Customer_Summary
ORDER BY
    Total_Profit DESC
LIMIT 10;

-- ============================================================
-- BUSINESS ANALYSIS
-- STEP 29: HIGH SALES BUT LOW PROFITABILITY CUSTOMERS
-- ============================================================

-- Group by CUSTOMER_ID to compare record counts and relevant business metrics.
WITH Customer_Summary AS (
    SELECT
        c.Customer_ID,
        c.Customer_Name,
        ROUND(SUM(o.Sales), 2) AS Total_Sales,
        ROUND(SUM(o.Profit), 2) AS Total_Profit,
        ROUND(
            SUM(o.Profit) / SUM(o.Sales) * 100,
            2
        ) AS Profit_Margin_Pct
    FROM customers_clean c
    INNER JOIN orders_clean o
        ON c.Customer_ID = o.Customer_ID
    GROUP BY
        c.Customer_ID,
        c.Customer_Name
),
Benchmarks AS (
    SELECT
        AVG(Total_Sales) AS Avg_Sales,
        AVG(Profit_Margin_Pct) AS Avg_Profit_Margin
    FROM Customer_Summary
)

SELECT
    cs.Customer_ID,
    cs.Customer_Name,
    cs.Total_Sales,
    cs.Total_Profit,
    cs.Profit_Margin_Pct
FROM Customer_Summary cs
CROSS JOIN Benchmarks b
WHERE cs.Total_Sales > b.Avg_Sales
  AND cs.Profit_Margin_Pct < b.Avg_Profit_Margin
ORDER BY
    cs.Total_Sales DESC;
    
-- ============================================================
-- BUSINESS ANALYSIS
-- STEP 30: HIGH SALES & HIGH PROFITABILITY CUSTOMERS
-- ============================================================

-- Group by CUSTOMER_ID to compare record counts and relevant business metrics.
WITH Customer_Summary AS (
    SELECT
        c.Customer_ID,
        c.Customer_Name,
        ROUND(SUM(o.Sales), 2) AS Total_Sales,
        ROUND(SUM(o.Profit), 2) AS Total_Profit,
        ROUND(
            SUM(o.Profit) / SUM(o.Sales) * 100,
            2
        ) AS Profit_Margin_Pct
    FROM customers_clean c
    INNER JOIN orders_clean o
        ON c.Customer_ID = o.Customer_ID
    GROUP BY
        c.Customer_ID,
        c.Customer_Name
),
Benchmarks AS (
    SELECT
        AVG(Total_Sales) AS Avg_Sales,
        AVG(Profit_Margin_Pct) AS Avg_Profit_Margin
    FROM Customer_Summary
)

SELECT
    cs.Customer_ID,
    cs.Customer_Name,
    cs.Total_Sales,
    cs.Total_Profit,
    cs.Profit_Margin_Pct
FROM Customer_Summary cs
CROSS JOIN Benchmarks b
WHERE cs.Total_Sales > b.Avg_Sales
  AND cs.Profit_Margin_Pct > b.Avg_Profit_Margin
ORDER BY
    cs.Total_Sales DESC;
    
-- ============================================================
-- BUSINESS ANALYSIS
-- STEP 31: CUSTOMER COHORT ACQUISITION
-- ============================================================

-- Review the related records and values for this data-quality or business check.
WITH First_Purchase_Date AS (
    SELECT
        Customer_ID,
        MIN(Order_Date) AS First_Purchase_Date
    FROM orders_clean
    WHERE Customer_ID IS NOT NULL
    GROUP BY
        Customer_ID
),
Cohort_Month AS (
    SELECT
        DATE_FORMAT(
            First_Purchase_Date,
            '%Y-%m'
        ) AS Cohort_Month
    FROM First_Purchase_Date
)

SELECT
    Cohort_Month,
    COUNT(*) AS New_Customers
FROM Cohort_Month
GROUP BY
    Cohort_Month
ORDER BY
    Cohort_Month;
    
-- ============================================================
-- BUSINESS ANALYSIS
-- STEP 32: COHORT ACTIVITY MONTH & MONTH NUMBER
-- ============================================================

-- Review the related records and values for this data-quality or business check.
WITH Cohort_Month AS (
    SELECT
        Customer_ID,
        DATE_FORMAT(
            MIN(Order_Date),
            '%Y-%m-01'
        ) AS Cohort_Month
    FROM orders_clean
    WHERE Customer_ID IS NOT NULL
    GROUP BY
        Customer_ID
),
Activity_Month AS (
    SELECT DISTINCT
        Customer_ID,
        DATE_FORMAT(
            Order_Date,
            '%Y-%m-01'
        ) AS Activity_Month
    FROM orders_clean
    WHERE Customer_ID IS NOT NULL
)

SELECT
    c.Customer_ID,
    c.Cohort_Month,
    a.Activity_Month,
    TIMESTAMPDIFF(
        MONTH,
        c.Cohort_Month,
        a.Activity_Month
    ) AS Month_Number
FROM Cohort_Month c
INNER JOIN Activity_Month a
    ON c.Customer_ID = a.Customer_ID
ORDER BY
    c.Cohort_Month,
    c.Customer_ID,
    a.Activity_Month;

-- ============================================================
-- BUSINESS ANALYSIS
-- STEP 32: COHORT ACTIVE CUSTOMERS
-- ============================================================

-- Review the related records and values for this data-quality or business check.
WITH Cohort_Month AS (
    SELECT
        Customer_ID,
        DATE_FORMAT(
            MIN(Order_Date),
            '%Y-%m-01'
        ) AS Cohort_Month
    FROM orders_clean
    WHERE Customer_ID IS NOT NULL
    GROUP BY
        Customer_ID
),
Activity_Month AS (
    SELECT DISTINCT
        Customer_ID,
        DATE_FORMAT(
            Order_Date,
            '%Y-%m-01'
        ) AS Activity_Month
    FROM orders_clean
    WHERE Customer_ID IS NOT NULL
),
Cohort_Activity AS (
    SELECT
        c.Customer_ID,
        c.Cohort_Month,
        a.Activity_Month,
        TIMESTAMPDIFF(
            MONTH,
            c.Cohort_Month,
            a.Activity_Month
        ) AS Month_Number
    FROM Cohort_Month c
    INNER JOIN Activity_Month a
        ON c.Customer_ID = a.Customer_ID
)

SELECT
    Cohort_Month,
    Month_Number,
    COUNT(DISTINCT Customer_ID) AS Active_Customers
FROM Cohort_Activity
GROUP BY
    Cohort_Month,
    Month_Number
ORDER BY
    Cohort_Month,
    Month_Number;
    
-- ============================================================
-- BUSINESS ANALYSIS
-- STEP 32: COHORT RETENTION ANALYSIS
-- ============================================================

-- Review the related records and values for this data-quality or business check.
WITH Cohort_Month AS (
    SELECT
        Customer_ID,
        DATE_FORMAT(
            MIN(Order_Date),
            '%Y-%m-01'
        ) AS Cohort_Month
    FROM orders_clean
    WHERE Customer_ID IS NOT NULL
    GROUP BY
        Customer_ID
),
Activity_Month AS (
    SELECT DISTINCT
        Customer_ID,
        DATE_FORMAT(
            Order_Date,
            '%Y-%m-01'
        ) AS Activity_Month
    FROM orders_clean
    WHERE Customer_ID IS NOT NULL
),
Cohort_Activity AS (
    SELECT
        c.Customer_ID,
        c.Cohort_Month,
        a.Activity_Month,
        TIMESTAMPDIFF(
            MONTH,
            c.Cohort_Month,
            a.Activity_Month
        ) AS Month_Number
    FROM Cohort_Month c
    INNER JOIN Activity_Month a
        ON c.Customer_ID = a.Customer_ID
),
Cohort_Size AS (
    SELECT
        Cohort_Month,
        COUNT(DISTINCT Customer_ID) AS Cohort_Size
    FROM Cohort_Month
    GROUP BY
        Cohort_Month
),
Customer_Retention AS (
    SELECT
        Cohort_Month,
        Month_Number,
        COUNT(DISTINCT Customer_ID) AS Active_Customers
    FROM Cohort_Activity
    GROUP BY
        Cohort_Month,
        Month_Number
)

SELECT
    cr.Cohort_Month,
    cr.Month_Number,
    cs.Cohort_Size,
    cr.Active_Customers,
    ROUND(
        cr.Active_Customers * 100.0 / cs.Cohort_Size,
        2
    ) AS Retention_Pct
FROM Cohort_Size cs
INNER JOIN Customer_Retention cr
    ON cs.Cohort_Month = cr.Cohort_Month
ORDER BY
    cr.Cohort_Month,
    cr.Month_Number;
    
-- ============================================================
-- BUSINESS ANALYSIS
-- STEP 33: COHORT RETENTION MATRIX
-- ============================================================

-- Review the related records and values for this data-quality or business check.
WITH Cohort_Month AS (
    SELECT
        Customer_ID,
        DATE_FORMAT(
            MIN(Order_Date),
            '%Y-%m-01'
        ) AS Cohort_Month
    FROM orders_clean
    WHERE Customer_ID IS NOT NULL
    GROUP BY
        Customer_ID
),
Activity_Month AS (
    SELECT DISTINCT
        Customer_ID,
        DATE_FORMAT(
            Order_Date,
            '%Y-%m-01'
        ) AS Activity_Month
    FROM orders_clean
    WHERE Customer_ID IS NOT NULL
),
Cohort_Activity AS (
    SELECT
        c.Customer_ID,
        c.Cohort_Month,
        a.Activity_Month,
        TIMESTAMPDIFF(
            MONTH,
            c.Cohort_Month,
            a.Activity_Month
        ) AS Month_Number
    FROM Cohort_Month c
    INNER JOIN Activity_Month a
        ON c.Customer_ID = a.Customer_ID
),
Cohort_Size AS (
    SELECT
        Cohort_Month,
        COUNT(DISTINCT Customer_ID) AS Cohort_Size
    FROM Cohort_Month
    GROUP BY
        Cohort_Month
),
Customer_Retention AS (
    SELECT
        Cohort_Month,
        Month_Number,
        COUNT(DISTINCT Customer_ID) AS Active_Customers
    FROM Cohort_Activity
    GROUP BY
        Cohort_Month,
        Month_Number
),
Retention_Pct AS (
    SELECT
        cr.Cohort_Month,
        cr.Month_Number,
        ROUND(
            cr.Active_Customers * 100.0 / cs.Cohort_Size,
            2
        ) AS Retention_Pct
    FROM Cohort_Size cs
    INNER JOIN Customer_Retention cr
        ON cs.Cohort_Month = cr.Cohort_Month
)

SELECT
    Cohort_Month,

    MAX(
        CASE
            WHEN Month_Number = 0
            THEN Retention_Pct
        END
    ) AS Month_0,

    MAX(
        CASE
            WHEN Month_Number = 1
            THEN Retention_Pct
        END
    ) AS Month_1,

    MAX(
        CASE
            WHEN Month_Number = 2
            THEN Retention_Pct
        END
    ) AS Month_2,

    MAX(
        CASE
            WHEN Month_Number = 3
            THEN Retention_Pct
        END
    ) AS Month_3

FROM Retention_Pct
GROUP BY
    Cohort_Month
ORDER BY
    Cohort_Month;
    
-- ============================================================
-- BUSINESS ANALYSIS
-- STEP 34: CUSTOMER INACTIVITY / CHURN CANDIDATES
-- ============================================================

-- Review the related records and values for this data-quality or business check.
WITH Last_Order_Date AS (
    SELECT
        c.Customer_ID,
        c.Customer_Name,
        MAX(o.Order_Date) AS Last_Order_Date
    FROM orders_clean o
    INNER JOIN customers_clean c
        ON c.Customer_ID = o.Customer_ID
    GROUP BY
        c.Customer_ID,
        c.Customer_Name
),
Latest_Date AS (
    SELECT
        MAX(Order_Date) AS Latest_Order_Date
    FROM orders_clean
),
Customer_Recency AS (
    SELECT
        cs.Customer_ID,
        cs.Customer_Name,
        cs.Last_Order_Date,
        DATEDIFF(
            ld.Latest_Order_Date,
            cs.Last_Order_Date
        ) AS Inactive_Days
    FROM Last_Order_Date cs
    CROSS JOIN Latest_Date ld
)

SELECT
    Customer_ID,
    Customer_Name,
    Last_Order_Date,
    Inactive_Days
FROM Customer_Recency
WHERE Inactive_Days >= 180
ORDER BY
    Inactive_Days DESC;

-- ============================================================
-- BUSINESS ANALYSIS
-- STEP 35: CUSTOMER SALES PARETO ANALYSIS
-- ============================================================

-- Group by CUSTOMER_ID to compare record counts and relevant business metrics.
WITH Customer_Sales AS (
    SELECT
        c.Customer_ID,
        c.Customer_Name,
        SUM(o.Sales) AS Total_Sales
    FROM orders_clean o
    INNER JOIN customers_clean c
        ON c.Customer_ID = o.Customer_ID
    GROUP BY
        c.Customer_ID,
        c.Customer_Name
),
Cumulative_Sales AS (
    SELECT
        *,
        SUM(Total_Sales) OVER (
            ORDER BY Total_Sales DESC
            ROWS BETWEEN UNBOUNDED PRECEDING
            AND CURRENT ROW
        ) AS Cumulative_Sales,
        SUM(Total_Sales) OVER () AS Overall_Sales
    FROM Customer_Sales
)

SELECT
    Customer_ID,
    Customer_Name,
    ROUND(Total_Sales, 2) AS Total_Sales,
    ROUND(Cumulative_Sales, 2) AS Cumulative_Sales,
    ROUND(
        Cumulative_Sales * 100.0 / Overall_Sales,
        2
    ) AS Cumulative_Sales_Pct
FROM Cumulative_Sales
ORDER BY
    Total_Sales DESC;
    
-- ============================================================
-- BUSINESS ANALYSIS
-- STEP 36: CUSTOMERS REQUIRED TO REACH 80% SALES
-- ============================================================

-- Group by CUSTOMER_ID to compare record counts and relevant business metrics.
WITH Customer_Sales AS (
    SELECT
        c.Customer_ID,
        c.Customer_Name,
        SUM(o.Sales) AS Total_Sales
    FROM orders_clean o
    INNER JOIN customers_clean c
        ON c.Customer_ID = o.Customer_ID
    GROUP BY
        c.Customer_ID,
        c.Customer_Name
),
Cumulative_Sales AS (
    SELECT
        *,
        ROW_NUMBER() OVER (
            ORDER BY Total_Sales DESC
        ) AS Customer_Rank,

        SUM(Total_Sales) OVER (
            ORDER BY Total_Sales DESC
            ROWS BETWEEN UNBOUNDED PRECEDING
            AND CURRENT ROW
        ) AS Cumulative_Sales,

        SUM(Total_Sales) OVER () AS Overall_Sales
    FROM Customer_Sales
),
Pareto AS (
    SELECT
        Customer_ID,
        Customer_Name,
        Customer_Rank,
        ROUND(Total_Sales, 2) AS Total_Sales,
        ROUND(Cumulative_Sales, 2) AS Cumulative_Sales,
        ROUND(
            Cumulative_Sales * 100.0 / Overall_Sales,
            2
        ) AS Cumulative_Sales_Pct
    FROM Cumulative_Sales
)

SELECT
    Customer_Rank,
    Customer_ID,
    Customer_Name,
    Total_Sales,
    Cumulative_Sales,
    Cumulative_Sales_Pct
FROM Pareto
WHERE Cumulative_Sales_Pct >= 80
ORDER BY Customer_Rank
LIMIT 1;
 
-- ============================================================
-- BUSINESS ANALYSIS
-- STEP 37: PRODUCTS REQUIRED TO REACH 80% SALES
-- ============================================================

-- Group by PRODUCT_ID to compare record counts and relevant business metrics.
WITH Product_Sales AS (
    SELECT
        p.Product_ID,
        p.Product_Name,
        SUM(o.Sales) AS Total_Sales
    FROM orders_clean o
    INNER JOIN products_clean p
        ON p.Product_ID = o.Product_ID
    GROUP BY
        p.Product_ID,
        p.Product_Name
),
Cumulative_Sales AS (
    SELECT
        *,
        ROW_NUMBER() OVER (
            ORDER BY Total_Sales DESC
        ) AS Product_Rank,

        SUM(Total_Sales) OVER (
            ORDER BY Total_Sales DESC
            ROWS BETWEEN UNBOUNDED PRECEDING
            AND CURRENT ROW
        ) AS Cumulative_Sales,

        SUM(Total_Sales) OVER () AS Overall_Sales
    FROM Product_Sales
),
Pareto AS (
    SELECT
        Product_ID,
        Product_Name,
        Product_Rank,
        ROUND(Total_Sales, 2) AS Total_Sales,
        ROUND(Cumulative_Sales, 2) AS Cumulative_Sales,
        ROUND(
            Cumulative_Sales * 100.0 / Overall_Sales,
            2
        ) AS Cumulative_Sales_Pct
    FROM Cumulative_Sales
)

SELECT
    Product_Rank,
    Product_ID,
    Product_Name,
    Total_Sales,
    Cumulative_Sales,
    Cumulative_Sales_Pct
FROM Pareto
WHERE Cumulative_Sales_Pct >= 80
ORDER BY
    Product_Rank
LIMIT 1;
    
-- ============================================================
-- BUSINESS INVESTIGATION
-- Q38 - PART 1: DISCOUNT BAND PROFITABILITY ANALYSIS
-- ============================================================

-- Group discount values into bands and compare sales and profitability across those bands.
SELECT
    CASE
        WHEN Discount > 0.30 THEN 'Extreme High Discount'
        WHEN Discount > 0.20 AND Discount <= 0.30 THEN 'High Discount'
        WHEN Discount > 0.10 AND Discount <= 0.20 THEN 'Medium Discount'
        WHEN Discount > 0 AND Discount <= 0.10 THEN 'Low Discount'
        ELSE 'No Discount'
    END AS Discount_Band,
    
    ROUND(SUM(Sales), 2) AS Total_Sales,
    ROUND(SUM(Profit), 2) AS Total_Profit,
    ROUND(SUM(Profit) / SUM(Sales) * 100, 2) AS Profit_Margin_Pct,
    COUNT(DISTINCT Order_ID) AS Total_Orders

FROM orders_clean

GROUP BY Discount_Band
ORDER BY Profit_Margin_Pct;

-- ============================================================
-- BUSINESS INVESTIGATION
-- Q38 - PART 2: CATEGORY PROFITABILITY ANALYSIS
-- ============================================================

-- Group discount values into bands and compare sales and profitability across those bands.
SELECT
    p.Category,
    ROUND(SUM(o.Sales), 2) AS Total_Sales,
    ROUND(SUM(o.Profit), 2) AS Total_Profit,
    ROUND(AVG(o.Discount), 2) AS Avg_Discount,
    ROUND(
        SUM(o.Profit) / SUM(o.Sales) * 100,
        2
    ) AS Profit_Margin_Pct
FROM orders_clean o
INNER JOIN products_clean p
    ON o.Product_ID = p.Product_ID
GROUP BY p.Category
ORDER BY Profit_Margin_Pct ASC;

-- ============================================================
-- BUSINESS INVESTIGATION
-- Q38 - PART 3: FURNITURE SUB-CATEGORY PROFITABILITY
-- ============================================================

-- Review the related records and values for this data-quality or business check.
SELECT
    p.Sub_Category,
    ROUND(SUM(o.Sales), 2) AS Total_Sales,
    ROUND(SUM(o.Profit), 2) AS Total_Profit,
    ROUND(
        SUM(o.Profit) / SUM(o.Sales) * 100,
        2
    ) AS Profit_Margin_Pct,
    ROUND(AVG(o.Discount), 2) AS Avg_Discount
FROM orders_clean o
INNER JOIN products_clean p
    ON o.Product_ID = p.Product_ID
WHERE p.Category = 'Furniture'
GROUP BY
    p.Sub_Category
ORDER BY
    Profit_Margin_Pct ASC;

-- ============================================================
-- BUSINESS INVESTIGATION
-- Q38 - PART 4: FURNITURE SUB-CATEGORY DISCOUNT COMPARISON
-- ============================================================

-- Review the related records and values for this data-quality or business check.
SELECT
    p.Sub_Category,
    ROUND(SUM(o.Sales), 2) AS Total_Sales,
    ROUND(SUM(o.Profit), 2) AS Total_Profit,
    ROUND(
        SUM(o.Profit) / SUM(o.Sales) * 100,
        2
    ) AS Profit_Margin_Pct,
    ROUND(AVG(o.Discount), 2) AS Avg_Discount
FROM orders_clean o
INNER JOIN products_clean p
    ON o.Product_ID = p.Product_ID
WHERE p.Category = 'Furniture'
GROUP BY
    p.Sub_Category
ORDER BY
    Profit_Margin_Pct ASC;
    
-- ============================================================
-- BUSINESS INVESTIGATION
-- Q38 - PART 5: LOSS-MAKING FURNITURE SUB-CATEGORIES
-- ============================================================

-- Review the related records and values for this data-quality or business check.
SELECT
    p.Sub_Category,
    ROUND(SUM(o.Sales), 2) AS Total_Sales,
    ROUND(SUM(o.Profit), 2) AS Total_Profit,
    ROUND(
        SUM(o.Profit) / SUM(o.Sales) * 100,
        2
    ) AS Profit_Margin_Pct,
    ROUND(AVG(o.Discount), 2) AS Avg_Discount
FROM orders_clean o
INNER JOIN products_clean p
    ON o.Product_ID = p.Product_ID
WHERE p.Category = 'Furniture'
GROUP BY
    p.Sub_Category
HAVING
    SUM(o.Profit) < 0
ORDER BY
    Profit_Margin_Pct ASC;

-- ============================================================
-- BUSINESS INVESTIGATION
-- Q38 - PART 6: CATEGORY CONTRIBUTION TO TOTAL BUSINESS
-- ============================================================

-- Group by CATEGORY to compare record counts and relevant business metrics.
WITH Category_Summary AS (
    SELECT
        p.Category,
        SUM(o.Sales) AS Total_Sales,
        SUM(o.Profit) AS Total_Profit
    FROM orders_clean o
    INNER JOIN products_clean p
        ON o.Product_ID = p.Product_ID
    GROUP BY p.Category
),

Overall_Summary AS (
    SELECT
        SUM(Sales) AS Overall_Sales,
        SUM(Profit) AS Overall_Profit
    FROM orders_clean
)

SELECT
    cs.Category,
    ROUND(cs.Total_Sales, 2) AS Total_Sales,
    ROUND(cs.Total_Profit, 2) AS Total_Profit,
    ROUND(
        cs.Total_Profit / cs.Total_Sales * 100,
        2
    ) AS Profit_Margin_Pct,
    ROUND(
        cs.Total_Sales / os.Overall_Sales * 100,
        2
    ) AS Sales_Contribution_Pct,
    ROUND(
        cs.Total_Profit / os.Overall_Profit * 100,
        2
    ) AS Profit_Contribution_Pct
FROM Category_Summary cs
CROSS JOIN Overall_Summary os
WHERE cs.Category = 'Furniture';


-- ============================================================
-- BUSINESS INVESTIGATION
-- Q38 - PART 7: CATEGORY PROFIT GAP ANALYSIS
-- ============================================================

-- Group by CATEGORY to compare record counts and relevant business metrics.
WITH Category_Summary AS (
    SELECT
        p.Category,
        SUM(o.Sales) AS Total_Sales,
        SUM(o.Profit) AS Total_Profit
    FROM orders_clean o
    INNER JOIN products_clean p
        ON o.Product_ID = p.Product_ID
    GROUP BY p.Category
),

Overall_Summary AS (
    SELECT
        SUM(Sales) AS Overall_Sales,
        SUM(Profit) AS Overall_Profit
    FROM orders_clean
),

Contribution_Analysis AS (
    SELECT
        cs.Category,
        ROUND(cs.Total_Sales, 2) AS Total_Sales,
        ROUND(cs.Total_Profit, 2) AS Total_Profit,
        ROUND(
            cs.Total_Profit / cs.Total_Sales * 100,
            2
        ) AS Profit_Margin_Pct,
        ROUND(
            cs.Total_Sales / os.Overall_Sales * 100,
            2
        ) AS Sales_Contribution_Pct,
        ROUND(
            cs.Total_Profit / os.Overall_Profit * 100,
            2
        ) AS Profit_Contribution_Pct
    FROM Category_Summary cs
    CROSS JOIN Overall_Summary os
)

SELECT
    *,
    ROUND(
        Sales_Contribution_Pct - Profit_Contribution_Pct,
        2
    ) AS Profit_Gap_Pct
FROM Contribution_Analysis
ORDER BY Profit_Gap_Pct DESC;

-- ============================================================
-- BUSINESS INVESTIGATION
-- Q38 - PART 8: LOSS-MAKING PRODUCTS
-- ============================================================

-- Group discount values into bands and compare sales and profitability across those bands.
SELECT
    p.Product_ID,
    p.Product_Name,
    p.Category,
    ROUND(SUM(o.Sales), 2) AS Total_Sales,
    ROUND(SUM(o.Profit), 2) AS Total_Profit,
    ROUND(
        SUM(o.Profit) / SUM(o.Sales) * 100,
        2
    ) AS Profit_Margin_Pct,
    ROUND(AVG(o.Discount), 2) AS Avg_Discount
FROM orders_clean o
INNER JOIN products_clean p
    ON o.Product_ID = p.Product_ID
GROUP BY
    p.Product_ID,
    p.Product_Name,
    p.Category
HAVING
    SUM(o.Profit) < 0
ORDER BY
    Total_Profit ASC
LIMIT 5;

-- ============================================================
-- BUSINESS ANALYSIS
-- Q39: CATEGORY × DISCOUNT BAND PROFITABILITY
-- ============================================================

-- Group discount values into bands and compare sales and profitability across those bands.
SELECT
    p.Category,
    
    CASE
        WHEN o.Discount > 0.30 THEN 'Extreme High Discount'
        WHEN o.Discount > 0.20 AND o.Discount <= 0.30 THEN 'High Discount'
        WHEN o.Discount > 0.10 AND o.Discount <= 0.20 THEN 'Medium Discount'
        WHEN o.Discount > 0 AND o.Discount <= 0.10 THEN 'Low Discount'
        ELSE 'No Discount'
    END AS Discount_Band,

    ROUND(SUM(o.Sales), 2) AS Total_Sales,
    ROUND(SUM(o.Profit), 2) AS Total_Profit,
    ROUND(
        SUM(o.Profit) / SUM(o.Sales) * 100,
        2
    ) AS Profit_Margin_Pct

FROM orders_clean o

INNER JOIN products_clean p
    ON o.Product_ID = p.Product_ID

GROUP BY
    p.Category,
    Discount_Band

ORDER BY
    Profit_Margin_Pct ASC;

-- ============================================================
-- BUSINESS ANALYSIS
-- Q39 - PART 2: EXTREME HIGH DISCOUNT BY CATEGORY
-- ============================================================

-- Group discount values into bands and compare sales and profitability across those bands.
SELECT
    p.Category,
    ROUND(SUM(o.Sales), 2) AS Total_Sales,
    ROUND(SUM(o.Profit), 2) AS Total_Profit,
    ROUND(
        SUM(o.Profit) / SUM(o.Sales) * 100,
        2
    ) AS Profit_Margin_Pct
FROM orders_clean o
INNER JOIN products_clean p
    ON o.Product_ID = p.Product_ID
WHERE o.Discount > 0.30
  AND p.Category IS NOT NULL
GROUP BY
    p.Category
ORDER BY
    Profit_Margin_Pct ASC;

-- ============================================================
-- BUSINESS ANALYSIS
-- Q39 - PART 3: FURNITURE DISCOUNT BAND PROFITABILITY
-- ============================================================

-- Review the related records and values for this data-quality or business check.
SELECT
    CASE
        WHEN o.Discount > 0.30 THEN 'Extreme High Discount'
        WHEN o.Discount > 0.20 AND o.Discount <= 0.30 THEN 'High Discount'
        WHEN o.Discount > 0.10 AND o.Discount <= 0.20 THEN 'Medium Discount'
        WHEN o.Discount > 0 AND o.Discount <= 0.10 THEN 'Low Discount'
        ELSE 'No Discount'
    END AS Discount_Band,

    ROUND(SUM(o.Sales), 2) AS Total_Sales,
    ROUND(SUM(o.Profit), 2) AS Total_Profit,
    ROUND(
        SUM(o.Profit) / SUM(o.Sales) * 100,
        2
    ) AS Profit_Margin_Pct

FROM orders_clean o

INNER JOIN products_clean p
    ON o.Product_ID = p.Product_ID

WHERE p.Category = 'Furniture'

GROUP BY
    Discount_Band

ORDER BY
    Profit_Margin_Pct ASC;

-- ============================================================
-- BUSINESS ANALYSIS
-- Q39 - PART 4: LOSS-MAKING FURNITURE SUB-CATEGORIES
-- ============================================================

-- Review the related records and values for this data-quality or business check.
SELECT
    p.Sub_Category,

    CASE
        WHEN o.Discount > 0.30 THEN 'Extreme High Discount'
        WHEN o.Discount > 0.20 AND o.Discount <= 0.30 THEN 'High Discount'
        WHEN o.Discount > 0.10 AND o.Discount <= 0.20 THEN 'Medium Discount'
        WHEN o.Discount > 0 AND o.Discount <= 0.10 THEN 'Low Discount'
        ELSE 'No Discount'
    END AS Discount_Band,

    ROUND(SUM(o.Sales), 2) AS Total_Sales,
    ROUND(SUM(o.Profit), 2) AS Total_Profit,

    ROUND(
        SUM(o.Profit) / SUM(o.Sales) * 100,
        2
    ) AS Profit_Margin_Pct,

    ROUND(AVG(o.Discount), 2) AS Avg_Discount

FROM orders_clean o

INNER JOIN products_clean p
    ON o.Product_ID = p.Product_ID

WHERE p.Category = 'Furniture'
  AND o.Discount > 0.20

GROUP BY
    p.Sub_Category,
    Discount_Band

HAVING
    SUM(o.Profit) < 0

ORDER BY
    Profit_Margin_Pct ASC;

-- ============================================================
-- BUSINESS ANALYSIS
-- Q39 - PART 5: FURNITURE HIGH-DISCOUNT OVERALL IMPACT
-- ============================================================

-- Review the related records and values for this data-quality or business check.
SELECT
    ROUND(SUM(o.Sales), 2) AS Total_Sales,
    ROUND(SUM(o.Profit), 2) AS Total_Profit,
    ROUND(
        SUM(o.Profit) / SUM(o.Sales) * 100,
        2
    ) AS Profit_Margin_Pct,
    ROUND(AVG(o.Discount), 2) AS Avg_Discount,
    COUNT(DISTINCT o.Order_ID) AS Total_Orders
FROM orders_clean o
INNER JOIN products_clean p
    ON o.Product_ID = p.Product_ID
WHERE p.Category = 'Furniture'
  AND o.Discount > 0.20;

-- ============================================================
-- BUSINESS ANALYSIS
-- Q40: HIGH-DISCOUNT IMPACT ACROSS CATEGORIES
-- ============================================================

-- Group discount values into bands and compare sales and profitability across those bands.
SELECT
    p.Category,
    ROUND(SUM(o.Sales), 2) AS Total_Sales,
    ROUND(SUM(o.Profit), 2) AS Total_Profit,
    ROUND(
        SUM(o.Profit) / SUM(o.Sales) * 100,
        2
    ) AS Profit_Margin_Pct,
    ROUND(AVG(o.Discount), 2) AS Avg_Discount,
    COUNT(DISTINCT o.Order_ID) AS Total_Orders
FROM orders_clean o
INNER JOIN products_clean p
    ON o.Product_ID = p.Product_ID
WHERE o.Discount > 0.20
  AND p.Category IS NOT NULL
GROUP BY
    p.Category
ORDER BY
    Profit_Margin_Pct ASC;
  
-- ============================================================
-- BUSINESS ANALYSIS
-- Q41: LOSS-MAKING FURNITURE PRODUCTS AT HIGH DISCOUNTS
-- ============================================================

-- Review the related records and values for this data-quality or business check.
SELECT
    p.Product_ID,
    p.Product_Name,
    ROUND(SUM(o.Sales), 2) AS Total_Sales,
    ROUND(SUM(o.Profit), 2) AS Total_Profit,
    ROUND(
        SUM(o.Profit) / SUM(o.Sales) * 100,
        2
    ) AS Profit_Margin_Pct,
    ROUND(AVG(o.Discount), 2) AS Avg_Discount
FROM orders_clean o
INNER JOIN products_clean p
    ON o.Product_ID = p.Product_ID
WHERE p.Category = 'Furniture'
  AND o.Discount > 0.20
GROUP BY
    p.Product_ID,
    p.Product_Name
HAVING SUM(o.Profit) < 0
ORDER BY Total_Profit ASC
LIMIT 10;

-- ============================================================
-- BUSINESS ANALYSIS
-- Q42: REGIONAL × HIGH DISCOUNT PROFITABILITY
-- ============================================================

-- Group discount values into bands and compare sales and profitability across those bands.
SELECT
    c.Region,
    ROUND(SUM(o.Sales), 2) AS Total_Sales,
    ROUND(SUM(o.Profit), 2) AS Total_Profit,
    ROUND(
        SUM(o.Profit) / SUM(o.Sales) * 100,
        2
    ) AS Profit_Margin_Pct,
    ROUND(AVG(o.Discount), 2) AS Avg_Discount,
    COUNT(DISTINCT o.Order_ID) AS Total_Orders
FROM orders_clean o
INNER JOIN customers_clean c
    ON o.Customer_ID = c.Customer_ID
WHERE o.Discount > 0.20
  AND c.Region IS NOT NULL
GROUP BY
    c.Region
ORDER BY
    Total_Profit ASC;

-- ============================================================
-- BUSINESS ANALYSIS
-- Q43: REGIONAL × CATEGORY HIGH-DISCOUNT PROFITABILITY
-- ============================================================

-- Group discount values into bands and compare sales and profitability across those bands.
SELECT
    c.Region,
    p.Category,
    ROUND(SUM(o.Sales), 2) AS Total_Sales,
    ROUND(SUM(o.Profit), 2) AS Total_Profit,
    ROUND(
        SUM(o.Profit) / SUM(o.Sales) * 100,
        2
    ) AS Profit_Margin_Pct,
    ROUND(AVG(o.Discount), 2) AS Avg_Discount,
    COUNT(DISTINCT o.Order_ID) AS Total_Orders
FROM orders_clean o
INNER JOIN customers_clean c
    ON o.Customer_ID = c.Customer_ID
INNER JOIN products_clean p
    ON o.Product_ID = p.Product_ID
WHERE o.Discount > 0.20
  AND c.Region IS NOT NULL
  AND p.Category IS NOT NULL
GROUP BY
    c.Region,
    p.Category
ORDER BY
    Total_Profit ASC;

-- ============================================================
-- BUSINESS ANALYSIS
-- Q44: FURNITURE SUB-CATEGORY × REGION HIGH-DISCOUNT LOSSES
-- ============================================================

-- Review the related records and values for this data-quality or business check.
SELECT
    c.Region,
    p.Sub_Category,
    ROUND(SUM(o.Sales), 2) AS Total_Sales,
    ROUND(SUM(o.Profit), 2) AS Total_Profit,
    ROUND(
        SUM(o.Profit) / SUM(o.Sales) * 100,
        2
    ) AS Profit_Margin_Pct,
    ROUND(AVG(o.Discount), 2) AS Avg_Discount,
    COUNT(DISTINCT o.Order_ID) AS Total_Orders
FROM orders_clean o
INNER JOIN customers_clean c
    ON o.Customer_ID = c.Customer_ID
INNER JOIN products_clean p
    ON o.Product_ID = p.Product_ID
WHERE o.Discount > 0.20
  AND c.Region IS NOT NULL
  AND p.Category = 'Furniture'
  AND p.Sub_Category IS NOT NULL
GROUP BY
    c.Region,
    p.Sub_Category
ORDER BY
    Total_Profit ASC;
    
-- ============================================================
-- BUSINESS ANALYSIS
-- Q45: LOSS-MAKING FURNITURE PRODUCTS AT HIGH DISCOUNTS
-- ============================================================

-- Review the related records and values for this data-quality or business check.
SELECT
    p.Product_ID,
    p.Product_Name,
    p.Sub_Category,
    ROUND(SUM(o.Sales), 2) AS Total_Sales,
    ROUND(SUM(o.Profit), 2) AS Total_Profit,
    ROUND(
        SUM(o.Profit) / SUM(o.Sales) * 100,
        2
    ) AS Profit_Margin_Pct,
    ROUND(AVG(o.Discount), 2) AS Avg_Discount,
    COUNT(DISTINCT o.Order_ID) AS Total_Orders
FROM orders_clean o
INNER JOIN products_clean p
    ON o.Product_ID = p.Product_ID
WHERE o.Discount > 0.20
  AND p.Category = 'Furniture'
  AND p.Sub_Category IS NOT NULL
  AND p.Product_Name IS NOT NULL
GROUP BY
    p.Product_ID,
    p.Product_Name,
    p.Sub_Category
HAVING SUM(o.Profit) < 0
ORDER BY
    Total_Profit ASC
LIMIT 15;

-- ============================================================
-- BUSINESS ANALYSIS
-- Q46: PRODUCT CONTRIBUTION TO FURNITURE HIGH-DISCOUNT LOSS
-- ============================================================

-- Review the related records and values for this data-quality or business check.
WITH Product_Loss AS (
    SELECT
        p.Product_ID,
        p.Product_Name,
        SUM(o.Profit) AS Product_Total_Profit
    FROM orders_clean o
    INNER JOIN products_clean p
        ON o.Product_ID = p.Product_ID
    WHERE o.Discount > 0.20
      AND p.Category = 'Furniture'
      AND p.Sub_Category IS NOT NULL
      AND p.Product_Name IS NOT NULL
    GROUP BY
        p.Product_ID,
        p.Product_Name
    HAVING SUM(o.Profit) < 0
),

Furniture_Loss AS (
    SELECT
        SUM(o.Profit) AS Furniture_High_Discount_Total_Profit
    FROM orders_clean o
    INNER JOIN products_clean p
        ON o.Product_ID = p.Product_ID
    WHERE o.Discount > 0.20
      AND p.Category = 'Furniture'
      AND p.Sub_Category IS NOT NULL
      AND p.Product_Name IS NOT NULL
)

SELECT
    pl.Product_ID,
    pl.Product_Name,
    ROUND(pl.Product_Total_Profit, 2) AS Product_Total_Profit,
    ROUND(
        ABS(pl.Product_Total_Profit)
        / ABS(fl.Furniture_High_Discount_Total_Profit) * 100,
        2
    ) AS Loss_Contribution_Pct
FROM Product_Loss pl
CROSS JOIN Furniture_Loss fl
ORDER BY
    Loss_Contribution_Pct DESC;

-- ============================================================
-- BUSINESS ANALYSIS
-- Q47: LOSS-MAKING FURNITURE PRODUCTS AT HIGH DISCOUNTS
-- ============================================================

-- Review the related records and values for this data-quality or business check.
WITH Furniture_Products AS (
    SELECT
        COUNT(DISTINCT Product_ID) AS Total_Furniture_Products
    FROM products_clean
    WHERE Category = 'Furniture'
      AND Product_Name IS NOT NULL
),

High_Discount_Products AS (
    SELECT
        p.Product_ID,
        SUM(o.Profit) AS Total_Profit
    FROM orders_clean o
    INNER JOIN products_clean p
        ON o.Product_ID = p.Product_ID
    WHERE o.Discount > 0.20
      AND p.Category = 'Furniture'
      AND p.Product_Name IS NOT NULL
    GROUP BY
        p.Product_ID
),

Product_Summary AS (
    SELECT
        COUNT(*) AS High_Discount_Furniture_Products,
        SUM(
            CASE
                WHEN Total_Profit < 0 THEN 1
                ELSE 0
            END
        ) AS Loss_Making_Products
    FROM High_Discount_Products
)

SELECT
    fp.Total_Furniture_Products,
    ps.High_Discount_Furniture_Products,
    ps.Loss_Making_Products,
    ROUND(
        ps.Loss_Making_Products
        / ps.High_Discount_Furniture_Products * 100,
        2
    ) AS Loss_Making_Pct
FROM Furniture_Products fp
CROSS JOIN Product_Summary ps;

-- ============================================================
-- BUSINESS ANALYSIS
-- Q48: FURNITURE HIGH-DISCOUNT OVERALL IMPACT
-- ============================================================

-- Review the related records and values for this data-quality or business check.
WITH Furniture_Overall AS (
    SELECT
        SUM(o.Sales) AS Total_Sales,
        SUM(o.Profit) AS Total_Profit
    FROM orders_clean o
    INNER JOIN products_clean p
        ON o.Product_ID = p.Product_ID
    WHERE p.Category = 'Furniture'
),

Furniture_High_Discount AS (
    SELECT
        SUM(o.Sales) AS High_Discount_Sales,
        SUM(o.Profit) AS High_Discount_Profit
    FROM orders_clean o
    INNER JOIN products_clean p
        ON o.Product_ID = p.Product_ID
    WHERE p.Category = 'Furniture'
      AND o.Discount > 0.20
)

SELECT
    ROUND(fo.Total_Sales, 2) AS Furniture_Total_Sales,
    ROUND(fo.Total_Profit, 2) AS Furniture_Total_Profit,
    ROUND(
        fo.Total_Profit / fo.Total_Sales * 100,
        2
    ) AS Furniture_Overall_Margin_Pct,

    ROUND(fhd.High_Discount_Sales, 2) AS High_Discount_Sales,
    ROUND(fhd.High_Discount_Profit, 2) AS High_Discount_Profit,
    ROUND(
        fhd.High_Discount_Profit / fhd.High_Discount_Sales * 100,
        2
    ) AS High_Discount_Margin_Pct,

    ROUND(
        fhd.High_Discount_Sales / fo.Total_Sales * 100,
        2
    ) AS High_Discount_Sales_Contribution_Pct,

    ROUND(
        fhd.High_Discount_Profit / fo.Total_Profit * 100,
        2
    ) AS High_Discount_Profit_Contribution_Pct

FROM Furniture_Overall fo
CROSS JOIN Furniture_High_Discount fhd;

-- ============================================================
-- BUSINESS ANALYSIS
-- Q49: FURNITURE HIGH-DISCOUNT YEARLY TREND
-- ============================================================

-- Review the related records and values for this data-quality or business check.
WITH Furniture_Yearly AS (
    SELECT 
        YEAR(o.Order_Date) AS Year,
        ROUND(SUM(o.Sales), 2) AS Total_Sales,
        ROUND(SUM(o.Profit), 2) AS Total_Profit,
        ROUND(
            SUM(o.Profit) / SUM(o.Sales) * 100,
            2
        ) AS Profit_Margin_Pct
    FROM orders_clean o
    INNER JOIN products_clean p
        ON o.Product_ID = p.Product_ID
    WHERE p.Category = 'Furniture'
    GROUP BY YEAR(o.Order_Date)
),

Furniture_High_Discount AS (
    SELECT 
        YEAR(o.Order_Date) AS Year,
        ROUND(SUM(o.Sales), 2) AS High_Discount_Sales,
        ROUND(SUM(o.Profit), 2) AS High_Discount_Profit
    FROM orders_clean o
    INNER JOIN products_clean p
        ON o.Product_ID = p.Product_ID
    WHERE p.Category = 'Furniture'
      AND o.Discount > 0.20
    GROUP BY YEAR(o.Order_Date)
)

SELECT
    fy.Year,
    fy.Total_Sales,
    fy.Total_Profit,
    fy.Profit_Margin_Pct,
    fhd.High_Discount_Sales,
    fhd.High_Discount_Profit
FROM Furniture_Yearly fy
LEFT JOIN Furniture_High_Discount fhd
    ON fy.Year = fhd.Year
ORDER BY fy.Year;

-- ============================================================
-- BUSINESS ANALYSIS
-- Q50: YEAR-WISE HIGH-DISCOUNT LOSS CONTRIBUTION
-- ============================================================

-- Review the related records and values for this data-quality or business check.
WITH Furniture_Profit AS (
    SELECT
        YEAR(o.Order_Date) AS Year,
        SUM(o.Profit) AS Total_Profit
    FROM orders_clean o
    INNER JOIN products_clean p
        ON o.Product_ID = p.Product_ID
    WHERE p.Category = 'Furniture'
    GROUP BY YEAR(o.Order_Date)
),

Furniture_High_Discount AS (
    SELECT
        YEAR(o.Order_Date) AS Year,
        SUM(o.Profit) AS High_Discount_Profit
    FROM orders_clean o
    INNER JOIN products_clean p
        ON o.Product_ID = p.Product_ID
    WHERE p.Category = 'Furniture'
      AND o.Discount > 0.20
    GROUP BY YEAR(o.Order_Date)
)

SELECT
    fh.Year,
    ROUND(fh.High_Discount_Profit, 2) AS High_Discount_Profit,
    ROUND(fp.Total_Profit, 2) AS Total_Furniture_Profit,
    ROUND(
        fh.High_Discount_Profit / fp.Total_Profit * 100,
        2
    ) AS Loss_Contribution_Pct
FROM Furniture_High_Discount fh
INNER JOIN Furniture_Profit fp
    ON fh.Year = fp.Year
ORDER BY fh.Year;

-- ============================================================
-- BUSINESS ANALYSIS
-- Q51: FURNITURE HIGH-DISCOUNT ORDER CONTRIBUTION
-- ============================================================

-- Review the related records and values for this data-quality or business check.
WITH Furniture_Orders AS (
    SELECT
        COUNT(DISTINCT o.Order_ID) AS Total_Furniture_Orders
    FROM orders_clean o
    INNER JOIN products_clean p
        ON o.Product_ID = p.Product_ID
    WHERE p.Category = 'Furniture'
),

Furniture_High_Discount AS (
    SELECT
        COUNT(DISTINCT o.Order_ID) AS High_Discount_Orders
    FROM orders_clean o
    INNER JOIN products_clean p
        ON o.Product_ID = p.Product_ID
    WHERE p.Category = 'Furniture'
      AND o.Discount > 0.20
)

SELECT
    fh.High_Discount_Orders,
    fo.Total_Furniture_Orders,
    ROUND(
        fh.High_Discount_Orders * 100.0
        / fo.Total_Furniture_Orders,
        2
    ) AS High_Discount_Order_Pct
FROM Furniture_High_Discount fh
CROSS JOIN Furniture_Orders fo;

-- ============================================================
-- BUSINESS ANALYSIS
-- Q52: FURNITURE HIGH-DISCOUNT MARGIN IMPACT
-- ============================================================

-- Review the related records and values for this data-quality or business check.
WITH Overall AS (
    SELECT
        AVG(o.Discount) AS Overall_Avg_Discount,
        SUM(o.Profit) / SUM(o.Sales) * 100 AS Overall_Margin
    FROM orders_clean o
    INNER JOIN products_clean p
        ON o.Product_ID = p.Product_ID
    WHERE p.Category = 'Furniture'
),

High_Discount AS (
    SELECT
        AVG(o.Discount) AS High_Discount_Avg_Discount,
        SUM(o.Profit) / SUM(o.Sales) * 100 AS High_Discount_Margin
    FROM orders_clean o
    INNER JOIN products_clean p
        ON o.Product_ID = p.Product_ID
    WHERE p.Category = 'Furniture'
      AND o.Discount > 0.20
)

SELECT
    ROUND(o.Overall_Avg_Discount, 2) AS Overall_Avg_Discount,
    ROUND(h.High_Discount_Avg_Discount, 2) AS High_Discount_Avg_Discount,
    ROUND(o.Overall_Margin, 2) AS Overall_Margin,
    ROUND(h.High_Discount_Margin, 2) AS High_Discount_Margin
FROM Overall o
CROSS JOIN High_Discount h;