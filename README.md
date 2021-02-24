# RISC-V Bitmanip (Bit Manipulation) Extension

This is the repository for the RISC-V Foundations Bitmanip Extension working group.

**NOTE: These RISC-V Bitmanip instructions are a work in progress.**
These instructions and their specification may change before being accepted as a standard by the RISC-V Foundation and so it is highly likely that implementations made using this draft specification will not conform to the future standard.

## Specification 
See [bitmanip-0.93.pdf](bitmanip-0.93.pdf) for a pre-built version of the PDF spec document.
The source of the PDF specification is in the [texsrc](texsrc) directory with a script (`bitmanip.sh`) to build the PDF.

## Toolchain
See the [tools](tools) directory for build scripts for a compiler toolchain with RISC-V Bitmanip support.
See [rvintrin.h](https://github.com/riscv/riscv-bitmanip/blob/master/cproofs/rvintrin.h) for compiler intrinsics.

## Test Suite
The [tests](tests) directory contains a test suite for the toolchain and bitmanip instructions.

## Verilog Reference
The [verilog](verilog) directory includes various Verilog reference implementations.

## cproofs
The [cproofs](cproofs) directory contains the reference C models and a few related formal proofs.

----

# Imperas riscvOVPsimPlus Free Reference Simulation

**riscvOVPsimPlus** is an extension to **riscvOVPsim** created by Imperas in 2018 to assist in the development of compliance tests and to provide a free, high quality, configurable reference simulator of the RISC-V specifications.

It is developed by Imperas and is kept up to date as the Bit Manip extensions changes and moves to standardization.

It was originally provided in this repository as a convenience. It has now evolved and has been enhanced and moved to its own repository.

There are now two flavors:  _riscvOVPsim_  from [github.com/riscv-ovpsim](https://github.com/riscv-ovpsim/imperas-riscv-tests) which supports standard and ratified extensions and is useful for running compliance tests and generating the required signatures, and  _riscvOVPsimPlus_  from [ovpworld.org/riscv-ovpsim-plus](https://www.ovpworld.org/riscv-ovpsim-plus) which supports additional features and all extension, including those not yet ratified, is used for test development and verification.

Please contact info@ovpworld.org or info@imperas.com for more information.

For details on riscvOVPsim look here: [github.com/riscv-ovpsim](https://github.com/riscv-ovpsim/imperas-riscv-tests) and here: [riscv-ovpsim/doc/riscvOVPsim_User_Guide.pdf](https://github.com/riscv-ovpsim/imperas-riscv-tests/blob/master/riscv-ovpsim/doc/riscvOVPsim_User_Guide.pdf).

For details on riscvOVPsimPlus look here: [riscv-ovpsim/doc/riscvOVPsimPlus_User_Guide.pdf](https://github.com/riscv-ovpsim/imperas-riscv-tests/blob/master/riscv-ovpsim-plus/doc/riscvOVPsimPlus_User_Guide.pdf).

To enable the bit manip extension/instructions, enable the B bit in the MISA register

    riscvOVPsimPlus.exe --override riscvOVPsim/cpu/add_Extensions=B

And in the log you will see it enabled, for example:

    Info (Bit Manipulation) extB Version(0.94 Draft) 

This simulation is instruction accurate, is provided as a pre-compiled binary, and the source of the new instructions in the model can be found in the riscvOVPsim downloads. If you want to make changes to the instructions, please contact the working group chair or [Imperas](mailto:info@imperas.com).

NOTE the instruction behavior and decodes will change before they become part of the RISC-V open-standard ISA.

## Building the Specification PDF
In order to produce the Specification pdf run the following command

    $ make document

The following command installs the prerequisites for building the specification PDF on Ubuntu:

    $ sudo apt install clang texlive-latex-base texlive-latex-extra texlive-luatex make

## Issues or more information
Please add an issue to this repository or email the normal bitmanip working group alias.

## Instruction Assembler Tests
Many assembly tests are included ([asmtests](asmtests)) that provide directed and generated tests for the new instructions. There is a simple framework to run the tests and compare them with a golden logfile.

## Building and Running the Instruction Assembler Tests
To start, you need to set up the search path to include the path to a RISCV Compiler, eg:

    $ export PATH=${PATH}:/home/tools/riscv-none-embed/bin
    
Also, you need a variable to define the canonical compiler prefix, eg:

    $ export RISCV_PREFIX=riscv-none-embed-
    
And then you run the tests:

    $ make runtest
    
This process is self-checking, and will report a set of passing/failing tests at the end.

## Clean Sandbox
To remove all generated files:

    $ make clean
 
## Enhancing supported instructions in the riscvOVPsim reference simulator
If you  need changes to the instructions or want to make other additions or enhancements, please contact Imperas : support@imperas.com

