#!/bin/bash

set -euo pipefail

exec > >(tee /var/log/sonarqube-user-data.log | logger -t sonarqube-user-data -s 2>/dev/console) 2>&1

echo "===== SonarQube Docker bootstrap started ====="

########################################
# VARIABLES FROM TERRAFORM
########################################

SONARQUBE_VOLUME_ID="${sonarqube_volume_id}"
POSTGRES_VOLUME_ID="${postgres_volume_id}"

SONARQUBE_MOUNT_PATH="${sonarqube_mount_path}"
POSTGRES_MOUNT_PATH="${postgres_mount_path}"

SONARQUBE_IMAGE="${sonarqube_image}"
SONARQUBE_CONTAINER="${sonarqube_container}"
SONARQUBE_PORT="${sonarqube_port}"

POSTGRES_IMAGE="${postgres_image}"
POSTGRES_CONTAINER="${postgres_container}"
POSTGRES_USER="${postgres_user}"
POSTGRES_DB="${postgres_db}"
POSTGRES_PORT="${postgres_port}"

POSTGRES_UID="${postgres_uid}"
POSTGRES_GID="${postgres_gid}"

SONARQUBE_UID="${sonarqube_uid}"
SONARQUBE_GID="${sonarqube_gid}"

DOCKER_NETWORK="${docker_network}"

SECRET_NAME="${secret_name}"
SECRET_DESCRIPTION="${secret_description}"

POSTGRES_PASSWORD_FILE="${postgres_password_file}"

COMPOSE_DIRECTORY="${compose_directory}"
COMPOSE_FILE="${compose_file}"
COMPOSE_ENV_FILE="${compose_env_file}"

POSTGRES_HEALTH_INTERVAL="${postgres_health_interval}"
POSTGRES_HEALTH_TIMEOUT="${postgres_health_timeout}"
POSTGRES_HEALTH_RETRIES="${postgres_health_retries}"
POSTGRES_HEALTH_START_PERIOD="${postgres_health_start_period}"

CONTAINER_START_WAIT="${container_start_wait}"

VM_MAX_MAP_COUNT="${vm_max_map_count}"
FS_FILE_MAX="${fs_file_max}"

AWS_REGION="${aws_region}"

########################################
# INSTALL PACKAGES
########################################

echo "Installing required packages..."

dnf install -y \
  docker \
  openssl \
  nvme-cli \
  xfsprogs \
  awscli \
  python3

########################################
# START DOCKER
########################################

echo "Starting Docker..."

systemctl enable docker
systemctl start docker

echo "Installing Docker Compose..."

DOCKER_CONFIG="/usr/local/lib/docker"
DOCKER_CLI_PLUGINS="$${DOCKER_CONFIG}/cli-plugins"

mkdir -p "$${DOCKER_CLI_PLUGINS}"

curl -SL \
  "https://github.com/docker/compose/releases/download/v2.39.2/docker-compose-linux-x86_64" \
  -o "$${DOCKER_CLI_PLUGINS}/docker-compose"

chmod +x "$${DOCKER_CLI_PLUGINS}/docker-compose"

docker compose version
########################################
# SONARQUBE KERNEL SETTINGS
########################################

echo "Configuring kernel parameters..."

cat > /etc/sysctl.d/99-sonarqube.conf <<EOF
vm.max_map_count=$${VM_MAX_MAP_COUNT}
fs.file-max=$${FS_FILE_MAX}
EOF

sysctl --system

########################################
# CREATE DIRECTORIES
########################################

mkdir -p "$${SONARQUBE_MOUNT_PATH}"
mkdir -p "$${POSTGRES_MOUNT_PATH}"

mkdir -p "$${COMPOSE_DIRECTORY}"

########################################
# WAIT FOR EBS DEVICES
########################################

echo "Waiting for EBS volumes..."

SONAR_VOLUME_SERIAL=$(echo "$${SONARQUBE_VOLUME_ID}" | tr -d '-')
POSTGRES_VOLUME_SERIAL=$(echo "$${POSTGRES_VOLUME_ID}" | tr -d '-')

SONARQUBE_DEVICE=""
POSTGRES_DEVICE=""

