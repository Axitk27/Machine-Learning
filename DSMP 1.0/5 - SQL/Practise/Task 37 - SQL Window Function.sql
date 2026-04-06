USE nord_wind;
-- Q-1: Rank Employee in terms of revenue generation. Show employee id, first name, revenue, and rank

SELECT 
t.FirstName,t.EmployeeID,t.revenue,DENSE_RANK() OVER(ORDER BY revenue DESC) AS 'rank'
FROM(SELECT t3.FirstName,t3.EmployeeID,SUM(t2.UnitPrice * t2.Quantity) AS 'revenue' 
FROM nw_orders t1
INNER JOIN nw_order_details t2
ON t1.OrderID = t2.OrderID 
INNER JOIN nw_employees t3
ON t3.EmployeeID = t1.EmployeeID
GROUP BY t3.FirstName) t;

-- Option 2
select e.EmployeeID, e.FirstName , sum(od.UnitPrice * od.Quantity) as revenue,
rank() over( order by sum(od.UnitPrice * od.Quantity) desc) as EmpRank
from nw_orders o join 
nw_order_details od on od.OrderID = o.OrderID
join nw_employees e on e.EmployeeID = o.EmployeeID
group by e.EmployeeID, e.FirstName
order by EmpRank;

-- Q-2: Show All products cumulative sum of units sold each month.
-- Unit per Product sold 
-- SELECT MONTHNAME(t2.OrderDate) AS 'month',YEAR(t2.OrderDate) AS 'year',t1.ProductID,

SELECT 
*,SUM(t.total_quantity) OVER(PARTITION BY t.ProductID ORDER BY t.month rows between unbounded preceding and current row) AS 'aqumalative_sum'
FROM (SELECT t1.ProductID,MONTH(t2.OrderDate) AS 'month',SUM(t1.Quantity) AS 'total_quantity'
FROM nw_order_details t1
INNER JOIN nw_orders t2
ON t1.OrderID = t2.OrderID
-- ORDER BY year,month;
GROUP BY t1.ProductID,MONTHNAME(t2.OrderDate)) t;

-- total Unit sold 

SELECT MONTHNAME(t2.OrderDate) AS 'month',YEAR(t2.OrderDate) AS 'year',
SUM(t1.Quantity) OVER(PARTITION BY t1.ProductID)AS 'quantity_sold' FROM nw_order_details t1
INNER JOIN nw_orders t2
ON t1.OrderID = t2.OrderID
ORDER BY year,month;

-- Option 2 

select p.ProductID, month(o.OrderDate) 'Month', sum(od.Quantity)  as 'QuantitySum',
sum(sum(od.Quantity)) over(partition by p.ProductID order by month(o.OrderDate) rows between unbounded preceding and current row) as QuantityCumSum
from nw_orders o 
join nw_order_details od 
on od.OrderID = o.OrderID
join nw_products p 
on p.ProductID = od.ProductID
group by p.ProductID, month(o.OrderDate);

-- Q-3: Show Percentage of total revenue by each suppliers

SELECT t2.CompanyName,SUM(Quantity*t3.UnitPrice) / SUM(SUM(Quantity*t3.UnitPrice)) OVER() * 100 AS 'percent_revenue'
FROM nw_products t1
INNER JOIN nw_suppliers t2
ON t1.SupplierID = t2.SupplierID
INNER JOIN nw_order_details t3
ON t3.ProductID = t1.ProductID
GROUP BY t2.CompanyName
ORDER BY percent_revenue DESC;

-- Option 2 

select s.SupplierId, sum(od.UnitPrice*od.Quantity) as Revenue, sum(od.UnitPrice*od.Quantity) /
sum(sum(od.UnitPrice*od.Quantity)) over() * 100 as PercentTotalRevenue
from nw_suppliers s 
join nw_products p on p.SupplierId=s.SupplierID
join nw_order_details od on p.ProductID=od.ProductID
group by s.SupplierId
order by Revenue desc; 

-- Q-4: Show Percentage of total orders by each suppliers
SELECT t.supplierID,t.order,100*t.order/SUM(t.order) OVER() AS 'total_order' 
FROM (SELECT t2.SupplierID,COUNT(DISTINCT(OrderID)) AS 'order' FROM nw_order_details t1
INNER JOIN nw_products t2
ON t1.ProductID = t2.ProductID
GROUP BY SupplierID) t
ORDER BY total_order DESC;

