SET search_path TO imdb;

-- Query 7 statements


-- Get the pid of person 'Shyamalan, M. Night'
CREATE TABLE ShyPid AS
SELECT p.person_id as person_id
FROM people p
WHERE p.name = 'Shyamalan, M. Night'; -- note: Doesn't exist in the example given 

-- Get all the movies Shyamalan, M, Night is a roles, cinematographers, composers, diretors, writers
CREATE TABLE MovieShy AS
SELECT r.movie_id as movie_id
FROM Roles r, ShyPid s
WHERE r.person_id = s.person_id
UNION
SELECT c.movie_id as movie_id
FROM Cinematographers c, ShyPid s
WHERE c.person_id = s.person_id
UNION
SELECT c.movie_id as movie_id
FROM Composers c, ShyPid s
WHERE c.person_id = s.person_id
UNION
SELECT d.movie_id as movie_id
FROM Directors d, ShyPid s
WHERE d.person_id = s.person_id
UNION 
SELECT w.movie_id as movie_id
FROM Writers w, ShyPid s
WHERE w.person_id = s.person_id;

-- Now, get all Pid of those associated including 'Shy' himself  since using tables 
CREATE TABLE AssociatedPid AS
SELECT r.person_id
FROM Roles r, MovieShy m
WHERE r.movie_id = m.movie_id 
UNION 
SELECT c.person_id
FROM Cinematographers c, MovieShy m
WHERE c.movie_id = m.movie_id 
UNION 
SELECT c.person_id
FROM Composers c, MovieShy m
WHERE c.movie_id = m.movie_id
UNION 
SELECT d.person_id
FROM Directors d, MovieShy m
WHERE d.movie_id = m.movie_id
UNION 
SELECT w.person_id
FROM Writers w, MovieShy m
WHERE w.movie_id = m.movie_id;


-- Now, start deleting using person_id from: 
-- 1. Roles
-- 2. Cinematographers
-- 3. Composers
-- 4. Directors
-- 5. Writers

DELETE FROM Roles
WHERE Roles.person_id IN (SELECT * FROM AssociatedPid); 

DELETE FROM Cinematographers
WHERE Cinematographers.person_id IN (SELECT * FROM AssociatedPid);

DELETE FROM Composers
WHERE Composers.person_id IN (SELECT * FROM AssociatedPid);

DELETE FROM Directors
WHERE Directors.person_id IN (SELECT * FROM AssociatedPid);

DELETE FROM Writers
WHERE Writers.person_id IN (SELECT * FROM AssociatedPid);

-- Now, delete using movie_id from: 
-- 1. Roles 
-- 2. Cinematographers
-- 3. Composers 
-- 4. Directors 
-- 5. Writers
-- 6. Movie_genres
-- 7. Movie_keywords

DELETE FROM Roles
WHERE Roles.movie_id IN (SELECT * FROM MovieShy); 

DELETE FROM Cinematographers
WHERE Cinematographers.movie_id IN (SELECT * FROM MovieShy);

DELETE FROM Composers
WHERE Composers.movie_id IN (SELECT * FROM MovieShy);

DELETE FROM Directors
WHERE Directors.movie_id IN (SELECT * FROM MovieShy);

DELETE FROM Writers
WHERE Writers.movie_id IN (SELECT * FROM MovieShy);

DELETE FROM Movie_genres
WHERE Movie_genres.movie_id IN (SELECT * FROM MovieShy);

DELETE FROM Movie_keywords
WHERE Movie_keywords.movie_id IN (SELECT * FROM MovieShy);


-- Now, delete from People 
-- 1. People -- note: Delete all People excluding 'Shy' himself to not get rid of the MID from Views
-- note: Delete people last to prevent violating reference constraint  

DELETE FROM People
WHERE People.person_id IN (SELECT * FROM AssociatedPid);

-- Now, delete all MID 
-- 1. Movies  
-- note: Delete movies last to prevent violating reference constraint 
-- note: Can delete all MID cause PID from 'Shy' doesn't depend on it 

DELETE FROM Movies
WHERE Movies.movie_id IN (SELECT * FROM MovieShy);

-- Finally, delete PID of 'Shy' himself 
-- 1. People 
DELETE FROM People
WHERE People.person_id IN (SELECT * FROM ShyPid);

------------------------------------
-- Testing output and to be removed
--SELECT * 
--FROM ShyPid; 
--FROM MovieShy; 
--FROM AssociatedPid; 
-------------------------------------

--DROP VIEW Answer CASCADE; 
DROP TABLE AssociatedPid CASCADE; 
DROP TABLE MovieShy CASCADE; 
DROP TABLE ShyPid CASCADE; 

