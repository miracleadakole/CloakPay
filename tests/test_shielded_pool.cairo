use cloakpay::shielded_pool::ShieldedPool;
use cloakpay::shielded_pool::IShieldedPoolDispatcher;
use cloakpay::shielded_pool::IShieldedPoolDispatcherTrait;
use starknet::{ContractAddress, contract_address_const};
use snforge_std::{declare, ContractClassTrait, DeclareResultTrait, start_cheat_caller_global, stop_cheat_caller_global};

fn deploy_shielded_pool() -> ContractAddress {
    let contract = declare("ShieldedPool").unwrap().contract_class();
    let (contract_address, _) = contract.deploy(@ArrayTrait::new()).unwrap();
    contract_address
}

#[test]
fn test_deposit() {
    let contract_address = deploy_shielded_pool();
    let dispatcher = IShieldedPoolDispatcher { contract_address };
    
    let user = contract_address_const::<0x123456>();
    start_cheat_caller_global(user);
    
    dispatcher.deposit(100);
    
    let deposit = dispatcher.get_deposit(user);
    assert(deposit == 100, 'Deposit should be 100');
    
    stop_cheat_caller_global();
}

#[test]
fn test_multiple_deposits() {
    let contract_address = deploy_shielded_pool();
    let dispatcher = IShieldedPoolDispatcher { contract_address };
    
    let user1 = contract_address_const::<0x111111>();
    let user2 = contract_address_const::<0x222222>();
    
    start_cheat_caller_global(user1);
    dispatcher.deposit(100);
    stop_cheat_caller_global();
    
    start_cheat_caller_global(user2);
    dispatcher.deposit(200);
    stop_cheat_caller_global();
    
    assert(dispatcher.get_deposit(user1) == 100, 'User1 deposit mismatch');
    assert(dispatcher.get_deposit(user2) == 200, 'User2 deposit mismatch');
    assert(dispatcher.get_total_deposits() == 300, 'Total deposits mismatch');
}

#[test]
fn test_withdraw() {
    let contract_address = deploy_shielded_pool();
    let dispatcher = IShieldedPoolDispatcher { contract_address };
    
    let user = contract_address_const::<0x123456>();
    start_cheat_caller_global(user);
    
    dispatcher.deposit(100);
    assert(dispatcher.get_deposit(user) == 100, 'Initial deposit should be 100');
    
    dispatcher.withdraw(40);
    assert(dispatcher.get_deposit(user) == 60, 'After withdraw should be 60');
    assert(dispatcher.get_total_deposits() == 60, 'Total should be 60');
    
    stop_cheat_caller_global();
}

#[test]
#[should_panic(expected: ('Insufficient balance',))]
fn test_withdraw_insufficient_balance() {
    let contract_address = deploy_shielded_pool();
    let dispatcher = IShieldedPoolDispatcher { contract_address };
    
    let user = contract_address_const::<0x123456>();
    start_cheat_caller_global(user);
    
    dispatcher.deposit(50);
    dispatcher.withdraw(100); // Should panic
    
    stop_cheat_caller_global();
}