select s.SupplierId, count(distinct od.OrderID) as NumberOfOrder, count(distinct od.OrderID) /
sum(count(distinct od.OrderID)) over() * 100 as PercentTotalOrder
from nw_suppliers s join nw_products p on p.SupplierId=s.SupplierID
join nw_order_details od on p.ProductID=od.ProductID
group by s.SupplierId
order by NumberOfOrder desc;

-- Q-5:Show All Products Year Wise report of totalQuantity sold, percentage change from last year.
SELECT t.year,
t.ProductID,
t.quantity_sold,
100*(t.quantity_sold - LAG(t.quantity_sold) OVER(PARTITION BY t.ProductID ORDER BY t.year))/LAG(t.quantity_sold) OVER(PARTITION BY t.ProductID ORDER BY t.year) AS 'Percentage_change'
FROM(SELECT YEAR(OrderDate) AS 'year',t2.ProductID,SUM(Quantity) AS "quantity_sold" FROM nw_orders t1
JOIN nw_order_details t2
ON t1.OrderID = t2.OrderID
GROUP BY YEAR(OrderDate),t2.ProductID) t;


select *, 100 *(Quantity - lag(Quantity) over(partition  by ProductId order by ProductId, Year))/lag(Quantity) over(partition  by ProductId order by ProductId, Year) PercentageChange
from (select p.ProductID, year(o.OrderDate) Year, sum( od.Quantity)  as 'Quantity'
from nw_orders o join nw_order_details od on od.OrderID = o.OrderID
join nw_products p on p.ProductID = od.ProductID
group by p.ProductID,year(o.OrderDate)
order by p.ProductID,year(o.OrderDate)) t;

USE drugs;
-- Problem-6: For each condition, what is the average satisfaction level of drugs that are "On Label" vs "Off Label"?

