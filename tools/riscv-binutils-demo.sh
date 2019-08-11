#!/bin/bash
set -ex
/opt/riscv64b/bin/riscv64-unknown-elf-as -o riscv-binutils-demo.o -march=rv64ib riscv-binutils-demo.s
/opt/riscv64b/bin/riscv64-unknown-elf-objdump -M numeric -d riscv-binutils-demo.o
