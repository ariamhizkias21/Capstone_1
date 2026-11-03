-- CAPSTONE 1: EAST REGION IN-STORE SALE

-- QUESTION 1:
-- What is the total revenue for the East Region's
-- in-store sales, and what are the first and last transaction dates?
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


-- QUESTION 2:
-- What is the revenue by year and month
-- for East Region in-store sales?
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


---Question 3 : Provide a comparison of total revenue for the specific sales territory and the region it belongs to
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


-- QUESTION 4: What is the number of transactions per month and average transaction amount by product
category for the sales territory?
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
