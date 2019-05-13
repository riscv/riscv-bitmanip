# RISC-V Bit Manipulation Instruction Support
#
# Copyright (c) 2019, Imperas Software Ltd. Additions
# All rights reserved.
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are met:
#      * Redistributions of source code must retain the above copyright
#        notice, this list of conditions and the following disclaimer.
#      * Redistributions in binary form must reproduce the above copyright
#        notice, this list of conditions and the following disclaimer in the
#        documentation and/or other materials provided with the distribution.
#      * the name of Imperas Software Ltd. nor the
#        names of its contributors may be used to endorse or promote products
#        derived from this software without specific prior written permission.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS
# IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO,
# THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR
# PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL Codasip Ltd., Imperas Software Ltd.
# BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
# DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
# LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
# ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
# (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF
# THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
#
.include "extB.S.include"

# use s0(r8)  - s1(r9)
# use s2(r18) - s11(r27)

# rd = min_unsigned(rs1,rs2)
#      s2 s3  s4
#      18 19  20
# MINU rd rs1 rs2
.macro test_MINU imm1 imm2
    WRITE_LOG_N str1
    WRITE_S sep
    li s2, 0
    li s3, \imm1
    li s4, \imm2
    MINU 18 19 20
    WRITE_RAW s3
    WRITE_S op
    WRITE_RAW s4
    WRITE_S gives
    WRITE_RAW s2
    WRITE_NL
.endm

#if defined(XLEN64)
    #define test_OP(i1, i2) \
        test_MINU 0x ## i1 0x ## i2; \
        test_MINU 0x ## i1 ## i1 0x ## i2 ## i2;
#else
    #define test_OP(i1, i2) \
        test_MINU 0x ## i1 0x ## i2;
#endif

