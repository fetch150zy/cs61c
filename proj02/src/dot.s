.globl dot

.text
# =======================================================
# FUNCTION: Dot product of 2 int vectors
# Arguments:
#   a0 (int*) is the pointer to the start of v0
#   a1 (int*) is the pointer to the start of v1
#   a2 (int)  is the length of the vectors
#   a3 (int)  is the stride of v0
#   a4 (int)  is the stride of v1
# Returns:
#   a0 (int)  is the dot product of v0 and v1
#
# If the length of the vector is less than 1, 
# this function exits with error code 5.
# If the stride of either vector is less than 1,
# this function exits with error code 6.
# =======================================================
dot:
    #! t0, t1
    # Prologue
    addi    sp, sp, -20
    sw      ra, 0(sp)
    sw      s0, 4(sp)
    sw      s1, 8(sp)
    sw      s2, 12(sp)
    sw      s3, 16(sp)

    # check vector's size and stride
    li      t0, 1
    blt     a2, t0, exit_5
    blt     a3, t0, exit_6
    blt     a4, t0, exit_6

    li      t0, 0               # count
    li      s0, 4               # 4 bytes pre value
    li      s1, 4                
    mul     s0, s0, a3          # 4 * stride
    mul     s1, s1, a4
    li      t1, 0               # res

loop_start:
    beq     t0, a2, loop_end    # i == size: goto loop_end
    lw      s2, 0(a0)
    lw      s3, 0(a1)
    mul     s2, s2, s3
    add     t1, t1, s2          # sum

    addi    t0, t0, 1           # count++
    add     a0, a0, s0          # update address
    add     a1, a1, s1
    
    j loop_start

loop_end:
    mv      a0, t1

    # Epilogue
    lw      ra, 0(sp)
    lw      s0, 4(sp)
    lw      s1, 8(sp)
    lw      s2, 12(sp)
    lw      s3, 16(sp)
    addi    sp, sp, 20
    
    jr      ra

exit_5:
    li      a1, 5
    jal     exit2

exit_6:
    li      a1, 6
    jal     exit2