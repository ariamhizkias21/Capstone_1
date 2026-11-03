
-- CAPSTONE 1: EAST REGION IN-STORE SALE

-- STEP 1: Select the database
USE sample_sales;
-- STEP 2: Check available tables
SHOW TABLES;
-- STEP 3: Identify states in the East Region
SELECT *
FROM Management
WHERE Region = 'East';
-- STEP 4: Inspect the table structures
DESCRIBE Store_Sales;
DESCRIBE Store_Locations;
DESCRIBE Management;
DESCRIBE Products;
DESCRIBE Inventory_Categories;
-- STEP 5: Explore product categories
SELECT *
FROM Inventory_Categories
LIMIT 10;
-- STEP 6: Explore product subcategories
SELECT *
FROM Inventory_Subcategories;
-- STEP 7: View store locations
SELECT *
FROM Store_Locations;
-- STEP 8: Check stores in New York
SELECT *
FROM Store_Locations
WHERE State = 'New York';
-- STEP 9: Check stores in Connecticut
SELECT *
FROM Store_Locations
WHERE State = 'Connecticut';


-- QUESTION 1:
-- What is the total revenue for the East Region's
-- in-store sales, and what are the first and last transaction dates?
Use sample_sales;

SELECT
    SUM(Store_Sales.Sale_Amount),
    MIN(Store_Sales.Transaction_Date),
    MAX(Store_Sales.Transaction_Date)
FROM Store_Sales
JOIN Store_Locations
    ON Store_Sales.Store_ID = Store_Locations.StoreId
JOIN Management
    ON Store_Locations.State = Management.State
WHERE Management.Region = 'East';

SUM() adds all the sales amounts.
MIN() finds the earliest transaction date.
MAX() finds the latest transaction date.
JOIN connects the sales, store locations, and management tables.
WHERE keeps only East Region sales.

Total revenue: $6,723,039.53
First transaction: January 1, 2022
Last transaction: December 31,2025

-- QUESTION 2:
-- What is the revenue by year and month
-- for East Region in-store sales?
Use sample_sales;

SELECT
    YEAR(Store_Sales.Transaction_Date),
    MONTH(Store_Sales.Transaction_Date),
    SUM(Store_Sales.Sale_Amount)
FROM Store_Sales
JOIN Store_Locations
    ON Store_Sales.Store_ID = Store_Locations.StoreId
JOIN Management
    ON Store_Locations.State = Management.State
WHERE Management.Region = 'East'
GROUP BY
    YEAR(Store_Sales.Transaction_Date),
    MONTH(Store_Sales.Transaction_Date)
ORDER BY
    YEAR(Store_Sales.Transaction_Date),
    MONTH(Store_Sales.Transaction_Date);

48 monthly records, covering 2022–2025.
Highest revenue year: 2025, with $2,436,605.47.
Highest monthly revenue: October 2025, with $301,070.13.

---Question 3 : Provide a comparison of total revenue for the specific sales territory and the region it belongs to
    USE sample_sales;
SELECT
    Store_Locations.State,
    SUM(Store_Sales.Sale_Amount)
FROM Store_Sales
JOIN Store_Locations
    ON Store_Sales.Store_ID = Store_Locations.StoreId
JOIN Management
    ON Store_Locations.State = Management.State
WHERE Management.Region = 'East'
GROUP BY
    Store_Locations.State
ORDER BY
    SUM(Store_Sales.Sale_Amount) DESC;
    
GROUP BY creates one result for each state.
ORDER BY Total_Revenue DESC puts the highest revenue first.

-- QUESTION 4: What is the number of transactions per month and average transaction amount by product
category for the sales territory?
USE sample_sales;

SELECT
    YEAR(Store_Sales.Transaction_Date),
    MONTH(Store_Sales.Transaction_Date),
    Inventory_Categories.Category,
    COUNT(*),
    AVG(Store_Sales.Sale_Amount)
FROM Store_Sales
JOIN Products
    ON Store_Sales.Prod_Num = Products.ProdNum
JOIN Inventory_Categories
    ON Products.Categoryid = Inventory_Categories.Categoryid
JOIN Store_Locations
    ON Store_Sales.Store_ID = Store_Locations.StoreId
JOIN Management
    ON Store_Locations.State = Management.State
WHERE Management.Region = 'East'
GROUP BY
    YEAR(Store_Sales.Transaction_Date),
    MONTH(Store_Sales.Transaction_Date),
    Inventory_Categories.Category
ORDER BY
    YEAR(Store_Sales.Transaction_Date),
    MONTH(Store_Sales.Transaction_Date),
    Inventory_Categories.Category;
    
    
-- QUESTION 5: Rank East Region in-store performance by store
USE sample_sales;

SELECT
    RANK() OVER (
        ORDER BY SUM(Store_Sales.Sale_Amount) DESC
    ),
    Store_Locations.StoreId,
    Store_Locations.StoreLocation,
    Store_Locations.State,
    SUM(Store_Sales.Sale_Amount)
FROM Store_Sales
JOIN Store_Locations
    ON Store_Sales.Store_ID = Store_Locations.StoreId
JOIN Management
    ON Store_Locations.State = Management.State
WHERE Management.Region = 'East'
GROUP BY
    Store_Locations.StoreId,
    Store_Locations.StoreLocation,
    Store_Locations.State
ORDER BY
    SUM(Store_Sales.Sale_Amount) DESC;
    
    
-- Question 6: Sales Recommendations for the Next Quarter
USE sample_sales;

SELECT
    Store_Locations.StoreLocation,
    Inventory_Categories.Category,
    SUM(Store_Sales.Sale_Amount)
FROM Store_Sales
JOIN Store_Locations
    ON Store_Sales.Store_ID = Store_Locations.StoreId
JOIN Products
    ON Store_Sales.Prod_Num = Products.ProdNum
JOIN Inventory_Categories
    ON Products.Categoryid = Inventory_Categories.Categoryid
JOIN Management
    ON Store_Locations.State = Management.State
WHERE Management.Region = 'East'
    AND (
        Store_Locations.StoreLocation = 'New York'
        OR Store_Locations.StoreLocation = 'Old Saybrook'
    )
GROUP BY
    Store_Locations.StoreLocation,
    Inventory_Categories.Category
ORDER BY
    Store_Locations.StoreLocation,
    SUM(Store_Sales.Sale_Amount) DESC;