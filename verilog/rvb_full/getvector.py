#!/usr/bin/env python3

from Verilog_VCD.Verilog_VCD import parse_vcd
from sys import argv
from os import system
import re

cycle = 10
pcpi = dict()

for netinfo in parse_vcd(argv[1]).values():
    for net in netinfo['nets']:
        if net["hier"] == "bmc" and net["name"] in ["pcpi_valid", "pcpi_insn", "pcpi_rs1", "pcpi_rs2", "pcpi_rs3"]:
            pcpi[net["name"].replace("pcpi_", "")] = dict(netinfo['tv'])[cycle]

# print(pcpi)
assert pcpi["valid"] == '1'

insn = int(pcpi["insn"], 2)
rs = list([int(pcpi[i], 2) for i in ["rs1", "rs2", "rs3"]])
# print("0x%08x" % insn, rs)

with open("getvector.s", "w") as f:
    print(".word 0x%08x" % insn, file=f)

system("/opt/riscv64b/bin/riscv64-unknown-elf-gcc -c -march=rv32imb -mabi=ilp32 getvector.s")
system("/opt/riscv64b/bin/riscv64-unknown-elf-objdump -d -M numeric,no-aliases getvector.o | grep '^  *0:' > getvector.x")

with open("getvector.x", "r") as f:
    for line in f:
        line = line.split()
        # print(line)
        assert line[1] == ("%08x" % insn)
        op = [line[2]]
        args = line[3].split(",")
        # print(op, args)
        assert re.fullmatch(r"x[0-9][0-9]?", args[0])

for a in args[1:]:
    if re.fullmatch(r"x[0-9][0-9]?", a):
        op.append("%08x" % rs[0])
        rs = rs[1:]

print("%-15s" % op[0], " ".join(op[1:]))

system("rm -f getvector.s getvector.o getvector.x")
