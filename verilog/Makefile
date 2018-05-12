all: tinygrev tinygzip simplegrev simplegzip simplebfxp simplebitcnt simplebextdep smartbextdep

stats: stats.ysok
	python3 stats.py | grep . > stats.tex
	pdflatex stats.tex

stats.ysok: stats.ys *.v
	yosys stats.ys
	touch stats.ysok

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

simplebitcnt_tb: simplebitcnt_tb.v simplebitcnt.v
	iverilog -o $@ $^

simplebitcnt: simplebitcnt_tb testdata_clz.hex testdata_ctz.hex testdata_pcnt.hex
	vvp -N simplebitcnt_tb

# ------------------------------------------------------------------------

simplegrev_tb: simplegrev_tb.v simplegrev.v
	iverilog -o $@ $^

simplegrev: simplegrev_tb testdata_grev.hex
	vvp -N simplegrev_tb

# ------------------------------------------------------------------------

simplegzip_tb: simplegzip_tb.v simplegzip.v
	iverilog -o $@ $^

simplegzip: simplegzip_tb testdata_gzip.hex
	vvp -N simplegzip_tb

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

smartbextdep_tb: smartbextdep_tb.v smartbextdep.v
	iverilog -o $@ $^

smartbextdep: smartbextdep_tb testdata_bext.hex testdata_bdep.hex
	vvp -N smartbextdep_tb

# ------------------------------------------------------------------------

testdata_clz.hex: testdata_grev.hex
testdata_ctz.hex: testdata_grev.hex
testdata_pcnt.hex: testdata_grev.hex
testdata_gzip.hex: testdata_grev.hex
testdata_bfxp.hex: testdata_grev.hex
testdata_bfxpc.hex: testdata_grev.hex
testdata_bext.hex: testdata_grev.hex
testdata_bdep.hex: testdata_grev.hex

testdata_grev.hex: testdata.cc
	clang++ -Wall -Os -std=c++11 -o testdata testdata.cc
	./testdata
