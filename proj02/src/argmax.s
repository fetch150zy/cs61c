.globl argmax

.text
# =================================================================
# FUNCTION: Given a int vector, return the index of the largest
#	element. If there are multiple, return the one
#	with the smallest index.
# Arguments:
# 	a0 (int*) is the pointer to the start of the vector
#	a1 (int)  is the # of elements in the vector
# Returns:
#	a0 (int)  is the first index of the largest element
#
# If the length of the vector is less than 1, 
# this function exits with error code 7.
# =================================================================
argmax:
    #! t0, t1
    # Prologue
    addi    sp, sp, -12
    sw      ra, 0(sp)
    sw      s0, 4(sp)
    sw      s1, 8(sp)

    # check vector size
    li      t0, 1
    blt     a1, t1, exit_7

    lw      s1, 0(a0)       # max val: vector[0]
    li      s0, 0           # the max val's index
    addi    a0, a0, 4       # address
    li      t0, 1           # t0: count

loop_start:
    beq     t0, a1, loop_end

    lw      t1, 0(a0)               # t1: vector[i]
    ble     t1, s1, loop_continue   # vector[i] < max_val: goto loop_continue
    mv      s1, t1                  # else: max_val = vector[i]
    mv      s0, t0                  #       index = count

loop_continue:
    addi    t0, t0, 1               # ++count
    addi    a0, a0, 4               # update address
    j       loop_start

loop_end:
    mv      a0, s0                  # return index

    # Epilogue
    lw      ra, 0(sp)
    lw      s0, 4(sp)
    lw      s1, 8(sp)
    addi    sp, sp, 12

    jr      ra

exit_7:
    li      a1, 7
    jal     exit2