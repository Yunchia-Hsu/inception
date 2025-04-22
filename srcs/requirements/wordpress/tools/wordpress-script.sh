#!/bin/sh
#腳本自動化了從環境配置到 WordPress 安裝與啟動的所有必要步驟
echo "You are setting up Wordpress..."
echo "memory_limit = 512M" >> /etc/php83/php.ini

cd /var/www/html

echo "Downloading wordpress client WP_CLI"
wget -q https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar -O /usr/local/bin/wp || { echo "Failed to download wp-cli.phar"; exit 1; } 

chmod +x /usr/local/bin/wp

echo "check if mariadb is running before running wordpress"

mariadb-admin ping --protocol=tcp --host=mariadb -u $WORDPRESS_DATABASE_USER --password=$WORDPRESS_DATABASE_PASSWORD --wait=300 

# —— 第一次安裝區塊（只在 wp-config.php 不存在時執行） ——
if [ ! -f /var/www/html/wp-config.php ]; then
  echo "first time install：download WordPress，create wp-config.php and install core"
  cd /var/www/html

  wp core download --allow-root

  wp config create \
    --dbname="$WORDPRESS_DATABASE_NAME" \
    --dbuser="$WORDPRESS_DATABASE_USER" \
    --dbpass="$WORDPRESS_DATABASE_PASSWORD" \
    --dbhost=mariadb \
    --force

  wp core install \
    --url="$DOMAIN_NAME" \
    --title="$WORDPRESS_TITLE" \
    --admin_user="$WORDPRESS_ADMIN" \
    --admin_password="$WORDPRESS_ADMIN_PASSWORD" \
    --admin_email="$WORDPRESS_ADMIN_EMAIL" \
    --skip-email \
    --path=/var/www/html
fi

# —— 自訂使用者檢查區塊（每次啟動都會檢查並補建立） ——
echo "check and build user：$WORDPRESS_USER"
if ! wp user get "$WORDPRESS_USER" --allow-root >/dev/null 2>&1; then
  wp user create \
    --allow-root \
    "$WORDPRESS_USER" "$WORDPRESS_USER_EMAIL" \
    --user_pass="$WORDPRESS_USER_PASSWORD"
  echo "user existed：$WORDPRESS_USER"
else
  echo "user $WORDPRESS_USER is here，no need to build again。"
fi




    chown -R www-data:www-data /var/www/html

    chmod -R 755 /var/www/html/

    echo "Running php in the foreground "
    php-fpm83 -F