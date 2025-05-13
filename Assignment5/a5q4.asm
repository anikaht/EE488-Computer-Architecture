        .data
hex0:    .asciiz "0x0"
hex1:    .asciiz "0x1"
hex2:    .asciiz "0x2"
hex3:    .asciiz "0x3"
hex4:    .asciiz "0x4"
hex5:    .asciiz "0x5"
hex6:    .asciiz "0x6"
hex7:    .asciiz "0x7"
hex8:    .asciiz "0x8"
hex9:    .asciiz "0x9"
hexa:    .asciiz "0xa"
hexb:    .asciiz "0xb"
hexc:    .asciiz "0xc"
hexd:    .asciiz "0xd"
hexe:    .asciiz "0xe"
hexf:    .asciiz "0xf"

table:   .word hex0,hex1,hex2,hex3,hex4,hex5,hex6,hex7
         .word hex8,hex9,hexa,hexb,hexc,hexd,hexe,hexf

newline: .asciiz "\n"
prompt:  .asciiz "Enter a value 0-15: "

        .text
        .globl main
main:
        # --- prompt for digit ---
        li   $v0, 4
        la   $a0, prompt
        syscall

        # --- read integer into t0 ---
        li   $v0, 5
        syscall
        move $t0, $v0          # t0 = user input (0–15)

        # --- compute address: table + t0*4 ---
        la   $t1, table
        sll  $t2, $t0, 2       # byte offset = input*4
        add  $t1, $t1, $t2

        # --- load the address of the right string into a0 ---
        lw   $a0, 0($t1)

        # --- print the hex string ---
        li   $v0, 4
        syscall

        # --- print newline ---
        li   $v0, 4
        la   $a0, newline
        syscall

        # --- exit ---
        li   $v0, 10
        syscall
