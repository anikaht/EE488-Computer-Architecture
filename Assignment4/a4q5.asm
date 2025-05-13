    #####################################################
    # a4q5.asm
    # Q5: Read an amount (1–99 cents), compute change in
    #     quarters, dimes, nickels, pennies, then exit.
    #####################################################

    .data
prompt_amt:   .asciiz "Enter amount in cents (1-99): "
quarter_lbl:  .asciiz " quarters, "
dime_lbl:     .asciiz " dimes, "
nickel_lbl:   .asciiz " nickels, "
penny_lbl:    .asciiz " pennies\n"

    .text
    .globl main
main:
    # Call the coin_change routine
    jal  coin_change

    # Exit program
    li   $v0, 10
    syscall

# ------------------------------------------------------------
# coin_change:
#   Prompts for an amount in cents, reads it, then computes
#   the number of quarters, dimes, nickels, and pennies, and
#   prints each count with its label.
#   Uses only div/mflo/mfhi for arithmetic.
# ------------------------------------------------------------
coin_change:
    # Prompt the user
    li   $v0, 4
    la   $a0, prompt_amt
    syscall

    # Read the amount into t0
    li   $v0, 5
    syscall
    move $t0, $v0        # t0 = amount

    # Compute quarters
    li   $t1, 25
    div  $t0, $t1
    mflo $t2             # t2 = #quarters
    mfhi $t0             # t0 = remainder

    # Compute dimes
    li   $t1, 10
    div  $t0, $t1
    mflo $t3             # t3 = #dimes
    mfhi $t0             # t0 = remainder

    # Compute nickels
    li   $t1, 5
    div  $t0, $t1
    mflo $t4             # t4 = #nickels
    mfhi $t0             # t0 = remainder

    # Remaining pennies
    move $t5, $t0        # t5 = #pennies

    # Print quarters
    li   $v0, 1
    move $a0, $t2
    syscall
    li   $v0, 4
    la   $a0, quarter_lbl
    syscall

    # Print dimes
    li   $v0, 1
    move $a0, $t3
    syscall
    li   $v0, 4
    la   $a0, dime_lbl
    syscall

    # Print nickels
    li   $v0, 1
    move $a0, $t4
    syscall
    li   $v0, 4
    la   $a0, nickel_lbl
    syscall

    # Print pennies
    li   $v0, 1
    move $a0, $t5
    syscall
    li   $v0, 4
    la   $a0, penny_lbl
    syscall

    jr   $ra
    nop
