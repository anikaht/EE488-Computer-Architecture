.data
prompt:     .asciiz "Enter a number: "
result_msg: .asciiz "The result of multiplying by 10 is: "

.text
.globl main

main:
    # Prompt the user for input
    li $v0, 4              # syscall for print_string
    la $a0, prompt         # load address of prompt
    syscall

    # Read the integer input
    li $v0, 5              # syscall for read_int
    syscall
    move $t0, $v0          # store the input in $t0

    # Multiply by 10 using bit shifts and addition
    sll $t1, $t0, 3        # $t1 = input * 8 (shift left by 3)
    sll $t2, $t0, 1        # $t2 = input * 2 (shift left by 1)
    add $t3, $t1, $t2      # $t3 = (input * 8) + (input * 2) = input * 10

    # Verify using mult and mflo
    mult $t0, $10          # multiply input by 10
    mflo $t4               # store the result in $t4

    # Print the result
    li $v0, 4              # syscall for print_string
    la $a0, result_msg      # load address of result_msg
    syscall

    move $a0, $t3          # load the result into $a0
    li $v0, 1              # syscall for print_int
    syscall

    # Exit the program
    li $v0, 10             # syscall for exit
    syscall

