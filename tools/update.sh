#!/bin/bash

for prj in riscv-gcc riscv-binutils riscv-isa-sim; do
	cd $prj; echo; echo "== $prj =="
	if git branch | grep -q '^\* riscv-bitmanip$'; then
		git pull origin
	else
		echo "Not on riscv-bitmanip branch"
	fi
	cd ..
done

cd riscv-newlib; echo
echo "== riscv-newlib =="
git pull origin
# git checkout 77e11e1 # known good commit
git checkout riscv-newlib-3.0.0
cd ..

cd riscv-pk; echo
echo "== riscv-pk =="
git pull origin
# git checkout bc94419 # known good commit
git checkout master
cd ..
