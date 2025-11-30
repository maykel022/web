# n8n Automation Setup Guide

This guide walks you through setting up n8n to automate content creation for CryptoTradeInsights.

## Overview

The n8n workflow performs the following tasks on a schedule:

1. **Fetch News**: Pull from multiple crypto RSS feeds and APIs
2. **Aggregate**: Combine and deduplicate news items
3. **Generate Posts**: Use Claude AI to write blog posts from news
4. **Format**: Add proper Hugo frontmatter and structure
5. **Commit**: Push markdown files to GitHub repository
6. **Trigger Build**: GitHub Actions auto-builds and deploys

## Prerequisites

- n8n instance (self-hosted or n8n Cloud)
- GitHub account with repository access token
- Anthropic API key (Claude)
- Optional: News API key for broader coverage

## Step 1: Prepare Credentials

### GitHub Personal Access Token
1. Go to GitHub Settings → Developer settings → Personal access tokens → Tokens (classic)
2. Create a new token with:
   - Scopes: `repo` (full control)
   - Expiration: Choose appropriate duration
3. Save the token securely

### Anthropic Claude API Key
1. Sign up at https://console.anthropic.com/
2. Go to API keys section
3. Create a new key and copy it

### News API Key (Optional)
1. Sign up at https://newsapi.org/
2. Copy your API key

## Step 2: Create RSS Feed List

Create a file `docs/rss-feeds.json`:

```json
{
  "feeds": [
    "https://feeds.bloomberg.com/markets/news.rss",
    "https://feed.coindesk.com/idx/feed",
    "https://theblock.co/feed/rss",
    "https://feeds.bloomberg.com/crypto.rss",
    "https://api.kraken.com/feeds/blog",
    "https://blog.binance.com/en/feed",
    "https://blog.coinbase.com/feed"
  ]
}
```

## Step 3: n8n Workflow Architecture

### Workflow Components

```
Cron Trigger (Daily at 8 AM UTC)
    ↓
Fetch RSS Feeds (Parallel)
    ↓
Parse & Extract News Items
    ↓
Deduplicate Items
    ↓
For Each News Item:
  ├─ Call Claude API
  ├─ Generate Blog Post
  └─ Format Frontmatter
    ↓
Create GitHub Commit
    ↓
Push to Repository
```

## Step 4: Build the Workflow in n8n

### Node 1: Cron Trigger
- **Type**: Cron node
- **Trigger**: Daily at 08:00 (UTC)
- **Expression**: `0 8 * * *`

### Node 2: Fetch RSS Feeds
- **Type**: HTTP Request (in loop)
- **Method**: GET
- **URL**: RSS feed URL (from array)
- **Parser**: Extract XML

**Sample transformation**:
```javascript
// Parse RSS XML to JSON
const parser = require('xml2js').Parser;
// Extract: title, description, pubDate, link, source
```

### Node 3: Deduplicate News
- **Type**: Function/Code
- **Logic**: Remove duplicate titles/URLs from last 24 hours
- **Store**: Use Redis or database for deduplication

### Node 4: Generate Blog Post
- **Type**: HTTP Request (Anthropic API)
- **Method**: POST
- **URL**: `https://api.anthropic.com/v1/messages`
- **Headers**: 
  - `x-api-key: your-key`
  - `content-type: application/json`

**Payload**:
```json
{
  "model": "claude-3-5-sonnet-20241022",
  "max_tokens": 2048,
  "messages": [
    {
      "role": "user",
      "content": "Write a blog post about: {newsItem.title}\n\nDetails: {newsItem.description}\n\nSource: {newsItem.source}\n\nReturn ONLY the markdown content (no frontmatter)."
    }
  ]
}
```

### Node 5: Format Hugo Frontmatter
- **Type**: Function/Code
- **Logic**: Create Hugo-compatible markdown with frontmatter

**Output format**:
```javascript
const post = {
  frontmatter: {
    date: new Date().toISOString(),
    title: newsItem.title,
    description: newsItem.description.substring(0, 160),
    tags: extractTags(newsItem),
    categories: ["news"],
    author: "CryptoTradeInsights"
  },
  content: generateContent(newsItem, aiResponse),
  filename: slugify(newsItem.title) + '.md'
};
```

### Node 6: Create GitHub Commit
- **Type**: GitHub API / Git operations
- **Action**: Create or update file
- **Path**: `content/posts/{filename}`
- **Branch**: `main`
- **Message**: `AI: Auto-generated post - ${title}`

**Using GitHub API**:
```bash
curl -X PUT \
  https://api.github.com/repos/{owner}/{repo}/contents/content/posts/{filename} \
  -H "Authorization: token {token}" \
  -H "Content-Type: application/json" \
  -d '{
    "message": "AI: Auto-generated post - {title}",
    "content": "{base64_encoded_content}",
    "branch": "main"
  }'
```

