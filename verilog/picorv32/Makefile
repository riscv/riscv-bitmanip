RUN_TESTS_B = true
RUN_TESTS_I = false
RUN_TESTS_M = false

run: system firmware.hex
	vvp -N ./system

define add_test
TESTOBJS += tests/test_$(1).o
TESTNAMES += $(1)
tests/test_$(1).o: riscv_test.h $(2)/references/$(3).reference_output $(2)/src/$(3).S
	mkdir -p tests
	echo "extern void testcode_$(1)();" > tests/test_$(1).h
	echo "extern uint32_t signature_$(1)[];" >> tests/test_$(1).h
	echo "uint32_t reference_$(1)[] = {" >> tests/test_$(1).h
	sed 's/^/0x/; s/$$$$/,/;' $(2)/references/$(3).reference_output >> tests/test_$(1).h
	echo "};" >> tests/test_$(1).h
	/opt/riscv64b/bin/riscv64-unknown-elf-gcc -c -o tests/test_$(1).o -march=rv32imb -mabi=ilp32 \
			-D 'RVTEST_SYM(_sym)=_sym##_$(1)' -I. -I../../../riscv-compliance/riscv-test-env \
			-I ../../../riscv-compliance/riscv-target/spike $(2)/src/$(3).S
endef

tests/tests.h: Makefile
	mkdir -p tests
	echo -n '#define RUN_ALL_TESTS' > tests/tests.h.new
	{ for t in $(TESTNAMES); do echo -n " RUNTEST($$t)"; done; echo; } >> tests/tests.h.new
	for t in $(TESTNAMES); do echo "#include \"test_$$t.h\""; done >> tests/tests.h.new
	mv tests/tests.h.new tests/tests.h

tests/tests.mk: Makefile blacklist.txt
	mkdir -p tests
	if $(RUN_TESTS_B); then set -e; for x in ../../compliance/rv32b/src/*.S; do \
	p=$$(basename $$x); p=$$(echo $$p | sed 's,\.S$$,,'); n=rv32$$(echo $$p | tr A-Z-. a-z__); \
	grep -xqF $$n blacklist.txt || echo "\$$(eval \$$(call add_test,$$n,../../compliance/rv32b,$$p))"; done; fi > tests/tests.mk.new
	if $(RUN_TESTS_I); then set -e; for x in ../../../riscv-compliance/riscv-test-suite/rv32i/src/*.S; do \
	p=$$(basename $$x); p=$$(echo $$p | sed 's,\.S$$,,'); n=rv32$$(echo $$p | tr A-Z-. a-z__ | sed 's/_01$$//'); \
	grep -xqF $$n blacklist.txt || echo "\$$(eval \$$(call add_test,$$n,../../../riscv-compliance/riscv-test-suite/rv32i,$$p))"; done; fi >> tests/tests.mk.new
	if $(RUN_TESTS_M); then set -e; for x in ../../../riscv-compliance/riscv-test-suite/rv32im/src/*.S; do \
	p=$$(basename $$x); p=$$(echo $$p | sed 's,\.S$$,,'); n=rv32m_$$(echo $$p | tr A-Z-. a-z__); \
	grep -xqF $$n blacklist.txt || echo "\$$(eval \$$(call add_test,$$n,../../../riscv-compliance/riscv-test-suite/rv32im,$$p))"; done; fi >> tests/tests.mk.new
	mv tests/tests.mk.new tests/tests.mk

-include tests/tests.mk

firmware.hex: start.S firmware.c hex8tohex32.py $(TESTOBJS) tests/tests.h
	/opt/riscv64b/bin/riscv64-unknown-elf-gcc -march=rv32imb -mabi=ilp32 -o firmware.elf -Wall -O2 -ffreestanding -nostdlib \
			-Wl,-Bstatic,-T,sections.lds,-Map,firmware.map,--strip-debug start.S firmware.c $(TESTOBJS)
	/opt/riscv64b/bin/riscv64-unknown-elf-objcopy -O verilog firmware.elf firmware.tmp
	python3 hex8tohex32.py firmware.tmp > firmware.hex
	rm -f firmware.tmp

RVB_SRCS = rvb_pcpi.v ../rvb_full/rvb_full.v
RVB_SRCS += ../rvb_bextdep/rvb_bextdep.v ../rvb_bitcnt/rvb_bitcnt.v ../rvb_bmatxor/rvb_bmatxor.v
RVB_SRCS += ../rvb_clmul/rvb_clmul.v ../rvb_crc/rvb_crc.v ../rvb_shifter/rvb_shifter.v ../rvb_simple/rvb_simple.v

system: system.v picorv32.v $(RVB_SRCS)
	iverilog -o system -D RVB_DEBUG system.v picorv32.v $(RVB_SRCS)

clean:
	rm -f system firmware.hex firmware.elf firmware.map system.vcd tests/test_*.h tests/test_*.o tests/tests.h tests/tests.mk

.PHONY: run clean
