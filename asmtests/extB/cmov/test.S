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

// rd = (rs2) ? rs1 : rs3
#      s2 s3  s4  s5
#      18 19  20  21
# CMOV rd rs1 rs2 rs3
.macro test_CMOV imm1 imm2 imm3
    WRITE_LOG_N str1
    WRITE_S sep
    li s2, 0
    li s3, \imm1
    li s4, \imm2
    li s5, \imm3
    CMOV 18 19 20 21
    WRITE_RAW s3
    WRITE_S op
    WRITE_RAW s4
    WRITE_S op
    WRITE_RAW s5
    WRITE_S gives
    WRITE_RAW s2
    WRITE_NL
.endm

#if defined(XLEN64)
    #define test_OP(i1, i2, i3) \
        test_CMOV 0x ## i1 0x ## i2 0x ## i3; \
        test_CMOV 0x ## i1 ## i1 0x ## i2 ## i2 0x ## i3 ## i3;
#else
    #define test_OP(i1, i2, i3) \
        test_CMOV 0x ## i1 0x ## i2 0x ## i3;
#endif

START_TEST:

    test_OP(55555555, 00000000, AAAAAAAA)
    test_OP(55555555, 00000001, AAAAAAAA)
    test_OP(55555555, 00000002, AAAAAAAA)
    test_OP(55555555, 00000004, AAAAAAAA)
    test_OP(55555555, 00000008, AAAAAAAA)
    test_OP(55555555, 00000010, AAAAAAAA)
    test_OP(55555555, 00000020, AAAAAAAA)
    test_OP(55555555, 00000040, AAAAAAAA)
    test_OP(55555555, 00000080, AAAAAAAA)
    test_OP(55555555, 00000100, AAAAAAAA)
    test_OP(55555555, 00000200, AAAAAAAA)
    test_OP(55555555, 00000400, AAAAAAAA)
    test_OP(55555555, 00000800, AAAAAAAA)
    test_OP(55555555, 00001000, AAAAAAAA)
    test_OP(55555555, 00002000, AAAAAAAA)
    test_OP(55555555, 00004000, AAAAAAAA)
    test_OP(55555555, 00008000, AAAAAAAA)
    test_OP(55555555, 00010000, AAAAAAAA)
    test_OP(55555555, 00020000, AAAAAAAA)
    test_OP(55555555, 00040000, AAAAAAAA)
    test_OP(55555555, 00080000, AAAAAAAA)
    test_OP(55555555, 00100000, AAAAAAAA)
    test_OP(55555555, 00200000, AAAAAAAA)
    test_OP(55555555, 00400000, AAAAAAAA)
    test_OP(55555555, 00800000, AAAAAAAA)
    test_OP(55555555, 01000000, AAAAAAAA)
    test_OP(55555555, 02000000, AAAAAAAA)
    test_OP(55555555, 04000000, AAAAAAAA)
    test_OP(55555555, 08000000, AAAAAAAA)
    test_OP(55555555, 10000000, AAAAAAAA)
    test_OP(55555555, 20000000, AAAAAAAA)
    test_OP(55555555, 40000000, AAAAAAAA)
    test_OP(55555555, 80000000, AAAAAAAA)

    EXIT_TEST

str1:
    .string "Testing CMOV"

sep:
    .string " "

gives:
    .string " => "

op:
    .string " (OP) "
