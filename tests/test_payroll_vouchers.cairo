%lang starknet

from contracts.PayrollVouchers import PayrollVouchers

@external
func test_create_voucher{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}():
    let employee = 12345
    let amount = Uint256(500, 0)
    let (voucher_id) = PayrollVouchers.create_voucher(employee, amount)

    let (emp, amt, claimed) = PayrollVouchers.get_voucher(voucher_id)
    assert emp = employee
    assert amt.low = 500
    assert claimed = 0

    let (count) = PayrollVouchers.get_employee_voucher_count(employee)
    assert count = 1

    let (vid) = PayrollVouchers.get_employee_voucher(employee, 0)
    assert vid = voucher_id

    return ()
end

@external
func test_claim_voucher{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}():
    let employee = 12345
    let amount = Uint256(300, 0)
    let (voucher_id) = PayrollVouchers.create_voucher(employee, amount)

    # Simulate claiming as the employee
    PayrollVouchers.claim_voucher(voucher_id)

    let (emp, amt, claimed) = PayrollVouchers.get_voucher(voucher_id)
    assert claimed = 1

    return ()
end