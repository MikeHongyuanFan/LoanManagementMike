#!/bin/bash

# Check if backup file is provided
if [ -z "$1" ]; then
  echo "Usage: $0 <backup_file>"
  echo "Example: $0 ./backups/20250404_123456_site1_20250404_123456.sql.gz"
  exit 1
fi

BACKUP_FILE=$1

# Check if backup file exists
if [ ! -f "$BACKUP_FILE" ]; then
  echo "Backup file not found: $BACKUP_FILE"
  exit 1
fi

# Load environment variables
if [ -f .env ]; then
  export $(grep -v '^#' .env | xargs)
fi

# Set default values if not provided
SITE_NAME=${SITE_NAME:-site1.local}

# Get the backend container ID
BACKEND_CONTAINER=$(docker ps | grep backend | awk '{print $1}')

if [ -z "$BACKEND_CONTAINER" ]; then
  echo "Backend container not found. Make sure the containers are running."
  exit 1
fi

# Copy backup file to container
BACKUP_FILENAME=$(basename $BACKUP_FILE)
CONTAINER_BACKUP_PATH="/home/frappe/frappe-bench/sites/$SITE_NAME/private/backups/$BACKUP_FILENAME"

echo "Copying backup file to container..."
docker cp $BACKUP_FILE $BACKEND_CONTAINER:$CONTAINER_BACKUP_PATH

echo "Restoring backup for site: $SITE_NAME"
docker exec -it $BACKEND_CONTAINER bash -c "cd /home/frappe/frappe-bench && bench --site $SITE_NAME restore $CONTAINER_BACKUP_PATH"

echo "Restore complete!"
