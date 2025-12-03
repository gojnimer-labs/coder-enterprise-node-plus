FROM codercom/enterprise-node:latest

# Accept build arguments from GitHub Actions
ARG CODE_SERVER_VERSION=4.95.3
ARG CLAUDE_CODE_VERSION=latest
ARG PODMAN_VERSION=""

USER root

# Install podman and rootless dependencies
RUN set -eux && \
    echo "Installing podman and rootless container dependencies..." && \
    apt-get update && \
    apt-get install -y --no-install-recommends \
        podman \
        fuse-overlayfs \
        slirp4netns \
        uidmap \
    && rm -rf /var/lib/apt/lists/* && \
    echo "Podman version:" && \
    podman --version

# Set capabilities for rootless operation
RUN setcap cap_setuid+ep /usr/bin/newuidmap && \
    setcap cap_setgid+ep /usr/bin/newgidmap && \
    chmod 0755 /usr/bin/newuidmap /usr/bin/newgidmap

# Configure subuid/subgid for coder user (range: 100000-165535)
RUN usermod --add-subuids 100000-165535 --add-subgids 100000-165535 coder 2>/dev/null || \
    (echo "coder:100000:65536" > /etc/subuid && \
     echo "coder:100000:65536" > /etc/subgid)

# Create configuration directories
RUN mkdir -p /etc/containers \
             /home/coder/.config/containers \
             /home/coder/.local/share/containers \
             /var/lib/shared/overlay-images \
             /var/lib/shared/overlay-layers \
             /var/lib/shared/vfs-images \
             /var/lib/shared/vfs-layers && \
    touch /var/lib/shared/overlay-images/images.lock \
          /var/lib/shared/overlay-layers/layers.lock \
          /var/lib/shared/vfs-images/images.lock \
          /var/lib/shared/vfs-layers/layers.lock

# containers.conf - Kubernetes-compatible configuration
RUN cat > /etc/containers/containers.conf <<'EOF'
[containers]
netns="host"
userns="host"
ipcns="host"
utsns="host"
cgroupns="host"
cgroups="disabled"
log_driver = "k8s-file"
volumes = ["/proc:/proc"]
default_sysctls = []

[engine]
cgroup_manager = "cgroupfs"
events_logger="file"
runtime="crun"
EOF

# storage.conf - Rootless overlay with fuse-overlayfs
RUN cat > /etc/containers/storage.conf <<'EOF'
[storage]
driver = "overlay"
runroot = "/run/containers/storage"
graphroot = "/var/lib/containers/storage"

[storage.options]
additionalimagestores = ["/var/lib/shared"]
pull_options = {enable_partial_images = "false", use_hard_links = "false"}

[storage.options.overlay]
mount_program = "/usr/bin/fuse-overlayfs"
mountopt = "nodev,fsync=0"
EOF

# Set permissions
RUN chmod 644 /etc/containers/*.conf && \
    chown -R coder:coder /home/coder/.config /home/coder/.local

# Signal that user namespaces are configured
ENV _CONTAINERS_USERNS_CONFIGURED=""

# Alias "docker" to "podman" for compatibility
RUN ln -sf /usr/bin/podman /usr/bin/docker

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
RUN podman --version || (echo "podman not found" && exit 1)
RUN podman info --debug || echo "Podman info (may show kernel warnings during build)"

# Switch to coder user
USER coder

# Verify installations work as coder user too
RUN /tmp/code-server/bin/code-server --version
RUN claude --version
RUN podman --version
RUN podman info || echo "Note: Podman rootless requires kernel user namespaces at runtime"
