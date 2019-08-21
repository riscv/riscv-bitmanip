A simple wrapper over the other `rvb_*` cores, that provides all
RISC-V bitmanip operations.

Module paramters:

    XLEN ....... 32 or 64

Required instruction bits:

    insn[31:0] ... entire instruction word

Instruction bits encoding for registers are ignored. This core
decodes immediates in the instruction word and ignores the
`din_rs2` input signal for immediate instructions.
