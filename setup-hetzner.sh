#!/bin/bash
set -e

echo ">>> Installing Docker..."
curl -fsSL https://get.docker.com | sh
systemctl enable docker
systemctl start docker

if [ ! -f .env ]; then
  echo "ERROR: .env file not found. Copy .env.example to .env and fill in your values:"
  echo "  cp .env.example .env && nano .env"
  exit 1
fi

bash start.sh

echo ""
echo ">>> Make sure these ports are open in your Hetzner firewall:"
echo "    7777 UDP  — game client"
echo "    7778 UDP  — raw UDP socket"
echo "    27015 UDP — Steam server list"
echo "    27020 TCP — RCON"
