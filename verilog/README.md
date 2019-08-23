This directory contains Verilog reference implementations of B-extension
instructions. They all provide the same interface:

    // module parameters
    parameter integer XLEN = 64;      // 32 or 64

    // control signals
    input             clock;          // positive edge clock
    input             reset;          // synchronous reset

    // data input
    input             din_valid;      // input is valid
    output            din_ready;      // core accepts input
    input  [XLEN-1:0] din_rs1;        // value of 1st argument
    input  [XLEN-1:0] din_rs2;        // value of 2nd argument
    input  [XLEN-1:0] din_rs3;        // value of 3rd argument
    input             din_insnNN;     // value of instruction bit NN

    // data output
    output            dout_valid;     // output is valid
    input             dout_ready;     // accept output
    output [XLEN-1:0] dout_rd;        // output value

Some of the cores are combinatorial. Those cores simply ignore
`clock` and `reset`, connect `dout_ready` to `din_ready`, and connect
`din_valid` to `dout_valid`.

Some of the cores are simple pipelines. Those cores drive
`din_ready` with `!dout_valid || dout_ready`.

The cores in this directory (`rvb_*/`) implement the following instructions.
When configured with XLEN=64 they also implement the `*W` versions of these
instructions, if the exist in the ISA. When configured with XLEN=32 they all
ignore the `din_insn3` input.

These cores can decode immediate-instructions, but the immediate values are
expected to be present in `din_rs2` and are not extracted by the core from
the instruction word.

The behavior of these cores when the instruction at the `din_insn*` inputs
is not one of the instructions implemented by the core, is undefined.

|     Core     | Instructions (optional instructions in parentheses)                                 |
|:-------------|:------------------------------------------------------------------------------|
| rvb_bextdep  | bext bdep (grev gorc shfl unshfl)                                             |
| rvb_clmul    | clmul clmulr clmulh                                                           |
| rvb_shifter  | sll srl sra slo sro rol ror fsl fsr slliu.w (sbset sbclr sbinv sbext bfp)     |
| rvb_bmatxor  | bmatxor bmator                                                                |
| rvb_simple   | min max minu maxu andn orn xnor pack cmix cmov addiwu addwu subwu adduw subuw |
| rvb_bitcnt   | clz ctz pcnt (bmatflip)                                                       |
| rvb_crc      | crc32.[bhwd] crc32c.[bhwd]                                                    |
