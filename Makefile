# Variables
ENV_FILE = srcs/.env
GREEN = \033[0;32m
RED = \033[0;31m
YELLOW = \033[0;33m
NC = \033[0m

all: up

up:
	@echo "$(GREEN)Starting Inception...$(NC)"
	@cd srcs && docker compose up -d --build
	@echo "$(GREEN)Running at: https://$(shell grep DOMAIN_NAME $(ENV_FILE) | cut -d '=' -f2)$(NC)"

down:
	@echo "$(YELLOW)Stopping containers...$(NC)"
	@cd srcs && docker compose down

clean:
	@echo "$(RED)Removing containers and volumes...$(NC)"
	@cd srcs && docker compose down -v

fclean: clean
	@echo "$(RED)Removing images...$(NC)"
	@docker rmi -f $$(docker images -q srcs-nginx srcs-wordpress srcs-mariadb 2>/dev/null) 2>/dev/null || true
	@docker system prune -af --volumes

re: fclean all

logs:
	@cd srcs && docker compose logs -f

ps:
	@docker ps -a --filter "name=nginx\|wordpress\|mariadb"

.PHONY: all up down clean fclean re logs ps