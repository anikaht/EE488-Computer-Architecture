        .data
prompt:     .asciiz "Enter max Fibonacci index: "
space:      .asciiz " "
newline:    .asciiz "\n"

        .text
        .globl main
main:
        # --- Prompt & read n into $s0 ---
        li   $v0,4
        la   $a0,prompt
        syscall
        li   $v0,5
        syscall
        move $s0,$v0        # length = n

        # --- Allocate n words on stack for Fib[0..n-1] ---
        sll  $t0,$s0,2      # t0 = n*4
        subu $sp,$sp,$t0
        move $s1,$sp        # s1 = base of Fib[]

        # --- Base cases ---
        sw   $zero,0($s1)   # Fib[0] = 0
        li   $t1,1
        li   $t2,2
        blt  $s0,$t2,skip1  # if n<2 skip Fib[1]
        sw   $t1,4($s1)     # Fib[1] = 1
skip1:

        # --- Fill Fib[2..n-1] ---
        li   $t3,2          # i = 2
fill_loop:
        bge  $t3,$s0,done_fill
        sll  $t4,$t3,2
        add  $t5,$s1,$t4    # &Fib[i]

        # load Fib[i-1]
        addi $t6,$t3,-1
        sll  $t6,$t6,2
        add  $t6,$s1,$t6
        lw   $t7,0($t6)

        # load Fib[i-2]
        addi $t8,$t3,-2
        sll  $t8,$t8,2
        add  $t8,$s1,$t8
        lw   $t9,0($t8)

        add  $t7,$t7,$t9     # Fib[i] = Fib[i-1] + Fib[i-2]
        sw   $t7,0($t5)

        addi $t3,$t3,1
        j    fill_loop
done_fill:

        # --- Print the array ---
        move $a0,$s1        # base pointer
        move $a1,$s0        # length
        jal  PrintIntArray

        # --- Restore stack & exit ---
        move $sp,$s1
        li   $v0,10
        syscall

#-------------------------------------------------------
# PrintIntArray: prints each element of the int array on one line.
#  In:  $a0 = base address, $a1 = length
PrintIntArray:
        addiu $sp,$sp,-12
        sw    $ra,8($sp)
        sw    $s0,4($sp)
        sw    $s1,0($sp)

        move  $s0,$a1       # counter = length
        move  $s2,$a0       # save base pointer in s2
        li    $t0,0         # index i = 0

print_loop:
        beq   $t0,$s0,end_print
        sll   $t1,$t0,2
        add   $t2,$s2,$t1   # t2 = address of Fib[i]
        lw    $a0,0($t2)    # load Fib[i]
        li    $v0,1
        syscall            # print integer

        addi  $t0,$t0,1
        blt   $t0,$s0,do_space
        j     print_loop

do_space:
        li    $v0,4
        la    $a0,space
        syscall            # print a space
        j     print_loop

end_print:
        li    $v0,4
        la    $a0,newline
        syscall            # final newline

        lw    $s1,0($sp)
        lw    $s0,4($sp)
        lw    $ra,8($sp)
        addiu $sp,$sp,12
        jr    $ra
