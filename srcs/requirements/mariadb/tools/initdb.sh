#!/bin/bash
set -e

# Read secrets
# DB_ROOT_PASSWORD=$(cat /run/secrets/db_root_password)
# DB_ADMIN_PASSWORD=$(cat /run/secrets/db_admin_password)
# DB_USER_PASSWORD=$(cat /run/secrets/db_user_password)

# Initialize database
if [ ! -d "/var/lib/mysql/mysql" ]; then
    echo "Initializing database..."
    mariadb-install-db --user=mysql --datadir="/var/lib/mysql"

    mariadbd-safe --skip-networking &
    pid="$!"

    mariadb -u root <<EOF
        ALTER USER 'root'@'localhost' IDENTIFIED BY '${DB_ROOT_PASSWORD}';
        CREATE DATABASE IF NOT EXISTS ${DB_NAME};
        CREATE USER IF NOT EXISTS ${DB_ADMIN_USER}@'%' IDENTIFIED BY '${DB_ADMIN_PASSWORD}';
        CREATE USER IF NOT EXISTS ${DB_USER}@'%' IDENTIFIED BY '${DB_USER_PASSWORD}';
        GRANT ALL PRIVILEGES ON ${DB_NAME}.* TO ${DB_ADMIN_USER}@'%';
        GRANT SELECT, INSERT, UPDATE, DELETE ON ${DB_NAME}.* TO ${DB_USER}@'%';
        FLUSH PRIVILEGES;
EOF

    kill "$pid"
    wait "$pid"
fi

echo "Starting MariaDB server..."
exec mariadbd-safe --bind-address=0.0.0.0