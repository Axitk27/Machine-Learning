USE lecture;
-- Ranking function 

SELECT * FROM (SELECT batter,BattingTeam,SUM(batsman_run) AS 'total_runs',
DENSE_RANK() OVER(PARTITION BY BattingTeam ORDER BY total_runs DESC) AS 'rank'
FROM ipl
GROUP BY BattingTeam,batter) t
WHERE t.rank BETWEEN 1 AND 5
ORDER BY t.BattingTeam ASC,t.rank ASC;

-- Cumulative SUM

SELECT * FROM (SELECT CONCAT("Match - ",CAST(ROW_NUMBER() OVER(ORDER BY ID ASC) AS CHAR)) AS 'match_number', 
SUM(batsman_run) AS 'batsman_run',
SUM(SUM(batsman_run)) OVER(ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS 'accumulative_runs'
FROM ipl
WHERE batter = 'V Kohli'
GROUP BY ID) t
WHERE match_number = "Match - 50" OR match_number = "Match - 100" OR match_number = "Match - 193";


-- Cumulative Average 

SELECT 
    CONCAT('Match - ', CAST(ROW_NUMBER() OVER(ORDER BY ID ASC) AS CHAR)) AS match_number,
    SUM(batsman_run) AS runs,
    AVG(SUM(batsman_run)) OVER w AS accumulative_average
FROM ipl
WHERE batter = 'V Kohli'
GROUP BY ID
WINDOW w AS (ORDER BY ID ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW)
ORDER BY ID;

-- Running Average - You are having a 

SELECT 
    CONCAT('Match - ', CAST(ROW_NUMBER() OVER(ORDER BY ID ASC) AS CHAR)) AS match_number,
    SUM(batsman_run) AS runs,
    AVG(SUM(batsman_run)) OVER(ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS accumulative_average,
    AVG(SUM(batsman_run)) OVER(ORDER BY ID ROWS BETWEEN 9 PRECEDING AND 0 FOLLOWING) AS 'rolling_average'
FROM ipl
WHERE batter = 'V Kohli'
GROUP BY ID
WINDOW w AS (ORDER BY ID ROWS BETWEEN 9 PRECEDING AND  CURRENT ROW)
ORDER BY ID;

-- Percent of total
USE zomato;

SELECT t.f_name, 
100*total_value/SUM(total_value) OVER() AS 'percent_value'
FROM 
(SELECT t2.f_id,t3.f_name,
SUM(t1.amount) AS total_value 
FROM orders t1
INNER JOIN order_details t2
ON t1.order_id = t2.order_id 
INNER JOIN food t3
ON t3.f_id = t2.f_id
WHERE r_id = 5
GROUP BY f_id) t;

-- Perecent Chnage
USE lecture;
SELECT YEAR(date),MONTHNAME(date),
100*(SUM(views) - LAG(SUM(views)) OVER(ORDER BY YEAR(date),MONTHNAME(date)))/LAG(SUM(views)) OVER(ORDER BY YEAR(date),MONTHNAME(date)) AS 'percentage_change'
FROM youtube
GROUP BY YEAR(date),MONTHNAME(date)
ORDER BY YEAR(date),MONTHNAME(date);

SELECT *,LAG(views,7) OVER(ORDER BY date),
100* (views - LAG(views,7) OVER(ORDER BY date))/ LAG(views,7) OVER(ORDER BY date)
FROM youtube
ORDER BY date;

-- Percentiles & Quantiles
-- Quantile  - To devide data in a equal number of part
	-- Ex - deciles - ten equal part
		 -- Quartile - Four equal part
         -- percentile - 100 euqal part
         
-- Median
-- Overall median 
SELECT *,
PERCENTILE_DISC(0.5) WITHIN GROUP(ORDER BY marks ASC) OVER() AS 'median marks'
FROM students; 
 
-- branch wise data

SELECT *,
PERCENTILE_DISC(0.5) WITHIN GROUP(ORDER BY marks ASC) OVER(PARTITION BY branch) AS 'median marks'
FROM students;  

SELECT *,
PERCENTILE_CONT(0.5) WITHIN GROUP(ORDER BY marks ASC) OVER(PARTITION BY branch) AS 'median marks1',  -- Continuous percentile value consider as a continuous value
PERCENTILE_DISC(0.5) WITHIN GROUP(ORDER BY marks ASC) OVER(PARTITION BY branch) AS 'median marks2'
FROM students; 

 -- 1 2 3 4 4 5 
-- Continuoys 3 + 4 / 2 = 3.5
-- Descrite 3 or 4 median

-- Find the outlier

SELECT * FROM (SELECT *,
PERCENTILE_DISC(0.25) WITHIN GROUP(ORDER BY marks) OVER() AS 'Q1',
PERCENTILE_DISC(0.75) WITHIN GROUP(ORDER BY marks) OVER() AS 'Q3'
FROM students) t
WHERE t.marks NOT BETWEEN t.Q1 - 1.5*(t.Q3 - t.Q1) AND t.Q3 + 1.5*(t.Q3 - t.Q1);


-- Segmentation - into the bucket

SELECT *,
NTILE(3) OVER(ORDER BY marks DESC) AS 'Buckets'
FROM students; 

USE mobilephone;


SELECT brand_name,model,price, 
CASE 
	WHEN t.bucket = 1 THEN 'budget'
    WHEN t.bucket = 2 THEN 'mid-range'
    WHEN t.bucket = 3 THEN 'premium'
END AS 'phone_type'
FROM (
SELECT  brand_name,
		model,price,
		NTILE(3) OVER(ORDER BY price) AS 'bucket'
		FROM smartphones) t;
        
        
-- Cumulative distribution

SELECT * ,
100*CUME_DIST() OVER(ORDER BY marks) AS 'percentile_score'
FROM students;

-- Partition by multiple columns
USE practise;

SELECT * FROM(SELECT Source,Destination,airline,AVG(Price), 
DENSE_RANK() OVER(PARTITION BY source,Destination ORDER BY AVG(Price) ) AS 'rank'
FROM flights
GROUP BY Source,Destination,airline) t
WHERE t.rank < 2
 