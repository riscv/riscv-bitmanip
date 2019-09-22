run: run32q

run32q: crc32q
	/opt/riscv64b/bin/spike --isa=RV64GCB pk crc32q

crc32q: crc32q.c
	/opt/riscv64b/bin/riscv64-unknown-elf-gcc -march=rv64gcb -o $@ -Wall -O2 $<

clean:
	rm -f crc32q

.PHONY: run run32q clean
