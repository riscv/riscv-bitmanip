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

ror_permdata = [list(range(32)) for i in range(32)]
grev_permdata = [list(range(32)) for i in range(32)]
gzip_permdata = [list(range(32)) for i in range(32)]
gzipflip_permdata = list(range(32))

with open("bextcref-printperm.dat", "r") as infile:
    for line in infile:
        line = line.split()
        ror_permdata[int(line[0])][int(line[1])] = int(line[2])
        grev_permdata[int(line[0])][int(line[1])] = int(line[3])
        gzip_permdata[int(line[0])][int(line[1])] = int(line[4])
        gzipflip_permdata[int(line[0])] = int(line[5])

with open("bextcref-printperm.tex", "w") as outfile:
    print("\\begin{center}", file=outfile)
    print("\\begin{tikzpicture}", file=outfile)

    for i in range(5):
        for j in range(32):
            k = ror_permdata[j][1 << i]
            print("\\draw (%.3f, %d) -- (%.3f, %d);" % ((31-k) * 0.375, i * 2, (31-j) * 0.375, i * 2 + 2), file=outfile)
        print("\\node at (%.3f, %d) {ror stage %d};" % (1.5 + 32 * 0.375, i * 2 + 1, i), file=outfile)

    for i in range(6):
        for j in range(32):
            print("\\filldraw[fill=white, draw=black] (%.3f, %d) circle (1mm);" % (j * 0.375, i * 2), file=outfile)

    print("\\end{tikzpicture}", file=outfile)
    print("\\end{center}", file=outfile)

    print("\\newpage", file=outfile)

    print("\\begin{center}", file=outfile)
    print("\\begin{tikzpicture}", file=outfile)

    for i in range(5):
        for j in range(32):
            k = grev_permdata[j][1 << i]
            print("\\draw (%.3f, %d) -- (%.3f, %d);" % (k * 0.375, i * 2, j * 0.375, i * 2 + 2), file=outfile)
        print("\\node at (%.3f, %d) {grev stage %d};" % (1.5 + 32 * 0.375, i * 2 + 1, i), file=outfile)

    for i in range(6):
        for j in range(32):
            print("\\filldraw[fill=white, draw=black] (%.3f, %d) circle (1mm);" % (j * 0.375, i * 2), file=outfile)

    print("\\end{tikzpicture}", file=outfile)
    print("\\end{center}", file=outfile)

    print("\\newpage", file=outfile)

    print("\\begin{center}", file=outfile)
    print("\\begin{tikzpicture}", file=outfile)

    for i in range(4):
        for j in range(32):
            k = gzip_permdata[j][1 << (i+1)]
            print("\\draw (%.3f, %d) -- (%.3f, %d);" % (k * 0.375, i * 2 + 2, j * 0.375, i * 2 + 4), file=outfile)
        print("\\node at (%.3f, %d) {gzip stage %d};" % (1.5 + 32 * 0.375, i * 2 + 3, i), file=outfile)

    for i in [0, 5]:
        for j in range(32):
            k = gzipflip_permdata[j]
            print("\\draw (%.3f, %d) -- (%.3f, %d);" % (k * 0.375, i * 2, j * 0.375, i * 2 + 2), file=outfile)
        print("\\node at (%.3f, %d) {gzip flip};" % (1.5 + 32 * 0.375, i * 2 + 1), file=outfile)

    for i in range(7):
        for j in range(32):
            print("\\filldraw[fill=white, draw=black] (%.3f, %d) circle (1mm);" % (j * 0.375, i * 2), file=outfile)

    print("\\end{tikzpicture}", file=outfile)
    print("\\end{center}", file=outfile)
