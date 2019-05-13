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

.macro test_ANDC imm1 imm2
    WRITE_LOG_N str1
    WRITE_S sep
    li s3, \imm1
    li s4, \imm2
    ANDC 18 19 20
    WRITE_RAW s3
    WRITE_S op
    WRITE_RAW s4
    WRITE_S gives
    WRITE_RAW s2
    WRITE_NL
.endm

#if defined(XLEN64)
    #define test_OP(i1, i2) \
        test_ANDC 0x ## i1 0x ## i2; \
        test_ANDC 0x ## i1 ## i1 0x ## i2 ## i2;
#else
    #define test_OP(i1, i2) \
        test_ANDC 0x ## i1 0x ## i2;
#endif

START_TEST:
    test_OP(00000000, 00000000)
    test_OP(00000000, FFFFFFFF)
    test_OP(FFFFFFFF, FFFFFFFF)
    test_OP(FFFFFFFF, 00000000)
    test_OP(F0F0F0F0, 00000000)
    test_OP(F0F0F0F0, 0F0F0F0F)
    test_OP(F0F0F0F0, FFFFFFFF)
    test_OP(F0F0F0F0, F0F0F0F0)

    EXIT_TEST

str1:
    .string "Testing ANDC"

sep:
    .string " "

gives:
    .string " => "

op:
    .string " (OP) "
