SET search_path TO imdb;

-- Query 3 statements

-- Group all actor, cinematographer, composer, director, writer as DistinctPeople
-- Note: Different position is the same person 
CREATE VIEW DistinctPeople AS
SELECT movie_id, person_id
FROM Roles 
UNION
SELECT * 
FROM Cinematographers
UNION
SELECT * 
FROM  Composers
UNION 
SELECT * 
FROM Directors
UNION 
SELECT * 
FROM Writers; 

-- Count NumPeople for each movie
CREATE VIEW NumPeople AS
SELECT d.movie_id as movie_id, count(d.person_id) as people
From DistinctPeople d
GROUP BY d.movie_id
ORDER BY people DESC, movie_id ASC; 


-- Now need find total number of positions for the movie 
CREATE VIEW DistinctPosition AS
SELECT movie_id, person_id
FROM Roles 
UNION ALL
SELECT * 
FROM Cinematographers
UNION ALL
SELECT * 
FROM  Composers
UNION ALL
SELECT * 
FROM Directors
UNION ALL
SELECT * 
FROM Writers; 

-- Count NumPosition for each movie
CREATE VIEW NumPosition AS
SELECT d.movie_id as movie_id, count(d.person_id) as positions
From DistinctPosition d
GROUP BY d.movie_id
ORDER BY positions DESC, movie_id ASC; 

-- Now output the answer

CREATE VIEW Answer AS
SELECT n1.movie_id as movie_id, n2.positions as positions, n1.people as people
FROM NumPeople n1, NumPosition n2
WHERE n1.movie_id = n2.movie_id
ORDER BY positions DESC, people DESC, n1.movie_id ASC; 

------------------------------------
-- Testing output and to be removed
SELECT * 
--FROM DistinctPeople; 
--FROM NumPeople; 
--FROM DistinctPosition; 
--FROM NumPosition; 
FROM Answer;  
-------------------------------------

DROP VIEW Answer CASCADE;
DROP VIEW NumPosition CASCADE; 
DROP VIEW DistinctPosition CASCADE; 
DROP VIEW NumPeople CASCADE; 
DROP VIEW DistinctPeople CASCADE; 


