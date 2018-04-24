#!/usr/bin/env python3

with open("cproofs/common.h", "r") as infile:
    outfile = None
    breakstate = 1
    for line in infile:
        if line.startswith("// --REF-BEGIN-- "):
            name = line.split()[2]
            outfile = open("bextcref-%s.tex" % name, "w")
            print("\\begin{minipage}{\linewidth}", file=outfile)
            print("\\begin{verbatim}", file=outfile)
            breakstate = 1
        elif line.startswith("// --REF-END--"):
            print("\\end{verbatim}", file=outfile)
            print("\\end{minipage}", file=outfile)
            outfile.close()
            outfile = None
        elif line.strip() == "" and breakstate != 2:
            if breakstate != 1 and outfile is not None:
                print("\\end{verbatim}", file=outfile)
                print("\\end{minipage}", file=outfile)
                print("", file=outfile)
                print("\\begin{minipage}{\linewidth}", file=outfile)
                print("\\begin{verbatim}", file=outfile)
            breakstate = 1
        elif outfile is not None:
            if "// NOREF" not in line:
                print("  " + line.replace("\t", "    "), end="", file=outfile)
                breakstate = 0 if len(line) and line[0] not in " \t" else 2
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

with open("bextcref-printperm-rot.tex", "w") as outfile:
    print("\\begin{tikzpicture}", file=outfile)

    for i in range(5):
        for j in range(32):
            print("\\draw[dashed,gray!50] (%.3f, %d) -- (%.3f, %d);" % (j * 0.375, i * 2, j * 0.375, i * 2 + 2), file=outfile)
        for j in range(32):
            k = ror_permdata[j][1 << i]
            print("\\draw (%.3f, %d) -- (%.3f, %d);" % ((31-k) * 0.375, i * 2, (31-j) * 0.375, i * 2 + 2), file=outfile)
        print("\\node[align=center] at (%.3f, %d) {ror stage %d \\\\ ({\\tt shamt[%d]})};" % (1.5 + 32 * 0.375, i * 2 + 1, i, i), file=outfile)

    for i in range(6):
        for j in range(32):
            print("\\filldraw[fill=white, draw=black] (%.3f, %d) circle (1mm);" % (j * 0.375, i * 2), file=outfile)

    print("\\end{tikzpicture}", file=outfile)

with open("bextcref-printperm-grev.tex", "w") as outfile:
    print("\\begin{tikzpicture}", file=outfile)

    for i in range(5):
        for j in range(32):
            print("\\draw[dashed,gray!50] (%.3f, %d) -- (%.3f, %d);" % (j * 0.375, i * 2, j * 0.375, i * 2 + 2), file=outfile)
        for j in range(32):
            k = grev_permdata[j][1 << i]
            print("\\draw (%.3f, %d) -- (%.3f, %d);" % (k * 0.375, i * 2, j * 0.375, i * 2 + 2), file=outfile)
        print("\\node[align=center] at (%.3f, %d) {grev stage %d \\\\ ({\\tt shamt[%d]})};" % (1.5 + 32 * 0.375, i * 2 + 1, i, i), file=outfile)

    for i in range(6):
        for j in range(32):
            print("\\filldraw[fill=white, draw=black] (%.3f, %d) circle (1mm);" % (j * 0.375, i * 2), file=outfile)

    print("\\end{tikzpicture}", file=outfile)

with open("bextcref-printperm-gzip-flip.tex", "w") as outfile:
    print("\\begin{tikzpicture}[yscale=0.8]", file=outfile)

    for i in range(4):
        for j in range(32):
            k = gzip_permdata[j][1 << (i+1)]
            if k != j:
                print("\\draw[dashed,gray!50] (%.3f, %d) -- (%.3f, %d);" % (j * 0.375, i * 2 + 2, j * 0.375, i * 2 + 4), file=outfile)
        for j in range(32):
            k = gzip_permdata[j][1 << (i+1)]
            print("\\draw (%.3f, %d) -- (%.3f, %d);" % (k * 0.375, i * 2 + 2, j * 0.375, i * 2 + 4), file=outfile)
        print("\\node at (%.3f, %d) {gzip stage %d};" % (1.5 + 32 * 0.375, i * 2 + 3, i), file=outfile)

    for i in [0, 5]:
        for j in range(32):
            k = gzipflip_permdata[j]
            if k != j:
                print("\\draw[dashed,gray!50] (%.3f, %d) -- (%.3f, %d);" % (j * 0.375, i * 2, j * 0.375, i * 2 + 2), file=outfile)
        for j in range(32):
            k = gzipflip_permdata[j]
            print("\\draw (%.3f, %d) -- (%.3f, %d);" % (k * 0.375, i * 2, j * 0.375, i * 2 + 2), file=outfile)
        print("\\node at (%.3f, %d) {gzip flip};" % (1.5 + 32 * 0.375, i * 2 + 1), file=outfile)

    for i in range(7):
        for j in range(32):
            print("\\filldraw[fill=white, draw=black] (%.3f, %d) circle (1mm);" % (j * 0.375, i * 2), file=outfile)

    print("\\end{tikzpicture}", file=outfile)

with open("bextcref-printperm-gzip-noflip.tex", "w") as outfile:
    print("\\begin{tikzpicture}[yscale=0.8]", file=outfile)

    for i in range(4):
        offset = 1 + 32 * 0.15
        for j in range(32):
            k = gzip_permdata[j][1 << (4-i)]
            if k != j:
                print("\\draw[dashed,gray!50] (%.3f, %d) -- (%.3f, %d);" % (j * 0.15, i * 2, j * 0.15, i * 2 + 2), file=outfile)
            k = gzip_permdata[j][1 << (i+1)]
            if k != j:
                print("\\draw[dashed,gray!50] (%.3f, %d) -- (%.3f, %d);" % (offset + j * 0.15, i * 2, offset + j * 0.15, i * 2 + 2), file=outfile)
        for j in range(32):
            k = gzip_permdata[j][1 << (4-i)]
            print("\\draw (%.3f, %d) -- (%.3f, %d);" % (k * 0.15, i * 2, j * 0.15, i * 2 + 2), file=outfile)
            k = gzip_permdata[j][1 << (i+1)]
            print("\\draw (%.3f, %d) -- (%.3f, %d);" % (offset + k * 0.15, i * 2, offset + j * 0.15, i * 2 + 2), file=outfile)
        print("\\node at (%.3f, %d) {\\tt mode[%d]};" % (2.5 + 64 * 0.15, i * 2 + 1, i+1), file=outfile)

    for j in range(32):
        print("\\draw[dashed,gray!50] (%.3f, 0) -- (%.3f, -2);" % (offset + j * 0.15, offset/2 + j * 0.15), file=outfile)
    for j in range(32):
        print("\\draw (%.3f, 0) -- (%.3f, -2);" % (j * 0.15, offset/2 + j * 0.15), file=outfile)
        print("\\filldraw[fill=white, draw=black] (%.3f, %d) circle (0.5mm);" % (offset/2 + j * 0.15, -2), file=outfile)
    print("\\node at (%.3f, %d) {\\tt mode[0]};" % (2.5 + 64 * 0.15, -1), file=outfile)

    for i in range(5):
        for j in range(32):
            print("\\filldraw[fill=white, draw=black] (%.3f, %d) circle (0.5mm);" % (j * 0.15, i * 2), file=outfile)
            print("\\filldraw[fill=white, draw=black] (%.3f, %d) circle (0.5mm);" % (offset + j * 0.15, i * 2), file=outfile)

    print("\\end{tikzpicture}", file=outfile)
