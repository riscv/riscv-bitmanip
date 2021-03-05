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

.macro test_CLZ imm
    WRITE_LOG_N str1
    WRITE_S sep
    li s0, \imm
    CLZ 9 8
    WRITE_RAW s0
    WRITE_S gives
    WRITE_RAW s1
    WRITE_NL
.endm

#if defined(XLEN64)
    #define test_OP(i1) \
        test_CLZ 0x ## i1; \
        test_CLZ 0x ## i1 ## i1;
#else
    #define test_OP(i1) \
        test_CLZ 0x ## i1;
#endif

START_TEST:
    test_OP(00000000)
    test_OP(00000001)
    test_OP(00000002)
    test_OP(00000004)
    test_OP(00000008)
    test_OP(00000010)
    test_OP(00000020)
    test_OP(00000040)
    test_OP(00000080)
    test_OP(00000100)
    test_OP(00000200)
    test_OP(00000400)
    test_OP(00000800)
    test_OP(00001000)
    test_OP(00002000)
    test_OP(00004000)
    test_OP(00008000)
    test_OP(00010000)
    test_OP(00020000)
    test_OP(00040000)
    test_OP(00080000)
    test_OP(00100000)
    test_OP(00200000)
    test_OP(00400000)
    test_OP(00800000)
    test_OP(01000000)
    test_OP(02000000)
    test_OP(04000000)
    test_OP(08000000)
    test_OP(10000000)
    test_OP(20000000)
    test_OP(40000000)
    test_OP(80000000)
    test_OP(00000001)
    test_OP(00000003)
    test_OP(00000007)
    test_OP(0000000F)
    test_OP(0000001F)
    test_OP(0000003F)
    test_OP(0000007F)
    test_OP(000000FF)
    test_OP(000001FF)
    test_OP(000003FF)
    test_OP(000007FF)
    test_OP(00000FFF)
    test_OP(00001FFF)
    test_OP(00003FFF)
    test_OP(00007FFF)
    test_OP(0000FFFF)
    test_OP(0001FFFF)
    test_OP(0003FFFF)
    test_OP(0007FFFF)
    test_OP(000FFFFF)
    test_OP(001FFFFF)
    test_OP(003FFFFF)
    test_OP(007FFFFF)
    test_OP(00FFFFFF)
    test_OP(01FFFFFF)
    test_OP(03FFFFFF)
    test_OP(07FFFFFF)
    test_OP(0FFFFFFF)
    test_OP(1FFFFFFF)
    test_OP(3FFFFFFF)
    test_OP(7FFFFFFF)
    test_OP(FFFFFFFF)
    test_OP(FFFFFFFF)
    test_OP(FFFFFFFE)
    test_OP(FFFFFFFC)
    test_OP(FFFFFFF8)
    test_OP(FFFFFFF0)
    test_OP(FFFFFFE0)
    test_OP(FFFFFFC0)
    test_OP(FFFFFF80)
    test_OP(FFFFFF00)
    test_OP(FFFFFE00)
    test_OP(FFFFFC00)
    test_OP(FFFFF800)
    test_OP(FFFFF000)
    test_OP(FFFFE000)
    test_OP(FFFFC000)
    test_OP(FFFF8000)
    test_OP(FFFF0000)
    test_OP(FFFE0000)
    test_OP(FFFC0000)
    test_OP(FFF80000)
    test_OP(FFF00000)
    test_OP(FFE00000)
    test_OP(FFC00000)
    test_OP(FF800000)
    test_OP(FF000000)
    test_OP(FE000000)
    test_OP(FC000000)
    test_OP(F8000000)
    test_OP(F0000000)
    test_OP(E0000000)
    test_OP(C0000000)
    test_OP(80000000)

    EXIT_TEST

str1:
    .string "Testing CLZ"

sep:
    .string " "

gives:
    .string " => "
