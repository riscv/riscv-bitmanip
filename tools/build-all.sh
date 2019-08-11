#!/bin/bash
set -ex
test -w /opt/riscv64b
bash checkout.sh
bash riscv-binutils-build.sh
bash riscv-gcc-build.sh
bash riscv-newlib-build.sh
bash riscv-isa-sim-build.sh
bash riscv-pk-build.sh
