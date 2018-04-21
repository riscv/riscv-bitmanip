#!/usr/bin/env python3

with open("cproofs/common.h", "r") as infile:
    outfile = None
    for line in infile:
        if line.startswith("// --REF-BEGIN-- "):
            name = line.split()[2]
            outfile = open("bextcref-%s.tex" % name, "w")
            print("\\begin{verbatim}", file=outfile)
        elif line.startswith("// --REF-END--"):
            print("\\end{verbatim}", file=outfile)
            outfile.close()
            outfile = None
        elif outfile is not None:
            if "// NOREF" not in line:
                print("  " + line.replace("\t", "    "), end="", file=outfile)
    assert outfile is None

