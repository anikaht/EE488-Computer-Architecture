    #####################################################
    # a4q2.asm
    # Q2: Read n (>=3), print primes 3..n, then exit
    #####################################################

    .data
prompt_n:  .asciiz "Enter an integer n (>= 3): "
newline:   .asciiz "\n"

    .text
    .globl main
main:
    # Prompt for n
    li   $v0, 4
    la   $a0, prompt_n
    syscall

    # Read n into $t5
    li   $v0, 5
    syscall
    move $t5, $v0        # t5 = n

    # Initialize i = 3
    li   $t0, 3

loop_i:
    # If i > n, exit
    bgt  $t0, $t5, exit

    # Test divisors j = 2..√i
    li   $t1, 2          # j = 2

test_j:
    mul  $t2, $t1, $t1   # t2 = j * j
    bgt  $t2, $t0, is_prime  # if j^2 > i, it's prime

    div  $t0, $t1        # divide i by j
    mfhi $t3             # t3 = remainder
    beq  $t3, $zero, next_i # divisible → not prime

    addi $t1, $t1, 1     # j++
    j    test_j

is_prime:
    # Print i
    li   $v0, 1
    move $a0, $t0
    syscall
    # Print newline
    li   $v0, 4
    la   $a0, newline
    syscall

next_i:
    addi $t0, $t0, 1     # i++
    j    loop_i

exit:
    # Clean exit
    li   $v0, 10
    syscall
