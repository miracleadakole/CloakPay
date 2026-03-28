use starknet::ContractAddress;


#[starknet::interface]
pub trait IPayrollVouchers<TContractState> {
    fn create_voucher(ref self: TContractState, employee: ContractAddress, amount: u256);
    fn claim_voucher(ref self: TContractState, voucher_id: u256);
    fn get_voucher_amount(self: @TContractState, voucher_id: u256) -> u256;
    fn is_claimed(self: @TContractState, voucher_id: u256) -> bool;
    fn get_employer(self: @TContractState) -> ContractAddress; // Added for transparency
}

#[starknet::contract]
mod PayrollVouchers {
    use starknet::{ContractAddress, get_caller_address};
    use starknet::storage::{Map, StorageMapReadAccess, StorageMapWriteAccess, StoragePointerReadAccess, StoragePointerWriteAccess};
    // Import the interface into the module scope
    use super::IPayrollVouchers;

    #[storage]
    struct Storage {
        employer: ContractAddress,
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

    // Set the employer at deployment
    #[constructor]
    fn constructor(ref self: ContractState, employer_address: ContractAddress) {
        self.employer.write(employer_address);
        self.voucher_count.write(0);
    }

    #[abi(embed_v0)]
    impl PayrollVouchersImpl of IPayrollVouchers<ContractState> {
        fn create_voucher(ref self: ContractState, employee: ContractAddress, amount: u256) {
            let caller = get_caller_address();
            assert(caller == self.employer.read(), 'Only employer can create');
            
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
            
            // Basic authorization check
            assert(employee == caller, 'Not authorized');
            assert(!self.claimed.read(voucher_id), 'Already claimed');

            self.claimed.write(voucher_id, true);
            let amount = self.voucher_amount.read(voucher_id);

            self.emit(VoucherClaimed { voucher_id, employee: caller, amount });
        }

        fn get_voucher_amount(self: @ContractState, voucher_id: u256) -> u256 {
            self.voucher_amount.read(voucher_id)
        }

        fn is_claimed(self: @ContractState, voucher_id: u256) -> bool {
            self.claimed.read(voucher_id)
        }

        fn get_employer(self: @ContractState) -> ContractAddress {
            self.employer.read()
        }
    }
}