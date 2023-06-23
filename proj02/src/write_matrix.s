.globl write_matrix

.text
# ==============================================================================
# FUNCTION: Writes a matrix of integers into a binary file
#   If any file operation fails or doesn't write the proper number of bytes,
#   exit the program with exit code 1.
# FILE FORMAT:
#   The first 8 bytes of the file will be two 4 byte ints representing the
#   numbers of rows and columns respectively. Every 4 bytes thereafter is an
#   element of the matrix in row-major order.
# Arguments:
#   a0 (char*) is the pointer to string representing the filename
#   a1 (int*)  is the pointer to the start of the matrix in memory
#   a2 (int)   is the number of rows in the matrix
#   a3 (int)   is the number of columns in the matrix
# Returns:
#   None
#
# If you receive an fopen error or eof, 
# this function exits with error code 53.
# If you receive an fwrite error or eof,
# this function exits with error code 54.
# If you receive an fclose error or eof,
# this function exits with error code 55.
# ==============================================================================
write_matrix:
    #! t0
    # Prologue
    addi    sp, sp, -24
    sw      ra, 0(sp)
    sw      s0, 4(sp)
    sw      s1, 8(sp)
    sw      s2, 12(sp)
    sw      s3, 16(sp)
    sw      s4, 20(sp)          # file descriptor

    mv      s0, a0
    mv      s1, a1
    mv      s2, a2
    mv      s3, a3

    # create dest file
    mv      a1, s0
    li      a2, 1
    jal     ra, fopen
    # check fopen error
    li      t0, -1
    beq     a0, t0, exit_53
    mv      s4, a0

    # write to the dest file
    li      a0, 8
    jal     ra, malloc
    # check malloc error
    beq     a0, zero, exit_48   # NULL
    mv      a2, a0
    sw      s2, 0(a2)
    sw      s3, 4(a2)
    mv      a1, s4
    li      a3, 2
    li      a4, 4
    jal     ra, fwrite          # write row and column
    # check fwrite error
    bne     a0, a3, exit_54
    # free 8 bytes
    mv      a0, a2
    jal     ra, free
    
    mv      a1, s4
    mv      a2, s1
    mv      a3, s2
    mul     a3, a3, s3
    li      a4, 4
    jal     ra, fwrite
    # check fwrite error
    bne     a0, a3, exit_54

    # close file
    mv      a1, s4
    jal     ra, fclose
    # check fclose error
    li      t0, -1
    beq     a0, t0, exit_55

    # Epilogue
    lw      ra, 0(sp)
    lw      s0, 4(sp)
    lw      s1, 8(sp)
    lw      s2, 12(sp)
    lw      s3, 16(sp)
    lw      s4, 20(sp)
    addi    sp, sp, 24

    jr      ra

exit_48:
    li      a1, 48
    jal     exit2

exit_53:
    li      a1, 53
    jal     exit2

exit_54:
    li      a1, 54
    jal     exit2

exit_55:
    li      a1, 55
    jal     exit2