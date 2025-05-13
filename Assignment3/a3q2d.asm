.data
prompt_x:    .asciiz "Enter x: "
prompt_y:    .asciiz "Enter y: "
result_msg:  .asciiz "The result of (4x/3)*y is: "

# floating‐point constants
f_four:      .float 4.0
f_three:     .float 3.0

.text
.globl main

main:
    # --- read integer x ---
    li   $v0, 4
    la   $a0, prompt_x
    syscall

    li   $v0, 5       # read_int
    syscall
    move $t0, $v0     # t0 = x (integer)

    # --- read integer y ---
    li   $v0, 4
    la   $a0, prompt_y
    syscall

    li   $v0, 5
    syscall
    move $t1, $v0     # t1 = y (integer)

    # --- convert x to float and multiply by 4.0 ---
    mtc1 $t0, $f0        # move int x → FPU register f0 (raw bits)
    cvt.s.w $f0, $f0     # convert f0 from int to float

    l.s  $f2, f_four     # load constant 4.0 into f2
    mul.s $f0, $f0, $f2  # f0 = x * 4.0

    # --- divide by 3.0 ---
    l.s   $f2, f_three   # load constant 3.0 into f2
    div.s $f0, $f0, $f2  # f0 = (4x) / 3.0

    # --- convert integer y to float ---
    mtc1  $t1, $f4       # move int y → FPU register f4
    cvt.s.w $f4, $f4     # convert to float

    # --- multiply by y ---
    mul.s $f0, $f0, $f4  # f0 = (4x/3.0) * y

    # --- print result ---
    li   $v0, 4
    la   $a0, result_msg
    syscall

    mov.s $f12, $f0      # syscall print_float takes its arg in f12
    li   $v0, 2          # print_float
    syscall

    # --- exit ---
    li   $v0, 10
    syscall
