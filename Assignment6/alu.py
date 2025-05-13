def alu(opcode: str, A: int, B: int) -> str:
    """
    8-bit ALU.
    opcode: 4-bit string, e.g. '0000'
    A, B: integer inputs (any range)
    Returns: 8-bit binary string of the result.
    """
    # --- convert inputs to 8-bit values ---
    a = int(format(A & 0xFF, '08b'), 2)
    b = int(format(B & 0xFF, '08b'), 2)

    # --- decode opcode and compute out (may exceed 8 bits) ---
    if   opcode == '0000':  # add
        out = a + b
    elif opcode == '0001':  # sub
        out = a - b
    elif opcode == '0010':  # mul
        out = a * b
    elif opcode == '0011':  # div (integer)
        out = a // b if b != 0 else 0
    elif opcode == '0100':  # shift left logical
        out = (a << 1)
    elif opcode == '0101':  # shift right logical
        out = (a >> 1)
    elif opcode == '0110':  # rotate left by 1
        out = ((a << 1) & 0xFF) | ((a >> 7) & 0x01)
    elif opcode == '0111':  # rotate right by 1
        out = ((a >> 1) & 0x7F) | ((a & 0x01) << 7)
    elif opcode == '1000':  # and
        out = a & b
    elif opcode == '1001':  # or
        out = a | b
    elif opcode == '1010':  # xor
        out = a ^ b
    elif opcode == '1011':  # nor = ¬(A ∨ B)
        out = ~(a | b)
    elif opcode == '1100':  # nand = ¬(A ∧ B)
        out = ~(a & b)
    elif opcode == '1101':  # xnor = ¬(A ⊕ B)
        out = ~(a ^ b)
    elif opcode == '1110':  # A > B ?
        out = 1 if a > b else 0
    elif opcode == '1111':  # A == B ?
        out = 1 if a == b else 0
    else:
        raise ValueError(f"Unknown opcode '{opcode}'")

    # --- mask result to 8 bits ---
    out &= 0xFF

    # --- return as 8-bit binary string ---
    return format(out, '08b')

if __name__ == "__main__":
    # test the specific cases you already have
    cases = [
        ('0000', 15, 5),
        ('0001', 15, 5),
        ('0110', 0x85, 0),
        ('1110', 7, 3),
        ('1010', 0b10101010, 0b01010101),
    ]
    for op, A, B in cases:
        out_bin = alu(op, A, B)
        out_int = int(out_bin, 2)
        print(f"{op} | A={A:#04x} B={B:#04x} → int {out_int}, bin {out_bin}")

    print("\n-- Exhaustive opcode test --")
    for op in [f"{i:04b}" for i in range(16)]:
        # pick a few sample values for A and B
        for A, B in [(0,0), (1,1), (0xFF,0xFF), (0xAA,0x55)]:
            out = alu(op, A, B)
            print(f"{op} | A={A:#04x} B={B:#04x} → {out}")
