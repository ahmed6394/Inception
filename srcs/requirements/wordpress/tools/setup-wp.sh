#!/bin/bash

set -e

if [ ! -d "/var/www/html" ]; then
  mkdir -p /var/www/html
fi

cd /var/www/html

# Install wp-cli if not present
if [ ! -f "/usr/local/bin/wp" ]; then
    curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
    chmod +x wp-cli.phar
    mv wp-cli.phar /usr/local/bin/wp
fi

echo "Waiting for MariaDB to be ready..."
while ! mysqladmin ping -h ${DB_HOST} -u ${DB_ADMIN_USER} -p${DB_ADMIN_PASSWORD} --silent; do
    sleep 3
done

if [ ! -f "wp-config.php" ]; then
    wp core download --allow-root --locale=en_US
    wp config create --allow-root --dbname=${DB_NAME} --dbuser=${DB_ADMIN_USER} --dbpass=${DB_ADMIN_PASSWORD} --dbhost=${DB_HOST}:3306
    wp core install --allow-root --url=${WP_URL} --title=${WP_TITLE} --admin_user=${WP_ADMIN_USER} --admin_password=${WP_ADMIN_PASSWORD} --admin_email=${WP_ADMIN_EMAIL}
    wp user create "${WP_USER}" "${WP_EMAIL}" --user_pass="${WP_PASSWORD}" --role=author --allow-root
else
    echo "Wordpress already configured!"
fi

chown -R www-data:www-data /var/www/html
chmod -R 755 /var/www/html

echo "php-fpm start..."
exec php-fpm8.4 -F -R