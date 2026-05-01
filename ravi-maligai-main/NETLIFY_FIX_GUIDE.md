# Netlify Deployment Fix: Complete Guide

## 🔴 Problem: Publish Directory Locked to `client/dist`

You're experiencing a Netlify issue where the **Publish directory is locked** and shows as `client/dist` instead of `dist`.

### Why This Happens
1. **Old UI Settings Override**: Netlify cached old settings from before you added `netlify.toml`
2. **Incorrect Import**: The repository wasn't properly re-imported after `netlify.toml` was created
3. **Build Cache**: Netlify is still using cached configuration from a previous build

### The Solution
We'll fix this by resetting the Netlify project configuration and redeploying with the correct `netlify.toml` settings.

---

## ✅ Solution: Step-by-Step Fix

### Phase 1: Verify Local Configuration

#### Step 1.1: Verify `netlify.toml` exists in repository root
```bash
# From your project root
ls netlify.toml
# Should output: netlify.toml
```

#### Step 1.2: Verify `client/.env.production` exists
```bash
ls client/.env.production
# Should contain: VITE_API_URL=https://ravi-maligai.onrender.com
```

#### Step 1.3: Test build locally
```bash
cd client
npm install
npm run build
# Should create: client/dist/ folder with index.html, assets/, etc.
```

If the build succeeds, proceed to Phase 2.

---

### Phase 2: Fix Netlify Configuration

You have **two options** depending on your situation:

#### **Option A: Recommended - Reset Netlify Project (Complete Fix)**

This is the cleanest solution and ensures Netlify reads your `netlify.toml` correctly.

##### Step 2A.1: Disconnect from Netlify
1. Go to your Netlify dashboard: https://app.netlify.com
2. Select your site (e.g., `ravi-maligai-frontend`)
3. Click **Site Settings** (top menu)
4. Scroll down to **Danger Zone**
5. Click **Delete this site**
6. Confirm by typing the site name

##### Step 2A.2: Push Configuration to GitHub
```bash
# From project root
git add netlify.toml client/.env.production client/.env.development client/public/_redirects
git commit -m "Fix Netlify configuration for MERN stack deployment"
git push origin main
```

##### Step 2A.3: Reconnect Repository to Netlify
1. Go to [netlify.com](https://netlify.com)
2. Click **Add new site** → **Import an existing project**
3. Choose **GitHub** and authorize if needed
4. Select your repository: `ravi-maligai-main`
5. **Important**: Netlify will show deploy settings - DO NOT CHANGE THEM
   - You should see:
     - **Owner**: (your GitHub username)
     - **Repository**: (your repo name)
     - **Branch to deploy**: `main`
   - Click **Deploy site** (settings will be read from `netlify.toml`)

##### Step 2A.4: Wait for Build to Complete
- Netlify will start building immediately
- Check the **Deploys** tab for build logs
- Build should complete in 1-2 minutes

---

#### **Option B: Alternative - Clear Cache & Redeploy (If Reset Not Possible)**

If you want to keep your existing Netlify site:

##### Step 2B.1: Clear Netlify Build Cache
1. Go to your Netlify dashboard
2. Select your site
3. Click **Site Settings** → **Build & Deploy** → **Build Environment**
4. Click **Edit settings**
5. Scroll to the bottom and click **Clear Cache**
6. Confirm

##### Step 2B.2: Remove Manual Build Settings
1. In **Site Settings** → **Build & Deploy** → **Continuous Deployment**
2. Look for any manually set values in:
   - Build command
   - Publish directory
   - Environment variables
3. **Delete** or clear any custom values (let `netlify.toml` handle it)

##### Step 2B.3: Push to Trigger Rebuild
```bash
# Make a small change to force a rebuild
echo "" >> netlify.toml
git add netlify.toml
git commit -m "Trigger Netlify rebuild to read netlify.toml"
git push origin main
```

##### Step 2B.4: Monitor Build
- Go to **Deploys** → **Trigger deploy** → **Deploy site**
- Or wait for auto-deploy when you push to main
- Check build logs for errors

---

### Phase 3: Verify Configuration in Netlify UI

#### Step 3.1: Check Build Settings
After deployment succeeds:
1. Go to **Site Settings** → **Build & Deploy** → **Build Settings**
2. Verify you see:
   ```
   Base directory: client
   Build command: npm run build
   Publish directory: dist
   ```
   
   Note: Netlify UI may display it as `client/dist` for clarity, but the config should show:
   - `base = "client"`
   - `publish = "dist"`

#### Step 3.2: Check Environment Variables
1. Go to **Site Settings** → **Build & Deploy** → **Environment**
2. You should NOT see any manual `VITE_API_URL` set here
3. Instead, it's defined in `netlify.toml` and `client/.env.production`

---

## 🚀 Final Verification

After deployment completes, verify everything works:

### Step 4.1: Check Deployed Site
1. Visit your Netlify site URL (e.g., `https://your-site.netlify.app`)
2. Should load without errors
3. Check browser DevTools (F12 → Console) for any errors

### Step 4.2: Test React Router
1. Go to any page in your app (e.g., `/products`, `/dashboard`)
2. Refresh the page (Ctrl+F5 or Cmd+Shift+R)
3. Page should load correctly (not show 404)
4. If it shows blank, the SPA redirect isn't working

### Step 4.3: Test API Connection
1. Open browser Console (F12 → Console)
2. Check that API calls are using: `https://ravi-maligai.onrender.com`
3. Verify your backend (Render) is accessible
4. Test an API endpoint to ensure connectivity

### Step 4.4: Check Build Logs
1. Go to **Deploys** → Select latest deploy
2. Click **Deploy log** to see full build output
3. Should show:
   ```
   Installing dependencies...
   npm install (in client/)
   
   Building...
   npm run build (in client/)
   
   ✓ dist/index.html
   ✓ dist/assets/...
   
   Deploy is live!
   ```

---

## ❌ Troubleshooting

### Issue: "Base directory does not exist"
**Cause**: Netlify can't find the `client/` folder  
**Solution**:
```bash
# Verify client folder exists in root
ls -la | grep client

# Make sure netlify.toml has: base = "client"
cat netlify.toml | grep "base ="

# Redeploy
git push origin main
```

### Issue: Build Fails - "Cannot find module"
**Cause**: Dependencies not installed  
**Solution**:
```bash
# Check client/package.json exists
cat client/package.json

# Check if package-lock.json or yarn.lock exists
ls client/package-lock.json
# OR
ls client/yarn.lock
```

### Issue: Publish Directory Still Shows `client/dist`
**Cause**: Netlify UI is caching old config  
**Solution**:
```bash
# Clear browser cache
# OR manually trigger rebuild in Netlify:
# Site Settings → Build & Deploy → Deploys → Trigger deploy → Deploy site
```

### Issue: Pages Blank on Refresh (404 Errors)
**Cause**: SPA routing not configured  
**Solution**: Verify `netlify.toml` has:
```toml
[[redirects]]
  from = "/*"
  to = "/index.html"
  status = 200
```

### Issue: API Calls Return 404
**Cause**: Wrong backend URL or backend not accessible  
**Solution**:
```bash
# Check .env.production
cat client/.env.production
# Should show: VITE_API_URL=https://ravi-maligai.onrender.com

# Verify backend is running
curl https://ravi-maligai.onrender.com

# Check browser console for actual API URL
```

---

## 📋 Configuration Files Summary

### ✅ Required Files

| File | Location | Content |
|------|----------|---------|
| `netlify.toml` | **Root** | Build config, redirects, headers |
| `.env.production` | `client/` | `VITE_API_URL=https://ravi-maligai.onrender.com` |
| `.env.development` | `client/` | `VITE_API_URL=http://localhost:4000` |
| `_redirects` | `client/public/` | Backup SPA redirect rule |
| `package.json` | `client/` | Must have `"build": "vite build"` |

### Verify All Files Exist
```bash
# From project root
test -f netlify.toml && echo "✓ netlify.toml" || echo "✗ Missing netlify.toml"
test -f client/.env.production && echo "✓ .env.production" || echo "✗ Missing"
test -f client/.env.development && echo "✓ .env.development" || echo "✗ Missing"
test -f client/public/_redirects && echo "✓ _redirects" || echo "✗ Missing"
test -f client/package.json && echo "✓ package.json" || echo "✗ Missing"
```

---

## 🔄 How Netlify Builds Your Project

When you push to `main` branch:

```
GitHub Push
    ↓
Netlify Detects Change
    ↓
Netlify Reads netlify.toml
    ↓
Sets base = "client" (cd into client/)
    ↓
Runs: npm install
    ↓
Loads: .env.production (VITE_API_URL=...)
    ↓
Runs: npm run build
    ↓
Vite compiles React → dist/
    ↓
Publishes: client/dist/ folder
    ↓
Applies SPA redirect rule
    ↓
Site Live ✅
```

---

## 📝 Deployment Checklist

Before pushing changes:

- [ ] `netlify.toml` exists in project root
- [ ] `netlify.toml` has `base = "client"`
- [ ] `netlify.toml` has `publish = "dist"`
- [ ] `.env.production` has correct backend URL
- [ ] `client/package.json` has `"build": "vite build"`
- [ ] Local build works: `cd client && npm run build`
- [ ] All files committed to GitHub
- [ ] Ready to push: `git push origin main`

---

## 📚 Key Concepts

### What is `base` directory?
- Tells Netlify where your app is located
- All build commands run from inside this directory
- In your case: `client/`

### What is `publish` directory?
- The folder Netlify serves to users
- Relative to the `base` directory
- So `publish = "dist"` means `client/dist/`

### Why use `.env.production`?
- Vite automatically loads this during `npm run build`
- Sets `VITE_API_URL` to your production backend
- Your code reads it via: `import.meta.env.VITE_API_URL`

### Why SPA redirects?
- React Router handles routing on the frontend
- When user accesses `/products`, the server tries to find `products.html` (doesn't exist)
- Redirect rule sends all requests to `index.html`
- React Router then handles the route on the client

---

## 🆘 Still Not Working?

If you've followed all steps and still have issues:

1. **Check Netlify Build Logs**:
   - Site Dashboard → Deploys → Latest Deploy → Deploy log
   - Look for error messages

2. **Verify Files on GitHub**:
   - https://github.com/your-username/ravi-maligai-main
   - Check if `netlify.toml` exists in root
   - Check if `client/` folder contents are present

3. **Check Backend Status**:
   - Visit `https://ravi-maligai.onrender.com` directly
   - Verify your Render backend is running

4. **Clear Everything & Start Fresh**:
   ```bash
   # On GitHub, ensure main branch has:
   # - netlify.toml in root
   # - client/.env.production with correct URL
   
   # Delete Netlify site
   # Reconnect repository
   # Let it auto-deploy
   ```

---

## ✨ Success Indicators

You'll know it's working when:

✅ Netlify dashboard shows "Deploy successful"  
✅ Site loads at `https://your-site.netlify.app`  
✅ Pages work after refresh (React Router)  
✅ API calls go to `https://ravi-maligai.onrender.com`  
✅ No console errors  
✅ Assets are cached properly  

---

## 📞 Support

- **Netlify Docs**: https://docs.netlify.com/configure-builds/file-based-configuration/
- **Vite Docs**: https://vitejs.dev/guide/env-and-mode.html
- **React Router**: https://reactrouter.com/

