#!/usr/bin/env python3
"""
CryptoTradeInsights Content Generator
Generates blog posts from crypto news feeds using Claude AI
"""

import os
import json
import re
import hashlib
import feedparser
import requests
from datetime import datetime
from pathlib import Path
from typing import Optional, List, Dict
from urllib.parse import urlparse

# Configuration
CLAUDE_API_KEY = os.getenv("ANTHROPIC_API_KEY")
GITHUB_TOKEN = os.getenv("GITHUB_TOKEN")
GITHUB_REPO = os.getenv("GITHUB_REPO", "username/cryptotradeinsights")
CONTENT_DIR = Path(__file__).parent.parent / "content" / "posts"
CLAUDE_API_URL = "https://api.anthropic.com/v1/messages"
GITHUB_API_URL = "https://api.github.com"

# RSS Feeds to monitor
RSS_FEEDS = [
    "https://feeds.bloomberg.com/markets/news.rss",
    "https://feed.coindesk.com/idx/feed",
    "https://theblock.co/feed/rss",
    "https://feeds.bloomberg.com/crypto.rss",
    "https://blog.binance.com/en/feed",
]

# Deduplication file
DEDUP_FILE = Path(__file__).parent / ".seen_articles.json"


def load_seen_articles() -> set:
    """Load previously seen article hashes"""
    if DEDUP_FILE.exists():
        with open(DEDUP_FILE) as f:
            return set(json.load(f))
    return set()


def save_seen_articles(seen: set):
    """Save article hashes to prevent duplicates"""
    with open(DEDUP_FILE, "w") as f:
        json.dump(list(seen), f)


def hash_article(title: str, url: str) -> str:
    """Create hash for article deduplication"""
    content = f"{title}:{url}".encode()
    return hashlib.md5(content).hexdigest()


def fetch_rss_feeds() -> List[Dict]:
    """Fetch and parse all RSS feeds"""
    articles = []
    
    for feed_url in RSS_FEEDS:
        try:
            print(f"📰 Fetching {feed_url}...")
            feed = feedparser.parse(feed_url)
            
            for entry in feed.entries[:5]:  # Get latest 5 from each feed
                article = {
                    "title": entry.get("title", ""),
                    "description": entry.get("description", "")[:500],  # Truncate
                    "link": entry.get("link", ""),
                    "published": entry.get("published", datetime.now().isoformat()),
                    "source": feed.feed.get("title", urlparse(feed_url).netloc),
                }
                articles.append(article)
        except Exception as e:
            print(f"❌ Error fetching {feed_url}: {e}")
    
    return articles


def deduplicate_articles(articles: List[Dict], seen: set) -> List[Dict]:
    """Remove previously seen articles"""
    new_articles = []
    
    for article in articles:
        article_hash = hash_article(article["title"], article["link"])
        if article_hash not in seen:
            new_articles.append(article)
            seen.add(article_hash)
    
    return new_articles


def generate_post_with_claude(article: Dict) -> Optional[str]:
    """Use Claude to generate a blog post from article"""
    
    if not CLAUDE_API_KEY:
        print("❌ ANTHROPIC_API_KEY not set")
        return None
    
    prompt = f"""Write a comprehensive blog post about this cryptocurrency news:

Title: {article['title']}
Description: {article['description']}
Source: {article['source']}

Requirements:
- Write 500-1000 words of original analysis
- Include relevant context about crypto markets
- Cite the source
- Use Markdown formatting
- NO frontmatter (we'll add that separately)
- Include relevant crypto terms naturally
- Be informative but accessible

Return only the markdown content."""

    try:
        print(f"🤖 Generating post with Claude...")
        response = requests.post(
            CLAUDE_API_URL,
            headers={
                "x-api-key": CLAUDE_API_KEY,
                "anthropic-version": "2023-06-01",
                "content-type": "application/json",
            },
            json={
                "model": "claude-3-5-sonnet-20241022",
                "max_tokens": 2048,
                "messages": [
                    {
                        "role": "user",
                        "content": prompt,
                    }
                ],
            },
            timeout=30,
        )
        response.raise_for_status()
        
        data = response.json()
        content = data["content"][0]["text"]
        return content
    
    except Exception as e:
        print(f"❌ Claude API error: {e}")
        return None


def slugify(text: str) -> str:
    """Convert title to URL-safe slug"""
    text = text.lower()
    text = re.sub(r"[^\w\s-]", "", text)
    text = re.sub(r"[\s_-]+", "-", text)
    text = re.sub(r"^-+|-+$", "", text)
    return text[:50]


