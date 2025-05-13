        .data
prompt:      .asciiz "Enter n: "
result_msg:  .asciiz "Factorial is: "
newline:     .asciiz "\n"

        .text
        .globl main
main:
        # --- Prompt & read n into $a0 ---
        li   $v0, 4
        la   $a0, prompt
        syscall

        li   $v0, 5
        syscall
        move $a0, $v0        # $a0 = n

        # --- Compute factorial(n) → $v0 ---
        jal  factorial

        # --- Preserve result before printing label ---
        move $t0, $v0        # t0 = n!

        # --- Print "Factorial is: " ---
        li   $v0, 4
        la   $a0, result_msg
        syscall

        # --- Print the numeric result from $t0 ---
        move $a0, $t0
        li   $v0, 1
        syscall

        # --- Newline & exit ---
        li   $v0, 4
        la   $a0, newline
        syscall
        li   $v0, 10
        syscall


# factorial:
#   in:  $a0 = n
#  out:  $v0 = n!
factorial:
        addiu $sp, $sp, -8
        sw    $ra, 4($sp)
        sw    $a0, 0($sp)       # save original n

        li    $t1, 1
        ble   $a0, $t1, fact_base   # if n ≤ 1, return 1

        # recursive case: compute fact(n-1)
        addiu $a0, $a0, -1
        jal   factorial
        lw    $t2, 0($sp)       # reload original n
        mul   $v0, $v0, $t2     # v0 = (n-1)! * n
        j     fact_done

fact_base:
        li    $v0, 1            # 0! = 1! = 1

fact_done:
        lw    $ra, 4($sp)
        addiu $sp, $sp, 8
        jr    $ra
