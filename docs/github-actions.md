# GitHub Actions & Automation Integration

Guide for setting up GitHub Actions with n8n for automated content generation.

## Architecture Overview

```
n8n Workflow (Daily 8 AM UTC)
    ↓
    ├─ Fetch RSS feeds
    ├─ Aggregate news
    ├─ Call Claude API
    └─ Commit to GitHub
    ↓
GitHub Actions Trigger
    ↓
Hugo Build (automatic)
    ↓
Deploy to GitHub Pages
    ↓
Site Updates Live
```

## GitHub Secrets Setup

### Adding Secrets to GitHub

1. Go to your repository on GitHub
2. Settings → Secrets and variables → Actions
3. Click "New repository secret"
4. Add these secrets:

#### ANTHROPIC_API_KEY
- **Name**: `ANTHROPIC_API_KEY`
- **Value**: Your Claude API key from https://console.anthropic.com/
- Used by: n8n workflow to generate posts

#### GITHUB_TOKEN
- **Name**: `GITHUB_TOKEN`
- **Value**: Personal access token with `repo` scope
- Create at: https://github.com/settings/tokens
- Used by: n8n to commit files, GitHub Actions

#### Optional: NEWS_API_KEY
- **Name**: `NEWS_API_KEY`
- **Value**: API key from https://newsapi.org/
- Used by: Enhanced news aggregation

## GitHub Actions Workflows

### 1. Deploy Workflow (Automatic)

File: `.github/workflows/deploy.yml` (already included)

This workflow:
- Triggers on push to `main`
- Builds Hugo site
- Deploys to `gh-pages` branch
- Updates GitHub Pages

**Status**: ✅ Already configured

### 2. Schedule Content Generation (Optional)

Create: `.github/workflows/generate-content.yml`

This allows GitHub Actions itself to trigger content generation:

```yaml
name: Generate Content

on:
  schedule:
    # Run at 8 AM UTC daily
    - cron: '0 8 * * *'
  workflow_dispatch:  # Allow manual trigger

jobs:
  generate:
    runs-on: ubuntu-latest
    
    steps:
      - name: Checkout code
        uses: actions/checkout@v4
        with:
          token: ${{ secrets.GITHUB_TOKEN }}
      
      - name: Set up Python
        uses: actions/setup-python@v4
        with:
          python-version: '3.11'
      
      - name: Install dependencies
        run: |
          pip install -r scripts/requirements.txt
      
      - name: Generate posts
        env:
          ANTHROPIC_API_KEY: ${{ secrets.ANTHROPIC_API_KEY }}
          GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
          GITHUB_REPO: ${{ github.repository }}
        run: |
          python scripts/generate_posts.py
      
      - name: Commit changes
        run: |
          git config --local user.email "action@github.com"
          git config --local user.name "GitHub Action"
          git add content/posts/
          git diff --quiet && git diff --staged --quiet || (
            git commit -m "chore: auto-generated posts from news feeds"
            git push
          )
```

## n8n Integration with GitHub

### Step 1: Create GitHub Personal Access Token

1. Go to https://github.com/settings/tokens
2. Click "Generate new token (classic)"
3. Give it a name: `n8n-bot`
4. Grant scopes:
   - `repo` (full control)
   - `workflow` (manage workflows)
5. Copy token and save securely

### Step 2: Add Token to GitHub Secrets

Add it as `N8N_GITHUB_TOKEN` in repository secrets.

### Step 3: Create n8n GitHub Commit Node

In your n8n workflow, add a GitHub node:

**Node Type**: GitHub

**Configuration**:
- **Credential**: GitHub (using your token)
- **Resource**: Repository/Content
- **Operation**: Create Update
- **Owner**: your-github-username
- **Repository**: cryptotradeinsights
- **File Path**: `content/posts/{{ $json.filename }}`
- **File Content**: `{{ $json.markdownContent }}`
- **Commit Message**: `AI: Auto-generated post - {{ $json.title }}`
- **Branch**: main

## Advanced: Webhook Triggers

### Trigger n8n from GitHub

Allow n8n to be triggered when code is pushed:

```bash
# Get your n8n webhook URL from n8n dashboard
# Usually: https://your-n8n-domain.com/webhook/crypto-insights

# Create GitHub webhook:
# 1. Settings → Webhooks → Add webhook
# 2. Payload URL: [your n8n webhook URL]
# 3. Events: Push events
# 4. Active: Yes
```

