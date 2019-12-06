#include "compliance_test.h"
#include "compliance_io.h"
#include "test_macros.h"

RV_COMPLIANCE_RV32M

RV_COMPLIANCE_CODE_BEGIN
    la a1,test_results
    li a5, 0xd77b6ecd
    crc32c.h s10,a5
    sw s10,0(a1)
    li a7, 0x36a9a6d7
    crc32c.h s0,a7
    sw s0,4(a1)
    li t0, 0x219954ae
    crc32c.h a0,t0
    sw a0,8(a1)
    li a7, 0x91f3a75b
    crc32c.h a6,a7
    sw a6,12(a1)
    li t4, 0x6723f89c
    crc32c.h s6,t4
    sw s6,16(a1)
    li s2, 0x6042e65d
    crc32c.h a5,s2
    sw a5,20(a1)
    li s7, 0x00000000
    crc32c.h t5,s7
    sw t5,24(a1)
    li s0, 0x00000004
    crc32c.h t3,s0
    sw t3,28(a1)
    li a2, 0x0000002d
    crc32c.h t0,a2
    sw t0,32(a1)
    li a5, 0x00000a80
    crc32c.h a7,a5
    sw a7,36(a1)
    li s7, 0x00000dd7
    crc32c.h s5,s7
    sw s5,40(a1)
    li s6, 0x00156892
    crc32c.h t2,s6
    sw t2,44(a1)
    li a3, 0x0020aa01
    crc32c.h s5,a3
    sw s5,48(a1)
    li s11, 0x002f74a0
    crc32c.h t4,s11
    sw t4,52(a1)
    li s5, 0x00f03303
    crc32c.h a0,s5
    sw a0,56(a1)
    li a3, 0x020010d3
    crc32c.h s3,a3
    sw s3,60(a1)
    li s4, 0x020010db
    crc32c.h t5,s4
    sw t5,64(a1)
    li s0, 0x04000004
    crc32c.h s8,s0
    sw s8,68(a1)
    li s10, 0x06652557
    crc32c.h s0,s10
    sw s0,72(a1)
    li s5, 0x06807dd5
    crc32c.h s7,s5
    sw s7,76(a1)
    li t6, 0x08000ef5
    crc32c.h s7,t6
    sw s7,80(a1)
    li t3, 0x08015886
    crc32c.h s2,t3
    sw s2,84(a1)
    li s6, 0x0806a022
    crc32c.h a6,s6
    sw a6,88(a1)
    li s6, 0x0810691e
    crc32c.h s5,s6
    sw s5,92(a1)
    li a4, 0x10080084
    crc32c.h a0,a4
    sw a0,96(a1)
    li s6, 0x1c48c7c4
    crc32c.h a7,s6
    sw a7,100(a1)
    li t2, 0x27f33a8a
    crc32c.h t1,t2
    sw t1,104(a1)
    li s7, 0x28083074
    crc32c.h a4,s7
    sw a4,108(a1)
    li s1, 0x29a94208
    crc32c.h a2,s1
    sw a2,112(a1)
    li t1, 0x42050184
    crc32c.h a2,t1
    sw a2,116(a1)
    li s4, 0x561a6628
    crc32c.h t6,s4
    sw t6,120(a1)
    li s9, 0x5ffbac3e
    crc32c.h t0,s9
    sw t0,124(a1)
    li t5, 0x72a10106
    crc32c.h a5,t5
    sw a5,128(a1)
    li t3, 0x809ffe48
    crc32c.h s8,t3
    sw s8,132(a1)
    li s1, 0x80a27fee
    crc32c.h t4,s1
    sw t4,136(a1)
    li s7, 0x820417c0
    crc32c.h t1,s7
    sw t1,140(a1)
    li t6, 0xa9000610
    crc32c.h s8,t6
    sw s8,144(a1)
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
