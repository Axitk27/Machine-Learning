-- Q1 - Find out the average sleep duration of top 15 male candidates who's sleep duration are equal to 7.5 or greater than 7.5.  
-- SELECT AVG(sleep_duration) AS 'average_sleep_duration'
-- FROM practise.sleep_efficiency
-- WHERE sleep_duration >= 7.5 AND gender = 'Male'

-- Q2 - Show avg deep sleep time for both gender. Round result at 2 decimal places.
-- SELECT gender,AVG(sleep_duration*deep_sleep_percentage/100 ) AS 'sleep_duration' FROM practise.sleep_efficiency
-- GROUP BY gender

 -- Q3 Find out the lowest 10th to 30th light sleep percentage records where deep sleep percentage values are between 25 to 45. 
 -- Display age, light sleep percentage and deep sleep percentage columns only. 
 
--  SELECT age,light_sleep_percentage,deep_sleep_percentage FROM practise.sleep_efficiency
--  WHERE deep_sleep_percentage BETWEEN 25 AND 45
--  ORDER BY light_sleep_percentage ASC LIMIT 10,20

-- Q4 Group by on exercise frequency and smoking status and show average deep sleep time, average light sleep time and avg rem sleep time.

-- SELECT exercise_frequency,smoking_status,AVG(sleep_duration*deep_sleep_percentage/100),AVG(sleep_duration*rem_sleep_percentage/100),AVG(sleep_duration*light_sleep_percentage/100) 
-- FROM practise.sleep_efficiency 
-- GROUP BY exercise_frequency,smoking_status 
-- ORDER BY AVG(`sleep_duration`*(`deep_sleep_percentage`/100));


-- Q-5 Group By on Awekning and show AVG Caffeine consumption, AVG Deep sleep time and AVG Alcohol consumption only for people who do exercise
-- atleast 3 days a week. Show result in descending order awekenings  
-- 1oz = 29 ML 1tesp = 50mg ceffein 
-- SELECT awakenings,AVG(caffeine_consumption) AS 'average_caffeine',AVG(sleep_duration*deep_sleep_percentage/100) AS 'average_deep_time',AVG(alcohol_consumption) AS 'average_alcohol_consumption'
-- FROM practise.sleep_efficiency
-- WHERE exercise_frequency >= 3 
-- GROUP BY awakenings
-- ORDER BY average_deep_time DESC

-- Q-6 
-- SELECT power_station,count(*) AS 'no',AVG(monitored_cap) AS 'average_monitored_cap'
-- FROM practise.powergeneration
-- GROUP BY power_station 
-- HAVING no > 200 AND average_monitored_cap BETWEEN 1000 AND 2000
-- ORDER BY no DESC

-- SELECT `power_station`,
-- AVG(`monitored_cap`) AS 'avg_capacity',
-- COUNT(*) AS 'occurence'
-- FROM practise.powergeneration
-- GROUP BY `power_station`
-- HAVING (avg_capacity BETWEEN 1000 AND 2000) AND occurence > 200 
-- ORDER BY avg_capacity DESC;


-- Q7 
-- SELECT State,ROUND(AVG(Value),2) AS 'Fees',COUNT(*)
-- FROM practise.university
-- WHERE Year in (2013,2017,2021) AND Type = 'Public In-State'
-- GROUP BY State	
-- HAVING COUNT(*) BETWEEN 6 AND 10
-- ORDER BY Fees ASC LIMIT 10

-- Q8 Best state in terms of low education cost (Tution Fees) in 'Public' type university.
-- SELECT State,ROUND(AVG(Value),2) AS 'Fees'
-- FROM practise.university	
-- WHERE Type LIKE '%Public%' AND Expense = 'Fees/Tuition'
-- GROUP BY Year,State
-- ORDER BY Fees ASC LIMIT 1

-- Q9 Best state in terms of low education cost (Tution Fees) in 'Public' type university.
-- SELECT State,ROUND(AVG(Value),2) AS 'Fees'
-- FROM practise.university
-- WHERE Type LIKE 'Private%' AND Year = 2021
-- GROUP BY State
-- ORDER BY Fees DESC LIMIT 1,1 

-- Q-10
-- SELECT Mode_of_Shipment,Warehouse_block,SUM(Discount_offered) AS 'total_discount_offered',AVG(Discount_offered) AS 'average_discount_offered'
-- FROM practise.shipping_ecommerce
-- WHERE Gender = 'M' AND Product_importance = 'High'
-- GROUP BY Mode_of_Shipment,Warehouse_block
-- ORDER BY Mode_of_Shipment DESC, Warehouse_block ASC






	