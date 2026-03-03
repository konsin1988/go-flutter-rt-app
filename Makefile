up:
	docker compose up -d && docker compose -f ~/keycloak/docker-compose.yaml up -d && progress_bar 15 && docker compose -f go/docker-compose.yml up -d dev worker-dev
down: 
	docker compose -f ./go/docker-compose.yml down && docker compose -f ~/keycloak/docker-compose.yaml down && docker compose down
