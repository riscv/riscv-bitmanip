#!/bin/bash

set -ex
export RISCV=/
export MAKEFLAGS="-j$(nproc)"

if [ ! -d rocket-chip ]; then
	git clone https://github.com/chipsalliance/rocket-chip.git
	cd rocket-chip
	git checkout b19afe8
	git submodule update --init
	patch -p1 < ../config.diff
	cd ..
fi

cd rocket-chip/vsim

make CONFIG=MulDivConfig32 verilog
sed '/^module MulDiv/,/^endmodule/ { s/module MulDiv/module MulDiv32 /; p; }; d;' ./generated-src/freechips.rocketchip.system.MulDivConfig32.v > ../../muldiv32.v

make CONFIG=MulDivConfig64 verilog
sed '/^module MulDiv/,/^endmodule/ { s/module MulDiv/module MulDiv64 /; p; }; d;' ./generated-src/freechips.rocketchip.system.MulDivConfig64.v > ../../muldiv64.v
