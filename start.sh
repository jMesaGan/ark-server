#!/bin/bash
set -e

if ! docker info > /dev/null 2>&1; then
  echo "ERROR: Docker is not running."
  exit 1
fi

if [ ! -f .env ]; then
  echo "ERROR: .env file not found. Copy .env.example to .env and fill in your values."
  exit 1
fi

mkdir -p data backups

echo ">>> Starting ARK server..."
docker compose --env-file .env up -d

echo ""
echo ">>> Server started! First run downloads ~30 GB — follow logs with:"
echo "    docker logs -f ark_server"
