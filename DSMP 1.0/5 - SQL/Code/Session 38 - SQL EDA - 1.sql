USE practise;

-- EDA(Explotary Data Analysis)
-- Two types of column 
-- (1) Numberical Column - Inches,resolution_width,resolution_height,cpu_speed,Ram,primary_storage,secondary_storage,weight,price,
-- (2) Categorical Column - Company,TypeName,touchscreen,cpu_brandmcpu_name,memory_type,gpu_brand,OpSys

-- You need to find the center of the problem and then you need to do analysis around that

-- head 
SELECT * FROM laptop
ORDER BY `Index` LIMIT 4;

-- tail

SELECT * FROM laptop
ORDER BY `Index` DESC LIMIT 4;

-- sample

SELECT * FROM laptop
ORDER BY rand() LIMIT 5;  

-- Univariate Analysis
-- (1) Price

-- Count of not null value
SELECT COUNT(Price) FROM laptop;

-- Count of Min value
SELECT MIN(Price) FROM laptop;

-- Count of Max value
SELECT MAX(Price) FROM laptop;

-- Count of Min value
SELECT MIN(Price) FROM laptop;

-- Count of 25% percentile and 75% percentile value

SELECT PERCENTILE_CONT(0.25) WITHIN GROUP(ORDER BY Price) OVER() AS 'Q1',
		PERCENTILE_CONT(0.50) WITHIN GROUP(ORDER BY Price) OVER() AS 'Median',
		PERCENTILE_CONT(0.75) WITHIN GROUP(ORDER BY Price) OVER() AS 'Q3'
FROM laptop
WHERE `Index` = 1;

-- Finding Missing value

SELECT COUNT(Price) FROM laptop
WHERE Price IS NULL;

-- Finding outliers

SELECT *
FROM (SELECT *,PERCENTILE_CONT(0.25) WITHIN GROUP(ORDER BY Price) OVER() AS 'Q1',
			PERCENTILE_CONT(0.75) WITHIN GROUP(ORDER BY Price) OVER() AS 'Q3',
            (PERCENTILE_CONT(0.75) WITHIN GROUP(ORDER BY Price) OVER()  - PERCENTILE_CONT(0.25) WITHIN GROUP(ORDER BY Price) OVER()) AS 'IQR'
	  FROM laptop) l      
WHERE price NOT BETWEEN (Q1 - 1.5* IQR) AND  (Q3 + 1.5* IQR);

-- There might be some value which is justifiable then you should not be consider that in outlier

-- draw a Histogram Vertical
-- (1) Bucket 
-- 0-25k,25-50k,50k-75k,75k-100k
SELECT REPEAT('*',t.`0-25000`) FROM (
SELECT 	SUM(l.`0-25000`)  AS '0-25000',
		SUM(l.`25001-50000`)  AS '25001-50000',
		SUM(l.`50001-75000`) AS '50001-75000' ,
		SUM(l.`75001-100000`)  AS '75001-100000' ,
		SUM(l.`>100000`) AS '>100000' 
  FROM (SELECT price,
					CASE WHEN price BETWEEN 0 AND 25000 THEN 1 ELSE 0 END AS '0-25000',
					CASE WHEN price BETWEEN 25001 AND 50000 THEN 1 ELSE 0 END AS '25001-50000',
					CASE WHEN price BETWEEN 50001 AND 75000 THEN 1 ELSE 0 END AS '50001-75000',
					CASE WHEN price BETWEEN 75001 AND 100000 THEN 1 ELSE 0 END AS '75001-100000',
					CASE WHEN price > 100000 THEN 1 ELSE 0 END AS '>100000'
				FROM laptop) l)t;
                
                
SELECT 'Hello\nWorld';
-- or
SELECT CONCAT('Hello', CHAR(10), 'World');
                
-- Option 2 draw a Histogram Horizontal
SELECT t.buckets,REPEAT('*',t.value/10) AS 'bar' FROM (SELECT COUNT(*) AS 'value',CASE
			 WHEN price BETWEEN 0 AND 25000 THEN '0-25k' 
			 WHEN price BETWEEN 25001 AND 50000 THEN  '25k-50k'
			 WHEN price BETWEEN 50001 AND 75000 THEN  '50k-75k' 
			 WHEN price BETWEEN 75001 AND 100000 THEN  '75k-100k' 
             ELSE '>100000'
        END  AS 'buckets'
FROM laptop 
GROUP BY buckets) t;

-- (2) Categorical Column 

-- frequency count

SELECT Company,COUNT(*) AS 'laptop' FROM laptop
GROUP BY Company
ORDER BY laptop DESC;


