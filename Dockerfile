FROM codercom/enterprise-node:latest

USER root

# Install code-server to the exact path Coder module expects in offline mode
# Using --prefix to match the module's default install_prefix=/tmp/code-server
RUN set -eux && \
    curl -fsSL https://code-server.dev/install.sh | sh -s -- --prefix=/tmp/code-server && \
    echo "=== Checking installation structure ===" && \
    ls -la /tmp/code-server/ && \
    ls -la /tmp/code-server/bin/ && \
    ls -la /tmp/code-server/lib/ && \
    echo "=== Checking symlink target ===" && \
    readlink -f /tmp/code-server/bin/code-server && \
    echo "=== Checking if binary exists ===" && \
    test -f /tmp/code-server/bin/code-server && \
    test -x /tmp/code-server/bin/code-server && \
    echo "=== Binary exists and is executable ==="

# Install Claude Code via npm to match the Coder module's installation method
# This ensures compatibility when install_claude_code=false
RUN npm install -g @anthropic-ai/claude-code@latest

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
