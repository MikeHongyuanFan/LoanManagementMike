#!/bin/bash

# Load environment variables
if [ -f .env ]; then
  export $(grep -v '^#' .env | xargs)
fi

# Set default values if not provided
SITE_NAME=${SITE_NAME:-site1.local}
BACKUP_DIR=${BACKUP_DIR:-./backups}

# Create backup directory if it doesn't exist
mkdir -p $BACKUP_DIR

# Get the backend container ID
BACKEND_CONTAINER=$(docker ps | grep backend | awk '{print $1}')

if [ -z "$BACKEND_CONTAINER" ]; then
  echo "Backend container not found. Make sure the containers are running."
  exit 1
fi

echo "Creating backup for site: $SITE_NAME"
docker exec -it $BACKEND_CONTAINER bash -c "cd /home/frappe/frappe-bench && bench --site $SITE_NAME backup --with-files"

# Get the latest backup file
LATEST_BACKUP=$(docker exec -it $BACKEND_CONTAINER bash -c "ls -t /home/frappe/frappe-bench/sites/$SITE_NAME/private/backups/*.sql.gz | head -n1")

if [ -z "$LATEST_BACKUP" ]; then
  echo "No backup file found."
  exit 1
fi

BACKUP_FILENAME=$(basename $LATEST_BACKUP)
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
LOCAL_BACKUP_PATH="$BACKUP_DIR/${TIMESTAMP}_${BACKUP_FILENAME}"

echo "Copying backup file to host: $LOCAL_BACKUP_PATH"
docker cp $BACKEND_CONTAINER:$LATEST_BACKUP $LOCAL_BACKUP_PATH

echo "Backup complete: $LOCAL_BACKUP_PATH"
