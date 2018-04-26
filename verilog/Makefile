all: tinygrev simplebfxp

# ------------------------------------------------------------------------

tinygrev: tinygrev.log tinygrev_tb.vcd

tinygrev.log: tinygrev.v
	yosys -l tinygrev.log -p 'synth; dfflibmap -liberty cells.lib' \
	      -p 'abc -liberty cells.lib; stat -liberty cells.lib' tinygrev.v

tinygrev_tb: tinygrev_tb.v tinygrev.v
	iverilog -o $@ $^

tinygrev_tb.vcd: tinygrev_tb testdata_grev.hex
	vvp -N tinygrev_tb

# ------------------------------------------------------------------------

simplebfxp: simplebfxp.log simplebfxp_tb.vcd

simplebfxp.log: simplebfxp.v
	yosys -l simplebfxp.log -p 'synth; dfflibmap -liberty cells.lib' \
	      -p 'abc -liberty cells.lib; stat -liberty cells.lib' simplebfxp.v

simplebfxp_tb: simplebfxp_tb.v simplebfxp.v
	iverilog -o $@ $^

simplebfxp_tb.vcd: simplebfxp_tb testdata_bfxp.hex
	vvp -N simplebfxp_tb

# ------------------------------------------------------------------------

testdata_gzip.hex: testdata_grev.hex
testdata_bfxp.hex: testdata_grev.hex

testdata_grev.hex: testdata.cc
	clang++ -Wall -Os -std=c++11 -o testdata testdata.cc
	./testdata
