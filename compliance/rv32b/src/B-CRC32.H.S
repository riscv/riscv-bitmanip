#include "compliance_test.h"
#include "compliance_io.h"
#include "test_macros.h"

RV_COMPLIANCE_RV32M

RV_COMPLIANCE_CODE_BEGIN
    la a1,test_results
    li s11, 0xd77b6ecd
    crc32.h a3,s11
    sw a3,0(a1)
    li t2, 0x36a9a6d7
    crc32.h a6,t2
    sw a6,4(a1)
    li s5, 0x219954ae
    crc32.h t5,s5
    sw t5,8(a1)
    li s4, 0x91f3a75b
    crc32.h a2,s4
    sw a2,12(a1)
    li s5, 0x6723f89c
    crc32.h s7,s5
    sw s7,16(a1)
    li t5, 0x6042e65d
    crc32.h t1,t5
    sw t1,20(a1)
    li s6, 0x00000000
    crc32.h s0,s6
    sw s0,24(a1)
    li a0, 0x00000004
    crc32.h s3,a0
    sw s3,28(a1)
    li s11, 0x0000002d
    crc32.h s10,s11
    sw s10,32(a1)
    li a0, 0x00000a80
    crc32.h a7,a0
    sw a7,36(a1)
    li t2, 0x00000dd7
    crc32.h t1,t2
    sw t1,40(a1)
    li s9, 0x00156892
    crc32.h t3,s9
    sw t3,44(a1)
    li a3, 0x0020aa01
    crc32.h a6,a3
    sw a6,48(a1)
    li a2, 0x002f74a0
    crc32.h s4,a2
    sw s4,52(a1)
    li s10, 0x00f03303
    crc32.h s0,s10
    sw s0,56(a1)
    li a4, 0x020010d3
    crc32.h s11,a4
    sw s11,60(a1)
    li s9, 0x020010db
    crc32.h a2,s9
    sw a2,64(a1)
    li a6, 0x04000004
    crc32.h a0,a6
    sw a0,68(a1)
    li t5, 0x06652557
    crc32.h s0,t5
    sw s0,72(a1)
    li s7, 0x06807dd5
    crc32.h s0,s7
    sw s0,76(a1)
    li s1, 0x08000ef5
    crc32.h t1,s1
    sw t1,80(a1)
    li t1, 0x08015886
    crc32.h s9,t1
    sw s9,84(a1)
    li s7, 0x0806a022
    crc32.h a4,s7
    sw a4,88(a1)
    li s10, 0x0810691e
    crc32.h a7,s10
    sw a7,92(a1)
    li t0, 0x10080084
    crc32.h s7,t0
    sw s7,96(a1)
    li s10, 0x1c48c7c4
    crc32.h s2,s10
    sw s2,100(a1)
    li s0, 0x27f33a8a
    crc32.h s6,s0
    sw s6,104(a1)
    li s5, 0x28083074
    crc32.h t2,s5
    sw t2,108(a1)
    li t1, 0x29a94208
    crc32.h a2,t1
    sw a2,112(a1)
    li s10, 0x42050184
    crc32.h s2,s10
    sw s2,116(a1)
    li t5, 0x561a6628
    crc32.h t4,t5
    sw t4,120(a1)
    li s9, 0x5ffbac3e
    crc32.h s11,s9
    sw s11,124(a1)
    li t0, 0x72a10106
    crc32.h s10,t0
    sw s10,128(a1)
    li a3, 0x809ffe48
    crc32.h s8,a3
    sw s8,132(a1)
    li a2, 0x80a27fee
    crc32.h s8,a2
    sw s8,136(a1)
    li s5, 0x820417c0
    crc32.h a2,s5
    sw a2,140(a1)
    li a5, 0xa9000610
    crc32.h s2,a5
    sw s2,144(a1)
    sw zero,148(a1)
    sw zero,152(a1)
    sw zero,156(a1)
    RV_COMPLIANCE_HALT
RV_COMPLIANCE_CODE_END

.data
RV_COMPLIANCE_DATA_BEGIN
test_results:
.fill 40,4,-1
RV_COMPLIANCE_DATA_END
