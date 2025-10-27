# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is an Inception project - a containerized WordPress infrastructure using Docker. The system consists of three services:
- **NGINX**: Web server with TLS/SSL termination (Alpine-based)
- **WordPress**: PHP-FPM with WordPress installation via WP-CLI (Alpine-based)
- **MariaDB**: Database server (Alpine-based)

All services run in Alpine 3.21 containers and communicate via a custom Docker bridge network called `inception`.

## Architecture

### Service Dependencies and Communication Flow
1. **MariaDB** starts first and initializes the database
2. **WordPress** waits for MariaDB, then downloads WordPress core and configures it
3. **NGINX** proxies HTTPS requests to WordPress via FastCGI on port 9000

### Key Design Patterns
- Each service has its own Dockerfile with a startup script (`tools/script.sh`)
- Configuration files are copied from `conf/` directories during build
- Environment variables from `srcs/.env` configure all services
- Named volumes (`db-data`, `wp-files`) persist data between container restarts
- NGINX uses self-signed SSL certificates generated at runtime

### Network Architecture
- NGINX exposes port 443 (HTTPS only) to the host
- WordPress (wp-php) listens on port 9000 for FastCGI connections
- MariaDB binds to 0.0.0.0:3306 within the Docker network
- All services communicate through the `inception` bridge network

## Working with This Project

### Building and Running
```bash
# Build and start all services
cd srcs && docker-compose up --build

# Build and start in background
cd srcs && docker-compose up -d --build

# Stop services
cd srcs && docker-compose down

# Stop and remove volumes (clean slate)
cd srcs && docker-compose down -v
```

### Debugging Individual Services
```bash
# View logs for a specific service
docker logs mariadb
docker logs wp-php
docker logs nginx

# Follow logs in real-time
docker logs -f nginx

# Access a running container
docker exec -it mariadb sh
docker exec -it wp-php sh
docker exec -it nginx sh
```

### Testing Database Connectivity
```bash
# Connect to MariaDB from WordPress container
docker exec -it wp-php mysql -h mariadb -u wpuser -p

# Check MariaDB status
docker exec -it mariadb mysqladmin -u root -p status
```

### WordPress Management
```bash
# Access WP-CLI from WordPress container
docker exec -it wp-php ./wp-cli.phar --allow-root [command]

# Examples:
docker exec -it wp-php ./wp-cli.phar user list --allow-root
docker exec -it wp-php ./wp-cli.phar plugin list --allow-root
```

## Service-Specific Details

### NGINX (srcs/requirements/nginx/)
- **Startup script**: Generates self-signed SSL certificate, then starts NGINX
- **Configuration**: `conf/default.conf` defines SSL settings and FastCGI proxy to WordPress
- **SSL**: Certificate generated for domain `lyoussef.42.fr` with 365-day validity
- **Protocols**: TLSv1.2 and TLSv1.3 only

### WordPress (srcs/requirements/wordpress/)
- **Startup script**:
  1. Waits 10 seconds for MariaDB to be ready
  2. Downloads WP-CLI and WordPress core
  3. Creates `wp-config.php` with database connection settings
  4. Installs WordPress with admin credentials
  5. Starts PHP-FPM in foreground mode
- **PHP-FPM Configuration**: Listens on port 9000 with dynamic process management
- **Installation path**: `/var/www/html`

### MariaDB (srcs/requirements/mariadb/)
- **Startup script**:
  1. Initializes database with `mysql_install_db`
  2. Starts MariaDB temporarily to run initialization SQL
  3. Creates WordPress database and user
  4. Sets root password
  5. Restarts MariaDB in foreground mode
- **Configuration**: Binds to 0.0.0.0 to accept connections from Docker network
- **Data directory**: `/var/lib/mysql`

## Environment Variables

All configuration is in `srcs/.env`:
- `DOMAIN_NAME`: WordPress site domain
- `MYSQL_ROOT_PASSWORD`: MariaDB root password
- `MYSQL_DATABASE`: WordPress database name
- `MYSQL_USER`: WordPress database user
- `MYSQL_PASSWORD`: WordPress database user password
- `WP_ADMIN_USER`: WordPress admin username
- `WP_ADMIN_PASSWORD`: WordPress admin password
- `WP_ADMIN_EMAIL`: WordPress admin email

## Important Notes

### Modifying Services
- When editing Dockerfiles, rebuild with `docker-compose up --build`
- When editing `script.sh` files, rebuild the affected service
- When editing config files in `conf/`, rebuild the affected service
- Changes to `srcs/.env` require container restart

### Container Naming
- MariaDB container: `mariadb`
- WordPress container: `wp-php`
- NGINX container: `nginx`

These names are used for DNS resolution within the Docker network.

### Volume Persistence
- `db-data`: MariaDB database files
- `wp-files`: WordPress installation files

These volumes persist data even when containers are stopped. Use `docker-compose down -v` to remove them.

### SSL Certificate
The NGINX self-signed certificate is regenerated on each container restart. For production, replace the `openssl req` command in `srcs/requirements/nginx/tools/script.sh` with proper certificate mounting.
