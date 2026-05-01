# Frontend-Backend Connection Setup Guide

## 📋 Overview

This guide explains how to properly connect your React (Vite) frontend to your Node.js/Express backend in both local development and production environments.

---

## 🏗️ Architecture

```
┌─────────────────────────────────────────────────────────────┐
│ Frontend (React + Vite)                                      │
│ http://localhost:3000                                       │
│ ├── Uses: VITE_API_URL environment variable                │
│ └── Makes requests to: http://localhost:4000/api/*         │
└────────────────────────┬────────────────────────────────────┘
                         │
                    HTTP/CORS
                         │
┌────────────────────────▼────────────────────────────────────┐
│ Backend (Express + Node.js)                                  │
│ http://localhost:4000                                        │
│ ├── Routes: /api/products, /api/dashboard, etc.            │
│ ├── CORS: Allows http://localhost:3000                      │
│ └── WebSocket: socket.io on same port                       │
└─────────────────────────────────────────────────────────────┘
```

---

## 🚀 Quick Start (Local Development)

### Step 1: Start Backend Server

```bash
cd server
npm install
npm start
```

**Expected Output:**
```
═══════════════════════════════════════════════════════
🚀 Server running on port 4000
🌐 Backend URL: http://localhost:4000
📡 API Endpoints: http://localhost:4000/api/*
═══════════════════════════════════════════════════════
✅ Environment:
   NODE_ENV: development
   PORT: 4000

✅ CORS Allowed Origins:
   - http://localhost:3000
   - http://localhost:5173
   - http://127.0.0.1:3000
   - http://127.0.0.1:5173
```

### Step 2: Start Frontend Server

```bash
cd client
npm install
npm run dev
```

**Expected Output:**
```
  VITE v4.x.x  build 1234567890ab

  ➜  Local:   http://localhost:3000/
  ➜  press h to show help

🔗 API Base URL: http://localhost:4000/api
🔗 Full API URL: http://localhost:4000
```

### Step 3: Test the Connection

Open browser console (F12) and look for:
```
📤 API Request: GET http://localhost:4000/api/products
📥 API Response: 200 from http://localhost:4000/api/products
```

---

## 🔧 Environment Configuration

### Frontend (.env files)

**`.env.development`** (Local development)
```env
# Used when running: npm run dev
VITE_API_URL=http://localhost:4000
```

**`.env.production`** (Production build)
```env
# Used during build and in production
VITE_API_URL=https://ravi-maligai.onrender.com
```

### Backend (.env file)

**`.env`** (All environments)
```env
# MongoDB Connection
MONGO_URI=mongodb://localhost:27017/grocery-ims

# Server Port
PORT=4000

# Node Environment
NODE_ENV=development

# Frontend URL for CORS (production only)
FRONTEND_URL=https://your-frontend-domain.com
```

---

## 📡 API Configuration (`client/src/api.js`)

### Key Points:

1. **Base URL Construction**
   ```javascript
   const API_URL = import.meta.env.VITE_API_URL || 'http://localhost:4000';
   const BASE_URL = `${API_URL}/api`;
   ```

2. **Axios Instance**
   ```javascript
   const apiClient = axios.create({
     baseURL: BASE_URL,
     withCredentials: true,  // For cookies/sessions
     timeout: 10000,          // 10 second timeout
   });
   ```

3. **Interceptors** (for debugging)
   - Request logging: Shows what's being sent
   - Response logging: Shows what's received
   - Error logging: Shows exact failure reason

4. **Error Handling**
   - Network errors → Shows backend URL and troubleshooting steps
   - Server errors → Shows exact status and message
   - Request errors → Shows configuration issues

---

## 🔒 CORS Configuration (Backend)

### What is CORS?

**CORS (Cross-Origin Resource Sharing)** allows frontend and backend on different domains/ports to communicate.

### Current Configuration (Automatic)

The backend automatically allows:
- `http://localhost:3000` (Your frontend)
- `http://localhost:5173` (Vite default port)
- `http://127.0.0.1:3000` & `http://127.0.0.1:5173` (Local IP)
- `process.env.FRONTEND_URL` (Production URL if set)

### Production Setup

For production (e.g., Render):

**Backend (.env)**
```env
FRONTEND_URL=https://your-netlify-site.netlify.app
```

This will automatically add your frontend to allowed origins.

---

## 🧪 Troubleshooting Guide

### Error: "Network error. Please check your connection."

#### 1️⃣ Check Backend is Running

```bash
# In a new terminal
curl http://localhost:4000
```

Expected response:
```
🚀 API is running successfully
```

If you get connection refused:
```bash
# Start the backend
cd server && npm start
```

#### 2️⃣ Check Port Number

In `server/.env`:
```env
PORT=4000  # ✅ Must be 4000 (or whatever you set)
```

In `client/.env.development`:
```env
VITE_API_URL=http://localhost:4000  # ✅ Must match backend port
```

