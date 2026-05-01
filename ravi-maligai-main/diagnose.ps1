# Frontend-Backend Connection Diagnostic Script (Windows PowerShell)
# Run this to verify your setup is correct
# Usage: .\diagnose.ps1

Write-Host ""
Write-Host "═══════════════════════════════════════════════════════════════" -ForegroundColor Cyan
Write-Host "🔍 Frontend-Backend Connection Diagnostic (Windows)" -ForegroundColor Cyan
Write-Host "═══════════════════════════════════════════════════════════════" -ForegroundColor Cyan
Write-Host ""

# Function to test connection
function Test-Connection {
    param(
        [string]$Url,
        [string]$Name
    )
    try {
        $response = Invoke-WebRequest -Uri $Url -UseBasicParsing -TimeoutSec 2 -ErrorAction Stop
        Write-Host "✅ $Name is running on $Url" -ForegroundColor Green
        Write-Host "   Response: $($response.StatusCode) $($response.StatusDescription)" -ForegroundColor Gray
        return $true
    } catch {
        Write-Host "❌ $Name is NOT running on $Url" -ForegroundColor Red
        return $false
    }
}

# Check Backend
Write-Host "1️⃣  Testing Backend Server..." -ForegroundColor Yellow
Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Gray

$backendRunning = Test-Connection -Url "http://localhost:4000" -Name "Backend"

if ($backendRunning) {
    Write-Host "   Fix: Run 'cd server && npm start' in a new terminal" -ForegroundColor Gray
}
Write-Host ""

# Check Backend API
Write-Host "2️⃣  Testing Backend API Endpoints..." -ForegroundColor Yellow
Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Gray

$apiRunning = Test-Connection -Url "http://localhost:4000/api/products" -Name "API Endpoint"
Write-Host ""

# Check Frontend
Write-Host "3️⃣  Testing Frontend Server..." -ForegroundColor Yellow
Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Gray

$frontendRunning = Test-Connection -Url "http://localhost:3000" -Name "Frontend"

if (!$frontendRunning) {
    Write-Host "   Fix: Run 'cd client && npm run dev' in a new terminal" -ForegroundColor Gray
}
Write-Host ""

# Check Environment Variables
Write-Host "4️⃣  Environment Configuration..." -ForegroundColor Yellow
Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Gray

if (Test-Path "server\.env") {
    Write-Host "✅ Backend .env file exists" -ForegroundColor Green
    $portLine = Select-String -Path "server\.env" -Pattern "PORT=" | Select-Object -First 1
    if ($portLine) {
        Write-Host "   $($portLine.Line)" -ForegroundColor Gray
    } else {
        Write-Host "⚠️  PORT not defined (will default to 4000)" -ForegroundColor Yellow
    }
} else {
    Write-Host "❌ Backend .env file not found" -ForegroundColor Red
}

if (Test-Path "client\.env.development") {
    Write-Host "✅ Frontend .env.development file exists" -ForegroundColor Green
    $apiLine = Select-String -Path "client\.env.development" -Pattern "VITE_API_URL=" | Select-Object -First 1
    if ($apiLine) {
        Write-Host "   $($apiLine.Line)" -ForegroundColor Gray
    }
} else {
    Write-Host "❌ Frontend .env.development file not found" -ForegroundColor Red
}
Write-Host ""

# Port Check
Write-Host "5️⃣  Checking if ports are available..." -ForegroundColor Yellow
Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Gray

$port4000 = Get-NetTCPConnection -LocalPort 4000 -ErrorAction SilentlyContinue
if ($port4000) {
    Write-Host "✅ Port 4000 is in use (backend might be running)" -ForegroundColor Green
} else {
    Write-Host "⚠️  Port 4000 is NOT in use - backend might not be running" -ForegroundColor Yellow
}

$port3000 = Get-NetTCPConnection -LocalPort 3000 -ErrorAction SilentlyContinue
if ($port3000) {
    Write-Host "✅ Port 3000 is in use (frontend might be running)" -ForegroundColor Green
} else {
    Write-Host "⚠️  Port 3000 is NOT in use - frontend might not be running" -ForegroundColor Yellow
}
Write-Host ""

# Summary
Write-Host "═══════════════════════════════════════════════════════════════" -ForegroundColor Cyan
Write-Host "📋 Summary" -ForegroundColor Cyan
Write-Host "═══════════════════════════════════════════════════════════════" -ForegroundColor Cyan
Write-Host ""

if ($backendRunning -and $apiRunning) {
    Write-Host "✅ Backend is operational" -ForegroundColor Green
} else {
    Write-Host "❌ Backend issues detected - start with:" -ForegroundColor Red
    Write-Host "   cd server && npm start" -ForegroundColor Yellow
}

if ($frontendRunning) {
    Write-Host "✅ Frontend is operational" -ForegroundColor Green
} else {
    Write-Host "❌ Frontend issues detected - start with:" -ForegroundColor Red
    Write-Host "   cd client && npm run dev" -ForegroundColor Yellow
}

Write-Host ""
Write-Host "🔍 Next Steps:" -ForegroundColor Cyan
Write-Host "   1. Open http://localhost:3000 in your browser" -ForegroundColor Gray
Write-Host "   2. Press F12 to open DevTools → Console tab" -ForegroundColor Gray
Write-Host "   3. Look for green '📤 API Request' and '📥 API Response' logs" -ForegroundColor Gray
Write-Host ""

if (!$backendRunning) {
    Write-Host "🔧 To fix backend:" -ForegroundColor Yellow
    Write-Host "   1. Open a new PowerShell/Command window" -ForegroundColor Gray
    Write-Host "   2. Navigate to server folder: cd server" -ForegroundColor Gray
    Write-Host "   3. Run: npm start" -ForegroundColor Gray
    Write-Host ""
}

if (!$frontendRunning) {
    Write-Host "🔧 To fix frontend:" -ForegroundColor Yellow
    Write-Host "   1. Open a new PowerShell/Command window" -ForegroundColor Gray
    Write-Host "   2. Navigate to client folder: cd client" -ForegroundColor Gray
    Write-Host "   3. Run: npm run dev" -ForegroundColor Gray
    Write-Host ""
}

Write-Host "🔗 Ensure these match:" -ForegroundColor Cyan
Write-Host "   ✓ client/.env.development → VITE_API_URL=http://localhost:4000" -ForegroundColor Gray
Write-Host "   ✓ server/.env → PORT=4000" -ForegroundColor Gray
Write-Host ""
