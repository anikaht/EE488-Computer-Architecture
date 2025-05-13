
.data
prompt_a:   .asciiz "Enter the first number: "
prompt_b:   .asciiz "Enter a prime number: "
result_msg: .asciiz "The result is: "

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

    # Prompt for the prime number
    li $v0, 4
    la $a0, prompt_b
    syscall
    li $v0, 5
    syscall
    move $t1, $v0  # $t1 = prime number

    # Check if the prime number is a factor
    div $t0, $t1
    mfhi $t2       # $t2 = remainder

    # Print the result
    li $v0, 4
    la $a0, result_msg
    syscall
    move $a0, $t2
    li $v0, 1
    syscall

    # Exit
    li $v0, 10
    syscall

