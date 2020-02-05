RUN_TESTS_B = true
RUN_TESTS_I = true
RUN_TESTS_M = true

run: run64

run32: test32
	/opt/riscv64b/bin/spike --isa=RV32GCB pk test32

run64: test64
	/opt/riscv64b/bin/spike --isa=RV64GCB pk test64

define add_test32
TEST32OBJS += test32_$(1).o
TEST32NAMES += $(1)
test32_$(1).o: riscv_test.h $(2)/references/$(3).reference_output $(2)/src/$(3).S
	echo "extern void testcode_$(1)();" > test32_$(1).h
	echo "extern uint32_t signature_$(1)[];" >> test32_$(1).h
	echo "uint32_t reference_$(1)[] = {" >> test32_$(1).h
	sed 's/^/0x/; s/$$$$/,/;' $(2)/references/$(3).reference_output >> test32_$(1).h
	echo "};" >> test32_$(1).h
	- /opt/riscv64b/bin/riscv64-unknown-elf-gcc -c -o test32_$(1).o -march=rv32gcb -mabi=ilp32f \
			-D 'RVTEST_SYM(_sym)=_sym##_$(1)' -I. -I../../../riscv-compliance/riscv-test-env \
			-I ../../../riscv-compliance/riscv-target/spike $(2)/src/$(3).S
endef

define add_test64
TEST64OBJS += test64_$(1).o
TEST64NAMES += $(1)
test64_$(1).o: riscv_test.h $(2)/references/$(3).reference_output $(2)/src/$(3).S
	echo "extern void testcode_$(1)();" > test64_$(1).h
	echo "extern uint32_t signature_$(1)[];" >> test64_$(1).h
	echo "uint32_t reference_$(1)[] = {" >> test64_$(1).h
	sed 's/^/0x/; s/$$$$/,/;' $(2)/references/$(3).reference_output >> test64_$(1).h
	echo "};" >> test64_$(1).h
	- /opt/riscv64b/bin/riscv64-unknown-elf-gcc -c -o test64_$(1).o -march=rv64gcb \
			-D 'RVTEST_SYM(_sym)=_sym##_$(1)' -I. -I../../../riscv-compliance/riscv-test-env \
			-I ../../../riscv-compliance/riscv-target/spike $(2)/src/$(3).S
endef

tests32.mk: Makefile blacklist.txt
	if $(RUN_TESTS_B); then set -e; for x in ../../compliance/rv32b/src/*.S; do \
	p=$$(basename $$x); p=$$(echo $$p | sed 's,\.S$$,,'); n=rv32$$(echo $$p | tr A-Z-. a-z__); \
	grep -xqF $$n blacklist.txt || echo "\$$(eval \$$(call add_test32,$$n,../../compliance/rv32b,$$p))"; done; fi > tests32.mk.new
	if $(RUN_TESTS_I); then set -e; for x in ../../../riscv-compliance/riscv-test-suite/rv32i/src/*.S; do \
	p=$$(basename $$x); p=$$(echo $$p | sed 's,\.S$$,,'); n=rv32$$(echo $$p | tr A-Z-. a-z__ | sed 's/_01$$//'); \
	grep -xqF $$n blacklist.txt || echo "\$$(eval \$$(call add_test32,$$n,../../../riscv-compliance/riscv-test-suite/rv32i,$$p))"; done; fi >> tests32.mk.new
	if $(RUN_TESTS_M); then set -e; for x in ../../../riscv-compliance/riscv-test-suite/rv32im/src/*.S; do \
	p=$$(basename $$x); p=$$(echo $$p | sed 's,\.S$$,,'); n=rv32m_$$(echo $$p | tr A-Z-. a-z__); \
	grep -xqF $$n blacklist.txt || echo "\$$(eval \$$(call add_test32,$$n,../../../riscv-compliance/riscv-test-suite/rv32im,$$p))"; done; fi >> tests32.mk.new
	mv tests32.mk.new tests32.mk

tests64.mk: Makefile blacklist.txt
	if $(RUN_TESTS_B); then set -e; for x in ../../compliance/rv64b/src/*.S; do \
	p=$$(basename $$x); p=$$(echo $$p | sed 's,\.S$$,,'); n=rv64$$(echo $$p | tr A-Z-. a-z__); \
	grep -xqF $$n blacklist.txt || echo "\$$(eval \$$(call add_test64,$$n,../../compliance/rv64b,$$p))"; done; fi > tests64.mk.new
	if $(RUN_TESTS_I); then set -e; for x in ../../../riscv-compliance/riscv-test-suite/rv64i/src/*.S; do \
	p=$$(basename $$x); p=$$(echo $$p | sed 's,\.S$$,,'); n=rv64$$(echo $$p | tr A-Z-. a-z__ | sed 's/_01$$//'); \
	grep -xqF $$n blacklist.txt || echo "\$$(eval \$$(call add_test64,$$n,../../../riscv-compliance/riscv-test-suite/rv64i,$$p))"; done; fi >> tests64.mk.new
	if $(RUN_TESTS_M); then set -e; for x in ../../../riscv-compliance/riscv-test-suite/rv64im/src/*.S; do \
	p=$$(basename $$x); p=$$(echo $$p | sed 's,\.S$$,,'); n=rv64m_$$(echo $$p | tr A-Z-. a-z__); \
	grep -xqF $$n blacklist.txt || echo "\$$(eval \$$(call add_test64,$$n,../../../riscv-compliance/riscv-test-suite/rv64im,$$p))"; done; fi >> tests64.mk.new
	mv tests64.mk.new tests64.mk

include tests32.mk
include tests64.mk

tests32.h: Makefile
	echo -n '#define RUN_ALL_TESTS' > tests32.h.new
	{ for t in $(TEST32NAMES); do echo -n " RUNTEST($$t)"; done; echo; } >> tests32.h.new
	for t in $(TEST32NAMES); do echo "#include \"test32_$$t.h\""; done >> tests32.h.new
	mv tests32.h.new tests32.h

tests64.h: Makefile
	echo -n '#define RUN_ALL_TESTS' > tests64.h.new
	{ for t in $(TEST64NAMES); do echo -n " RUNTEST($$t)"; done; echo; } >> tests64.h.new
	for t in $(TEST64NAMES); do echo "#include \"test64_$$t.h\""; done >> tests64.h.new
	mv tests64.h.new tests64.h

test32: main.c tests32.h $(TEST32OBJS)
	/opt/riscv64b/bin/riscv64-unknown-elf-gcc -march=rv32gcb -mabi=ilp32f -o test32 -Wall -O2 main.c $(TEST32OBJS)

test64: main.c tests64.h $(TEST64OBJS)
	/opt/riscv64b/bin/riscv64-unknown-elf-gcc -march=rv64gcb -o test64 -Wall -O2 main.c $(TEST64OBJS)

clean:
	rm -f test32 test32_*.h test32_*.o tests32.h tests32.mk
	rm -f test64 test64_*.h test64_*.o tests64.h tests64.mk

.PHONY: run clean
