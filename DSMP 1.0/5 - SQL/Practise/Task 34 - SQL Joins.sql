-- Q1
-- SELECT A.Country, A.A, B.D FROM (SELECT country,A FROM  `33`.country_ab t1
-- ORDER BY A DESC LIMIT 10) A
-- LEFT JOIN (SELECT Country,D FROM `33`.country_cd 
-- ORDER BY D DESC LIMIT 10) B
-- ON A.Country = B.Country

-- UNION 

-- SELECT B.Country, A.A, B.D FROM (SELECT country,A FROM  `33`.country_ab t1
-- ORDER BY A DESC LIMIT 10) A
-- RIGHT JOIN (SELECT Country,D FROM `33`.country_cd 
-- ORDER BY D DESC LIMIT 10) B
-- ON A.Country = B.Country

-- ORDER BY Country


-- Q2
-- SELECT t2.Region, t1.Edition,MAX(t1.CL) AS 'CL' FROM `33`.country_cl t1
-- INNER JOIN `33`.country_ab t2
-- ON t1.Country = t2.Country
-- WHERE t1.Edition = 2020
-- GROUP BY Region 
-- ORDER BY CL DESC  


-- Q3 Find top 5 most sold product
-- SELECT t2.Name,COUNT(*) AS 'product_sale', t1.ProductID,SUM(t1.Quantity) AS 'quantity_sold' FROM sales.sales1 t1
-- INNER JOIN sales.products t2
-- ON t1.ProductID = t2.ProductID
-- GROUP BY Name
-- ORDER BY quantity_sold DESC LIMIT 5

-- Q4 Find sales man who sold most no of products.
-- SELECT t3.FirstName,t3.LastName,COUNT(*) AS 'total_sales' FROM sales.sales1 t1
-- INNER JOIN sales.products t2
-- ON t1.ProductID = t2.ProductID
-- INNER JOIN sales.employees t3
-- ON t1.SalesPersonID = t3.EmployeeID
-- GROUP BY t1.SalesPersonID
-- ORDER BY total_sales DESC LIMIT 5

-- Q5 Sales man name who has most no of unique customer.
-- SELECT t1.FirstName,t1.LastName,COUNT(DISTINCT(t2.CustomerID)) AS 'Unique_customer' FROM sales.employees t1
-- INNER JOIN sales.sales1 t2
-- ON t1.EmployeeID = t2.SalesPersonID
-- GROUP BY SalesPersonID
-- ORDER BY Unique_customer DESC LIMIT 5;

-- Q6 Sales man who has generated most revenue. Show top 5.
-- SELECT t1.SalesPersonID,t3.FirstName,t3.LastName,ROUND(SUM(t2.Price*t1.Quantity),2) AS 'total_revenue' FROM sales.sales1 t1
-- INNER JOIN sales.products t2
-- ON t1.ProductID = t2.ProductID
-- INNER JOIN sales.employees t3
-- ON t1.SalesPersonID = t3.EmployeeID
-- GROUP BY t1.SalesPersonID
-- ORDER BY total_revenue DESC LIMIT 5

-- Q7 List all customers who have made more than 10 purchases.

-- SELECT  t2.CustomerID,t2.FirstName,t2.LastName,COUNT(t1.SalesID) AS 'total_purchase'  FROM sales.sales1 t1
-- INNER JOIN sales.customers t2
-- ON t1.CustomerID = t2.CustomerID
-- GROUP BY t2.CustomerID
-- HAVING total_purchase > 10


-- Q8 List all salespeople who have made sales to more than 5 customers.
-- SELECT t1.FirstName,t1.LastName,COUNT(DISTINCT(t2.CustomerID)) AS 'Unique_customer' FROM sales.employees t1
-- JOIN sales.sales1 t2
-- ON t1.EmployeeID = t2.SalesPersonID
-- GROUP BY t2.SalesPersonID
-- HAVING Unique_customer > 5
-- ORDER BY Unique_customer DESC 

-- Q9 List all pairs of customers who have made purchases with the same salesperson.

-- SELECT E.first_cusomer_first_name, E.first_cusomer_last_name, E.second_consumer,E.second_cusomer_first_name,E.second_cusomer_last_name,F.FirstName AS 'employee_first_name',F.LastName AS 'employee_last_name'
-- FROM (SELECT C.first_cusomer_first_name, C.first_cusomer_last_name, C.second_consumer,D.FirstName AS 'second_cusomer_first_name', D.LastName AS 'second_cusomer_last_name',C.SalesPersonID 
-- FROM (SELECT B.firstname AS 'first_cusomer_first_name', B.lastname AS 'first_cusomer_last_name',A.second_consumer,A.SalesPersonID 
-- FROM (SELECT DISTINCT t1.CustomerID AS 'first_consumer',t2.CustomerID AS 'second_consumer',t1.SalesPersonID FROM sales.sales1 t1
-- JOIN sales.sales1 t2
-- ON t1.SalesPersonID = t2.SalesPersonID
-- AND t1.CustomerID != t2.CustomerID) A
-- JOIN sales.customers B 
-- ON A.first_consumer = B.CustomerID) C
-- LEFT JOIN sales.customers D
-- ON C.second_consumer = D.CustomerID) E
-- JOIN sales.employees F
-- ON E.SalesPersonID = F.EmployeeID




 
 