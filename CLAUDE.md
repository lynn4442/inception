# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is an **Inception** project that creates a containerized infrastructure for hosting a WordPress website. The architecture consists of three Docker containers orchestrated by Docker Compose:

1. **MariaDB** - Database server
2. **WordPress (PHP-FPM)** - Application server running WordPress with PHP 8.2
3. **NGINX** - Web server and reverse proxy with TLS/SSL

All containers run on Alpine Linux 3.21 and communicate through a custom Docker network called `inception`.

## Build and Run Commands

### Primary Commands (via Makefile)

- `make all` or `make` - Create data directories, build all containers, and start services in detached mode
- `make down` - Stop all running services
- `make clean` - Stop services, remove containers, volumes, networks, images, and prune Docker system
- `make re` - Full rebuild: clean everything and start fresh (equivalent to `make clean && make all`)
- `make logs` - Follow logs for all services in real-time
- `make status` - Show current status of all services

### Direct Docker Compose Commands

```bash
docker compose -f srcs/docker-compose.yml up --build -d    # Build and start
docker compose -f srcs/docker-compose.yml down             # Stop
docker compose -f srcs/docker-compose.yml logs -f          # Follow logs
docker compose -f srcs/docker-compose.yml ps               # Show status
```

## Architecture and Data Flow

### Container Communication
- **NGINX** (port 443 exposed to host) → **WordPress** (port 9000, FastCGI) → **MariaDB** (port 3306, internal)
- All containers connected via the `inception` bridge network
- WordPress container name is `wp-php` (used in NGINX FastCGI configuration)
- MariaDB container name is `mariadb` (used as hostname in WordPress connection)

### Persistent Data
Both MariaDB and WordPress data persist on the host filesystem:
- MariaDB: `/home/${LOGIN}/data/mariadb` → `/var/lib/mysql` (in container)
- WordPress: `/home/${LOGIN}/data/wordpress` → `/var/www/html` (in container)

The `LOGIN` variable comes from `srcs/.env` and must match the host user. The Makefile's `setup` target creates these directories with proper ownership.

### Container Initialization Flow

1. **MariaDB** initializes first:
   - `srcs/requirements/mariadb/conf/script.sh` checks if database exists
   - If first run: initializes MariaDB, creates database and user, then starts normally
   - Listens on all interfaces (0.0.0.0:3306)

2. **WordPress** waits for MariaDB (depends_on + connection retry loop):
   - `srcs/requirements/wordpress/conf/script.sh` downloads WP-CLI and WordPress core
   - Waits up to 60 seconds for MariaDB to accept connections
   - Creates `wp-config.php` using environment variables
   - Installs WordPress via WP-CLI
   - Starts PHP-FPM on port 9000

3. **NGINX** starts last (depends on WordPress):
   - `srcs/requirements/nginx/ssl/generate_ssl.sh` generates self-signed SSL certificate
   - NGINX configuration template uses `${DOMAIN_NAME}` from environment
   - Proxies PHP requests to `wp-php:9000` via FastCGI

## Configuration Files

### Environment Variables (`srcs/.env`)
Contains all configuration: domain name, MySQL credentials, WordPress admin credentials. This file is:
- Included in the Makefile (`include srcs/.env`)
- Passed to containers via `environment` sections in docker-compose.yml
- **Required** before running any commands

### Service-Specific Configuration
- **MariaDB**: `srcs/requirements/mariadb/conf/50-server.cnf` - Server configuration
- **WordPress**: `srcs/requirements/wordpress/conf/www.conf` - PHP-FPM pool configuration
- **NGINX**: `srcs/requirements/nginx/conf/default` - Main server block with SSL and FastCGI configuration

## Key Implementation Details

### SSL/TLS
- Self-signed certificates generated at runtime using OpenSSL
- Only TLS 1.2 and TLS 1.3 enabled (TLS 1.0/1.1 disabled)
- HSTS header with 1-year max-age
- Certificate stored in `/etc/nginx/ssl/` inside container

### WordPress Installation
- Uses WP-CLI for automated installation
- PHP memory limit increased to 256M during core download
- All WordPress files owned by `nobody:nobody` user in container
- PHP-FPM runs as `nobody` user (non-root)

### Database Connection
- WordPress waits for MariaDB with retry logic (60 second timeout)
- MariaDB accepts connections from any host (`bind-address = 0.0.0.0`)
- Initialization script creates database and grants privileges to WordPress user

## Troubleshooting

### Checking Container Status
```bash
make status                          # Quick status check
docker compose -f srcs/docker-compose.yml ps   # Detailed status
```

### Viewing Logs
```bash
make logs                            # All services
docker logs mariadb                  # MariaDB only
docker logs wp-php                   # WordPress only
docker logs nginx                    # NGINX only
```

### Common Issues
- **MariaDB won't start**: Check if `/home/${LOGIN}/data/mariadb` exists and has correct permissions
- **WordPress connection fails**: Verify MariaDB is running and check credentials in `srcs/.env`
- **NGINX 502 error**: Ensure WordPress container is running and PHP-FPM is listening on port 9000
- **Permission issues**: Run `make setup` to recreate directories with correct ownership
