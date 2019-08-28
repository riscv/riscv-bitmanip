#include "compliance_test.h"
#include "compliance_io.h"
#include "test_macros.h"

RV_COMPLIANCE_RV32M

RV_COMPLIANCE_CODE_BEGIN
    la a1,test_results
    li t0, 0xd77b6ecd
    crc32.w s6,t0
    sw s6,0(a1)
    li t5, 0x36a9a6d7
    crc32.w t6,t5
    sw t6,4(a1)
    li a6, 0x219954ae
    crc32.w t5,a6
    sw t5,8(a1)
    li s4, 0x91f3a75b
    crc32.w s3,s4
    sw s3,12(a1)
    li a6, 0x6723f89c
    crc32.w t4,a6
    sw t4,16(a1)
    li s3, 0x6042e65d
    crc32.w s10,s3
    sw s10,20(a1)
    li s3, 0x00000000
    crc32.w s7,s3
    sw s7,24(a1)
    li s1, 0x00000004
    crc32.w t3,s1
    sw t3,28(a1)
    li a6, 0x0000002d
    crc32.w s4,a6
    sw s4,32(a1)
    li t6, 0x00000a80
    crc32.w a5,t6
    sw a5,36(a1)
    li s10, 0x00000dd7
    crc32.w s7,s10
    sw s7,40(a1)
    li s9, 0x00156892
    crc32.w s7,s9
    sw s7,44(a1)
    li s6, 0x0020aa01
    crc32.w a5,s6
    sw a5,48(a1)
    li s2, 0x002f74a0
    crc32.w t3,s2
    sw t3,52(a1)
    li a0, 0x00f03303
    crc32.w t4,a0
    sw t4,56(a1)
    li t1, 0x020010d3
    crc32.w a5,t1
    sw a5,60(a1)
    li t3, 0x020010db
    crc32.w a6,t3
    sw a6,64(a1)
    li s0, 0x04000004
    crc32.w a2,s0
    sw a2,68(a1)
    li t1, 0x06652557
    crc32.w a3,t1
    sw a3,72(a1)
    li s9, 0x06807dd5
    crc32.w s3,s9
    sw s3,76(a1)
    li s2, 0x08000ef5
    crc32.w a4,s2
    sw a4,80(a1)
    li s10, 0x08015886
    crc32.w a5,s10
    sw a5,84(a1)
    li s9, 0x0806a022
    crc32.w t2,s9
    sw t2,88(a1)
    li s7, 0x0810691e
    crc32.w a7,s7
    sw a7,92(a1)
    li t2, 0x10080084
    crc32.w s3,t2
    sw s3,96(a1)
    li s0, 0x1c48c7c4
    crc32.w a2,s0
    sw a2,100(a1)
    li s10, 0x27f33a8a
    crc32.w a5,s10
    sw a5,104(a1)
    li a0, 0x28083074
    crc32.w t3,a0
    sw t3,108(a1)
    li s4, 0x29a94208
    crc32.w t2,s4
    sw t2,112(a1)
    li t3, 0x42050184
    crc32.w a0,t3
    sw a0,116(a1)
    li s4, 0x561a6628
    crc32.w s9,s4
    sw s9,120(a1)
    li a7, 0x5ffbac3e
    crc32.w s5,a7
    sw s5,124(a1)
    li s11, 0x72a10106
    crc32.w t4,s11
    sw t4,128(a1)
    li t0, 0x809ffe48
    crc32.w s5,t0
    sw s5,132(a1)
    li t2, 0x80a27fee
    crc32.w s10,t2
    sw s10,136(a1)
    li s5, 0x820417c0
    crc32.w a7,s5
    sw a7,140(a1)
    li a3, 0xa9000610
    crc32.w t3,a3
    sw t3,144(a1)
    RV_COMPLIANCE_HALT
RV_COMPLIANCE_CODE_END

.data
RV_COMPLIANCE_DATA_BEGIN
test_results:
.fill 37,4,-1
RV_COMPLIANCE_DATA_END
