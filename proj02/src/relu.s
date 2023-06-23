.globl relu

.text
# ==============================================================================
# FUNCTION: Performs an inplace element-wise ReLU on an array of ints
# Arguments:
# 	a0 (int*) is the pointer to the array
#	a1 (int)  is the # of elements in the array
# Returns:
#	None
#
# If the length of the vector is less than 1, 
# this function exits with error code 8.
# ==============================================================================
relu:
    #! t0, t1
    # Prologue
    addi    sp, sp, -4
    sw      ra, 0(sp)

    # check vector size
    li      t0, 1
    blt     a1, t0, exit_8

    mv      t0, zero

loop_start:
    beq     t0, a1, loop_end            # count == size: goto loop_end

    lw      t1, 0(a0)                   # x = arr[i]
    bge     t1, zero, loop_continue     # x >= 0, continue

    sw      zero, 0(a0)                 # arr[i] = 0

loop_continue:
    addi    t0, t0, 1                   # count++
    addi    a0, a0, 4                   # update address
    j       loop_start

loop_end:

    # Epilogue
    lw      ra, 0(sp)
    addi    sp, sp, 4

	jr      ra

exit_8:
    li      a1, 8
    jal     exit2