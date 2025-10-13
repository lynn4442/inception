COMPOSE = docker compose

# Path to the docker-compose file
COMPOSE_FILE = srcs/docker-compose.yml

# Include environment variables from the .env file to use them in this Makefile
include srcs/.env
export

# The main target, builds and starts the services in detached mode
all: setup
	@echo "Building and starting services..."
	@$(COMPOSE) -f $(COMPOSE_FILE) up --build -d

# This target creates the necessary data directories on the host machine.
# It's a prerequisite for the 'all' target to ensure bind mounts work correctly.
.PHONY: setup
setup:
	@echo "Creating data directories..."
	@sudo mkdir -p /home/$(LOGIN)/data/mariadb
	@sudo mkdir -p /home/$(LOGIN)/data/wordpress
	@sudo chown -R $(LOGIN):$(LOGIN) /home/$(LOGIN)/data

# Stops the services
down:
	@echo "Stopping services..."
	@$(COMPOSE) -f $(COMPOSE_FILE) down

# Cleans up containers, networks, volumes, and images
clean:
	@echo "Cleaning up..."
	@$(COMPOSE) -f $(COMPOSE_FILE) down --volumes --rmi all
	@echo "Pruning docker system..."
	@docker system prune -af

# Rebuilds and restarts the services
re:
	@$(MAKE) clean
	@$(MAKE) all

# Shows logs for all services
logs:
	@$(COMPOSE) -f $(COMPOSE_FILE) logs -f

# Shows status of services
status:
	@$(COMPOSE) -f $(COMPOSE_FILE) ps

.PHONY: all down clean re setup logs status