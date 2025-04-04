#!/bin/bash

# Load environment variables
if [ -f .env ]; then
  export $(grep -v '^#' .env | xargs)
fi

# Set default values if not provided
SITE_NAME=${SITE_NAME:-site1.local}
ADMIN_PASSWORD=${ADMIN_PASSWORD:-admin}
DB_ROOT_PASSWORD=${DB_ROOT_PASSWORD:-123}

# Get the backend container ID
BACKEND_CONTAINER=$(docker ps | grep backend | awk '{print $1}')

if [ -z "$BACKEND_CONTAINER" ]; then
  echo "Backend container not found. Make sure the containers are running."
  exit 1
fi

echo "Creating new site: $SITE_NAME"
docker exec -it $BACKEND_CONTAINER bash -c "cd /home/frappe/frappe-bench && bench new-site $SITE_NAME --admin-password $ADMIN_PASSWORD --db-root-password $DB_ROOT_PASSWORD"

echo "Installing ERPNext app..."
docker exec -it $BACKEND_CONTAINER bash -c "cd /home/frappe/frappe-bench && bench --site $SITE_NAME install-app erpnext"

echo "Installing Lending app..."
docker exec -it $BACKEND_CONTAINER bash -c "cd /home/frappe/frappe-bench && bench --site $SITE_NAME install-app lending"

echo "Configuring site..."
docker exec -it $BACKEND_CONTAINER bash -c "cd /home/frappe/frappe-bench && bench config dns_multitenant off"
docker exec -it $BACKEND_CONTAINER bash -c "cd /home/frappe/frappe-bench && bench --site $SITE_NAME set-config -g host_name $SITE_NAME"
docker exec -it $BACKEND_CONTAINER bash -c "cd /home/frappe/frappe-bench && bench --site $SITE_NAME set-config -g serve_default_site true"
docker exec -it $BACKEND_CONTAINER bash -c "cd /home/frappe/frappe-bench && bench --site $SITE_NAME set-config -g maintenance_mode 0"

echo "Setting site as default..."
docker exec -it $BACKEND_CONTAINER bash -c "cd /home/frappe/frappe-bench && bench use $SITE_NAME"

echo "Site setup complete!"
echo "You can now access your site at http://localhost:${HTTP_PORT:-8080}"
echo "Login with username: Administrator and password: $ADMIN_PASSWORD"
