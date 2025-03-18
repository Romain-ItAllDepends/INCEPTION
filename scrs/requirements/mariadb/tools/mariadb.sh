#!/bin/sh

# Check if mysqld directory exist
if [ -d "/run/mysqld" ]; then
    echo "MySQL directory already present, skipping creation."
    chown -R mysql:mysql /run/mysqld
else
    mkdir -p /run/mysqld
    chown -R mysql:mysql /run/mysqld
    chmod 755 /run/mysqld
fi

# Check if the database is already create
if [ -d "/var/lib/mysql/${MARIADB_DATABASE}" ]; then
    echo "MySQL directory already present, skipping creation."
else
    chown -R mysql:mysql /var/lib/mysql

# Create a temporary file to initialize the database
    tfile=$(mktemp)
    if [ ! -f "$tfile" ]; then
        echo "Failed to create temp file!"
        exit 1
    fi

# SQL request to setup the database and create a user
    cat << END > $tfile
USE mysql;
FLUSH PRIVILEGES;
GRANT ALL ON *.* TO 'root'@'%' IDENTIFIED BY '${MARIADB_ROOT_PASSWORD}' WITH GRANT OPTION;
GRANT ALL ON *.* TO 'root'@'localhost' IDENTIFIED BY '${MARIADB_ROOT_PASSWORD}' WITH GRANT OPTION;
CREATE DATABASE IF NOT EXISTS ${MARIADB_DATABASE};
CREATE USER '${MARIADB_USER}'@'%' IDENTIFIED BY '${MARIADB_PASSWORD}';
GRANT ALL PRIVILEGES ON ${MARIADB_DATABASE}.* TO '${MARIADB_USER}'@'%';
FLUSH PRIVILEGES;
END

    # Initialize database
    /usr/sbin/mysqld --user=mysql --bootstrap < $tfile
    rm -f $tfile
fi

exec /usr/sbin/mysqld --user=mysql --console --skip-networking=0 --bind-address=0.0.0.0