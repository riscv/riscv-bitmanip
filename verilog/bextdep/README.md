A fast and efficient pipelined implementation of the RISC-V Zbe `bext` and `bdep`
instructions, based on the implementations from https://github.com/cliffordwolf/bextdep.

Optionally this core also implements the GREV instruction.

Module paramters:

    XLEN ......... 32 or 64
    GREV ......... GREV support (1=enable, 0=disable)
    FFS .......... Number of pipeline flip-flops (0..3)

Required instruction bits:

    insn3 ........ decode *W instructions (only used when XLEN=64)
    insn13 ....... decode GREV instructions (only used when GREV=1)
    insn14 ....... distinguish bext and bdep
