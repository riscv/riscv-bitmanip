#!/bin/bash
set -ex
rm -rf riscv-isa-sim-build
mkdir -p riscv-isa-sim-build
cd riscv-isa-sim-build
../riscv-isa-sim/configure --prefix=/opt/riscv64b
make -j$(nproc)
make install
