ELF = $(wildcard extB/object/*/test.elf)
LOG = $(ELF:.elf=.log)

ifeq ($(OS),Windows_NT)
    TARGET_SIM ?= ../riscv-ovpsim/bin/Windows64/riscvOVPsim.exe
else
    TARGET_SIM ?= ../riscv-ovpsim/bin/Linux64/riscvOVPsim.exe
endif

ifeq ($(shell command -v $(TARGET_SIM) 2> /dev/null),)
    $(error Target simulator executable '$(TARGET_SIM)` not found)
endif

RUN_TARGET = \
    $(TARGET_SIM) \
        --variant RV32GC --customcontrol --extensionb \
        --override riscvOVPsim/cpu/simulateexceptions=T \
        --override riscvOVPsim/cpu/defaultsemihost=F \
        --override riscvOVPsim/cpu/user_version=2.3 \
        --override riscvOVPsim/cpu/priv_version=1.11

export RISCV_PREFIX  ?= riscv-none-embed-
export RISCV_CC      ?= $(RISCV_PREFIX)gcc
export RISCV_OBJDUMP ?= $(RISCV_PREFIX)objdump

all: 
	$(MAKE) -C extB $@
	$(MAKE) run
	$(MAKE) verify

run: $(LOG)

verify:
	@ bash verify.sh

%.log: %.elf FORCE
	$(RUN_TARGET) --program $(<) --logfile $(@).trc --trace --tracechange >/dev/null
	$(RUN_TARGET) --program $(<) --logfile $(@).tmp
	@ grep "^LOG: " $(@).tmp > $@
	@ rm -f $(@).tmp

clean:
	$(MAKE) -C extB $@
	
FORCE:
