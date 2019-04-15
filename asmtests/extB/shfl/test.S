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

.macro test_SHFL imm1 imm2
    WRITE_LOG_N str1
    WRITE_S sep
    li s3, \imm1
    li s4, \imm2
    SHFL 18 19 20
    WRITE_RAW s3
    WRITE_S op
    WRITE_RAW s4
    WRITE_S gives
    WRITE_RAW s2
    WRITE_NL
.endm

START_TEST:
    test_SHFL 0x12345678 0x00000008
    test_SHFL 0x12345678 0x00000004
    test_SHFL 0x33333333 0x00000002
    test_SHFL 0x24242424 0x00000001

    test_SHFL 0x00010000 0x00000001
    test_SHFL 0x00010000 0x00000002
    test_SHFL 0x00010000 0x00000003
    test_SHFL 0x00010000 0x00000004
    test_SHFL 0x00010000 0x00000005
    test_SHFL 0x00010000 0x00000006
    test_SHFL 0x00010000 0x00000007
    test_SHFL 0x00010000 0x00000008
    test_SHFL 0x00010000 0x00000009
    test_SHFL 0x00010000 0x0000000a
    test_SHFL 0x00010000 0x0000000b
    test_SHFL 0x00010000 0x0000000c
    test_SHFL 0x00010000 0x0000000d
    test_SHFL 0x00010000 0x0000000e
    test_SHFL 0x00010000 0x0000000f

    test_SHFL 0x00020000 0x00000001
    test_SHFL 0x00020000 0x00000002
    test_SHFL 0x00020000 0x00000003
    test_SHFL 0x00020000 0x00000004
    test_SHFL 0x00020000 0x00000005
    test_SHFL 0x00020000 0x00000006
    test_SHFL 0x00020000 0x00000007
    test_SHFL 0x00020000 0x00000008
    test_SHFL 0x00020000 0x00000009
    test_SHFL 0x00020000 0x0000000a
    test_SHFL 0x00020000 0x0000000b
    test_SHFL 0x00020000 0x0000000c
    test_SHFL 0x00020000 0x0000000d
    test_SHFL 0x00020000 0x0000000e
    test_SHFL 0x00020000 0x0000000f

    test_SHFL 0x00800000 0x00000001
    test_SHFL 0x00800000 0x00000002
    test_SHFL 0x00800000 0x00000003
    test_SHFL 0x00800000 0x00000004
    test_SHFL 0x00800000 0x00000005
    test_SHFL 0x00800000 0x00000006
    test_SHFL 0x00800000 0x00000007
    test_SHFL 0x00800000 0x00000008
    test_SHFL 0x00800000 0x00000009
    test_SHFL 0x00800000 0x0000000a
    test_SHFL 0x00800000 0x0000000b
    test_SHFL 0x00800000 0x0000000c
    test_SHFL 0x00800000 0x0000000d
    test_SHFL 0x00800000 0x0000000e
    test_SHFL 0x00800000 0x0000000f

    EXIT_TEST

str1:
    .string "Testing SHFL"

sep:
    .string " "

gives:
    .string " => "

op:
    .string " (OP) "
