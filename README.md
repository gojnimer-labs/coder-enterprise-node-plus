# coder-enterprise-node-plus

Enhanced Docker image extending `codercom/enterprise-node` with code-server and claude-code pre-installed.

## Features

- Based on `codercom/enterprise-node:latest`
- Includes [code-server](https://github.com/coder/code-server) for VS Code in the browser
- Includes [claude-code](https://github.com/anthropics/claude-code) CLI tool
- Automated builds triggered by new versions of dependencies
- Published to GitHub Container Registry (GHCR)

## Usage

Pull the latest image from GHCR:

```bash
docker pull ghcr.io/gojnimer-labs/coder-enterprise-node-plus:latest
```

Run the container:

```bash
docker run -it -p 8080:8080 ghcr.io/gojnimer-labs/coder-enterprise-node-plus:latest
```

## Automated Builds

This repository uses GitHub Actions to automatically build and push Docker images when:

1. **Push to main branch** - Triggers immediate build
2. **Weekly schedule** - Checks for new versions every Sunday
3. **Manual trigger** - Can be triggered via GitHub Actions UI
4. **Dependabot updates** - Automatically triggers builds when base image or actions are updated

### Version Tags

Images are tagged with:
- `latest` - Latest build from main branch
- `code-server-{version}` - Tagged with code-server version
- `claude-code-{version}` - Tagged with claude-code version
- `{branch}-{sha}` - Specific commit builds

## Dependabot

Dependabot is configured to monitor:
- Docker base image updates
- GitHub Actions version updates

When Dependabot creates a PR, it automatically triggers a new build to ensure compatibility.

## Manual Build

To build locally:

```bash
docker build -t coder-enterprise-node-plus .
```

## Requirements

- Docker
- GitHub account with packages permission for GHCR

## License

MIT
