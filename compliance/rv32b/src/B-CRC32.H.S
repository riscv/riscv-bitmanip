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
    li a7, 0x00000000
    crc32.h a3,a7
    sw a3,24(a1)
    li s2, 0x00000004
    crc32.h t1,s2
    sw t1,28(a1)
    li s10, 0x0000002d
    crc32.h t1,s10
    sw t1,32(a1)
    li t0, 0x00000a80
    crc32.h a5,t0
    sw a5,36(a1)
    li a7, 0x00000dd7
    crc32.h t4,a7
    sw t4,40(a1)
    li s2, 0x00156892
    crc32.h a2,s2
    sw a2,44(a1)
    li s1, 0x0020aa01
    crc32.h s3,s1
    sw s3,48(a1)
    li a5, 0x002f74a0
    crc32.h a4,a5
    sw a4,52(a1)
    li t4, 0x00f03303
    crc32.h a5,t4
    sw a5,56(a1)
    li a3, 0x020010d3
    crc32.h t0,a3
    sw t0,60(a1)
    li a6, 0x020010db
    crc32.h a3,a6
    sw a3,64(a1)
    li s0, 0x04000004
    crc32.h t1,s0
    sw t1,68(a1)
    li t2, 0x06652557
    crc32.h s11,t2
    sw s11,72(a1)
    li s6, 0x06807dd5
    crc32.h s2,s6
    sw s2,76(a1)
    li s7, 0x08000ef5
    crc32.h a7,s7
    sw a7,80(a1)
    li s1, 0x08015886
    crc32.h a5,s1
    sw a5,84(a1)
    li t2, 0x0806a022
    crc32.h s10,t2
    sw s10,88(a1)
    li s8, 0x0810691e
    crc32.h a3,s8
    sw a3,92(a1)
    li a4, 0x10080084
    crc32.h t2,a4
    sw t2,96(a1)
    li s10, 0x1c48c7c4
    crc32.h a4,s10
    sw a4,100(a1)
    li s7, 0x27f33a8a
    crc32.h s0,s7
    sw s0,104(a1)
    li a0, 0x28083074
    crc32.h t0,a0
    sw t0,108(a1)
    li s10, 0x29a94208
    crc32.h s4,s10
    sw s4,112(a1)
    li t2, 0x42050184
    crc32.h t1,t2
    sw t1,116(a1)
    li t0, 0x561a6628
    crc32.h s0,t0
    sw s0,120(a1)
    li a7, 0x5ffbac3e
    crc32.h s5,a7
    sw s5,124(a1)
    li t4, 0x72a10106
    crc32.h s10,t4
    sw s10,128(a1)
    li a3, 0x809ffe48
    crc32.h t3,a3
    sw t3,132(a1)
    li a4, 0x80a27fee
    crc32.h s3,a4
    sw s3,136(a1)
    li t3, 0x820417c0
    crc32.h a3,t3
    sw a3,140(a1)
    li s7, 0xa9000610
    crc32.h a4,s7
    sw a4,144(a1)
    RV_COMPLIANCE_HALT
RV_COMPLIANCE_CODE_END

.data
RV_COMPLIANCE_DATA_BEGIN
test_results:
.fill 37,4,-1
RV_COMPLIANCE_DATA_END
