#!/bin/bash
set -e

WINDOWS=false

for arg in "$@"; do
  case $arg in
    --windows) WINDOWS=true ;;
    --help)
      echo "Usage: ./start.sh [--windows]"
      echo ""
      echo "  --windows   Run from WSL on Windows (validates WSL filesystem paths)"
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
  echo "ERROR: .env file not found. Copy .env.example to .env and fill in your values."
  exit 1
fi

if [ "$WINDOWS" = true ]; then
  echo ">>> Windows / WSL mode"

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
    echo "  ./start.sh --windows"
    echo ""
    exit 1
  fi

  echo ">>> WSL filesystem detected. Good to go."
fi

echo ">>> Starting ARK server..."
docker-compose --env-file .env up -d

echo ""
echo ">>> Server started! Follow logs with:"
echo "    docker logs -f ark_server"
echo ""
echo ">>> ARK will take a while to download (~30 GB) on first run."
