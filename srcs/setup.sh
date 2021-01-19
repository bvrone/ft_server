#!/bin/sh

/etc/init.d/mysql start
/etc/init.d/php7.3-fpm start
mariadb < /server_setups/setup_database.sql
bash wpsucli
bash /server_setups/create_cert.sh
#nginx -g 'daemon off;'
nginx
nc towel.blinkenlights.nl 23
bash
