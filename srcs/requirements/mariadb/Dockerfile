FROM alpine:3.20.6

#install MariaDB Server , client is for command iinterface like healthcheck activate mariadb ... 
RUN apk update && apk add mariadb mariadb-client

COPY ./conf/mariadb_config /etc/my.cnf.d/mariadb_config
RUN  chmod 644 /etc/my.cnf.d/mariadb_config

#mariadb-script.sh 含初始化 DB、建立使用者、權限設定等邏輯
COPY ./tools/mariadb-script.sh /usr/local/bin/mariadb-script.sh
RUN chmod +x /usr/local/bin/mariadb-script.sh

EXPOSE 3306

ENTRYPOINT ["mariadb-script.sh"]