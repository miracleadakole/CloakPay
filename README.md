# CloakPay - Private Bitcoin Payroll System

A shielded private payroll system for Bitcoin on Starknet using Zero-Knowledge proofs.

## Features

- 🔐 **Shielded Fund Management**: Convert public WBTC to shielded WBTC
- 💳 **Privacy-Preserving Distribution**: Process payroll as private vouchers
- 👁️ **Selective Disclosure**: Viewing keys for authorized audits
- ✅ **Proof of Payment**: Cryptographic guarantees for employees
- ⚡ **Efficient Batch Processing**: Handle multiple employees per transaction

## Tech Stack

- **Smart Contracts**: Cairo 1.0 on Starknet
- **Backend**: Python FastAPI server
- **Testing**: Starknet Foundry (snforge)
- **Build**: Scarb (Cairo package manager)
- **Blockchain**: Starknet with WBTC

## Project Structure

```
CloakPay/
├── src/                           # Cairo smart contracts (Cairo 1.0)
│   ├── lib.cairo                 # Module exports
│   ├── shielded_pool.cairo       # Shielded fund management
│   └── payroll_vouchers.cairo    # Private voucher system
├── backend/                       # Python backend
│   └── main.py                   # FastAPI application
├── tests/                         # Contract tests (snforge)
│   ├── test_shielded_pool.cairo
│   ├── test_payroll_vouchers.cairo
│   └── README.md                 # Test documentation
├── scripts/
│   ├── setup.sh                  # Environment setup
│   └── deploy.sh                 # Contract deployment
├── Scarb.toml                    # Scarb configuration
├── ARCHITECTURE.md               # System design
└── requirements.txt              # Python dependencies
```

## Getting Started

### Prerequisites

**System Requirements**:
- Linux/macOS/WSL
- 4GB+ RAM
- 2GB+ disk space

**Software**:
- Git
- Curl/Wget
- Python 3.9+
- Bash

### Quick Start (GitHub Codespaces - Recommended)

1. **Fork/Clone this repo** to GitHub
2. **Open in Codespaces**:
   - Click **Code → Codespaces → Create codespace on main**
   - Wait for container setup (~5 min)
3. **In the codespace terminal**:
   ```bash
   ./scripts/setup.sh
   ```
4. **Build contracts**:
   ```bash
   scarb build
   ```
5. **Run backend** (optional):
   ```bash
   source .venv/bin/activate
   python -m uvicorn backend.main:app --reload
   ```

### Local Setup (Linux/WSL)

```bash
# Clone the repository
git clone https://github.com/yourusername/CloakPay.git
cd CloakPay

# Run setup script
bash scripts/setup.sh

# Build contracts
cd /workspaces/CloakPay
scarb build

# Run tests (requires Rust toolchain)
snforge test
```

## Building & Testing

### Build Contracts
```bash
scarb build
```
Outputs to `target/dev/` directory.

### Run Tests
```bash
snforge test
```

Test coverage includes:
- ✅ Deposit/withdrawal functionality
- ✅ Multi-user balance tracking
- ✅ Voucher creation and claiming
- ✅ Authorization validation
- ✅ Error conditions

See `tests/README.md` for detailed test information.

### Run Backend Server
```bash
source .venv/bin/activate
python -m uvicorn backend.main:app --reload --host 0.0.0.0 --port 8000
```

**API Documentation**: Visit http://localhost:8000/docs (Swagger UI)

## Configuration

### Environment Variables

Create `.env` file:
```env
STARKNET_RPC_URL=https://starknet-sepolia.infura.io/v3/YOUR_KEY
PRIVATE_KEY=0xyour_private_key_hex
ACCOUNT_ADDRESS=0xyour_account_address
SHIELDED_POOL_ADDRESS=0xdeployed_contract_address
```

### Deployment Configuration

Edit `scripts/deploy.sh` to configure:
- Network (Testnet/Mainnet)
- Account credentials
- Gas parameters
- Contract parameters

## Smart Contracts

### ShieldedPool
Manages WBTC fund shielding and storage.

**Functions**:
- `deposit(amount: u256)` - Deposit WBTC publicly
- `withdraw(amount: u256)` - Withdraw shielded funds
- `get_deposit(user: ContractAddress) -> u256` - Query user balance
- `get_total_deposits() -> u256` - Query total pool balance

**Events**:
- `Deposit` - Emitted on deposit
- `Withdrawal` - Emitted on withdrawal

### PayrollVouchers
Manages private payment vouchers for employees.

**Functions**:
- `create_voucher(employee: ContractAddress, amount: u256)` - Create employee voucher
- `claim_voucher(voucher_id: u256)` - Employee claims payment
- `get_voucher_amount(voucher_id: u256) -> u256` - Query voucher amount
- `is_claimed(voucher_id: u256) -> bool` - Check if claimed

**Events**:
- `VoucherCreated` - New voucher issued
- `VoucherClaimed` - Employee claimed voucher

## API Endpoints

### POST /create-payroll
Create payroll for multiple employees. Returns voucher IDs.

**Request**:
```json
{
  "entries": [
    {
      "employee_address": "0x123...",
      "amount": 5000
    }
  ]
}
```

**Response**:
```json
{
  "vouchers": [
    {
      "employee": "0x123...",
      "amount": 5000,
      "proof": "0x..."
    }
  ],
  "status": "created"
}
```

