#!/bin/bash
set -e

# Initialize database
if [ ! -d "/var/lib/mysql/mysql" ]; then
    echo "Initializing database..."
    mariadb-install-db --user=mysql --datadir=/var/lib/mysql
fi

#star mariadb in the background
mysqld_safe --skip-networking &
pid="$!"

#wait untill mariadb is ready
untill mariadb-amin ping --silent; do
    echo "Waiting for database to be ready..."
    sleep 1
done



# Kill background mysqld-safe process
echo "Stopping temporary MySQL server..."
kill "$pid"
wait "$pid"

# Start MySQL server
echo "Starting MySQL server..."
exec mysqld --user=mysql --bind-address=0.0.0.0