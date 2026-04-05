USE sqldemo;
SELECT * FROM categories;
SELECT * FROM customers;
SELECT * FROM emplyoee;
SELECT * FROM orderdetails;
SELECT * FROM orders;
SELECT * FROM products;
SELECT * FROM shippers;
SELECT * FROM suppliers;

-- Find inconsistent values like negative order amounts
SELECT
	orderdetails.OrderID,
    SUM(orderdetails.Quantity*products.Price) AS OrderAmount
FROM orderdetails
	INNER JOIN products ON orderdetails.ProductID = products.ProductID
GROUP BY orderdetails.OrderID
HAVING OrderAmount <= 0;

-- Check for duplicate customers by name and city
SELECT 
    CustomerName,
    City,
    COUNT(*) AS Num
FROM customers
GROUP BY CustomerName, City
HAVING COUNT(*) > 1;

-- Verify referential integrity: orders without valid customer IDs
SELECT 
    orders.OrderID, 
    orders.CustomerID AS OrphanedID,
    orders.OrderDate
FROM orders
LEFT JOIN customers ON orders.CustomerID = customers.CustomerID
WHERE customers.CustomerID IS NULL;

-- Identify products with missing category or price
SELECT
	ProductID,
    ProductName
FROM products
WHERE CategoryID IS NULL OR PRICE IS NULL;

-- Detect unusually large quantities in orderdetails (possible data errors)
WITH Stats AS 
(SELECT 
	AVG(Quantity) AS AvgQuantity, 
	STDDEV(Quantity) AS StdDevQuantity
FROM orderdetails)
SELECT 
    orderdetails.OrderID, 
    orderdetails.ProductID,
    orderdetails.Quantity,
    ((orderdetails.Quantity - Stats.AvgQuantity) / Stats.StdDevQuantity) AS ZScore
FROM orderdetails, Stats
WHERE ((orderdetails.Quantity - Stats.AvgQuantity) / Stats.StdDevQuantity) > 3;
