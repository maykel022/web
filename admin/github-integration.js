/**
 * GitHub Integration Module
 * Handles saving posts directly to GitHub repository
 */

const githubIntegration = {
    token: null,
    repo: null,
    owner: null,
    branch: 'main',

    init() {
        this.token = localStorage.getItem('github_token');
        const repoString = localStorage.getItem('github_repo');
        
        if (repoString && repoString.includes('/')) {
            [this.owner, this.repo] = repoString.split('/');
        }
    },

    /**
     * Create or update a file in GitHub
     * @param {string} filePath - Path to file (e.g., "content/posts/my-post.md")
     * @param {string} content - File content
     * @param {string} message - Commit message
     * @returns {Promise}
     */
    async commitFile(filePath, content, message) {
        if (!this.token || !this.owner || !this.repo) {
            console.error('GitHub not configured');
            return false;
        }

        try {
            // Get current file SHA (needed for update)
            let sha = null;
            try {
                const getResponse = await fetch(
                    `https://api.github.com/repos/${this.owner}/${this.repo}/contents/${filePath}`,
                    {
                        headers: {
                            'Authorization': `token ${this.token}`,
                            'Accept': 'application/vnd.github.v3+json'
                        }
                    }
                );
                
                if (getResponse.ok) {
                    const data = await getResponse.json();
                    sha = data.sha;
                }
            } catch (e) {
                // File doesn't exist yet (new file)
            }

            // Encode content to base64
            const encodedContent = btoa(unescape(encodeURIComponent(content)));

            // Prepare request body
            const body = {
                message,
                content: encodedContent,
                branch: this.branch
            };

            if (sha) {
                body.sha = sha; // For update
            }

            // Commit to GitHub
            const response = await fetch(
                `https://api.github.com/repos/${this.owner}/${this.repo}/contents/${filePath}`,
                {
                    method: 'PUT',
                    headers: {
                        'Authorization': `token ${this.token}`,
                        'Accept': 'application/vnd.github.v3+json',
                        'Content-Type': 'application/json'
                    },
                    body: JSON.stringify(body)
                }
            );

            if (!response.ok) {
                throw new Error(`GitHub API error: ${response.statusText}`);
            }

            return true;
        } catch (error) {
            console.error('GitHub commit failed:', error);
            throw error;
        }
    },

    /**
     * Delete a file from GitHub
     * @param {string} filePath - Path to file
     * @param {string} message - Commit message
     * @returns {Promise}
     */
    async deleteFile(filePath, message) {
        if (!this.token || !this.owner || !this.repo) {
            console.error('GitHub not configured');
            return false;
        }

        try {
            // Get file SHA
            const getResponse = await fetch(
                `https://api.github.com/repos/${this.owner}/${this.repo}/contents/${filePath}`,
                {
                    headers: {
                        'Authorization': `token ${this.token}`,
                        'Accept': 'application/vnd.github.v3+json'
                    }
                }
            );

            if (!getResponse.ok) {
                throw new Error('File not found');
            }

            const data = await getResponse.json();

            // Delete file
            const deleteResponse = await fetch(
                `https://api.github.com/repos/${this.owner}/${this.repo}/contents/${filePath}`,
                {
                    method: 'DELETE',
                    headers: {
                        'Authorization': `token ${this.token}`,
                        'Accept': 'application/vnd.github.v3+json',
                        'Content-Type': 'application/json'
                    },
                    body: JSON.stringify({
                        message,
                        sha: data.sha,
                        branch: this.branch
                    })
                }
            );

            if (!deleteResponse.ok) {
                throw new Error(`Delete failed: ${deleteResponse.statusText}`);
            }

            return true;
        } catch (error) {
            console.error('GitHub delete failed:', error);
            throw error;
        }
    },

    /**
     * Convert post to Hugo markdown format
     * @param {object} post - Post object
     * @returns {string} - Formatted markdown
     */
    formatPostMarkdown(post) {
        const date = new Date(post.date).toISOString();
        const tagsJson = JSON.stringify(post.tags || []);
        const categoryJson = JSON.stringify(post.category || 'news');

        const frontmatter = `+++
date = '${date}'
draft = ${post.draft}
title = '${post.title.replace(/'/g, "\\'")}'
description = "${post.description.replace(/"/g, '\\"')}"
tags = ${tagsJson}
categories = ["${post.category || 'news'}"]
author = "CryptoTradeInsights"
showToc = true
TocOpen = false
hidemeta = false
+++

`;

        return frontmatter + post.content;
    },

    /**
     * Generate filename from post title
     * @param {string} title - Post title
     * @returns {string} - Filename
     */
    generateFilename(title) {
        return title
            .toLowerCase()
            .replace(/[^\w\s-]/g, '')
            .replace(/[\s_-]+/g, '-')
            .replace(/^-+|-+$/g, '')
            .substring(0, 50) + '.md';
    },

    /**
     * Save post to GitHub
     * @param {object} post - Post object
     * @param {boolean} isNew - True if new post
     * @returns {Promise}
     */
    async savePost(post, isNew = true) {
        const filename = this.generateFilename(post.title);
        const filepath = `content/posts/${filename}`;
        const content = this.formatPostMarkdown(post);
        const message = `${isNew ? 'feat' : 'update'}: ${post.title}`;

        return this.commitFile(filepath, content, message);
    },

    /**
     * Delete post from GitHub
     * @param {object} post - Post object
     * @returns {Promise}
     */
    async deletePost(post) {
        const filename = this.generateFilename(post.title);
        const filepath = `content/posts/${filename}`;
        const message = `delete: ${post.title}`;

        return this.deleteFile(filepath, message);
    },

    /**
     * Verify GitHub credentials
     * @returns {Promise<boolean>}
     */
    async verifyCredentials() {
        if (!this.token || !this.owner || !this.repo) {
            return false;
        }

        try {
            const response = await fetch(
                `https://api.github.com/repos/${this.owner}/${this.repo}`,
                {
                    headers: {
                        'Authorization': `token ${this.token}`,
                        'Accept': 'application/vnd.github.v3+json'
                    }
                }
            );

            return response.ok;
        } catch (error) {
            console.error('Credential verification failed:', error);
            return false;
        }
    },

    /**
     * Get repository information
     * @returns {Promise<object>}
     */
    async getRepoInfo() {
        if (!this.token || !this.owner || !this.repo) {
            return null;
        }

        try {
            const response = await fetch(
                `https://api.github.com/repos/${this.owner}/${this.repo}`,
                {
                    headers: {
                        'Authorization': `token ${this.token}`,
                        'Accept': 'application/vnd.github.v3+json'
                    }
                }
            );

            if (response.ok) {
                return await response.json();
            }
        } catch (error) {
            console.error('Failed to fetch repo info:', error);
        }

        return null;
    }
};

// Initialize on load
document.addEventListener('DOMContentLoaded', () => {
    githubIntegration.init();
});
