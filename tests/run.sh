#!/bin/bash
set -ex
gcc -o testgen -Wall -O1 -I../cproofs testgen.cc
./testgen > tests.c
/opt/riscv64b/bin/riscv64-unknown-elf-gcc -Wall  -march=rv64gb -O1 -o tests tests.c
/opt/riscv64b/bin/spike --isa=rv64gb pk tests
