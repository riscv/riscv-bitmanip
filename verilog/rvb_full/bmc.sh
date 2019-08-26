#!/bin/bash

exec 2>&1
set -ex

MUTATIONS=(_ $MUTATIONS)

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
	if [ -f bmc_${idx}/engine_0/trace.vcd ]; then
		{
			echo "# ${MUTATIONS[$idx]}: $mut"
			python3 ../../getvector.py bmc_${idx}/engine_0/trace.vcd
		} >> ../../database/vectors.txt
	fi
done < input.txt

exit 0
