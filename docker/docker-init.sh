#!/usr/bin/env bash
set -eo pipefail

STEP_CNT=4

echo_step() {
  echo ""
  echo "######################################################################"
  echo "# Step ${1}/${STEP_CNT} [${2}] - ${3}"
  echo "######################################################################"
}

ADMIN_USERNAME="${ADMIN_USERNAME:-admin}"
ADMIN_FIRSTNAME="${ADMIN_FIRSTNAME:-Superset}"
ADMIN_LASTNAME="${ADMIN_LASTNAME:-Admin}"
ADMIN_EMAIL="${ADMIN_EMAIL:-admin@superset.com}"
ADMIN_PASSWORD="${ADMIN_PASSWORD:-admin}"

# Initialize the database
echo_step "1" "Starting" "Applying DB migrations"
superset db upgrade

# Create admin user
echo_step "2" "Starting" "Creating admin user ${ADMIN_USERNAME}"
superset fab create-admin \
  --username "${ADMIN_USERNAME}" \
  --firstname "${ADMIN_FIRSTNAME}" \
  --lastname "${ADMIN_LASTNAME}" \
  --email "${ADMIN_EMAIL}" \
  --password "${ADMIN_PASSWORD}"

# Create default roles and permissions
echo_step "3" "Starting" "Setting up roles and permissions"
superset init

# Load examples
if [ "${SUPERSET_LOAD_EXAMPLES}" = "yes" ]; then
  echo_step "4" "Starting" "Loading examples"
  superset load_examples
fi

echo ""
echo "######################################################################"
echo "# Init complete"
echo "######################################################################"
