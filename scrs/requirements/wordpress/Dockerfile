FROM debian:bullseye

RUN apt search php8.2

RUN apt update && apt upgrade -m -y \
    && apt install -m -y curl \
    gnupg \
    lsb-release \
    ca-certificates \
    && apt clean
    
RUN curl -fsSL https://packages.sury.org/php/README.txt | bash -x
    
RUN apt install -m -y php8.2 php8.2-fpm php-zip php8.2-mysql mariadb-client unzip \
    && apt clean
    
# apt clean empties unnecessary cache files

# curl allows you to download files using links

# Verify that PHP and PHP-FPM are working
RUN php -v && php-fpm8.2 -v

WORKDIR /var/www/html
RUN curl -O https://wordpress.org/wordpress-6.7.zip \
	&& unzip wordpress-6.7.zip \
	&& mv wordpress/* . \
	&& rm -rf wordpress wordpress-6.7.zip

# Download WordPress
# Unzip the files in the WordPress folder from the .zip file and then place them in the current folder
# Delete the .zip file

# www-data must be the owner of the file because php-fpm runs as www-data, but Docker runs as root
# So if the owner isn't changed, WordPress won't be editable (php-fpm can't read/write/edit WordPress files)
# and it will be impossible to install plugins or use certain WordPress features
# /run/php is required for php-fpm to work

RUN chown -R www-data:www-data /var/www/html && \
mkdir -p /run/php && \
chown -R www-data:www-data /run/php

COPY conf/www.conf /etc/php/8.2/fpm/pool.d/www.conf
COPY tools/wp.sh /usr/local/bin/wp.sh

RUN chmod +x /usr/local/bin/wp.sh

EXPOSE 9000

CMD ["/usr/local/bin/wp.sh"]
