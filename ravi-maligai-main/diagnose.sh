#!/bin/bash
# Frontend-Backend Connection Diagnostic Script
# Run this to verify your setup is correct

echo ""
echo "═══════════════════════════════════════════════════════════════"
echo "🔍 Frontend-Backend Connection Diagnostic"
echo "═══════════════════════════════════════════════════════════════"
echo ""

# Check Backend
echo "1️⃣  Testing Backend Server..."
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

if curl -s http://localhost:4000 > /dev/null 2>&1; then
    echo "✅ Backend is running on http://localhost:4000"
    echo "   Response:"
    curl -s http://localhost:4000
    echo ""
else
    echo "❌ Backend is NOT running on http://localhost:4000"
    echo "   Fix: Run 'cd server && npm start' in a new terminal"
    echo ""
fi

# Check Backend API
echo "2️⃣  Testing Backend API Endpoints..."
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

if curl -s http://localhost:4000/api/products > /dev/null 2>&1; then
    echo "✅ /api/products endpoint is working"
else
    echo "❌ /api/products endpoint not responding"
    echo "   Make sure backend routes are configured"
fi
echo ""

# Check Frontend
echo "3️⃣  Testing Frontend Server..."
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

if curl -s http://localhost:3000 > /dev/null 2>&1; then
    echo "✅ Frontend is running on http://localhost:3000"
else
    echo "⚠️  Frontend is NOT running on http://localhost:3000"
    echo "   Fix: Run 'cd client && npm run dev' in a new terminal"
fi
echo ""

# Check Environment Variables
echo "4️⃣  Environment Configuration..."
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

if [ -f "server/.env" ]; then
    echo "✅ Backend .env file exists"
    grep "PORT=" server/.env || echo "⚠️  PORT not defined (will default to 4000)"
else
    echo "❌ Backend .env file not found"
fi

if [ -f "client/.env.development" ]; then
    echo "✅ Frontend .env.development file exists"
    cat client/.env.development | grep "VITE_API_URL"
else
    echo "❌ Frontend .env.development file not found"
fi
echo ""

# Port Check
echo "5️⃣  Checking if ports are available..."
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

if command -v lsof &> /dev/null; then
    if lsof -i :4000 > /dev/null 2>&1; then
        echo "✅ Port 4000 is in use (good!)"
    else
        echo "⚠️  Port 4000 is not in use - backend might not be running"
    fi
    
    if lsof -i :3000 > /dev/null 2>&1; then
        echo "✅ Port 3000 is in use (good!)"
    else
        echo "⚠️  Port 3000 is not in use - frontend might not be running"
    fi
else
    echo "ℹ️  lsof not available - skipping port check"
fi
echo ""

# Summary
echo "═══════════════════════════════════════════════════════════════"
echo "📋 Summary"
echo "═══════════════════════════════════════════════════════════════"
echo ""
echo "✅ If both frontend and backend are running:"
echo "   1. Open http://localhost:3000 in your browser"
echo "   2. Open DevTools (F12) and check Console tab"
echo "   3. You should see API request logs"
echo ""
echo "❌ If backend is not running:"
echo "   cd server && npm start"
echo ""
echo "❌ If frontend is not running:"
echo "   cd client && npm run dev"
echo ""
echo "🔗 Backend URL must match in:"
echo "   - client/.env.development: VITE_API_URL=http://localhost:4000"
echo "   - server/.env: PORT=4000"
echo ""
