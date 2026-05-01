# ⚡ Netlify Deployment: Quick Fix Checklist

## 🚀 Immediate Action (5 minutes)

### 1. Verify Local Setup ✓
```bash
# Check netlify.toml exists
[ -f netlify.toml ] && echo "✓ netlify.toml found" || echo "✗ Missing"

# Check .env.production exists
[ -f client/.env.production ] && echo "✓ .env.production found" || echo "✗ Missing"

# Test local build
cd client && npm run build && cd ..
echo "✓ Build successful"
```

### 2. Push Configuration to GitHub
```bash
git add netlify.toml client/.env.production client/.env.development client/public/_redirects
git commit -m "Fix Netlify deployment configuration"
git push origin main
```

### 3. Choose Your Fix Path

#### **Path A: Reset Everything (Recommended)**
```bash
# 1. Delete site from Netlify dashboard
# 2. Go to https://app.netlify.com/teams/[your-team]/builds
# 3. Find your site → Site Settings → Danger Zone → Delete Site
# 4. Then reconnect:
# 5. https://app.netlify.com → "Add new site" → "Import an existing project"
# 6. Select GitHub → Select repository
# 7. Click "Deploy site"
```

#### **Path B: Clear Cache (Faster)**
```bash
# 1. Netlify Dashboard → Your Site → Site Settings
# 2. Build & Deploy → Build Environment → Edit settings
# 3. Scroll down → Click "Clear Cache"
# 4. Then trigger rebuild:
#    - Build & Deploy → Deploys → "Trigger deploy" → "Deploy site"
# OR just push to main:
#    - git push origin main
```

### 4. Wait for Build
- Netlify will auto-build when you push
- Check: **Deploys** tab in Netlify dashboard
- Build takes 1-2 minutes
- Status will show: "Published" (success) or "Failed" (error)

### 5. Verify Configuration
Once build succeeds:
```bash
# Open site in browser
# https://your-site.netlify.app

# Check these:
✓ Site loads without errors
✓ Pages work after refresh
✓ API calls show correct backend URL
✓ Console has no errors (F12)
```

---

## ✅ Current Configuration

### `netlify.toml` (Root)
```toml
[build]
  base = "client"
  command = "npm run build"
  publish = "dist"

[build.environment]
  NODE_VERSION = "18"
  NODE_ENV = "production"

[[redirects]]
  from = "/*"
  to = "/index.html"
  status = 200
```

### `client/.env.production`
```
VITE_API_URL=https://ravi-maligai.onrender.com
```

### `client/public/_redirects`
```
/*  /index.html  200
```

---

## 🔍 Verification Commands

### Check if configuration files exist
```bash
# From project root
ls -la netlify.toml
ls -la client/.env.production
ls -la client/public/_redirects
cat client/.env.production
```

### Test the build
```bash
cd client
npm install
npm run build
# Check if dist/ folder created with index.html
ls -la dist/
cd ..
```

### Check GitHub status
```bash
git status
# Should show these files are committed:
# - netlify.toml
# - client/.env.production
# - client/.env.development
# - client/public/_redirects
```

---

## 📊 Expected Netlify Build Output

When build completes, you should see:

```
8:45:40 AM: Build started
8:45:44 AM: Git repo cloned
8:45:50 AM: Installing dependencies
8:45:51 AM: npm install (in /opt/build/repo/client)
8:46:15 AM: npm run build (in /opt/build/repo/client)
8:46:20 AM: ✓ dist/index.html (3.5 kB)
8:46:20 AM: ✓ dist/assets/index-xyz.js (150 kB)
8:46:20 AM: Site will be built as static site
8:46:20 AM: Finished processing build request
8:46:22 AM: Deploy is live!
```

---

## ❌ Common Issues & Quick Fixes

| Issue | Fix |
|-------|-----|
| "Base directory does not exist" | Make sure `base = "client"` in `netlify.toml` |
| Build fails "Cannot find module" | Check `client/package.json` has all dependencies |
| Pages blank on refresh | Verify redirect rule in `netlify.toml` |
| API returns 404 | Check `VITE_API_URL` in `.env.production` |
| Publish directory locked | Delete and reimport repository to Netlify |

---

## 🎯 Status Indicators

### ✅ Success
- Netlify shows "Deploy successful" badge
- Site loads without errors
- React Router works (refresh doesn't 404)
- API calls reach backend

### ⚠️ Issues
- Build log shows errors
- Site shows "Deploy failed"
- Pages blank on refresh
- API calls get 404

---

## 📝 Files Configured

```
ravi-maligai-main/
├── netlify.toml              ✓ (Deployment config)
├── client/
│   ├── .env.production       ✓ (Backend URL)
│   ├── .env.development      ✓ (Local dev URL)
│   ├── package.json          ✓ (Build script)
│   ├── vite.config.js        ✓ (Vite config)
│   ├── public/
│   │   └── _redirects        ✓ (SPA routing)
│   └── src/
│       └── api.js            ✓ (Uses VITE_API_URL)
└── server/                   (Deployed separately)
```

---

## 🚀 Next Steps After Fix

1. **Verify build succeeds** in Netlify dashboard
2. **Test the live site** at your Netlify URL
3. **Check API connectivity** by testing an endpoint
4. **Monitor for errors** in browser console
5. **Set up custom domain** (optional)

---

## 📞 Netlify Dashboard Links

- **View Site**: https://app.netlify.com (logged in)
- **Deploys**: [Your Site] → Deploys
- **Site Settings**: [Your Site] → Site Settings
- **Build & Deploy**: Site Settings → Build & Deploy → Build Settings
- **Environment**: Site Settings → Build & Deploy → Environment

---

**Last Updated**: May 1, 2026  
**Status**: ✅ Ready to Deploy  
**Backend**: https://ravi-maligai.onrender.com  
**Frontend Target**: Netlify

