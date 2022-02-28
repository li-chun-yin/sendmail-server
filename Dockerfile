FROM ubuntu
ARG DEBIAN_FRONTEND=noninteractive
ENV TZ=
WORKDIR /srv

RUN apt-get update

RUN apt-get install -yq git zip

COPY ./php-8.1.3.tar.gz /usr/src/php-8.1.3.tar.gz

RUN apt-get install -yq gcc \
				pkg-config \ 
				libxml2-dev \
				libssl-dev \ 
				libsqlite3-dev \
				zlib1g-dev \
				libcurl4-nss-dev \
				libonig-dev \
				libreadline-dev \
				libsodium-dev \
				libargon2-dev \
				make

RUN cd /usr/src/; \
	tar xfzv php-8.1.3.tar.gz; \
	cd php-8.1.3; \
	./configure \
		--prefix=/usr/local/etc/php \
		--with-config-file-path=/usr/local/etc/php/etc \
		--with-config-file-scan-dir="/usr/local/etc/php/etc/conf.d" \
		--enable-option-checking=fatal \
		--enable-bcmath \
		--enable-ftp \
		--enable-mbstring \
		--enable-mysqlnd \
		--enable-fpm \
		--enable-embed \
		--enable-zts \
		--with-mhash \
		--with-pic \
		--with-password-argon2 \
		--with-sodium=shared \
		--with-pdo-sqlite \
		--with-pdo_mysql \
		--with-sqlite3 \
		--with-curl \
		--with-openssl \
		--with-readline \
		--with-zlib \
		--with-pear \
		--with-libdir \
		--with-fpm-user=www \
		--with-fpm-group=www \
	; \
	make -j "$(nproc)"; \
	make install; \
	ln -s /usr/local/etc/php/bin/php /usr/local/bin/

RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"; \
	php -r "if (hash_file('sha384', 'composer-setup.php') === '906a84df04cea2aa72f40b5f787e49f22d4c2f19492ac310e8cba5b96ac8b64115ac402c8cd292b8a03482574915d1a8') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;"; \
	php composer-setup.php; \
	php -r "unlink('composer-setup.php');"; \
	mv composer.phar /usr/local/bin/composer; \
	composer config -g disable-tls true

COPY ./docker-entrypoint.sh /docker-entrypoint.sh

RUN chmod +x /docker-entrypoint.sh

EXPOSE 80

CMD ["/docker-entrypoint.sh"]

