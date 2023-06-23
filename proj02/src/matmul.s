.globl matmul

.text
# =======================================================
# FUNCTION: Matrix Multiplication of 2 integer matrices
# 	d = matmul(m0, m1)
#   The order of error codes (checked from top to bottom):
#   If the dimensions of m0 do not make sense, 
#   this function exits with exit code 2.
#   If the dimensions of m1 do not make sense, 
#   this function exits with exit code 3.
#   If the dimensions don't match, 
#   this function exits with exit code 4.
# Arguments:
# 	a0 (int*)  is the pointer to the start of m0 
#	a1 (int)   is the # of rows (height) of m0
#	a2 (int)   is the # of columns (width) of m0
#	a3 (int*)  is the pointer to the start of m1
# 	a4 (int)   is the # of rows (height) of m1
#	a5 (int)   is the # of columns (width) of m1
#	a6 (int*)  is the pointer to the the start of d
# Returns:
#	None (void), sets d = matmul(m0, m1)
# =======================================================
matmul:
    #! t0, t1, t2
    # err check
    beq     a0, zero, exit_2
    ble     a1, zero, exit_2
    ble     a2, zero, exit_2

    beq     a3, zero, exit_3
    ble     a4, zero, exit_3
    ble     a5, zero, exit_3

    bne     a2, a4, exit_4

    # Prologue
    addi    sp, sp, -8
    sw      ra, 0(sp)
    sw      s0, 4(sp)

    li      t0, 0           # i = 0
    li      t1, 0           # j = 0
    li      t2, 4
    mul     t2, t2, a2      # for matrix 1 jump to the next row
    mv      s0, a3          # to store the start address of matrix 2

outer_loop_start:
    beq     t0, a1, outer_loop_end

inner_loop_start:
    beq     t1, a5, inner_loop_end

    addi    sp, sp, -32
    sw      a0, 0(sp)
    sw      a1, 4(sp)
    sw      a2, 8(sp)
    sw      a3, 12(sp)
    sw      a4, 16(sp)
    sw      t0, 20(sp)
    sw      t1, 24(sp)
    sw      t2, 28(sp)

    mv      a0, a0
    mv      a1, a3
    mv      a2, a2
    li      a3, 1
    mv      a4, a5
    jal     ra, dot             # call dot
    sw      a0, 0(a6)

    lw      a0, 0(sp)
    lw      a1, 4(sp)
    lw      a2, 8(sp)
    lw      a3, 12(sp)
    lw      a4, 16(sp)
    lw      t0, 20(sp)
    lw      t1, 24(sp)
    lw      t2, 28(sp)
    addi    sp, sp, 32

    addi    t1, t1, 1           # ++j
    addi    a3, a3, 4           # matrix 2 move to the next column
    addi    a6, a6, 4           # dest move to the next column

    j       inner_loop_start

inner_loop_end:

    addi    t0, t0, 1           # ++i
    add     a0, a0, t2          # matrix 1 move to the next row
    mv      a3, s0
    li      t1, 0

    j       outer_loop_start

outer_loop_end:

    # Epilogue
    lw      ra, 0(sp)
    lw      s0, 4(sp)
    addi    sp, sp, 8
    
    jr      ra

exit_2:
    li      a1, 2
    j       exit2

exit_3:
    li      a1, 3
    j       exit2

exit_4:
    li      a1, 4
    j       exit2