USE practise;

CREATE TABLE uber (
	ride_id INTEGER PRIMARY KEY AUTO_INCREMENT,
    user_id INTEGER,
    cab_id INTEGER,
    start_time DATETIME,
    end_time DATETIME
);

INSERT INTO uber(user_id,cab_id,start_time,end_time)
VALUES 	(2,1,'2023-12-01 09:00:00', '2023-12-02 09:00:00'),
		(3,2,'2023-12-01 09:00:00', '2023-12-02 19:00:00'),
		(4,3,'2023-12-01 09:00:00', '2023-12-02 23:00:00');
        
        
-- Function 
-- Current date

SELECT CURRENT_DATE();
SELECT CURRENT_TIME();
SELECT NOW();

-- date 

SELECT DATE(start_time) FROM uber;
SELECT TIME(start_time) FROM uber;
SELECT MONTHNAME(start_time) FROM uber;
SELECT YEAR(start_time) FROM uber;
SELECT QUARTER(start_time) FROM uber;
SELECT DAY(start_time) FROM uber;
SELECT DAYNAME(start_time) FROM uber;
SELECT WEEKOFYEAR(start_time) FROM uber;
SELECT LAST_DAY(start_time) FROM uber;
SELECT WEEK(start_time),WEEKOFYEAR(start_time) FROM uber;

-- date formating
SELECT MONTHNAME(date) 
FROM
(SELECT DATE_FORMAT(start_time,'%d %b %y') AS 'date' FROM uber);
-- time formating

SELECT DATE_FORMAT(end_time,'%l:%i %p') AS 'date' FROM uber;

-- Type Conversion - Implicit time Conversion 
SELECT '2023-12-01' > '2023-12-12' ;
-- Explicit type conversion

SELECT MONTHNAME(STR_TO_DATE('2023 Mar 20','%Y %b %e'));


-- Datetime Arithmetic
SELECT DATEDIFF('2023-12-12','2023-12-01'); 
SELECT TIMEDIFF(end_time,start_time) FROM uber; 
SELECT DATE_ADD(NOW(),INTERVAL 10 MINUTE);
SELECT DATE_SUB(NOW(),INTERVAL 10 MONTH);

--

CREATE TABLE posts(
	post_id INTEGER PRIMARY KEY AUTO_INCREMENT,
    user_id INTEGER,
    content TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP(),
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP() ON UPDATE CURRENT_TIMESTAMP
);

INSERT INTO posts (user_id,content)
VALUES (1,'Hello World');

UPDATE posts
SET content = 'No Hello World'
WHERE post_id = 1;

-- Extra Questions 
USE practise;

-- 1. Find the month with most number of flights

SELECT MONTHNAME(Date_of_Journey) AS Month,COUNT(*) AS Flight FROM flights
GROUP BY MONTHNAME(Date_of_Journey)
ORDER BY Flight DESC;


-- 2. Which week day has most costly flights

SELECT WEEKDAY(Date_of_Journey) AS Day,AVG(Price) AS avg_price FROM flights
GROUP BY WEEKDAY(Date_of_Journey)
ORDER BY avg_price DESC;

-- 3. Find number of indigo flights every month
WITH temp_df AS (
	SELECT * FROM flights
    WHERE Airline = 'Indigo')
    
SELECT  MONTHNAME(Date_of_Journey) AS month,COUNT(*) AS 'flight_no' FROM temp_df
GROUP BY MONTHNAME(Date_of_Journey)
ORDER BY flight_no DESC;

--  4. Find list of all flights that depart between 10AM and 2PM from Delhi to Banglore

WITH temp_df AS (
	SELECT * FROM flights
    WHERE Source = 'Banglore' AND Destination = 'Delhi'
)

SELECT * FROM temp_df
WHERE TIME(Dep_Time) BETWEEN  TIME('10:00:00') AND TIME('14:00:00');

-- 5. Find the number of flights departing on weekends from Bangalore

WITH temp_df AS(
	SELECT * FROM flights
	WHERE Source = 'Banglore'
)

SELECT COUNT(*) AS 'Flight_No' FROM temp_df
WHERE DAYNAME(Date_of_Journey) IN ('Saturday','Sunday') ;


-- 6. Calculate the arrival time for all flights by adding the duration to the departure time.

SELECT * FROM flights;

ALTER TABLE flights
ADD COLUMN departure DATETIME, 
ADD COLUMN arrival DATETIME ;

-- merge date and time
UPDATE flights 
SET departure = STR_TO_DATE(CONCAT(Date_of_Journey,' ',dep_time),'%Y-%m-%d %H:%i');


ALTER TABLE flights
ADD COLUMN duration_min INTEGER;

