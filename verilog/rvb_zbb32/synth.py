#!/usr/bin/env python3

import os

with open("synth.ys", "w") as f:
    for entity in ("", "_decoder"):
        print("design -reset", file=f)
        print("read_verilog rvb_zbb32.v", file=f)
        print("hierarchy -top rvb_zbb32%s" % entity, file=f)
        print("synth -flatten; abc -g cmos; opt -fast", file=f)
        print("tee -a synth.tmp stat -tech cmos", file=f)
        print("tee -a synth.tmp ltp -noff", file=f)

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
                coresize = int(line.split()[-1])
            if "Longest topological path in" in line:
                coredelay = int(line.split("=")[-1].split(")")[0])
                print("%-32s %10d %5d" % (corename, coresize, coredelay), file=f)
