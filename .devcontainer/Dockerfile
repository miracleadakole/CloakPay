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
    python3.11 \
    python3.11-venv \
    python3.11-distutils \
    wget \
    ca-certificates \
  && rm -rf /var/lib/apt/lists/*

# Ensure python3 points to python3.11
RUN update-alternatives --install /usr/bin/python3 python3 /usr/bin/python3.11 1

# Upgrade pip and install python tooling
RUN python3 -m pip install --no-cache-dir --upgrade pip setuptools wheel

# Install Cairo & Starknet tooling
RUN python3 -m pip install --no-cache-dir cairo-lang==0.6.2 starknet-py fastapi uvicorn

# Install Cairo compiler
RUN curl -L https://github.com/starkware-libs/cairo/releases/download/v2.6.3/cairo-lang-2.6.3-x86_64-unknown-linux-musl.tar.gz | tar xz -C /usr/local && \
    ln -s /usr/local/cairo-lang-2.6.3/bin/starknet-compile /usr/local/bin/starknet-compile && \
    ln -s /usr/local/cairo-lang-2.6.3/bin/starknet-sierra-compile /usr/local/bin/starknet-sierra-compile

# Install Starknet CLI (starkli) for basic deployment and interaction
RUN curl -sSfL https://github.com/xJonathanLEI/starkli/releases/download/v0.3.4/starkli-x86_64-unknown-linux-gnu.tar.gz | tar -xz -C /usr/local/bin

# Create a working directory
WORKDIR /workspace
