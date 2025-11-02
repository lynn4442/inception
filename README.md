# Inception

A Docker-based project that sets up a complete WordPress website with HTTPS security using three separate containers.

## What is This Project?

This project creates a fully functional WordPress site using Docker containers. Instead of installing everything directly on your computer, each component (web server, WordPress, and database) runs in its own isolated container.

**Simple Architecture:**
```
Browser (HTTPS) → Nginx (Web Server) → WordPress (Website) → MariaDB (Database)
```

## Components

- **Nginx**: Web server that handles HTTPS requests and serves your website securely
- **WordPress**: The actual website/blog platform where you create content
- **MariaDB**: Database that stores all your WordPress data (posts, users, settings)

## Quick Start

### Prerequisites
- Docker and Docker Compose installed on your machine
- Port 443 available

### Setup

1. **Edit configuration file** `srcs/.env`:
   ```bash
   DOMAIN_NAME=your-domain.com
   MYSQL_ROOT_PASSWORD=your_password
   WP_ADMIN_USER=admin
   WP_ADMIN_PASSWORD=your_admin_password
   # ... (change other passwords)
   ```

2. **Start everything**:
   ```bash
   make up
   ```

3. **Access your site**:
   ```
   https://your-domain.com
   ```
   (Accept the security warning - it's self-signed certificate)

## Useful Commands

| Command | What It Does |
|---------|-------------|
| `make up` | Start the website |
| `make down` | Stop the website |
| `make clean` | Stop and delete data |
| `make re` | Rebuild everything from scratch |
| `make logs` | View what's happening |

## Project Structure

```
inception_final/
├── Makefile                    # Easy commands to control everything
├── srcs/
│   ├── .env                    # Your configuration (passwords, domain, etc.)
│   ├── docker-compose.yml      # Defines the 3 containers
│   └── requirements/
│       ├── mariadb/            # Database container setup
│       ├── nginx/              # Web server container setup
│       └── wordpress/          # WordPress container setup
```

## How It Works

1. **MariaDB** container starts first and creates a database
2. **WordPress** container downloads WordPress and connects to the database
3. **Nginx** container sets up HTTPS and connects to WordPress
4. All containers talk to each other through a private Docker network
5. Your data is saved in Docker volumes (persists even if containers restart)

## Important Notes

- Change all default passwords in the `.env` file before using
- The SSL certificate is self-signed (for development/learning)
- Data persists in Docker volumes even when containers are stopped
- Each service runs independently and can be restarted separately

## Troubleshooting

**Site not loading?**
```bash
make logs  # Check what's happening
make ps    # Check if containers are running
```

**Need to start fresh?**
```bash
make fclean  # Remove everything
make up      # Start again
```

## What You'll Learn

- How to use Docker and Docker Compose
- How web servers, applications, and databases work together
- How to containerize applications
- How to set up HTTPS
- Infrastructure as Code principles

---