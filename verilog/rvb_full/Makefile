test: testbench_0.ok testbench_1.ok

synth: synth.out
	cat synth.out

synth.out: rvb_full.v synth.py
	python3 synth.py

run: system firmware.hex
	vvp -N ./system

define add_test
TESTOBJS += test_$(1).o
TESTNAMES += $(1)
test_$(1).o: riscv_test.h
	echo "extern void testcode_$(1)();" > test_$(1).h
	echo "extern uint32_t begin_signature_$(1)[];" >> test_$(1).h
	echo "extern uint32_t end_signature_$(1)[];" >> test_$(1).h
	echo "uint32_t reference_$(1)[] = {" >> test_$(1).h
	sed 's/^/0x/; s/$$$$/,/;' $(2)/references/$(3).reference_output >> test_$(1).h
	echo "};" >> test_$(1).h
	/opt/riscv64b/bin/riscv64-unknown-elf-gcc -c -o test_$(1).o -march=rv32imb -mabi=ilp32 \
			-D 'RVTEST_SYM(_sym)=_sym##_$(1)' -I. -I../../../riscv-compliance/riscv-test-env $(2)/src/$(3).S
endef

tests.h:
	echo -n '#define RUN_ALL_TESTS' > tests.h.new
	{ for t in $(TESTNAMES); do echo -n " RUNTEST($$t)"; done; echo; } >> tests.h.new
	for t in $(TESTNAMES); do echo "#include \"test_$$t.h\""; done >> tests.h.new
	mv tests.h.new tests.h

tests.mk:
	set -e; for x in ../../../riscv-compliance/riscv-test-suite/rv32i/src/*.S; do \
	p=$$(basename $$x); p=$$(echo $$p | sed 's,\.S$$,,'); n=rv32$$(echo $$p | tr A-Z-. a-z__); \
	grep -xqF $$n blacklist.txt || echo "\$$(eval \$$(call add_test,$$n,../../../riscv-compliance/riscv-test-suite/rv32i,$$p))"; done > tests.mk.new
	set -e; for x in ../../../riscv-compliance/riscv-test-suite/rv32im/src/*.S; do \
	p=$$(basename $$x); p=$$(echo $$p | sed 's,\.S$$,,'); n=rv32m_$$(echo $$p | tr A-Z-. a-z__); \
	grep -xqF $$n blacklist.txt || echo "\$$(eval \$$(call add_test,$$n,../../../riscv-compliance/riscv-test-suite/rv32im,$$p))"; done >> tests.mk.new
	mv tests.mk.new tests.mk

-include tests.mk

firmware.hex: start.S firmware.c hex8tohex32.py $(TESTOBJS) tests.h
	/opt/riscv64b/bin/riscv64-unknown-elf-gcc -march=rv32imb -mabi=ilp32 -o firmware.elf -Wall -Os -ffreestanding -nostdlib \
			-Wl,-Bstatic,-T,sections.lds,-Map,firmware.map,--strip-debug start.S firmware.c $(TESTOBJS)
	/opt/riscv64b/bin/riscv64-unknown-elf-objcopy -O verilog firmware.elf firmware.tmp
	python3 hex8tohex32.py firmware.tmp > firmware.hex
	rm -f firmware.tmp

system: system.v picorv32.v rvb_full.v rvb_pcpi.v
	iverilog -o system system.v picorv32.v rvb_pcpi.v rvb_full.v \
			../rvb_bextdep/rvb_bextdep.v ../rvb_bitcnt/rvb_bitcnt.v ../rvb_bmatxor/rvb_bmatxor.v \
			../rvb_clmul/rvb_clmul.v ../rvb_crc/rvb_crc.v ../rvb_shifter/rvb_shifter.v ../rvb_simple/rvb_simple.v

testdata: testdata.cc
	c++ -Wall -o testdata testdata.cc

testdata_0.hex: testdata
	./testdata

testdata_1.hex: testdata_0.hex

testbench_0: testbench.v rvb_full.v
	iverilog -o testbench_0 -s testbench -DTESTDATA='"testdata_0.hex"' -DENABLE_64BIT testbench.v rvb_full.v \
			../rvb_bextdep/rvb_bextdep.v ../rvb_bitcnt/rvb_bitcnt.v ../rvb_bmatxor/rvb_bmatxor.v \
			../rvb_clmul/rvb_clmul.v ../rvb_crc/rvb_crc.v ../rvb_shifter/rvb_shifter.v ../rvb_simple/rvb_simple.v

testbench_1: testbench.v rvb_full.v
	iverilog -o testbench_1 -s testbench -DTESTDATA='"testdata_1.hex"' testbench.v rvb_full.v \
			../rvb_bextdep/rvb_bextdep.v ../rvb_bitcnt/rvb_bitcnt.v ../rvb_bmatxor/rvb_bmatxor.v \
			../rvb_clmul/rvb_clmul.v ../rvb_crc/rvb_crc.v ../rvb_shifter/rvb_shifter.v ../rvb_simple/rvb_simple.v

testbench_0.ok: testbench_0 testdata_0.hex
	vvp -N ./testbench_0
	touch testbench_0.ok

testbench_1.ok: testbench_1 testdata_1.hex
	vvp -N ./testbench_1
	touch testbench_1.ok

clean:
	rm -f testbench.vcd testdata testdata_?.hex testbench_? testbench_?.ok synth.out synth.tmp synth.ys
	rm -f system firmware.hex firmware.elf firmware.map system.vcd test_*.h test_*.o tests.h tests.mk

.PHONY: test synth clean
