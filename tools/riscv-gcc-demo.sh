#!/bin/bash
set -ex
/opt/riscv64b/bin/riscv64-unknown-elf-gcc -O3 -c -o riscv-gcc-demo.o -march=rv64ib -mabi=lp64 -ffreestanding riscv-gcc-demo.c
/opt/riscv64b/bin/riscv64-unknown-elf-objdump -d riscv-gcc-demo.o
