#!/bin/bash
set -e

# Load environment
source .env

# Build contracts
scarb build

# Deploy ShieldedPool
echo "Deploying ShieldedPool..."
DEPLOY_RESULT=$(sncast deploy --contract-name ShieldedPool --rpc-url $STARKNET_RPC_URL --account $ACCOUNT_ADDRESS --private-key $PRIVATE_KEY)

# Extract contract address
SHIELDED_POOL_ADDRESS=$(echo $DEPLOY_RESULT | grep -oP 'contract_address: \K[0-9a-fx]+')

echo "ShieldedPool deployed at: $SHIELDED_POOL_ADDRESS"

# Deploy PayrollVouchers
echo "Deploying PayrollVouchers..."
DEPLOY_RESULT=$(sncast deploy --contract-name PayrollVouchers --rpc-url $STARKNET_RPC_URL --account $ACCOUNT_ADDRESS --private-key $PRIVATE_KEY)

# Extract contract address
PAYROLL_VOUCHERS_ADDRESS=$(echo $DEPLOY_RESULT | grep -oP 'contract_address: \K[0-9a-fx]+')

echo "PayrollVouchers deployed at: $PAYROLL_VOUCHERS_ADDRESS"

# Update .env
sed -i "s/SHIELDED_POOL_ADDRESS=.*/SHIELDED_POOL_ADDRESS=$SHIELDED_POOL_ADDRESS/" .env
sed -i "s/PAYROLL_VOUCHERS_ADDRESS=.*/PAYROLL_VOUCHERS_ADDRESS=$PAYROLL_VOUCHERS_ADDRESS/" .env

echo "Deployment complete!"