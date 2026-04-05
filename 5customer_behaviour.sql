USE sqldemo;
SELECT * FROM categories;
SELECT * FROM customers;
SELECT * FROM emplyoee;
SELECT * FROM orderdetails;
SELECT * FROM orders;
SELECT * FROM products;
SELECT * FROM shippers;
SELECT * FROM suppliers;

-- Identify new vs returning customers for a given month.
WITH CustomersFirstOrders AS (
	SELECT
		CustomerID, MIN(OrderDate) AS FirstOrder
    FROM orders
    GROUP BY CustomerID)
SELECT orders.CustomerID, customers.CustomerName, orders.OrderDate,
	CASE
		WHEN CustomersFirstOrders.FirstOrder >= "1998-05-01" 
			AND CustomersFirstOrders.FirstOrder <= "1998-05-31" THEN "New Customer"
        ELSE "Returning Customer"
	END AS CustomerStatus
FROM orders
INNER JOIN customers ON orders.CustomerID = customers.CustomerID
INNER JOIN CustomersFirstOrders ON CustomersFirstOrders.CustomerID = orders.CustomerID
WHERE orders.OrderDate BETWEEN "1998-05-01" AND "1998-05-31";

-- Calculate customers lifetime value (sum of all order amounts).
SELECT
	customers.CustomerID,
    customers.CustomerName,
    ROUND(SUM(orderdetails.Quantity*products.Price),0) AS OrderAmount
FROM customers
	INNER JOIN orders ON orders.CustomerID = customers.CustomerID
	INNER JOIN orderdetails ON orderdetails.OrderID = orders.OrderID
	INNER JOIN products ON orderdetails.ProductID = products.ProductID
GROUP BY customers.CustomerID
ORDER BY OrderAmount DESC;

-- Find the customers with unusually high spending (top 1% by spend).
SELECT
	CustomerID,
    CustomerName,
    TotalSpend,
    SpendingRank
FROM (SELECT 
		customers.CustomerID,
        customers.CustomerName,
        ROUND(SUM(orderdetails.Quantity*products.Price),2) AS TotalSpend,
        PERCENT_RANK() OVER(ORDER BY ROUND(SUM(orderdetails.Quantity*products.Price),2) DESC) AS SpendingRanK
		FROM customers
			INNER JOIN orders ON orders.CustomerID = customers.CustomerID
			INNER JOIN orderdetails ON orderdetails.OrderID = orders.OrderID
			INNER JOIN products ON orderdetails.ProductID = products.ProductID
		GROUP BY customers.CustomerID) RANKC
WHERE SPENDINGRANK <= 0.01;

-- Determine the churn rate month to month
WITH MonthlyCount AS
	(SELECT
    MONTH(orders.OrderDate) AS Months,
    COUNT( DISTINCT orders.CustomerID) AS NoOfCustomers
    FROM orders
    GROUP BY Months)
SELECT
	Months, NoOfCustomers,
    (LAG(NoOfCustomers) OVER(ORDER BY Months) - NoOfCustomers)/NULLIF(LAG(NoOfCustomers) OVER(ORDER BY Months), 0) AS ChurnRate
    FROM MonthlyCount;

-- Identify customers who made only one purchase (one-time buyers)
SELECT
	customers.CustomerID,
    customers.CustomerName,
    COUNT(orders.OrderID) AS Counts
FROM customers
	INNER JOIN orders ON  customers.CustomerID = orders.CustomerID
GROUP BY customers.CustomerID, customers.CustomerName
HAVING Counts = 1;
