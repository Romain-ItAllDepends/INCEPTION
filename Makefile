all:
	@sudo mkdir -p /home/rgobet/data/mariadb
	@sudo mkdir -p /home/rgobet/data/wordpress
	@sudo chown -R 999:999 /home/rgobet/data/mariadb
	@sudo chown -R www-data:www-data /home/rgobet/data/wordpress
	@cd scrs && sudo docker compose up -d
	@echo Done!


ls:
	@sudo docker image ls
	
on:
	@sudo docker ps
	
start:
	@cd scrs && sudo docker-compose up -d

stop:
	@cd scrs && sudo docker compose down

restart:
	@cd scrs && docker compose down -v
	@sudo rm -rf /home/rgobet/data/mariadb/*
	@sudo rm -rf /home/rgobet/data/wordpress/*
	@cd scrs && docker compose up --build
	
delete:
	@cd /home/rgobet && sudo rm -rf data
	@sudo docker system prune -af

.PHONY: all ls on start stop restart delete