def extract_tags(article: Dict) -> List[str]:
    """Extract relevant crypto tags from article"""
    tags = ["crypto", "news"]
    
    title_lower = article["title"].lower()
    
    tag_keywords = {
        "bitcoin": ["bitcoin", "btc"],
        "ethereum": ["ethereum", "eth"],
        "defi": ["defi", "decentralized finance"],
        "altcoins": ["altcoin", "altcoins"],
        "nft": ["nft", "nfts"],
        "regulations": ["regulation", "sec", "cftc", "regulatory"],
        "trading": ["trading", "trader", "trade"],
        "exchanges": ["exchange", "coinbase", "binance", "kraken"],
    }
    
    for tag, keywords in tag_keywords.items():
        if any(keyword in title_lower for keyword in keywords):
            tags.append(tag)
    
    return list(set(tags))[:5]  # Max 5 tags


def create_hugo_markdown(article: Dict, content: str) -> str:
    """Create Hugo-formatted markdown with frontmatter"""
    
    tags = extract_tags(article)
    date_str = datetime.fromisoformat(article["published"].replace("Z", "+00:00")).isoformat()
    
    frontmatter = f"""+++
date = '{date_str}'
draft = false
title = '{article['title'].replace("'", "\\'")}'
description = "{article['description'][:160].replace('"', '\\"')}"
tags = {json.dumps(tags)}
categories = ["news"]
author = "CryptoTradeInsights"
showToc = true
TocOpen = false
hidemeta = false
+++

"""
    
    # Add source attribution
    content_with_source = f"{content}\n\n---\n\n*Source: {article['source']}*\n*Original: [{article['title']}]({article['link']})*"
    
    return frontmatter + content_with_source


def commit_to_github(filename: str, content: str, title: str) -> bool:
    """Commit the generated post to GitHub"""
    
    if not GITHUB_TOKEN:
        print("⚠️  GITHUB_TOKEN not set - saving locally only")
        return save_locally(filename, content)
    
    import base64
    
    try:
        # Prepare GitHub API request
        encoded_content = base64.b64encode(content.encode()).decode()
        
        owner, repo = GITHUB_REPO.split("/")
        file_path = f"content/posts/{filename}"
        url = f"{GITHUB_API_URL}/repos/{owner}/{repo}/contents/{file_path}"
        
        print(f"📤 Committing to GitHub...")
        
        response = requests.put(
            url,
            headers={
                "Authorization": f"token {GITHUB_TOKEN}",
                "Accept": "application/vnd.github.v3+json",
            },
            json={
                "message": f"AI: Auto-generated post - {title}",
                "content": encoded_content,
                "branch": "main",
            },
            timeout=10,
        )
        response.raise_for_status()
        
        print(f"✅ Committed to GitHub: {filename}")
        return True
    
    except Exception as e:
        print(f"❌ GitHub commit failed: {e}")
        print("💾 Saving locally instead...")
        return save_locally(filename, content)


def save_locally(filename: str, content: str) -> bool:
    """Save post to local filesystem"""
    try:
        CONTENT_DIR.mkdir(parents=True, exist_ok=True)
        filepath = CONTENT_DIR / filename
        
        with open(filepath, "w") as f:
            f.write(content)
        
        print(f"✅ Saved locally: {filepath}")
        return True
    except Exception as e:
        print(f"❌ Local save failed: {e}")
        return False


def main():
    """Main workflow"""
    
    print("🚀 CryptoTradeInsights Content Generator")
    print("=" * 50)
    
    # Load previously seen articles
    seen = load_seen_articles()
    print(f"📚 Loaded {len(seen)} previously seen articles")
    
    # Fetch RSS feeds
    print(f"\n📰 Fetching feeds...")
    articles = fetch_rss_feeds()
    print(f"✅ Found {len(articles)} articles")
    
    # Deduplicate
    print(f"\n🔍 Deduplicating...")
    new_articles = deduplicate_articles(articles, seen)
    save_seen_articles(seen)
    print(f"✅ {len(new_articles)} new articles to process")
    
    # Generate posts
    print(f"\n📝 Generating posts...")
    generated = 0
    for article in new_articles[:3]:  # Limit to 3 per run
        print(f"\n📌 Processing: {article['title'][:60]}...")
        
        # Generate content
        content = generate_post_with_claude(article)
        if not content:
            print("⏭️  Skipping due to generation error")
            continue
        
        # Create Hugo markdown
        markdown = create_hugo_markdown(article, content)
        
        # Generate filename
        filename = f"{slugify(article['title'])}.md"
        
        # Commit or save
        if commit_to_github(filename, markdown, article['title']):
            generated += 1
        
        print()
    
    print("=" * 50)
    print(f"✨ Generated {generated} posts")
    print("🎉 Done!")


if __name__ == "__main__":
    main()
