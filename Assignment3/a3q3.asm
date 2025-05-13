.data
prompt_a:   .asciiz "Enter the first number: "
prompt_b:   .asciiz "Enter the second number: "
result_msg: .asciiz "After swapping, the numbers are: "

.text
.globl main

main:
    # Prompt for the first number
    li $v0, 4
    la $a0, prompt_a
    syscall
    li $v0, 5
    syscall
    move $t0, $v0  # $t0 = first number

    # Prompt for the second number
    li $v0, 4
    la $a0, prompt_b
    syscall
    li $v0, 5
    syscall
    move $t1, $v0  # $t1 = second number

    # Swap using XOR
    xor $t0, $t0, $t1  # $t0 = $t0 XOR $t1
    xor $t1, $t0, $t1  # $t1 = $t0 XOR $t1
    xor $t0, $t0, $t1  # $t0 = $t0 XOR $t1

    # Print the result
    li $v0, 4
    la $a0, result_msg
    syscall

    move $a0, $t0  # print first number
    li $v0, 1
    syscall

    li $v0, 11     # print space
    li $a0, 32
    syscall

    move $a0, $t1  # print second number
    li $v0, 1
    syscall

    # Exit
    li $v0, 10
    syscall
