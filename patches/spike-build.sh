#!/bin/bash
set -ex
git clone https://github.com/riscv/riscv-isa-sim spike-build
cd spike-build
git checkout 8ac902f
patch -p1 < ../spike.diff
./configure --prefix=/opt/riscv64b
make -j$(nproc)
make install
