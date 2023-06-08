.globl factorial

.data
n: .word 8

.text
main:
    la t0, n
    lw a0, 0(t0)
    jal ra, factorial

    addi a1, a0, 0
    addi a0, x0, 1
    ecall # Print Result

    addi a1, x0, '\n'
    addi a0, x0, 11
    ecall # Print newline

    addi a0, x0, 10
    ecall # Exit

# int factorial(int x)
# {
#     int sum = 1;
#     for (int i = x; i > 0; --i) {
#         sum *= i;
#     }
#     return sum;
# }
factorial:
    # Prologue
    addi sp, sp, -4
    sw t0, 0(sp)

    # func part
    li s0, 1        # int sum = 1
    mv t0, a0       # int i = x
loop:
    ble t0, x0, exit # if t0 <x0 exit
    mul s0, s0, t0
    addi t0, t0, -1
    j loop
    
exit:
    mv a0, s0
    # Epilogue
    lw t0, 0(sp)
    addi sp, sp, 4

    ret