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

# reg = rs1, rs3
# rd = rotr(reg, rs2)
#      s2 s3  s4  s5
#      18 19  20  21
# FSR rd rs1 rs2 rs3
.macro test_FSR imm1 imm2 imm3
    WRITE_LOG_N str1
    WRITE_S sep
    li s2, 0
    li s3, \imm1
    li s4, \imm2
    li s5, \imm3
    FSR 18 19 20 21
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
        test_FSR 0x ## i1 0x ## i2 0x ## i3; \
        test_FSR 0x ## i1 ## i1 0x ## i2 ## i2 0x ## i3 ## i3;
#else
    #define test_OP(i1, i2, i3) \
        test_FSR 0x ## i1 0x ## i2 0x ## i3;
#endif

START_TEST:
    test_OP(00000000, 00000000, 00000000)
    test_OP(80000001, 00000000, 00000001)
    test_OP(80000001, 00000001, 00000001)
    test_OP(80000001, 00000002, 00000001)
    test_OP(80000001, 00000003, 00000001)
    test_OP(80000001, 00000004, 00000001)
    test_OP(80000001, 00000005, 00000001)
    test_OP(80000001, 00000006, 00000001)
    test_OP(80000001, 00000007, 00000001)
    test_OP(80000001, 00000008, 00000001)
    test_OP(80000001, 00000009, 00000001)
    test_OP(80000001, 0000000A, 00000001)
    test_OP(80000001, 0000000B, 00000001)
    test_OP(80000001, 0000000C, 00000001)
    test_OP(80000001, 0000000D, 00000001)
    test_OP(80000001, 0000000E, 00000001)
    test_OP(80000001, 0000000F, 00000001)
    test_OP(80000001, 00000010, 00000001)
    test_OP(80000001, 00000011, 00000001)
    test_OP(80000001, 00000012, 00000001)
    test_OP(80000001, 00000013, 00000001)
    test_OP(80000001, 00000014, 00000001)
    test_OP(80000001, 00000015, 00000001)
    test_OP(80000001, 00000016, 00000001)
    test_OP(80000001, 00000017, 00000001)
    test_OP(80000001, 00000018, 00000001)
    test_OP(80000001, 00000019, 00000001)
    test_OP(80000001, 0000001A, 00000001)
    test_OP(80000001, 0000001B, 00000001)
    test_OP(80000001, 0000001C, 00000001)
    test_OP(80000001, 0000001D, 00000001)
    test_OP(80000001, 0000001E, 00000001)
    test_OP(80000001, 0000001F, 00000001)
    test_OP(80000001, 00000020, 00000001)
    test_OP(80000001, 00000021, 00000001)
    test_OP(80000001, 00000022, 00000001)
    test_OP(80000001, 00000023, 00000001)
    test_OP(80000001, 00000024, 00000001)
    test_OP(80000001, 00000025, 00000001)
    test_OP(80000001, 00000026, 00000001)
    test_OP(80000001, 00000027, 00000001)
    test_OP(80000001, 00000028, 00000001)
    test_OP(80000001, 00000029, 00000001)
    test_OP(80000001, 0000002A, 00000001)
    test_OP(80000001, 0000002B, 00000001)
    test_OP(80000001, 0000002C, 00000001)
    test_OP(80000001, 0000002D, 00000001)
    test_OP(80000001, 0000002E, 00000001)
    test_OP(80000001, 0000002F, 00000001)
    test_OP(80000001, 00000030, 00000001)
    test_OP(80000001, 00000031, 00000001)
    test_OP(80000001, 00000032, 00000001)
    test_OP(80000001, 00000033, 00000001)
    test_OP(80000001, 00000034, 00000001)
    test_OP(80000001, 00000035, 00000001)
    test_OP(80000001, 00000036, 00000001)
    test_OP(80000001, 00000037, 00000001)
    test_OP(80000001, 00000038, 00000001)
    test_OP(80000001, 00000039, 00000001)
    test_OP(80000001, 0000003A, 00000001)
    test_OP(80000001, 0000003B, 00000001)
    test_OP(80000001, 0000003C, 00000001)
    test_OP(80000001, 0000003D, 00000001)
    test_OP(80000001, 0000003E, 00000001)
    test_OP(80000001, 0000003F, 00000001)
    test_OP(80000001, 00000040, 00000001)
    test_OP(80000001, 00000041, 00000001)
    test_OP(80000001, 00000042, 00000001)
    test_OP(80000001, 00000043, 00000001)
    test_OP(80000001, 00000044, 00000001)
    test_OP(80000001, 00000045, 00000001)
    test_OP(80000001, 00000046, 00000001)
    test_OP(80000001, 00000047, 00000001)
    test_OP(80000001, 00000048, 00000001)
    test_OP(80000001, 00000049, 00000001)
    test_OP(80000001, 0000004A, 00000001)
    test_OP(80000001, 0000004B, 00000001)
    test_OP(80000001, 0000004C, 00000001)
    test_OP(80000001, 0000004D, 00000001)
    test_OP(80000001, 0000004E, 00000001)
    test_OP(80000001, 0000004F, 00000001)

    EXIT_TEST

str1:
    .string "Testing FSR"

sep:
    .string " "

gives:
    .string " => "

op:
    .string " (OP) "
