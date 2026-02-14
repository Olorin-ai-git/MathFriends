# Deploy MathFriends

Your app is built and ready to deploy! The production build is in the `client/dist/` folder.

## Option 1: Netlify (Easiest - Drag & Drop)

1. Go to **https://netlify.com**
2. Click "Sign up" (create a free account)
3. After signing in, drag the `client/dist/` folder onto the Netlify page
4. Wait for deployment to complete
5. You'll get a live URL like `https://your-app-name.netlify.app`

**That's it!** Your app is live.

## Option 2: Vercel (Recommended)

1. Go to **https://vercel.com**
2. Click "Sign up" (create free account with GitHub)
3. Install Vercel CLI:
   ```bash
   npm install -g vercel
   ```
4. Deploy from the project root:
   ```bash
   vercel --prod
   ```
5. Follow the prompts and you're done!

You'll get a live URL like `https://mathfriends.vercel.app`

## Option 3: GitHub Pages (Free, but more setup)

1. Create a GitHub repository
2. Push your code:
   ```bash
   git init
   git add .
   git commit -m "Initial commit"
   git remote add origin https://github.com/YOUR-USERNAME/mathfriends.git
   git push -u origin main
   ```
3. Go to Settings → Pages
4. Set "Deploy from branch" to `main` and folder to `client/dist`
5. Your site will be live at `https://YOUR-USERNAME.github.io/mathfriends`

## After Deployment

- Your app is **100% client-side** - no server needed!
- All progress is saved in browser localStorage
- Works offline once loaded

## Rebuilding After Changes

If you make changes to the code:
```bash
npm run build
```

Then redeploy using your chosen hosting service.

---

**Recommended:** Use **Netlify** (simplest) or **Vercel** (fastest).
