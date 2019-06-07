#!/bin/bash
set -ex
/opt/riscv64b/bin/riscv64-unknown-elf-as -o binutils-demo.o -march=rv64ib binutils-demo.s
/opt/riscv64b/bin/riscv64-unknown-elf-objdump -M numeric -d binutils-demo.o
rm binutils-demo.o
