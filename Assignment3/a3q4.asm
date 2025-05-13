.data
prompt:     .asciiz "Enter a number: "
result_msg: .asciiz "The number is odd (1) or even (0): "

.text
.globl main

main:
    # Prompt for input
    li $v0, 4
    la $a0, prompt
    syscall
    li $v0, 5
    syscall
    move $t0, $v0  # $t0 = input number

    # Check if even or odd using sll and srl
    srl $t1, $t0, 1  # Shift right by 1 (divide by 2)
    sll $t2, $t1, 1  # Shift left by 1 (multiply by 2)
    sub $t3, $t0, $t2  # $t3 = input - (input / 2) * 2

    # Print the result
    li $v0, 4
    la $a0, result_msg
    syscall
    move $a0, $t3
    li $v0, 1
    syscall

    # Exit
    li $v0, 10
    syscall
