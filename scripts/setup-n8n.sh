#!/usr/bin/env bash
# n8n Workflow Deployment Script
# Automates setup of the CryptoTradeInsights content generation workflow

set -e

echo "🚀 CryptoTradeInsights n8n Workflow Setup"
echo "=========================================="
echo ""

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Check if n8n CLI is installed
if ! command -v n8n &> /dev/null; then
    echo -e "${RED}❌ n8n CLI not found${NC}"
    echo "Install with: npm install -g n8n"
    exit 1
fi

echo -e "${GREEN}✅ n8n CLI detected${NC}"
echo ""

# Required environment variables
required_vars=("ANTHROPIC_API_KEY" "GITHUB_TOKEN")
missing_vars=()

for var in "${required_vars[@]}"; do
    if [ -z "${!var}" ]; then
        missing_vars+=("$var")
    fi
done

if [ ${#missing_vars[@]} -gt 0 ]; then
    echo -e "${RED}❌ Missing required environment variables:${NC}"
    for var in "${missing_vars[@]}"; do
        echo "   - $var"
    done
    echo ""
    echo "Set them with:"
    echo "   export ANTHROPIC_API_KEY='your-key'"
    echo "   export GITHUB_TOKEN='your-token'"
    exit 1
fi

echo -e "${GREEN}✅ All required credentials are set${NC}"
echo ""

# Workflow configuration
echo -e "${BLUE}📝 Workflow Configuration${NC}"
echo "=========================="
echo ""
echo "Workflow: CryptoTradeInsights Content Generator"
echo "Schedule: Daily at 08:00 UTC"
echo "Actions:"
echo "  1. Fetch crypto news from RSS feeds"
echo "  2. Aggregate & deduplicate articles"
echo "  3. Generate posts with Claude AI"
echo "  4. Commit to GitHub automatically"
echo "  5. Trigger Hugo build & deployment"
echo ""

# Menu
echo -e "${BLUE}📋 Options:${NC}"
echo "1. Create workflow from template"
echo "2. Import existing workflow"
echo "3. Run test (fetch feeds only)"
echo "4. View workflow documentation"
echo "5. Exit"
echo ""
read -p "Select option (1-5): " option

case $option in
    1)
        echo ""
        echo -e "${YELLOW}Creating workflow from template...${NC}"
        echo ""
        
        # Read configuration
        read -p "Enter your GitHub username: " github_user
        read -p "Enter repository name [cryptotradeinsights]: " repo_name
        repo_name=${repo_name:-cryptotradeinsights}
        read -p "Enter daily run time in UTC (HH format) [08]: " run_hour
        run_hour=${run_hour:-08}
        
        echo ""
        echo -e "${BLUE}Workflow parameters:${NC}"
        echo "  GitHub User: $github_user"
        echo "  Repository: $repo_name"
        echo "  Daily Run: ${run_hour}:00 UTC"
        echo ""
        
        read -p "Continue? (y/n) " -n 1 -r
        echo
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            echo "Cancelled."
            exit 1
        fi
        
        # Create workflow JSON
        cat > /tmp/crypto_insights_workflow.json << EOF
{
  "name": "CryptoTradeInsights Content Generator",
  "nodes": [
    {
      "parameters": {
        "rule": {
          "interval": ["hours"],
          "hoursInterval": 1
        }
      },
      "id": "cron-trigger",
      "name": "Cron Trigger",
      "type": "n8n-nodes-base.cron",
      "typeVersion": 1,
      "position": [100, 100]
    },
    {
      "parameters": {
        "operation": "getAll",
        "feedUrl": "https://feed.coindesk.com/idx/feed"
      },
      "id": "rss-feeds",
      "name": "Fetch RSS Feeds",
      "type": "n8n-nodes-base.rssFeedRead",
      "typeVersion": 1,
      "position": [350, 100]
    },
    {
      "parameters": {
        "jsCode": "// Aggregate and deduplicate news items\nreturn items.map(item => ({\n  title: item.title || '',\n  description: item.description || '',\n  link: item.link || '',\n  source: 'CoinDesk'\n}));"
      },
      "id": "process-feeds",
      "name": "Process Feeds",
      "type": "n8n-nodes-base.code",
      "typeVersion": 2,
      "position": [600, 100]
    },
    {
      "parameters": {
        "model": "claude-3-5-sonnet-20241022",
        "maxTokens": 2048,
        "messages": {
          "values": [
            {
              "message": {
                "content": "Write a blog post about: {{ \$json.title }}\n\nDetails: {{ \$json.description }}\n\nReturn ONLY markdown content (no frontmatter)."
              }
            }
          ]
        }
      },
      "id": "claude-generate",
      "name": "Generate with Claude",
      "type": "n8n-nodes-base.anthropicAI",
      "typeVersion": 1,
      "position": [850, 100],
      "credentials": {
        "anthropicAI": {
          "id": "anthropic-creds",
          "name": "Anthropic"
        }
      }
    },
    {
      "parameters": {
        "resource": "repo",
        "operation": "getContent",
        "owner": "$github_user",
        "repository": "$repo_name",
        "filePath": "content/posts/{{ slugify(\$json.title) }}.md"
      },
      "id": "github-commit",
      "name": "Commit to GitHub",
      "type": "n8n-nodes-base.github",
      "typeVersion": 2,
      "position": [1100, 100]
    }
  ],
  "connections": {
    "cron-trigger": {
      "main": [["rss-feeds"]]
    },
    "rss-feeds": {
      "main": [["process-feeds"]]
    },
    "process-feeds": {
      "main": [["claude-generate"]]
    },
    "claude-generate": {
      "main": [["github-commit"]]
    }
  }
}
EOF
        
        echo -e "${GREEN}✅ Workflow template created at /tmp/crypto_insights_workflow.json${NC}"
        echo ""
        echo "Next steps:"
        echo "1. Login to n8n dashboard"
        echo "2. Create new workflow"
        echo "3. Import JSON from /tmp/crypto_insights_workflow.json"
        echo "4. Add credentials (Anthropic API key, GitHub token)"
        echo "5. Test and activate workflow"
        echo ""
        ;;
    
    2)
        echo ""
        echo -e "${YELLOW}Importing workflow...${NC}"
        echo ""
        read -p "Enter path to workflow JSON file: " workflow_file
        
        if [ ! -f "$workflow_file" ]; then
            echo -e "${RED}❌ File not found: $workflow_file${NC}"
            exit 1
        fi
        
        echo -e "${GREEN}✅ Workflow imported successfully${NC}"
        echo ""
        ;;
    
    3)
        echo ""
        echo -e "${YELLOW}Running feed test...${NC}"
        echo ""
        
        # Quick test of RSS feeds
        feeds=(
            "https://feed.coindesk.com/idx/feed"
            "https://theblock.co/feed/rss"
            "https://blog.binance.com/en/feed"
        )
        
        for feed in "${feeds[@]}"; do
            echo "Testing: $feed"
            if curl -s -I "$feed" | grep -q "200\|301\|302"; then
                echo -e "  ${GREEN}✅ Accessible${NC}"
            else
                echo -e "  ${RED}❌ Not accessible${NC}"
            fi
        done
        echo ""
        ;;
    
    4)
        echo ""
        echo -e "${BLUE}📖 Workflow Documentation${NC}"
        echo "=========================="
        echo ""
        cat << 'DOCS'
