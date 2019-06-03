#!/bin/bash
set -ex
git clone https://github.com/riscv/riscv-newlib newlib-build
cd newlib-build
git checkout 5bb8d44
./configure --prefix=/opt/riscv64b --target=riscv64-unkown-elf
PATH="/opt/riscv64b/bin:$PATH" make -j$(nproc)
PATH="/opt/riscv64b/bin:$PATH" make install
cp ../../cproofs/rvintrin.h /opt/riscv64b/riscv64-unkown-elf/include/
