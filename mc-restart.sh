#!/bin/bash

echo "[$(date)] Scheduled restart initiated..."

# 5 minute warning
docker exec root-mc-1 rcon-cli say "Server will restart in 5 minutes."
sleep 4m

# 1 minute warning
docker exec root-mc-1 rcon-cli say "Server will restart in 1 minute."
sleep 50

# Try to save world with retries
MAX_RETRIES=3
RETRY_DELAY=10
SAVE_SUCCESS=0

for i in $(seq 1 $MAX_RETRIES); do
    echo "[$(date)] Attempt $i: Saving world..."
    SAVE_OUTPUT=$(docker exec root-mc-1 rcon-cli save-all)
    echo "Save Output: $SAVE_OUTPUT"

    if echo "$SAVE_OUTPUT" | grep -qi "Saved the game"; then
        SAVE_SUCCESS=1
        echo "[$(date)] World saved successfully on attempt $i."
        break
    else
        echo "[$(date)] Save failed on attempt $i."
        if [ "$i" -lt "$MAX_RETRIES" ]; then
            echo "Retrying in $RETRY_DELAY seconds..."
            sleep $RETRY_DELAY
        fi
    fi
done

if [ "$SAVE_SUCCESS" -ne 1 ]; then
    echo "[$(date)] ERROR: World save failed after $MAX_RETRIES attempts. Restart canceled."
    docker exec root-mc-1 rcon-cli say "WARNING: World save failed. Restart canceled."
    exit 1
fi

docker exec root-mc-1 rcon-cli save-off
sleep 2
docker exec root-mc-1 rcon-cli save-on
sleep 10

docker restart root-mc-1
echo "[$(date)] Restart complete."
