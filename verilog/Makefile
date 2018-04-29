all: tinygrev tinygzip simplebfxp simplebextdep

# ------------------------------------------------------------------------

tinygrev_tb: tinygrev_tb.v tinygrev.v
	iverilog -o $@ $^

tinygrev: tinygrev_tb testdata_grev.hex
	vvp -N tinygrev_tb

# ------------------------------------------------------------------------

tinygzip_tb: tinygzip_tb.v tinygzip.v
	iverilog -o $@ $^

tinygzip: tinygzip_tb testdata_gzip.hex
	vvp -N tinygzip_tb

# ------------------------------------------------------------------------

simplebfxp_tb: simplebfxp_tb.v simplebfxp.v
	iverilog -o $@ $^

simplebfxp: simplebfxp_tb testdata_bfxp.hex
	vvp -N simplebfxp_tb

# ------------------------------------------------------------------------

simplebextdep_tb: simplebextdep_tb.v simplebextdep.v
	iverilog -o $@ $^

simplebextdep: simplebextdep_tb testdata_bext.hex testdata_bdep.hex
	vvp -N simplebextdep_tb

# ------------------------------------------------------------------------

testdata_gzip.hex: testdata_grev.hex
testdata_bfxp.hex: testdata_grev.hex
testdata_bext.hex: testdata_grev.hex
testdata_bdep.hex: testdata_grev.hex

testdata_grev.hex: testdata.cc
	clang++ -Wall -Os -std=c++11 -o testdata testdata.cc
	./testdata
