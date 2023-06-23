.globl read_matrix

.text
# ==============================================================================
# FUNCTION: Allocates memory and reads in a binary file as a matrix of integers
#   If any file operation fails or doesn't read the proper number of bytes,
#   exit the program with exit code 1.
# FILE FORMAT:
#   The first 8 bytes are two 4 byte ints representing the # of rows and columns
#   in the matrix. Every 4 bytes afterwards is an element of the matrix in
#   row-major order.
# Arguments:
#   a0 (char*) is the pointer to string representing the filename
#   a1 (int*)  is a pointer to an integer, we will set it to the number of rows
#   a2 (int*)  is a pointer to an integer, we will set it to the number of columns
# Returns:
#   a0 (int*)  is the pointer to the matrix in memory
#
# If you receive an fopen error or eof, 
# this function exits with error code 50.
# If you receive an fread error or eof,
# this function exits with error code 51.
# If you receive an fclose error or eof,
# this function exits with error code 52.
# ==============================================================================
read_matrix:
    #! t0, t1
    # Prologue
	addi    sp, sp, -24
    sw      ra, 0(sp)
    sw      s0, 4(sp)
    sw      s1, 8(sp)
    sw      s2, 12(sp)
    sw      s3, 16(sp)          # file descriptor
    sw      s4, 20(sp)          # memory address

    mv      s0, a0
    mv      s1, a1
    mv      s2, a2

    # open file
    mv      a1, s0
    li      a2, 0
    jal     ra, fopen           # call fopen, get the fd
    # check fopen error
    li      t0, -1
    beq     a0, t0, exit_50     # -1: fopen error
    mv      s3, a0              # file descriptor

    # read row and column
    li      a0, 8
    jal     ra, malloc          # malloc memory
    # check malloc error
    beq     a0, zero, exit_48   # NULL
    mv      s4, a0              # address of memory

    mv      a1, s3
    li      a3, 8
    mv      a2, s4
    jal     ra, fread
    # check fread error
    bne     a0, a3, exit_51
    
    lw      t0, 0(s4)
    sw      t0, 0(s1)           # store row
    lw      t1, 4(s4)
    sw      t1, 0(s2)           # store column
    mul     t0, t0, t1
    li      t1, 4
    mul     t0, t0, t1          # matrix's size

    # free 8 bytes: s4
    mv      a0, s4
    jal     ra, free

    # read matrix
    mv      a0, t0
    jal     ra, malloc
    # check malloc error
    beq     a0, zero, exit_48   # NULL
    mv      s4, a0

    mv      a1, s3
    mv      a2, s4
    mv      a3, t0
    jal     ra, fread           # read matrix
    # check fread error
    bne     a0, a3, exit_51

    # close file
    mv      a1, s3
    jal     ra, fclose
    # check fclose error
    li      t0, -1
    beq     a0, t0, exit_52

    mv      a0, s4              # return the address of array

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

exit_50:
    li      a1, 50
    jal     exit2

exit_51:
    li      a1, 51
    jal     exit2

exit_52:
    li      a1, 52
    jal     exit2