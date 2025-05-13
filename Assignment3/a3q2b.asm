.data
prompt_x:   .asciiz "Enter x: "
prompt_y:   .asciiz "Enter y: "
prompt_z:   .asciiz "Enter z: "
result_msg: .asciiz "The result of ((5x + 3y + z)/2)*3 is: "

.text
.globl main

main:
    # Prompt for x, y, z (same as part a)
      # Prompt for x
    li $v0, 4
    la $a0, prompt_x
    syscall
    li $v0, 5
    syscall
    move $t0, $v0  # $t0 = x

    # Prompt for y
    li $v0, 4
    la $a0, prompt_y
    syscall
    li $v0, 5
    syscall
    move $t1, $v0  # $t1 = y

    # Prompt for z
    li $v0, 4
    la $a0, prompt_z
    syscall
    li $v0, 5
    syscall
    move $t2, $v0  # $t2 = z
    
    # Calculate 5x + 3y + z
    li $t3, 5
    mul $t4, $t0, $t3  # $t4 = 5x
    li $t3, 3
    mul $t5, $t1, $t3  # $t5 = 3y
    add $t6, $t4, $t5  # $t6 = 5x + 3y
    add $t7, $t6, $t2  # $t7 = 5x + 3y + z

# 1) Move integer sum into FPU, convert to single-precision float
    mtc1   $t7, $f0         # move int t7 → float reg f0 (bit-wise)
    cvt.s.w $f0, $f0        # convert from 32-bit integer to float in f0

    # 2) Divide by 2.0 in floating point
    l.s    $f2, two         # load 2.0 into f2
    div.s  $f0, $f0, $f2    # f0 = f0 / f2

    # 3) Multiply by 3.0 in floating point
    l.s    $f2, three       # load 3.0 into f2
    mul.s  $f0, $f0, $f2    # f0 = f0 * f2

    # 4) Print the result as a float
    li     $v0, 4
    la     $a0, result_msg
    syscall                 # print the string
    mov.s  $f12, $f0        # syscall print-float expects argument in f12
    li     $v0, 2
    syscall                 # print the float in f12

    # 5) Exit
    li     $v0, 10
    syscall

.data
two:    .float 2.0
three:  .float 3.0

