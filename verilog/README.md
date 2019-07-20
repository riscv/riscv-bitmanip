This directory contains Verilog reference implementations of B-extension
instructions. They all follow the same interface:

    // control signals
    input             clock,          // positive edge clock
    input             reset,          // synchronous reset

    // data input
    input             din_valid,      // input is valid
    output            din_ready,      // core accepts input
    input  [XLEN-1:0] din_rs1,        // value of 1st argument
    input  [XLEN-1:0] din_rs2,        // value of 2nd argument
    input  [XLEN-1:0] din_rs3,        // value of 3rd argument
    input             din_insnNN,     // value of instruction bit NN

    // data output
    output            dout_valid,     // output is valid
    output [XLEN-1:0] dout_rd         // output value

Some of the cores are combinatorial. These cores simply ignore
`clock` and `reset`, drive `din_ready` constant high, and connect
`din_valid` to `dout_valid`.
