#!/bin/bash
set -ex
/opt/riscv64b/bin/riscv64-unkown-elf-gcc -O1 -c -o gcc-demo.o -march=rv64ib -mabi=lp64 gcc-demo.c
/opt/riscv64b/bin/riscv64-unkown-elf-objdump -d gcc-demo.o
rm gcc-demo.o
