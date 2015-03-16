SET search_path TO imdb;

-- Query 4 statements

-- Update year to Decades as int 
CREATE VIEW UpdatedYear AS
SELECT movie_id, title, (year/10)*10 as year, rating
FROM Movies; 

-- Append 's' to the decades 
CREATE VIEW Decades AS
SELECT movie_id, title, CAST(year AS VARCHAR(4))||'s' AS decade, rating
From UpdatedYear; 

-- Truncate to only supermovies 
CREATE VIEW SuperOnly AS
SELECT d.movie_id AS movie_id, d.title AS title, d.rating AS rating, d.decade AS decade 
FROM Decades d
WHERE  d.rating >= ALL (SELECT d2.rating FROM Decades d2 WHERE d2.decade = d.decade); 

-- Now, need get writers who writes for at least 1 super movie 
-- and all that writers work are for super movies only 


-- Get writers who writes at least 1 super movie 
CREATE VIEW AtLeastWriter AS
SELECT w.movie_id as movie_id, w.person_id as person_id
FROM Writers w, SuperOnly s
WHERE w.movie_id = s.movie_id; 

-- Get all the movie writer combination that writers should have contain
CREATE VIEW ShouldHave AS
SELECT *
FROM (SELECT movie_id FROM SuperOnly) AS T1
CROSS JOIN 
(SELECT person_id FROM AtLeastWriter) AS T2; 


-- Find only all writers who do not satisfy the condition whereby
-- that writer's written work must all be supermovies
CREATE VIEW BadWriter AS
SELECT * FROM AtLeastWriter 
EXCEPT
SELECT * FROM ShouldHave; 

CREATE VIEW EligibleWriter AS
SELECT * FROM AtLeastWriter
EXCEPT
SELECT * FROM BadWriter; 

CREATE VIEW Answer AS
SELECT p.name as writer, s.title as supermovie, s.rating as rating, s.decade as decade
FROM EligibleWriter w, SuperOnly s, People p
WHERE w.movie_id = s.movie_id and w.person_id = p.person_id
ORDER BY writer ASC, decade ASC, supermovie ASC; 

------------------------------------
-- Testing output and to be removed
SELECT * 
--FROM UpdatedYear;
--FROM Decades;  
--FROM SuperOnly; 
--FROM AtLeastWriter; 
--FROM ShouldHave; 
--FROM BadWriter; 
--FROM EligibleWriter; 
FROM Answer; 
-------------------------------------

DROP VIEW Answer CASCADE;
DROP VIEW EligibleWriter CASCADE; 
DROP VIEW BadWriter CASCADE; 
DROP VIEW ShouldHave CASCADE; 
DROP VIEW AtLeastWriter CASCADE; 
DROP VIEW SuperOnly CASCADE; 
DROP VIEW Decades CASCADE; 
DROP VIEW UpdatedYear CASCADE; 

