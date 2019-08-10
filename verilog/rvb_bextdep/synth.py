#!/usr/bin/env python3

import os

with open("synth.ys", "w") as f:
    for xlen in (32, 64):
        for grev in (0, 1):
            for shfl in (0, 1):
                for ffs in (0, 1, 2, 3):
                    if (xlen, grev, shfl, ffs) == (32, 0, 1, 3): continue  # work-around ABC bug
                    if (xlen, grev, shfl, ffs) == (32, 1, 1, 3): continue  # work-around ABC bug
                    if (xlen, grev, shfl, ffs) == (64, 0, 1, 3): continue  # work-around ABC bug
                    if (xlen, grev, shfl, ffs) == (64, 1, 1, 3): continue  # work-around ABC bug
                    print("design -reset", file=f)
                    print("read_verilog -defer rvb_bextdep.v", file=f)
                    print("hierarchy -top rvb_bextdep -chparam XLEN %d -chparam GREV %d -chparam SHFL %d -chparam FFS %d" % (xlen, grev, shfl, ffs), file=f)
                    print("rename rvb_bextdep rvb_bextdep_xlen%d_grev%d_shfl%d_ffs%d" % (xlen, grev, shfl, ffs), file=f)
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
