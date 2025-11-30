# Admin Dashboard - CryptoTradeInsights

A modern, dark-themed admin dashboard for managing your crypto blog posts, tags, and categories.

## Features

✅ **Dashboard**
- Overview statistics (total posts, tags, categories, drafts)
- Recent posts list
- Quick access to editing

✅ **Posts Management**
- Create new posts
- Edit existing posts
- Delete posts
- Search posts by title
- Filter by status (published/draft)
- Markdown content support
- Custom metadata (tags, categories, description)

✅ **Tags Management**
- Add/delete tags
- View all tags
- Use tags in posts

✅ **Categories Management**
- Add/delete categories
- Default categories included (news, analysis, tutorial)
- Use categories in posts

✅ **Post Editor**
- Full Markdown support
- Live frontmatter editing
- Date picker
- Status toggle (draft/published)
- Tags input (comma-separated)
- Category selection

✅ **Settings**
- GitHub token configuration (optional)
- GitHub repository configuration
- API mode selection
- Data management

## Accessing the Dashboard

1. **Locally during development:**
   ```bash
   hugo server
   # Open http://localhost:1313/admin/
   ```

2. **On deployed site:**
   - After deployment, visit: `https://yourdomain.com/admin/`

## How to Use

### Create a New Post

1. Click "✏️ New Post" in sidebar or from dashboard
2. Fill in the post details:
   - **Title**: Post headline
   - **Date**: Publication date (auto-filled with today)
   - **Status**: Choose "Published" or "Draft"
   - **Description**: Short summary (appears in previews)
   - **Tags**: Comma-separated tags (e.g., bitcoin, defi, trading)
   - **Category**: Select from existing categories
   - **Content**: Write your post in Markdown
3. Click "💾 Save Post"

### Edit a Post

1. Go to "📝 Posts"
2. Click "✏️ Edit" on the post you want to modify
3. Make your changes
4. Click "💾 Save Post"

### Manage Tags

1. Go to "🏷️ Tags"
2. **Add new tag**: Enter tag name and click "Add Tag"
3. **Delete tag**: Click the × button on any tag

### Manage Categories

1. Go to "📂 Categories"
2. **Add new category**: Enter category name and click "Add Category"
3. **Delete category**: Click the × button on any category

### Search & Filter Posts

In the "📝 Posts" section:
- Use the search box to find posts by title
- Use the "All Status" dropdown to filter published/draft posts

## Data Storage

### Local Storage (Default)

All data is stored in your browser's **localStorage**:
- Posts
- Tags
- Categories
- Settings

**Data persists** across browser sessions on the same device.

**Limitations:**
- Limited to ~5-10MB per domain
- Only available on the same browser/device
- Lost if localStorage is cleared

### GitHub Integration (Optional)

To enable auto-saving to GitHub:

1. Get a **GitHub Personal Access Token**:
   - Go to https://github.com/settings/tokens
   - Create new token with `repo` scope
   - Copy the token

2. In Admin Dashboard → Settings:
   - Paste token in "GitHub Token" field
   - Enter your repository (e.g., `maykel022/web`)
   - Select "GitHub Auto-Commit" mode

3. Now posts auto-save to `/content/posts/` in your repo

## Post Structure

Posts created in the admin dashboard follow Hugo's markdown format:

```markdown
+++
date = '2025-11-30T10:00:00Z'
draft = false
title = 'Your Post Title'
description = "Short description"
tags = ["crypto", "bitcoin"]
categories = ["news"]
author = "CryptoTradeInsights"
showToc = true
+++

Your post content in Markdown...
```

## Search & Filter

### Search Posts
- Type in the search box
- Results update in real-time
- Searches post titles

### Filter by Status
- All Status: Show all posts
- Published: Only published posts
- Draft: Only draft posts

## Best Practices

### Post Titles
- Keep clear and descriptive
- 50-60 characters ideal
- Include main keyword

### Descriptions
- 150-160 characters
- Summarize the post
- Include key points

### Tags
- Use 3-5 tags per post
- Keep tags consistent
- Example: bitcoin, ethereum, defi, trading, news

### Categories
- Use existing categories
- Create categories for broad topics
- Use consistently

### Content
- Write in clear Markdown
- Use headings (##, ###)
- Include links and images
- Keep paragraphs short

## Keyboard Shortcuts (Coming Soon)

- `Ctrl/Cmd + S`: Save post
- `Ctrl/Cmd + N`: New post
- `Esc`: Close editor

## Troubleshooting

### Posts not saving
- Check browser console for errors (F12)
- Ensure localStorage is enabled
- Try clearing cache if issues persist

### Can't find posts
- Check the status filter (might be filtering drafts)
- Search for exact title
- Check if in wrong browser/device

### Settings not saving
- Ensure localStorage is enabled
- Check browser console for errors
- Try clearing localStorage and reapplying

### GitHub integration not working
- Verify token is valid and has `repo` scope
- Check repository name format: `owner/repo`
- Ensure token hasn't expired

## Future Features

- 🔄 Real-time sync to GitHub
- 📸 Image upload support
- 🔍 Advanced search and filters
- 📊 Analytics dashboard
- 🔐 Authentication/login
- 📱 Mobile app
- 🤖 AI integration for post suggestions

## Technical Details

### Technologies Used
- **HTML5**: Markup
- **CSS3**: Styling with CSS Grid & Flexbox
- **Vanilla JavaScript**: No dependencies required
- **localStorage API**: Client-side data persistence
- **GitHub API**: Optional backend integration

### Browser Support
- Chrome 60+
- Firefox 55+
- Safari 11+
- Edge 79+

### Performance
- Single-file application (~15KB minified)
- No external dependencies
- Instant load times
- Works offline (with local storage)

## Security Notes

⚠️ **Important:**

1. **GitHub Token**: Stored in browser localStorage
   - Never commit to git
   - Only use in private environments
   - Use read-only token if possible
   - Can be cleared anytime in Settings

2. **Local Storage**: Accessible from browser console
   - Don't share your browser session
   - Clear sensitive data if sharing device
   - Use incognito mode for public devices

3. **Self-hosted**: If deployed publicly
   - Protect with authentication
   - Use HTTPS only
   - Consider password protection
   - Don't expose on public URLs

## Support

For issues or questions:
1. Check browser console (F12) for errors
2. Review this documentation
3. Open an issue on GitHub
4. Check GitHub discussions

## License

MIT License - Free to use and modify
