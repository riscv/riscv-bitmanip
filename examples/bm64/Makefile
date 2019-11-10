run: bm64
	/opt/riscv64b/bin/spike --isa=RV64GCB pk $<

bm64: bm64.c
	/opt/riscv64b/bin/riscv64-unknown-elf-gcc -march=rv64gcb -o $@ -Wall -O2 $<

clean:
	rm -f bm64

.PHONY: run clean
