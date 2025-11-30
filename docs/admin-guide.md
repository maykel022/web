# Admin Dashboard Guide

## Overview

The CryptoTradeInsights admin dashboard is a modern web interface for managing your crypto blog without touching code or GitHub.

**Access URL**: `http://localhost:1313/admin/` (local) or `/admin/` on your deployed site

## What You Can Do

✅ Create, edit, and delete blog posts  
✅ Manage tags and categories  
✅ View post statistics  
✅ Search and filter posts  
✅ Auto-sync posts to GitHub (optional)  
✅ Full markdown support  
✅ Draft/publish toggle  

## Getting Started

### 1. Access the Dashboard

**During local development:**
```bash
hugo server
# Open http://localhost:1313/admin/
```

**After deployment:**
- Navigate to your domain's `/admin/` path
- Example: `https://cryptotradeinsights.com/admin/`

### 2. Navigate the Interface

The dashboard has a sidebar menu with options:
- 📊 **Dashboard** - Overview and recent posts
- 📝 **Posts** - View all posts, search, filter
- ✏️ **New Post** - Create new blog posts
- 🏷️ **Tags** - Manage post tags
- 📂 **Categories** - Manage post categories
- ⚙️ **Settings** - Configure GitHub sync, manage data

## Creating Posts

### Step 1: Click "✏️ New Post"
- From sidebar or dashboard card
- Form opens with empty fields

### Step 2: Fill in Post Details

**Title** (required)
- Post headline
- Example: "Bitcoin Rally Continues - November 2025"
- Max 200 characters (no limit enforced)

**Date** (required)
- Publication date
- Auto-filled with today's date
- Use date picker to select

**Status**
- **Published**: Post is live on website
- **Draft**: Post is hidden (work in progress)

**Description** (recommended)
- 150-160 characters
- Summary that appears in post previews
- Keep it concise and keyword-rich

**Tags** (optional)
- Comma-separated keywords
- Example: `bitcoin, defi, trading, news`
- Used for navigation and categorization
- 3-5 tags per post recommended

**Category** (required)
- Choose from: News, Analysis, Tutorial
- Or create new category
- Helps organize posts

**Content** (required)
- Full post in Markdown format
- Supports headings, bold, italic, links, code blocks
- Write naturally, then save

### Step 3: Save Post

Click "💾 Save Post" button
- Post saves to browser storage
- If GitHub sync enabled, auto-commits to repo
- Redirects to posts list

### Example Post Structure

```markdown
## Section Heading

Bitcoin has surged above $50,000 as institutional adoption...

### Subsection

Key points:
- Point 1
- Point 2
- Point 3

Check out [this resource](https://example.com) for more info.

**Bold text** and *italic text* are supported.
```

## Editing Posts

### Quick Edit

1. Go to "📝 Posts"
2. Find your post
3. Click "✏️ Edit" button
4. Make changes
5. Click "💾 Save Post"

### Search Before Editing

1. Use search box to find post by title
2. Use status filter for published/draft posts
3. Click edit button

## Deleting Posts

### Delete Permanently

1. Go to "📝 Posts"
2. Click "🗑️ Delete" button on post
3. Confirm deletion
4. Post removed from website

**Note**: If GitHub sync enabled, post is also deleted from GitHub repo.

## Managing Tags

### Add New Tag

1. Go to "🏷️ Tags"
2. Enter tag name in input field
3. Click "Add Tag"
4. Tag appears in list

### Delete Tag

1. Go to "🏷️ Tags"
2. Find tag in list
3. Click × button
4. Tag removed

**Best Practices:**
- Keep tags consistent
- Use lowercase
- Avoid duplicates
- Max 50-60 tags total

### Common Tags

For crypto blog, consider tags like:
- bitcoin
- ethereum
- defi (Decentralized Finance)
- altcoins
- nft
- trading
- news
- regulations
- blockchain
- exchanges

## Managing Categories

### Add New Category

1. Go to "📂 Categories"
2. Enter category name
3. Click "Add Category"
4. Appears in dropdown when editing posts

### Delete Category

1. Click × on category
2. Confirm deletion
3. Posts keep their category even if category deleted

**Default Categories:**
- News (latest updates)
- Analysis (market analysis)
- Tutorial (guides and how-tos)

Add categories for broad topics:
- Exchange News
- DeFi Updates
- Regulation News
- Price Analysis

## Dashboard Stats

The main dashboard shows:

**📊 Total Posts**
- Count of all posts (published + draft)

**🏷️ Total Tags**
- Count of unique tags

**📂 Total Categories**
- Count of categories

**📝 Draft Posts**
- Count of unpublished drafts

**Recent Posts**
- Latest 5 posts
- Quick access to edit

## Search & Filter

### Search Posts
- Type in search box
- Searches post titles only
- Results update in real-time
- Case-insensitive

