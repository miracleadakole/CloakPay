#[feature("deprecated-starknet-consts")]
use cloakpay::shielded_pool::{IShieldedPoolDispatcher, IShieldedPoolDispatcherTrait};
use starknet::{ContractAddress, contract_address_const};
use snforge_std::{declare, ContractClassTrait, start_cheat_caller, stop_cheat_caller};

fn deploy_shielded_pool() -> ContractAddress {
    let contract = declare("ShieldedPool").unwrap();
    let (contract_address, _) = contract.deploy(@ArrayTrait::new()).unwrap();
    contract_address
}

#[test]
fn test_deposit() {
    let contract_address = deploy_shielded_pool();
    let dispatcher = IShieldedPoolDispatcher { contract_address };
    let user = contract_address_const::<0x123456>();
    
    start_cheat_caller(contract_address, user);
    dispatcher.deposit(100);
    
    let deposit = dispatcher.get_deposit(user);
    assert(deposit == 100, 'Deposit should be 100');
    stop_cheat_caller(contract_address);
}

#[test]
fn test_multiple_deposits() {
    let contract_address = deploy_shielded_pool();
    let dispatcher = IShieldedPoolDispatcher { contract_address };
    let user1 = contract_address_const::<0x111111>();
    let user2 = contract_address_const::<0x222222>();
    
    start_cheat_caller(contract_address, user1);
    dispatcher.deposit(100);
    stop_cheat_caller(contract_address);
    
    start_cheat_caller(contract_address, user2);
    dispatcher.deposit(200);
    stop_cheat_caller(contract_address);
    
    assert(dispatcher.get_deposit(user1) == 100, 'User1 deposit mismatch');
    assert(dispatcher.get_deposit(user2) == 200, 'User2 deposit mismatch');
}

#[test]
fn test_withdraw() {
    let contract_address = deploy_shielded_pool();
    let dispatcher = IShieldedPoolDispatcher { contract_address };
    let user = contract_address_const::<0x123456>();
    
    start_cheat_caller(contract_address, user);
    dispatcher.deposit(100);
    dispatcher.withdraw(40);
    
    assert(dispatcher.get_deposit(user) == 60, 'Balance should be 60');
    stop_cheat_caller(contract_address);
}

#[test]
#[should_panic(expected: ('Insufficient balance',))]
fn test_withdraw_insufficient_balance() {
    let contract_address = deploy_shielded_pool();
    let dispatcher = IShieldedPoolDispatcher { contract_address };
    let user = contract_address_const::<0x123456>();
    
    start_cheat_caller(contract_address, user);
    dispatcher.deposit(50);
    dispatcher.withdraw(100);
    stop_cheat_caller(contract_address);
}