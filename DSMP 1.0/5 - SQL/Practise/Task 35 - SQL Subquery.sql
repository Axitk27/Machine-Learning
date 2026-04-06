USE practise;
-- Q1 Display the names of athletes who won a gold medal in the 2008 Olympics and whose height is greater than the average height of all athletes in the 2008 Olympics. 

SELECT * FROM olympic
WHERE Year = 2008 AND height > (SELECT AVG(height) FROM olympic WHERE Year = 2008) AND Medal = 'Gold' ;

-- Q2 Display the names of athletes who won a medal in the sport of basketball in the 2016 Olympics and whose weight is less than the average weight of all athletes 
-- who won a medal in the 2016 Olympics. 

SELECT * FROM olympic
WHERE Year = 2016  AND Sport = 'Basketball' AND Weight < (SELECT AVG(Weight) FROM olympic 
WHERE Year = 2016 AND Medal NOT IN ('NA') AND Sex = 'F') AND Medal NOT IN ('NA') ;

SELECT AVG(Weight) FROM olympic 
WHERE Year = 2016 AND Medal NOT IN ('NA');

-- Q3 Display the names of all athletes who have won a medal in the sport of swimming in both the 2008 and 2016 Olympics.

SELECT DISTINCT(Name) FROM olympic year_2008
WHERE Medal NOT IN('NA') AND Year = 2008 AND year_2008.name IN (SELECT name FROM olympic WHERE Medal NOT IN('NA') AND Year = 2016) AND Sport = 'Swimming'
ORDER BY Name;

SELECT DISTINCT Name
FROM olympic
WHERE Sport = 'Swimming'
  AND Medal NOT IN('NA')
  AND Name IN (
    SELECT Name
    FROM olympic
    WHERE Sport = 'Swimming' AND Year = 2008 AND Medal NOT IN('NA')
  )
  AND Name IN (
    SELECT Name
    FROM olympic
    WHERE Sport = 'Swimming' AND Year = 2016 AND Medal NOT IN('NA')
  ) ORDER BY Name;
  
-- Q4 Display the names of all countries that have won more than 50 medals in a single year.

SELECT Year,Team,COUNT(*) AS 'total_medal' FROM olympic
WHERE Medal NOT IN('NA')
GROUP BY Year,Team
HAVING total_medal > 50;


-- Q5 Display the names of all athletes who have won medals in more than one sport in the same year.

SELECT DISTINCT name FROM olympic
WHERE ID IN (SELECT DISTINCT ID FROM olympic
			WHERE Medal IS NOT NULL
			GROUP BY ID,Year,Sport
			HAVING COUNT(Medal) > 1
			ORDER BY COUNT(Medal) DESC);

-- Q6 What is the average weight difference between male and female athletes in the Olympics who have won a medal in the same event?

WITH male_group AS (
    SELECT Sport,
           ROUND(AVG(Height),2) AS male_height,
           ROUND(AVG(Weight),2) AS male_weight
    FROM olympic
    WHERE Medal NOT IN ('NA') AND Sex = 'M'
    GROUP BY Sport
),
female_group AS (
    SELECT Sport,
           ROUND(AVG(Height),2) AS female_height,
           ROUND(AVG(Weight),2) AS female_weight
    FROM olympic
    WHERE Medal NOT IN ('NA') AND Sex = 'F'
    GROUP BY Sport
)
SELECT t1.Sport,t1.male_height,t1.male_weight,t2.female_height,t2.female_weight,t1.male_weight - t2.female_weight AS 'weight_diff',t1.male_height - t2.female_height AS 'height_diff'
FROM male_group t1
INNER JOIN female_group t2
    ON t1.Sport = t2.Sport;
    
    
-- Q7 How many patients have claimed more than the average claim amount for patients who are smokers and have at least one child, and belong to the southeast region?
USE practise;

SELECT COUNT(*) FROM insurancedata 
WHERE smoker = 'Yes' AND children > 0 AND region = 'southeast' AND claim > (SELECT AVG(claim) FROM insurancedata);

-- Q8 How many patients have claimed more than the average claim amount for patients who are not smokers and have a BMI greater than the average BMI for patients
-- who have at least one child? 

SELECT COUNT(*) FROM insurancedata 
WHERE smoker = 'No' AND bmi > (SELECT AVG(bmi) FROM insurancedata) AND claim > (SELECT AVG(claim) FROM insurancedata);

-- Q9 Problem 9
-- How many patients have claimed more than the average claim amount for patients who have a BMI greater than the average BMI for patients who are diabetic, 
-- have at least one child, and are from the southwest region? 

SELECT * FROM insurancedata
WHERE claim > (SELECT AVG(claim) FROM insurancedata) AND (SELECT AVG(bmi) FROM insurancedata) AND diabetic = 'Yes' AND children > 0 AND region = 'southwest';

-- Q10 What is the difference in the average claim amount between patients who are smokers and patients who are non-smokers, and have the same BMI and number of children? 

SELECT bmi,children, AVG(claim) AS 'avg_claim',
(SELECT AVG(claim) FROM insurancedata non_smoker WHERE non_smoker.smoker = 'No' AND bmi = smoker.bmi) AS 'average_claim_non_smoker',AVG(claim)-
(SELECT AVG(claim) FROM insurancedata non_smoker WHERE non_smoker.smoker = 'No' AND bmi = smoker.bmi) AS 'claim_diff'
FROM insurancedata smoker
WHERE smoker.smoker = 'Yes'
GROUP BY smoker.bmi,smoker.children

 



