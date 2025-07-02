#!/bin/bash

set -e

if [ "$EUID" -ne 0 ]; then
  echo "Please run as root."
  exit 1
fi

SCRIPT_URL="https://raw.githubusercontent.com/KingColton1/docker-mc-server-restarter/main/mc-restart.sh"
SCRIPT_PATH="/opt/mc-restart.sh"
CRON_LINE="0 0 * * * $SCRIPT_PATH >> /var/log/mc-restart.log 2>&1"

echo "[INFO] Downloading mc-restart.sh from $SCRIPT_URL..."
wget -O "$SCRIPT_PATH" "$SCRIPT_URL"

if [ $? -ne 0 ]; then
    echo "[ERROR] Failed to download script. Aborting."
    exit 1
fi

echo "[INFO] Making the script executable..."
chmod +x "$SCRIPT_PATH"

if [ ! -f /var/log/mc-restart.log ]; then
  touch /var/log/mc-restart.log
  chmod 644 /var/log/mc-restart.log
fi

echo "[INFO] Checking if cron job already exists..."
CRONTAB_TMP=$(mktemp)
crontab -l > "$CRONTAB_TMP" 2>/dev/null || true

if grep -Fq "$SCRIPT_PATH" "$CRONTAB_TMP"; then
    echo "[INFO] Cron job already exists. Skipping."
else
    echo "[INFO] Adding new cron job..."
    echo "$CRON_LINE" >> "$CRONTAB_TMP"
    crontab "$CRONTAB_TMP"
fi

rm "$CRONTAB_TMP"
echo "[INFO] Done. Restart will now run daily at midnight."
