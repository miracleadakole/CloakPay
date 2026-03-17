#!/usr/bin/env bash
set -euo pipefail

# Ensure we are in the repository root
cd "$(dirname "${BASH_SOURCE[0]}")/.."

echo "==> Creating Python venv"
python3 -m venv .venv
source .venv/bin/activate

echo "==> Upgrading pip + installing dependencies"
python -m pip install --upgrade pip
python -m pip install -r requirements.txt

echo "==> Done. Activate the venv with: source .venv/bin/activate"
