USE lecture;

-- Based on a Value returning
-- Scaler Subquery 

-- Q1 Find the movie with Highest rating
-- here there is no Hard coded value so thats why it is good way to code 
SELECT * FROM movies
WHERE score = (SELECT MAX(score) FROM movies);

-- Q2 Find the movie with highest profit
-- time complexity o(n)
SELECT * FROM movies
WHERE (gross-budget) = (SELECT MAX(gross-budget) FROM movies);

-- This one will run faster compare to the first one - sorting algoritham nlog(n)
SELECT * FROM movies 
ORDER BY (gross-budget) DESC LIMIT 1;

-- Q3 Find how many movie has a rating > avg of all the movie ratings
SELECT COUNT(*) FROM movies
WHERE score > (SELECT AVG(score) FROM movies);

SELECT AVG(score) FROM movies;

-- Q4 Find the highest rating movie of 2000
SELECT * FROM movies
WHERE score = (SELECT MAX(score) FROM movies WHERE year = 2000) AND year = 2000;


-- Q5 Find the highest rated movie among all the movies whose number of votes are > the dataset avg votes
SELECT * FROM movies
WHERE score = (SELECT MAX(score) FROM movies
WHERE votes > (SELECT ROUND(AVG(votes)) FROM movies));



-- Row Subquery

USE zomato;

-- Q6 Find all the user who never ordered
-- option 1
SELECT  user_id FROM user
WHERE user_id NOT IN (SELECT DISTINCT(user_id) FROM orders);

-- option 2
-- SELECT t1.user_id,name,email,r_id FROM user t1
-- LEFT JOIN orders t2
-- ON t1.user_id = t2.user_id
-- WHERE r_id IS NULL

-- Q7 Find all the movies made by top 3 director(gross income)
USE lecture;
-- temporary table is created 
with top_director AS (SELECT director 
					   FROM movies
					   GROUP BY director
					   ORDER BY SUM(gross) DESC LIMIT 3)

SELECT * FROM movies
WHERE director IN (SELECT director FROM top_director);


-- Q8 Find all the movies those actors whose averages rating > 8.5(take 25000 votes as cutoff)

SELECT * FROM movies 
WHERE star IN(SELECT star FROM movies 
WHERE votes > 25000
GROUP BY star
HAVING AVG(score) > 8.5) ;


-- Table Subquery 

-- Q9 Find the most profitable movie of each year  
SELECT * FROM movies
WHERE (year,gross - budget) IN (SELECT year,MAX(gross - budget) FROM movies
GROUP BY year);

-- Q10 Find the highest rated movie of each genre votes of cutoff 25000

SELECT * FROM movies 
WHERE (genre,score) IN (SELECT genre,MAX(score) FROM movies 
WHERE votes > 25000
GROUP BY genre) AND votes > 25000;

-- Q11 Find the highest rated grossing movies of top 5 actor/director combo in terms of total gross income
 
 WITH top_duos AS ( SELECT star,director,MAX(gross) FROM movies
 GROUP BY star,director
 ORDER BY SUM(gross) DESC LIMIT 5)
 
 SELECT * FROM movies
 WHERE (star,director,gross) IN (SELECT * FROM top_duos);
 
 -- Corelated subquery
 -- Inner dependon outersubquery

-- Q12 Find all the movies that have a rating higher than the average rating of movies in the same genre

SELECT * FROM movies m1
WHERE score = (SELECT MAX(score) FROM movies m2 WHERE m2.genre =  m1.genre);

SELECT * FROM movies 
WHERE writer = 'Stephen King';


-- Q13 Find the favourite food of each customer
 USE zomato;

WITH fevourite_food AS (SELECT t1.user_id,f_name,COUNT(*) AS 'frequency',t4.name FROM orders t1
JOIN order_details t2
ON t1.order_id = t2.order_id
JOIN food t3
ON t3.f_id = t2.f_id
JOIN user t4
ON t4.user_id = t1.user_id
GROUP BY t4.user_id,t3.f_id
ORDER BY COUNT(*) DESC)

SELECT * FROM fevourite_food f1
WHERE frequency = (SELECT MAX(frequency) FROM fevourite_food f2 WHERE f2.user_id = f1.user_id );

-- Subquery is used in SELECT

-- Q14 Get the percentage of votes of each movies compared to the total number of votes
USE lecture;
SELECT name,votes/(SELECT SUM(votes) FROM movies)*100 FROM movies;

-- Q15 Display all movie names,genre,score,AVG(score) of genre 
SELECT name,genre,score,(SELECT AVG(score) FROM movies m1 WHERE m1.genre = m2.genre ) AS 'average score' FROM movies m2;


-- Usage with FROM 
USE zomato;

SELECT t2.r_name,ROUND(avg_rating,2) FROM(SELECT r_id,AVG(restaurant_rating) AS 'avg_rating' FROM orders GROUP BY r_id) t1
JOIN restaurants t2
ON t1.r_id = t2.r_id;

-- HAVING

-- Q16 Find genres having avg score > avg score of all the movies
USE lecture;

SELECT genre,AVG(score) FROM movies
GROUP BY genre
HAVING AVG(score) > (SELECT AVG(score) FROM movies);

USE zomato;
-- INSERT


INSERT INTO loyal_users
(user_id,name) 
SELECT t1.user_id,name FROM orders t1
JOIN user t2
ON t1.user_id = t2.user_id
GROUP BY t1.user_id
HAVING COUNT(*) > 3;

-- UPDATE
UPDATE loyal_users m1
SET money = (SELECT SUM(amount)*0.1 FROM orders m2 
WHERE m1.user_id = m2.user_id
GROUP BY user_id );


-- DELETE
DELETE FROM  user
WHERE user_id NOT IN (SELECT DISTINCT(user_id) FROM orders)

 
