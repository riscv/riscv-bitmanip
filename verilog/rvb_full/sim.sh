#!/bin/bash

exec 2>&1
set -ex

{
	echo "read_ilang ../../database/design.il"
	while read -r idx mut; do
		echo "mutate -ctrl mutsel 8 ${idx} ${mut#* }"
	done < input.txt
	echo "write_verilog -attr2comment mutated.v"
} > mutate.ys

yosys -ql mutate.log mutate.ys
iverilog -DMCY -o sim ../../system.v ../../picorv32.v mutated.v
ln -s ../../firmware.hex .

while read idx mut; do
	vvp -N sim +mut=${idx} > sim_${idx}.out
	if grep -qFx '*** PASS ***' sim_${idx}.out; then
		echo "$idx PASS" >> output.txt
	else
		echo "$idx FAIL" >> output.txt
	fi
done < input.txt

exit 0
