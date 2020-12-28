#!/bin/sh

/etc/init.d/mysql start
/etc/init.d/php7.3-fpm start
mariadb < /server_setups/setup_database.sql
bash wpsucli
#nginx -g 'daemon off;'
nginx
bash
