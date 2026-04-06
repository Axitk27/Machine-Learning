USE lecture;

CREATE TABLE employee (
	emp_id INT PRIMARY KEY,
    emp_name VARCHAR(100),
    emp_department VARCHAR(50),
    emp_salary DECIMAL(10,2),
    emp_duration_in_days INT
);

INSERT INTO employee (emp_id, emp_name, emp_department, emp_salary, emp_duration_in_days)
VALUES
		(1, 'John Doe', 'IT', 60000, 365),
		(2, 'Jane Smith', 'HR', 50000, 730),
		(3, 'Bob Brown', 'Sales', 55000, 180),
		(4, 'Alice White', 'IT', 70000, 540),
		(5, 'Charlie Black', 'HR', 45000, 120),
		(6, 'David Green', 'Marketing', 48000, 300),
		(7, 'Eva Blue', 'Sales', 52000, 250),
		(8, 'Frank Gray', 'IT', 62000, 400),
		(9, 'Grace Yellow', 'Finance', 58000, 600),
		(10, 'Henry Pink', 'Marketing', 47000, 365),
		(11, 'Isla Purple', 'HR', 46000, 220),
		(12, 'Jack Red', 'Sales', 51000, 540),
		(13, 'Karen Orange', 'Finance', 61000, 730),
		(14, 'Liam Cyan', 'IT', 64000, 365),
		(15, 'Mia Violet', 'Marketing', 49000, 180),
		(16, 'Noah Indigo', 'Sales', 53000, 450),
		(17, 'Olivia Silver', 'HR', 47000, 500),
		(18, 'Paul Bronze', 'IT', 69000, 600),
		(19, 'Quincy Gold', 'Finance', 66000, 720),
		(20, 'Rachel Platinum', 'Marketing', 46000, 365);
        
-- CTE Common Table Expression - Temporary named subquery
-- TO INCREASE TH E READIBILITY, REDUCE COMPLEXITY, ENHANC E PERFRORMACE 
-- QUERY WITH 'WITH CLAUSE'

SELECT EMP_DEPARTMENT,AVG(EMP_SALARY) AS 'avg_salary' FROM employee
WHERE EMP_DURATION_IN_DAYS > 200 
GROUP BY EMP_DEPARTMENT;

-- With Subquery

SELECT * FROM employee t 
WHERE emp_salary BETWEEN (SELECT AVG(EMP_SALARY) AS 'avg_salary' FROM employee
					WHERE EMP_DURATION_IN_DAYS > 200 AND emp_department = t.emp_department
					GROUP BY EMP_DEPARTMENT) - 2000
                    
                    AND 
					(SELECT AVG(EMP_SALARY) AS 'avg_salary' FROM employee
					WHERE EMP_DURATION_IN_DAYS > 200 AND emp_department = t.emp_department
					GROUP BY EMP_DEPARTMENT) + 2000;
                    
SELECT 
    emp_department, AVG(EMP_SALARY) AS 'avg_salary'
FROM
    employee
WHERE
    EMP_DURATION_IN_DAYS > 200
GROUP BY EMP_DEPARTMENT;

-- With window function 
SELECT * FROM (SELECT *,AVG(EMP_SALARY) OVER(PARTITION BY emp_department) AS 'avg_salary' FROM employee
WHERE EMP_DURATION_IN_DAYS > 200) t
WHERE t.emp_salary - t.avg_salary  BETWEEN -2000 AND 2000
ORDER BY t.emp_id ;

-- Issue with subquery
	-- Decrease the readbility 
	-- Complexity Increase
	-- Decrease2 the performacne
    
-- How to Solve this 
	-- Common table expression 
    
-- How to use that
	-- we need to use that in one go 
    
WITH t AS (SELECT emp_department,AVG(EMP_SALARY) AS 'avg_salary' FROM employee
		   WHERE EMP_DURATION_IN_DAYS > 200
		   GROUP BY EMP_DEPARTMENT)
           

SELECT * FROM employee e
WHERE e.emp_salary > (SELECT avg_salary FROM t WHERE e.emp_department = t.emp_department);

-- WHERE AVG(EMP_SALARY) BETWEEN -2000 AND 2000;

-- Advantage
-- Performance getting increased
-- readability is also increased


-- Q - 2 Select the department from the employee table whose average salary is more than average salary across the department
WITH t 
AS(SELECT AVG(emp_salary) AS 'avg_salary' FROM employee)

SELECT emp_department,
		AVG(emp_salary) AS 'department_average',
        (SELECT avg_salary FROM t) AS 'company_average' 
FROM employee e
GROUP BY emp_department 
HAVING AVG(emp_salary) > (SELECT avg_salary FROM t WHERE emp_department = e.emp_department);


-- Option 2 

WITH t 
AS(SELECT emp_department,AVG(emp_salary) AS 'avg_salary' FROM employee GROUP BY emp_department)

SELECT * FROM t
WHERE avg_salary > (SELECT AVG(emp_salary) FROM employee);


-- Multiple CTE 

WITH  cte as (
	SELECT emp_department,AVG(emp_salary)AS 'average_salary' FROM employee
	GROUP BY emp_department
),
cte1 as (
	SELECT emp_department,ROUND(COUNT(*)) AS 'employee'FROM employee
    GROUP BY emp_department
)

SELECT t1.emp_department,t1.average_salary,t2.employee FROM cte t1
JOIN cte1 t2
ON t1.emp_department = t2.emp_department;