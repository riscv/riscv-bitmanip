all: document runtest

document:
	cd texsrc && bash bitmanip.sh 3
	cp texsrc/bitmanip.pdf .

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
