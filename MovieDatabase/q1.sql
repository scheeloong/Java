SET search_path TO imdb;

-- Query 1 statements

-- Get all the movies Brad Pitt is an actor 
CREATE VIEW MovieBP AS
SELECT m.movie_id as movie_id
FROM Movies m, People p, Roles r
WHERE p.person_id = r.person_id and m.movie_id = r.movie_id and p.name = 'Pitt, Brad';

-- Group the writers and composers as coworkers
CREATE VIEW Coworker AS
SELECT * 
FROM Writers 
UNION
SELECT * 
FROM Composers; 

CREATE VIEW Answer AS
SELECT p.name as name, count(c.movie_id) as bradtimes
FROM MovieBP m, Coworker c, people p
WHERE m.movie_id = c.movie_id  and p.person_id = c.person_id
GROUP BY p.name
ORDER BY p.name ASC;



------------------------------------
-- Testing output and to be removed
SELECT * 
--FROM MovieBP; 
--FROM Coworker;
FROM Answer;  
-------------------------------------

DROP VIEW Answer CASCADE; 
DROP VIEW Coworker CASCADE; 
DROP VIEW MovieBP CASCADE; 

