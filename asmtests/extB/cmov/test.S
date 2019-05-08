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

START_TEST:

    test_CMOV 0x55555555 0x00000000 0xAAAAAAAA
    test_CMOV 0x55555555 0x00000001 0xAAAAAAAA
    test_CMOV 0x55555555 0x00000002 0xAAAAAAAA
    test_CMOV 0x55555555 0x00000004 0xAAAAAAAA
    test_CMOV 0x55555555 0x00000008 0xAAAAAAAA
    test_CMOV 0x55555555 0x00000010 0xAAAAAAAA
    test_CMOV 0x55555555 0x00000020 0xAAAAAAAA
    test_CMOV 0x55555555 0x00000040 0xAAAAAAAA
    test_CMOV 0x55555555 0x00000080 0xAAAAAAAA
    test_CMOV 0x55555555 0x00000100 0xAAAAAAAA
    test_CMOV 0x55555555 0x00000200 0xAAAAAAAA
    test_CMOV 0x55555555 0x00000400 0xAAAAAAAA
    test_CMOV 0x55555555 0x00000800 0xAAAAAAAA
    test_CMOV 0x55555555 0x00001000 0xAAAAAAAA
    test_CMOV 0x55555555 0x00002000 0xAAAAAAAA
    test_CMOV 0x55555555 0x00004000 0xAAAAAAAA
    test_CMOV 0x55555555 0x00008000 0xAAAAAAAA
    test_CMOV 0x55555555 0x00010000 0xAAAAAAAA
    test_CMOV 0x55555555 0x00020000 0xAAAAAAAA
    test_CMOV 0x55555555 0x00040000 0xAAAAAAAA
    test_CMOV 0x55555555 0x00080000 0xAAAAAAAA
    test_CMOV 0x55555555 0x00100000 0xAAAAAAAA
    test_CMOV 0x55555555 0x00200000 0xAAAAAAAA
    test_CMOV 0x55555555 0x00400000 0xAAAAAAAA
    test_CMOV 0x55555555 0x00800000 0xAAAAAAAA
    test_CMOV 0x55555555 0x01000000 0xAAAAAAAA
    test_CMOV 0x55555555 0x02000000 0xAAAAAAAA
    test_CMOV 0x55555555 0x04000000 0xAAAAAAAA
    test_CMOV 0x55555555 0x08000000 0xAAAAAAAA
    test_CMOV 0x55555555 0x10000000 0xAAAAAAAA
    test_CMOV 0x55555555 0x20000000 0xAAAAAAAA
    test_CMOV 0x55555555 0x40000000 0xAAAAAAAA
    test_CMOV 0x55555555 0x80000000 0xAAAAAAAA

    EXIT_TEST

str1:
    .string "Testing CMOV"

sep:
    .string " "

gives:
    .string " => "

op:
    .string " (OP) "
