#!/bin/bash

sleep 15

# Wait until MariaDB is available
for i in {1..60}; do
    if mysqladmin ping -h "${WORDPRESS_DB_HOST}" -u "${WORDPRESS_DB_USER}" "--password=${WORDPRESS_DB_PASSWORD}" --silent; then
        echo "MariaDB is up."
        
        # Check if the database is ready for queries
        if mysql -h "${WORDPRESS_DB_HOST}" -u "${WORDPRESS_DB_USER}" "--password=${WORDPRESS_DB_PASSWORD}" -e "SHOW DATABASES;" > /dev/null 2>&1; then
            echo "MariaDB is ready for queries."
            break
        else
            echo "MariaDB is not ready for queries, retrying..."
            sleep 20
        fi
    else
        echo "MariaDB not available, retrying in 20 seconds..."
        sleep 20
    fi
done

cd /var/www/html

if [ -f wp-config.php ]; then
    echo "WordPress already installed."
else
    # Download WordPress files
    if [ ! -f /usr/local/bin/wp ]; then
        curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
        chmod +x wp-cli.phar
        mv wp-cli.phar /usr/local/bin/wp
    fi

    # Core files of WordPress
    wp core download --allow-root

    # Generating wp-config.php
    wp config create \
        --dbname=${WORDPRESS_DB_NAME} \
        --dbuser=${WORDPRESS_DB_USER} \
        --dbpass=${WORDPRESS_DB_PASSWORD} \
        --dbhost=${WORDPRESS_DB_HOST} \
        --allow-root

    wp core install \
        --url=${WORDPRESS_URL} \
        --title="${TITLE}" \
        --admin_user=${WORDPRESS_ADMIN_USER} \
        --admin_password=${WORDPRESS_ADMIN_PWD} \
        --admin_email=${WORDPRESS_ADMIN_EMAIL} \
        --allow-root

    # Creating WordPress user
    wp user create ${WORDPRESS_USER} ${WORDPRESS_EMAIL} --role=author --user_pass=${WORDPRESS_PASSWORD} --allow-root

    # Ensure the wp-content directory is writable by PHP
    chmod -R 775 wp-content
    chown -R www-data:www-data wp-content
fi

# Run php-fpm
exec php-fpm8.2 -F

