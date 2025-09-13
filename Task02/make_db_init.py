#!/usr/bin/env python3
# -*- coding: utf-8 -*-

import csv
import sqlite3
from pathlib import Path

def generate_db_init_sql():
    """Генерирует SQL-скрипт для создания и заполнения базы данных"""
    
    sql_script = """-- Удаляем существующие таблицы
DROP TABLE IF EXISTS ratings;
DROP TABLE IF EXISTS tags;
DROP TABLE IF EXISTS movies;
DROP TABLE IF EXISTS users;

-- Создаем таблицу movies
CREATE TABLE movies (
    id INTEGER PRIMARY KEY,
    title TEXT NOT NULL,
    year INTEGER,
    genres TEXT
);

-- Создаем таблицу ratings
CREATE TABLE ratings (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    user_id INTEGER NOT NULL,
    movie_id INTEGER NOT NULL,
    rating REAL NOT NULL,
    timestamp INTEGER NOT NULL,
    FOREIGN KEY (movie_id) REFERENCES movies (id)
);

-- Создаем таблицу tags
CREATE TABLE tags (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    user_id INTEGER NOT NULL,
    movie_id INTEGER NOT NULL,
    tag TEXT NOT NULL,
    timestamp INTEGER NOT NULL,
    FOREIGN KEY (movie_id) REFERENCES movies (id)
);

-- Создаем таблицу users
CREATE TABLE users (
    id INTEGER PRIMARY KEY,
    name TEXT NOT NULL,
    email TEXT,
    gender TEXT,
    register_date TEXT,
    occupation TEXT
);

"""

    # Записываем начало SQL-скрипта
    with open('db_init.sql', 'w', encoding='utf-8') as f:
        f.write(sql_script)

    # Обрабатываем movies.csv
    with open('db_init.sql', 'a', encoding='utf-8') as f:
        f.write("-- Заполняем таблицу movies данными из movies.csv\n")
        f.write("INSERT INTO movies (id, title, year, genres) VALUES\n")
        
        movies_data = []
        with open('../dataset/movies.csv', 'r', encoding='utf-8') as csv_file:
            reader = csv.DictReader(csv_file)
            for row in reader:
                title = row['title'].replace("'", "''")
                year = None
                if '(' in title and ')' in title:
                    year_str = title.split('(')[-1].split(')')[0]
                    if year_str.isdigit() and len(year_str) == 4:
                        year = int(year_str)
                
                genres = row['genres'].replace("'", "''")
                movies_data.append(f"({row['movieId']}, '{title}', {year if year else 'NULL'}, '{genres}')")

        f.write(',\n'.join(movies_data))
        f.write(';\n\n')

    # Обрабатываем ratings.csv частями
    with open('db_init.sql', 'a', encoding='utf-8') as f:
        f.write("-- Заполняем таблицу ratings данными из ratings.csv\n")
        
        with open('../dataset/ratings.csv', 'r', encoding='utf-8') as csv_file:
            reader = csv.DictReader(csv_file)
            batch = []
            for i, row in enumerate(reader, 1):
                batch.append(f"({row['userId']}, {row['movieId']}, {row['rating']}, {row['timestamp']})")
                
                if i % 10000 == 0:
                    f.write("INSERT INTO ratings (user_id, movie_id, rating, timestamp) VALUES\n")
                    f.write(',\n'.join(batch))
                    f.write(';\n\n')
                    batch = []
                    print(f"Обработано {i} записей ratings")
            
            if batch:
                f.write("INSERT INTO ratings (user_id, movie_id, rating, timestamp) VALUES\n")
                f.write(',\n'.join(batch))
                f.write(';\n\n')

    print("SQL-скрипт db_init.sql успешно создан!")

if __name__ == "__main__":
generate_db_int_sql()

