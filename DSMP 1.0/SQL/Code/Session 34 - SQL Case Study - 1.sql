-- Q1 - Select a Perticular database
-- USE zomato 


-- Q2 Count number of rows
 -- SELECT COUNT(*) AS 'rows' FROM user -- to get a number of rows 
 
 -- Q3 - Randomly sample the data - Sample Function from Pandas
--  SELECT * FROM user ORDER BY RAND() LIMIT 5 -- Randomly will get 5 rows 

-- Q4 Select NULL rating
-- First set the primary key then right click and then set null value 
-- SELECT * FROM orders WHERE restaurant_rating IS NOT NULL 

-- UPDATE orders SET restaurent_rating = 0
-- WHERE restaurent_rating = null

-- Q5 Find the number of order placed y each customers

-- SELECT t2.name,COUNT(*) AS 'num_orders' FROM orders t1
-- INNER JOIN user t2 
-- ON t1.user_id = t2.user_id
-- GROUP BY t1.user_id
-- ORDER BY num_orders DESC

-- Q6 Find the restaurents with most number of menu items
-- SELECT t1.r_name, COUNT(f_id) AS 'no_of_item' FROM restaurants t1
-- INNER JOIN menu t2
-- ON t1.r_id = t2.r_id
-- GROUP BY r_name

-- Q7 Find number of Votes and average voting for the restaurants
-- SELECT r_name,COUNT(*) AS 'no_of_votes',ROUND(AVG(restaurant_rating),2) AS 'average_rating' FROM orders t1
-- JOIN restaurants t2
-- ON t1.r_id = t2.r_id
-- WHERE restaurant_rating IS NOT NULL
-- GROUP BY t1.r_id
-- ORDER BY average_rating DESC

-- Q8 - Find the food name which is most sold in the restaurents
-- SELECT f_name, COUNT(*) AS 'no_of_item' FROM menu t1 
-- INNER JOIN food t2
-- ON t1.f_id = t2.f_id
-- GROUP BY f_name
-- ORDER BY no_of_item DESC

-- Q9 find restaurant with max revenue in a given month

-- SELECT r_name,MONTH(DATE(date)) AS 'month',SUM(amount) AS 'total_revenue' FROM orders t1
-- INNER JOIN restaurants t2 
-- ON t1.r_id = t2.r_id 
-- WHERE MONTH(DATE(date)) = 7
-- GROUP BY r_name , MONTH(DATE(date)) 
-- ORDER BY total_revenue DESC LIMIT 1

-- Month by Month revenue for perticular company 

-- SELECT r_name,MONTHNAME(DATE(date)) AS 'month',SUM(amount) AS 'total_revenue' FROM orders t1
-- INNER JOIN restaurants t2 
-- ON t1.r_id = t2.r_id 
-- WHERE r_name = 'box8'
-- GROUP BY MONTH(DATE(date)) 
-- ORDER BY total_revenue DESC 

-- Q10 Find restaurents sales > x 

-- SELECT r_name,SUM(amount) AS 'total_revenue' FROM orders t1
-- INNER JOIN restaurants t2 
-- ON t1.r_id = t2.r_id 
-- GROUP BY t1.r_id
-- HAVING total_revenue > 1000
-- ORDER BY total_revenue DESC 

-- Q11 FInd the person who had never ordered
-- Option 1 
-- SELECT t1.user_id,name,email,r_id FROM user t1
-- LEFT JOIN orders t2
-- ON t1.user_id = t2.user_id
-- WHERE r_id IS NULL

-- Option 2
-- SELECT user_id,name FROM user
-- EXCEPT 
-- SELECT t1.user_id,name FROM orders t1
-- JOIN user t2
-- ON t1.user_id = t2.user_id

-- Q 12 Select order for one perticular user in a perticular range 

-- SELECT order_id,user_id,t5.f_name,date,r_name FROM (SELECT order_id,user_id,t3.f_id,f_name,date,r_id FROM (SELECT t1.order_id,user_id,date,f_id,r_id FROM orders t1
-- JOIN order_details t2
-- ON t1.order_id = t2.order_id) t3
-- JOIN  food t4
-- ON t3.f_id = t4.f_id) t5
-- JOIN restaurants t6
-- ON t6.r_id = t5.r_id
-- WHERE user_id = 1 AND DATE(date) BETWEEN '2022-05-15' AND '2022-08-15'

-- Q13 Favourite Food - Not solved

-- SELECT user_id,f_name, COUNT(*) AS "item" FROM (SELECT order_id,user_id,t3.f_id,f_name,date,r_id FROM (SELECT t1.order_id,user_id,date,f_id,r_id FROM orders t1
-- JOIN order_details t2
-- ON t1.order_id = t2.order_id) t3
-- JOIN  food t4
-- ON t3.f_id = t4.f_id) t5
-- JOIN restaurants t6
-- ON t6.r_id = t5.r_id
-- GROUP BY user_id,f_name 
-- ORDER BY item DESC

-- Q14 - Find Most costly restaurant

-- SELECT r_name, SUM(price)/COUNT(*) AS 'average_price' FROM menu t1
-- JOIN restaurants t2
-- ON t1.r_id = t2.r_id
-- GROUP BY t1.r_id

-- Q15  
 
-- SELECT t1.partner_id,partner_name,COUNT(*)*100 + 1000* AVG(delivery_rating) AS 'money' FROM orders t1
-- INNER JOIN delivery_partner t2
-- ON t1.partner_id = t2.partner_id
-- GROUP BY partner_id 
-- ORDER BY money DESC

-- Q16 COrelation between delivery time and rating 
-- Version mismatch it is available 8.0.2 
-- SELECT CORR(deliver_time,delivery_rating + restaurant_rating) FROM orders

-- Q17 Corr   

-- Q18  Find Veg restaurend 

-- SELECT t5.r_name,t5.veg_item,t6.non_veg_item FROM (SELECT t4.r_name,t3.type,COUNT(*) AS 'veg_item' FROM (SELECT t1.f_id,t2.f_name, t2.type,t1.r_id FROM menu t1
-- INNER JOIN food t2
-- ON t1.f_id = t2.f_id ) t3
-- INNER JOIN restaurants t4
-- ON t3.r_id = t4.r_id
-- WHERE type = 'veg'
-- GROUP BY r_name,type) t5

-- LEFT JOIN (SELECT t4.r_name,t3.type,COUNT(*) AS 'non_veg_item' FROM (SELECT t1.f_id,t2.f_name, t2.type,t1.r_id FROM menu t1
-- INNER JOIN food t2
-- ON t1.f_id = t2.f_id ) t3
-- INNER JOIN restaurants t4
-- ON t3.r_id = t4.r_id
-- WHERE type = 'Non-veg'
-- GROUP BY r_name,type) t6
-- ON t5.r_name = t6.r_name

-- Minmtos Jindgi
SELECT t3.r_id,r_name FROM (SELECT r_id FROM menu t1
JOIN food t2
ON t1.f_id = t2.f_id
GROUP BY r_id 
HAVING MIN(type) = 'Veg' AND MAX(type) = 'Veg') t3
JOIN restaurants t4
ON t3.r_id = t4.r_id
 
# Q-20 

-- SELECT name,MIN(amount),MAX(amount) FROM orders t1
-- JOIN user t2
-- ON t1.user_id = t2.user_id 
-- GROUP BY name


--  t3.f_id,t3.f_name,t3.type,t3.r_id,t4.r_name