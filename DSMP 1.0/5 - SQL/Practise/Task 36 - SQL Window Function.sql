USE practise;
SELECT * FROM insurance_data;
-- Problem 1: What are the top 5 patients who claimed the highest insurance amounts?
-- Method 1 
	SELECT * FROM insurance_data
	ORDER BY claim DESC LIMIT 5;

-- Method 2

	SELECT * FROM (SELECT *,NTH_VALUE(claim,5) OVER(ORDER BY claim DESC) AS 'fifth_value' FROM insurance_data) t1
	WHERE claim >= t1.fifth_value OR fifth_value IS NULL ;

-- Problem 2: What is the average insurance claimed by patients based on the number of children they have?

	SELECT t1.average_claim, t1.children,t1.rank FROM 
    (SELECT *, AVG(claim) OVER(PARTITION BY children ORDER BY children DESC) AS 'average_claim',
    DENSE_RANK() OVER(PARTITION BY children ORDER BY claim DESC) AS 'rank'   FROM insurance_data ) t1
    WHERE t1.rank = 1;
    
-- Problem 3: What is the highest and lowest claimed amount by patients in each region?
	SELECT region, MIN(claim),MAX(claim) FROM insurance_data
    GROUP BY region;
    
	SELECT t1.region,t1.high_claim,t1.low_claim FROM (SELECT *,
	MAX(claim) OVER(PARTITION BY region ORDER BY claim) AS 'high_claim', 
	MIN(claim) OVER(PARTITION BY region ORDER BY claim) AS 'low_claim' , 
	ROW_NUMBER() OVER(PARTITION BY region ORDER BY claim) AS 'row_number'  
	FROM insurance_data) t1
    WHERE t1.row_number = 1;

-- Problem 4: What is the percentage of smokers in each age group?
-- group 0-18,19-50,51-70 

-- SELECT RANK() OVER(PARTITION BY age BETWEEN 1 AND 18) FROM insurance_data WHERE;


(SELECT * FROM insurance_data t1
WHERE age > 0 AND age <=18
ORDER BY age DESC) 
UNION
(SELECT * FROM insurance_data t2
WHERE age >= 19 AND age <= 50
ORDER BY age DESC)
UNION 
(SELECT * FROM insurance_data t3
WHERE age > 50
ORDER BY age DESC);


-- Problem 5: What is the difference between the claimed amount of each patient and the first claimed amount based on a rank of that patient?

	SELECT *,claim - FIRST_VALUE(claim) OVER(PARTITION BY region) AS 'diff_claim' FROM insurance_data
	GROUP BY PatientID;


-- Problem 6: For each patient, calculate the difference between their claimed amount and the average claimed amount of patients with the same number of children.

	SELECT *,
    claim-AVG(claim) OVER(PARTITION BY children) AS 'difference_claim'
    FROM insurance_data;

-- Problem 7: Show the patient with the highest BMI in each region and their respective rank.

	SELECT * 
    FROM (SELECT *,RANK() OVER(PARTITION BY region ORDER BY bmi DESC) AS 'rank_per_region', 
    RANK() OVER(ORDER BY bmi DESC) AS 'Overall_rank' 
    FROM insurance_data) t1
	WHERE t1.rank_per_region = 1
    ORDER BY t1.Overall_rank;



-- Problem 8: Calculate the difference between the claimed amount of each patient and the claimed amount of the patient who has the highest BMI in their region.

	SELECT *,
	claim-(FIRST_VALUE(claim) OVER(PARTITION BY region ORDER BY bmi DESC ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING)) AS 'claim_diff'   
	FROM insurance_data;


-- Problem 9: For each patient, calculate the difference in claim amount between the patient and the patient with the highest claim amount among patients with 
-- the smoker status, within the same region. Return the result in descending order difference.

	SELECT *,
	MAX(claim) OVER(PARTITION BY smoker,region ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) - claim  AS 'claim_diff' 
	FROM insurance_data
    ORDER BY claim_diff DESC;


-- Problem 10: For each patient, find the maximum BMI value among their next three records (ordered by age).

	SELECT *,MAX(bmi) OVER(ORDER BY age DESC ROWS BETWEEN 1 FOLLOWING AND 3 FOLLOWING) AS 'next_bmi' FROM insurance_data;

-- Problem 11: For each patient, find the rolling average of the last 2 claims.

	SELECT *,AVG(claim) OVER(ORDER BY age ROWS BETWEEN 2 PRECEDING AND 1 PRECEDING) AS 'rolling_avg' FROM insurance_data;

-- Problem 12: Find the first claimed insurance value for male and female patients, within each region order the data by patient age in ascending order,
-- and only include patients who are non-diabetic and have a bmi value between 25 and 30

WITH filtered_data AS (
SELECT * FROM insurance_data
WHERE diabetic = 'No' AND bmi BETWEEN 25 AND 30
)

SELECT * FROM 
(SELECT *,
FIRST_VALUE(claim) OVER(PARTITION BY gender,region ORDER BY age DESC) AS 'first_claim',
ROW_NUMBER() OVER(PARTITION BY gender,region ORDER BY age DESC) AS 'row_number' 
FROM filtered_data) t1
WHERE t1.row_number = 1;