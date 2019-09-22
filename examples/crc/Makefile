run: run32q run32c

run32q: crc32q
	/opt/riscv64b/bin/spike --isa=RV64GCB pk $<

crc32q: crc32q.c
	/opt/riscv64b/bin/riscv64-unknown-elf-gcc -march=rv64gcb -o $@ -Wall -O2 $<

run32c: crc32c
	/opt/riscv64b/bin/spike --isa=RV64GCB pk $<

crc32c: crc32c.c
	/opt/riscv64b/bin/riscv64-unknown-elf-gcc -march=rv64gcb -o $@ -Wall -O2 $<

clean:
	rm -f crc32q crc32c

.PHONY: run run32q run32c clean
