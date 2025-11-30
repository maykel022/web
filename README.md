# CryptoTradeInsights

An AI-powered cryptocurrency news blog built with Hugo, automated with n8n, and deployed on GitHub Pages.

## 🚀 Features

- **Fast Static Site**: Hugo generates lightning-fast HTML
- **Admin Dashboard**: Modern web interface to manage posts without code
- **Daily AI-Generated Content**: Automated posts from crypto news feeds using Claude AI
- **SEO Optimized**: Tags, categories, XML sitemap, and structured data
- **Responsive Design**: PaperMod theme with mobile-first layout
- **Auto-Deploy**: GitHub Actions CI/CD on every push
- **RSS Feeds**: Stay updated with RSS subscriptions
- **GitHub Integration**: Optional auto-sync posts to your repository

## 📁 Project Structure

```
cryptotradeinsights/
├── admin/               # Admin dashboard
│   ├── index.html       # Dashboard interface
│   ├── github-integration.js  # GitHub API integration
│   └── README.md        # Admin guide
├── content/             # Blog posts and pages
│   ├── posts/          # Blog post markdown files
│   └── about.md        # About page
├── themes/PaperMod/    # Hugo theme (submodule)
├── static/             # Static assets (images, CSS, etc.)
├── docs/               # Documentation
├── .github/workflows/  # GitHub Actions CI/CD
├── hugo.toml           # Hugo configuration
└── README.md           # This file
```

## 🛠️ Development

### Prerequisites
- [Hugo](https://gohugo.io/installation/) (extended version)
- Git

### Local Development

1. Clone the repository:
```bash
git clone --recursive https://github.com/yourusername/cryptotradeinsights.git
cd cryptotradeinsights
```

2. Start the Hugo development server:
```bash
hugo server -D
```

3. Open `http://localhost:1313/` in your browser

### Using the Admin Dashboard

Create and manage posts visually:

1. While running `hugo server`, open: `http://localhost:1313/admin/`
2. Create posts with form interface
3. Manage tags and categories
4. Auto-sync to GitHub (optional)
5. Changes appear instantly on site

**Full guide**: See `docs/admin-guide.md`

### Creating Posts Manually

Add a new post via command line:
````
```bash
hugo new content/posts/my-post-title.md
```

Edit the file with your content and metadata, then push to trigger auto-deployment.

## 🤖 Automation with n8n

The workflow automation is configured with n8n to:

1. **Aggregate news** from crypto RSS feeds daily
2. **Process with Claude AI** to generate quality posts
3. **Commit to GitHub** with proper frontmatter
4. **Trigger Hugo build** via GitHub Actions

**n8n Setup**: See `docs/n8n-setup.md` for detailed configuration.

## 🚀 Deployment

This site auto-deploys via GitHub Actions whenever changes are pushed to the `main` branch.

### Deployment Options

- **GitHub Pages** (free, included)
- **Netlify** (drag & drop, advanced features)
- **Vercel** (edge functions, serverless)

### Custom Domain

To use `CryptoTradeInsights.com`:

1. Update `baseURL` in `hugo.toml`
2. Add CNAME to GitHub Pages settings
3. Configure DNS records with your registrar

## 📊 Content Guidelines

- **Tone**: Informative, analytical, accessible
- **Length**: 500-1500 words
- **Sources**: Cite original news sources
- **Tags**: Use consistent tags (bitcoin, ethereum, defi, altcoins, regulations, etc.)
- **Update Frequency**: Daily or multiple times per day

## 📚 Resources

- [Hugo Documentation](https://gohugo.io/documentation/)
- [PaperMod Theme](https://github.com/adityatelange/hugo-PaperMod)
- [n8n Documentation](https://docs.n8n.io/)
- [GitHub Pages Docs](https://docs.github.com/en/pages)

## 📄 License

MIT License - Feel free to use this as a template for your own crypto blog!

## 🤝 Contributing

Contributions are welcome! Submit issues and pull requests to improve the site.

---

**Built with ❤️ for the crypto community**
