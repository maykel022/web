# Deployment Guide

This guide covers deploying CryptoTradeInsights to various platforms.

## GitHub Pages (Included - FREE)

GitHub Pages is automatically configured and requires minimal setup.

### Enable GitHub Pages

1. Push your code to GitHub
2. Go to Settings → Pages
3. Select "Deploy from a branch"
4. Choose `gh-pages` branch as source
5. Save

### Access Your Site

Once deployed:
- Free URL: `https://yourusername.github.io/cryptotradeinsights/`
- Custom domain: `https://cryptotradeinsights.com/`

### Update baseURL

For GitHub Pages (free subdomain):
```toml
baseURL = 'https://yourusername.github.io/cryptotradeinsights/'
```

For custom domain:
```toml
baseURL = 'https://cryptotradeinsights.com/'
```

## Custom Domain Setup

### Buy Domain

1. Purchase `CryptoTradeInsights.com` from:
   - Namecheap
   - GoDaddy
   - Google Domains
   - Route 53 (AWS)

### GitHub Pages Custom Domain

1. Go to Settings → Pages
2. Enter custom domain: `cryptotradeinsights.com`
3. Enable HTTPS (wait for SSL certificate)

### DNS Configuration

Add these DNS records at your domain registrar:

**Option 1: Using GitHub's IP addresses (traditional)**
```
@ A 185.199.108.153
@ A 185.199.109.153
@ A 185.199.110.153
@ A 185.199.111.153
```

**Option 2: Using CNAME (simpler)**
```
www CNAME yourusername.github.io.
```

### CNAME File

Add `CNAME` file to your repository root:
```
cryptotradeinsights.com
```

Then push and GitHub will use it automatically.

## Netlify Deployment (RECOMMENDED for custom domain)

### Why Netlify?

- ✅ Free tier with custom domain
- ✅ CDN for global speed
- ✅ Automatic HTTPS
- ✅ Deploy previews for pull requests
- ✅ Built-in email notifications
- ✅ Form handling (if added later)

### Setup Steps

1. Sign up at https://netlify.com

2. Connect GitHub:
   - Click "New site from Git"
   - Choose GitHub
   - Authorize Netlify
   - Select your repository

3. Configure build:
   - **Build command**: `hugo -D`
   - **Publish directory**: `public`
   - **Hugo version**: (leave empty for latest)

4. Deploy site:
   - Click "Deploy site"
   - Wait for build to complete

5. Connect custom domain:
   - Settings → Domain management
   - Add custom domain: `cryptotradeinsights.com`
   - Update DNS records or use Netlify DNS

### Netlify Configuration File

Create `netlify.toml`:
```toml
[build]
  command = "hugo --minify"
  publish = "public"

[build.environment]
  HUGO_VERSION = "0.152.2"
  HUGO_ENV = "production"

[[redirects]]
  from = "/*"
  to = "/404.html"
  status = 404

[[headers]]
  for = "/*"
  [headers.values]
    X-Frame-Options = "SAMEORIGIN"
    X-Content-Type-Options = "nosniff"
    Referrer-Policy = "strict-origin-when-cross-origin"
```

## Vercel Deployment (Alternative)

### Setup Steps

1. Sign up at https://vercel.com

2. Import GitHub project:
   - Click "New Project"
   - Select GitHub repo
   - Grant permissions

3. Configure:
   - **Framework**: Hugo
   - **Build command**: `hugo`
   - **Output dir**: `public`

4. Deploy:
   - Click Deploy
   - Wait for build

5. Custom domain:
   - Settings → Domains
   - Add custom domain
   - Update DNS records

### Vercel Configuration

Create `vercel.json`:
```json
{
  "buildCommand": "hugo --minify",
  "outputDirectory": "public",
  "framework": null
}
```

## Comparison Table

| Feature | GitHub Pages | Netlify | Vercel |
|---------|------|---------|--------|
| Cost | Free | Free | Free |
| Custom domain | Yes | Yes | Yes |
| HTTPS | Yes | Yes | Yes |
| CDN | Yes | Yes | Yes |
| Build previews | ⚠️ Limited | ✅ Yes | ✅ Yes |
| Forms | ❌ No | ✅ Yes | ❌ No |
| Serverless functions | ❌ No | ✅ Yes | ✅ Yes |
| Environment variables | ✅ Yes | ✅ Yes | ✅ Yes |

## Environment Variables

For n8n automation, set these in your CI/CD platform:

### GitHub Actions
1. Settings → Secrets and variables → Actions
2. Add secrets:
   - `ANTHROPIC_API_KEY`: Your Claude API key
   - `GITHUB_TOKEN`: Personal access token (usually automatic)

### Netlify
1. Site settings → Build & deploy → Environment
2. Add build environment variables:
   - `ANTHROPIC_API_KEY`: Your Claude API key

### Vercel
1. Settings → Environment Variables
2. Add:
   - `ANTHROPIC_API_KEY`: Your Claude API key

## Monitoring & Logs

### GitHub Actions
- Go to Actions tab in your repo
- View workflow runs
- Check logs for each step
- Debug build failures

### Netlify
- Deploys tab shows all deployments
- Click deployment to see logs
- Email notifications for failures

### Vercel
- Deployments tab
- Click deployment for logs
- Real-time build status

## Performance Optimization

### Enable Caching

**Netlify cache plugin**:
```toml
[[plugins]]
  package = "@netlify/plugin-caching"

  [plugins.inputs]
    nodeModulesCacheDir = ".cache/node_modules"
```

**Vercel automatic**: No configuration needed

### Minification

Already configured in `hugo.toml`:
```toml
minify = true
```

### Image Optimization

Add to `hugo.toml`:
```toml
[imaging]
  resampleFilter = "lanczos"
  quality = 75
```

## Troubleshooting

### Build fails on GitHub Pages
- Check Actions logs
- Verify `hugo.toml` syntax
- Ensure theme submodule is initialized
- Check for deprecated Hugo features

### Domain not resolving
- DNS changes take 24-48 hours
- Verify DNS records are correct
- Clear browser cache
- Try different device/network

### Site shows 404
- Check baseURL matches domain
- Verify CNAME file is present
- Check build output in `public/` directory
- Ensure source files are committed

### Slow loading times
- Enable CDN caching headers
- Minimize large images
- Use Netlify/Vercel edge caching
- Check performance metrics

## Next Steps

After deployment:
1. Test website on custom domain
2. Verify SSL certificate is active
3. Test RSS feed functionality
4. Set up DNS monitoring
5. Configure email notifications
6. Monitor site analytics
