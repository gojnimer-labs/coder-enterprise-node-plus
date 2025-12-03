FROM codercom/enterprise-node:latest

USER root

# Install code-server
RUN curl -fsSL https://code-server.dev/install.sh | sh

# Install claude-code (Official curl install)
RUN curl -fsSL https://claude.ai/install.sh | bash

# Switch back to coder user if it exists in the base image
USER coder

# Expose code-server port
EXPOSE 8080
