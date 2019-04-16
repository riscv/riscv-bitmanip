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

export RISCV_CC      ?= riscv-none-embed-gcc
export RISCV_OBJDUMP ?= riscv-none-embed-objdump

all: 
	make -C extB $@
	make run
	make verify
	
run: $(LOG)

verify:
	@ verify.sh

%.log: %.elf FORCE
	$(RUN_TARGET) --program $(<) --logfile $(@).tmp
	$(RUN_TARGET) --program $(<) --logfile $(@).trc --trace --tracechange >/dev/null
	@ grep "^LOG: " $(@).tmp > $@
	@ rm -f $(@).tmp

clean:
	make -C extB $@
	
FORCE:
