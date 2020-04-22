#!/bin/bash
set -ex

if [ ! -d coremark-src ]; then
	git clone https://github.com/eembc/coremark coremark-src
	ln -s ../riscv64 coremark-src/riscv64
fi

cd coremark-src

make clean
make ITERATIONS=1000 PORT_DIR=riscv64 PORT_CFLAGS="-O3 -march=rv64gc"
cp run1.log ../run1-rv64gc.log
cp run2.log ../run2-rv64gc.log
cp coremark.exe ../coremark-rv64gc.exe
/opt/riscv64b/bin/riscv64-unknown-elf-size coremark.exe > ../coremark-rv64gc.size

make clean
make ITERATIONS=1000 PORT_DIR=riscv64 PORT_CFLAGS="-O3 -march=rv64gcb"
cp run1.log ../run1-rv64gcb.log
cp run2.log ../run2-rv64gcb.log
cp coremark.exe ../coremark-rv64gcb.exe
/opt/riscv64b/bin/riscv64-unknown-elf-size coremark.exe > ../coremark-rv64gcb.size