-- SELECT t1.Condition,RANK() OVER(PARTITION BY drug_clean.Condition,Indication ORDER BY t.condition_statisfication DESC) AS 'rank'
-- FROM(

SELECT * FROM (
SELECT drug_clean.Condition,
Indication,
AVG(Satisfaction) OVER(PARTITION BY drug_clean.Condition,Indication) AS 'condition_statisfication',
ROW_NUMBER() OVER(PARTITION BY drug_clean.Condition,Indication) AS 'number'
FROM drug_clean) t
WHERE t.number = 1
ORDER BY t.Condition ;

SELECT drug_clean.Condition,Indication,ROUND(AVG(Satisfaction),2) AS 'average_statisfaction' FROM drug_clean
GROUP BY drug_clean.Condition,Indication;

-- Option 2 


WITH temp_df AS (
        SELECT
            drug_clean.Condition,
            drug_clean.Indication,
            drug_clean.Satisfaction,
            ROUND(
                AVG(drug_clean.Satisfaction) OVER(
                    PARTITION BY drug_clean.Condition,
                    drug_clean.Indication
                    ORDER BY drug_clean.Satisfaction
                    ROWS BETWEEN UNBOUNDED PRECEDING
                        AND UNBOUNDED FOLLOWING
                ),
                2
            ) AS avg_satisfaction,
            DENSE_RANK() OVER(
                PARTITION BY drug_clean.Condition,
                drug_clean.Indication
                ORDER BY
                    drug_clean.Satisfaction
            ) AS rank_num
        FROM drug_clean
    )
SELECT
    temp_df.Condition,
    temp_df.Indication,
    temp_df.avg_satisfaction
FROM temp_df
where rank_num = 1;


-- Problem-7: For each drug type (RX, OTC, RX/OTC), what is the average ease of use and satisfaction level of drugs with a price above the median for their type?

SELECT T.Type,AVG(T.Satisfaction) AS 'avg_statisfication',AVG(T.EaseOfUse) AS 'avg_ease_of_use' FROM(SELECT *,
PERCENTILE_DISC(0.5) WITHIN GROUP(ORDER BY Price ASC) OVER(PARTITION BY Type) AS 'medianPrice'
FROM drug_clean
WHERE Type IN ('RX', 'OTC', 'RX/OTC')) t
WHERE t.Price >= t.medianPrice 
GROUP BY t.Type;



-- Option 2 

WITH temp_df as (
    SELECT Type,
        AVG(EaseOfUse) OVER(PARTITION BY Type) AS avg_ease_of_use,
        AVG(Satisfaction) OVER(PARTITION BY Type) AS avg_satisfaction
    FROM (
        SELECT
            Type, Price,
            PERCENTILE_CONT(0.5) WITHIN GROUP (
                ORDER BY Price
            ) OVER (PARTITION BY Type) AS median_price,
            EaseOfUse,
            Satisfaction
        FROM drug_clean AS drugs WHERE Type IN ('RX', 'OTC', 'RX/OTC')
    ) AS subquery
    WHERE Price >= median_price
)

SELECT Type, avg_ease_of_use, avg_satisfaction FROM temp_df GROUP BY Type;

-- Problem 8: What is the cumulative distribution of EaseOfUse ratings for each drug type (RX, OTC, RX/OTC)? Show the results in descending order by drug type and 
-- cumulative distribution. (Use the built-in method and the manual method by calculating on your own. For the manual method, use the "ROWS BETWEEN UNBOUNDED PRECEDING 
-- AND CURRENT ROW" and see if you get the same results as the built-in method.)


SELECT Type, EaseOfUse,
       COUNT(*) OVER (
            PARTITION BY Type
            ORDER BY EaseOfUse
        ) * 1.0 / COUNT(*) OVER (PARTITION BY Type) AS cumulative_dist_manual,
        cume_dist() over(
            partition by Type
            order by EaseOfUse
        ) as 'cumulative_dist_builtin'
FROM drug_clean AS drugs
WHERE Type IN ('RX', 'OTC', 'RX/OTC');

-- Problem 9: What is the median satisfaction level for each medical condition? Show the results in descending order by median satisfaction level.
 -- (Don't repeat the same rows of your result.)

SELECT t.Condition,t.median_statisfiction_condition
FROM (SELECT *,PERCENTILE_DISC(0.5) WITHIN GROUP(ORDER BY Satisfaction ASC) OVER(PARTITION BY drug_clean.Condition) AS 'median_statisfiction_condition',
ROW_NUMBER() OVER(PARTITION BY drug_clean.Condition ORDER BY Satisfaction DESC) AS 'rank'
FROM drug_clean) t
WHERE t.rank = 1
ORDER BY t.median_statisfiction_condition DESC;

-- Option 2
WITH temp_df AS (
    SELECT drugs.Condition,
       PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY drugs.Satisfaction) OVER (PARTITION BY drugs.Condition) AS median_satisfaction
    FROM drug_clean AS drugs
)

SELECT temp_df.Condition, temp_df.median_satisfaction
FROM temp_df
GROUP BY temp_df.Condition
ORDER BY temp_df.median_satisfaction DESC;

-- Problem 10: What is the running average of the price of drugs for each medical condition? Show the results in ascending order by medical condition and drug name.
SELECT 
	drug_clean.Condition,
	Drug,
    Price,
    SUM(Price) OVER(PARTITION BY drug_clean.Condition ORDER BY Price 
		ASC ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) /
        COUNT(Price) OVER(PARTITION BY drug_clean.Condition ORDER BY
        Price ASC ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW)
        AS 'cumulative_average'
FROM drug_clean
ORDER BY drug_clean.Condition ASC;

-- Option 2 

SELECT drugs.Condition, drugs.Drug, ROUND(drugs.Price, 2),
    ROUND(AVG(drugs.Price) OVER (
        PARTITION BY drugs.Condition
        ORDER BY drugs.Drug
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ), 2) AS running_avg_price
FROM drug_clean AS drugs
ORDER BY drugs.Condition ASC, drugs.Drug ASC;

-- Problem 11: What is the percentage change in the number of reviews for each drug between the previous row and the current row? 
-- Show the results in descending order by percentage change.

SELECT 
	drug_clean.Condition,
    Drug, 
	Reviews,
    LAG(Reviews) OVER(PARTITION BY drug_clean.Condition, Drug ORDER BY Reviews DESC) AS 'next_review',
 	100*(Reviews - LAG(Reviews) OVER(PARTITION BY drug_clean.Condition, Drug ORDER BY Reviews DESC))/ 
 	LAG(Reviews) OVER(PARTITION BY drug_clean.Condition, Drug ORDER BY Reviews DESC)
	AS 'value_change'
FROM drug_clean
ORDER BY value_change DESC;

-- Option 2

SELECT drugs.Condition, drugs.Drug, drugs.Reviews,
    (drugs.Reviews - LAG(drugs.Reviews) OVER (
        PARTITION BY drugs.Condition, drugs.Drug
        ORDER BY drugs.Reviews DESC)
    ) * 100.0 / LAG(drugs.Reviews) OVER (
        PARTITION BY drugs.Condition, drugs.Drug
        ORDER BY drugs.Reviews DESC
    ) AS pct_change
FROM drug_clean AS drugs
ORDER BY pct_change DESC;



-- Problem 12: What is the percentage of total satisfaction level for each drug type (RX, OTC, RX/OTC)?
-- Show the results in descending order by drug type and percentage of total satisfaction.

SELECT * FROM(SELECT *,ROW_NUMBER() OVER(PARTITION BY type) AS 'rank' 
FROM (SELECT type,100*SUM(Satisfaction) OVER(PARTITION BY type)/SUM(Satisfaction) OVER() AS 'satisfaction_level' 
FROM drug_clean) t) t1
WHERE t1.rank = 1
ORDER BY t1.satisfaction_level DESC;

-- Option 2

WITH temp_df AS (
    SELECT Type, Satisfaction,
        ROUND(SUM(Satisfaction) OVER (PARTITION BY Type) * 100.0 / SUM(Satisfaction) OVER (),2) AS pct_total_satisfaction
    FROM drug_clean AS drugs
    WHERE Type IN ('RX', 'OTC', 'RX/OTC')
    ORDER BY Type ASC, pct_total_satisfaction DESC
)

SELECT Type, pct_total_satisfaction FROM temp_df
GROUP BY Type;

-- Problem 13: What is the cumulative sum of effective ratings for each medical condition and drug form combination? 
-- Show the results in ascending order by medical condition, drug form and the name of the drug.

SELECT drug_clean.Condition,
		Drug,
        SUM(Satisfaction) 
        OVER(PARTITION BY drug_clean.Condition,
			Form ORDER BY Drug ASC 
            ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) 
		AS 'accumalative_effective_rating'
FROM drug_clean
ORDER BY drug_clean.Condition ASC,
		 Form ASC,
		 Drug ASC;

-- Option 2 

SELECT drugs.Condition, drugs.Form, drugs.Drug,
    drugs.Effective,
    SUM(drugs.Effective) OVER (
        PARTITION BY drugs.Condition, drugs.Form
        ORDER BY drugs.Drug
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ) AS cumulative_sum_effective
FROM drug_clean drugs
ORDER BY
    drugs.Condition ASC,
    drugs.Form ASC,
    drugs.Drug ASC;

-- Problem-14: What is the rank of the average ease of use for each drug type (RX, OTC, RX/OTC)? Show the results in descending order by rank and drug type.

SELECT 	Type,
		EaseOfUse,
        DENSE_RANK() 
        OVER(PARTITION BY Type ORDER BY AVG(EaseOfUse) DESC) 
        AS 'rank' 
FROM drug_clean
GROUP BY Type;

-- Option 2 

SELECT
  Type,
  AVG(EaseOfUse) AS average_ease_of_use,
  RANK() OVER (ORDER BY AVG(EaseOfUse) DESC) AS 'rank'
FROM drug_clean drugs
WHERE Type IN ('RX', 'OTC', 'RX/OTC')
GROUP BY Type;


-- Problem-15: For each condition, what is the average effectiveness of the top 3 most reviewed drugs?

SELECT 	t.Condition,
		t.Drug,
        AVG(t.Effective) OVER(PARTITION BY t.Condition) AS 'Effective_drug' 
        FROM	(SELECT *,
						ROW_NUMBER() OVER(PARTITION BY drug_clean.Condition ORDER BY Reviews DESC) AS 'rank' 
				 FROM drug_clean) t
WHERE t.rank < 4;

-- Option 2


SELECT * FROM (
    SELECT
        drugs.Condition,
        drugs.Drug,
        ROUND(drugs.Reviews, 2) AS 'Reviews',
        ROUND(AVG(drugs.Effective) OVER (
            PARTITION BY drugs.Condition, drugs.Drug
            ORDER BY drugs.Reviews DESC
            ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
        ), 2) AS avg_effectiveness,
    RANK() OVER (
        PARTITION BY drugs.Condition
        ORDER BY drugs.Reviews DESC
    ) AS rank_num
    FROM drug_clean drugs
) t
WHERE rank_num <= 3;


