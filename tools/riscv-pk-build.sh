#!/bin/bash
set -ex
rm -rf riscv-pk-build
mkdir -p riscv-pk-build
cd riscv-pk-build
export PATH="/opt/riscv64b/bin:$PATH"
../riscv-pk/configure --prefix=/opt/riscv64b --host=riscv64-unknown-elf
make -j$(nproc)
make install
