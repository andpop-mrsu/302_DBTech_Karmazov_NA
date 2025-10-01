@echo off
chcp 65001

echo Проверка установки SQLite3...
sqlite3 --version
if errorlevel 1 (
    echo ОШИБКА: SQLite3 не установлен или не добавлен в PATH
    echo Скачайте с: https://sqlite.org/download.html
    pause
    exit /b 1
)

echo Создание базы данных...
sqlite3 movies_rating.db < db_init.sql

echo 1. Фильмы с оценками:
echo --------------------------------------------------
sqlite3 movies_rating.db "SELECT DISTINCT m.title, m.year FROM movies m JOIN ratings r ON m.id = r.movie_id ORDER BY m.year, m.title LIMIT 10;"
echo.

echo 2. Пользователи с фамилией на A:
echo --------------------------------------------------
sqlite3 movies_rating.db "SELECT id, name, register_date FROM users WHERE SUBSTR(name, INSTR(name, ' ') + 1) LIKE 'A%%' ORDER BY register_date LIMIT 5;"
echo.

echo 3. Информация о рейтингах:
echo --------------------------------------------------
sqlite3 movies_rating.db "SELECT u.name, m.title, m.year, r.rating, datetime(r.timestamp, 'unixepoch') as date FROM ratings r JOIN users u ON r.user_id = u.id JOIN movies m ON r.movie_id = m.id ORDER BY u.name, m.title, r.rating LIMIT 10;"
echo.

echo 4. Фильмы с тегами:
echo --------------------------------------------------
sqlite3 movies_rating.db "SELECT m.title, m.year, t.tag, u.name FROM movies m JOIN tags t ON m.id = t.movie_id JOIN users u ON t.user_id = u.id ORDER BY m.year, m.title, t.tag LIMIT 10;"
echo.

echo 5. Самые свежие фильмы:
echo --------------------------------------------------
sqlite3 movies_rating.db "SELECT title, year FROM movies WHERE year = (SELECT MAX(year) FROM movies) ORDER BY title;"
echo.

echo 6. Драмы после 2005 для женщин:
echo --------------------------------------------------
sqlite3 movies_rating.db "SELECT m.title, m.year, COUNT(*) as count FROM movies m JOIN ratings r ON m.id = r.movie_id JOIN users u ON r.user_id = u.id WHERE m.genres LIKE '%%Drama%%' AND m.year > 2005 AND u.gender = 'F' AND r.rating >= 4.5 GROUP BY m.id ORDER BY m.year, m.title;"
echo.

echo 7. Анализ регистраций:
echo --------------------------------------------------
sqlite3 movies_rating.db "SELECT SUBSTR(register_date, 1, 4) as year, COUNT(*) as count FROM users GROUP BY year ORDER BY count DESC;"
echo.

echo Лабораторная работа 3 завершена!
pause