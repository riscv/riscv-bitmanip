#!/usr/bin/env python3

import os

with open("synth.ys", "w") as f:
    for xlen in (32, 64):
        for entity in ("", ".rvb_bextdep", ".rvb_bitcnt", ".rvb_bmatxor", ".rvb_clmul", ".rvb_shifter", ".rvb_simple"):
            if xlen == 32 and entity == ".rvb_bmatxor": continue
            print("design -reset", file=f)
            print("read_verilog -defer rvb_full.v", file=f)
            print("read_verilog -defer ../rvb_bextdep/rvb_bextdep.v", file=f)
            print("read_verilog -defer ../rvb_bitcnt/rvb_bitcnt.v", file=f)
            print("read_verilog -defer ../rvb_bmatxor/rvb_bmatxor.v", file=f)
            print("read_verilog -defer ../rvb_clmul/rvb_clmul.v", file=f)
            print("read_verilog -defer ../rvb_shifter/rvb_shifter.v", file=f)
            print("read_verilog -defer ../rvb_simple/rvb_simple.v", file=f)
            print("hierarchy -top rvb_full -chparam XLEN %d" % (xlen,), file=f)
            print("rename rvb_full rvb_full_xlen%d" % (xlen,), file=f)
            print("uniquify; hierarchy -top rvb_full_xlen%d%s" % (xlen, entity), file=f)
            print("synth -flatten; abc -g cmos; opt -fast", file=f)
            print("tee -a synth.tmp stat -tech cmos", file=f)
        print("design -reset", file=f)
        print("read_verilog -defer ../muldiv/muldiv%d.v" % xlen, file=f)
        print("hierarchy -top MulDiv%d" % (xlen,), file=f)
        print("synth -flatten; abc -g cmos; opt -fast", file=f)
        print("tee -a synth.tmp stat -tech cmos", file=f)

try:
    os.remove("synth.tmp")
except FileNotFoundError:
    pass
os.system("yosys -v1 synth.ys")

with open("synth.out", "w") as f:
    with open("synth.tmp", "r") as t:
        for line in t:
            if "===" in line:
                corename = line.split()[1]
            if "Estimated number of transistors:" in line:
                print("%-32s %10d" % (corename, int(line.split()[-1])), file=f)
