# See https://aka.ms/vscode-remote/devcontainer/base for more information.
FROM mcr.microsoft.com/devcontainers/base:ubuntu

# Install system dependencies
RUN apt-get update \
  && apt-get install -y --no-install-recommends \
    curl \
    git \
    build-essential \
    pkg-config \
    libssl-dev \
    libffi-dev \
    python3 \
    python3-venv \
    python3-pip \
    wget \
    ca-certificates \
  && rm -rf /var/lib/apt/lists/*

# Upgrade pip and install python tooling
RUN python3 -m pip install --no-cache-dir --upgrade --break-system-packages pip setuptools wheel

# Install Cairo & Starknet tooling
RUN python3 -m pip install --no-cache-dir --break-system-packages cairo-lang starknet-py fastapi uvicorn

# Install Starknet CLI (starkli) for deployment and interaction
RUN curl -sSfL https://github.com/xJonathanLEI/starkli/releases/download/v0.3.4/starkli-x86_64-unknown-linux-gnu.tar.gz | tar -xz -C /usr/local/bin

# Create a working directory
WORKDIR /workspace
