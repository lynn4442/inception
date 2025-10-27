# Inception - Docker Infrastructure Makefile

# Variables
COMPOSE_FILE = srcs/docker-compose.yml
ENV_FILE = srcs/.env

# Colors for output
GREEN = \033[0;32m
RED = \033[0;31m
YELLOW = \033[0;33m
NC = \033[0m # No Color

.PHONY: all up build down clean fclean re logs status ps exec-nginx exec-wordpress exec-mariadb help

# Default target
all: up

# Build and start all containers
up:
	@echo "$(GREEN)Starting Inception infrastructure...$(NC)"
	@cd srcs && docker compose up -d --build
	@echo "$(GREEN)All services are running!$(NC)"
	@echo "$(YELLOW)Access WordPress at: https://$(shell grep DOMAIN_NAME $(ENV_FILE) | cut -d '=' -f2)$(NC)"

# Build containers without starting
build:
	@echo "$(GREEN)Building Docker images...$(NC)"
	@cd srcs && docker compose build

# Start containers (without rebuild)
start:
	@echo "$(GREEN)Starting containers...$(NC)"
	@cd srcs && docker compose start

# Stop containers (without removing)
stop:
	@echo "$(YELLOW)Stopping containers...$(NC)"
	@cd srcs && docker compose stop

# Stop and remove containers
down:
	@echo "$(YELLOW)Stopping and removing containers...$(NC)"
	@cd srcs && docker compose down

# Remove containers, networks, and volumes
clean:
	@echo "$(RED)Removing containers, networks, and volumes...$(NC)"
	@cd srcs && docker compose down -v

# Full cleanup: remove containers, volumes, images
fclean: clean
	@echo "$(RED)Removing all Docker images...$(NC)"
	@docker rmi -f $$(docker images -q srcs-nginx srcs-wordpress srcs-mariadb 2>/dev/null) 2>/dev/null || true
	@echo "$(RED)Cleaning up unused Docker resources...$(NC)"
	@docker system prune -af --volumes
	@echo "$(GREEN)Complete cleanup finished!$(NC)"

# Rebuild everything from scratch
re: fclean all

# Show logs for all services
logs:
	@cd srcs && docker compose logs -f

# Show logs for specific service
logs-nginx:
	@docker logs -f nginx

logs-wordpress:
	@docker logs -f wp-php

logs-mariadb:
	@docker logs -f mariadb

# Show container status
status:
	@cd srcs && docker compose ps

# Show running containers
ps:
	@docker ps -a --filter "name=nginx\|wp-php\|mariadb"

# Execute shell in containers
exec-nginx:
	@docker exec -it nginx sh

exec-wordpress:
	@docker exec -it wp-php sh

exec-mariadb:
	@docker exec -it mariadb sh

# Database operations
db-connect:
	@echo "$(GREEN)Connecting to MariaDB...$(NC)"
	@docker exec -it mariadb mysql -u root -p$(shell grep MYSQL_ROOT_PASSWORD $(ENV_FILE) | cut -d '=' -f2)

db-backup:
	@echo "$(GREEN)Backing up database...$(NC)"
	@mkdir -p backups
	@docker exec mariadb mysqldump -u root -p$(shell grep MYSQL_ROOT_PASSWORD $(ENV_FILE) | cut -d '=' -f2) \
		$(shell grep MYSQL_DATABASE $(ENV_FILE) | cut -d '=' -f2) > backups/wordpress_$(shell date +%Y%m%d_%H%M%S).sql
	@echo "$(GREEN)Database backup created in backups/$(NC)"

# WordPress operations
wp-cli:
	@docker exec -it wp-php ./wp-cli.phar --allow-root $(CMD)

wp-info:
	@echo "$(GREEN)WordPress Information:$(NC)"
	@docker exec wp-php ./wp-cli.phar core version --allow-root
	@docker exec wp-php ./wp-cli.phar plugin list --allow-root
	@docker exec wp-php ./wp-cli.phar user list --allow-root

# Network inspection
network-inspect:
	@docker network inspect srcs_inception

# Volume inspection
volumes:
	@docker volume ls | grep srcs

volume-inspect-db:
	@docker volume inspect srcs_db-data

volume-inspect-wp:
	@docker volume inspect srcs_wp-files

