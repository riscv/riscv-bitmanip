all: tinygrev simplebfxp

# ------------------------------------------------------------------------

tinygrev_tb: tinygrev_tb.v tinygrev.v
	iverilog -o $@ $^

tinygrev: tinygrev_tb testdata_grev.hex
	vvp -N tinygrev_tb

# ------------------------------------------------------------------------

simplebfxp_tb: simplebfxp_tb.v simplebfxp.v
	iverilog -o $@ $^

simplebfxp: simplebfxp_tb testdata_bfxp.hex
	vvp -N simplebfxp_tb

# ------------------------------------------------------------------------

testdata_gzip.hex: testdata_grev.hex
testdata_bfxp.hex: testdata_grev.hex

testdata_grev.hex: testdata.cc
	clang++ -Wall -Os -std=c++11 -o testdata testdata.cc
	./testdata
