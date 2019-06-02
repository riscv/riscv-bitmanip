#!/bin/bash
set -ex
binutils-gdb/gas/as-new -o binutils-demo.o -march=rv64ib binutils-demo.s
binutils-gdb/binutils/objdump -M numeric -d binutils-demo.o
rm binutils-demo.o
