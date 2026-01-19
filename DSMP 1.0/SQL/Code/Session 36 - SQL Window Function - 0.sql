USE zomato;
SELECT *,ROW_NUMBER() OVER(ORDER BY marks DESC) FROM students;

SELECT * FROM (SELECT user_id,MONTHNAME(date) AS 'Month',SUM(amount) AS 'Sum',RANK() OVER(PARTITION BY MONTHNAME(date) ORDER BY SUM(amount) DESC) AS 'Month_rank'
FROM orders
GROUP BY user_id,MONTHNAME(date)
ORDER BY MONTH(date)) t
WHERE Month_rank < 3
ORDER BY Month DESC, Month_rank ASC;


-- FIRST Value
USE lecture;
SELECT *,FIRST_VALUE(name) OVER (ORDER BY marks DESC) AS 'Highest' FROM students; 


-- Last Value 

SELECT *,
	    NTH_VALUE(name,2) OVER (w) AS Second_Highest
FROM students
WINDOW w AS (PARTITION BY branch ORDER BY marks DESC 
			  ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING);


SELECT *,
       NTH_VALUE(name, 2) OVER w AS Second_Highest
FROM students
WINDOW w AS (PARTITION BY branch ORDER BY marks DESC
             ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING);




SELECT name,marks,branch FROM (SELECT *,FIRST_VALUE(name) OVER (PARTITION BY branch ORDER BY marks ASC) AS 'Highest' FROM students) t
WHERE name = t.Highest;


SELECT *,LAG(marks) OVER(PARTITION BY branch ORDER BY marks) FROM students




