up:
	docker compose -f ~/RT-App/hub-api/docker/docker-compose.yml up -d && cd ~/keycloak && docker compose up -d
down: 
	docker compose -f ~/keycloak/docker-compose.yaml down && docker compose -f ~/RT-App/hub-api/docker/docker-compose.yml down
