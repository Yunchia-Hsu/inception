#!/bin/sh
echo "You are setting up MariaDB directory..."
chmod -R 755 /var/lib/mysql


mkdir -p /run/mysqld
chown -R mysql:mysql /var/lib/mysql /run/mysqld
#check if mariadb is init
if [ ! -d "/var/lib/mysql/mysql" ]; then
    echo "Initializing MariaDB system tables..."
    mariadb-install-db --basedir=/usr --user=mysql --datadir=/var/lib/mysql >/dev/null

    echo "setting up wordpress database and user~"
    mysqld --user=mysql --bootstrap << EOF
USE mysql;
FLUSH PRIVILEGES;

ALTER USER 'root'@'localhost' IDENTIFIED BY "$MYSQL_ROOT_PASSWORD";
CREATE DATABASE $WORDPRESS_DATABASE_NAME CHARACTER SET utf8 COLLATE utf8_general_ci;
CREATE USER $WORDPRESS_DATABASE_USER@'%' IDENTIFIED BY "$WORDPRESS_DATABASE_PASSWORD";
GRANT ALL PRIVILEGES ON $WORDPRESS_DATABASE_NAME.* TO $WORDPRESS_DATABASE_USER@'%';



FLUSG PRIVILEGES;
EOF

else
    echo "MariaDB  was initialized. Database and users were configured."
fi

echo "mariadb server is running..."
exec mysqld --defaults-file=/etc/my.cnf.d/mariadb_config