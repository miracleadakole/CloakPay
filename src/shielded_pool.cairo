use starknet::ContractAddress;

#[starknet::interface]
pub trait IShieldedPool<TContractState> {
    fn deposit(ref self: TContractState, amount: u256);
    fn withdraw(ref self: TContractState, amount: u256);
    fn get_deposit(self: @TContractState, user: ContractAddress) -> u256;
    fn get_total_deposits(self: @TContractState) -> u256;
}

#[starknet::contract]
mod ShieldedPool {
    use starknet::{ContractAddress, get_caller_address};
    // This is crucial for the contract to see the interface above it
    use super::IShieldedPool;
    use starknet::storage::{
        Map, StorageMapReadAccess, StorageMapWriteAccess, 
        StoragePointerReadAccess, StoragePointerWriteAccess
    };

    #[storage]
    struct Storage {
        total_deposits: u256,
        deposits: Map<ContractAddress, u256>,
    }

    #[event]
    #[derive(Drop, starknet::Event)]
    enum Event {
        Deposit: Deposit,
        Withdrawal: Withdrawal,
    }

    #[derive(Drop, starknet::Event)]
    struct Deposit {
        user: ContractAddress,
        amount: u256,
    }

    #[derive(Drop, starknet::Event)]
    struct Withdrawal {
        user: ContractAddress,
        amount: u256,
    }
    
    #[constructor]
    fn constructor(ref self: ContractState) {
        self.total_deposits.write(0);
    }

    #[abi(embed_v0)]
    impl ShieldedPoolImpl of IShieldedPool<ContractState> {
        fn deposit(ref self: ContractState, amount: u256) {
            assert(amount > 0, 'Amount must be positive'); // Added safety check

            let caller = get_caller_address();
            let current_deposit = self.deposits.read(caller);
            let new_deposit = current_deposit + amount;
            self.deposits.write(caller, new_deposit);

            let current_total = self.total_deposits.read();
            let new_total = current_total + amount;
            self.total_deposits.write(new_total);

            self.emit(Deposit { user: caller, amount });
        }

        fn withdraw(ref self: ContractState, amount: u256) {
            let caller = get_caller_address();
            let current_deposit = self.deposits.read(caller);
            
            assert(current_deposit >= amount, 'Insufficient balance');
            
            let new_deposit = current_deposit - amount;
            self.deposits.write(caller, new_deposit);

            let current_total = self.total_deposits.read();
            let new_total = current_total - amount;
            self.total_deposits.write(new_total);

            self.emit(Withdrawal { user: caller, amount });
        }

        fn get_deposit(self: @ContractState, user: ContractAddress) -> u256 {
            self.deposits.read(user)
        }

        fn get_total_deposits(self: @ContractState) -> u256 {
            self.total_deposits.read()
        }
    }
}