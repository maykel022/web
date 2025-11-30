#!/bin/bash
# Project Structure Overview for CryptoTradeInsights

cat << 'EOF'
cryptotradeinsights/
│
├── 📄 README.md                 # Project overview & setup
├── 📄 hugo.toml                 # Hugo configuration (site metadata, theme, SEO)
├── 📄 CNAME                     # Custom domain (optional, for GitHub Pages)
├── .gitignore                   # Git ignore rules
│
├── .github/
│   └── workflows/
│       └── deploy.yml           # GitHub Actions: Auto-build & deploy on push
│
├── content/                     # All blog content (Markdown)
│   ├── _index.md                # Home page
│   ├── about.md                 # About page
│   └── posts/
│       ├── _index.md            # Posts index page
│       └── *.md                 # Individual blog posts
│                                 # Example: welcome-to-cryptotradeinsights.md
│
├── static/                      # Static assets (images, downloads, etc.)
│   ├── images/
│   ├── css/
│   └── ...
│
├── themes/
│   └── PaperMod/                # Hugo theme (git submodule)
│       ├── layouts/
│       ├── static/
│       └── ...
│
├── archetypes/
│   └── default.md               # Post template (frontmatter structure)
│
├── public/                       # Build output (ignored by git)
│   └── ...                       # Generated HTML files
│
├── docs/                        # Project documentation
│   ├── quickstart.md            # 10-minute setup guide
│   ├── deployment.md            # Deploy to GitHub Pages / Netlify / Vercel
│   ├── n8n-setup.md             # n8n automation workflow guide
│   ├── github-actions.md        # GitHub Actions CI/CD setup
│   └── README.md                # Documentation index
│
├── scripts/                     # Automation scripts
│   ├── generate_posts.py        # Python script to generate posts from RSS feeds
│   └── requirements.txt          # Python dependencies
│
├── resources/                   # Hugo cache (ignored by git)
│   └── ...
│
└── .hugo_build.lock             # Hugo lock file (ignored by git)


KEY DIRECTORIES EXPLAINED:

