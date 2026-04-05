USE sqldemo;
SELECT * FROM categories;
SELECT * FROM customers;
SELECT * FROM emplyoee;
SELECT * FROM orderdetails;
SELECT * FROM orders;
SELECT * FROM products;
SELECT * FROM shippers;
SELECT * FROM suppliers;

-- List Most frequently purchased products
SELECT
	categories.CategoryName,
    products.ProductName,
    SUM(orderdetails.Quantity) AS QuantityPurchased,
	COUNT(orders.OrderID) AS TimesPurchased
FROM categories
	INNER JOIN products ON categories.CategoryID = products.CategoryID
	INNER JOIN orderdetails ON orderdetails.ProductID = products.ProductID
	INNER JOIN orders ON orders.OrderID = orderdetails.OrderID
GROUP BY products.ProductID, products.ProductName, categories.CategoryName
ORDER BY QuantityPurchased DESC;

-- Find the top 5 product categories by total revenue
SELECT
	categories.CategoryName,
    ROUND(SUM(orderdetails.Quantity*products.Price), 2) AS Revenue
FROM categories
	INNER JOIN products ON categories.CategoryID = products.CategoryID
	INNER JOIN orderdetails ON orderdetails.ProductID = products.ProductID
GROUP BY categories.CategoryName;

-- Determine which category has the highest average price
SELECT
	categories.CategoryName,
    MAX(products.Price) AS AveragePrice
FROM categories
	INNER JOIN products ON categories.CategoryID = products.CategoryID
GROUP BY categories.CategoryName
ORDER BY AveragePrice DESC;

-- For each product, compute total units sold and average quantity per order
SELECT
	products.ProductID,
	products.ProductName,
    SUM(orderdetails.Quantity) AS TotalQuantity,
    ROUND(AVG(orderdetails.Quantity), 2) AS AverageQuantity
FROM products
	INNER JOIN orderdetails ON products.ProductID = orderdetails.ProductID
GROUP BY orderdetails.OrderID;

-- Find products that have never been purchased
SELECT
	products.ProductID,
	products.ProductName
FROM products
	LEFT JOIN orderdetails ON orderdetails.ProductID = products.ProductID
WHERE orderdetails.Quantity IS NULL;
    
