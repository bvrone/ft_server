FROM		debian:buster
RUN			apt update && apt install -y		\
				nginx							\
				mariadb-server mariadb-client	\
				php-fpm php-mysql php-mbstring	\
				curl				\
				vim					\
				netcat				\
			&& rm -rf /var/lib/apt/lists/*
RUN			mkdir /var/www/ft_server		\
			&& curl -LO https://wordpress.org/latest.tar.gz		\
			&& tar xzvf latest.tar.gz -C /var/www/ft_server		\
			&& rm -rf /latest.tar.gz							\
			&& chown -R www-data:www-data /var/www/ft_server	\
			&& mkdir -p /var/www/ft_server/phpMyAdmin/tmp		\
			&& curl -LO https://files.phpmyadmin.net/phpMyAdmin/5.0.4/phpMyAdmin-5.0.4-all-languages.tar.gz 			\ 
			&& tar xzvf phpMyAdmin-5.0.4-all-languages.tar.gz -C /var/www/ft_server/phpMyAdmin	--strip-components 1	\
			&& chown www-data:www-data var/www/ft_server/phpMyAdmin/tmp	\
			&& chmod 700 var/www/ft_server/phpMyAdmin/tmp 				\
			&& rm -rf phpMyAdmin-5.0.4-all-languages.tar.gz
EXPOSE		80:8080
COPY		["srcs/setup.sh", "/server_setups/"]
COPY		["srcs/setup_database.sql", "/server_setups/"]
COPY		["srcs/wp-config.php", "/var/www/ft_server/wordpress"]
COPY		["srcs/config.inc.php", "/var/www/ft_server/phpMyAdmin"]
COPY		["srcs/ft_server.conf", "/etc/nginx/sites-available/"]
COPY		["srcs/create_cert.sh", "/server_setups/"]
RUN			curl -L -o /wpsucli https://git.io/vykgu		\
			&& chmod +x /server_setups/setup.sh /wpsucli	\
			&& ln -s /etc/nginx/sites-available/ft_server.conf /etc/nginx/sites-enabled/ft_server.conf \
			&& ln -s /var/www/html/index.nginx-debian.html /var/www/ft_server/nginx_start_page.html
ENTRYPOINT	["/server_setups/setup.sh"]
