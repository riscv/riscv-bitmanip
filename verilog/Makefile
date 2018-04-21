
all: tinygrev.log tinygrev_tb.vcd

tinygrev.log: tinygrev.v
	yosys -l tinygrev.log -p 'synth; dfflibmap -liberty cells.lib' \
	      -p 'abc -liberty cells.lib; stat -liberty cells.lib' tinygrev.v

tinygrev_tb: tinygrev_tb.v tinygrev.v
	iverilog -o $@ $^

tinygrev_tb.vcd: tinygrev_tb testdata_grev.hex
	vvp -N tinygrev_tb

testdata_shuffle.hex: testdata_grev.hex

testdata_grev.hex: testdata.cc
	clang++ -Wall -Os -std=c++11 -o testdata testdata.cc
	./testdata
