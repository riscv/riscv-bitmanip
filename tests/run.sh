#!/bin/bash
set -ex
gcc -o testgen -Wall -O1 -I../cproofs testgen.cc
./testgen > tests.c
/opt/riscv64b/bin/riscv64-unknown-elf-gcc -Wall  -march=rv64gb -Os -o tests tests.c
/opt/riscv64b/bin/spike --isa=RV64GCB pk tests
