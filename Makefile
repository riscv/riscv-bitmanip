all: document runtest

document:
	bash bitmanip.sh 3

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
