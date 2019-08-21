#!/usr/bin/env python3

from sympy import *

data32 = dict()
data64 = dict()

with open("synth.out", "r") as f:
    for line in f:
        line = line.split()
        if "32" in line[0]:
            data32[line[0].replace("_xlen32", "").split(".")[-1]] = int(line[1])
        else:
            data64[line[0].replace("_xlen64", "").split(".")[-1]] = int(line[1])

def solveit(data):
    if "rvb_bmatxor" not in data:
        data["rvb_bmatxor"] = 0

    width, border, span = symbols("width border span", real=True)
    heigh_bextdep = symbols("heigh_bextdep", real=True)
    heigh_bitcnt = symbols("heigh_bitcnt", real=True)
    heigh_bmatxor = symbols("heigh_bmatxor", real=True)
    heigh_clmul = symbols("heigh_clmul", real=True)
    heigh_shifter = symbols("heigh_shifter", real=True)
    heigh_simple = symbols("heigh_simple", real=True)

    system = list()
    system.append(Eq(width*width, data["rvb_full"]))
    system.append(Eq((width-2*border)*(width-2*border), data["rvb_bextdep"] + data["rvb_bitcnt"] +
            data["rvb_bmatxor"] + data["rvb_clmul"] + data["rvb_shifter"] + data["rvb_simple"]))
    system.append(Eq((width-2*border)*span, data["rvb_bextdep"] + data["rvb_shifter"] + data["rvb_simple"]))
    system.append(Eq(heigh_bextdep*span, data["rvb_bextdep"]))
    system.append(Eq(heigh_shifter*span, data["rvb_shifter"]))
    system.append(Eq(heigh_simple*span, data["rvb_simple"]))
    system.append(Eq(heigh_bitcnt*(width-2*border-span), data["rvb_bitcnt"]))
    system.append(Eq(heigh_bmatxor*(width-2*border-span), data["rvb_bmatxor"]))
    system.append(Eq(heigh_clmul*(width-2*border-span), data["rvb_clmul"]))

    variables = [width, border, span, heigh_bextdep, heigh_bitcnt, heigh_bmatxor, heigh_clmul, heigh_shifter, heigh_simple]
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
        geodata[var] = float(val)
    return geodata

print(data32)
print(solveit(data32))

print(data64)
print(solveit(data64))