### Webhook Payload Handling

In n8n, the webhook receives GitHub push events:

```json
{
  "action": "opened",
  "pull_request": {
    "head": {
      "ref": "main"
    }
  }
}
```

## Post-Generation Cleanup

### Prevent Duplicates

Store generated article hashes:

```json
{
  "seen_articles": [
    "hash1",
    "hash2"
  ],
  "last_run": "2025-11-30T08:00:00Z"
}
```

Store in repository as `.github/cache/generated.json` or use GitHub's cache actions.

## Error Handling & Notifications

### Slack Notifications

Add to GitHub Actions or n8n:

```yaml
- name: Notify on failure
  if: failure()
  uses: slackapi/slack-github-action@v1
  with:
    webhook-url: ${{ secrets.SLACK_WEBHOOK }}
    payload: |
      {
        "text": "❌ CryptoTradeInsights build failed",
        "blocks": [
          {
            "type": "section",
            "text": {
              "type": "mrkdwn",
              "text": "Build failed: ${{ github.server_url }}/${{ github.repository }}/actions/runs/${{ github.run_id }}"
            }
          }
        ]
      }
```

### Email Notifications

GitHub provides default email on workflow failure.

Customize in Actions settings or use IFTTT.

## Rate Limits & Quotas

### Claude API Limits
- Standard: 5 requests/minute
- Upgrade for higher limits
- Check usage in dashboard

### GitHub API Limits
- Authenticated requests: 5,000/hour
- Each commit = 1 request
- Each file check = 1 request

### GitHub Actions Free Tier
- Public repos: Unlimited minutes
- Private repos: 2,000 minutes/month
- Self-hosted runners: No limits

## Testing the Workflow

### Manual Trigger

1. Go to Actions tab
2. Select the workflow
3. Click "Run workflow"
4. Choose branch (main)
5. Click "Run workflow" button

### Check Results

1. Wait for workflow to complete
2. Check Actions logs for errors
3. Verify commit in repository
4. Check for new post files
5. Verify site rebuilds

### Debug Tips

Enable debug logging:

```yaml
- name: Enable debug logging
  env:
    RUNNER_DEBUG: 1
  run: |
    echo "Debug mode enabled"
```

## Monitoring & Analytics

### GitHub Actions Insights

- Workflows tab shows run history
- Click run for detailed logs
- Identify patterns in failures
- Monitor execution times

### n8n Monitoring

- n8n dashboard shows execution history
- View input/output for each step
- Identify API errors
- Monitor rate limits

### Website Analytics

Add Google Analytics to Hugo theme:

```toml
[params]
  googleAnalyticsID = "G-XXXXXXXXXX"
```

Monitor:
- Daily users
- Pages per session
- Bounce rate
- Traffic sources

## Optimization Tips

### Reduce API Calls
- Cache RSS feed results (1-2 hours)
- Batch process articles
- Skip low-quality sources

### Improve Generation Quality
- Better Claude prompts
- Include publication context
- Verify facts before publishing
- Add editorial review step

### Speed Up Deployments
- Use GitHub Actions caching
- Pre-warm DNS
- Optimize images
- Minify CSS/JS

## Cost Calculation

**Monthly costs**:

| Service | Cost | Notes |
|---------|------|-------|
| GitHub Pages | Free | Included in GitHub |
| n8n Self-hosted | ~$5-20 | VPS minimum |
| Claude API | ~$0.30 | ~100 posts/month |
| Domain | ~$1 | Yearly average |
| **Total** | **~$25-50** | Budget option |

**Cloud option**:
- n8n Cloud: $100/month
- Claude API: $0.30
- Domain: $1
- **Total**: ~$100/month

## Troubleshooting

### Workflow doesn't trigger
- Check schedule syntax: `0 8 * * *` (24-hour format)
- Verify branch is `main`
- Check for branch protection rules

### Articles not committing
- Verify GitHub token has correct permissions
- Check file path is correct
- Verify branch name matches

### Site doesn't rebuild
- Check Deploy workflow logs
- Verify theme submodule is present
- Check for Hugo syntax errors

### Duplicate posts
- Verify deduplication logic
- Check article hash algorithm
- Review seen articles file

## Resources

- [GitHub Actions Documentation](https://docs.github.com/en/actions)
- [GitHub API Reference](https://docs.github.com/en/rest)
- [n8n Documentation](https://docs.n8n.io/)
- [Cron Expression Generator](https://crontab.guru/)
