USE sqldemo;
SELECT * FROM categories;
SELECT * FROM customers;
SELECT * FROM emplyoee;
SELECT * FROM orderdetails;
SELECT * FROM orders;
SELECT * FROM products;
SELECT * FROM shippers;
SELECT * FROM suppliers;

-- How many orders are placed per day/week/month?
SELECT
	OrderDate,
    COUNT(OrderID) AS NoOfOrders
FROM Orders
GROUP BY OrderDate
ORDER BY OrderDate DESC;
-- 
SELECT
	YEAR(OrderDate) AS year,
    WEEK(OrderDate) AS week_number,
    COUNT(OrderId) AS total_orders
FROM orders
GROUP BY year, week_number
ORDER BY year DESC, week_number DESC;
-- 
SELECT
	DATE_FORMAT(OrderDate, '%Y-%m') AS month,
    COUNT(OrderId) AS total_orders
FROM orders
GROUP BY month
ORDER BY month DESC;

-- Find month-over-month growth in total sales.
WITH MonthlySales AS(
	SELECT
		DATE_FORMAT(OrderDate, "%Y-%M") AS MonthOfSale,
		ROUND(SUM(Products.Price*OrderDetails.Quantity), 2) AS CurrentMonthSale
	FROM OrderDetails INNER JOIN Products ON OrderDetails.ProductID = Products.ProductID
		INNER JOIN Orders ON Orders.OrderID = OrderDetails.OrderID
	GROUP BY MonthOfSale
	ORDER BY MonthOfSale DESC)
SELECT
	MonthOfSale,
    CurrentMonthSale,
	LAG(CurrentMonthSale) OVER() AS PreviousMonthSale,
	ROUND(((LAG(CurrentMonthSale) OVER() - CurrentMonthSale)/CurrentMonthSale)*100, 2) AS GrowthOverMonth
FROM MonthlySales
ORDER BY MonthOfSale DESC;

-- Identify peak order hours of the day.
SELECT
	OrderDate,
	Hour(OrderDate) AS HourOfTheDay ,
    COUNT(OrderId) AS NoOfOrders
FROM orders
GROUP BY OrderDate, HourOfTheDay
ORDER BY OrderDate, HourOfTheDay DESC;

-- Find the average order amount by weekday vs weekend.
SELECT
	CASE
		WHEN WEEKDAY(Orders.OrderDate) IN (5,6) THEN "Weekend"
		ELSE "Weekday"
	END AS DayOfTheWeek,
	COUNT(Orders.OrderID) AS NoOfOrders,
	ROUND(AVG(Products.Price*OrderDetails.Quantity),2) AS AverageAmount
FROM OrderDetails
	INNER JOIN Products ON OrderDetails.ProductID = Products.ProductID
	INNER JOIN Orders ON Orders.OrderID = OrderDetails.OrderID
GROUP BY DayOfTheWeek;

-- Identify the first and last purchase date for each customer
SELECT
	customers.CustomerName,
    MAX(Orders.OrderDate) AS LastDate,
    MIN(Orders.OrderDate) AS FirstDate
FROM Orders
	INNER JOIN Customers ON Customers.CustomerID = Orders.CustomerID
GROUP BY Customers.CustomerName;

