# RISC-V Bitmanip (Bit Manipulation) Extension

This is the repository for the RISC-V Foundations Bitmanip Extension working group.

### NOTE: These RISC-V Bitmanip instructions are a work in progress.
These instructions and their specification may change before being accepted as a standard by the RISC-V Foundation and so it is highly likely that implementations made using this draft specification will not conform to the future standard.

## Specification 
See [bitmanip-0.90.pdf](bitmanip-0.90.pdf) for a pre-built version of the PDF spec document.
The source of the PDF specification is in the [texsrc](texsrc) directory with script (`bitmanip.sh`) to build the PDF.

## Toolchain
See the [patches](patches) directory for patches for [riscv-opcodes](https://github.com/riscv/riscv-opcodes),
[binutils](https://www.gnu.org/software/binutils/), and [riscv-isa-sim](https://github.com/riscv/riscv-isa-sim) (aka spike).
See [rvintrin.h](https://github.com/riscv/riscv-bitmanip/blob/master/cproofs/rvintrin.h) for compiler intrinsics.

## Test Suite

The [tests](tests) directory contains a test suite for the toolchain and bitmanip instructions.

## Verilog Reference
The [verilog](verilog) directory includes various Verilog reference implementations.

## cproofs
The [cproofs](cproofs) directory contains the reference C models and a few related formal proofs.

----

# Imperas riscvOVPsim Reference Simulation
Included in this repository in the directory [riscv-ovpsim](riscv-ovpsim) is a version of the Imperas [riscvOVPsim](riscv-ovpsim/README.md) simulator that includes a full implementation of the RISC-V 32 & 64 Bit ISA specification and an implementation of these new bitmanip instructions. 

To enable the new instructions, enable the B bit in the MISA register

    riscvOVPsim.exe --override riscvOVPsim/cpu/add_Extensions=B

And in the log you will see it enabled, for example:

    Info (RISCV_EXTB) extB Version(0.90) June 10 2019

This simulation is instruction accurate, is provided as a pre-compiled binary, and the source of the new instructions in the model can be found in [extB.c](Imperas/ImperasLib/source/riscv.ovpworld.org/intercept/extB/1.0/model/extB.c). If you want to make changes to the instructions, please contact the working group chair or [Imperas](mailto:info@imperas.com).

NOTE the instruction behavior and decodes will change before they become part of the RISC-V open standard ISA.

## Building the Specification PDF
In order to produce the Specification pdf run he following command

    $ make document

## Issues or more information
Please add an issue to this repository or email the normal bitmanip working group alias.

## Instruction Assembler Tests
Many assembly tests are included ([asmtests](asmtests)) that provide directed and generated tests for the new instructions. There is a simple framework to run the tests and compare them with a golden logfile.

## Building and Running the Instruction Assembler Tests
To start, you need to set up the search path to include the path to a RISCV Compiler, eg:

    $ export PATH=${PATH}:/home/tools/riscv-none-embed/bin
    
Also you need a variable to define the canonical compiler prefix, eg:

    $ export RISCV_PREFIX=riscv-none-embed-
    
And then you run the tests:

    $ make runtest
    
This process is self checking, and will report a set of passing/failing tests at the end.

## Clean Sandbox
To remove all generated files:

    $ make clean
 
## Enhancing supported instructions in the riscvOVPsim reference simulator
If you  need changes to the instructions or want to make other additions or enhancements, please contact Imperas : support@imperas.com

