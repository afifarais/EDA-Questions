USE sqldemo;
SELECT * FROM categories;
SELECT * FROM customers;
SELECT * FROM emplyoee;
SELECT * FROM orderdetails;
SELECT * FROM orders;
SELECT * FROM products;
SELECT * FROM shippers;
SELECT * FROM suppliers;

-- 1 Show the distribution of customers by age group (e.g., 18-25, 26-35, etc.).
SELECT CASE
	WHEN age <18 THEN 'Below 18'
	WHEN age BETWEEN 18 AND 25 THEN '18 - 25'
	WHEN age BETWEEN 26 AND 35 THEN '26 - 35'
	WHEN age BETWEEN 35 AND 45 THEN '35 - 45'
	ELSE 'Above 45'
END AS AgeRanges,
 COUNT(*) AS NoOfPeople
FROM customers
GROUP BY AgeRanges;

-- Count total orders per customer and find the average orders per customer
SELECT
	customers.customerID,
    customers.CustomerName,
    SUM(orders.OrderID) AS OrderCount,
    ROUND(AVG(orders.OrderID), 2) AS AvgOrders
FROM orders
	INNER JOIN customers ON customers.customerID = orders.customerID
GROUP BY customers.customerID
ORDER BY customers.customerID;

-- Find the top 10 cities by number of customers
SELECT
	City,
	COUNT(customerID) AS NoOfCustomers
FROM customers
GROUP BY city
LIMIT 10;

-- Find the distribution of payment methods used in orders.
SELECT
	COUNT(orderID) AS NumderOfOrders,
    payment_method
FROM orders
GROUP BY payment_method;

-- Calculate the average, median, and standard deviation of order amounts.
WITH OrderTotals AS
(SELECT 
	orderdetails.OrderID,
	SUM(orderdetails.Quantity * products.Price) AS TotalOrderAmount
FROM orderdetails
    INNER JOIN products ON orderdetails.ProductID = products.ProductID
GROUP BY orderdetails.OrderID),
RankedOrders AS 
(SELECT 
	TotalOrderAmount,
	ROW_NUMBER() OVER (ORDER BY TotalOrderAmount) AS row_id,
	COUNT(*) OVER () AS total_count,
	AVG(TotalOrderAmount) OVER () AS Average,
	STDDEV(TotalOrderAmount) OVER () AS StandardDeviation
FROM OrderTotals)
SELECT 
    Average,
    StandardDeviation,
    AVG(TotalOrderAmount) AS Median
FROM RankedOrders
WHERE row_id BETWEEN total_count / 2.0 AND total_count / 2.0 + 1
GROUP BY Average, StandardDeviation;