## Step 5: n8n Workflow JSON

Here's a starter workflow template:

```json
{
  "name": "CryptoTradeInsights Content Generator",
  "nodes": [
    {
      "name": "Cron Trigger",
      "type": "n8n-nodes-base.cron",
      "typeVersion": 1,
      "position": [100, 100],
      "parameters": {
        "rule": {
          "interval": [
            "days"
          ],
          "daysInterval": 1,
          "hoursInterval": 8
        }
      }
    },
    {
      "name": "Fetch RSS Feeds",
      "type": "n8n-nodes-base.httpRequest",
      "typeVersion": 4,
      "position": [300, 100],
      "parameters": {
        "url": "={{ $json.feedUrl }}",
        "method": "GET"
      }
    },
    {
      "name": "Generate with Claude",
      "type": "n8n-nodes-base.httpRequest",
      "typeVersion": 4,
      "position": [500, 100],
      "parameters": {
        "url": "https://api.anthropic.com/v1/messages",
        "method": "POST",
        "headers": {
          "x-api-key": "={{ $credentials.anthropicApiKey }}",
          "anthropic-version": "2023-06-01"
        },
        "body": {
          "model": "claude-3-5-sonnet-20241022",
          "max_tokens": 2048,
          "messages": [
            {
              "role": "user",
              "content": "Write a blog post about this crypto news..."
            }
          ]
        }
      }
    },
    {
      "name": "Commit to GitHub",
      "type": "n8n-nodes-base.github",
      "typeVersion": 2,
      "position": [700, 100],
      "parameters": {
        "operation": "createUpdate",
        "owner": "your-username",
        "repository": "cryptotradeinsights",
        "filePath": "content/posts/{{ $json.filename }}",
        "fileContent": "={{ $json.markdownContent }}",
        "commitMessage": "AI: Auto-generated post - {{ $json.title }}"
      }
    }
  ],
  "connections": {
    "Cron Trigger": {
      "main": [["Fetch RSS Feeds"]]
    },
    "Fetch RSS Feeds": {
      "main": [["Generate with Claude"]]
    },
    "Generate with Claude": {
      "main": [["Commit to GitHub"]]
    }
  }
}
```

## Step 6: Testing & Validation

1. **Test individual RSS feeds**:
   - Verify feeds are accessible
   - Check XML parsing
   - Validate item extraction

2. **Test Claude integration**:
   - Send sample news items
   - Verify post quality
   - Check token limits

3. **Test GitHub integration**:
   - Verify token has correct permissions
   - Test file creation
   - Verify GitHub Actions trigger

4. **End-to-end test**:
   - Run workflow manually
   - Verify post appears in `content/posts/`
   - Check GitHub Pages deployment

## Step 7: Deploy & Monitor

### n8n Self-Hosted (Recommended for control)
```bash
docker run -d \
  -p 5678:5678 \
  -e N8N_HOST=your-domain.com \
  -e N8N_PROTOCOL=https \
  -v ~/.n8n:/home/node/.n8n \
  n8nio/n8n
```

### n8n Cloud
1. Sign up at n8n.cloud
2. Import the workflow
3. Add credentials
4. Set schedule and deploy

### Monitoring
- Set up email/Slack notifications for failures
- Monitor GitHub commit history
- Track post generation metrics
- Review Hugo build logs in GitHub Actions

## Step 8: Optimization

### Post Quality
- Experiment with Claude prompts
- A/B test different content lengths
- Gather reader feedback
- Refine tag/category logic

### Performance
- Cache RSS feeds to avoid repeated calls
- Batch process multiple articles
- Use GitHub API rate limiting wisely
- Consider Redis for deduplication

### Cost Optimization
- n8n Self-hosted: ~$5-20/month on VPS
- Claude API: ~$0.003 per 1K input tokens
- GitHub Pages: Free
- Total monthly cost: ~$5-30

## Troubleshooting

### Common Issues

**Feeds not updating:**
- Check RSS feed availability
- Verify XML parsing logic
- Check for SSL/certificate issues

**Claude API errors:**
- Verify API key is valid
- Check token limits
- Monitor rate limits (5 requests/minute standard tier)

**GitHub commit failures:**
- Verify token hasn't expired
- Check repository permissions
- Review branch protection rules

**Posts not deploying:**
- Check GitHub Actions logs
- Verify Hugo theme is properly configured
- Ensure frontmatter is valid TOML

## Resources

- [n8n Documentation](https://docs.n8n.io/)
- [Anthropic Claude API](https://docs.anthropic.com/en/api/getting-started)
- [GitHub API Reference](https://docs.github.com/en/rest)
- [RSS Feed Specifications](https://www.rssboard.org/rss-specification)
