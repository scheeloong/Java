SET search_path TO imdb;

-- Query 6 statements

-- Get all movies before 1990
CREATE VIEW OldMovie AS
SELECT *
FROM Movies m
WHERE m.year < 1990; 

-- Get maximum mID for original table 
CREATE VIEW MaxMid AS
SELECT max(m1.movie_id) as movie_id
FROM Movies m1;


--CREATE TABLE MaxMidTemp AS 
--SELECT max(m1.movie_id) as movie_id
--FROM Movies m1;  

-- Create the new table with new mID
CREATE VIEW SequelMovie AS
SELECT o.movie_id + m.movie_id as movie_id, o.title||': The Sequel' as title, 2020 as year, o.rating as rating
FROM OldMovie o, MaxMid m; 

INSERT INTO Movies (SELECT * FROM SequelMovie);


------------------------------------
-- Testing output and to be removed
SELECT * 
--FROM OldMovie; 
--FROM MaxMid;
FROM Movies;  
-------------------------------------

-- Note: You cannot delete from Views without creating a new table 
-- because the views will be updated as soon as the Table itself is updated!! 

-- Cannot delete in this file! since autotester depends on it 
--DELETE FROM Movies 
--WHERE Movies.movie_id > (SELECT MaxMidTemp.movie_id as movie_id FROM MaxMidTemp); 

--DROP TABLE MaxMidTemp; -- remove the table itself 

--DROP VIEW Answer CASCADE;
DROP VIEW SequelMovie CASCADE; 
DROP VIEW MaxMid CASCADE; 
DROP VIEW OldMovie CASCADE; 
