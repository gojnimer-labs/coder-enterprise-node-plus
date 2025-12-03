# Example Changelog

This is an example of what the automatically generated changelog will look like for each release.

---

## What's Changed

### Included Versions

- **code-server**: `4.93.1` ([Release Notes](https://github.com/coder/code-server/releases/tag/v4.93.1))
- **claude-code**: `0.9.0` ([Release Notes](https://github.com/anthropics/claude-code/releases/tag/v0.9.0))
- **Base Image**: `codercom/enterprise-node:latest`

### Docker Images

Pull this release:
```bash
docker pull ghcr.io/gojnimer-labs/coder-enterprise-node-plus:latest
# Or use version-specific tags:
docker pull ghcr.io/gojnimer-labs/coder-enterprise-node-plus:code-server-4.93.1
docker pull ghcr.io/gojnimer-labs/coder-enterprise-node-plus:claude-code-0.9.0
```

### Commits Since Last Release

```
abc1234 Update Dockerfile to optimize layer caching
def5678 Add health check endpoint
ghi9012 Improve documentation
```

### Build Information

- **Build Date**: 2025-12-03 14:30:00 UTC
- **Commit**: `abc123def456`
- **Workflow Run**: [#42](https://github.com/gojnimer-labs/coder-enterprise-node-plus/actions/runs/123456)
- **Triggered by**: push

---

This changelog is automatically generated and attached to every release created by the CI/CD pipeline.
