all: testbench_0.ok testbench_1.ok testbench_2.ok testbench_3.ok

testdata: testdata.cc
	c++ -Wall -o testdata testdata.cc

testdata_0.hex: testdata
	./testdata

testdata_1.hex: testdata_0.hex
testdata_2.hex: testdata_0.hex
testdata_3.hex: testdata_0.hex

testbench_0: testbench.v rvb_bextdep.v
	iverilog -o testbench_0 -s testbench -DTESTDATA='"testdata_0.hex"' -DENABLE_64BIT -DENABLE_GREV testbench.v rvb_bextdep.v

testbench_1: testbench.v rvb_bextdep.v
	iverilog -o testbench_1 -s testbench -DTESTDATA='"testdata_1.hex"' -DENABLE_GREV testbench.v rvb_bextdep.v

testbench_2: testbench.v rvb_bextdep.v
	iverilog -o testbench_2 -s testbench -DTESTDATA='"testdata_2.hex"' -DENABLE_64BIT testbench.v rvb_bextdep.v

testbench_3: testbench.v rvb_bextdep.v
	iverilog -o testbench_3 -s testbench -DTESTDATA='"testdata_3.hex"' testbench.v rvb_bextdep.v

testbench_0.ok: testbench_0 testdata_0.hex
	vvp -N ./testbench_0
	touch testbench_0.ok

testbench_1.ok: testbench_1 testdata_1.hex
	vvp -N ./testbench_1
	touch testbench_1.ok

testbench_2.ok: testbench_2 testdata_2.hex
	vvp -N ./testbench_2
	touch testbench_2.ok

testbench_3.ok: testbench_3 testdata_3.hex
	vvp -N ./testbench_3
	touch testbench_3.ok

clean:
	rm -f testbench.vcd testdata testdata_?.hex testbench_? testbench_?.ok

.PHONY: all clean
