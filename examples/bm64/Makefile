run: bm64
	/opt/riscv64b/bin/spike --isa=RV64GCB pk $<

bm64: bm64.c bm64.s
	/opt/riscv64b/bin/riscv64-unknown-elf-gcc -march=rv64gcb -o $@ -Wall -O3 $^

clean:
	rm -f bm64

.PHONY: run clean
