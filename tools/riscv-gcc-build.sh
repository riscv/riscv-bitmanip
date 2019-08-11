#!/bin/bash
set -ex
rm -rf riscv-gcc-build
mkdir -p riscv-gcc-build
cd riscv-gcc-build
../riscv-gcc/configure --prefix=/opt/riscv64b --target=riscv64-unknown-elf --enable-languages=c --disable-libssp
make -j$(nproc)
make install
ln -fs riscv64-unknown-elf-gcc /opt/riscv64b/bin/riscv64-unknown-elf-cc
for d in /opt/riscv64b/lib/gcc/riscv64-unknown-elf/*/include/; do cp ../../cproofs/rvintrin.h $d; done
