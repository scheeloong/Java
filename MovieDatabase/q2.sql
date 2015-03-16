
SET search_path TO imdb;

-- Query 2 statements

-- Get number of keywords for each movie 
CREATE VIEW NumKey AS
SELECT m.movie_id as movie_id, count(m.keyword_id) as keywords
FROM movie_keywords m
GROUP BY m.movie_id;  


-- Get ratings 
CREATE VIEW Rating AS
SELECT n.movie_id as movie_id, n.keywords as keywords, m.rating as rating
FROM NumKey n, movies m
WHERE n.movie_id = m.movie_id;

CREATE VIEW Answer AS
Select r.keywords as keywords , avg(r.rating) as avgrating
FROM Rating r
GROUP BY r.keywords
ORDER BY r.keywords ASC;


------------------------------------
-- Testing output and to be removed
SELECT * 
--FROM NumKey; 
--FROM Rating; 
FROM Answer; 
-------------------------------------

DROP VIEW Answer CASCADE;
DROP VIEW Rating CASCADE; 
DROP VIEW NumKey CASCADE; 

