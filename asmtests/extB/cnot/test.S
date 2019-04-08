.include "extB.S.include"

# use s0(r8)  - s1(r9)
# use s2(r18) - s11(r27)

.macro test_CNOT imm1
    WRITE_LOG_N str1
    WRITE_S sep
    li s0, \imm1
    li s1, \imm1
    CNOT 9
    WRITE_RAW s0
    WRITE_S gives
    WRITE_RAW s1
    WRITE_NL
.endm

START_TEST:
    test_CNOT ~0x00000000
    test_CNOT ~0x00000001
    test_CNOT ~0x00000002
    test_CNOT ~0x00000004
    test_CNOT ~0x00000008
    test_CNOT ~0x00000010
    test_CNOT ~0x00000020
    test_CNOT ~0x00000040
    test_CNOT ~0x00000080
    test_CNOT ~0x00000100
    test_CNOT ~0x00000200
    test_CNOT ~0x00000400
    test_CNOT ~0x00000800
    test_CNOT ~0x00001000
    test_CNOT ~0x00002000
    test_CNOT ~0x00004000
    test_CNOT ~0x00008000
    test_CNOT ~0x00010000
    test_CNOT ~0x00020000
    test_CNOT ~0x00040000
    test_CNOT ~0x00080000
    test_CNOT ~0x00100000
    test_CNOT ~0x00200000
    test_CNOT ~0x00400000
    test_CNOT ~0x00800000
    test_CNOT ~0x01000000
    test_CNOT ~0x02000000
    test_CNOT ~0x04000000
    test_CNOT ~0x08000000
    test_CNOT ~0x10000000
    test_CNOT ~0x20000000
    test_CNOT ~0x40000000
    test_CNOT ~0x80000000

    test_CNOT 0x00000000
    test_CNOT 0x00000001
    test_CNOT 0x00000002
    test_CNOT 0x00000004
    test_CNOT 0x00000008
    test_CNOT 0x00000010
    test_CNOT 0x00000020
    test_CNOT 0x00000040
    test_CNOT 0x00000080
    test_CNOT 0x00000100
    test_CNOT 0x00000200
    test_CNOT 0x00000400
    test_CNOT 0x00000800
    test_CNOT 0x00001000
    test_CNOT 0x00002000
    test_CNOT 0x00004000
    test_CNOT 0x00008000
    test_CNOT 0x00010000
    test_CNOT 0x00020000
    test_CNOT 0x00040000
    test_CNOT 0x00080000
    test_CNOT 0x00100000
    test_CNOT 0x00200000
    test_CNOT 0x00400000
    test_CNOT 0x00800000
    test_CNOT 0x01000000
    test_CNOT 0x02000000
    test_CNOT 0x04000000
    test_CNOT 0x08000000
    test_CNOT 0x10000000
    test_CNOT 0x20000000
    test_CNOT 0x40000000
    test_CNOT 0x80000000

    EXIT_TEST

str1:
    .string "Testing CNOT"

sep:
    .string " "

gives:
    .string " => "

op:
    .string " (OP) "
