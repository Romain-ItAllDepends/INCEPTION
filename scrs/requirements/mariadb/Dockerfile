FROM debian:bullseye

RUN apt update && apt upgrade -y \
    && apt install mariadb-server -y \
	&& apt clean

COPY tools/mariadb.sh mariadb.sh

RUN chmod 744 mariadb.sh && chmod -R 755 /var/lib/mysql && chown -R mysql:mysql /var/lib/mysql

EXPOSE 3306

ENTRYPOINT ["./mariadb.sh"]