for attempt in $(seq 1 60); do

    for device in /dev/nvme*n1; do

        [ -e "$device" ] || continue

        serial=$(udevadm info --query=property --name="$device" 2>/dev/null \
            | awk -F= '/^ID_SERIAL_SHORT=/{print $2}')

        if [[ "$serial" == *"$${SONAR_VOLUME_SERIAL}"* ]]; then
            SONARQUBE_DEVICE="$device"
        fi

        if [[ "$serial" == *"$${POSTGRES_VOLUME_SERIAL}"* ]]; then
            POSTGRES_DEVICE="$device"
        fi

    done

    if [[ -n "$${SONARQUBE_DEVICE}" && -n "$${POSTGRES_DEVICE}" ]]; then
        break
    fi

    echo "Waiting for EBS devices... attempt $${attempt}/60"
    sleep 5
done

if [[ -z "$${SONARQUBE_DEVICE}" ]]; then
    echo "ERROR: SonarQube EBS volume was not found."
    exit 1
fi

if [[ -z "$${POSTGRES_DEVICE}" ]]; then
    echo "ERROR: PostgreSQL EBS volume was not found."
    exit 1
fi

echo "SonarQube device: $${SONARQUBE_DEVICE}"
echo "PostgreSQL device: $${POSTGRES_DEVICE}"

########################################
# FORMAT VOLUMES IF REQUIRED
########################################

format_if_needed() {

    DEVICE="$1"

    if ! blkid "$${DEVICE}" >/dev/null 2>&1; then
        echo "No filesystem found on $${DEVICE}. Creating XFS filesystem..."
        mkfs.xfs -f "$${DEVICE}"
    else
        echo "Filesystem already exists on $${DEVICE}"
    fi
}

format_if_needed "$${SONARQUBE_DEVICE}"
format_if_needed "$${POSTGRES_DEVICE}"

########################################
# GET UUIDS
########################################

SONARQUBE_UUID=$(blkid -s UUID -o value "$${SONARQUBE_DEVICE}")
POSTGRES_UUID=$(blkid -s UUID -o value "$${POSTGRES_DEVICE}")

########################################
# FSTAB
########################################

grep -q "$${SONARQUBE_UUID}" /etc/fstab || \
echo "UUID=$${SONARQUBE_UUID} $${SONARQUBE_MOUNT_PATH} xfs defaults,nofail 0 2" >> /etc/fstab

grep -q "$${POSTGRES_UUID}" /etc/fstab || \
echo "UUID=$${POSTGRES_UUID} $${POSTGRES_MOUNT_PATH} xfs defaults,nofail 0 2" >> /etc/fstab

########################################
# MOUNT
########################################

mountpoint -q "$${SONARQUBE_MOUNT_PATH}" || \
mount "$${SONARQUBE_MOUNT_PATH}"

mountpoint -q "$${POSTGRES_MOUNT_PATH}" || \
mount "$${POSTGRES_MOUNT_PATH}"

echo "Mounted volumes successfully."

########################################
# CREATE SONARQUBE DIRECTORIES
########################################

mkdir -p \
  "$${SONARQUBE_MOUNT_PATH}/data" \
  "$${SONARQUBE_MOUNT_PATH}/extensions" \
  "$${SONARQUBE_MOUNT_PATH}/logs" \
  "$${SONARQUBE_MOUNT_PATH}/temp"

########################################
# SET PERMISSIONS
########################################

chown -R "$${SONARQUBE_UID}:$${SONARQUBE_GID}" \
  "$${SONARQUBE_MOUNT_PATH}"

chown -R "$${POSTGRES_UID}:$${POSTGRES_GID}" \
  "$${POSTGRES_MOUNT_PATH}"

########################################
# CREATE DOCKER NETWORK
########################################

docker network inspect "$${DOCKER_NETWORK}" >/dev/null 2>&1 || \
docker network create "$${DOCKER_NETWORK}"

########################################
# SECRETS MANAGER
########################################

echo "Checking PostgreSQL secret..."

SECRET_EXISTS="false"

if aws secretsmanager describe-secret \
    --secret-id "$${SECRET_NAME}" \
    --region "$${AWS_REGION}" >/dev/null 2>&1; then

    SECRET_EXISTS="true"
fi

