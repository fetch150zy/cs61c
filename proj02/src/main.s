.import read_matrix.s
.import write_matrix.s
.import matmul.s
.import dot.s
.import relu.s
.import argmax.s
.import utils.s
.import classify.s

.globl main

# main.s -m -1 <M0_PATH> <M1_PATH> <INPUT_PATH> <OUTPUT_PATH>
# .data
# m0_path: .asciiz "/home/fetch150zy/Projects/pub-class/cs61c/proj02/tests/inputs/mnist/bin/m0.bin"
# m1_path: .asciiz "/home/fetch150zy/Projects/pub-class/cs61c/proj02/tests/inputs/mnist/bin/m1.bin"
# input_path: .asciiz "/home/fetch150zy/Projects/pub-class/cs61c/proj02/tests/inputs/mnist/bin/inputs/mnist_input0.bin"
# output_path: .asciiz "/home/fetch150zy/Projects/pub-class/cs61c/proj02/tests/outputs/test_mnist_main/student_mnist_outputs.bin"


# This is a dummy main function which imports and calls the classify function.
# While it just exits right after, it could always call classify again.
.text
main:
    # li      a0, 20
    # jal     malloc
    # la      t0, m0_path
    # sw      t0, 4(a0)
    # la      t0, m1_path
    # sw      t0, 8(a0)
    # la      t0, input_path
    # sw      t0, 12(a0)
    # la      t0, output_path
    # sw      t0, 16(a0)
    # mv      a1, a0

    # li      a0, 5
    # li      a2, 0
    jal     classify
    jal     exit
