# mult4.py

def mult4_shiftadd(x: int, y: int) -> int:
    """
    4-bit unsigned shift-add multiplier (Version 1).
    Implements:
      for i in 0..3:
        if y[i] == 1: product += (x << i)
      shift y right each cycle.
    Returns 8-bit product of x * y (0..15 × 0..15 → 0..255).
    """
    mcand = x & 0xF     # 4-bit multiplicand
    mult  = y & 0xF     # 4-bit multiplier
    prod  = 0
    for _ in range(4):
        if mult & 1:
            prod += mcand
        mcand <<= 1
        mult  >>= 1
    return prod & 0xFF  # mask to 8 bits


def mult4_booth(x: int, y: int) -> int:
    """
    4-bit signed Booth’s algorithm multiplier.
    x, y are treated as signed 4-bit (–8..+7). Returns signed 8-bit Python int.
    
    Algorithm (per Booth’s rules):
      - Examine (Q0, Q−1):
        01 → add  M into A
        10 → sub  M from A
        00 or 11 → no op
      - Arithmetic right shift of [A(5b), Q(4b), Q−1]
      - Repeat 4 times.
    """
    def to_u4(v): return v & 0xF
    def to_s4(u): return u - 0x10 if (u & 0x8) else u

    M   = to_s4(to_u4(x))    # signed multiplicand
    Q   = to_u4(y)           # unsigned bits of multiplier
    A   = 0
    Q_1 = 0

    for _ in range(4):
        q0 = Q & 1
        # Booth step :contentReference[oaicite:4]{index=4}:contentReference[oaicite:5]{index=5}
        if   q0 == 1 and Q_1 == 0:
            A = (A - M) & 0x1F
        elif q0 == 0 and Q_1 == 1:
            A = (A + M) & 0x1F

        # pack [A(5b), Q(4b), Q−1] into 10 bits and arithmetic shift right by 1
        combo = (A << 5) | (Q << 1) | Q_1
        msb   = (combo >> 9) & 1
        combo = (combo >> 1) | (msb << 9)

        A   = (combo >> 5) & 0x1F
        Q   = (combo >> 1) & 0xF
        Q_1 = combo & 1

    # combine and sign-extend to Python int
    result = ((A & 0x1F) << 4) | Q
    result &= 0xFF
    if result & 0x80:
        result -= 0x100
    return result


if __name__ == "__main__":
    # Demo of both multipliers
    print("Unsigned shift-add (0..15 × 0..15):")
    for a, b in [(3,6), (7,7), (15,15)]:
        print(f"  {a:2d} × {b:2d} = {mult4_shiftadd(a,b):3d}")

    print("\nBooth’s algorithm (–8..+7 × –8..+7):")
    for a, b in [(-7,3), (7,-3), (-8,7), (-8,-8)]:
        print(f"  {a:3d} × {b:3d} = {mult4_booth(a,b):4d}")
