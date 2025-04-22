# 映像能自動產生自簽憑證、設定 Nginx 為 HTTPS 伺服器，並以最小體積的 Alpine Linux 作為基底，適合在容器化環境中快速佈署安全的反向代理或靜態網站伺服器
FROM alpine:3.20.6

RUN apk update && apk add nginx openssl


RUN mkdir -p /etc/nginx/ssl

RUN openssl req -x509 -nodes \
#create public and private keys path
    -out /etc/nginx/ssl/public_certificate.crt \	
    -keyout /etc/nginx/ssl/private.key \  
    -subj "/C=FI/ST=Uusimaa/L=Helsinki/O=42/OU=Hive/CN=yhsu.42.fr"

RUN adduser -D -H -s /sbin/nologin -g www-data -G www-data www-data
#-D no password -H no repository -s not allow to lonin from shell  
#-g、-G：設定主群組與附加群組都為 www-data，以便 Nginx 進程以此使用者身分運行、讀寫網站檔案。

COPY ./conf/nginx.conf /etc/nginx/nginx.conf
RUN chmod 644 /etc/nginx/nginx.conf

EXPOSE 443

CMD ["nginx", "-c", "/etc/nginx/nginx.conf", "-g", "daemon off;"]