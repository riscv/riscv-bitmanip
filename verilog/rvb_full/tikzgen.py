#!/usr/bin/env python3

import math
from sympy import *

zbb32 = None
data32 = dict()
data64 = dict()

with open("synth.out", "r") as f:
    for line in f:
        line = line.split()
        if "32" in line[0]:
            data32[line[0].replace("_xlen32", "").replace("32", "").split(".")[-1]] = int(line[1]) // 4
        else:
            data64[line[0].replace("_xlen64", "").replace("64", "").split(".")[-1]] = int(line[1]) // 4

with open("../rvb_zbb32/synth.out", "r") as f:
    for line in f:
        line = line.split()
        if line[0] == "rvb_zbb32":
            zbb32 = int(line[1]) // 4

def solveit(data):
    if "rvb_bmatxor" not in data:
        data["rvb_bmatxor"] = 0

    width, border, span = symbols("width border span", real=True)
    height_bextdep = symbols("height_bextdep", real=True)
    height_bitcnt = symbols("height_bitcnt", real=True)
    height_bmatxor = symbols("height_bmatxor", real=True)
    height_clmul = symbols("height_clmul", real=True)
    height_shifter = symbols("height_shifter", real=True)
    height_simple = symbols("height_simple", real=True)
    height_crc = symbols("height_crc", real=True)

    system = list()
    system.append(Eq(width*width, data["rvb_full"]))
    system.append(Eq((width-2*border)*(width-2*border), data["rvb_bextdep"] + data["rvb_bitcnt"] +
            data["rvb_bmatxor"] + data["rvb_clmul"] + data["rvb_shifter"] + data["rvb_simple"] + data["rvb_crc"]))
    system.append(Eq((width-2*border)*span, data["rvb_bextdep"] + data["rvb_shifter"] + data["rvb_simple"]))
    system.append(Eq(height_bextdep*span, data["rvb_bextdep"]))
    system.append(Eq(height_shifter*span, data["rvb_shifter"]))
    system.append(Eq(height_simple*span, data["rvb_simple"]))
    system.append(Eq(height_bitcnt*(width-2*border-span), data["rvb_bitcnt"]))
    system.append(Eq(height_bmatxor*(width-2*border-span), data["rvb_bmatxor"]))
    system.append(Eq(height_clmul*(width-2*border-span), data["rvb_clmul"]))
    system.append(Eq(height_crc*(width-2*border-span), data["rvb_crc"]))

    variables = [width, border, span, height_bextdep, height_bitcnt, height_bmatxor, height_clmul, height_shifter, height_simple, height_crc]
    solutions = nonlinsolve(system, variables)

    solution = None
    for sol in solutions:
        found_neg = False
        for var, val in zip(variables, sol):
            if float(val) < 0: found_neg = True
        if not found_neg:
            assert solution is None
            solution = sol

    assert solution is not None
    assert len(variables) == len(solution)

    geodata = dict()
    for var, val in zip(variables, solution):
        geodata[str(var)] = float(val)
    geodata["width_muldiv"] = math.sqrt(data["MulDiv"])
    return geodata

