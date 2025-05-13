#####################################################
    # a4q3.asm
    # Q3: Read n (3–100), print its prime factors (with repeats),
    #     then exit.
    #####################################################

    .data
prompt_n:     .asciiz "Enter an integer n (3-100): "
prompt_fact:  .asciiz "Prime factors: "
comma_space:  .asciiz ", "
newline:      .asciiz "\n"

    .text
    .globl main
main:
    # — Prompt for n —
    li   $v0, 4
    la   $a0, prompt_n
    syscall

    # — Read n into $t1 —
    li   $v0, 5
    syscall
    move $t1, $v0        # t1 = n

    # — Print header —
    li   $v0, 4
    la   $a0, prompt_fact
    syscall

    # — Initialize factor = 2 —
    li   $t0, 2

factor_loop:
    # if factor > remaining (t1), we’re done
    bgt  $t0, $t1, done_factors

    # divide remaining by factor
    div  $t1, $t0
    mfhi $t2            # t2 = remainder

    # if not divisible, bump factor
    bne  $t2, $zero, next_factor

    # — divisible: print factor —
    li   $v0, 1
    move $a0, $t0
    syscall

    # — print ", " —
    li   $v0, 4
    la   $a0, comma_space
    syscall

    # update remaining = quotient
    mflo $t1

    # loop again with same factor (to catch repeats)
    j    factor_loop

next_factor:
    addi $t0, $t0, 1    # factor++
    j    factor_loop

done_factors:
    # newline
    li   $v0, 4
    la   $a0, newline
    syscall

    # exit
    li   $v0, 10
    syscall
