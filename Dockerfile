FROM codercom/enterprise-node:latest

USER root

# Install code-server
RUN curl -fsSL https://code-server.dev/install.sh | sh

# Install claude-code (Ubuntu curl install)
RUN curl -fsSL https://deb.coder.com/anthropics.asc | gpg --dearmor -o /usr/share/keyrings/anthropics-archive-keyring.gpg && \
    echo "deb [signed-by=/usr/share/keyrings/anthropics-archive-keyring.gpg] https://deb.coder.com/ any main" > /etc/apt/sources.list.d/anthropics.list && \
    apt-get update && \
    apt-get install -y claude-code && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Switch back to coder user if it exists in the base image
USER coder

# Expose code-server port
EXPOSE 8080
