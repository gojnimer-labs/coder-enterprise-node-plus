FROM codercom/enterprise-node:latest

USER root

# Install code-server to the exact path Coder module expects in offline mode
# Using --prefix to match the module's default install_prefix=/tmp/code-server
RUN curl -fsSL https://code-server.dev/install.sh | sh -s -- --prefix=/tmp/code-server

# Install Claude Code via npm to match the Coder module's installation method
# This ensures compatibility when install_claude_code=false
RUN npm install -g @anthropic-ai/claude-code@latest

# Add binaries to system PATH for all users
RUN echo 'export PATH="/tmp/code-server/bin:$PATH"' >> /etc/profile.d/coder-paths.sh && \
    chmod +x /etc/profile.d/coder-paths.sh

# Switch to coder user
USER coder

# Verify installations are accessible
RUN /tmp/code-server/bin/code-server --version
RUN claude --version

# Set PATH for non-login shells (important for Coder agent)
ENV PATH="/tmp/code-server/bin:${PATH}"
