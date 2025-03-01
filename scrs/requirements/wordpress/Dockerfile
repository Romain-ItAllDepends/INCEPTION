FROM debian:bullseye

RUN apt update && apt upgrade -y \
    && apt install -y curl \
    unzip \
    php8.2 \
    php-zip \
    php8.2-fpm \
    php-mysqli \
    mariadb-client \
    && apt clean # Vide les fichiers en cache inutiles

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

EXPOSE 9000

CMD ["/usr/local/bin/wp.sh"]