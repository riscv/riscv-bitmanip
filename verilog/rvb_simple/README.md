Implementations of all the "simple" instructions. A real processor
implementation probably wants wo provide those through their own ALU
instead of using an external core. Thus we only provide this core as
reference.

Module parameters:

    XLEN ....... 32 or 64

Required instruction bits:

    insn3  ....... only for XLEN=64
    insn5  ....... only for XLEN=64
    insn12 ....... decode instruction
    insn13 ....... decode instruction
    insn14 ....... decode instruction
    insn25 ....... decode instruction
    insn26 ....... decode instruction
    insn27 ....... decode instruction
    insn30 ....... decode instruction
