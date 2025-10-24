@echo off
chcp 65001

echo Создание базы данных...
sqlite3 movies_rating.db < db_init.sql

echo 1. Найти все пары пользователей, оценивших один и тот же фильм.
echo --------------------------------------------------
sqlite3 movies_rating.db "SELECT DISTINCT u1.name as user1, u2.name as user2, m.title as movie FROM ratings r1 JOIN ratings r2 ON r1.movie_id = r2.movie_id AND r1.user_id < r2.user_id JOIN users u1 ON r1.user_id = u1.id JOIN users u2 ON r2.user_id = u2.id JOIN movies m ON r1.movie_id = m.id ORDER BY m.title, u1.name, u2.name LIMIT 10;"
echo.

echo 2. Найти 10 самых старых оценок от разных пользователей.
echo --------------------------------------------------
sqlite3 movies_rating.db "SELECT DISTINCT m.title, u.name as user_name, r.rating, date(r.timestamp, 'unixepoch') as rating_date FROM ratings r JOIN movies m ON r.movie_id = m.id JOIN users u ON r.user_id = u.id ORDER BY r.timestamp ASC LIMIT 10;"
echo.

echo 3. Фильмы с максимальным и минимальным средним рейтингом.
echo --------------------------------------------------
sqlite3 movies_rating.db "WITH MovieRatings AS (SELECT m.id, m.title, m.year, AVG(r.rating) as avg_rating FROM movies m JOIN ratings r ON m.id = r.movie_id GROUP BY m.id, m.title, m.year), MaxMinRatings AS (SELECT MAX(avg_rating) as max_rating, MIN(avg_rating) as min_rating FROM MovieRatings) SELECT mr.title, mr.year, mr.avg_rating, CASE WHEN mr.avg_rating = (SELECT max_rating FROM MaxMinRatings) THEN 'Да' ELSE 'Нет' END as Рекомендуем FROM MovieRatings mr WHERE mr.avg_rating = (SELECT max_rating FROM MaxMinRatings) OR mr.avg_rating = (SELECT min_rating FROM MaxMinRatings) ORDER BY mr.year, mr.title;"
echo.

echo 4. Оценки пользователей-мужчин в период с 2011 по 2014 год.
echo --------------------------------------------------
sqlite3 movies_rating.db "SELECT COUNT(*) as ratings_count, ROUND(AVG(r.rating), 2) as avg_rating FROM ratings r JOIN users u ON r.user_id = u.id WHERE u.gender = 'M' AND strftime('%%Y', datetime(r.timestamp, 'unixepoch')) BETWEEN '2011' AND '2014';"
echo.

echo 5. Фильмы с указанием средней оценки и количества пользователей.
echo --------------------------------------------------
sqlite3 movies_rating.db "SELECT m.title, m.year, ROUND(AVG(r.rating), 2) as avg_rating, COUNT(DISTINCT r.user_id) as users_count FROM movies m JOIN ratings r ON m.id = r.movie_id GROUP BY m.id, m.title, m.year ORDER BY m.year, m.title LIMIT 10;"
echo.

echo 6. Самый распространенный жанр фильма.
echo --------------------------------------------------
sqlite3 movies_rating.db "WITH SplitGenres AS (WITH RECURSIVE split(genre, rest) AS (SELECT CASE WHEN instr(genres, '|') = 0 THEN genres ELSE substr(genres, 1, instr(genres, '|') - 1) END, CASE WHEN instr(genres, '|') = 0 THEN '' ELSE substr(genres, instr(genres, '|') + 1) END FROM movies UNION ALL SELECT CASE WHEN instr(rest, '|') = 0 THEN rest ELSE substr(rest, 1, instr(rest, '|') - 1) END, CASE WHEN instr(rest, '|') = 0 THEN '' ELSE substr(rest, instr(rest, '|') + 1) END FROM split WHERE rest != '') SELECT trim(genre) as genre FROM split WHERE genre != '') SELECT genre, COUNT(*) as movie_count FROM SplitGenres GROUP BY genre ORDER BY movie_count DESC LIMIT 1;"
echo.

echo 7. 10 последних зарегистрированных пользователей.
echo --------------------------------------------------
sqlite3 movies_rating.db "SELECT substr(name, instr(name, ' ') + 1) || ' ' || substr(name, 1, instr(name, ' ') - 1) || '|' || register_date as user_info FROM users ORDER BY register_date DESC LIMIT 10;"
echo.

echo 8. День рождения по годам.
echo --------------------------------------------------
sqlite3 movies_rating.db "WITH RECURSIVE BirthdayYears(year_num) AS (VALUES(2005) UNION ALL SELECT year_num + 1 FROM BirthdayYears WHERE year_num < 2024) SELECT year_num as year, case strftime('%%w', year_num || '-10-05') when '0' then 'Воскресенье' when '1' then 'Понедельник' when '2' then 'Вторник' when '3' then 'Среда' when '4' then 'Четверг' when '5' then 'Пятница' when '6' then 'Суббота' end as day_of_week FROM BirthdayYears ORDER BY year_num;"
echo.

echo Лабораторная работа 4 завершена!
pause