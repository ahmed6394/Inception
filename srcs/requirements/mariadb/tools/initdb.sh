#!/bin/bash
set -e

# Initialize database
if [ ! -d "/var/lib/mysql/mysql" ]; then
    echo "Initializing database..."
    mariadb_install_db --user=mysql --datadir=/var/lib/mysql
fi

#star mariadb in the background
mysqld_safe --skip-networking &
pid="$!"

#wait untill mariadb is ready
untill mariadb-amin ping --silent; do
    echo "Waiting for database to be ready..."
    sleep 1
done


#create database and user
mariadb -u root <<-EOSQL
    CREATE DATABASE IF NOT EXISTS wordpress;
    CREATE USER IF NOT EXISTS 'wp_user'@'%' IDENTIFIED BY 'wp_pass';
    GRANT ALL PRIVILEGES ON wordpress.* TO 'wp_user'@'%';
    FLUSH PRIVILEGES;
EOSQL

# Start MySQL server
echo "Starting MySQL server..."
exec mysqld --user=mysql --bind-address=0.0.0.0