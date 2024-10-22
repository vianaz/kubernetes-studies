start:
	@docker network create giropops-senhas
	@docker container run --rm --name giropops-senhas-redis --network giropops-senhas -d redis
	@docker container run --rm --name giropops-senhas -p 5000:5000 --network giropops-senhas --env REDIS_HOST=giropops-senhas-redis -d vianaz/linuxtips-giropops-senhas:main

stop:
	@docker container stop giropops-senhas giropops-senhas-redis
	@docker network rm giropops-senhas