# Netlify Deployment Guide for Vite React Frontend

## ✅ Configuration Complete

Your Netlify deployment is configured to deploy **only the frontend** to Netlify while connecting to your backend on Render.

**Frontend**: Netlify  
**Backend**: https://ravi-maligai.onrender.com

## 📋 Configuration Files

### 1. `netlify.toml` (Root Directory)
```toml
[build]
  base = "client"              # Frontend app location
  command = "npm run build"    # Vite build command
  publish = "dist"             # Output folder (relative to base)

[build.environment]
  NODE_VERSION = "18"
  NODE_ENV = "production"
```

**What This Does**:
- ✅ Tells Netlify the frontend is in the `client/` folder
- ✅ Runs `npm run build` from inside `client/`
- ✅ Publishes the `client/dist/` folder (shown as just `dist` since base is `client`)
- ✅ Overrides any incorrect Netlify UI settings

### 2. `.env.production` (Client Folder)
```
VITE_API_URL=https://ravi-maligai.onrender.com
```

**What This Does**:
- ✅ Sets the backend URL during the production build
- ✅ Vite loads this automatically when `npm run build` runs
- ✅ Your app will connect to Render backend in production

### 3. `.env.development` (Client Folder)
```
VITE_API_URL=http://localhost:4000
```

**What This Does**:
- ✅ Used when you run `npm run dev` locally
- ✅ Connects to local backend for development

### 4. `_redirects` (Client/Public Folder)
```
/*  /index.html  200
```

**What This Does**:
- ✅ Backup SPA routing configuration
- ✅ Ensures React Router works on all paths
- ✅ Deployed to your Netlify site automatically

## 🚀 Deployment Steps

### Step 1: Push Configuration to GitHub
```bash
git add netlify.toml client/.env.production client/.env.development client/public/_redirects
git commit -m "Configure Netlify deployment for Vite React frontend"
git push origin main
```

### Step 2: Connect Repository to Netlify (If Not Already Connected)

1. Go to [netlify.com](https://netlify.com)
2. Click **"Add new site"** → **"Import an existing project"**
3. Choose **GitHub** and authorize
4. Select your repository: `ravi-maligai-main`
5. Netlify will auto-detect `netlify.toml` settings
6. Click **"Deploy site"**

### Step 3: Verify Deployment

1. Wait for the build to complete (usually 1-2 minutes)
2. Check the **Deploys** section in Netlify dashboard
3. Once successful, your site will be live at the provided URL

### Step 4: Test the Frontend

1. Open your Netlify site URL in a browser
2. Check the browser console (F12 → Console)
3. Verify no errors appear
4. Test API calls - they should connect to `https://ravi-maligai.onrender.com`

## ✨ How the Deployment Works

```
┌─────────────────────────────────────────┐
│  GitHub Repository                      │
│  ├── netlify.toml (root)               │
│  └── client/                            │
│      ├── .env.production                │
│      ├── public/_redirects              │
│      ├── package.json                   │
│      ├── vite.config.js                 │
│      └── src/                           │
└─────────────────────────────────────────┘
                    ↓
         Netlify detects change
                    ↓
┌─────────────────────────────────────────┐
│  Netlify Build Process                  │
│  1. Read netlify.toml                   │
│  2. cd client/                          │
│  3. npm install                         │
│  4. npm run build                       │
│  5. Load .env.production                │
│  6. Output: client/dist/                │
│  7. Apply _redirects rules              │
└─────────────────────────────────────────┘
                    ↓
         Site Published ✅
                    ↓
┌─────────────────────────────────────────┐
│  Your Netlify Site                      │
│  Serves: dist/ folder                   │
│  Connects to: Render Backend            │
│  All routes → /index.html (React)       │
└─────────────────────────────────────────┘
```

## 🔄 Understanding Environment Variables

### How `.env.production` is Used

1. **Build Time**: Netlify runs `npm run build`
2. **Vite Processing**: Vite reads `.env.production`
3. **API URL Replacement**: `import.meta.env.VITE_API_URL` becomes `https://ravi-maligai.onrender.com`
4. **Build Output**: `dist/` folder contains the API URL hardcoded in the build

### Your Code (api.js)
```javascript
const API_URL = import.meta.env.VITE_API_URL || 'http://localhost:4000';
// In production: https://ravi-maligai.onrender.com
// In development: http://localhost:4000
```

## ✅ Verification Checklist

After deployment, verify:

- [ ] Netlify shows "Deploy successful" in dashboard
- [ ] Site loads without errors
- [ ] Page refresh works (no blank page)
- [ ] React Router navigation works
- [ ] API calls connect to `https://ravi-maligai.onrender.com`
- [ ] Assets are cached correctly (DevTools → Network)

## 🔍 Troubleshooting

### Issue: Build Fails
**Solution**: 
- Check Netlify build logs (Deploy → Logs)
- Ensure `client/package.json` has all dependencies
- Run `npm install && npm run build` locally in `client/` folder to verify

### Issue: Blank Page on Refresh
**Solution**:
- Verify `netlify.toml` has the redirect rule
- Check `client/public/_redirects` exists
- Clear browser cache (Ctrl+Shift+Del)

### Issue: API Calls Return 404
**Solution**:
- Verify `.env.production` has correct backend URL
- Check backend (https://ravi-maligai.onrender.com) is running
- Check browser console for actual API URL being used

### Issue: Still Using Netlify UI Settings
**Solution**:
- Go to **Site Settings → Build & Deploy → Build command**
- Clear any manually set values
- Commit and push to trigger a new build
- Netlify will now read `netlify.toml`

## 📝 File Summary

| File | Location | Purpose |
|------|----------|---------|
| `netlify.toml` | Root | Build config (base, command, publish, env vars) |
| `.env.production` | `client/` | Production API URL |
| `.env.development` | `client/` | Development API URL |
| `_redirects` | `client/public/` | SPA routing backup |

## 🚀 Future Updates

If you need to change the backend URL:
1. Edit `.env.production` with new URL
2. Commit and push to GitHub
3. Netlify auto-deploys - no manual configuration needed

## 📚 Resources

- [Netlify Configuration Reference](https://docs.netlify.com/configure-builds/file-based-configuration/)
- [Vite Environment Variables](https://vitejs.dev/guide/env-and-mode.html)
- [Netlify SPA Routing](https://docs.netlify.com/routing/overview/)

