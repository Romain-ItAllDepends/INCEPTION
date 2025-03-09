FROM debian:bullseye

RUN apt update && apt upgrade -y \
    && apt install mariadb-server -y \
	&& apt clean

COPY tools/mariadb.sh mariadb.sh

RUN chmod 744 mariadb.sh

EXPOSE 3306

ENTRYPOINT ["./mariadb.sh"]