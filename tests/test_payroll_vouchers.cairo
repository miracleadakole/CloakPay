#[feature("deprecated-starknet-consts")]
use cloakpay::payroll_vouchers::{IPayrollVouchersDispatcher, IPayrollVouchersDispatcherTrait};
use starknet::{ContractAddress, contract_address_const};
use snforge_std::{declare, ContractClassTrait, start_cheat_caller, stop_cheat_caller}; 

fn deploy_payroll_vouchers() -> ContractAddress {
    let contract = declare("PayrollVouchers").unwrap(); 
    let (contract_address, _) = contract.deploy(@ArrayTrait::new()).unwrap();
    contract_address
}

#[test]
fn test_create_voucher() {
    let contract_address = deploy_payroll_vouchers();
    let dispatcher = IPayrollVouchersDispatcher { contract_address };
    let employer = contract_address_const::<0x999999>();
    let employee = contract_address_const::<0x123456>();
    
    start_cheat_caller(contract_address, employer);
    dispatcher.create_voucher(employee, 1000);
    stop_cheat_caller(contract_address);

    assert(dispatcher.get_voucher_amount(1) == 1000, 'Wrong amount');
}

#[test]
fn test_create_multiple_vouchers() {
    let contract_address = deploy_payroll_vouchers();
    let dispatcher = IPayrollVouchersDispatcher { contract_address };
    let employer = contract_address_const::<0x999999>();
    let employee1 = contract_address_const::<0x111111>();
    let employee2 = contract_address_const::<0x222222>();
    
    start_cheat_caller(contract_address, employer);
    dispatcher.create_voucher(employee1, 500);
    dispatcher.create_voucher(employee2, 750);
    dispatcher.create_voucher(employee1, 300);
    stop_cheat_caller(contract_address);
    
    assert(dispatcher.get_voucher_amount(1) == 500, 'Voucher 1 amount mismatch');
    assert(dispatcher.get_voucher_amount(2) == 750, 'Voucher 2 amount mismatch');
    assert(dispatcher.get_voucher_amount(3) == 300, 'Voucher 3 amount mismatch');
}

#[test]
fn test_claim_voucher() {
    let contract_address = deploy_payroll_vouchers();
    let dispatcher = IPayrollVouchersDispatcher { contract_address };
    let employer = contract_address_const::<0x999999>();
    let employee = contract_address_const::<0x123456>();
    
    start_cheat_caller(contract_address, employer);
    dispatcher.create_voucher(employee, 500);
    stop_cheat_caller(contract_address);
    
    start_cheat_caller(contract_address, employee);
    dispatcher.claim_voucher(1);
    
    let is_claimed = dispatcher.is_claimed(1);
    assert(is_claimed == true, 'Voucher should be claimed');
    stop_cheat_caller(contract_address);
}

#[test]
#[should_panic(expected: ('Not authorized',))]
fn test_claim_voucher_unauthorized() {
    let contract_address = deploy_payroll_vouchers();
    let dispatcher = IPayrollVouchersDispatcher { contract_address };
    let employer = contract_address_const::<0x999999>();
    let employee = contract_address_const::<0x123456>();
    let unauthorized = contract_address_const::<0x777777>();
    
    start_cheat_caller(contract_address, employer);
    dispatcher.create_voucher(employee, 500);
    stop_cheat_caller(contract_address);
    
    start_cheat_caller(contract_address, unauthorized);
    dispatcher.claim_voucher(1); 
    stop_cheat_caller(contract_address);
}

#[test]
#[should_panic(expected: ('Already claimed',))]
fn test_claim_voucher_twice() {
    let contract_address = deploy_payroll_vouchers();
    let dispatcher = IPayrollVouchersDispatcher { contract_address };
    let employer = contract_address_const::<0x999999>();
    let employee = contract_address_const::<0x123456>();
    
    start_cheat_caller(contract_address, employer);
    dispatcher.create_voucher(employee, 500);
    stop_cheat_caller(contract_address);
    
    start_cheat_caller(contract_address, employee);
    dispatcher.claim_voucher(1);
    dispatcher.claim_voucher(1); 
    stop_cheat_caller(contract_address);
}