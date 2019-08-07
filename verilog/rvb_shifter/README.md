A combinatorial implementation of a RISC-V bitmanip funnel shifter, with optional
support for single-bit instructions.

Module paramters:

    XLEN ......... 32 or 64
    SBOP ......... enable single-bit instructions (1 or 0)

Required instruction bits:

    insn3 ........ *W instructions (only used when XLEN=64)
    insn14 ....... select shift direction
    insn26 ....... select funnel shift
    insn27 ....... select single-bit instruction
    insn29 ....... function select
    insn30 ....... function select
