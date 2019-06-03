#!/bin/bash
set -ex
/opt/riscv64b/bin/riscv64-unkown-elf-gcc -Os -march=rv64gb -c xorshift32.c
/opt/riscv64b/bin/riscv64-unkown-elf-objdump -d xorshift32.o
