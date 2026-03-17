# CloakPay

A shielded private payroll system for Bitcoin on Starknet.

## Features

- Shielded fund management: Convert public BTC to shielded BTC
- Privacy-preserving distribution: Process payroll as private vouchers
- Selective disclosure: Viewing keys for authorized audits
- Proof of payment: Cryptographic guarantees for employees

## Tech Stack

- Starknet (Cairo)
- Python backend
- Wrapped BTC (WBTC)

## Getting Started (GitHub Codespaces)

### Prerequisites

- A GitHub account
- Access to GitHub Codespaces (free tier works for hackathon)

### Setup (Codespaces)

1. Push this repo to GitHub
2. Open the repo in GitHub and click **Code → Codespaces → Create codespace**
3. Wait for the container to build (it installs Python, Cairo, and Starknet tooling)
4. Once the codespace is ready, open a terminal inside it and run:

```bash
bash /workspace/scripts/setup.sh
```

5. You can now run the backend:

```bash
source .venv/bin/activate
uvicorn backend.main:app --reload --host 0.0.0.0 --port 8000
```

## Local Setup (if you have Linux/WSL)

If you are working on a Linux machine or WSL, you can use the same scripts:

```bash
bash scripts/setup.sh
```

## Project Structure

- `contracts/`: Cairo smart contracts
- `scripts/`: Deployment and utility scripts
- `tests/`: Test files
- `backend/`: Python backend code