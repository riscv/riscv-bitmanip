#!/bin/bash

for d in riscv-gcc riscv-binutils riscv-isa-sim riscv-opcodes riscv-newlib riscv-pk; do
	cd $d; git diff | grep '^[-+@ ]' | filterdiff --strip=1 --addprefix=$d/ --clean; cd ..
done