START_TEST:
    test_OP(00000000, 00000000)
    test_OP(FFFFFFFF, FFFFFFFF)
    test_OP(00000000, 00000001)
    test_OP(00000002, 00000001)
    test_OP(00000002, 00000004)
    test_OP(00000008, 00000004)
    test_OP(00000008, 00000010)
    test_OP(00000020, 00000010)
    test_OP(00000020, 00000040)
    test_OP(00000080, 00000040)
    test_OP(00000080, 00000100)
    test_OP(00000200, 00000100)
    test_OP(00000200, 00000400)
    test_OP(00000800, 00000400)
    test_OP(00000800, 00001000)
    test_OP(00002000, 00001000)
    test_OP(00002000, 00004000)
    test_OP(00008000, 00004000)
    test_OP(00008000, 00010000)
    test_OP(00020000, 00010000)
    test_OP(00020000, 00040000)
    test_OP(00080000, 00040000)
    test_OP(00080000, 00100000)
    test_OP(00200000, 00100000)
    test_OP(00200000, 00400000)
    test_OP(00800000, 00400000)
    test_OP(00800000, 01000000)
    test_OP(02000000, 01000000)
    test_OP(02000000, 04000000)
    test_OP(08000000, 04000000)
    test_OP(08000000, 10000000)
    test_OP(20000000, 10000000)
    test_OP(20000000, 40000000)
    test_OP(80000000, 40000000)
    test_OP(80000000, 80000000)
    test_OP(00000001, 00000000)
    test_OP(00000001, 00000002)
    test_OP(00000004, 00000002)
    test_OP(00000004, 00000008)
    test_OP(00000010, 00000008)
    test_OP(00000010, 00000020)
    test_OP(00000040, 00000020)
    test_OP(00000040, 00000080)
    test_OP(00000100, 00000080)
    test_OP(00000100, 00000200)
    test_OP(00000400, 00000200)
    test_OP(00000400, 00000800)
    test_OP(00001000, 00000800)
    test_OP(00001000, 00002000)
    test_OP(00004000, 00002000)
    test_OP(00004000, 00008000)
    test_OP(00010000, 00008000)
    test_OP(00010000, 00020000)
    test_OP(00040000, 00020000)
    test_OP(00040000, 00080000)
    test_OP(00100000, 00080000)
    test_OP(00100000, 00200000)
    test_OP(00400000, 00200000)
    test_OP(00400000, 00800000)
    test_OP(01000000, 00800000)
    test_OP(01000000, 02000000)
    test_OP(04000000, 02000000)
    test_OP(04000000, 08000000)
    test_OP(10000000, 08000000)
    test_OP(10000000, 20000000)
    test_OP(40000000, 20000000)
    test_OP(40000000, 80000000)
    test_OP(80000000, 80000000)
    test_OP(FFFFFFFF, FFFFFFFE)
    test_OP(FFFFFFFC, FFFFFFFE)
    test_OP(FFFFFFFC, FFFFFFF8)
    test_OP(FFFFFFF0, FFFFFFF8)
    test_OP(FFFFFFF0, FFFFFFE0)
    test_OP(FFFFFFC0, FFFFFFE0)
    test_OP(FFFFFFC0, FFFFFF80)
    test_OP(FFFFFF00, FFFFFF80)
    test_OP(FFFFFF00, FFFFFE00)
    test_OP(FFFFFC00, FFFFFE00)
    test_OP(FFFFFC00, FFFFF800)
    test_OP(FFFFF000, FFFFF800)
    test_OP(FFFFF000, FFFFE000)
    test_OP(FFFFC000, FFFFE000)
    test_OP(FFFFC000, FFFF8000)
    test_OP(FFFF0000, FFFF8000)
    test_OP(FFFF0000, FFFE0000)
    test_OP(FFFC0000, FFFE0000)
    test_OP(FFFC0000, FFF80000)
    test_OP(FFF00000, FFF80000)
    test_OP(FFF00000, FFE00000)
    test_OP(FFC00000, FFE00000)
    test_OP(FFC00000, FF800000)
    test_OP(FF000000, FF800000)
    test_OP(FF000000, FE000000)
    test_OP(FC000000, FE000000)
    test_OP(FC000000, F8000000)
    test_OP(F0000000, F8000000)
    test_OP(F0000000, E0000000)
    test_OP(C0000000, E0000000)
    test_OP(C0000000, 80000000)
    test_OP(00000000, 80000000)
    test_OP(FFFFFFFE, FFFFFFFF)
    test_OP(FFFFFFFE, FFFFFFFC)
    test_OP(FFFFFFF8, FFFFFFFC)
    test_OP(FFFFFFF8, FFFFFFF0)
    test_OP(FFFFFFE0, FFFFFFF0)
    test_OP(FFFFFFE0, FFFFFFC0)
    test_OP(FFFFFF80, FFFFFFC0)
    test_OP(FFFFFF80, FFFFFF00)
    test_OP(FFFFFE00, FFFFFF00)
    test_OP(FFFFFE00, FFFFFC00)
    test_OP(FFFFF800, FFFFFC00)
    test_OP(FFFFF800, FFFFF000)
    test_OP(FFFFE000, FFFFF000)
    test_OP(FFFFE000, FFFFC000)
    test_OP(FFFF8000, FFFFC000)
    test_OP(FFFF8000, FFFF0000)
    test_OP(FFFE0000, FFFF0000)
    test_OP(FFFE0000, FFFC0000)
    test_OP(FFF80000, FFFC0000)
    test_OP(FFF80000, FFF00000)
    test_OP(FFE00000, FFF00000)
    test_OP(FFE00000, FFC00000)
    test_OP(FF800000, FFC00000)
    test_OP(FF800000, FF000000)
    test_OP(FE000000, FF000000)
    test_OP(FE000000, FC000000)
    test_OP(F8000000, FC000000)
    test_OP(F8000000, F0000000)
    test_OP(E0000000, F0000000)
    test_OP(E0000000, C0000000)
    test_OP(80000000, C0000000)
    test_OP(80000000, 00000000)

    EXIT_TEST

str1:
    .string "Testing MINU"

sep:
    .string " "

gives:
    .string " => "

op:
    .string " (OP) "