📝 content/
  └─ Where all blog posts and pages live as Markdown
  └─ Directory structure: content/posts/*.md
  └─ Each .md file becomes an HTML page with frontmatter metadata

🎨 themes/PaperMod/
  └─ The Hugo theme (responsive, fast, crypto-friendly)
  └─ Added as git submodule for easy updates
  └─ No need to edit - theme is maintained separately

⚙️  .github/workflows/
  └─ GitHub Actions automation
  └─ deploy.yml: Builds Hugo → Commits to gh-pages → GitHub Pages
  └─ Triggers on: push to main branch

📚 docs/
  └─ Project documentation (not part of website)
  └─ quickstart.md: Get started in 10 minutes
  └─ deployment.md: Deploy to various platforms
  └─ n8n-setup.md: Automate content generation
  └─ github-actions.md: GitHub Actions CI/CD

🤖 scripts/
  └─ generate_posts.py: Fetch RSS → Generate with Claude → Commit to GitHub
  └─ Runs on schedule (n8n) or manually

📦 public/
  └─ Build output (compiled HTML files)
  └─ Created by: hugo command
  └─ Deployed by: GitHub Actions to gh-pages branch
  └─ Should NOT be committed to git


WORKFLOW OVERVIEW:

1. YOU CREATE A POST
   $ hugo new content/posts/my-post.md
   [Edit the markdown file]
   $ git add . && git commit && git push

2. GITHUB ACTIONS TRIGGERS
   .github/workflows/deploy.yml runs automatically
   ├─ Checks out repository
   ├─ Installs Hugo
   ├─ Builds site: hugo → public/
   └─ Deploys: public/ → gh-pages branch

3. GITHUB PAGES PUBLISHES
   GitHub Pages serves the website from gh-pages branch
   ├─ https://yourusername.github.io/cryptotradeinsights/ (free)
   └─ https://cryptotradeinsights.com/ (with custom domain)

4. READERS DISCOVER CONTENT
   ├─ Browse website
   ├─ Subscribe to RSS feed (/index.xml)
   ├─ Read on social media (share links)
   └─ Link from other sites


AUTOMATED CONTENT GENERATION (OPTIONAL):

n8n Workflow (Daily at 8 AM UTC)
├─ Fetch crypto news from RSS feeds
├─ Aggregate & deduplicate articles
├─ Call Claude API for post generation
├─ Format with Hugo frontmatter
├─ Commit to GitHub (content/posts/)
└─ GitHub Actions auto-builds & deploys


FILE EDITING GUIDE:

DO EDIT:
├─ content/posts/*.md      (your blog posts)
├─ content/about.md        (about page)
├─ hugo.toml               (site title, description, links)
└─ scripts/generate_posts.py (to customize automation)

DON'T EDIT:
├─ themes/PaperMod/        (update theme via git submodule update)
├─ public/                  (auto-generated, don't commit)
├─ resources/               (auto-generated, don't commit)
└─ .hugo_build.lock         (auto-generated, don't commit)


GIT WORKFLOW:

$ cd cryptotradeinsights
$ git status                           # Check changes
$ git add .                            # Stage changes
$ git commit -m "Your message"         # Commit
$ git push origin main                 # Push to GitHub

GitHub Actions will:
├─ See the push
├─ Run deploy.yml workflow
├─ Build Hugo
└─ Deploy to GitHub Pages

Your site updates automatically! ✨


DEPLOYMENT OPTIONS:

Option 1: GitHub Pages (Free, Included)
├─ URL: yourusername.github.io/cryptotradeinsights/
├─ Or custom domain: cryptotradeinsights.com
└─ Setup: 5 minutes

Option 2: Netlify (Free tier available)
├─ Better DX, preview deployments
├─ Serverless functions available
└─ Setup: 10 minutes

Option 3: Vercel (Free tier available)
├─ Ultra-fast edge network
├─ Great for high traffic
└─ Setup: 10 minutes


AUTOMATION OPTIONS:

Option 1: n8n (Recommended)
├─ Self-hosted: ~$5-20/month (VPS)
├─ Managed: ~$100/month (n8n Cloud)
├─ Full control over workflow
└─ Daily automated posts

Option 2: GitHub Actions
├─ Free for public repos
├─ Limited to 2,000 min/month for private
├─ Python script included
└─ No additional infrastructure

Option 3: Manual Posts
├─ Create posts manually
├─ Git commit & push
├─ GitHub Actions still auto-deploys
└─ No automation costs


COST BREAKDOWN:

Minimal Setup (Static only):
├─ Domain: ~$1/month
├─ GitHub Pages: Free
├─ Claude API (manual): $0-5/month
└─ Total: ~$1-5/month

Basic Automation (GitHub Actions):
├─ Domain: ~$1/month
├─ GitHub Pages: Free
├─ Claude API (~30 posts): ~$0.30/month
└─ Total: ~$1.30/month

Advanced Automation (n8n self-hosted):
├─ VPS: ~$5-20/month
├─ Domain: ~$1/month
├─ Claude API (~100 posts): ~$0.30/month
└─ Total: ~$25-50/month


NEXT STEPS:

1. Read docs/quickstart.md for 10-minute setup
2. Deploy to GitHub Pages (free)
3. Create first posts manually
4. If desired: Set up automation with n8n or GitHub Actions
5. Add custom domain
6. Monitor with Google Analytics
7. Grow audience & traffic


USEFUL COMMANDS:

# Development
hugo server                        # Start local dev server
hugo -D                            # Build with drafts
hugo --logLevel debug              # Debug build issues

# Production
hugo --minify                      # Build & minify for production
hugo mod get -u                    # Update modules/dependencies

# Git operations
git status                         # Check changes
git log --oneline                  # View commit history
git submodule update               # Update theme

# Testing
hugo new content/posts/test.md     # Create test post
hugo mod clean                     # Clean cache
rm -rf resources/                  # Clear Hugo cache


THEME CUSTOMIZATION:

PaperMod is highly customizable via hugo.toml:

[params]
  profileMode.enabled = false
  showBreadcrumbs = false
  showPostNavLinks = true
  showReadingTime = true
  showShareButtons = true
  comments = false

[[params.socialIcons]]
  name = "twitter"
  url = "https://twitter.com/yourhandle"

[params.colors]
  lightBackground = "#f0f0f0"
  lightText = "#000000"


FOLDER STRUCTURE EXPLAINED:

archetype/          → Template for new posts
content/            → Your blog content (Markdown)
public/             → Build output (don't commit)
static/             → Images, PDFs, static files
themes/             → Hugo themes (PaperMod)
docs/               → Project documentation
scripts/            → Automation scripts (.github actions, n8n, etc.)
resources/          → Hugo caches (don't commit)
.github/workflows/  → GitHub Actions (CI/CD automation)

Each folder has a specific purpose in the Hugo + Git + GitHub workflow.

EOF

echo ""
echo "✨ Project structure overview displayed above"
echo ""
echo "📚 For detailed setup, read: docs/quickstart.md"
echo "🚀 For deployment options, read: docs/deployment.md"
echo "🤖 For automation, read: docs/n8n-setup.md"
