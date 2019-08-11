#!/bin/bash
set -ex
rm -rf riscv-newlib-build
mkdir -p riscv-newlib-build
cd riscv-newlib-build
export PATH="/opt/riscv64b/bin:$PATH"
../riscv-newlib/configure --prefix=/opt/riscv64b --target=riscv64-unknown-elf
make -j$(nproc)
make install
