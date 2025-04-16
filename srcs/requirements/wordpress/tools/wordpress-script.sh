#!/bin/sh
#腳本自動化了從環境配置到 WordPress 安裝與啟動的所有必要步驟
echo "You are setting up Wordpress..."
echo "memory_limit = 512M">> /etc/php83/php.ini

cd /var/www/html

echo "Downloading wordpress client WP_CLI"
wget -q https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar -O /usr/local/bin/wp || { echo "Failed to download wp-cli.phar"; exit 1; } 

chmod +x /usr/local/bin/wp

echo "check if mariadb is running before running wordpress"
# ping  check if mariadb can be connected 
mariadb-admin ping --protocol=tcp --host=mariadb -u $WORDPRESS_DATABASE_USER --password=$WORDPRESS_DATABASE_USER_PASSWORD --wait=300 

if [ ! -f /var/www/html/wp-config.php ]; then
    echo "now, downlodaing, installing, configuring WordPress files..."
    wp core download --allow-root
#create wp-config.php  file wp-config.php 是 WordPress 的主要設定檔
    wp config create \
        --dbname=$WORDPRESS_DATABASE_NAME \
        --dbuser=$WORDPRESS_DATABASE_USER \
        --dbpass=$WORDPRESS_DATABASE_PASSWORD \
        --dbhost=mariadb \
        --force

    wp core install --url="DOMAIN_NAME" --title="$WORDPRESS_TITLE" \
        --admin_user="$WORDPRESS_ADMIN" \
        --admin_password="$WORDPRESS_ADMIN_PASSWORD" \
        --admin_email="$WORDPRESS_ADMIN_EMAIL" \
        --admin-root \
        --skip-email \
        --path=/var/www/html

    echo "create WP user..."
    wp user creat \
        --allow-root \
        $WORDPRESS_USER $WORDPRESS_USER_EMAIL \
        --user_pass=$WORDPRESS_USER_PASSWORD
else
	echo "WordPress is already downloaded, installed and cinfogured."
fi

    chow -R www-data:www-data /var/www/html

    chmod -R 755 /var/www/html/

    echo "Runninf php in the foreground "
    php-fpm83 -F