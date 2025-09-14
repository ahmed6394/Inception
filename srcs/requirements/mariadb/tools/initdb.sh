#!/bin/bash

set -e

Initialize database
if [ ! -d "/var/lib/mysql/mysql" ]; then
    echo "Initializing database..."
    mariadb-install-db --user=mysql --datadir="/var/lib/mysql"

    mariadbd-safe --skip-networking &
    sleep 10

    mariadb -u root <<EOF
        ALTER USER 'root'@'localhost' IDENTIFIED BY '${DB_ROOT_PASSWORD}';
        CREATE DATABASE IF NOT EXISTS ${DB_NAME};
        CREATE USER IF NOT EXISTS ${DB_ADMIN_USER}@'%' IDENTIFIED BY '${DB_ADMIN_PASSWORD}';
        CREATE USER IF NOT EXISTS ${DB_USER}@'%' IDENTIFIED BY '${DB_USER_PASSWORD}';
        GRANT ALL PRIVILEGES ON ${DB_NAME}.* TO ${DB_ADMIN_USER}@'%';
        GRANT SELECT, INSERT, UPDATE, DELETE ON ${DB_NAME}.* TO ${DB_USER}@'%';
        FLUSH PRIVILEGES;
EOF

    mysqladmin -u root -p${DB_ROOT_PASSWORD} shutdown
    echo "Database initialized."
else
    echo "Database already initialized."
fi

echo "Starting MariaDB server..."
exec mariadbd-safe --bind-address=0.0.0.0