### GET /pool-balance
Query shielded pool total balance.

### GET /health
Health check endpoint.

## Development Workflow

```
┌─────────────────────┐
│   Edit Contracts    │
│   (src/*.cairo)     │
└──────────┬──────────┘
           ↓
┌─────────────────────┐
│   Build with Scarb  │
│  (scarb build)      │
└──────────┬──────────┘
           ↓
┌─────────────────────┐
│   Run Tests         │
│  (snforge test)     │
└──────────┬──────────┘
           ↓
┌─────────────────────┐
│   Deploy to Testnet │
│ (./scripts/deploy)  │
└──────────┬──────────┘
           ↓
┌─────────────────────┐
│   Test via Backend  │
│  (Python API)       │
└─────────────────────┘
```

## Architecture Diagram

```
Employer
    ↓
FastAPI Backend (Python)
    ├─ POST /create-payroll
    ├─ GET /pool-balance
    └─ GET /health
    ↓
Starknet Smart Contracts (Cairo)
    ├─ ShieldedPool (WBTC management)
    └─ PayrollVouchers (Private vouchers)
    ↓
Employee Clients
    ├─ Claim vouchers
    ├─ Verify payments
    └─ View history
```

## Common Tasks

### Deploy to Testnet
```bash
# 1. Configure .env with testnet account
# 2. Run deployment script
./scripts/deploy.sh

# 3. Save deployed contract addresses
# 4. Update .env with SHIELDED_POOL_ADDRESS
```

### Create Payroll for Employees
```bash
curl -X POST http://localhost:8000/create-payroll \
  -H "Content-Type: application/json" \
  -d '{
    "entries": [
      {"employee_address": "0x123...", "amount": 5000},
      {"employee_address": "0x456...", "amount": 7500}
    ]
  }'
```

### Check Pool Balance
```bash
curl http://localhost:8000/pool-balance
```

## Troubleshooting

### Scarb Build Fails
```bash
# Update Scarb
curl -L https://github.com/software-mansion/scarb/releases/download/v2.14.0/scarb-v2.14.0-x86_64-unknown-linux-musl.tar.gz | tar -xz
sudo mv scarb-v2.14.0-x86_64-unknown-linux-musl/bin/scarb /usr/local/bin/
```

### Tests Don't Run
```bash
# Ensure Rust toolchain is installed (for snforge_std)
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh

# Update snforge
snfoundryup
```

### Backend Server Issues
```bash
# Install Python dependencies
source .venv/bin/activate
pip install -r requirements.txt --upgrade

# Clear cache
rm -rf __pycache__ .pytest_cache

# Restart server
python -m uvicorn backend.main:app --reload
```

## References

- [Starknet Docs](https://docs.starknet.io/)
- [Cairo Book](https://book.cairo-lang.org/)
- [Starknet Foundry](https://foundry-rs.github.io/starknet-foundry/)
- [Scarb Package Manager](https://docs.swmansion.com/scarb/)
- [ARCHITECTURE.md](ARCHITECTURE.md) - System design details

## Future Enhancements

- [ ] Full ZK circuit implementation for fund shielding
- [ ] Merkle tree batch verification
- [ ] Multi-signature approval workflow
- [ ] Auditor dashboard with selective disclosure
- [ ] Mobile app for employees (React Native)
- [ ] Bitcoin bridge for direct WBTC integration
- [ ] Gas optimization and cost analysis
- [ ] Advanced privacy features (coin mixing, stealth addresses)

## Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit changes (`git commit -m 'Add amazing feature'`)
4. Push to branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## License

This project is licensed under the MIT License - see [LICENSE](LICENSE) file for details.

## Support & Community

- **Issues**: GitHub Issues for bug reports
- **Discussions**: GitHub Discussions for questions
- **Documentation**: See [ARCHITECTURE.md](ARCHITECTURE.md) for design details

---

**Made with ❤️ for private, efficient payroll** | Powered by Starknet

## Building Smart Contracts

### Compile a Cairo contract

```bash
source .venv/bin/activate
starknet-compile contracts/ShieldedPool.cairo --output contracts/ShieldedPool_compiled.json
```

### Deploy to Starknet Goerli testnet

1. Get some ETH on Goerli (faucet)
2. Set up your account:

```bash
starkli account oz init --keystore ~/.starkli-wallets/deployer --account ~/.starkli-wallets/deployer
```

3. Deploy:

```bash
starkli contract deploy contracts/ShieldedPool_compiled.json --account ~/.starkli-wallets/deployer --rpc https://starknet-goerli.infura.io/v3/YOUR_INFURA_KEY
```

## API Endpoints

### POST /create-payroll
Create private vouchers for payroll distribution.

**Request Body:**
```json
{
  "entries": [
    {
      "employee_address": "0xEMPLOYEE_ADDRESS",
      "amount": 1000
    }
  ]
}
```

**Response:**
```json
{
  "vouchers": [...],
  "message": "Payroll vouchers created successfully"
}
```

### GET /voucher/{voucher_id}
Get voucher details for employee verification.

## Project Structure

- `contracts/`: Cairo smart contracts
- `scripts/`: Deployment and utility scripts
- `tests/`: Test files
- `backend/`: Python backend code