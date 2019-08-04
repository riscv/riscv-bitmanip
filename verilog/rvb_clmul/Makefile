test: testbench_0.ok testbench_1.ok

synth: synth.out
	cat synth.out

synth.out: rvb_clmul.v
	python3 synth.py

testdata: testdata.cc
	c++ -Wall -o testdata testdata.cc

testdata_0.hex: testdata
	./testdata

testdata_1.hex: testdata_0.hex

testbench_0: testbench.v rvb_clmul.v
	iverilog -o testbench_0 -s testbench -DTESTDATA='"testdata_0.hex"' -DENABLE_64BIT testbench.v rvb_clmul.v

testbench_1: testbench.v rvb_clmul.v
	iverilog -o testbench_1 -s testbench -DTESTDATA='"testdata_1.hex"' testbench.v rvb_clmul.v

testbench_0.ok: testbench_0 testdata_0.hex
	vvp -N ./testbench_0
	touch testbench_0.ok

testbench_1.ok: testbench_1 testdata_1.hex
	vvp -N ./testbench_1
	touch testbench_1.ok

clean:
	rm -f testbench.vcd testdata testdata_?.hex testbench_? testbench_?.ok synth.out synth.tmp synth.ys

.PHONY: test synth clean
