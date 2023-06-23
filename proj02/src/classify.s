.globl classify

.text
classify:
    # =====================================
    # COMMAND LINE ARGUMENTS
    # =====================================
    # Args:
    #   a0 (int)    argc
    #   a1 (char**) argv
    #   a2 (int)    print_classification, if this is zero, 
    #               you should print the classification. Otherwise,
    #               this function should not print ANYTHING.
    # Returns:
    #   a0 (int)    Classification
    # 
    # If there are an incorrect number of command line args,
    # this function returns with exit code 49.
    #
    # Usage:
    #   main.s -m -1 <M0_PATH> <M1_PATH> <INPUT_PATH> <OUTPUT_PATH>
    #! t0
    li      t0, 5
    bne     a0, t0, exit_49

    # prologue
    addi    sp, sp, -48
    sw      ra, 0(sp)
    sw      s0, 4(sp)
    sw      s1, 8(sp)
    sw      s2, 12(sp)
    sw      s3, 16(sp)
    sw      s4, 20(sp)
    sw      s5, 24(sp)
    sw      s6, 28(sp)
    sw      s7, 32(sp)
    sw      s8, 36(sp)
    sw      s9, 40(sp)
    sw      s10, 44(sp)

    mv      s0, a1
    mv      s1, a2

	# =====================================
    # LOAD MATRICES
    # =====================================

    # Load pretrained m0
	li      a0, 8
    jal     ra, malloc
    # check malloc error
    beq     a0, zero, exit_48   # NULL
    mv      s2, a0              # 0(s2): m0's row, 4(s2): m0's column
	lw      a0, 4(s0)
    addi    a1, s2, 0
    addi    a2, s2, 4
    jal     ra, read_matrix
    mv      s3, a0              # s3: m0's address
    
    # Load pretrained m1
	li      a0, 8
    jal     ra, malloc
    # check malloc error
    beq     a0, zero, exit_48   # NULL
    mv      s4, a0              # 0(s4): m1's row, 4(s2): m1's column
    lw      a0, 8(s0)
    addi    a1, s4, 0
    addi    a2, s4, 4
    jal     ra, read_matrix
    mv      s5, a0              # s5: m1's address

    # Load input matrix
	li      a0, 8
    jal     ra, malloc
    # check malloc error
    beq     a0, zero, exit_48   # NULL
    mv      s6, a0              # 0(s6): mat's row, 4(s6): mat's column
    lw      a0, 12(s0)
    addi    a1, s6, 0
    addi    a2, s6, 4
	jal     ra, read_matrix
    mv      s7, a0	            # s7 = input matrix

    # =====================================
    # RUN LAYERS
    # =====================================
    # 1. LINEAR LAYER:    m0 * input
    # 2. NONLINEAR LAYER: ReLU(m0 * input)
    # 3. LINEAR LAYER:    m1 * ReLU(m0 * input)

    # matmul
    lw      t0, 0(s2)
    lw      t1, 4(s6)
    mul     a0, t0, t1
    li      t0, 4
    mul     a0, a0, t0
    jal     ra, malloc
    # check malloc error
    beq     a0, zero, exit_48   # NULL
    mv      s8, a0              # s8: m0 * mat

    mv      a0, s3
    lw      a1, 0(s2)
    lw      a2, 4(s2)
    mv      a3, s7
    lw      a4, 0(s6)
    lw      a5, 4(s6)
    mv      a6, s8

    jal     ra, matmul          # call matrix multiply
    
    # relu
    mv      a0, s8
    lw      t0, 0(s2)
    lw      t1, 4(s6)
    mul     a1, t0, t1

    jal     ra, relu            # call relu

    # matmul
    lw      t0, 0(s4)
    lw      t1, 4(s6)
    mul     a0, t0, t1
    li      t0, 4
    mul     a0, a0, t0
    jal     ra, malloc
    # check malloc error
    beq     a0, zero, exit_48   # NULL
    mv      s9, a0              # s9: m1 * relu(m0 * mat)

    mv      a0, s5
    lw      a1, 0(s4)
    lw      a2, 4(s4)
    mv      a3, s8
    lw      a4, 0(s2)
    lw      a5, 4(s6)
    mv      a6, s9
    
    jal     ra, matmul          # call matrix multiply

    # =====================================
    # WRITE OUTPUT
    # =====================================
    # Write output matrix
	lw      a0, 16(s0)
    mv      a1, s9
    lw      a2, 0(s4)
    lw      a3, 4(s6)
    jal     ra, write_matrix

    # =====================================
    # CALCULATE CLASSIFICATION/LABEL
    # =====================================
    # Call argmax
	mv      a0, s9
    lw      t0, 0(s4)
    lw      t1, 4(s6)
    mul     a1, t0, t1
    jal     ra, argmax
	mv      s10, a0                 # index
    
    bne     s1, x0, not_print
    # Print classification
    mv      a1, s10
    jal     ra, print_int

    # Print newline afterwards for clarity
	li      a1 '\n'
    jal     ra, print_char

not_print:
	# free the space
	mv      a0, s2
    jal     free
    mv      a0, s3
    jal     free
    mv      a0, s4
    jal     free
    mv      a0, s5
    jal     free
    mv      a0, s6
    jal     free
    mv      a0, s7
    jal     free
    mv      a0, s8
    jal     free
    mv      a0, s9
    jal     free
    
    mv      a0, s10                 # return classification
    
    # epilogue
    lw      ra, 0(sp)
    lw      s0, 4(sp)
    lw      s1, 8(sp)
    lw      s2, 12(sp)
    lw      s3, 16(sp)
    lw      s4, 20(sp)
    lw      s5, 24(sp)
    lw      s6, 28(sp)
    lw      s7, 32(sp)
    lw      s8, 36(sp)
    lw      s9, 40(sp)
    lw      s10, 44(sp)
    addi    sp, sp, 48

    jr      ra

exit_48:
    li      a1, 48
    jal     exit2

exit_49:
    li      a1, 49
    jal     exit2