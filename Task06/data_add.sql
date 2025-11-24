INSERT OR IGNORE INTO users (name, email, gender, register_date, occupation_id)
VALUES
('Данькин Иван Батькович', 'vania@gmail.com', 'male', date('now'),
 (SELECT id FROM occupations ORDER BY id LIMIT 1)),
('Ермаков Егор Александрович', 'ermakov@gmail.com', 'male', date('now'),
 (SELECT id FROM occupations ORDER BY id LIMIT 1)),
('Кармазов Никита Александрович', 'yabuzova@gmail.com', 'male', date('now'),
 (SELECT id FROM occupations ORDER BY id LIMIT 1)),
('Китаев Евгений Витальевич', 'evgeni@gmail.com', 'male', date('now'),
 (SELECT id FROM occupations ORDER BY id LIMIT 1)),
('Копеин Александр Сергеевич', 'nosasa@gmail.com', 'male', date('now'),
 (SELECT id FROM occupations ORDER BY id LIMIT 1));


INSERT OR IGNORE INTO movies (title, year)
VALUES
('Джентльмены удачи (1971)', 1971),
('Бриллиантовая рука (1969)', 1969),
('Операция Ы и другие приключения Шурика (1965)', 1965);


INSERT OR IGNORE INTO genres (name) VALUES ('Comedy');
INSERT OR IGNORE INTO genres (name) VALUES ('Crime');
INSERT OR IGNORE INTO genres (name) VALUES ('Adventure');


INSERT OR IGNORE INTO movie_genres (movie_id, genre_id)
SELECT m.id, g.id FROM movies m JOIN genres g ON g.name = 'Comedy'
WHERE m.title = 'Джентльмены удачи (1971)';

INSERT OR IGNORE INTO movie_genres (movie_id, genre_id)
SELECT m.id, g.id FROM movies m JOIN genres g ON g.name = 'Crime'
WHERE m.title = 'Бриллиантовая рука (1969)';

INSERT OR IGNORE INTO movie_genres (movie_id, genre_id)
SELECT m.id, g.id FROM movies m JOIN genres g ON g.name = 'Adventure'
WHERE m.title = 'Операция Ы и другие приключения Шурика (1965)';


INSERT INTO ratings (user_id, movie_id, rating, timestamp)
SELECT u.id, m.id, 5.0, strftime('%s','now')
FROM users u JOIN movies m ON m.title = 'Джентльмены удачи (1971)'
WHERE u.email = 'yabuzova@gmail.com'
AND NOT EXISTS (
    SELECT 1 FROM ratings r WHERE r.user_id = u.id AND r.movie_id = m.id
);

INSERT INTO ratings (user_id, movie_id, rating, timestamp)
SELECT u.id, m.id, 4.9, strftime('%s','now')
FROM users u JOIN movies m ON m.title = 'Бриллиантовая рука (1969)'
WHERE u.email = 'yabuzova@gmail.com'
AND NOT EXISTS (
    SELECT 1 FROM ratings r WHERE r.user_id = u.id AND r.movie_id = m.id
);

INSERT INTO ratings (user_id, movie_id, rating, timestamp)
SELECT u.id, m.id, 4.8, strftime('%s','now')
FROM users u JOIN movies m ON m.title = 'Операция Ы и другие приключения Шурика (1965)'
WHERE u.email = 'yabuzova@gmail.com'
AND NOT EXISTS (
    SELECT 1 FROM ratings r WHERE r.user_id = u.id AND r.movie_id = m.id
);
