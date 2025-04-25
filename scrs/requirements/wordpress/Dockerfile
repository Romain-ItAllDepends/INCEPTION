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
    
# apt clean vide les fichiers en cache inutiles

# curl permet de telecharger des fichiers en utilisant des liens

# Vérifier que PHP et PHP-FPM fonctionnent
RUN php -v && php-fpm8.2 -v

WORKDIR /var/www/html
RUN curl -O https://wordpress.org/wordpress-6.7.zip \
	&& unzip wordpress-6.7.zip \
	&& mv wordpress/* . \
	&& rm -rf wordpress wordpress-6.7.zip

# Telecharge wordpress
# Unzip les fichier dans le dossier wordpress du .zip puis les mets dans le dossier courant
# Supprime le .zip

# www-data doit etre proprietaire du fichier car php-fpm s'execute en tant que www-data mais un docker lui en tant que root
# Donc si le proprietaire n'est pas changer le wordpress ne sera pas modifiable (php-fpm peut pas lire/ecrire/modifier les fichiers wordpress)
# et il sera impossible d'installer des plugins ou d'utiliser certaines fonctionnalitees wordpress
# /run/php est necessaire pour le fonctionnement de php-fpm

RUN chown -R www-data:www-data /var/www/html && \
mkdir -p /run/php && \
chown -R www-data:www-data /run/php

COPY conf/www.conf /etc/php/8.2/fpm/pool.d/www.conf
COPY tools/wp.sh /usr/local/bin/wp.sh

RUN chmod +x /usr/local/bin/wp.sh

EXPOSE 9000

CMD ["/usr/local/bin/wp.sh"]
