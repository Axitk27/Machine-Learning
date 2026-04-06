USE campusx;
SELECT * FROM flights;

-- View has been created

CREATE VIEW indigo AS
SELECT * FROM flights
WHERE Airline = 'Indigo';

CREATE VIEW zomato AS 
SELECT order_id,amount,r_name,name,date,delivery_time FROM orders t1
INNER JOIN users t2
ON t1.user_id = t2.user_id
INNER JOIN restaurants t3
ON t3.r_id = t1.r_id;

-- drop the indigo Views
DROP VIEW indigo;

-- Updating the table 
UPDATE flights
SET SOURCE = 'Indigo Airline'
WHERE SOURCE = 'Indigo';

CREATE VIEW indigo AS
SELECT * FROM flights
WHERE Airline = 'Indigo';

-- updating the Table view will be automatic updated

UPDATE flights
SET SOURCE = 'Bangloru'
WHERE SOURCE = 'Banglore';

SELECT * FROM flights;

-- Updating the views

UPDATE indigo
SET SOURCE = 'New Delhi'
WHERE SOURCE = 'Delhi';

-- User defined function 

-- no of times function will be executed
SELECT hello_world() FROM users;

-- age calculation 
SELECT name,age_calculation(dob) FROM person;

-- greetings
-- Mr for male 
-- Mrs female unmaried
-- Ms Female maried

SELECT *,proper_name(name,gender,maried) FROM person;


-- Flight between two Cities

SELECT flights_between('Mumbai','New Delhi')