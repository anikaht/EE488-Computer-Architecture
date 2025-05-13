    #####################################################
    # utils.asm
    # Q1: Mult10, ToUpper, ToLower + tes)
    #####################################################

    .data
newline:        .asciiz "\n"
test_val_mult:  .word   7
# pack 'a','b','c' into low 3 bytes: 0x00 63 62 61 → 0x00636261
test_val_upper: .word   0x00636261
# pack 'X','Y','Z' into low 3 bytes: 0x00 5A 59 58 → 0x005A5958
test_val_lower: .word   0x005A5958

    .text
    .globl main
main:
    # Test 1: Mult10(7) → print 70
    la    $t0, test_val_mult
    lw    $a0, 0($t0)
    jal   Mult10
    move  $a0, $v0
    li    $v0, 1
    syscall

    # newline
    la    $a0, newline
    li    $v0, 4
    syscall

    # Test 2: ToUpper("abc") → print "ABC"
    la    $t0, test_val_upper
    lw    $a0, 0($t0)
    jal   ToUpper
    move  $t2, $v0

    # print byte 0
    andi  $t1, $t2, 0xFF
    move  $a0, $t1
    li    $v0, 11
    syscall

    # print byte 1
    srl   $t1, $t2, 8
    andi  $t1, $t1, 0xFF
    move  $a0, $t1
    li    $v0, 11
    syscall

    # print byte 2
    srl   $t1, $t2, 16
    andi  $t1, $t1, 0xFF
    move  $a0, $t1
    li    $v0, 11
    syscall

    # newline (ASCII 10)
    li    $a0, 10
    li    $v0, 11
    syscall

    # Test 3: ToLower("XYZ") → print "xyz"
    la    $t0, test_val_lower
    lw    $a0, 0($t0)
    jal   ToLower
    move  $t2, $v0

    # print byte 0
    andi  $t1, $t2, 0xFF
    move  $a0, $t1
    li    $v0, 11
    syscall

    # print byte 1
    srl   $t1, $t2, 8
    andi  $t1, $t1, 0xFF
    move  $a0, $t1
    li    $v0, 11
    syscall

    # print byte 2
    srl   $t1, $t2, 16
    andi  $t1, $t1, 0xFF
    move  $a0, $t1
    li    $v0, 11
    syscall

    # newline
    li    $a0, 10
    li    $v0, 11
    syscall

hang:
    j     hang
    nop

# ------------------------------------------------------------
# Mult10:
#   Multiply $a0 by 10 → $v0 using only shifts & adds
#   Clobbers: $t0, $t1
# ------------------------------------------------------------
Mult10:
    sll   $t0, $a0, 3
    sll   $t1, $a0, 1
    add   $v0, $t0, $t1
    jr    $ra
    nop

# ------------------------------------------------------------
# ToUpper:
#   Lowercase→uppercase for up to three ASCII bytes in $a0 → $v0
#   Clobbers: $t0–$t4
# ------------------------------------------------------------
ToUpper:
    move  $t2, $a0
    li    $t3, 0x20

    # byte 0
    andi  $t0, $t2, 0xFF
    li    $t1, 'a'
    li    $t4, 'z'
    blt   $t0, $t1, U0skip
    bgt   $t0, $t4, U0skip
    sub   $t0, $t0, $t3
U0skip:
    andi  $t2, $t2, 0xFFFFFF00
    or    $t2, $t2, $t0

    # byte 1
    srl   $t0, $a0, 8
    andi  $t0, $t0, 0xFF
    li    $t1, 'a'
    li    $t4, 'z'
    blt   $t0, $t1, U1skip
    bgt   $t0, $t4, U1skip
    sub   $t0, $t0, $t3
U1skip:
    sll   $t0, $t0, 8
    andi  $t2, $t2, 0xFFFF00FF
    or    $t2, $t2, $t0

    # byte 2
    srl   $t0, $a0, 16
    andi  $t0, $t0, 0xFF
    li    $t1, 'a'
    li    $t4, 'z'
    blt   $t0, $t1, U2skip
    bgt   $t0, $t4, U2skip
    sub   $t0, $t0, $t3
U2skip:
    sll   $t0, $t0, 16
    andi  $t2, $t2, 0xFF00FFFF
    or    $t2, $t2, $t0

    move  $v0, $t2
    jr    $ra
    nop

# ------------------------------------------------------------
# ToLower:
#   Uppercase→lowercase for up to three ASCII bytes in $a0 → $v0
#   Clobbers: $t0–$t4
# ------------------------------------------------------------
ToLower:
    move  $t2, $a0
    li    $t3, 0x20

    # byte 0
    andi  $t0, $t2, 0xFF
    li    $t1, 'A'
    li    $t4, 'Z'
    blt   $t0, $t1, L0skip
    bgt   $t0, $t4, L0skip
    add   $t0, $t0, $t3
L0skip:
    andi  $t2, $t2, 0xFFFFFF00
    or    $t2, $t2, $t0

    # byte 1
    srl   $t0, $a0, 8
    andi  $t0, $t0, 0xFF
    li    $t1, 'A'
    li    $t4, 'Z'
    blt   $t0, $t1, L1skip
    bgt   $t0, $t4, L1skip
    add   $t0, $t0, $t3
L1skip:
    sll   $t0, $t0, 8
    andi  $t2, $t2, 0xFFFF00FF
    or    $t2, $t2, $t0

    # byte 2
    srl   $t0, $a0, 16
    andi  $t0, $t0, 0xFF
    li    $t1, 'A'
    li    $t4, 'Z'
    blt   $t0, $t1, L2skip
    bgt   $t0, $t4, L2skip
    add   $t0, $t0, $t3
L2skip:
    sll   $t0, $t0, 16
    andi  $t2, $t2, 0xFF00FFFF
    or    $t2, $t2, $t0

    move  $v0, $t2
    jr    $ra
    nop
