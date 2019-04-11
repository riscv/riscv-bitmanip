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

.macro test_PCNT imm
    WRITE_LOG_N str1
    WRITE_S sep
    li s0, \imm
    PCNT 9 8
    WRITE_RAW s0
    WRITE_S gives
    WRITE_RAW s1
    WRITE_NL
.endm

START_TEST:
    test_PCNT 0x00000000

    test_PCNT 0x00000001
    test_PCNT 0x00000002
    test_PCNT 0x00000004
    test_PCNT 0x00000008
    test_PCNT 0x00000010
    test_PCNT 0x00000020
    test_PCNT 0x00000040
    test_PCNT 0x00000080
    test_PCNT 0x00000100
    test_PCNT 0x00000200
    test_PCNT 0x00000400
    test_PCNT 0x00000800
    test_PCNT 0x00001000
    test_PCNT 0x00002000
    test_PCNT 0x00004000
    test_PCNT 0x00008000
    test_PCNT 0x00010000
    test_PCNT 0x00020000
    test_PCNT 0x00040000
    test_PCNT 0x00080000
    test_PCNT 0x00100000
    test_PCNT 0x00200000
    test_PCNT 0x00400000
    test_PCNT 0x00800000
    test_PCNT 0x01000000
    test_PCNT 0x02000000
    test_PCNT 0x04000000
    test_PCNT 0x08000000
    test_PCNT 0x10000000
    test_PCNT 0x20000000
    test_PCNT 0x40000000
    test_PCNT 0x80000000

    test_PCNT 0x00000001
    test_PCNT 0x00000003
    test_PCNT 0x00000007
    test_PCNT 0x0000000F
    test_PCNT 0x0000001F
    test_PCNT 0x0000003F
    test_PCNT 0x0000007F
    test_PCNT 0x000000FF
    test_PCNT 0x000001FF
    test_PCNT 0x000003FF
    test_PCNT 0x000007FF
    test_PCNT 0x00000FFF
    test_PCNT 0x00001FFF
    test_PCNT 0x00003FFF
    test_PCNT 0x00007FFF
    test_PCNT 0x0000FFFF
    test_PCNT 0x0001FFFF
    test_PCNT 0x0003FFFF
    test_PCNT 0x0007FFFF
    test_PCNT 0x000FFFFF
    test_PCNT 0x001FFFFF
    test_PCNT 0x003FFFFF
    test_PCNT 0x007FFFFF
    test_PCNT 0x00FFFFFF
    test_PCNT 0x01FFFFFF
    test_PCNT 0x03FFFFFF
    test_PCNT 0x07FFFFFF
    test_PCNT 0x0FFFFFFF
    test_PCNT 0x1FFFFFFF
    test_PCNT 0x3FFFFFFF
    test_PCNT 0x7FFFFFFF
    test_PCNT 0xFFFFFFFF

    test_PCNT 0xFFFFFFFF
    test_PCNT 0xFFFFFFFE
    test_PCNT 0xFFFFFFFC
    test_PCNT 0xFFFFFFF8
    test_PCNT 0xFFFFFFF0
    test_PCNT 0xFFFFFFE0
    test_PCNT 0xFFFFFFC0
    test_PCNT 0xFFFFFF80
    test_PCNT 0xFFFFFF00
    test_PCNT 0xFFFFFE00
    test_PCNT 0xFFFFFC00
    test_PCNT 0xFFFFF800
    test_PCNT 0xFFFFF000
    test_PCNT 0xFFFFE000
    test_PCNT 0xFFFFC000
    test_PCNT 0xFFFF8000
    test_PCNT 0xFFFF0000
    test_PCNT 0xFFFE0000
    test_PCNT 0xFFFC0000
    test_PCNT 0xFFF80000
    test_PCNT 0xFFF00000
    test_PCNT 0xFFE00000
    test_PCNT 0xFFC00000
    test_PCNT 0xFF800000
    test_PCNT 0xFF000000
    test_PCNT 0xFE000000
    test_PCNT 0xFC000000
    test_PCNT 0xF8000000
    test_PCNT 0xF0000000
    test_PCNT 0xE0000000
    test_PCNT 0xC0000000
    test_PCNT 0x80000000

    test_PCNT 0x0000000a
    test_PCNT 0x000000aa
    test_PCNT 0x00000aaa
    test_PCNT 0x0000aaaa
    test_PCNT 0x000aaaaa
    test_PCNT 0x00aaaaaa
    test_PCNT 0x0aaaaaaa
    test_PCNT 0xaaaaaaaa

    test_PCNT 0x00000001
    test_PCNT 0x00000011
    test_PCNT 0x00000111
    test_PCNT 0x00001111
    test_PCNT 0x00011111
    test_PCNT 0x00111111
    test_PCNT 0x01111111
    test_PCNT 0x11111111

    EXIT_TEST

str1:
    .string "Testing PCNT"

sep:
    .string " "

gives:
    .string " => "
