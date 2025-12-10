# Dockerfile for dotfiles repository integrity testing
# Base: Ubuntu LTS for Linux environment validation

FROM ubuntu:24.04

# ============================================================================
# Environment Setup
# ============================================================================
ENV DEBIAN_FRONTEND=noninteractive \
    TERM=xterm-256color \
    HOME=/home/testuser

# ============================================================================
# Metadata
# ============================================================================
LABEL maintainer="dotfiles" \
      description="Complete integrity test environment for dotfiles repository" \
      ubuntu.version="24.04"

# ============================================================================
# System Dependencies
# ============================================================================
RUN apt-get update && apt-get install -y \
    # Build essentials
    build-essential \
    # Shells
    zsh \
    bash \
    # Version control
    git \
    # Network tools
    curl \
    wget \
    # Development tools
    make \
    # Editors
    vim \
    neovim \
    # Utilities
    file \
    tree \
    # Lua (for Neovim config validation)
    lua5.4 \
    # Cleanup
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# ============================================================================
# User Setup (non-root for realistic testing)
# ============================================================================
RUN useradd -m -s /bin/zsh testuser && \
    echo "testuser ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

# ============================================================================
# Switch to Test User
# ============================================================================
USER testuser
WORKDIR /home/testuser

# ============================================================================
# Copy Repository
# ============================================================================
COPY --chown=testuser:testuser . /home/testuser/.dotfiles

# ============================================================================
# Setup Test Script
# ============================================================================
RUN chmod +x /home/testuser/.dotfiles/init.sh

# ============================================================================
# Default Command: Run Complete Test Suite
# ============================================================================
CMD ["/home/testuser/.dotfiles/init.sh"]

# ============================================================================
# Usage:
#   Build:  docker build -t dotfiles-test .
#   Test:   docker run --rm dotfiles-test
#   Shell:  docker run --rm -it dotfiles-test /bin/zsh
# ============================================================================
