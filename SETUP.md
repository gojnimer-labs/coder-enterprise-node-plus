# Setup Guide

## Initial Setup

After pushing this repository to GitHub, follow these steps to enable automated builds:

### 1. Enable GitHub Actions

1. Go to your repository settings
2. Navigate to Actions > General
3. Ensure "Allow all actions and reusable workflows" is selected
4. Enable "Read and write permissions" for workflows

### 2. Enable GitHub Container Registry (GHCR)

1. The workflow is already configured to push to `ghcr.io`
2. Images will be published to `ghcr.io/gojnimer-labs/coder-enterprise-node-plus`
3. The `GITHUB_TOKEN` is automatically provided by GitHub Actions

### 3. Enable Dependabot

Dependabot should be automatically enabled with the `.github/dependabot.yml` configuration.

To verify:
1. Go to repository Settings > Security > Code security and analysis
2. Ensure "Dependabot alerts" and "Dependabot security updates" are enabled

### 4. Manual Trigger (Optional)

To manually trigger a build:
1. Go to Actions tab
2. Select "Build and Push Docker Image" workflow
3. Click "Run workflow"
4. Select branch and click "Run workflow"

## How It Works

### Automated Version Detection

The workflow automatically detects the latest versions of:
- **code-server**: Queries GitHub API for latest release
- **claude-code**: Queries GitHub API for latest release

### Build Triggers

Builds are triggered by:
1. **Push to main**: Immediate build on code changes
2. **Weekly schedule**: Every Sunday at midnight UTC
3. **Dependabot PRs**: When dependencies are updated
4. **Manual dispatch**: Via GitHub Actions UI

### Image Tags

Each build creates multiple tags:
- `latest`: Always points to the most recent build
- `code-server-X.Y.Z`: Tagged with code-server version
- `claude-code-X.Y.Z`: Tagged with claude-code version
- `main-abc123`: Branch name and commit SHA

### Automated Releases

After each successful build, a GitHub release is automatically created with:
- **Release Tag**: Timestamp-based (e.g., `v2025.12.03-143000`)
- **Changelog**: Includes versions, docker pull commands, commit history, and build info
- **Links**: Direct links to code-server and claude-code release notes

The workflow uses `gh` CLI to create releases, which requires:
- `contents: write` permission (already configured)
- `GITHUB_TOKEN` (automatically provided)

## Testing Locally

Build the image locally:

```bash
docker build -t coder-enterprise-node-plus:test .
```

Run the container:

```bash
docker run -it --rm -p 8080:8080 coder-enterprise-node-plus:test
```

Verify installations:

```bash
docker run -it --rm coder-enterprise-node-plus:test code-server --version
docker run -it --rm coder-enterprise-node-plus:test claude --version
```

## Troubleshooting

### Build Failures

If builds fail:
1. Check the Actions tab for error logs
2. Verify the Dockerfile syntax
3. Ensure base image `codercom/enterprise-node` is accessible
4. Check that installation scripts are still valid

### Permission Issues

If you get permission errors when pushing to GHCR:
1. Verify workflow has write permissions for packages
2. Check repository settings > Actions > General > Workflow permissions

### Dependabot Not Creating PRs

If Dependabot isn't working:
1. Verify Dependabot is enabled in repository settings
2. Check `.github/dependabot.yml` syntax
3. Wait for the scheduled check (may take up to 24 hours for initial run)

## Next Steps

After setup:
1. Push these files to your main branch
2. Monitor the Actions tab for the first build
3. Once built, pull the image: `docker pull ghcr.io/gojnimer-labs/coder-enterprise-node-plus:latest`
4. Configure Coder to use this custom image
