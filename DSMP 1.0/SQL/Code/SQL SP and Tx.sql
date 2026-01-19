USE campusx;
-- Procedure call
-- Stored Procedure
-- Writting multiple SQL statement in a multiple order and executed one by one 

-- Function and stored procedure are total different
-- SQL Simple Code < SQL Function < SQL Stored Procedure 

CALL hello_world();

SET @message = '';

CALL add_user('axit','axit@gmail.com',@message);
CALL add_user('Jimmy','jimmy@gmail.com',@message);
CALL add_user('kj','kj@gmail.com',@message);
CALL add_user('pj','pj@gmail.com',@message);
SELECT @message;

CALL user_order('pj@gmail.com');
SET @total = 0;
CALL place_order(3,3,'6,7',@total);
SELECT @total;

-- Why to use stored procedure
-- Improve Performance
-- Enhanced Security
-- Encapusulation of Business Logic
-- Consistency
-- Reduced Network Traffic
-- It is used for Report generation as well

-- What is the difference between SET and DECLARE
-- SET is in SQL Environment -- SET @total = 0 -- Parameter decleration and assignment
-- DECLARE is in a Function and Stored Procedure Environment -- DECLARE total INTEGER -- created total parameter


-- Transaction 
-- Sequence of operation that are performed as a singe logical unit of a work in DBMS 
-- Transaction may consist one or more operation 
-- It is only for write operation(CUD) not for a read operation(R)(SELECT) 
-- There is a all or none concept. If one of the SQL statement failed to execute then all of the result will be roll out

-- Three main command
-- Commit, Rollback, Savepoint


SET autocommit = 0; -- will update the autocommit to 0 now you need to update the database manually

-- start transaction means autocommit is 0 
START TRANSACTION;
UPDATE person SET maried = 'Y' WHERE name = 'axit'; 
UPDATE person SET maried = 'N' WHERE name1 = 'jago'; 

-- commit the transaction
COMMIT;

-- Rollback


-- start transaction means autocommit is 0 
START TRANSACTION;
UPDATE person SET maried = 'Y' WHERE name = 'axit'; 
UPDATE person SET maried = 'N' WHERE name1 = 'jago'; 

-- rollback the transaction
ROLLBACK;

-- Rollback with savepoint

START TRANSACTION;
SAVEPOINT A;
UPDATE person SET maried = 'N' WHERE name = 'axit'; 
SAVEPOINT B;
UPDATE person SET maried1 = 'N' WHERE name = 'jago'; 

ROLLBACK TO B;


-- ROllback and Commit

START TRANSACTION;
UPDATE person SET maried = 'N' WHERE name = 'axit'; 
COMMIT;
UPDATE person SET maried = 'N' WHERE name = 'jago'; 
ROLLBACK;

-- with ACID Properties
-- Book - Database System Concept

-- Atomocity - it is treated as a single indivisible unit 
-- Consistency - transaction takes one dataset from valid state to another dataset to valid state
-- Isolation - Multiple transaction can be done at a same time
-- Durability - Commited data stay forever in the database so in case of main database failure you can have still the backup of your database
