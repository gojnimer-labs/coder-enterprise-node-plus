# Quick Start Guide

## Push to GitHub

First, navigate to the repository and push all files:

```bash
cd /home/coder/projects/coder-enterprise-node-plus

# Initialize git if not already done
git add .
git commit -m "Initial setup: Docker image with code-server and claude-code

- Add Dockerfile extending codercom/enterprise-node
- Install code-server and claude-code
- Configure automated builds via GitHub Actions
- Add Dependabot for dependency monitoring
- Implement automatic release creation with changelogs

🤖 Generated with Claude Code"

git push origin main
```

## What Happens Next

After pushing to GitHub:

1. **First Build Triggers** (~2-5 minutes)
   - Workflow detects latest versions of code-server and claude-code
   - Builds Docker image with both tools
   - Pushes to `ghcr.io/gojnimer-labs/coder-enterprise-node-plus`
   - Creates a GitHub release with detailed changelog

2. **Release Created** (~30 seconds after build)
   - Tagged with timestamp (e.g., `v2025.12.03-143000`)
   - Includes changelog with versions, docker commands, commits
   - Available in the Releases section

3. **Dependabot Activates** (within 24 hours)
   - Monitors for Docker base image updates
   - Monitors for GitHub Actions updates
   - Creates PRs automatically when updates are available

## Using gh CLI

Your gh CLI is already configured! You can now:

```bash
# View repository info
gh repo view

# List releases
gh release list

# View latest release
gh release view --web

# Trigger manual build
gh workflow run build-and-push.yml

# Check workflow status
gh run list --workflow=build-and-push.yml
```

## Using the Image

Once the first build completes:

```bash
# Pull the latest image
docker pull ghcr.io/gojnimer-labs/coder-enterprise-node-plus:latest

# Run it
docker run -it -p 8080:8080 ghcr.io/gojnimer-labs/coder-enterprise-node-plus:latest

# Access code-server
# Open browser to http://localhost:8080

# Use claude-code
docker exec -it <container-id> claude --version
```

## Monitoring

- **Actions**: https://github.com/gojnimer-labs/coder-enterprise-node-plus/actions
- **Packages**: https://github.com/gojnimer-labs/coder-enterprise-node-plus/pkgs/container/coder-enterprise-node-plus
- **Releases**: https://github.com/gojnimer-labs/coder-enterprise-node-plus/releases
- **Dependabot**: Repository Settings > Security > Dependabot

## Automatic Updates

The workflow automatically:
- Checks for new versions weekly (Sundays at midnight UTC)
- Builds when you push to main
- Builds when Dependabot updates dependencies
- Creates releases with changelogs for every successful build

## Need Help?

- See [SETUP.md](SETUP.md) for detailed setup instructions
- See [README.md](README.md) for usage documentation
- See [CHANGELOG_EXAMPLE.md](CHANGELOG_EXAMPLE.md) for example release notes
