    #####################################################
    # a4q4.asm
    # Q4: Read an integer and print “even” or “odd”
    #      using only srl/sll for the test.
    #####################################################

    .data
prompt_even:  .asciiz "Enter an integer: "
even_str:     .asciiz "The number is even\n"
odd_str:      .asciiz "The number is odd\n"

    .text
    .globl main
main:
    # Call the even/odd tester
    jal   even_odd

    # Exit program
    li    $v0, 10
    syscall

# ------------------------------------------------------------
# even_odd:
#   Prompts for an integer, reads it, and prints
#   even_str if it’s even, odd_str if it’s odd.
#   Only uses srl/sll to test the low bit.
# ------------------------------------------------------------
even_odd:
    # Print prompt
    li    $v0, 4
    la    $a0, prompt_even
    syscall

    # Read integer into t0
    li    $v0, 5
    syscall
    move  $t0, $v0

    # Compute t1 = (t0 >> 1) << 1
    srl   $t1, $t0, 1
    sll   $t1, $t1, 1

    # If t1 == t0, it was even
    beq   $t1, $t0, EVEN

    # Otherwise, odd
    li    $v0, 4
    la    $a0, odd_str
    syscall
    jr    $ra

EVEN:
    li    $v0, 4
    la    $a0, even_str
    syscall
    jr    $ra
