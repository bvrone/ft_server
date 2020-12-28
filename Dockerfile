FROM		debian:buster
RUN			apt update && apt install -y \
				nginx				\
				mariadb-server mariadb-client		\
				php-fpm php-mysql	\
				php-common php-mbstring php-xmlrpc php-soap php-gd php-xml php-intl php-mysql php-cli php-ldap php-zip php-curl \
				curl				\
				vim				\
			&& rm -rf /var/lib/apt/lists/*
RUN			mkdir /var/www/ft_server		\
			&& curl -LO https://wordpress.org/latest.tar.gz	\
			&& tar xzvf latest.tar.gz						\
			&& cp -a /wordpress/. /var/www/ft_server		\
			&& rm -rf /latest.tar.gz /wordpress				\
			&& chown -R www-data:www-data /var/www/ft_server
EXPOSE		80:80
COPY		["srcs/setup.sh", "/server_setups/"]
COPY		["srcs/setup_database.sql", "/server_setups/"]
COPY		["srcs/wp-config.php", "/var/www/ft_server/"]
COPY		["srcs/ft_server.conf", "/etc/nginx/sites-available/"]
RUN			curl -L -o /wpsucli https://git.io/vykgu		\
			&& chmod +x /server_setups/setup.sh /wpsucli	\
			&& ln -s /etc/nginx/sites-available/ft_server.conf /etc/nginx/sites-enabled/ft_server.conf
ENTRYPOINT	["/server_setups/setup.sh"]
