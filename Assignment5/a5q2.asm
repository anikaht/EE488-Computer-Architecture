        .data
prompt:     .asciiz "Enter n: "
result_msg: .asciiz "Square is: "
newline:    .asciiz "\n"

        .text
        .globl main
main:
        # --- Prompt & read n into $v0 ---
        li   $v0, 4
        la   $a0, prompt
        syscall

        li   $v0, 5
        syscall
        move $s1, $v0       # $s1 = original n (saved)
        move $a0, $v0       # $a0 = countdown = n

        # --- Compute n*n via recursion; result in $v0 ---
        jal  square_rec

        # --- Preserve the true result before printing the label ---
        move $t0, $v0       # t0 = n*n

        # --- Print "Square is: " ---
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


# square_rec:
#   in:  $a0 = how many copies of n to add
#        $s1 = original n (never changed)
#  out:  $v0 = original_n * (initial_count)
square_rec:
        addiu $sp, $sp, -4
        sw    $ra, 0($sp)

        blez  $a0, base_zero    # if count ≤ 0 → square = 0
        addiu $a0, $a0, -1      # decrement count
        jal   square_rec        # recurse
        addu  $v0, $v0, $s1     # add one copy of n
        j     unwind

base_zero:
        li    $v0, 0            # base case: 0 copies → 0

unwind:
        lw    $ra, 0($sp)
        addiu $sp, $sp, 4
        jr    $ra
