#!/bin/bash

set -e

LOG_FILE="/var/log/nexus-bootstrap.log"

exec > >(tee -a "$LOG_FILE") 2>&1

echo "=========================================="
echo "Nexus Bootstrap Started"
echo "=========================================="

# ------------------------------------------------------------
# System packages
# ------------------------------------------------------------

dnf update -y --allowerasing

dnf install -y \
  wget \
  unzip \
  tar \
  git \
  nvme-cli

# ------------------------------------------------------------
# Create Nexus user
# ------------------------------------------------------------

id nexus &>/dev/null || useradd --system --create-home nexus

# ------------------------------------------------------------
# Identify attached EBS data volume
# ------------------------------------------------------------

ROOT_DEVICE=$(findmnt -n -o SOURCE /)

ROOT_DISK=$(lsblk -no PKNAME "$ROOT_DEVICE" | head -n 1)

DATA_DEVICE=""

for DEVICE in $(lsblk -dpno NAME,TYPE | awk '$2=="disk"{print $1}'); do

    DEVICE_NAME=$(basename "$DEVICE")

    if [[ "$DEVICE_NAME" != "$ROOT_DISK" ]]; then
        DATA_DEVICE="$DEVICE"
        break
    fi

done

if [ -z "$DATA_DEVICE" ]; then
    echo "ERROR: Nexus data volume was not found."
    exit 1
fi

echo "Nexus data device: $DATA_DEVICE"

# ------------------------------------------------------------
# Format only if filesystem does not exist
# ------------------------------------------------------------

if ! blkid "$DATA_DEVICE" >/dev/null 2>&1; then
    echo "Formatting Nexus data volume..."
    mkfs.xfs "$DATA_DEVICE"
fi

# ------------------------------------------------------------
# Mount Nexus data volume
# ------------------------------------------------------------

mkdir -p /nexus-data

UUID=$(blkid -s UUID -o value "$DATA_DEVICE")

if ! grep -q "$UUID" /etc/fstab; then
    echo "UUID=$UUID /nexus-data xfs defaults,nofail 0 2" >> /etc/fstab
fi

mount -a

# Verify mount
if ! mountpoint -q /nexus-data; then
    echo "ERROR: /nexus-data is not mounted."
    exit 1
fi

echo "Nexus data volume mounted successfully."

# ------------------------------------------------------------
# Download Nexus Repository
# ------------------------------------------------------------

NEXUS_VERSION="3.96.0-09"

cd /opt

NEXUS_ARCHIVE="nexus-${NEXUS_VERSION}-linux-x86_64.tar.gz"
NEXUS_DIR="/opt/nexus-${NEXUS_VERSION}"

if [ ! -d "$NEXUS_DIR" ]; then

    echo "Downloading Nexus ${NEXUS_VERSION}..."

    wget \
      "https://download.sonatype.com/nexus/3/${NEXUS_ARCHIVE}" \
      -O "/tmp/${NEXUS_ARCHIVE}"

    if [ ! -s "/tmp/${NEXUS_ARCHIVE}" ]; then
        echo "ERROR: Nexus download failed or archive is empty."
        exit 1
    fi

    echo "Extracting Nexus..."

    tar xzf "/tmp/${NEXUS_ARCHIVE}" -C /opt

    rm -f "/tmp/${NEXUS_ARCHIVE}"

fi

ln -sfn "$NEXUS_DIR" /opt/nexus

# ------------------------------------------------------------
# Configure Nexus user
# ------------------------------------------------------------

chown -R nexus:nexus "$NEXUS_DIR"

chown -R nexus:nexus /nexus-data

# ------------------------------------------------------------
# Configure Nexus data directory
# ------------------------------------------------------------

mkdir -p \
  /nexus-data/log \
  /nexus-data/tmp \
  /nexus-data/instances

chown -R nexus:nexus /nexus-data

# ------------------------------------------------------------
# Nexus VM options
# ------------------------------------------------------------

cat > /opt/nexus/bin/nexus.vmoptions <<'EOF'
-Xms1200m
-Xmx1200m
-XX:MaxDirectMemorySize=2g
-XX:+UnlockDiagnosticVMOptions
-XX:+LogVMOutput
-XX:LogFile=/nexus-data/log/jvm.log
-Djava.net.preferIPv4Stack=true
-Dkaraf.home=/opt/nexus
-Dkaraf.base=/opt/nexus
-Dkaraf.data=/nexus-data
-Djava.io.tmpdir=/nexus-data/tmp
-Dkaraf.instances=/nexus-data/instances
EOF

chown nexus:nexus /opt/nexus/bin/nexus.vmoptions

# ------------------------------------------------------------
# Nexus environment
# ------------------------------------------------------------

cat > /etc/profile.d/nexus.sh <<'EOF'
export NEXUS_HOME=/opt/nexus
export NEXUS_DATA=/nexus-data
EOF

# ------------------------------------------------------------
# Systemd service
# ------------------------------------------------------------

cat > /etc/systemd/system/nexus.service <<'EOF'
[Unit]
Description=Nexus Repository
After=network.target

[Service]
Type=forking

User=nexus
Group=nexus

LimitNOFILE=65536

ExecStart=/opt/nexus/bin/nexus start
ExecStop=/opt/nexus/bin/nexus stop

Restart=on-abnormal

[Install]
WantedBy=multi-user.target
EOF

# ------------------------------------------------------------
# Start Nexus
# ------------------------------------------------------------

systemctl daemon-reload

systemctl enable nexus

systemctl start nexus

echo "=========================================="
echo "Nexus Bootstrap Completed"
echo "=========================================="

systemctl status nexus --no-pager || true
