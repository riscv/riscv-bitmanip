Implementations of the bit count instructions `clz`, `ctz`, and `pcnt`.
Optionally also `bmatflip`.

Module paramters:

    XLEN ....... 32 or 64
    BMAT ....... 0 or 1

Required instruction bits:

    insn3  ....... only for XLEN=64
    insn20 ....... decode instruction
    insn21 ....... decode instruction
