FROM codercom/enterprise-node:latest

# Accept build arguments from GitHub Actions
ARG CODE_SERVER_VERSION=4.95.3
ARG CLAUDE_CODE_VERSION=latest

USER root

# Install code-server manually to the exact path Coder module expects
RUN set -eux && \
    ARCH="$(dpkg --print-architecture)" && \
    echo "Installing code-server version: ${CODE_SERVER_VERSION} for architecture: ${ARCH}" && \
    mkdir -p /tmp/code-server/lib /tmp/code-server/bin && \
    curl -fsSL "https://github.com/coder/code-server/releases/download/v${CODE_SERVER_VERSION}/code-server-${CODE_SERVER_VERSION}-linux-${ARCH}.tar.gz" -o /tmp/code-server.tar.gz && \
    tar -xzf /tmp/code-server.tar.gz -C /tmp/code-server/lib --strip-components=1 && \
    ln -s /tmp/code-server/lib/bin/code-server /tmp/code-server/bin/code-server && \
    rm /tmp/code-server.tar.gz && \
    echo "=== Verifying installation ===" && \
    ls -la /tmp/code-server/bin/ && \
    /tmp/code-server/bin/code-server --version

# Install Claude Code via npm to match the Coder module's installation method
# This ensures compatibility when install_claude_code=false
RUN npm install -g @anthropic-ai/claude-code@${CLAUDE_CODE_VERSION}

# Add binaries to system PATH for all users and for non-login shells
ENV PATH="/tmp/code-server/bin:${PATH}"
RUN echo 'export PATH="/tmp/code-server/bin:$PATH"' >> /etc/profile.d/coder-paths.sh && \
    chmod +x /etc/profile.d/coder-paths.sh

# Verify installations are accessible (as root first to catch any issues)
RUN /tmp/code-server/bin/code-server --version || (echo "code-server not found or not executable" && exit 1)
RUN claude --version || (echo "claude not found" && exit 1)

# Switch to coder user
USER coder

# Verify installations work as coder user too
RUN /tmp/code-server/bin/code-server --version
RUN claude --version
