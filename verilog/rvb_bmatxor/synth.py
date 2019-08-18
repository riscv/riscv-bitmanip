#!/usr/bin/env python3

import os

with open("synth.ys", "w") as f:
    for cycles in (0, 8):
        print("design -reset", file=f)
        print("read_verilog -defer rvb_bmatxor.v", file=f)
        print("hierarchy -top rvb_bmatxor -chparam CYCLES %d" % (cycles,), file=f)
        print("rename rvb_bmatxor rvb_bmatxor_cycles%d" % (cycles,), file=f)
        print("synth -flatten; abc -dff -g cmos; opt -fast", file=f)
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
