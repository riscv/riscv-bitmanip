all: document autoasm

document:
	make -C specification

autoasm:
	make -C asmtests/auto

runtest: autoasm
	make -C asmtests

clean:
	make -C specification clean
	make -C asmtests/auto clean
	make -C asmtests clean

help:
	@echo "Targets"
	@echo "    all"
	@echo "    document"
	@echo "    runtest"
	@echo "    clean"
