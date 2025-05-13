.data
prompt_x:   .asciiz "Enter x: "
prompt_y:   .asciiz "Enter y: "
prompt_z:   .asciiz "Enter z: "
result_msg: .asciiz "The result of 5x + 3y + z is: "

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

    # Prompt for y
    li $v0, 4
    la $a0, prompt_y
    syscall
    li $v0, 5
    syscall
    move $t1, $v0  # $t1 = y

    # Prompt for z
    li $v0, 4
    la $a0, prompt_z
    syscall
    li $v0, 5
    syscall
    move $t2, $v0  # $t2 = z

    # Calculate 5x + 3y + z
    li $t3, 5
    mul $t4, $t0, $t3  # $t4 = 5x
    li $t3, 3
    mul $t5, $t1, $t3  # $t5 = 3y
    add $t6, $t4, $t5  # $t6 = 5x + 3y
    add $t7, $t6, $t2  # $t7 = 5x + 3y + z

    # Print the result
    li $v0, 4
    la $a0, result_msg
    syscall
    move $a0, $t7
    li $v0, 1
    syscall

    # Exit
    li $v0, 10
    syscall
 
