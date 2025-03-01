FROM debian:bullseye

RUN apt update && apt upgrade -y \
    && apt install -y curl \
    unzip \
    php8.2 \
    php-zip \
    php8.2-fpm \
    php-mysqli \
    mariadb-client \
    && apt clean
    
# apt clean vide les fichiers en cache inutiles

# curl permet de telecharger des fichiers en utilisant des liens

# Vérifier que PHP et PHP-FPM fonctionnent
RUN php -v && php-fpm -v

WORKDIR /var/www/html
RUN curl -O https://wordpress.org/wordpress-6.7.zip \
	&& unzip wordpress-6.7.zip wordpress/* -d . \
	&& rm wordpress-6.7.zip
# Telecharge wordpress
# Unzip les fichier dans le dossier wordpress du .zip puis les mets dans le dossier courant
# Supprime le .zip

# www-data doit etre proprietaire du fichier car php-fpm s'execute en tant que www-data mais un docker lui en tant que root
# Donc si le proprietaire n'est pas changer le wordpress ne sera pas modifiable (php-fpm peut pas lire/ecrire/modifier les fichiers wordpress)
# et il sera impossible d'installer des plugins ou d'utiliser certaines fonctionnalitees wordpress
# /run/php est necessaire pour le fonctionnement de php-fpm
RUN chown -R www-data:www-data /var/www/html && mkdir -p /run/php && chown -R www-data:www-data /run/php

EXPOSE 9000

CMD ["/usr/local/bin/wp.sh"]
