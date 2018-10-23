#!/usr/bin/env python3

import re

core_list = [
    "ror",
    "tinygrev",
    "simplegrev",
    "tinygzip",
    "simplegzip",
    "simplebitcnt",
    "simplebfxp",
    "simplebextdep",
    "smartbextdep",
    "XBitmanip",
    "rocketmuldiv",
    "simplemul",
    "simpleclmul",
    "deltaclmul",
    "tinybmat",
    "simplebmat",
]

core_data = dict()

for core in core_list:
    if core in ("XBitmanip", "deltaclmul"):
        continue
    ff_count = 0
    lut_count = 0
    gates_count = 0
    lut_depth = None
    gate_depth = None
    with open("stats_%s_asic.txt" % core, "r") as f:
        for line in f:
            if line.startswith("Longest topological path"):
                m = re.search("length=(\d+)", line)
                gate_depth = int(m.group(1))
                continue
            line = line.split()
            if len(line) != 2: continue
            if line[0] == "$_NOT_":
                gates_count += 0.5*int(line[1])
            elif line[0] in ["$_NAND_", "$_NOR_"]:
                gates_count += int(line[1])
            elif line[0] in ["$_AOI3_", "$_OAI3_"]:
                gates_count += 1.5*int(line[1])
            elif line[0] in ["$_AOI4_", "$_OAI4_"]:
                gates_count += 2*int(line[1])
            elif line[0] in ["$_DFF_P_", "ror"]:
                continue
            else:
                print(line)
                assert 0
    with open("stats_%s_fpga.txt" % core, "r") as f:
        for line in f:
            if line.startswith("Longest topological path"):
                m = re.search("length=(\d+)", line)
                lut_depth = int(m.group(1))
                continue
            line = line.split()
            if len(line) != 2: continue
            if line[0] == "$lut":
                lut_count += int(line[1])
            elif line[0] == "$_DFF_P_":
                ff_count += int(line[1])
            elif line[0] in ["ror"]:
                continue
            else:
                assert 0
    core_data[core] = (ff_count, lut_count, int(gates_count), lut_depth, gate_depth)

ff_count = 0
lut_count = 0
gates_count = 0
lut_depth = 0
gate_depth = 0

for core in ["simplegrev", "simplegzip", "smartbextdep", "simplebitcnt"]:
    ff_count += core_data[core][0]
    lut_count += core_data[core][1]
    gates_count += core_data[core][2]
    lut_depth = max(lut_depth, core_data[core][3])
    gate_depth = max(gate_depth, core_data[core][4])

core_data["XBitmanip"] = (ff_count, lut_count, gates_count, lut_depth, gate_depth)

core_data["deltaclmul"] = (
    core_data["simpleclmul"][0] - core_data["simplemul"][0],
    core_data["simpleclmul"][1] - core_data["simplemul"][1],
    core_data["simpleclmul"][2] - core_data["simplemul"][2],
    "---", "---"
)

