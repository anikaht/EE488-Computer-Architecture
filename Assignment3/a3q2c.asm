.data
prompt_x:   .asciiz "Enter x: "
result_msg: .asciiz "The result of x^3 + 2x^2 + 3x + 4 is: "

.text
.globl main

main:
    # Prompt for x
    li $v0, 4
    la $a0, prompt_x
    syscall
    li $v0, 5
    syscall
    move $t0, $v0  # $t0 = x

    # Calculate x^3
    mul $t1, $t0, $t0  # $t1 = x^2
    mul $t2, $t1, $t0  # $t2 = x^3

    # Calculate 2x^2
    li $t3, 2
    mul $t4, $t1, $t3  # $t4 = 2x^2

    # Calculate 3x
    li $t3, 3
    mul $t5, $t0, $t3  # $t5 = 3x

    # Add all terms
    add $t6, $t2, $t4  # $t6 = x^3 + 2x^2
    add $t7, $t6, $t5  # $t7 = x^3 + 2x^2 + 3x
    addi $t8, $t7, 4   # $t8 = x^3 + 2x^2 + 3x + 4

    # Print the result
    li $v0, 4
    la $a0, result_msg
    syscall
    move $a0, $t8
    li $v0, 1
    syscall

    # Exit
    li $v0, 10
    syscall
