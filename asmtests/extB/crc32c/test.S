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

#      s2 s3
#      18 19
# CRC  rd rs1
.macro test_CRC32C_B imm1
    WRITE_LOG_N str1
    WRITE_S sep
    li s2, 0
    li s3, \imm1
    CRC32C_B 18 19
    WRITE_S op
    WRITE_RAW s3
    WRITE_S gives
    WRITE_RAW s2
    WRITE_NL
.endm

.macro test_CRC32C_H imm1
    WRITE_LOG_N str2
    WRITE_S sep
    li s2, 0
    li s3, \imm1
    CRC32C_H 18 19
    WRITE_S op
    WRITE_RAW s3
    WRITE_S gives
    WRITE_RAW s2
    WRITE_NL
.endm

.macro test_CRC32C_W imm1
    WRITE_LOG_N str3
    WRITE_S sep
    li s2, 0
    li s3, \imm1
    CRC32C_W 18 19
    WRITE_S op
    WRITE_RAW s3
    WRITE_S gives
    WRITE_RAW s2
    WRITE_NL
.endm

.macro test_OP imm1
    test_CRC32C_B \imm1
    test_CRC32C_H \imm1
    test_CRC32C_W \imm1
.endm

START_TEST:
    test_OP 0x00000000

    test_OP 0x00000001
    test_OP 0x00000002
    test_OP 0x00000004
    test_OP 0x00000008
    test_OP 0x00000010
    test_OP 0x00000020
    test_OP 0x00000040
    test_OP 0x00000080
    test_OP 0x00000100
    test_OP 0x00000200
    test_OP 0x00000400
    test_OP 0x00000800
    test_OP 0x00001000
    test_OP 0x00002000
    test_OP 0x00004000
    test_OP 0x00008000
    test_OP 0x00010000
    test_OP 0x00020000
    test_OP 0x00040000
    test_OP 0x00080000
    test_OP 0x00100000
    test_OP 0x00200000
    test_OP 0x00400000
    test_OP 0x00800000
    test_OP 0x01000000
    test_OP 0x02000000
    test_OP 0x04000000
    test_OP 0x08000000
    test_OP 0x10000000
    test_OP 0x20000000
    test_OP 0x40000000
    test_OP 0x80000000

    EXIT_TEST

str1:
    .string "Testing CRC32C_B"

str2:
    .string "Testing CRC32C_H"

str3:
    .string "Testing CRC32C_W"

sep:
    .string " "

gives:
    .string " => "

op:
    .string " (OP) "
