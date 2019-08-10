test: testbench_0.ok testbench_1.ok testbench_2.ok testbench_3.ok testbench_4.ok testbench_5.ok testbench_6.ok testbench_7.ok

regen:
	grep -B999999 -A1 '^// -x- ' rvb_bextdep.v > rvb_bextdep.v.new
	python3 bflymaker.py >> rvb_bextdep.v.new
	python3 ppsmaker.py    -i 1 -o 8 -n 4  -m rvb_bextdep_pps4   >> rvb_bextdep.v.new
	python3 ppsmaker.py    -i 1 -o 8 -n 8  -m rvb_bextdep_pps8   >> rvb_bextdep.v.new
	python3 ppsmaker.py    -i 1 -o 8 -n 16 -m rvb_bextdep_pps16  >> rvb_bextdep.v.new
	python3 ppsmaker.py    -i 1 -o 8 -n 32 -m rvb_bextdep_pps32  >> rvb_bextdep.v.new
	python3 ppsmaker.py    -i 1 -o 8 -n 64 -m rvb_bextdep_pps64  >> rvb_bextdep.v.new
	python3 ppsmaker.py -f -i 1 -o 8 -n 32 -m rvb_bextdep_pps32f >> rvb_bextdep.v.new
	python3 ppsmaker.py -f -i 1 -o 8 -n 64 -m rvb_bextdep_pps64f >> rvb_bextdep.v.new
	mv rvb_bextdep.v.new rvb_bextdep.v

synth: synth.out
	cat synth.out

synth.out: rvb_bextdep.v synth.py
	python3 synth.py

testdata: testdata.cc
	c++ -Wall -o testdata testdata.cc

testdata_0.hex: testdata
	./testdata

testdata_1.hex: testdata_0.hex
testdata_2.hex: testdata_0.hex
testdata_3.hex: testdata_0.hex
testdata_4.hex: testdata_0.hex
testdata_5.hex: testdata_0.hex
testdata_6.hex: testdata_0.hex
testdata_7.hex: testdata_0.hex

testbench_0: testbench.v rvb_bextdep.v
	iverilog -o testbench_0 -s testbench -DTESTDATA='"testdata_0.hex"' -DENABLE_SHFL -DENABLE_GREV -DENABLE_64BIT testbench.v rvb_bextdep.v

testbench_1: testbench.v rvb_bextdep.v
	iverilog -o testbench_1 -s testbench -DTESTDATA='"testdata_1.hex"' -DENABLE_SHFL -DENABLE_GREV testbench.v rvb_bextdep.v

testbench_2: testbench.v rvb_bextdep.v
	iverilog -o testbench_2 -s testbench -DTESTDATA='"testdata_2.hex"' -DENABLE_SHFL -DENABLE_64BIT testbench.v rvb_bextdep.v

testbench_3: testbench.v rvb_bextdep.v
	iverilog -o testbench_3 -s testbench -DTESTDATA='"testdata_3.hex"' -DENABLE_SHFL testbench.v rvb_bextdep.v

testbench_4: testbench.v rvb_bextdep.v
	iverilog -o testbench_4 -s testbench -DTESTDATA='"testdata_4.hex"' -DENABLE_GREV -DENABLE_64BIT testbench.v rvb_bextdep.v

testbench_5: testbench.v rvb_bextdep.v
	iverilog -o testbench_5 -s testbench -DTESTDATA='"testdata_5.hex"' -DENABLE_GREV testbench.v rvb_bextdep.v

testbench_6: testbench.v rvb_bextdep.v
	iverilog -o testbench_6 -s testbench -DTESTDATA='"testdata_6.hex"' -DENABLE_64BIT testbench.v rvb_bextdep.v

testbench_7: testbench.v rvb_bextdep.v
	iverilog -o testbench_7 -s testbench -DTESTDATA='"testdata_7.hex"' testbench.v rvb_bextdep.v

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

testbench_4.ok: testbench_4 testdata_4.hex
	vvp -N ./testbench_4
	touch testbench_4.ok

testbench_5.ok: testbench_5 testdata_5.hex
	vvp -N ./testbench_5
	touch testbench_5.ok

testbench_6.ok: testbench_6 testdata_6.hex
	vvp -N ./testbench_6
	touch testbench_6.ok

testbench_7.ok: testbench_7 testdata_7.hex
	vvp -N ./testbench_7
	touch testbench_7.ok

clean:
	rm -f testbench.vcd testdata testdata_?.hex testbench_? testbench_?.ok synth.out synth.tmp synth.ys

.PHONY: test synth clean
