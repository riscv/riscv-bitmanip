#!/bin/bash
set -ex
/opt/riscv64b/bin/riscv64-unknown-elf-gcc -o riscv-isa-sim-demo riscv-isa-sim-demo.c
/opt/riscv64b/bin/spike pk riscv-isa-sim-demo
