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
#include "extB.S.include"

# use s0(r8)  - s1(r9)
# use s2(r18) - s11(r27)

.macro test_BDEP imm1 imm2
    WRITE_LOG_N str1
    WRITE_S sep
    li s3, \imm1
    li s4, \imm2
    BDEP 18 19 20
    WRITE_RAW s3
    WRITE_S op
    WRITE_RAW s4
    WRITE_S gives
    WRITE_RAW s2
    WRITE_NL
.endm

#if defined(XLEN64)
    #define test_OP(i1, i2) \
        test_BDEP 0x ## i1 0x ## i2; \
        test_BDEP 0x ## i1 ## i1 0x ## i2 ## i2;
#else
    #define test_OP(i1, i2) \
        test_BDEP 0x ## i1 0x ## i2;
#endif

START_TEST:
    test_OP(12345678, 0000000F)
    test_OP(12345678, 000000F0)
    test_OP(12345678, 00000F00)
    test_OP(12345678, 0000F000)
    test_OP(12345678, 000F0000)
    test_OP(12345678, 00F00000)
    test_OP(12345678, 0F000000)
    test_OP(12345678, F0000000)
    test_OP(12345678, 000000FF)
    test_OP(12345678, 00000FF0)
    test_OP(12345678, 0000FF00)
    test_OP(12345678, 000FF000)
    test_OP(12345678, 00FF0000)
    test_OP(12345678, 0FF00000)
    test_OP(12345678, FF000000)
    test_OP(12345678, 00000FFF)
    test_OP(12345678, 0000FFF0)
    test_OP(12345678, 000FFF00)
    test_OP(12345678, 00FFF000)
    test_OP(12345678, 0FFF0000)
    test_OP(12345678, FFF00000)
    test_OP(12345678, 0000FFFF)
    test_OP(12345678, 000FFFF0)
    test_OP(12345678, 00FFFF00)
    test_OP(12345678, 0FFFF000)
    test_OP(12345678, FFFF0000)
    test_OP(12345678, 000FFFFF)
    test_OP(12345678, 00FFFFF0)
    test_OP(12345678, 0FFFFF00)
    test_OP(12345678, FFFFF000)
    test_OP(12345678, 00FFFFFF)
    test_OP(12345678, 0FFFFFF0)
    test_OP(12345678, FFFFFF00)
    test_OP(12345678, 0FFFFFFF)
    test_OP(12345678, FFFFFFF0)
    test_OP(12345678, FFFFFFFF)
    test_OP(12345678, 000FF000)
    test_OP(12345678, 00F00F00)
    test_OP(12345678, 0F0000F0)
    test_OP(12345678, F000000F)
    test_OP(55555555, 55555555)
    test_OP(AAAAAAAA, 55555555)
    test_OP(55555555, AAAAAAAA)
    test_OP(AAAAAAAA, AAAAAAAA)

    EXIT_TEST

str1:
    .string "Testing BDEP"

sep:
    .string " "

gives:
    .string " => "

op:
    .string " (OP) "
