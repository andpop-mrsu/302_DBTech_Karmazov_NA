#!/bin/bash
echo "Генерация SQL-скрипта..."
python3 make_db_init.py

echo "Создание базы данных..."
sqlite3 movies_rating.db < db_init.sql

echo "База данных movies_rating.db успешно создана!"
