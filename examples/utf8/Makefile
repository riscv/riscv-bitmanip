run: utf8
	/opt/riscv64b/bin/spike --isa=RV64GCB pk $<

utf8: utf8.c
	/opt/riscv64b/bin/riscv64-unknown-elf-gcc -march=rv64gcb -o $@ -Wall -O3 $^

clean:
	rm -f utf8

.PHONY: run clean