UPDATe flights 
SET duration_min = (REPLACE(SUBSTRING_INDEX(Duration,' ',1),'h','')*60 + 
	CASE 
		WHEN SUBSTRING_INDEX(Duration,' ',-1) = SUBSTRING_INDEX(Duration,' ',1) THEN 0
        ELSE REPLACE(SUBSTRING_INDEX(Duration,' ',-1),'m','')
        END );
-- add duration + total_times 
UPDATE flights
SET arrival = DATE_ADD(departure,INTERVAL duration_min MINUTE);

SELECT TIME(arrival) FROM flights;

-- 7. Calculate the arrival date for all the flights

SELECT DATE(arrival) FROM flights;

-- 8. Find the number of flights which travel on multiple dates.

SELECT COUNT(*) FROM flights
WHERE DATE(departure) != DATE(arrival);

-- 9 Calculate the average duration of flights between all city pairs. The answer
-- should In xh ym format
SELECT Source,Destination,TIME_FORMAT(SEC_TO_TIME(AVG(duration_min)*60),'%kh:%im') AS 'Average_min' FROM flights
GROUP BY Source,Destination;

-- 10. Find all flights which departed before midnight but arrived at their destination
-- after midnight having only 0 stops.

WITH temp_df AS(
	SELECT * FROM flights
	WHERE total_stops = 'non-stop'
)

SELECT * FROM temp_df
WHERE DATE(arrival) > DATE(departure);


-- 11. Find quarter wise number of flights for each airline

SELECT QUARTER(Date_of_journey),Airline,COUNT(*) FROM flights
GROUP BY QUARTER(departure),Airline;


-- 12. Find the longest flight distance(between cities in terms of time) in India

SELECT * FROM flights
ORDER BY duration_min DESC LIMIT 1;

-- 13. Average time duration for flights that have 1 stop vs more than 1 stops

WITH temp_df AS(
SELECT Total_stops,AVG(duration_min) AS 'avg_time' FROM flights
GROUP BY Total_stops)

-- SELECT * FROM temp_df;

SELECT 
		CASE WHEN Total_stops = '1 stop' THEN SUM(avg_time) END,
		CASE WHEN Total_stops != '1 stop' THEN SUM(avg_time) END
FROM temp_df;	

-- 14. Find all Air India flights in a given date range originating from Delhi

SELECT * FROM flights
WHERE Source = 'Delhi' AND departure BETWEEN DATE('2019-01-15') AND DATE('2019-04-21');

-- 15. Find the longest flight of each airline
SELECT Airline,Source,Destination,TIME_FORMAT(SEC_TO_TIME(MAX(duration_min)*60),'%kh:%im') AS 'flights' FROM flights
GROUP BY Airline
ORDER BY flights DESC; 

-- 16. Find all the pair of cities having average time duration > 3 hours

SELECT Source,Destination,TIME_FORMAT(SEC_TO_TIME(AVG(duration_min)*60),'%kh:%im') AS 'flights' FROM flights
GROUP BY Source,Destination
HAVING AVG(duration_min) > 180;

-- 17 Make a weekday vs time grid showing avg flight count from Banglore and Delhi

WITH temp_df AS(
	SELECT * FROM flights
    WHERE Source = 'Banglore' AND Destination = 'Delhi')
    
SELECT DAYNAME(departure) AS 'Day',
	SUM(CASE WHEN HOUR(departure) BETWEEN 0 AND 5 THEN 1 ELSE 0 END) AS '12AM - 6AM',
	SUM(CASE WHEN HOUR(departure) BETWEEN 6 AND 11 THEN 1 ELSE 0 END) AS '6AM - 12PM',
	SUM(CASE WHEN HOUR(departure) BETWEEN 12 AND 17 THEN 1 ELSE 0 END) AS '12PM - 6PM',
	SUM(CASE WHEN HOUR(departure) BETWEEN 18 AND 23 THEN 1 ELSE 0 END) AS '6PM - 12PM'
FROM temp_df
GROUP BY DAYNAME(departure)
ORDER BY DAYOFWEEK(departure) ASC;

-- 18 Make a weekday vs time grid showing avg flight price from Banglore and Delhi
WITH temp_df AS(
	SELECT * FROM flights
    WHERE Source = 'Banglore' AND Destination = 'Delhi')
    
SELECT DAYNAME(departure) AS 'Day',
	AVG(CASE WHEN HOUR(departure) BETWEEN 0 AND 5 THEN price ELSE NULL END) AS '12AM - 6AM',
	AVG(CASE WHEN HOUR(departure) BETWEEN 6 AND 11 THEN price ELSE NULL END) AS '6AM - 12PM',
	AVG(CASE WHEN HOUR(departure) BETWEEN 12 AND 17 THEN price ELSE NULL END) AS '12PM - 6PM',
	AVG(CASE WHEN HOUR(departure) BETWEEN 18 AND 23 THEN price ELSE NULL END) AS '6PM - 12PM'
FROM temp_df
GROUP BY DAYNAME(departure)
ORDER BY DAYOFWEEK(departure) ASC;