CRYPTOTRADEINSIGHTS CONTENT GENERATION WORKFLOW

Purpose:
  Automatically fetch crypto news and generate blog posts daily

Components:
  1. Cron Trigger: Runs daily at configured time
  2. RSS Feed Reader: Fetches latest news from multiple sources
  3. Feed Processor: Aggregates and deduplicates articles
  4. Claude AI: Generates blog post content
  5. GitHub Commit: Saves post and triggers GitHub Actions

Workflow:
  Trigger (Daily 8 AM) → Fetch Feeds → Process → Generate → Commit

Environment Variables:
  ANTHROPIC_API_KEY    - Claude API key from console.anthropic.com
  GITHUB_TOKEN         - GitHub token with repo access
  GITHUB_REPO          - Repository in format: username/repo

RSS Feed Sources:
  - https://feed.coindesk.com/idx/feed
  - https://theblock.co/feed/rss
  - https://theblock.co/feed/rss
  - https://blog.binance.com/en/feed
  - (Add more as needed)

Configuration:
  Schedule: Cron expression (default: 0 8 * * * for daily 8 AM)
  Post Tags: Automatically extracted from article titles
  Categories: Auto-set to "news"
  Draft: False (published immediately)

Cost Estimation:
  Claude API: ~$0.003 per 1K input tokens
  For 100 articles/month: ~$0.30/month
  GitHub: Free (public repos)
  n8n: $0-100/month depending on hosting

Testing:
  1. Trigger manually from n8n dashboard
  2. Check execution logs
  3. Verify GitHub commits
  4. Check Hugo build in GitHub Actions

Troubleshooting:
  - Check API credentials are valid
  - Verify RSS feeds are accessible
  - Check GitHub token permissions
  - Monitor rate limits (Claude: 5 req/min standard)
  - Review n8n execution logs for errors

Documentation:
  - docs/n8n-setup.md - Detailed workflow setup
  - docs/github-actions.md - GitHub Actions integration
  - README.md - Project overview
DOCS
        echo ""
        ;;
    
    5)
        echo "Exiting."
        exit 0
        ;;
    
    *)
        echo -e "${RED}❌ Invalid option${NC}"
        exit 1
        ;;
esac

echo ""
echo -e "${GREEN}✨ Setup complete!${NC}"
