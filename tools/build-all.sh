#!/bin/bash
set -ex
test -w /opt/riscv64b
bash checkout.sh
bash update.sh
bash riscv-binutils-build.sh
bash riscv-gcc-build.sh
bash riscv-newlib-build.sh
bash riscv-isa-sim-build.sh
bash riscv-pk-build.sh
bash riscv-binutils-demo.sh
bash riscv-gcc-demo.sh
bash riscv-isa-sim-demo.sh
