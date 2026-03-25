# Contract Tests

This directory contains comprehensive tests for CloakPay smart contracts using Starknet Foundry (snforge).

## Test Files

### test_shielded_pool.cairo
Tests for the ShieldedPool contract covering:
- **test_deposit**: Basic deposit functionality for a single user
- **test_multiple_deposits**: Multiple users depositing and total balance tracking
- **test_withdraw**: Withdrawal functionality and balance updates
- **test_withdraw_insufficient_balance**: Error handling for insufficient balance

### test_payroll_vouchers.cairo
Tests for the PayrollVouchers contract covering:
- **test_create_voucher**: Creating a single voucher for an employee
- **test_create_multiple_vouchers**: Creating multiple vouchers for different employees
- **test_claim_voucher**: Employee claiming their voucher
- **test_claim_voucher_unauthorized**: Error handling for unauthorized claims
- **test_claim_voucher_twice**: Error handling for duplicate claims
- **test_get_voucher_amount**: Retrieving voucher amount

## Running Tests

### Prerequisites
- Starknet Foundry 0.58.0 or higher
- Scarb 2.14.0 or higher
- Rust toolchain (for snforge_std dependency)

### Running All Tests
```bash
cd /workspaces/CloakPay
snforge test
```

### Running Specific Test File
```bash
snforge test test_shielded_pool
snforge test test_payroll_vouchers
```

### Running Specific Test
```bash
snforge test test_shielded_pool::test_deposit
snforge test test_payroll_vouchers::test_claim_voucher_unauthorized
```

## Test Coverage

### ShieldedPool Tests
✅ Deposit funds
✅ Track deposits per user
✅ Track total deposits
✅ Withdraw funds
✅ Balance validation
✅ Insufficient balance error

### PayrollVouchers Tests
✅ Create vouchers
✅ Track voucher amounts
✅ Claim vouchers
✅ Authorization checks
✅ Double claim prevention
✅ Status tracking (claimed/unclaimed)

## Test Statistics
- Total Tests: 10
- Coverage: Core functionality for both contracts
- Edge Cases: Error conditions, authorization, state validation

## Future Enhancements
- Integration tests for contract interactions
- ZK proof verification tests
- Merkle tree validation tests
- Cross-contract calls
- Gas optimization benchmarks
