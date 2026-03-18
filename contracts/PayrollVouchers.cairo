%lang starknet

from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.cairo.common.uint256 import Uint256
from starkware.cairo.common.hash import hash2
from starkware.starknet.common.syscalls import get_caller_address

# Storage variables
@storage_var
func voucher_count() -> (res: felt):
end

@storage_var
func vouchers(voucher_id: felt) -> (employee: felt, amount: Uint256, claimed: felt):
end

@storage_var
func employee_vouchers(employee: felt, index: felt) -> (voucher_id: felt):
end

@storage_var
func employee_voucher_count(employee: felt) -> (res: felt):
end

# Events
@event
func voucher_created_event(voucher_id: felt, employee: felt, amount: Uint256):
end

@event
func voucher_claimed_event(voucher_id: felt, employee: felt, amount: Uint256):
end

# Constructor
@constructor
func constructor{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}():
    return ()
end

# Create a private voucher for an employee
@external
func create_voucher{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    employee: felt, amount: Uint256
) -> (voucher_id: felt):
    let (caller) = get_caller_address()
    # In real implementation, only employer can create vouchers
    # For now, anyone can create (simplified)

    let (current_count) = voucher_count.read()
    let voucher_id = current_count + 1
    voucher_count.write(voucher_id)

    vouchers.write(voucher_id, (employee, amount, 0))

    let (emp_count) = employee_voucher_count.read(employee)
    employee_vouchers.write(employee, emp_count, voucher_id)
    employee_voucher_count.write(employee, emp_count + 1)

    voucher_created_event.emit(voucher_id, employee, amount)
    return (voucher_id)
end

# Employee claims their voucher (private)
@external
func claim_voucher{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    voucher_id: felt
) -> ():
    let (caller) = get_caller_address()
    let (employee, amount, claimed) = vouchers.read(voucher_id)

    assert caller = employee, 'Not authorized to claim'
    assert claimed = 0, 'Voucher already claimed'

    # In real implementation, transfer WBTC to employee
    # For now, just mark as claimed
    vouchers.write(voucher_id, (employee, amount, 1))

    voucher_claimed_event.emit(voucher_id, employee, amount)
    return ()
end

# View functions
@view
func get_voucher{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    voucher_id: felt
) -> (employee: felt, amount: Uint256, claimed: felt):
    let (employee, amount, claimed) = vouchers.read(voucher_id)
    return (employee, amount, claimed)
end

@view
func get_employee_voucher_count{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    employee: felt
) -> (res: felt):
    let (res) = employee_voucher_count.read(employee)
    return (res)
end

@view
func get_employee_voucher{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    employee: felt, index: felt
) -> (voucher_id: felt):
    let (voucher_id) = employee_vouchers.read(employee, index)
    return (voucher_id)
end