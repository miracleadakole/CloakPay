use cloakpay::payroll_vouchers::PayrollVouchers;
use cloakpay::payroll_vouchers::IPayrollVouchersDispatcher;
use cloakpay::payroll_vouchers::IPayrollVouchersDispatcherTrait;
use starknet::{ContractAddress, contract_address_const};
use snforge_std::{declare, ContractClassTrait, DeclareResultTrait, start_cheat_caller_global, stop_cheat_caller_global};

fn deploy_payroll_vouchers() -> ContractAddress {
    let contract = declare("PayrollVouchers").unwrap().contract_class();
    let (contract_address, _) = contract.deploy(@ArrayTrait::new()).unwrap();
    contract_address
}

#[test]
fn test_create_voucher() {
    let contract_address = deploy_payroll_vouchers();
    let dispatcher = IPayrollVouchersDispatcher { contract_address };
    
    let employer = contract_address_const::<0x999999>();
    let employee = contract_address_const::<0x123456>();
    
    start_cheat_caller_global(employer);
    
    dispatcher.create_voucher(employee, 500);
    
    let amount = dispatcher.get_voucher_amount(1);
    assert(amount == 500, 'Voucher amount should be 500');
    
    let is_claimed = dispatcher.is_claimed(1);
    assert(is_claimed == false, 'Voucher should not be claimed');
    
    stop_cheat_caller_global();
}

#[test]
fn test_create_multiple_vouchers() {
    let contract_address = deploy_payroll_vouchers();
    let dispatcher = IPayrollVouchersDispatcher { contract_address };
    
    let employer = contract_address_const::<0x999999>();
    let employee1 = contract_address_const::<0x111111>();
    let employee2 = contract_address_const::<0x222222>();
    
    start_cheat_caller_global(employer);
    
    dispatcher.create_voucher(employee1, 500);
    dispatcher.create_voucher(employee2, 750);
    dispatcher.create_voucher(employee1, 300);
    
    assert(dispatcher.get_voucher_amount(1) == 500, 'Voucher 1 amount mismatch');
    assert(dispatcher.get_voucher_amount(2) == 750, 'Voucher 2 amount mismatch');
    assert(dispatcher.get_voucher_amount(3) == 300, 'Voucher 3 amount mismatch');
    
    stop_cheat_caller_global();
}

#[test]
fn test_claim_voucher() {
    let contract_address = deploy_payroll_vouchers();
    let dispatcher = IPayrollVouchersDispatcher { contract_address };
    
    let employer = contract_address_const::<0x999999>();
    let employee = contract_address_const::<0x123456>();
    
    start_cheat_caller_global(employer);
    dispatcher.create_voucher(employee, 500);
    stop_cheat_caller_global();
    
    start_cheat_caller_global(employee);
    dispatcher.claim_voucher(1);
    
    let is_claimed = dispatcher.is_claimed(1);
    assert(is_claimed == true, 'Voucher should be claimed');
    
    stop_cheat_caller_global();
}

#[test]
#[should_panic(expected: ('Not authorized',))]
fn test_claim_voucher_unauthorized() {
    let contract_address = deploy_payroll_vouchers();
    let dispatcher = IPayrollVouchersDispatcher { contract_address };
    
    let employer = contract_address_const::<0x999999>();
    let employee = contract_address_const::<0x123456>();
    let unauthorized = contract_address_const::<0x777777>();
    
    start_cheat_caller_global(employer);
    dispatcher.create_voucher(employee, 500);
    stop_cheat_caller_global();
    
    start_cheat_caller_global(unauthorized);
    dispatcher.claim_voucher(1); // Should panic - not authorized
    stop_cheat_caller_global();
}

#[test]
#[should_panic(expected: ('Already claimed',))]
fn test_claim_voucher_twice() {
    let contract_address = deploy_payroll_vouchers();
    let dispatcher = IPayrollVouchersDispatcher { contract_address };
    
    let employer = contract_address_const::<0x999999>();
    let employee = contract_address_const::<0x123456>();
    
    start_cheat_caller_global(employer);
    dispatcher.create_voucher(employee, 500);
    stop_cheat_caller_global();
    
    start_cheat_caller_global(employee);
    dispatcher.claim_voucher(1);
    dispatcher.claim_voucher(1); // Should panic - already claimed
    stop_cheat_caller_global();
}

#[test]
fn test_get_voucher_amount() {
    let contract_address = deploy_payroll_vouchers();
    let dispatcher = IPayrollVouchersDispatcher { contract_address };
    
    let employer = contract_address_const::<0x999999>();
    let employee = contract_address_const::<0x123456>();
    
    start_cheat_caller_global(employer);
    dispatcher.create_voucher(employee, 1000);
    stop_cheat_caller_global();
    
    let amount = dispatcher.get_voucher_amount(1);
    assert(amount == 1000, 'Amount should be 1000');
}

    # Simulate claiming as the employee
    PayrollVouchers.claim_voucher(voucher_id)

    let (emp, amt, claimed) = PayrollVouchers.get_voucher(voucher_id)
    assert claimed = 1

    return ()
end