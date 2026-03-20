# Run with: powershell -ExecutionPolicy Bypass -File setup-local.ps1

# ── Check Docker ──────────────────────────────────────────────────────────────
if (-not (Get-Command docker -ErrorAction SilentlyContinue)) {
    Write-Host "ERROR: Docker not found." -ForegroundColor Red
    Write-Host "  Install Docker Desktop from: https://www.docker.com/products/docker-desktop"
    Write-Host "  After installing, restart your PC and run this script again."
    exit 1
}

try {
    docker info 2>&1 | Out-Null
    if ($LASTEXITCODE -ne 0) { throw }
} catch {
    Write-Host "ERROR: Docker is not running." -ForegroundColor Red
    Write-Host "  Open Docker Desktop from the Start Menu and wait for it to fully start, then try again."
    exit 1
}

# ── .env check ────────────────────────────────────────────────────────────────
if (-not (Test-Path ".env")) {
    Copy-Item ".env.example" ".env"
    Write-Host ""
    Write-Host ">>> .env created from .env.example." -ForegroundColor Yellow
    Write-Host "    Edit it to set your server name, passwords, map, etc."
    Write-Host ""
    Write-Host "    Opening in Notepad..." -ForegroundColor Cyan
    Start-Process notepad ".env" -Wait
    Write-Host ""
    Write-Host "    Re-run this script when done." -ForegroundColor Yellow
    exit 0
}

# ── Create folders & start ─────────────────────────────────────────────────────
New-Item -ItemType Directory -Force -Path "data", "backups" | Out-Null

Write-Host ">>> Starting ARK server..." -ForegroundColor Cyan
docker compose --env-file .env up -d

Write-Host ""
Write-Host ">>> Server started! First run downloads ~30 GB." -ForegroundColor Green
Write-Host "    Follow logs with:  docker logs -f ark_server"
Write-Host ""
Write-Host ">>> Your LAN IP (share this with friends on the same network):" -ForegroundColor Cyan
$lanIP = (Get-NetIPAddress -AddressFamily IPv4 |
          Where-Object { $_.InterfaceAlias -notmatch "Loopback|vEthernet" -and $_.IPAddress -notmatch "^169" } |
          Select-Object -First 1).IPAddress
Write-Host "    $lanIP"
Write-Host ""
Write-Host ">>> To let friends connect FROM THE INTERNET, forward these ports on your router:" -ForegroundColor Yellow
Write-Host "    7777  UDP  - game client"
Write-Host "    7778  UDP  - raw UDP socket"
Write-Host "    27015 UDP  - Steam server list"
Write-Host "    27020 TCP  - RCON (optional)"
