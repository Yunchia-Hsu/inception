FROM alpine:3.20.6
#install php extensions
EXPOSE 9000
RUN apk update && add mariadb-client \
    php83 \
    #fastcgi process manager (nginx uses to process php)
    php83-fpm \ 
    php83-phar \
    #connect php and mariadb
    php83-mysqli \
    php83 curl \
    php83-iconv \
    php83-json \
    wget

COPY ./conf/www.conf /etc/php83/php-fpm.d/www.conf

RUN mkdir -p /var/www/wp /var/www/html
#run wp setup script
COPY ./tools/wordpress-script.sh /usr/local/bin/wordpress-script.sh
RUN chmod 755 /usr/local/bin/wordpress-script.sh
#create user for PHP to increase the security for PHP (not to run wordpress as root)
RUN adduser -D -H -s /sbin/nologin -g www-data -G www-data www-data
#entry command
CMD ["wordpress-script.sh"]