test: testbench_0.ok

synth: synth.out
	cat synth.out

synth.out: rvb_zbb32.v synth.py
	python3 synth.py

testdata: testdata.cc
	c++ -Wall -o testdata testdata.cc

testdata_0.hex: testdata
	./testdata

testbench_0: testbench.v rvb_zbb32.v
	iverilog -o testbench_0 -s testbench -DTESTDATA='"testdata_0.hex"' testbench.v rvb_zbb32.v

testbench_0.ok: testbench_0 testdata_0.hex
	vvp -N ./testbench_0
	touch testbench_0.ok

clean:
	rm -f testbench.vcd testdata testdata_?.hex testbench_? testbench_?.ok synth.out synth.tmp synth.ys

.PHONY: test synth clean