def drawit(sz, tdata, data, zbb=None):
    print("%", data)
    scale = sz / data["width_muldiv"]

    width = scale * data["width"]
    border = scale * data["border"]
    span = scale * data["span"]

    height_bextdep = scale * data["height_bextdep"]
    height_bitcnt = scale * data["height_bitcnt"]
    height_bmatxor = scale * data["height_bmatxor"]
    height_clmul = scale * data["height_clmul"]
    height_shifter = scale * data["height_shifter"]
    height_simple = scale * data["height_simple"]
    height_crc = scale * data["height_crc"]

    width_muldiv = scale * data["width_muldiv"]

    print("\\begin{tikzpicture}")

    print("\\draw [fill=red, opacity=0.2] (%f,0) rectangle (-1,%f);" % (-width_muldiv-1, width_muldiv))
    print("\\node (label) at (%f,%f) [below right, align=left, style={font=\\tiny\\tt}] {Rocket MulDiv \\\\ %d gates};" % (-width_muldiv-1, width_muldiv, tdata["MulDiv"]))

    if zbb is not None:
        width_zbb = scale * math.sqrt(zbb)
        print("\\draw [fill=red, opacity=0.2] (%f,0) rectangle (%f,%f);" % (-width_muldiv-2-width_zbb, -width_muldiv-2, width_zbb))
        print("\\node (label) at (%f,%f) [below right, align=left, style={font=\\tiny\\tt}] {rvb\\_zbb32 \\\\ %d gates};" % (-width_muldiv-2-width_zbb, width_zbb, zbb))

    print("\\draw [fill=red, opacity=0.2] (0,0) rectangle (%f,%f);" % (width, width))
    print("\\draw [draw=black!20, fill=white] (%f,%f) rectangle (%f,%f);" % (border-0.05, border-0.05, width-border+0.05, width-border+0.05))

    cursor = border

    print("\\draw [draw=black, fill=blue, opacity=0.2] (%f,%f) rectangle (%f,%f);" % (border+0.05, cursor+0.05, border+span-0.05, cursor+height_bextdep-0.05))
    print("\\node (label) at (%f,%f) [below right, align=left, style={font=\\tiny\\tt}] {rvb\\_bextdep \\\\ %d gates};" % (border+0.05, cursor+height_bextdep-0.05, tdata["rvb_bextdep"]))
    cursor += height_bextdep

    print("\\draw [draw=black, fill=blue, opacity=0.2] (%f,%f) rectangle (%f,%f);" % (border+0.05, cursor+0.05, border+span-0.05, cursor+height_shifter-0.05))
    print("\\node (label) at (%f,%f) [below right, align=left, style={font=\\tiny\\tt}] {rvb\\_shifter \\\\ %d gates};" % (border+0.05, cursor+height_shifter-0.05, tdata["rvb_shifter"]))
    cursor += height_shifter

    print("\\draw [draw=black, fill=blue, opacity=0.2] (%f,%f) rectangle (%f,%f);" % (border+0.05, cursor+0.05, border+span-0.05, cursor+height_simple-0.05))
    print("\\node (label) at (%f,%f) [below right, align=left, style={font=\\tiny\\tt}] {rvb\\_simple \\\\ %d gates};" % (border+0.05, cursor+height_simple-0.05, tdata["rvb_simple"]))
    cursor += height_simple

    cursor = border

    print("\\draw [draw=black, fill=blue, opacity=0.2] (%f,%f) rectangle (%f,%f);" % (border+span+0.05, cursor+0.05, width-border-0.05, cursor+height_bitcnt-0.05))
    print("\\node (label) at (%f,%f) [below right, align=left, style={font=\\tiny\\tt}] {rvb\\_bitcnt \\\\ %d gates};" % (border+span+0.05, cursor+height_bitcnt-0.05, tdata["rvb_bitcnt"]))
    cursor += height_bitcnt

    if tdata["rvb_bmatxor"]:
        print("\\draw [draw=black, fill=blue, opacity=0.2] (%f,%f) rectangle (%f,%f);" % (border+span+0.05, cursor+0.05, width-border-0.05, cursor+height_bmatxor-0.05))
        print("\\node (label) at (%f,%f) [below right, align=left, style={font=\\tiny\\tt}] {rvb\\_bmatxor \\\\ %d gates};" % (border+span+0.05, cursor+height_bmatxor-0.05, tdata["rvb_bmatxor"]))
        cursor += height_bmatxor

    print("\\draw [draw=black, fill=blue, opacity=0.2] (%f,%f) rectangle (%f,%f);" % (border+span+0.05, cursor+0.05, width-border-0.05, cursor+height_clmul-0.05))
    print("\\node (label) at (%f,%f) [below right, align=left, style={font=\\tiny\\tt}] {rvb\\_clmul \\\\ %d gates};" % (border+span+0.05, cursor+height_clmul-0.05, tdata["rvb_clmul"]))
    cursor += height_clmul

    print("\\draw [draw=black, fill=blue, opacity=0.2] (%f,%f) rectangle (%f,%f);" % (border+span+0.05, cursor+0.05, width-border-0.05, cursor+height_crc-0.05))
    print("\\node (label) at (%f,%f) [below right, align=left, style={font=\\tiny\\tt}] {rvb\\_crc \\\\ %d gates};" % (border+span+0.05, cursor+height_crc-0.05, tdata["rvb_crc"]))
    cursor += height_crc

    print("\\end{tikzpicture}")

drawit(4, data32, solveit(data32), zbb32)
drawit(5, data64, solveit(data64))
