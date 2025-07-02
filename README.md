# docker-mc-server-restarter
Automatically install and configure restart job using bash, cron, and Docker commands for your Minecraft server running in a Docker container. Made for my servers I run using Docker (itzg/minecraft-server).

Must have RCON enabled and configured to use this as it send commands. Currently hardcoded for `root-mc-1` as container name assuming that is your first and only Minecraft server running in your server. Please check `mc-restart.sh` before use.

Use this one-line installer (must be root or have sudo access):
```bash
sudo bash <(wget -qO- https://raw.githubusercontent.com/KingColton1/docker-mc-server-restarter/main/install-restarter.sh)
```
