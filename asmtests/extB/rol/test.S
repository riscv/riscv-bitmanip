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

.macro test_ROL imm1 imm2
    WRITE_LOG_N str1
    WRITE_S sep
    li s3, \imm1
    li s4, \imm2
    ROL 18 19 20
    WRITE_RAW s3
    WRITE_S op
    WRITE_RAW s4
    WRITE_S gives
    WRITE_RAW s2
    WRITE_NL
.endm

#if defined(XLEN64)
    #define test_OP(i1, i2) \
        test_ROL 0x ## i1 0x ## i2; \
        test_ROL 0x ## i1 ## i1 0x ## i2 ## i2;
#else
    #define test_OP(i1, i2) \
        test_ROL 0x ## i1 0x ## i2;
#endif

START_TEST:
    test_OP(0000000, 00000000)
    test_OP(0000000, 00000001)
    test_OP(0000000, 00000002)
    test_OP(0000000, 00000003)
    test_OP(0000000, 00000004)
    test_OP(0000000, 00000005)
    test_OP(0000000, 00000006)
    test_OP(0000000, 00000007)
    test_OP(0000000, 00000008)
    test_OP(0000000, 00000009)
    test_OP(0000000, 0000000a)
    test_OP(0000000, 0000000b)
    test_OP(0000000, 0000000c)
    test_OP(0000000, 0000000d)
    test_OP(0000000, 0000000e)
    test_OP(0000000, 0000000f)
    test_OP(0000000, 00000010)
    test_OP(0000000, 00000011)
    test_OP(0000000, 00000012)
    test_OP(0000000, 00000013)
    test_OP(0000000, 00000014)
    test_OP(0000000, 00000015)
    test_OP(0000000, 00000016)
    test_OP(0000000, 00000017)
    test_OP(0000000, 00000018)
    test_OP(0000000, 00000019)
    test_OP(0000000, 0000001a)
    test_OP(0000000, 0000001b)
    test_OP(0000000, 0000001c)
    test_OP(0000000, 0000001d)
    test_OP(0000000, 0000001e)
    test_OP(0000000, 0000001f)
    test_OP(0000000, 00000020)
    test_OP(0000001, 00000000)
    test_OP(0000001, 00000001)
    test_OP(0000001, 00000002)
    test_OP(0000001, 00000003)
    test_OP(0000001, 00000004)
    test_OP(0000001, 00000005)
    test_OP(0000001, 00000006)
    test_OP(0000001, 00000007)
    test_OP(0000001, 00000008)
    test_OP(0000001, 00000009)
    test_OP(0000001, 0000000a)
    test_OP(0000001, 0000000b)
    test_OP(0000001, 0000000c)
    test_OP(0000001, 0000000d)
    test_OP(0000001, 0000000e)
    test_OP(0000001, 0000000f)
    test_OP(0000001, 00000010)
    test_OP(0000001, 00000011)
    test_OP(0000001, 00000012)
    test_OP(0000001, 00000013)
    test_OP(0000001, 00000014)
    test_OP(0000001, 00000015)
    test_OP(0000001, 00000016)
    test_OP(0000001, 00000017)
    test_OP(0000001, 00000018)
    test_OP(0000001, 00000019)
    test_OP(0000001, 0000001a)
    test_OP(0000001, 0000001b)
    test_OP(0000001, 0000001c)
    test_OP(0000001, 0000001d)
    test_OP(0000001, 0000001e)
    test_OP(0000001, 0000001f)
    test_OP(0000001, 00000020)
    test_OP(0000001, 00000000)
    test_OP(0000001, 00000001)
    test_OP(0000001, 00000002)
    test_OP(0000001, 00000003)
    test_OP(0000001, 00000004)
    test_OP(0000001, 00000005)
    test_OP(0000001, 00000006)
    test_OP(0000001, 00000007)
    test_OP(0000001, 00000008)
    test_OP(0000001, 00000009)
    test_OP(0000001, 0000000a)
    test_OP(0000001, 0000000b)
    test_OP(0000001, 0000000c)
    test_OP(0000001, 0000000d)
    test_OP(0000001, 0000000e)
    test_OP(0000001, 0000000f)
    test_OP(0000001, 00000010)
    test_OP(0000001, 00000011)
    test_OP(0000001, 00000012)
    test_OP(0000001, 00000013)
    test_OP(0000001, 00000014)
    test_OP(0000001, 00000015)
    test_OP(0000001, 00000016)
    test_OP(0000001, 00000017)
    test_OP(0000001, 00000018)
    test_OP(0000001, 00000019)
    test_OP(0000001, 0000001a)
    test_OP(0000001, 0000001b)
    test_OP(0000001, 0000001c)
    test_OP(0000001, 0000001d)
    test_OP(0000001, 0000001e)
    test_OP(0000001, 0000001f)
    test_OP(0000001, 00000020)
    test_OP(5555555, 00000000)
    test_OP(5555555, 00000001)
    test_OP(5555555, 00000002)
    test_OP(5555555, 00000003)
    test_OP(5555555, 00000004)
    test_OP(5555555, 00000005)
    test_OP(5555555, 00000006)
    test_OP(5555555, 00000007)
    test_OP(5555555, 00000008)
    test_OP(5555555, 00000009)
    test_OP(5555555, 0000000a)
    test_OP(5555555, 0000000b)
    test_OP(5555555, 0000000c)
    test_OP(5555555, 0000000d)
    test_OP(5555555, 0000000e)
    test_OP(5555555, 0000000f)
    test_OP(5555555, 00000010)
    test_OP(5555555, 00000011)
    test_OP(5555555, 00000012)
    test_OP(5555555, 00000013)
    test_OP(5555555, 00000014)
    test_OP(5555555, 00000015)
    test_OP(5555555, 00000016)
    test_OP(5555555, 00000017)
    test_OP(5555555, 00000018)
    test_OP(5555555, 00000019)
    test_OP(5555555, 0000001a)
    test_OP(5555555, 0000001b)
    test_OP(5555555, 0000001c)
    test_OP(5555555, 0000001d)
    test_OP(5555555, 0000001e)
    test_OP(5555555, 0000001f)
    test_OP(5555555, 00000020)
    test_OP(FFFFFFF, 00000000)
    test_OP(FFFFFFE, 00000000)
    test_OP(FFFFFFC, 00000001)
    test_OP(FFFFFF8, 00000002)
    test_OP(FFFFFF0, 00000003)
    test_OP(FFFFFE0, 00000004)
    test_OP(FFFFFC0, 00000005)
    test_OP(FFFFF80, 00000006)
    test_OP(FFFFF00, 00000007)
    test_OP(FFFFE00, 00000008)
    test_OP(FFFFC00, 00000009)
    test_OP(FFFF800, 0000000a)
    test_OP(FFFF000, 0000000b)
    test_OP(FFFE000, 0000000c)
    test_OP(FFFC000, 0000000d)
    test_OP(FFF8000, 0000000e)
    test_OP(FFF0000, 0000000f)
    test_OP(FFE0000, 00000010)
    test_OP(FFC0000, 00000011)
    test_OP(FF80000, 00000012)
    test_OP(FF00000, 00000013)
    test_OP(FE00000, 00000014)
    test_OP(FC00000, 00000015)
    test_OP(F800000, 00000016)
    test_OP(F000000, 00000017)
    test_OP(E000000, 00000018)
    test_OP(C000000, 00000019)
    test_OP(8000000, 0000001a)
    test_OP(0000000, 0000001b)
    test_OP(0000000, 0000001c)
    test_OP(0000000, 0000001d)
    test_OP(0000000, 0000001e)
    test_OP(0000000, 0000001f)
    test_OP(0000000, 00000020)

    EXIT_TEST

str1:
    .string "Testing ROL"

sep:
    .string " "

gives:
    .string " => "

op:
    .string " (OP) "
