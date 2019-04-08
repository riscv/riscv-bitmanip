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

START_TEST:
    test_ANDC 0x00000000 0x00000000
    test_ANDC 0x00000000 0xFFFFFFFF
    test_ANDC 0xFFFFFFFF 0xFFFFFFFF
    test_ANDC 0xFFFFFFFF 0x00000000

    test_ANDC 0xF0F0F0F0 0x00000000
    test_ANDC 0xF0F0F0F0 0x0F0F0F0F
    test_ANDC 0xF0F0F0F0 0xFFFFFFFF
    test_ANDC 0xF0F0F0F0 0xF0F0F0F0

    EXIT_TEST

str1:
    .string "Testing ANDC"

sep:
    .string " "

gives:
    .string " => "

op:
    .string " (OP) "
