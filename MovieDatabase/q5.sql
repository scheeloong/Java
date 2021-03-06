SET search_path TO imdb;

-- Query 5 statements


-- First, get movies and the year for each role 
CREATE VIEW RoleYears AS
SELECT r.movie_id AS movie_id, r.person_id AS person_id, m.title AS title, m.year AS year
FROM Roles r, Movies m
WHERE r.movie_id = m.movie_id; 

-- Now, get all the movies that are not maximum  in alphabetical order for same year

CREATE VIEW NotMin AS
SELECT r1.movie_id AS movie_id, r1.person_id AS person_id, r1.title AS title, r1.year AS year
FROM RoleYears r1, RoleYears r2
WHERE r1.person_id = r2.person_id and r1.year = r2.year and r1.title > r2.title; 

-- Now, only keep movies that are first in alphabetical order for the same person same year 


CREATE VIEW OnlyMin AS
SELECT * FROM RoleYears
EXCEPT 
SELECT * FROM NotMin; 

CREATE VIEW OnlyMinOrder AS
SELECT * 
FROM OnlyMin
ORDER By person_id ASC, year ASC; 

-- only output the different values 
CREATE VIEW OnlyMinRelevant AS
SELECT DISTINCT o.title AS title, o.year AS year  , o.movie_id as movie_id  
FROM OnlyMin o; 

CREATE VIEW ShouldHaveOneBefore AS
SELECT o.person_id AS person_id, o.year-1 AS year
FROM OnlyMinOrder o; 

-- Eliminate those who don't have the year of one before 

CREATE VIEW NoHaveOneBefore AS
SELECT * 
FROM ShouldHaveOneBefore 
EXCEPT 
SELECT o.person_id AS person_id, o.year AS year
FROM OnlyMinOrder o; 

-- Now, only keep those who have one year before
-- note: Need add back 1 to remove those from the years without 1 before

CREATE VIEW HaveOneBefore AS
SELECT o.person_id AS person_id, o.year AS year
FROM OnlyMinOrder o
EXCEPT
SELECT n.person_id AS person_id, n.year+1 AS year
FROM NoHaveOneBefore n; 

-- Similarly, check for 2 years before 

CREATE VIEW ShouldHaveTwoBefore AS
SELECT h.person_id AS person_id, h.year-2 AS year
FROM HaveOneBefore h; 

-- Eliminate those who don't have the year of two before 
-- note: Need deduct from original set 

CREATE VIEW NoHaveTwoBefore AS
SELECT * 
FROM ShouldHaveTwoBefore 
EXCEPT 
SELECT o.person_id AS person_id, o.year AS year
FROM OnlyMinOrder o; 

-- Now, only keep those who have two year before
-- note: Need add back 2 cause taken from updated list 
CREATE VIEW HaveTwoBefore AS
SELECT h.person_id AS person_id, h.year AS year
FROM HaveOneBefore h
EXCEPT
SELECT n.person_id AS person_id, n.year+2 AS year
FROM NoHaveTwoBefore n; 


-- Here, have gotten all person_id that satisfies 3 consecutive years
-- Now, need to only keep the highest year from all combination of 3 consecutive years for each person 

CREATE VIEW NotHighestYear AS
SELECT h1.person_id AS person_id, h1.year AS year 
FROM HaveTwoBefore h1, HaveTwoBefore h2
WHERE h1.person_id = h2.person_id and h1.year < h2.year; 


-- Now, only keep each actor with their highest year 

CREATE VIEW HighestYear AS
SELECT * FROM HaveTwoBefore
EXCEPT 
SELECT * FROM NotHighestYear;

-- now, start collecting the latest 3 movies of remaining actors and year and concatenate them 
-- Note: get from only min and not movies to be able to make sure select lower alphabetical if same year 
CREATE VIEW Answer AS
SELECT DISTINCT h.person_id AS person_id, p.name AS name, h.year-2 AS year1, m3.title as movie1, h.year-1 AS year2, m2.title AS movie2, h.year as year3, m.title as movie3
FROM HighestYear h, People p, OnlyMinRelevant m, Roles r1, OnlyMinRelevant m2, Roles r2, OnlyMinRelevant m3, Roles r3
WHERE h.person_id = p.person_id AND r1.person_id = h.person_id AND r1.movie_id = m.movie_id AND h.year = m.year
AND r2.person_id = h.person_id AND r2.movie_id = m2.movie_id AND h.year-1 = m2.year
AND r3.person_id = h.person_id AND r3.movie_id = m3.movie_id AND h.year-2 = m3.year
ORDER BY person_id ASC;  

------------------------------------
-- Testing output and to be removed
SELECT * 
--FROM RoleYears; 
--FROM NotMin;
--FROM OnlyMin; 
--FROM OnlyMinOrder;
--FROM ShouldHaveOneBefore;  
--FROM NoHaveOneBefore; 
--FROM HaveOneBefore; 
--FROM ShouldHaveTwoBefore; 
--FROM NoHaveTwoBefore; 
--FROM HaveTwoBefore;
--FROM NotHighestYear;
--FROM HighestYear;
FROM Answer; 
------------------------------------

DROP VIEW Answer CASCADE;
DROP VIEW HighestYear CASCADE; 
DROP VIEW NotHighestYear CASCADE; 
DROP VIEW HaveTwoBefore CASCADE; 
DROP VIEW NoHaveTwoBefore CASCADE; 
DROP VIEW ShouldHaveTwoBefore CASCADE; 
DROP VIEW HaveOneBefore CASCADE; 
DROP VIEW NoHaveOneBefore CASCADE; 
DROP VIEW ShouldHaveOneBefore CASCADE; 
DROP VIEW OnlyMinRelevant CASCADE; 
DROP VIEW OnlyMinOrder CASCADE; 
DROP VIEW OnlyMin CASCADE; 
DROP VIEW NotMin CASCADE; 
DROP VIEW RoleYears CASCADE; 

