FROM codercom/enterprise-node:latest

USER root

# Install code-server
RUN curl -fsSL https://code-server.dev/install.sh | sh

# Install claude-code (Official curl install)
RUN curl -fsSL https://claude.ai/install.sh | bash
