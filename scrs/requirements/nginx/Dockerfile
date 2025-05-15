FROM debian:bullseye

# The -y option means that when Y/N is requested for download, yes will be sent automatically.

RUN apt update \
    && apt upgrade -y \
    && apt install -y nginx \
    && apt install -y openssl \
    && apt clean \
    && mkdir -p /etc/nginx/ssl \
    && openssl req -x509 -nodes \
    -out /etc/nginx/ssl/inception.crt \
    -keyout /etc/nginx/ssl/inception.key \
    -subj "/C=FR/ST=Nouvelle-Aquitaine/L=Angouleme/O=42/OU=42/CN=rgobet.42.fr/UID=rgobet"

# apt clean clears unnecessary cached files

# CMD allows you to run a command by default when the container starts

# nginx → Starts the Nginx server.
# -g → Option that allows you to pass a global directive to Nginx. (Required when using Docker and is used to edit the nginx.conf file)
# daemon off; → Prevents Nginx from switching to daemon (background) mode, which is required in a Docker container. (Prevents the container from stopping directly)

# COPY copies the default folder or file to the following location.

COPY conf/nginx.conf /etc/nginx/nginx.conf

# Allows access to /var/www/html with nginx which is in the www-data group
RUN chown -R www-data:www-data /var/www/html

EXPOSE 443

CMD ["nginx", "-g", "daemon off;"]
