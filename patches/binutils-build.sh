#!/bin/bash
set -ex
git clone --depth=1000 git://sourceware.org/git/binutils-gdb.git binutils-build
cd binutils-build
git checkout 9660559
patch -p1 < ../binutils.diff
./configure --prefix=/opt/riscv64b --target=riscv64-unknown-elf
make -j$(nproc)
make install
