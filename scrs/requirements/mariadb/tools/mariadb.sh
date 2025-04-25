#!/bin/sh

# Setup mysqld directory
if [ ! -d "/run/mysqld" ]; then
    mkdir -p /run/mysqld
fi
chown -R mysql:mysql /run/mysqld
chmod 755 /run/mysqld

# Initialize DB if needed
if [ ! -d "/var/lib/mysql/${MARIADB_DATABASE}" ]; then
    echo "Initializing MariaDB..."
    mysql_install_db --user=mysql --basedir=/usr --datadir=/var/lib/mysql
else
    echo "Database already exists. Skipping DB files init."
fi

# 🟢 Always apply user/database grants (even if DB already exists)
tfile=$(mktemp)
cat << EOF > $tfile
USE mysql;
FLUSH PRIVILEGES;
GRANT ALL ON *.* TO 'root'@'%' IDENTIFIED BY '${MARIADB_ROOT_PASSWORD}' WITH GRANT OPTION;
GRANT ALL ON *.* TO 'root'@'localhost' IDENTIFIED BY '${MARIADB_ROOT_PASSWORD}' WITH GRANT OPTION;
CREATE DATABASE IF NOT EXISTS ${MARIADB_DATABASE};
CREATE OR REPLACE USER '${MARIADB_USER}'@'%' IDENTIFIED BY '${MARIADB_PASSWORD}';
GRANT ALL PRIVILEGES ON ${MARIADB_DATABASE}.* TO '${MARIADB_USER}'@'%';
FLUSH PRIVILEGES;
EOF

# Run SQL bootstrap
/usr/sbin/mysqld --user=mysql --bootstrap < $tfile
rm -f $tfile

# Start MariaDB normally
exec /usr/sbin/mysqld --user=mysql --console --skip-networking=0 --bind-address=0.0.0.0

