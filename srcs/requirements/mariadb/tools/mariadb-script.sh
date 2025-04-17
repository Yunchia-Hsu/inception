#!/bin/sh

echo "==> Setting up MariaDB directory..."
chmod -R 755 /var/lib/mysql

mkdir -p /run/mysqld 

chown -R mysql:mysql /var/lib/mysql /run/mysqld

if [ ! -d "/var/lib/mysql/mysql" ]; then
    echo "==> Initializing MariaDB system tables..."
    mariadb-install-db --basedir=/usr --user=mysql --datadir=/var/lib/mysql >/dev/null

    echo "==> Creating WordPress database and user..."
    mysqld --user=mysql --bootstrap << EOF
USE mysql;
FLUSH PRIVILEGES;


CREATE DATABASE $WORDPRESS_DATABASE_NAME CHARACTER SET utf8 COLLATE utf8_general_ci;
CREATE USER $WORDPRESS_DATABASE_USER@'%' IDENTIFIED BY "$WORDPRESS_DATABASE_PASSWORD";
GRANT ALL PRIVILEGES ON $WORDPRESS_DATABASE_NAME.* TO '$WORDPRESS_DATABASE_USER'@'%';


CREATE USER 'yhsu'@'localhost' IDENTIFIED BY "$WORDPRESS_DATABASE_PASSWORD";
GRANT ALL PRIVILEGES ON `$WORDPRESS_DATABASE_NAME`.* TO 'yhsu'@'localhost';


FLUSH PRIVILEGES;
EOF

else
    echo "==> MariaDB is already installed. Database and users are configured."
fi

echo "==> Starting MariaDB server..."
exec mysqld --defaults-file=/etc/my.cnf.d/mariadb_config