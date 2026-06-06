-- ================================================
-- RETAILLENS - SQL ANALYSIS QUERIES
-- ================================================

-- Query 1: Total Revenue & Profit
SELECT 
    ROUND(SUM("Sales")::numeric, 2) AS total_revenue,
    ROUND(SUM("Profit")::numeric, 2) AS total_profit,
    ROUND(AVG("Profit Margin %")::numeric, 2) AS avg_margin
FROM sales;

-- ------------------------------------------------

-- Query 2: Sales by Category
SELECT 
    "Category",
    ROUND(SUM("Sales")::numeric, 2) AS revenue,
    ROUND(SUM("Profit")::numeric, 2) AS profit
FROM sales
GROUP BY "Category"
ORDER BY revenue DESC;

-- ------------------------------------------------

-- Query 3: Top 10 Products by Revenue
SELECT 
    "Product Name",
    ROUND(SUM("Sales")::numeric, 2) AS revenue
FROM sales
GROUP BY "Product Name"
ORDER BY revenue DESC
LIMIT 10;

-- ------------------------------------------------

-- Query 4: Monthly Sales Trend
SELECT 
    "Order Year",
    "Order Month",
    "Order Month Name",
    ROUND(SUM("Sales")::numeric, 2) AS monthly_sales
FROM sales
GROUP BY "Order Year", "Order Month", "Order Month Name"
ORDER BY "Order Year", "Order Month";

-- ------------------------------------------------

-- Query 5: Loss Making Products
SELECT 
    "Product Name",
    ROUND(SUM("Profit")::numeric, 2) AS total_profit
FROM sales
GROUP BY "Product Name"
HAVING SUM("Profit") < 0
ORDER BY total_profit ASC
LIMIT 10;

-- ------------------------------------------------

-- Query 6: Region Wise Performance
SELECT 
    "Region",
    ROUND(SUM("Sales")::numeric, 2) AS revenue,
    ROUND(SUM("Profit")::numeric, 2) AS profit,
    COUNT(DISTINCT "Customer ID") AS customers
FROM sales
GROUP BY "Region"
ORDER BY revenue DESC;

-- ------------------------------------------------

-- Query 7: Top 10 Customers by Revenue
SELECT 
    "Customer ID",
    "Customer Name",
    COUNT(DISTINCT "Order ID") AS total_orders,
    ROUND(SUM("Sales")::numeric, 2) AS total_spent
FROM sales
GROUP BY "Customer ID", "Customer Name"
ORDER BY total_spent DESC
LIMIT 10;

-- ------------------------------------------------

-- Query 8: Discount Impact on Profit
SELECT 
    CASE 
        WHEN "Discount" = 0 THEN 'No Discount'
        WHEN "Discount" <= 0.1 THEN '1-10%'
        WHEN "Discount" <= 0.2 THEN '11-20%'
        ELSE 'Above 20%'
    END AS discount_range,
    ROUND(AVG("Profit")::numeric, 2) AS avg_profit,
    COUNT(*) AS order_count
FROM sales
GROUP BY discount_range
ORDER BY avg_profit DESC;

-- ------------------------------------------------

-- Query 9: Repeat vs One-time Customers
SELECT 
    CASE 
        WHEN order_count = 1 THEN 'One-time Customer'
        ELSE 'Repeat Customer'
    END AS customer_type,
    COUNT(*) AS customer_count
FROM (
    SELECT "Customer ID", COUNT(DISTINCT "Order ID") AS order_count
    FROM sales
    GROUP BY "Customer ID"
) t
GROUP BY customer_type;

-- ------------------------------------------------

-- Query 10: Shipping Performance
SELECT 
    "Ship Mode",
    ROUND(AVG("Shipping Days")::numeric, 1) AS avg_shipping_days,
    COUNT(*) AS total_orders
FROM sales
GROUP BY "Ship Mode"
ORDER BY avg_shipping_days;