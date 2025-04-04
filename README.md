# Frappe with Lending App Docker

This repository contains everything needed to run Frappe with ERPNext and the Lending app in Docker containers.

## Features

- Ready-to-use Docker setup for Frappe, ERPNext, and Lending app
- Easy deployment with Docker Compose
- Configurable through environment variables
- Scripts for common operations

## Quick Start

### Prerequisites

- Docker
- Docker Compose

### Setup

1. Clone this repository:
   ```bash
   git clone https://github.com/yourusername/frappe-lending-docker.git
   cd frappe-lending-docker
   ```

2. Create a `.env` file from the example:
   ```bash
   cp .env.example .env
   ```

3. Edit the `.env` file with your preferred settings.

4. Build the Docker image:
   ```bash
   ./scripts/build.sh
   ```

5. Start the containers:
   ```bash
   docker compose up -d
   ```

6. Set up the site:
   ```bash
   ./scripts/setup-site.sh
   ```

7. Access the application at http://localhost:8080 (or the port you configured)
   - Username: Administrator
   - Password: admin (or what you set during setup)

## Docker Image

The Docker image is built on top of the official Frappe/ERPNext image and includes:

- Frappe framework
- ERPNext
- Lending app

You can pull the pre-built image from Docker Hub:
```bash
docker pull yourusername/frappe-lending:latest
```

Or build it yourself:
```bash
docker build -t yourusername/frappe-lending:latest .
```

## Configuration

The setup can be configured through environment variables in the `.env` file:

- `DOCKER_USERNAME`: Your Docker Hub username
- `TAG`: The image tag to use
- `HTTP_PORT`: The port to expose the application on
- `DB_ROOT_PASSWORD`: MariaDB root password
- `DB_USER`: Database user for Frappe
- `DB_PASSWORD`: Database password
- `DB_NAME`: Database name

## Scripts

- `scripts/build.sh`: Build the Docker image
- `scripts/setup-site.sh`: Set up a new site
- `scripts/backup.sh`: Create a backup of the site
- `scripts/restore.sh`: Restore from a backup

## Production Deployment

For production deployment, consider:

1. Using HTTPS with a proper SSL certificate
2. Using a managed database service
3. Setting up proper backups
4. Configuring email

See the [deployment guide](docs/deployment.md) for more details.

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
