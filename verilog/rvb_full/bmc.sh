#!/bin/bash

exec 2>&1
set -ex

{
	echo "read_ilang ../../database/design.il"
	while read -r idx mut; do
		echo "mutate -ctrl mutsel 8 ${idx} ${mut#* }"
	done < input.txt
	echo "write_ilang mutated.il"
} > mutate.ys

yosys -ql mutate.log mutate.ys
cp ../../bmc.sv ../../bmc.sby .

while read idx mut; do
	sby -f bmc.sby ${idx}
	gawk "{ print $idx, \$1; }" bmc_${idx}/status >> output.txt
done < input.txt

exit 0
