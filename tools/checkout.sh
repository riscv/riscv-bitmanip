#!/bin/bash

set -ex

if [ ! -d riscv-gcc ]; then
	rm -rf riscv-gcc-new
	git clone git@github.com:riscv/riscv-gcc.git riscv-gcc-new
	cd riscv-gcc-new
	git checkout riscv-bitmanip
	git remote add upstream git://gcc.gnu.org/git/gcc.git
	git fetch upstream
	cd ..
	mv riscv-gcc-new riscv-gcc
fi

if [ ! -d riscv-binutils ]; then
	rm -rf riscv-binutils-new
	git clone git@github.com:riscv/riscv-binutils-gdb.git riscv-binutils-new
	cd riscv-binutils-new
	git checkout riscv-bitmanip
	git remote add upstream git://sourceware.org/git/binutils-gdb.git
	git fetch upstream
	cd ..
	mv riscv-binutils-new riscv-binutils
fi

if [ ! -d riscv-isa-sim ]; then
	rm -rf riscv-isa-sim-new
	git clone git@github.com:riscv/riscv-isa-sim.git riscv-isa-sim-new
	cd riscv-isa-sim-new
	git checkout riscv-bitmanip
	cd ..
	mv riscv-isa-sim-new riscv-isa-sim
fi

if [ ! -d riscv-opcodes ]; then
	rm -rf riscv-opcodes-new
	git clone git@github.com:riscv/riscv-opcodes.git riscv-opcodes-new
	cd riscv-opcodes-new
	git checkout riscv-bitmanip
	cd ..
	mv riscv-opcodes-new riscv-opcodes
fi

if [ ! -d riscv-newlib ]; then
	rm -rf riscv-newlib-new
	git clone git@github.com:riscv/riscv-newlib.git riscv-newlib-new
	mv riscv-newlib-new riscv-newlib
fi

if [ ! -d riscv-pk ]; then
	rm -rf riscv-pk-new
	git clone git@github.com:riscv/riscv-pk.git riscv-pk-new
	mv riscv-pk-new riscv-pk
fi
