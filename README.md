# ARK Survival Evolved — Dockerized Server

Run your own ARK: Survival Evolved dedicated server using Docker on Windows (via WSL2).

> **Mac / Linux users:** The ARK server binary is x86_64 only. It does not work reliably on Apple Silicon (ARM) via emulation. A Linux x86_64 VPS is recommended for non-Windows hosts.

---

## Requirements

- Windows 10/11 with **WSL2** enabled
- **Docker Desktop** with WSL2 backend enabled

### Install WSL2

```powershell
# Run in PowerShell as Administrator
wsl --install
```

### Install Docker Desktop

Download from [docker.com](https://www.docker.com/products/docker-desktop/) and enable the WSL2 backend during setup.

---

## Setup

**All commands must be run inside a WSL terminal, not PowerShell or CMD.**

### 1. Clone the repo inside WSL

```bash
# Important: clone inside WSL filesystem, NOT inside /mnt/c/...
cd ~
git clone https://github.com/jMesaGan/ark-server.git
cd ark-server
```

### 2. Configure your server

```bash
cp .env.example .env
nano .env   # or use any text editor
```

Edit the values in `.env`:

| Variable | Description |
|---|---|
| `SESSION_NAME` | Server name visible in the game browser |
| `SERVER_MAP` | Map to play (`TheIsland`, `Ragnarok`, `Aberration`, etc.) |
| `SERVER_PASSWORD` | Password to join (leave empty for public) |
| `ADMIN_PASSWORD` | Password for in-game admin console |
| `MAX_PLAYERS` | Max number of players |
| `GAME_MOD_IDS` | Comma-separated Steam Workshop mod IDs |
| `UPDATE_ON_START` | Auto-update ARK on each container start (`true`/`false`) |
| `BACKUP_ON_STOP` | Create a backup when the server stops (`true`/`false`) |

### 3. Start the server

```bash
chmod +x start.sh
./start.sh
```

First run downloads ARK (~30 GB) — this will take a while. Follow the progress with:

```bash
docker logs -f ark_server
```

---

## Connecting to the server

Once the server is running, players can connect via:

- **Direct connect** in ARK: use your machine's local IP + port `7777`
- To allow friends over the internet, **forward these ports** on your router:

| Port | Protocol | Purpose |
|---|---|---|
| 7777 | UDP | Game client |
| 7778 | UDP | Raw UDP socket |
| 27015 | UDP | Steam server list |
| 27020 | TCP | RCON (admin remote access) |

---

## Managing the server

```bash
# Check server status
docker exec ark_server arkmanager status

# Force update
docker exec ark_server arkmanager update --force

# Reinstall mods
docker exec ark_server arkmanager installmods

# Stop gracefully (triggers backup if BACKUP_ON_STOP=true)
docker compose down

# Restart
docker compose --env-file .env up -d
```

---

## File locations

Inside the container:

| Path | Contents |
|---|---|
| `/app/server/ShooterGame/Saved/Config/LinuxServer/GameUserSettings.ini` | Main server settings |
| `/app/server/ShooterGame/Saved/Config/LinuxServer/Game.ini` | Advanced game settings |

On your host (inside WSL):

| Path | Contents |
|---|---|
| `~/ark-server/data/` | Server files |
| `~/ark-server/backups/` | Backups |

---

## Available maps

`TheIsland` · `TheCenter` · `ScorchedEarth_P` · `Ragnarok` · `Aberration_P` · `Extinction` · `Valguero_P` · `CrystalIsles` · `Gen2` · `LostIsland` · `Fjordur`

---

## Credits

Built on top of [hermsi/ark-server](https://github.com/Hermsi1337/docker-ark-server).
