.import ../../src/read_matrix.s
.import ../../src/utils.s

.data
file_path: .asciiz "inputs/test_read_matrix/test_input.bin"

.text
main:
    # Read matrix into memory
    li a0, 4
    jal ra, malloc
    mv s0, a0
    li a0, 4
    jal ra, malloc
    mv s1, a0

    la a0, file_path
    mv a1, s0
    mv a2, s1
    jal ra, read_matrix

    # Print out elements of matrix
    lw a1, 0(s0)
    lw a2, 0(s1)
    jal ra, print_int_array

    # Terminate the program
    jal exit