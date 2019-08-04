A multi-cycle implementation of the RISC-V "Zbc" extension `clmul`, `clmulr` and `clmulh`
instructions. 32-bit operations are executed in 4 cycles, and 64-bit operations in 8 cycles.

Module paramters:

    XLEN ......... 32 or 64

Required instruction bits:

    insn3 ........ decode *W instructions (only used when XLEN=64)
    insn12 ....... decode CLMUL/CLMULR/CLMULH instructions
    insn13 ....... decode CLMUL/CLMULR/CLMULH instructions