#### 3️⃣ Check Browser Console

Open DevTools (F12) → Console tab

Look for these logs:
```
🔗 API Base URL: http://localhost:4000/api
🔗 Full API URL: http://localhost:4000
📤 API Request: GET /products
```

If you see network errors:
```
❌ Network Error: {
  message: "Network Error",
  url: "http://localhost:4000/api/products",
  baseURL: "http://localhost:4000/api"
}
⚠️ Troubleshooting:
   1. Is backend running on http://localhost:4000?
   2. Check CORS configuration on backend
   3. Check browser console for more details
```

#### 4️⃣ Check CORS Headers

In browser DevTools → Network tab → Click any API request:

**Response Headers should include:**
```
Access-Control-Allow-Origin: http://localhost:3000
Access-Control-Allow-Credentials: true
```

If missing, backend CORS isn't configured.

#### 5️⃣ Check Firewall

Ensure port 4000 isn't blocked:
```bash
# Windows
netstat -ano | findstr :4000

# macOS/Linux
lsof -i :4000
```

---

## 🚢 Production Deployment

### On Render (Backend)

1. **Create .env for production:**
   ```env
   MONGO_URI=mongodb+srv://user:pass@cluster.mongodb.net/db
   PORT=4000
   NODE_ENV=production
   FRONTEND_URL=https://your-frontend-url.netlify.app
   ```

2. **Backend will be at:**
   ```
   https://ravi-maligai.onrender.com
   ```

### On Netlify (Frontend)

1. **Create .env.production:**
   ```env
   VITE_API_URL=https://ravi-maligai.onrender.com
   ```

2. **Build and deploy:**
   ```bash
   npm run build
   # Deploy dist/ folder to Netlify
   ```

3. **Test with:**
   ```
   https://your-site.netlify.app
   ```

---

## 🔍 API Endpoints Reference

All endpoints are prefixed with `/api`:

| Endpoint | Method | Purpose |
|----------|--------|---------|
| `/api/products` | GET | Fetch all products |
| `/api/products` | POST | Create product |
| `/api/products/:id` | PUT | Update product |
| `/api/products/:id` | DELETE | Delete product |
| `/api/dashboard/stats` | GET | Dashboard stats |
| `/api/cart/checkout` | POST | Checkout |
| `/api/invoices/:id/pdf` | GET | Invoice PDF |
| `/api/sales/history` | GET | Sales history |
| `/api/reports/sales` | GET | Sales reports |

---

## 🐛 Common Issues & Solutions

### Issue 1: ECONNREFUSED

**Error:**
```
Error: connect ECONNREFUSED 127.0.0.1:4000
```

**Solution:**
1. Check backend is running: `npm start` in `server/` directory
2. Check PORT in `server/.env` is 4000
3. Check no other process is using port 4000

### Issue 2: CORS Error in Browser

**Error:**
```
Access to XMLHttpRequest blocked by CORS policy
```

**Solution:**
1. Check backend CORS config includes your frontend URL
2. Restart backend server after changing CORS
3. Clear browser cache (Ctrl+Shift+Delete)

### Issue 3: 404 Not Found on API Routes

**Error:**
```
GET http://localhost:4000/api/products 404 Not Found
```

**Solution:**
1. Check backend routes are defined in `server/index.js`
2. Check route files exist in `server/routes/`
3. Restart backend server

### Issue 4: Timeout on Requests

**Error:**
```
Error: timeout of 10000ms exceeded
```

**Solution:**
1. Backend is too slow or not responding
2. Check MongoDB connection
3. Check for errors in backend console
4. Increase timeout in `client/src/api.js`: `timeout: 20000`

---

## ✅ Verification Checklist

- [ ] Backend running: `curl http://localhost:4000` → Success
- [ ] Port 4000 configured in `server/.env`
- [ ] `VITE_API_URL=http://localhost:4000` in `client/.env.development`
- [ ] Browser shows API logs in console
- [ ] No CORS errors in DevTools
- [ ] Can fetch data from `/api/products` endpoint
- [ ] Production URLs configured for deployment
- [ ] FRONTEND_URL set in backend .env for production

---

## 📚 Additional Resources

- [Axios Documentation](https://axios-http.com/)
- [CORS Explained](https://developer.mozilla.org/en-US/docs/Web/HTTP/CORS)
- [Express Middleware](https://expressjs.com/en/guide/using-middleware.html)
- [Vite Environment Variables](https://vitejs.dev/guide/env-and-mode.html)
- [Socket.IO CORS](https://socket.io/docs/v4/handling-cors/)

---

## 🆘 Still Having Issues?

1. **Check browser console (F12)** for exact error message
2. **Check backend terminal** for error logs
3. **Verify all URLs match** across files
4. **Restart both servers** (backend then frontend)
5. **Clear browser cache** (Ctrl+Shift+Delete)
6. **Use curl to test backend:**
   ```bash
   curl -X GET http://localhost:4000/api/products
   ```

