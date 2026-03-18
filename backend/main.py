from fastapi import FastAPI, HTTPException
from pydantic import BaseModel
from typing import List
import os
from starknet_py.net import AccountClient
from starknet_py.net.models import StarknetChainId
from starknet_py.contract import Contract

app = FastAPI(title="CloakPay Backend")

# In production, use environment variables
STARKNET_RPC_URL = os.getenv("STARKNET_RPC_URL", "https://starknet-goerli.infura.io/v3/YOUR_INFURA_KEY")
PRIVATE_KEY = os.getenv("PRIVATE_KEY", "0xYOUR_PRIVATE_KEY")
ACCOUNT_ADDRESS = os.getenv("ACCOUNT_ADDRESS", "0xYOUR_ACCOUNT_ADDRESS")

class PayrollEntry(BaseModel):
    employee_address: str
    amount: int

class PayrollRequest(BaseModel):
    entries: List[PayrollEntry]

@app.get("/health")
def health():
    return {"status": "ok"}

@app.post("/create-payroll")
async def create_payroll(request: PayrollRequest):
    """
    Create private vouchers for payroll distribution
    """
    try:
        # Initialize Starknet client
        client = AccountClient(
            address=ACCOUNT_ADDRESS,
            client=AccountClient.get_default_client(STARKNET_RPC_URL),
            key_pair=KeyPair.from_private_key(PRIVATE_KEY),
            chain=StarknetChainId.TESTNET
        )

        # Load contract (in real implementation, deploy first)
        # contract = await Contract.from_address(
        #     address="0xCONTRACT_ADDRESS",
        #     client=client
        # )

        vouchers = []
        for entry in request.entries:
            # In real implementation, call contract.create_voucher()
            # For now, just simulate
            voucher = {
                "employee": entry.employee_address,
                "amount": entry.amount,
                "voucher_id": f"voucher_{len(vouchers)}"
            }
            vouchers.append(voucher)

        return {"vouchers": vouchers, "message": "Payroll vouchers created successfully"}

    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))

@app.get("/voucher/{voucher_id}")
async def get_voucher(voucher_id: str):
    """
    Get voucher details (for employee verification)
    """
    # In real implementation, query the contract
    return {
        "voucher_id": voucher_id,
        "employee": "0xEMPLOYEE_ADDRESS",
        "amount": 1000,
        "claimed": False
    }
