# CloakPay Architecture

## Overview

CloakPay enables private Bitcoin payroll using Starknet's ZK capabilities.

## Components

### Smart Contracts (Starknet)

1. **ShieldedPool**: Manages shielded WBTC funds
   - Deposit public WBTC
   - Withdraw shielded funds
   - ZK proofs for privacy

2. **PayrollContract**: Handles voucher distribution
   - Create private vouchers for employees
   - Merkle trees for efficient proofs

3. **ViewingKeyManager**: Manages selective disclosure
   - Generate viewing keys for auditors
   - Reveal transaction data to authorized parties

### Backend (Python)

- Payroll processing API
- Proof generation
- Integration with Starknet

### Frontend (by teammate)

- UI for uploading payroll
- Employee dashboard

## Data Flow

1. Employer deposits WBTC to ShieldedPool
2. Backend processes payroll list, generates vouchers
3. Employees claim vouchers privately
4. Auditors can view with viewing keys

## ZK Proofs

- Use Cairo for ZK circuits
- Proofs for:
  - Fund shielding
  - Voucher validity
  - Payment confirmation