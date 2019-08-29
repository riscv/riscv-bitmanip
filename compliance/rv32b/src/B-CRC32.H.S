#include "compliance_test.h"
#include "compliance_io.h"
#include "test_macros.h"

RV_COMPLIANCE_RV32M

RV_COMPLIANCE_CODE_BEGIN
    la a1,test_results
    li s4, 0xd77b6ecd
    crc32.h s6,s4
    sw s6,0(a1)
    li s1, 0x36a9a6d7
    crc32.h t5,s1
    sw t5,4(a1)
    li s11, 0x219954ae
    crc32.h a3,s11
    sw a3,8(a1)
    li t2, 0x91f3a75b
    crc32.h a6,t2
    sw a6,12(a1)
    li s5, 0x6723f89c
    crc32.h t5,s5
    sw t5,16(a1)
    li s4, 0x6042e65d
    crc32.h a2,s4
    sw a2,20(a1)
    li s10, 0x00000000
    crc32.h s8,s10
    sw s8,24(a1)
    li t5, 0x00000004
    crc32.h s10,t5
    sw s10,28(a1)
    li a4, 0x0000002d
    crc32.h t1,a4
    sw t1,32(a1)
    li s5, 0x00000a80
    crc32.h t1,s5
    sw t1,36(a1)
    li t0, 0x00000dd7
    crc32.h s2,t0
    sw s2,40(a1)
    li s9, 0x00156892
    crc32.h a7,s9
    sw a7,44(a1)
    li a6, 0x0020aa01
    crc32.h s10,a6
    sw s10,48(a1)
    li a3, 0x002f74a0
    crc32.h t4,a3
    sw t4,52(a1)
    li s2, 0x00f03303
    crc32.h s0,s2
    sw s0,56(a1)
    li t5, 0x020010d3
    crc32.h t0,t5
    sw t0,60(a1)
    li s0, 0x020010db
    crc32.h s4,s0
    sw s4,64(a1)
    li t2, 0x04000004
    crc32.h s4,t2
    sw s4,68(a1)
    li t3, 0x06652557
    crc32.h s11,t3
    sw s11,72(a1)
    li s5, 0x06807dd5
    crc32.h a6,s5
    sw a6,76(a1)
    li a6, 0x08000ef5
    crc32.h a3,a6
    sw a3,80(a1)
    li s2, 0x08015886
    crc32.h t4,s2
    sw t4,84(a1)
    li t0, 0x0806a022
    crc32.h s0,t0
    sw s0,88(a1)
    li s5, 0x0810691e
    crc32.h a4,s5
    sw a4,92(a1)
    li t0, 0x10080084
    crc32.h a3,t0
    sw a3,96(a1)
    li s6, 0x1c48c7c4
    crc32.h s0,s6
    sw s0,100(a1)
    li s10, 0x27f33a8a
    crc32.h a7,s10
    sw a7,104(a1)
    li s1, 0x28083074
    crc32.h s10,s1
    sw s10,108(a1)
    li s0, 0x29a94208
    crc32.h s11,s0
    sw s11,112(a1)
    li s2, 0x42050184
    crc32.h t4,s2
    sw t4,116(a1)
    li t0, 0x561a6628
    crc32.h s5,t0
    sw s5,120(a1)
    li s3, 0x5ffbac3e
    crc32.h s7,s3
    sw s7,124(a1)
    li s8, 0x72a10106
    crc32.h t2,s8
    sw t2,128(a1)
    li t3, 0x809ffe48
    crc32.h s3,t3
    sw s3,132(a1)
    li s9, 0x80a27fee
    crc32.h s6,s9
    sw s6,136(a1)
    li a5, 0x820417c0
    crc32.h a7,a5
    sw a7,140(a1)
    li a3, 0xa9000610
    crc32.h a4,a3
    sw a4,144(a1)
    RV_COMPLIANCE_HALT
RV_COMPLIANCE_CODE_END

.data
RV_COMPLIANCE_DATA_BEGIN
test_results:
.fill 37,4,-1
RV_COMPLIANCE_DATA_END
