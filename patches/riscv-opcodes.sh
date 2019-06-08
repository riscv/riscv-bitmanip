#!/bin/bash
set -ex
git clone https://github.com/riscv/riscv-opcodes riscv-opcodes
cd riscv-opcodes
cat opcodes opcodes-rvc-pseudo opcodes-rvc opcodes-custom opcodes-rvv | python3 ./parse-opcodes -c > encoding_old.h
patch -p1 < ../riscv-opcodes.diff
cat opcodes opcodes-rvc-pseudo opcodes-rvc opcodes-custom opcodes-rvv | python3 ./parse-opcodes -c > encoding_new.h
