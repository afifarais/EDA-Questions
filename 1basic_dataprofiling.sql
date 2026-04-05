USE sqldemo;
SELECT * FROM categories;
SELECT * FROM customers;
SELECT * FROM emplyoee;
SELECT * FROM orderdetails;
SELECT * FROM orders;
SELECT * FROM products;
SELECT * FROM shippers;
SELECT * FROM suppliers;

-- 1. Find the total number of customers, orders and products.
SELECT
	COUNT(customers.customerID) AS TotalNoOfCustomers,
	COUNT(orders.orderID) AS TotalNoOfOrders,
	COUNT(products.productID) AS TotalNoOfProducts
FROM customers
	INNER JOIN orders ON orders.customerID = customers.customerID
    INNER JOIN orderdetails ON orderdetails.orderID = orders.orderID
    INNER JOIN products ON products.productID = orderdetails.productID;


-- 2 What is the date range of the orders in the dataset?
SELECT
	CONCAT_WS(' - ', MIN(OrderDate),
    MAX(OrderDate)) AS DateRangeForOrders
FROM orders;

-- 3 Count missing or NULL values in each column of the customers table.
SELECT
	COUNT(*) - COUNT(customerID) AS NoOfNULL_IDs,
    COUNT(*) - COUNT(customerName) AS NoOfNULL_names,
    COUNT(*) - COUNT(ContactName) AS NoOfNULL_ContactName,
    COUNT(*) - COUNT(Address) AS NoOfNULLs_Address,
    COUNT(*) - COUNT(city) AS NoOfNULLs_city,
    COUNT(*) - COUNT(PostalCode) AS NoOfNULLs_PostalCode,
    COUNT(*) - COUNT(Country) AS NoOfNULLs_Country
FROM customers;

-- 4 Get the number of distinct cities customers come from
SELECT
	COUNT(DISTINCT city) 
FROM customers;

-- 5 What are the min, max, and average order amounts?
SELECT 
    MIN(OrderTotal) AS MinAmount, 
    MAX(OrderTotal) AS MaxAmount, 
    ROUND(AVG(OrderTotal), 2) AS AvgAmount
FROM 
(SELECT ROUND(SUM(orderdetails.Quantity * products.price), 2) AS OrderTotal
FROM orders
    INNER JOIN orderdetails ON orderdetails.orderID = orders.orderID
    INNER JOIN products ON products.productID = orderdetails.ProductID
GROUP BY orders.orderID) AS AggregateByOrderID;