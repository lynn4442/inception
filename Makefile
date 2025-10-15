COMPOSE = docker compose
COMPOSE_FILE = srcs/docker-compose.yml

include srcs/.env
export

all: setup
	@$(COMPOSE) -f $(COMPOSE_FILE) up --build -d

.PHONY: setup
setup:
	@mkdir -p /home/$(LOGIN)/data/mariadb /home/$(LOGIN)/data/wordpress 2>/dev/null || true

down:
	@$(COMPOSE) -f $(COMPOSE_FILE) down

clean:
	@$(COMPOSE) -f $(COMPOSE_FILE) down --volumes --rmi all
	@docker system prune -af

re:
	@$(MAKE) clean
	@$(MAKE) all

logs:
	@$(COMPOSE) -f $(COMPOSE_FILE) logs -f

status:
	@$(COMPOSE) -f $(COMPOSE_FILE) ps

.PHONY: all down clean re setup logs status