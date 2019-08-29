A fast and efficient pipelined implementation of the RISC-V "Zbe" extension `bext` and `bdep`
instructions, based on the implementations from https://github.com/cliffordwolf/bextdep.

Optionally this core also implements the `gorc`, `grev`, `shfl`, and `unshfl` instruction.

Module parameters:

    XLEN ......... 32 or 64
    GREV ......... GREV support (1=enable, 0=disable)
    SHFL ......... [UN]SHFL support (1=enable, 0=disable)
    FFS .......... Number of pipeline flip-flops (0..3)

Required instruction bits:

    insn3 ........ decode *W instructions (only used when XLEN=64)
    insn13 ....... decode SHFL/UNSHFL (only used when SHFL=1)
    insn14 ....... distinguish bext/bdep and shfl/unshfl
    insn29 ....... decode GORC/GREV (only used when GREV=1)
    insn30 ....... decode GORC/GREV (only used when GREV=1)
