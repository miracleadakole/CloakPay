#[starknet::contract]
mod PayrollVouchers {
    use starknet::{ContractAddress, get_caller_address};
    use starknet::storage::{Map, StorageMapReadAccess, StorageMapWriteAccess, StoragePointerReadAccess, StoragePointerWriteAccess};

    #[starknet::interface]
    trait IPayrollVouchers<TContractState> {
        fn create_voucher(ref self: TContractState, employee: ContractAddress, amount: u256);
        fn claim_voucher(ref self: TContractState, voucher_id: u256);
        fn get_voucher_amount(self: @TContractState, voucher_id: u256) -> u256;
        fn is_claimed(self: @TContractState, voucher_id: u256) -> bool;
    }

    #[storage]
    struct Storage {
        voucher_count: u256,
        voucher_employee: Map<u256, ContractAddress>,
        voucher_amount: Map<u256, u256>,
        claimed: Map<u256, bool>,
    }

    #[event]
    #[derive(Drop, starknet::Event)]
    enum Event {
        VoucherCreated: VoucherCreated,
        VoucherClaimed: VoucherClaimed,
    }

    #[derive(Drop, starknet::Event)]
    struct VoucherCreated {
        voucher_id: u256,
        employee: ContractAddress,
        amount: u256,
    }

    #[derive(Drop, starknet::Event)]
    struct VoucherClaimed {
        voucher_id: u256,
        employee: ContractAddress,
        amount: u256,
    }

    #[abi(embed_v0)]
    impl PayrollVouchersImpl of IPayrollVouchers<ContractState> {
        fn create_voucher(ref self: ContractState, employee: ContractAddress, amount: u256) {
            let _caller = get_caller_address();
            // In real implementation, verify caller is authorized (e.g., employer)

            let voucher_id = self.voucher_count.read() + 1;
            self.voucher_count.write(voucher_id);

            self.voucher_employee.write(voucher_id, employee);
            self.voucher_amount.write(voucher_id, amount);
            self.claimed.write(voucher_id, false);

            self.emit(VoucherCreated { voucher_id, employee, amount });
        }

        fn claim_voucher(ref self: ContractState, voucher_id: u256) {
            let caller = get_caller_address();
            let employee = self.voucher_employee.read(voucher_id);
            assert(employee == caller, 'Not authorized');
            assert(!self.claimed.read(voucher_id), 'Already claimed');

            let amount = self.voucher_amount.read(voucher_id);
            self.claimed.write(voucher_id, true);

            // In real implementation, transfer funds from ShieldedPool
            self.emit(VoucherClaimed { voucher_id, employee: caller, amount });
        }

        fn get_voucher_amount(self: @ContractState, voucher_id: u256) -> u256 {
            self.voucher_amount.read(voucher_id)
        }

        fn is_claimed(self: @ContractState, voucher_id: u256) -> bool {
            self.claimed.read(voucher_id)
        }
    }
}