# Deployment Guide

This guide provides instructions for deploying Frappe with the Lending app in various environments.

## Local Deployment

For local development or testing:

1. Clone the repository:
   ```bash
   git clone https://github.com/yourusername/frappe-lending-docker.git
   cd frappe-lending-docker
   ```

2. Create a `.env` file:
   ```bash
   cp .env.example .env
   ```

3. Build and start the containers:
   ```bash
   ./scripts/build.sh
   docker compose up -d
   ```

4. Set up the site:
   ```bash
   ./scripts/setup-site.sh
   ```

## AWS Deployment

### EC2 Instance Setup

1. Launch an EC2 instance:
   - Recommended: t3.medium or larger
   - OS: Amazon Linux 2 or Ubuntu Server 20.04 LTS
   - Storage: At least 30GB

2. Configure security groups:
   - Allow SSH (port 22)
   - Allow HTTP (port 80)
   - Allow HTTPS (port 443)
   - Allow custom TCP (port 8080)

3. Install Docker and Docker Compose:

   For Amazon Linux 2:
   ```bash
   sudo yum update -y
   sudo amazon-linux-extras install docker -y
   sudo service docker start
   sudo systemctl enable docker
   sudo usermod -a -G docker ec2-user
   sudo curl -L "https://github.com/docker/compose/releases/download/v2.18.1/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
   sudo chmod +x /usr/local/bin/docker-compose
   ```

   For Ubuntu:
   ```bash
   sudo apt update
   sudo apt install -y docker.io docker-compose
   sudo systemctl enable --now docker
   sudo usermod -aG docker ubuntu
   ```

4. Clone the repository and deploy:
   ```bash
   git clone https://github.com/yourusername/frappe-lending-docker.git
   cd frappe-lending-docker
   cp .env.example .env
   # Edit .env with your settings
   ./scripts/build.sh
   docker compose up -d
   ./scripts/setup-site.sh
   ```

### Using AWS Managed Services

For production environments, consider using:

1. **Amazon RDS for MariaDB**:
   - Create a MariaDB RDS instance
   - Update your `.env` file:
     ```
     DB_HOST=your-rds-endpoint.rds.amazonaws.com
     DB_PORT=3306
     DB_USER=frappe
     DB_PASSWORD=your-secure-password
     DB_NAME=frappe
     ```
   - Update `docker-compose.yml` to remove the local db service and use the RDS endpoint

2. **Amazon ElastiCache for Redis**:
   - Create Redis ElastiCache clusters
   - Update your `docker-compose.yml` to use the ElastiCache endpoints

3. **Amazon EFS for persistent storage**:
   - Create an EFS file system
   - Mount it to your EC2 instance
   - Use it for persistent storage in your Docker Compose file

## Using Docker Hub

You can push your custom image to Docker Hub for easier deployment:

1. Build the image:
   ```bash
   docker build -t yourusername/frappe-lending:latest .
   ```

2. Log in to Docker Hub:
   ```bash
   docker login
   ```

3. Push the image:
   ```bash
   docker push yourusername/frappe-lending:latest
   ```

4. On your deployment server, pull the image:
   ```bash
   docker pull yourusername/frappe-lending:latest
   ```

## Setting Up HTTPS

For production environments, you should use HTTPS:

1. Get an SSL certificate (Let's Encrypt or other provider)

2. Create a `nginx-proxy` directory with the following files:

   `docker-compose.yml`:
   ```yaml
   version: '3'
   
   services:
     nginx-proxy:
       image: jwilder/nginx-proxy
       ports:
         - "80:80"
         - "443:443"
       volumes:
         - /var/run/docker.sock:/tmp/docker.sock:ro
         - ./certs:/etc/nginx/certs
         - ./vhost.d:/etc/nginx/vhost.d
         - ./html:/usr/share/nginx/html
       restart: always
   
     letsencrypt:
       image: jrcs/letsencrypt-nginx-proxy-companion
       volumes:
         - /var/run/docker.sock:/var/run/docker.sock:ro
         - ./certs:/etc/nginx/certs
         - ./vhost.d:/etc/nginx/vhost.d
         - ./html:/usr/share/nginx/html
       environment:
         - NGINX_PROXY_CONTAINER=nginx-proxy
       restart: always
   ```

3. Update your main `docker-compose.yml` to include:
   ```yaml
   services:
     frontend:
       environment:
         - VIRTUAL_HOST=your-domain.com
         - LETSENCRYPT_HOST=your-domain.com
         - LETSENCRYPT_EMAIL=your-email@example.com
   ```

4. Start the nginx proxy:
   ```bash
   cd nginx-proxy
   docker compose up -d
   ```

5. Start your Frappe containers:
   ```bash
   cd frappe-lending-docker
   docker compose up -d
   ```

## Backup and Restore

Regular backups are essential for production deployments:

1. Set up a cron job to run the backup script:
   ```bash
   0 2 * * * cd /path/to/frappe-lending-docker && ./scripts/backup.sh
   ```

2. Consider using AWS S3 for backup storage:
   ```bash
   # Install AWS CLI
   pip install awscli
   
   # Configure AWS CLI
   aws configure
   
   # Add to backup script
   aws s3 cp $LOCAL_BACKUP_PATH s3://your-bucket/backups/
   ```

3. To restore from a backup:
   ```bash
   ./scripts/restore.sh ./backups/your-backup-file.sql.gz
   ```
