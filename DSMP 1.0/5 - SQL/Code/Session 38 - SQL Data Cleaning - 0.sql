USE lecture;
-- Wildcards 
-- (1) _ Underscore
SELECT name FROM movies
WHERE name LIKE 'A_____';

-- (2) % Percent

SELECT * FROM movies
WHERE name LIKE '%Woman';

-- Upper Function

SELECT name,UPPER(name),LOWER(name)
FROM movies;

-- Concate and Concat WS

SELECT CONCAT(name,' ',director,' ') FROM movies;
SELECT CONCAT_WS('@',name,director) FROM movies;

-- Substring 

SELECT name,SUBSTR(name,1,5) FROM movies; 
SELECT name,SUBSTR(name,5) FROM movies; 
SELECT name,SUBSTR(name,5,5) FROM movies; 
SELECT name,SUBSTR(name,-5) FROM movies; 
SELECT name,SUBSTR(name,-6,1) FROM movies; 

-- replace

SELECT REPLACE("Hello World",'World','India');
SELECT REPLACE(name,'Man','woman') FROM movies;

-- reverse 

SELECT REVERSE("HELLO");
-- Finding the movie name which are palindrom
SELECT name FROM movies
WHERE name = REVERSE(name);

-- char_length length
-- char_length = return the length of character
-- length = return the length of the string in byte

SELECT name  FROM movies
WHERE LENGTH(name)!= CHAR_LENGTH(name);
-- SELECT name,CHAR_LENGTH(name) FROM movie- 

-- Insert

SELECT INSERT("Hello",5,0,'World') ;

-- left and right 

SELECT name,LEFT(name,3) FROM movies;
SELECT name,RIGHT(name,3) FROM movies;

-- repeat

-- Multiple of the string three times
SELECT repeat(name,3) FROM movies;

-- trim

-- leadingg and trailing space would be removed 
SELECT trim("    ASXIT     ");
SELECT TRIM(BOTH"." FROM '...............in...............') ;
SELECT TRIM(LEADING"." FROM '...............in...............') ;
SELECT TRIM(TRAILING"." FROM '...............in...............') ;

-- LTRIM AND RTRIM

SELECT LTRIM('      AXIT         ') ;
SELECT RTRIM('      AXIT         ') ;

-- substring_index(split function)

SELECT SUBSTRING_INDEX('www.campusx.com','.',1) ;-- From front
SELECT SUBSTRING_INDEX('www.campusx.com','.',-2) ;-- From front

-- strcmp

-- it indicate the relation between two string

-- str1>str2 negative
-- str1=str2 zero
-- str1<str2 positive

SELECT STRCMP("DELHI","MUMBAI");
SELECT STRCMP("MUMBAI",'DELHI');
SELECT STRCMP('DELHI','DELHI');

-- Locate function
-- start at the 1
SELECT LOCATE("H","HELLO");

-- start at the 4
SELECT LOCATE("H","HELLO",4);

-- LPAD and RPAD

SELECT LPAD('816621872817218',18,'+91'); 
SELECT RPAD('816621872817218',18,'+91'); 