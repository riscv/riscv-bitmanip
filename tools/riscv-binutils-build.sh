#!/bin/bash
set -ex
rm -rf riscv-binutils-build
mkdir -p riscv-binutils-build
cd riscv-binutils-build
../riscv-binutils/configure --prefix=/opt/riscv64b --target=riscv64-unknown-elf
make -j$(nproc)
make install
