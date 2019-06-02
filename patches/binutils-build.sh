#!/bin/bash
set -ex
git clone git://sourceware.org/git/binutils-gdb.git
cd binutils-gdb
git checkout 9660559
patch -p1 < ../binutils.diff
./configure --target=riscv-unkown-elf
make -j$(nproc)
