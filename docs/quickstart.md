# Quick Start Guide

Get CryptoTradeInsights up and running in 10 minutes.

## 🚀 Super Quick Setup (5 minutes)

### 1. Fork & Clone
```bash
# Clone this repository
git clone --recursive https://github.com/yourusername/cryptotradeinsights.git
cd cryptotradeinsights
```

### 2. Install Hugo
```bash
# macOS
brew install hugo

# Ubuntu/Debian
sudo apt-get install hugo

# Or download from https://github.com/gohugoio/hugo/releases
```

### 3. Run Locally
```bash
hugo server
# Open http://localhost:1313/
```

### 4. Create & Edit Posts
```bash
# Create a new post
hugo new content/posts/my-first-post.md

# Edit the markdown file with your content
# Remove `draft = true` to publish
```

### 5. Deploy to GitHub Pages
```bash
# Push to GitHub
git add .
git commit -m "Add my post"
git push origin main

# GitHub Actions auto-deploys!
# Check: Settings → Pages → Visit site
```

---

## 📋 Complete 10-Minute Setup

### Step 1: Prerequisites (2 min)

Install required tools:
```bash
# Hugo (https://gohugo.io/installation/)
brew install hugo

# Git (usually pre-installed)
git --version

# Python 3.8+ (for automation scripts)
python3 --version
```

### Step 2: Local Setup (3 min)

```bash
# Clone the repository
git clone --recursive https://github.com/yourusername/cryptotradeinsights.git
cd cryptotradeinsights

# Install Python dependencies (optional, for automation)
pip install -r scripts/requirements.txt
```

### Step 3: Test Locally (2 min)

```bash
# Start development server
hugo server

# Open browser: http://localhost:1313/

# View existing content
# - Home page
# - Welcome post
# - About page
```

### Step 4: GitHub Setup (3 min)

1. **Create GitHub repo**:
   - Go to github.com/new
   - Name: `cryptotradeinsights`
   - Description: "AI-powered crypto news blog"
   - Click "Create repository"

2. **Connect local repo**:
   ```bash
   git remote add origin https://github.com/yourusername/cryptotradeinsights.git
   git branch -M main
   git push -u origin main
   ```

3. **Enable GitHub Pages**:
   - Go to Settings → Pages
   - Source: Deploy from a branch
   - Branch: `gh-pages`
   - Save

4. **Check Actions**:
   - Go to Actions tab
   - Should see "Hugo Deploy" workflow running
   - Wait for ✅ completion

### Step 5: Access Your Site (0 min)

Your site is now live at:
- `https://yourusername.github.io/cryptotradeinsights/`

---

## ✍️ Creating Your First Post

### Manual Creation

1. Create post file:
   ```bash
   hugo new content/posts/bitcoin-rally-november-2025.md
   ```

2. Edit the markdown:
   ```markdown
   +++
   date = '2025-11-30T10:00:00Z'
   draft = false
   title = 'Bitcoin Rally Continues in November 2025'
   description = "Bitcoin surges past $50,000 as institutional adoption grows"
   tags = ["bitcoin", "trading"]
   categories = ["news"]
   +++
   
   ## Market Overview
   
   Bitcoin has rallied strongly...
   
   [Add your content here]
   ```

3. Push to publish:
   ```bash
   git add content/posts/bitcoin-rally-november-2025.md
   git commit -m "Add: Bitcoin rally analysis"
   git push
   ```

### Automated Generation (Optional)

Generate posts from crypto news feeds:

```bash
# Set API keys
export ANTHROPIC_API_KEY="your-claude-api-key"
export GITHUB_TOKEN="your-github-token"

# Run generator
python scripts/generate_posts.py
```

The script will:
1. Fetch latest crypto news
2. Generate posts with Claude AI
3. Commit to GitHub
4. Trigger auto-deployment

---

## 🎯 Next Steps

### Setup Custom Domain
```bash
# Edit hugo.toml
baseURL = 'https://cryptotradeinsights.com/'

# Add CNAME file to repo root
echo "cryptotradeinsights.com" > CNAME

# Update GitHub Pages settings with custom domain
```

### Enable RSS Feed
Your site automatically has an RSS feed at:
- `/index.xml` - Full content feed
- `/posts/index.xml` - Posts only feed

Subscribe in readers like Feedly, Inoreader, etc.

### Add Social Links
Edit `hugo.toml`:
```toml
[[params.socialIcons]]
name = "twitter"
url = "https://twitter.com/yourhandle"

[[params.socialIcons]]
name = "github"
url = "https://github.com/yourusername"
```

### Setup Automation

**Choose your automation tool**:

1. **n8n** (recommended)
   - Follow: `docs/n8n-setup.md`
   - Daily content generation
   - Full control over workflow

2. **GitHub Actions**
   - Follow: `docs/github-actions.md`
   - Free tier available
   - Python script included

3. **Manual Posts**
   - Create posts manually
   - Commit to GitHub
   - GitHub Actions builds & deploys

### Monitor Your Site

Add Google Analytics:
```toml
[params]
  googleAnalyticsID = "G-XXXXXXXXXX"
```

---

## 📚 Full Documentation

- **Deployment**: `docs/deployment.md` (GitHub Pages, Netlify, Vercel)
- **n8n Setup**: `docs/n8n-setup.md` (Automated content generation)
- **GitHub Actions**: `docs/github-actions.md` (CI/CD workflows)
- **README**: `README.md` (Project overview)

---

## 🐛 Troubleshooting

### Site won't build
```bash
# Check Hugo syntax
hugo --logLevel debug

# Verify theme submodule is loaded
git submodule update --init --recursive

# Check hugo.toml for errors
hugo config
```

### Posts not showing
- Remove `draft = true` from post frontmatter
- Ensure correct directory: `content/posts/`
- Check file extension: `.md`

### Deployment stuck
- Check GitHub Actions logs
- Verify GitHub token permissions
- Ensure `gh-pages` branch exists

### Local server won't start
```bash
# Clear cache
rm -rf resources/

# Rebuild
hugo server -D
```

---

## 💡 Pro Tips

1. **Draft posts**: Set `draft = true` to hide posts while editing
2. **Schedule posts**: Use `publishDate` in frontmatter for future publish
3. **Tags & Categories**: Use for navigation and SEO
4. **RSS feed**: Promote your `/index.xml` feed for subscribers
5. **SEO**: Include `description` in frontmatter (160 chars)

---

## 🎉 You're Ready!

Your CryptoTradeInsights blog is now:
- ✅ Running locally
- ✅ Deployed on GitHub Pages
- ✅ Auto-building on pushes
- ✅ Ready for content

Start writing! 🚀

---

**Need help?**
- Docs: `docs/` folder
- Issues: GitHub Issues
- Discussion: GitHub Discussions
