# include Cross Compiler settings for RISCV

RISCV_PREFIX  ?= riscv-none-embed-
RISCV_CC      ?= $(RISCV_PREFIX)gcc
RISCV_OBJDUMP ?= $(RISCV_PREFIX)objdump

SRC     = $(wildcard */test.S)
ELF32   = $(foreach f,$(SRC:.S=.32.elf),object/$(f))
ELF64   = $(foreach f,$(SRC:.S=.64.elf),object/$(f))
ELF     = $(ELF32) $(ELF64)
INCLUDE = -I../common -Iautoasm 

OPT_CC32  = -mabi=ilp32 -march=rv32im -Wl,-Ttext=0x80000000 -nostartfiles -DXLEN32 -DBMVER=93
OPT_CC64  = -mabi=lp64  -march=rv64im -Wl,-Ttext=0x80000000 -nostartfiles -DXLEN64 -DBMVER=93
 
all: $(ELF)

object/%.32.elf: %.S
	mkdir -p $(@D)
	cat ../common/log.S $(^) > $(@D)/concat.S
	$(RISCV_CC) $(OPT_CC32) -o $@ $(@D)/concat.S $(INCLUDE)
	$(RISCV_OBJDUMP) -D $(@) > $(@).32.objdump

object/%.64.elf: %.S
	mkdir -p $(@D)
	cat ../common/log.S $(^) > $(@D)/concat.S
	$(RISCV_CC) $(OPT_CC64) -o $@ $(@D)/concat.S $(INCLUDE)
	$(RISCV_OBJDUMP) -D $(@) > $(@).64.objdump

clean:
	- rm -rf object
