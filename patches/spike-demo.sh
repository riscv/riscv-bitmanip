#!/bin/bash
set -ex
/opt/riscv64b/bin/riscv64-unknown-elf-gcc -o spike-demo spike-demo.c
/opt/riscv64b/bin/spike pk spike-demo
rm spike-demo
