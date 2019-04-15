all: document runtest

document:
	bitmanip.sh

autoasm:
	make -C asmtests/auto

runtest: autoasm
	make -C asmtests

clean:
	make -C asmtests/auto clean
	make -C asmtests clean

help:
	@echo "Targets"
	@echo "    all"
	@echo "    document"
	@echo "    runtest"
	@echo "    clean"
