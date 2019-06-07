#!/bin/bash
set -ex

git clone https://github.com/riscv/riscv-pk riscv-pk-build
cd riscv-pk-build
mkdir build
cd build
PATH="/opt/riscv64b/bin:$PATH" CC=riscv64-unknown-elf-cc ../configure --prefix=/opt/riscv64b --host=riscv64-unknown-elf
PATH="/opt/riscv64b/bin:$PATH" make -j$(nproc)
PATH="/opt/riscv64b/bin:$PATH" make install
cd ../..

git clone https://github.com/riscv/riscv-isa-sim spike-build
cd spike-build
git checkout 8ac902f
patch -p1 < ../spike.diff
git add -N riscv/insns/*
mkdir build
cd build
../configure --prefix=/opt/riscv64b
make -j$(nproc)
make install
cd ../..