-- Bivariate Analysis
-- Numerical - Numerical
-- (1) Price - CPU Speed

SELECT PERCENTILE_CONT(0.25) WITHIN GROUP(ORDER BY Price) OVER() AS 'Q1 - Price',
		PERCENTILE_CONT(0.50) WITHIN GROUP(ORDER BY Price) OVER() AS 'Median - Price',
		PERCENTILE_CONT(0.75) WITHIN GROUP(ORDER BY Price) OVER() AS 'Q3 - Price',
        PERCENTILE_CONT(0.25) WITHIN GROUP(ORDER BY cpu_speed) OVER() AS 'Q1 - cpu_speed',
		PERCENTILE_CONT(0.50) WITHIN GROUP(ORDER BY cpu_speed) OVER() AS 'Median - cpu_speed',
		PERCENTILE_CONT(0.75) WITHIN GROUP(ORDER BY cpu_speed) OVER() AS 'Q3 - cpu_speed'
FROM laptop
WHERE `Index` = 1;

-- not possible directly
SELECT CORR(price,cpu_speed) FROM laptop;

-- Categorical - Categorical 
-- (1) Company - touchscree 

-- Contengency Table 

SELECT company,
		SUM(CASE WHEN touchscreen = 1 THEN 1 ELSE 0 END) AS 'touchscreen_yes',
		SUM(CASE WHEN touchscreen = 0 THEN 1 ELSE 0 END) AS 'touchscreen_No'
FROM laptop t1
GROUP BY company;

SELECT company,
		SUM(CASE WHEN cpu_brand = 'Intel' THEN 1 ELSE 0 END) AS 'Intel',
		SUM(CASE WHEN cpu_brand = 'Amd' THEN 1 ELSE 0 END) AS 'Amd',
		SUM(CASE WHEN cpu_brand = 'Samsung' THEN 1 ELSE 0 END) AS 'Samsung'
FROM laptop t1
GROUP BY company;

-- Numerical - Categorical data

SELECT company,MIN(price),AVG(price),MAX(price) FROM laptop
GROUP BY company
ORDER BY AVG(price) DESC;

-- Dealing with missing value
-- Updating the value NULL
UPDATE laptop l1
SET price = NULL
WHERE `Index` IN (7,100,200,300,231,234,678,876,564,456,679,1000) ;

-- Fill the value with NULL

-- (1) Fill with mean value

UPDATE laptop l1
SET price = (SELECT AVG(price) FROM laptop l2 WHERE l2.Company = l1.Company)
WHERE price IS NULL;

SELECT Company,AVG(price) FROM laptop l2 GROUP BY Company;

SELECT * FROM laptop 
WHERE `Index` IN (7,100,200,300,231,234,678,876,564,456,679,1000) ;


-- Feature Engineering
-- After EDA you get knowledge that you are not able to get insight into the column now you are generating new column 


ALTER TABLE laptop
ADD COLUMN ppi INTEGER AFTER resolution_height;

UPDATE laptop 
SET ppi = ROUND(sqrt(resolution_width*resolution_width + resolution_height*resolution_height)/inches,2) ;


ALTER TABLE laptop
ADD COLUMN screen_size VARCHAR(50) AFTER inches;

-- devide in a equal part 
SELECT *,NTILE(3) OVER(ORDER BY Inches) AS type FROM laptop; 

-- Not Working
UPDATE laptop l1
SET screen_size = (SELECT 
	CASE 
		WHEN NTILE(3) OVER(ORDER BY Inches) = 1 THEN 'Small'
		WHEN NTILE(3) OVER(ORDER BY Inches) = 2 THEN 'Medium'
		ELSE 'Large'
	END
    FROM laptop l2 WHERE l2.`Index` = l1.`Index`); 
    
UPDATE laptop l1
SET screen_size = (SELECT
	CASE 
		WHEN Inches < 14.0 THEN 'Small'
		WHEN Inches > 14.0 AND Inches < 17.0 THEN 'Medium'
		ELSE 'Large'
	END
    FROM laptop l2 WHERE l2.`Index` = l1.`Index`); 

-- ONE HOT Encoding
    
SELECT cpu_brand,
	CASE WHEN cpu_brand = 'Intel' THEN 1 ELSE 0 END AS 'Intel',
	CASE WHEN cpu_brand = 'amd' THEN 1 ELSE 0 END AS 'amd',
	CASE WHEN cpu_brand = 'nvidia' THEN 1 ELSE 0 END AS 'nvidia',
	CASE WHEN cpu_brand = 'arm' THEN 1 ELSE 0 END AS 'arm' 
FROM laptop;