### Filter by Status
- **All Status**: Show all posts
- **Published**: Only published posts
- **Draft**: Only unpublished posts

## Data Storage

### Local Storage (Default)

All data stored in browser:
- Posts
- Tags
- Categories
- Settings

**Advantages:**
- Works offline
- Fast performance
- No server required
- Private data

**Limitations:**
- Only on one device/browser
- ~5-10MB limit
- Lost if cleared

**Backup tips:**
- Export data periodically
- Screenshot important info
- Keep copy of posts

### GitHub Integration (Optional)

Posts can sync to GitHub automatically.

**Setup:**
1. Go to Settings ⚙️
2. Add GitHub token
3. Add repository (e.g., `maykel022/web`)
4. Select "GitHub Auto-Commit" mode
5. Save settings

**Benefits:**
- Automatic backup
- Version control
- Auto-deploy via GitHub Actions
- Share with team

**How it works:**
1. Create/edit post in dashboard
2. Click save
3. Post auto-commits to GitHub
4. GitHub Actions builds Hugo
5. Site updates automatically

## Settings

### GitHub Configuration

**GitHub Token**
- Personal access token from github.com/settings/tokens
- Scope: `repo`
- Stored locally in browser
- Used only for commits

**GitHub Repository**
- Format: `username/repo`
- Example: `maykel022/web`
- Must have write access

**API Mode**
- Local Storage: Save only locally
- GitHub Auto-Commit: Auto-save to GitHub

### Data Management

**Clear All Data**
- ⚠️ Warning: Deletes everything
- Cannot be undone
- Use with caution
- Backup first!

## Security & Privacy

### Browser Storage

✅ **Secure:**
- Data stored locally
- Only accessible from same domain
- HTTPS encrypts in transit

⚠️ **Not Secure:**
- Anyone with browser access
- Admin dashboard not password protected
- GitHub token visible in localStorage

### Recommendations

1. Use on trusted device only
2. Don't share browser session
3. Clear data before sharing device
4. Use private/incognito mode
5. Protect GitHub token
6. Consider password protection for deployment

### GitHub Token Safety

- Stored in browser localStorage
- Only used for commits to your repo
- Can be rotated anytime
- Use read-only scope if possible
- Consider creating disposable token

## Keyboard Tips

- Tab: Navigate form fields
- Enter: Submit form
- Escape: Cancel (coming soon)
- Ctrl+S: Save (coming soon)

## Troubleshooting

### Posts Not Saving

**Check:**
1. Browser console for errors (F12)
2. LocalStorage enabled
3. Not in private/incognito mode
4. Try refreshing page

**Solution:**
- Clear browser cache
- Try different browser
- Check localStorage quota

### Search Not Working

- Searches title only
- Check exact spelling
- Try shorter search term
- Clear search box

### GitHub Sync Failed

**Check:**
1. Token is valid
2. Repository exists
3. Token has `repo` scope
4. Repository is public/accessible

**Solution:**
- Regenerate GitHub token
- Verify repository name
- Try toggling API mode off/on
- Check GitHub API status

### Dashboard Won't Load

**Check:**
1. JavaScript enabled in browser
2. Not blocking external scripts
3. Browser supports ES6
4. No browser extensions interfering

**Solution:**
- Try different browser
- Disable extensions
- Clear browser cache
- Check browser console (F12)

## Tips & Tricks

### Markdown Tips

```markdown
# Heading 1
## Heading 2
### Heading 3

**Bold text**
*Italic text*
`Inline code`

- Bullet point
- Another point

1. Numbered list
2. Second item

[Link text](https://example.com)

![Image alt](image.jpg)

> Blockquote
> Multiple lines

`​`​`
Code block
Multiple lines
`​`​`
```

### Post Organization

- Use consistent tags
- One category per post
- Clear, descriptive titles
- Rich descriptions
- Proper headings in content

### Workflow Optimization

1. **Draft first**: Create as draft
2. **Edit later**: Refine over time
3. **Publish when ready**: Toggle status
4. **Plan ahead**: Keep editorial calendar

## Advanced Features

### Export/Import (Coming Soon)

- Backup all posts
- Bulk operations
- Import from Medium/dev.to

### Collaboration (Coming Soon)

- Share access
- User roles
- Edit history
- Comments

### Analytics (Coming Soon)

- View counts
- Popular posts
- Traffic sources
- Engagement metrics

## Getting Help

1. **Documentation**: Check admin/README.md
2. **GitHub Issues**: Report bugs
3. **Browser Console**: Check for errors (F12)
4. **Inspect Element**: Debug CSS/layout

## More Resources

- [Hugo Markdown Guide](https://www.markdownguide.org/)
- [Git & GitHub Basics](https://docs.github.com/en/get-started)
- [CryptoTradeInsights Docs](../docs/)

---

**Last Updated**: November 2025

**Version**: 1.0

**Next Update**: TBD with analytics, collaboration, and import/export features
