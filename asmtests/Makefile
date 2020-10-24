ELF32 = $(wildcard extB/object/*/test.32.elf)
ELF64 = $(wildcard extB/object/*/test.64.elf)

AUTOTEST ?= 0
ifeq ($(AUTOTEST),1)
	ELF32 = extB/object/autoasm/test.32.elf
	ELF64 = extB/object/autoasm/test.64.elf
endif
export AUTOTEST

LOG64 = $(ELF64:.64.elf=.64.log)
LOG32 = $(ELF32:.32.elf=.32.log)
ELF   = $(ELF32) $(ELF64)
LOG   = $(LOG32) $(LOG64)

V=@
REDIR=>/dev/null
ifeq ($(VERBOSE),1)
	REDIR=
	V=
endif
ifeq ($(TRACE),1)
	REDIR=--trace --tracechange --tracefile $(@).trc >/dev/null
endif

ifeq ($(OS),Windows_NT)
    TARGET_SIM ?= riscvOVPsim.exe
else
    TARGET_SIM ?= riscvOVPsim.exe
endif

ifeq ($(shell command -v $(TARGET_SIM) 2> /dev/null),)
    $(error Target simulator executable '$(TARGET_SIM)` not found)
endif

RUN_TARGET = \
    $(TARGET_SIM) \
        --customcontrol \
        --override riscvOVPsim/cpu/simulateexceptions=T \
        --override riscvOVPsim/cpu/defaultsemihost=F \
        --override riscvOVPsim/cpu/user_version=2.3 \
        --override riscvOVPsim/cpu/priv_version=1.11 \
        --override riscvOVPsim/cpu/add_Extensions=B

all: 
	$(MAKE) -C extB $@
	$(MAKE) run
	$(MAKE) verify

run: $(LOG)

verify:
	@ bash verify.sh

%.32.log: %.32.elf FORCE
	$(RUN_TARGET) --variant RV32GC --program $(<) --logfile $(@).tmp $(REDIR)
	@ -grep "^LOG: " $(@).tmp > $@
	@ rm -f $(@).tmp

%.64.log: %.64.elf FORCE
	$(RUN_TARGET) --variant RV64GC --program $(<) --logfile $(@).tmp $(REDIR)
	@ -grep "^LOG: " $(@).tmp > $@
	@ rm -f $(@).tmp

clean:
	$(MAKE) -C extB $@
	
FORCE:
