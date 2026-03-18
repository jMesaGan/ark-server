#!/bin/bash
set -e

for arg in "$@"; do
  case $arg in
    --help)
      echo "Usage: ./start.sh"
      echo ""
      echo "Starts the ARK Survival Evolved Docker server."
      echo "Must be run from inside WSL on Windows."
      exit 0
      ;;
  esac
done

# Check Docker is running
if ! docker info > /dev/null 2>&1; then
  echo "ERROR: Docker is not running. Please start Docker Desktop and try again."
  exit 1
fi

# Check .env exists
if [ ! -f .env ]; then
  echo "ERROR: .env file not found."
  echo "Copy .env.example to .env and fill in your values:"
  echo "  cp .env.example .env"
  exit 1
fi

# Warn if running from a Windows-mounted filesystem (/mnt/c, /mnt/d, etc.)
CURRENT_PATH=$(pwd)
if echo "$CURRENT_PATH" | grep -q "^/mnt/"; then
  echo ""
  echo "WARNING: You are running from a Windows filesystem ($CURRENT_PATH)."
  echo "This will cause the ARK install to be extremely slow or get stuck."
  echo ""
  echo "Please move this folder inside WSL's filesystem, for example:"
  echo "  cp -r $CURRENT_PATH ~/ark-server"
  echo "  cd ~/ark-server"
  echo "  ./start.sh"
  echo ""
  exit 1
fi

echo ">>> Starting ARK server..."
docker compose --env-file .env up -d

echo ""
echo ">>> Server started! Follow logs with:"
echo "    docker logs -f ark_server"
echo ""
echo ">>> First run will take a while — ARK downloads ~30 GB."
