# include Cross Compiler settings for RISCV
ifeq ($(RISCV_CC),)
    IMPERAS_ERROR := $(error "Error : RISCV_CC not set. Please check installation of toolchain for RISCV")
endif

SRC     = $(wildcard */*.S)
ELF     = $(foreach f,$(SRC:.S=.elf),object/$(f))
INCLUDE = -I../common -I../../Imperas/ImperasLib/source/riscv.ovpworld.org/intercept/extB/1.0/model

OPT_CC  = -mabi=ilp32 -march=rv32im -Wl,-Ttext=0x80000000 -nostartfiles

all: $(ELF)

object/%.elf: %.S
	mkdir -p $(@D)
	cat ../common/log.S $(^) > $(@D)/concat.S
	$(RISCV_CC) $(OPT_CC) -o $@ $(@D)/concat.S $(INCLUDE)
	#$(RISCV_OBJDUMP) -D $(@) > $(*).objdump

clean:
	- rm -rf object
