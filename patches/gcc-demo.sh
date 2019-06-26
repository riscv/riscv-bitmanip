#!/bin/bash
set -ex
/opt/riscv64b/bin/riscv64-unknown-elf-gcc -O3 -c -o gcc-demo.o -march=rv64ib -mabi=lp64 -ffreestanding gcc-demo.c
/opt/riscv64b/bin/riscv64-unknown-elf-objdump -d gcc-demo.o
rm gcc-demo.o
