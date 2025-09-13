# Требования к окружению для работы скриптов

## Для Windows:
1. Установите Python: https://www.python.org/downloads/
2. Установите SQLite: https://sqlite.org/download.html
3. Запустите: `db_init.bat`

## Для Linux/Mac:
1. Установите: `sudo apt-get install python3 sqlite3`
2. Дайте права: `chmod +x db_init.sh`
3. Запустите: `./db_init.sh`

## Структура базы данных:
- movies: id, title, year, genres
- ratings: id, user_id, movie_id, rating, timestamp  
- tags: id, user_id, movie_id, tag, timestamp
- users: id, name, email, gender, register_date, occupation
