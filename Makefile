all: document runtest

document:
	cd texsrc && bash bitmanip.sh 5
	cp texsrc/bitmanip.pdf .

autoasm:
	$(MAKE) -C asmtests/auto

runtest: autoasm
	$(MAKE) -C asmtests

clean:
	$(MAKE) -C asmtests/auto clean
	$(MAKE) -C asmtests clean

help:
	@echo "Targets"
	@echo "    all"
	@echo "    document"
	@echo "    runtest"
	@echo "    clean"
