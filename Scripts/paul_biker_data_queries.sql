-- Data Extraction Query

-- Data Extraction Query: Joining three tables and selecting relevant columns
SELECT 
    o.OrderID, o.OrderDate, o.CustomerID, c.CustomerName, c.Region, 
    p.ProductID, p.ProductName, p.ProductCategory, p.Price, o.Quantity, 
    (o.Quantity * p.Price) AS TotalSales
FROM Orders o
JOIN Customers c ON o.CustomerID = c.CustomerID
JOIN Products p ON o.ProductID = p.ProductID;


-- Data Cleaning & Transformation Query

-- Data Cleaning & Transformation: Removing duplicates, standardizing formats
WITH CleanedData AS (
    SELECT DISTINCT
        OrderID, OrderDate, CustomerID, CustomerName, 
        Region, ProductID, ProductName, ProductCategory, 
        Price, Quantity, TotalSales
    FROM SalesData
    WHERE OrderDate IS NOT NULL AND CustomerID IS NOT NULL
)
SELECT * FROM CleanedData;


-- Performance Metrics Calculation Query

-- Performance Metrics Calculation: Generating key KPIs (sales, revenue, customer segmentation)

-- Total Sales per Customer
SELECT CustomerID, CustomerName, SUM(TotalSales) AS TotalRevenue
FROM SalesData
GROUP BY CustomerID, CustomerName;

-- Sales by Product Category
SELECT ProductCategory, SUM(TotalSales) AS CategoryRevenue
FROM SalesData
GROUP BY ProductCategory;

-- Customer Segmentation Based on Revenue
SELECT 
    CustomerID, CustomerName, TotalRevenue,
    CASE 
        WHEN TotalRevenue > 10000 THEN 'High-Value Customer'
        WHEN TotalRevenue BETWEEN 5000 AND 10000 THEN 'Loyal Customer'
        ELSE 'New/Potential Customer'
    END AS CustomerSegment
FROM (
    SELECT CustomerID, CustomerName, SUM(TotalSales) AS TotalRevenue
    FROM SalesData
    GROUP BY CustomerID, CustomerName
) AS RevenueData;