if [[ "$${SECRET_EXISTS}" == "true" ]]; then

    echo "Existing secret found. Retrieving password..."

    SECRET_STRING=$(aws secretsmanager get-secret-value \
        --secret-id "$${SECRET_NAME}" \
        --region "$${AWS_REGION}" \
        --query SecretString \
        --output text)

    POSTGRES_PASSWORD=$(echo "$${SECRET_STRING}" | \
        python3 -c '
import sys
import json

data = json.load(sys.stdin)
print(data["password"])
')

else

    echo "Secret does not exist. Generating PostgreSQL password..."

    POSTGRES_PASSWORD=$(openssl rand -hex 32)

    SECRET_FILE="/tmp/sonarqube-secret.json"

    python3 - "$${POSTGRES_PASSWORD}" "$${POSTGRES_USER}" "$${POSTGRES_DB}" > "$${SECRET_FILE}" <<'PY'
import sys
import json

password = sys.argv[1]
username = sys.argv[2]
database = sys.argv[3]

secret = {
    "username": username,
    "password": password,
    "database": database
}

print(json.dumps(secret))
PY

    chmod 600 "$${SECRET_FILE}"

    aws secretsmanager create-secret \
        --name "$${SECRET_NAME}" \
        --description "$${SECRET_DESCRIPTION}" \
        --secret-string "file://$${SECRET_FILE}" \
        --region "$${AWS_REGION}"

    rm -f "$${SECRET_FILE}"

fi

########################################
# STORE LOCAL PASSWORD FILE
########################################

mkdir -p "$(dirname "$${POSTGRES_PASSWORD_FILE}")"

printf '%s' "$${POSTGRES_PASSWORD}" \
  > "$${POSTGRES_PASSWORD_FILE}"

chmod 600 "$${POSTGRES_PASSWORD_FILE}"

########################################
# CREATE COMPOSE ENVIRONMENT FILE
########################################

cat > "$${COMPOSE_ENV_FILE}" <<EOF
SONARQUBE_IMAGE=$${SONARQUBE_IMAGE}
SONARQUBE_CONTAINER=$${SONARQUBE_CONTAINER}
SONARQUBE_PORT=$${SONARQUBE_PORT}
SONARQUBE_DATA_PATH=$${SONARQUBE_MOUNT_PATH}

POSTGRES_IMAGE=$${POSTGRES_IMAGE}
POSTGRES_CONTAINER=$${POSTGRES_CONTAINER}
POSTGRES_USER=$${POSTGRES_USER}
POSTGRES_DB=$${POSTGRES_DB}
POSTGRES_PORT=$${POSTGRES_PORT}
POSTGRES_DATA_PATH=$${POSTGRES_MOUNT_PATH}

POSTGRES_PASSWORD=$${POSTGRES_PASSWORD}
POSTGRES_PASSWORD_FILE=$${POSTGRES_PASSWORD_FILE}

POSTGRES_HEALTH_INTERVAL=$${POSTGRES_HEALTH_INTERVAL}
POSTGRES_HEALTH_TIMEOUT=$${POSTGRES_HEALTH_TIMEOUT}
POSTGRES_HEALTH_RETRIES=$${POSTGRES_HEALTH_RETRIES}
POSTGRES_HEALTH_START_PERIOD=$${POSTGRES_HEALTH_START_PERIOD}
EOF

chmod 600 "$${COMPOSE_ENV_FILE}"

########################################
# WRITE DOCKER COMPOSE
########################################

cat > "$${COMPOSE_FILE}" <<'EOF'
${docker_compose}
EOF

chmod 600 "$${COMPOSE_FILE}"

########################################
# START CONTAINERS
########################################

cd "$${COMPOSE_DIRECTORY}"

echo "Starting PostgreSQL and SonarQube..."

docker compose \
  --env-file "$${COMPOSE_ENV_FILE}" \
  -f "$${COMPOSE_FILE}" \
  up -d

########################################
# WAIT FOR CONTAINERS
########################################

echo "Waiting for containers..."

sleep "$${CONTAINER_START_WAIT}"

########################################
# SHOW STATUS
########################################

docker compose \
  --env-file "$${COMPOSE_ENV_FILE}" \
  -f "$${COMPOSE_FILE}" \
  ps

########################################
# FINAL CHECK
########################################

if docker ps --format '{{.Names}}' | grep -q "^$${POSTGRES_CONTAINER}$"; then
    echo "PostgreSQL container is running."
else
    echo "ERROR: PostgreSQL container is not running."
    docker logs "$${POSTGRES_CONTAINER}" || true
    exit 1
fi

if docker ps --format '{{.Names}}' | grep -q "^$${SONARQUBE_CONTAINER}$"; then
    echo "SonarQube container is running."
else
    echo "ERROR: SonarQube container is not running."
    docker logs "$${SONARQUBE_CONTAINER}" || true
    exit 1
fi

echo "===== SonarQube Docker bootstrap completed ====="
