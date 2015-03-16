SET search_path TO imdb;

INSERT INTO movies VALUES
	(2, 'Fight Club', 1999, 8.9),
	(1, 'Taxi Driver', 1976, 8.4),
	(3, 'The Curious Case of Benjamin Button', 2008, 7.8),
	(4, 'No Country for Old Men', 2007, 8.1),
	(5, 'Goya''s Ghosts', 2006, 6.9),
	(6, 'Vicky Cristina Barcelona', 2008, 7.2);

---

INSERT INTO people VALUES
	(1, 'Pitt, Brad'),
	(2, 'Norton, Edward'),
	(3, 'Fincher, David'),
	(4, 'Uhls, Jim'),
	(5, 'Hanke, P.J.'),
	(6, 'Cronenweth, Jeff'),
	(7, 'De Niro, Robert'),
	(8, 'Scorsese, Martin'),
	(9, 'Schrader, Paul'),
	(10, 'Herrmann, Bernard'),
	(11, 'Chapman, Michael'),
	(12, 'Blanchett, Cate'),
	(13, 'Roth, Eric'),
	(14, 'Desplat, Alexandre'),
	(15, 'Miranda, Claudio'),
	(16, 'Foster, Jodie'),
	(17, 'Jones, Tommy Lee'),
	(18, 'Bardem, Javier'),
	(19, 'Coen, Joel'),
	(20, 'Coen, Ethan'),
	(21, 'Burwell, Carter'),
	(22, 'Deakins, Roger'),
	(23, 'Portman, Natalie'),
	(24, 'Forman, Milos'),
	(25, 'Carrière, Jean-Claude'),
	(26, 'Bauer, Varhan'),
	(27, 'Aguirresarobe, Javier'),
	(28, 'Johansson, Scarlett'),
	(29, 'Cruz, Penelope'),
	(30, 'Allen, Woody'),
	(31, 'Hall, Rebecca'),
	(32, 'Navarro, Inigo');



INSERT INTO cinematographers VALUES
	(2, 6),
	(1, 11),
	(3, 15),
	(4, 22),
	(5, 27),
	(6, 27);

INSERT INTO composers VALUES
	(2, 5),
	(1, 10),
	(3, 14),
	(4, 21),
	(5, 26),
	(6, 32);

INSERT INTO directors VALUES
	(2, 3),
	(1, 8),
	(3, 3),
	(4, 19),
	(5, 24),
	(6, 30);

INSERT INTO roles VALUES
	(1, 2, 'Tyler Durden'),
	(2, 2, 'The Narrator'),
	(7, 1, 'Travis Bickle'),
	(16, 1, 'Iris'),
	(1, 3, 'Benjamin Button'),
	(12, 3, 'Daisy'),
	(17, 4, 'Ed Tom Bell'),
	(18, 4, 'Anton Chigurh'),
	(18, 5, 'Lorenzo'),
	(24, 5, 'Alicia'),
	(18, 6, 'Juan Antonio'),
	(28, 6, 'Cristina'),
	(29, 6, 'Maria Elena');


INSERT INTO writers VALUES
	(2, 4),
	(1, 9),
	(3, 13),
	(4, 20),
	(5, 25),
	(6, 31);

---

INSERT INTO genres VALUES
	(1, 'Drama'),
	(2, 'Crime'),
	(3, 'Fantasy'),
	(4, 'Romance'),
	(5, 'Thriller'),
	(6, 'Biography'),
	(7, 'History');

INSERT INTO movie_genres VALUES
	(2, 1),
	(1, 1),
	(1, 2),
	(3, 1),
	(3, 3),
	(3, 4),
	(4, 1),
	(4, 2),
	(4, 5),
	(5, 1),
	(5, 6),
	(5, 7),
	(6, 1),
	(6, 4);

INSERT INTO keywords VALUES
	(1, 'vigilante'),
	(2, 'alienation'),
	(3, 'loner'),
	(4, 'surprise ending'),
	(5, 'fighting'),
	(6, 'aging'),
	(7, 'ransom'),
	(8, 'coin toss'),
	(9, 'muse'),
	(10, 'painter'),
	(11, 'summer'),
	(12, 'artist');

INSERT INTO movie_keywords VALUES
	(2, 4),
	(2, 5),
	(2, 2),
	(1, 1),
	(1, 2),
	(1, 3),
	(3, 6),
	(4, 8),
	(5, 9),
	(5, 10),
	(5, 12),
	(6, 10),
	(6, 11),
	(6, 12);