def maketikzpicture(scale):
    ffs_scale = scale * 0.8 / core_data["ror"][0]
    luts_scale = scale * 2.0 / core_data["ror"][1]
    gates_scale = scale * 2.0 / core_data["ror"][2]

    ffs_scale = 5*gates_scale

    print(r"1 LUT $\hat{=}$ %.2f Gates, 1 FF $\hat{=}$ %.2f Gates \\" % (luts_scale / gates_scale, ffs_scale / gates_scale))

    print(r"\begin{center}")
    print(r"\begin{tikzpicture}")

    y = ffs_scale*core_data["ror"][0]
    while y < 0.7:
        print(r"\draw[gray!20] (0,%.3f) -- (%.3f,%.3f);" % (-y, 0.5 + len(core_list), -y))
        y += ffs_scale*core_data["ror"][0]

    y = luts_scale*core_data["ror"][1]
    while y < 3.5:
        print(r"\draw[gray!20] (0,%.3f) -- (%.3f,%.3f);" % (y, 0.5 + len(core_list), y))
        y += luts_scale*core_data["ror"][1]

    print(r"""
\fill[white] (0,2.5) rectangle (4,4);

\draw[-latex] (0,0) -- (0,4);
\draw (-0.2,4) node[left,rotate=90] {\tiny Logic (LUTs or Gates)};

\draw[-latex] (0,0) -- (0,-1);
\draw (-0.2,-1) node[right,rotate=90] {\tiny FFs};

\draw[pattern=north west lines, pattern color=blue] (0.25,3.5) rectangle (0.5,3.75);
\draw[pattern=crosshatch dots, pattern color=green] (0.25,3.0) rectangle (0.5,3.25);
\draw[pattern=crosshatch, pattern color=magenta] (0.25,2.5) rectangle (0.5,2.75);

\draw (0.5,3.5 + 0.125) node[right] {\tiny ASIC Gates (ror $=$ %d)};
\draw (0.5,3.0 + 0.125) node[right] {\tiny FPGA 4-LUTs (ror $=$ %d)};
\draw (0.5,2.5 + 0.125) node[right] {\tiny D-FFs (ror $=$ %d)};
""" % (core_data["ror"][2], core_data["ror"][1], core_data["ror"][0]))

    for idx, core in enumerate(core_list):
        ffs, luts, gates, ldep, gdep = core_data[core]
        corename = core if core != "rocketmuldiv" else "Rocket MulDiv"
        print(r"\draw (%.3f,0) node[above right,rotate=90] {\tiny\tt %s};" % (0.55+idx, corename))
        print(r"\fill[white] (%.3f,0) rectangle (%.3f,%.3f);" % (0.5+idx, 0.75+idx, gates_scale*gates))
        print(r"\fill[white] (%.3f,0) rectangle (%.3f,%.3f);" % (0.75+idx, 1.00+idx, luts_scale*luts))
        print(r"\fill[white] (%.3f,0) rectangle (%.3f,%.3f);" % (0.5+idx, 1.0+idx, -ffs_scale*ffs))
        print(r"\draw[pattern=north west lines, pattern color=blue] (%.3f,0) rectangle (%.3f,%.3f);" % (0.5+idx, 0.75+idx, gates_scale*gates))
        print(r"\draw[pattern=crosshatch dots, pattern color=green] (%.3f,0) rectangle (%.3f,%.3f);" % (0.75+idx, 1.00+idx, luts_scale*luts))
        print(r"\draw[pattern=crosshatch, pattern color=magenta] (%.3f,0) rectangle (%.3f,%.3f);" % (0.5+idx, 1.0+idx, -ffs_scale*ffs))

    print(r"\draw (0,0) -- (%.3f,0);" % (0.5 + len(core_list)))
    print(r"\end{tikzpicture}")
    print(r"\end{center}")

print(r"""
\documentclass{report}
\usepackage{tikz}
\usetikzlibrary{patterns}
\begin{document}
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
""")

maketikzpicture(0.17)

print(r"""
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
\begin{center}
\begin{tabular}{l|rr|rr|r}
Module & Gates & Depth & 4-LUTs & Depth & FFs \\
""")

for core in core_list:
    ffs, luts, gates, ldep, gdep = core_data[core]
    if core in ["ror", "tinygrev", "tinygzip", "simplebitcnt", "simplebfxp", "simplebextdep", "XBitmanip", "simplemul", "tinybmat"]:
        print(r"\hline")
    corename = core if core != "rocketmuldiv" else "Rocket MulDiv"
    print(r"{\tt %s} & %d & %s & %d & %s & %d \\" % (corename, gates, gdep, luts, ldep, ffs))

print(r"""
\end{tabular}
\end{center}
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
""")

# core_list = [core for core in core_list if core != "rocketmuldiv"]
# maketikzpicture(1.0)

print(r"""
\end{document}
""")

