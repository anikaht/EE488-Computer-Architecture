        .data
prompt1: .asciiz "Enter first number: "
prompt2: .asciiz "Enter second number: "
prompt3: .asciiz "Enter third number: "
result:  .asciiz "Median is: "
newline: .asciiz "\n"

        .text
        .globl main
main:
        # --- Read a, b, c into $s0, $s1, $s2 ---
        li   $v0, 4
        la   $a0, prompt1
        syscall
        li   $v0, 5
        syscall
        move $s0, $v0         # s0 = a

        li   $v0, 4
        la   $a0, prompt2
        syscall
        li   $v0, 5
        syscall
        move $s1, $v0         # s1 = b

        li   $v0, 4
        la   $a0, prompt3
        syscall
        li   $v0, 5
        syscall
        move $s2, $v0         # s2 = c

        # --- Compute sum = a + b + c in $t4 ---
        add  $t4, $s0, $s1
        add  $t4, $t4, $s2

        # --- Find max(a,b) into $t0 ---
        slt  $t1, $s0, $s1     # t1 = 1 if a < b
        bne  $t1, $zero, L1    # if a<b, go to L1 (b is larger)
        move $t0, $s0          # else a ≥ b → t0 = a
        j    L2
L1:     move $t0, $s1          # t0 = b
L2:
        # t0 now holds max(a,b)
        slt  $t1, $t0, $s2     # t1 = 1 if max(a,b) < c
        bne  $t1, $zero, L3    # if so, c is the overall max
        # else max(a,b) ≥ c
        # t0 already max(a,b)
        j    GotMax
L3:     move $t0, $s2          # c is the overall max
GotMax:
        # --- Now t0 = M = max(a,b,c) ---

        # --- Find min(a,b) into $t1 ---
        slt  $t2, $s1, $s0     # t2 = 1 if b < a
        bne  $t2, $zero, L4    # if b<a, go to L4
        move $t1, $s0          # else a ≤ b → t1 = a
        j    L5
L4:     move $t1, $s1          # t1 = b
L5:
        # t1 now holds min(a,b)
        slt  $t2, $s2, $t1     # t2 = 1 if c < min(a,b)
        bne  $t2, $zero, L6    # if so, c is the overall min
        # else min(a,b) ≤ c
        j    GotMin
L6:     move $t1, $s2          # c is the overall min
GotMin:
        # --- Now t1 = m = min(a,b,c) ---

        # --- median = sum − max − min → $t2 ---
        sub  $t2, $t4, $t0     # t2 = sum - max
        sub  $t2, $t2, $t1     # t2 = (a+b+c) - max - min

        # --- Print ---
        li   $v0, 4
        la   $a0, result
        syscall

        move $a0, $t2
        li   $v0, 1
        syscall

        li   $v0, 4
        la   $a0, newline
        syscall

        li   $v0, 10
        syscall
