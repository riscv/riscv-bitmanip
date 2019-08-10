#!/usr/bin/env python3

def print_bfly(modname, stages):
    print("module %s #(" % modname)
    print("  parameter integer XLEN = 32,")
    print("  parameter integer SHFL = 1,")
    print("  parameter integer GORC = 1")
    print(") (")
    print("  input gorc,")
    print("  input shfl_en,")
    print("  input [4:0] shfl,")
    print("  input [XLEN-1:0] din,")
    print("  input [XLEN/2-1:0] s1, s2, s4, s8, s16, s32,")
    print("  output [XLEN-1:0] dout")
    print(");")
    print("  wire orc = GORC && gorc;")
    print("  wire [4:0] sh = SHFL && shfl_en ? (XLEN == 64 ? shfl : shfl[3:0]) : 5'b0;")
    print("  wire [31:0] x1 = s1, x2 = s2, x4 = s4, x8 = s8, x16 = s16;")
    print("  wire [31:0] x32 = XLEN == 64 ? s32 : 32'b0;")
    print("  wire [63:0] start = din;")
    cursor = "start";

    for stage in stages:
        pwr2 = 1 << stage
        print("  wire [63:0] bfly%d;" % pwr2)

        for i in range(64):
            sidx = None
            oidx = i ^ pwr2
            xidx = ((i >> (stage+1)) << stage) | (i & ((1 << stage)-1))

            # shuffle
            if stage < 5:
                grpsize = 4*pwr2
                grppos = i % grpsize
                grpseg = (4*grppos) // grpsize
                if grpseg == 1: sidx = i + grpsize/4
                if grpseg == 2: sidx = i - grpsize/4

            if sidx is None:
                print("  assign bfly%d[%d] = x%d[%d] ? (%s[%d] | (orc & %s[%d])): %s[%d];" %
                        (pwr2, i, pwr2, xidx, cursor, oidx, cursor, i, cursor, i))
            else:
                print("  assign bfly%d[%d] = sh[%d] ? %s[%d] : (x%d[%d] ? (%s[%d] | (orc & %s[%d])) : %s[%d]);" %
                        (pwr2, i, stage, cursor, sidx, pwr2, xidx, cursor, oidx, cursor, i, cursor, i))

        cursor = "bfly%d" % pwr2

    print("  assign dout = %s;" % cursor)
    print("endmodule")
    pass

print_bfly("rvb_bextdep_butterfly_fwd", range(5, -1, -1))
print_bfly("rvb_bextdep_butterfly_bwd", range(0, 6))
