
DROP TABLE IF EXISTS ratings;
DROP TABLE IF EXISTS tags;
DROP TABLE IF EXISTS movies;
DROP TABLE IF EXISTS users;

CREATE TABLE movies (
    id INTEGER PRIMARY KEY,
    title TEXT NOT NULL,
    year INTEGER,
    genres TEXT
);

CREATE TABLE ratings (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    user_id INTEGER NOT NULL,
    movie_id INTEGER NOT NULL,
    rating REAL NOT NULL,
    timestamp INTEGER NOT NULL
);

CREATE TABLE tags (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    user_id INTEGER NOT NULL,
    movie_id INTEGER NOT NULL,
    tag TEXT NOT NULL,
    timestamp INTEGER NOT NULL
);

CREATE TABLE users (
    id INTEGER PRIMARY KEY,
    name TEXT NOT NULL,
    email TEXT,
    gender TEXT,
    register_date TEXT,
    occupation TEXT
);

-- Вставляем тестовые данные для работы
INSERT INTO movies (id, title, year, genres) VALUES
(1, 'The Shawshank Redemption', 1994, 'Drama'),
(2, 'The Godfather', 1972, 'Crime|Drama'),
(3, 'The Dark Knight', 2008, 'Action|Crime|Drama'),
(4, 'Pulp Fiction', 1994, 'Crime|Drama'),
(5, 'Forrest Gump', 1994, 'Drama|Romance'),
(6, 'Inception', 2010, 'Action|Adventure|Sci-Fi'),
(7, 'The Matrix', 1999, 'Action|Sci-Fi'),
(8, 'Goodfellas', 1990, 'Biography|Crime|Drama'),
(9, 'The Silence of the Lambs', 1991, 'Crime|Drama|Thriller'),
(10, 'La La Land', 2016, 'Drama|Music|Romance');

INSERT INTO users (id, name, email, gender, register_date, occupation) VALUES
(1, 'John Anderson', 'john@email.com', 'M', '2020-01-15', 'engineer'),
(2, 'Alice Adams', 'alice@email.com', 'F', '2020-03-20', 'student'),
(3, 'Michael Armstrong', 'mike@email.com', 'M', '2019-12-10', 'teacher'),
(4, 'Sarah Allen', 'sarah@email.com', 'F', '2021-02-05', 'doctor'),
(5, 'Robert Adams', 'rob@email.com', 'M', '2020-06-18', 'artist');

INSERT INTO ratings (user_id, movie_id, rating, timestamp) VALUES
(1, 1, 4.5, 1609459200),
(2, 1, 5.0, 1609545600),
(3, 2, 4.0, 1609632000),
(4, 3, 4.8, 1609718400),
(5, 1, 3.5, 1609804800),
(1, 3, 4.2, 1609891200),
(2, 5, 4.9, 1609977600);

INSERT INTO tags (user_id, movie_id, tag, timestamp) VALUES
(1, 1, 'classic', 1609459200),
(2, 1, 'prison', 1609545600),
(3, 2, 'mafia', 1609632000),
(4, 3, 'superhero', 1609718400);