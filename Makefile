ls:
	@docker image ls
	
on:
	@docker compose ps
	
start:
	@cd scrs && docker-compose up
