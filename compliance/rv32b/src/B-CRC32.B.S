#include "compliance_test.h"
#include "compliance_io.h"
#include "test_macros.h"

RV_COMPLIANCE_RV32M

RV_COMPLIANCE_CODE_BEGIN
    la a1,test_results
    li t0, 0xd77b6ecd
    crc32.b t3,t0
    sw t3,0(a1)
    li s6, 0x36a9a6d7
    crc32.b t1,s6
    sw t1,4(a1)
    li s10, 0x219954ae
    crc32.b a4,s10
    sw a4,8(a1)
    li a0, 0x91f3a75b
    crc32.b t3,a0
    sw t3,12(a1)
    li a7, 0x6723f89c
    crc32.b t0,a7
    sw t0,16(a1)
    li a2, 0x6042e65d
    crc32.b s3,a2
    sw s3,20(a1)
    li t0, 0x00000000
    crc32.b t1,t0
    sw t1,24(a1)
    li a3, 0x00000004
    crc32.b t4,a3
    sw t4,28(a1)
    li s11, 0x0000002d
    crc32.b s1,s11
    sw s1,32(a1)
    li t2, 0x00000a80
    crc32.b s6,t2
    sw s6,36(a1)
    li s0, 0x00000dd7
    crc32.b s3,s0
    sw s3,40(a1)
    li t5, 0x00156892
    crc32.b s6,t5
    sw s6,44(a1)
    li s4, 0x0020aa01
    crc32.b t3,s4
    sw t3,48(a1)
    li a7, 0x002f74a0
    crc32.b s1,a7
    sw s1,52(a1)
    li s10, 0x00f03303
    crc32.b s4,s10
    sw s4,56(a1)
    li s5, 0x020010d3
    crc32.b t0,s5
    sw t0,60(a1)
    li a3, 0x020010db
    crc32.b s11,a3
    sw s11,64(a1)
    li s8, 0x04000004
    crc32.b s11,s8
    sw s11,68(a1)
    li t5, 0x06652557
    crc32.b s9,t5
    sw s9,72(a1)
    li t4, 0x06807dd5
    crc32.b s2,t4
    sw s2,76(a1)
    li t6, 0x08000ef5
    crc32.b s9,t6
    sw s9,80(a1)
    li s4, 0x08015886
    crc32.b t1,s4
    sw t1,84(a1)
    li a4, 0x0806a022
    crc32.b t4,a4
    sw t4,88(a1)
    li t3, 0x0810691e
    crc32.b a0,t3
    sw a0,92(a1)
    li t3, 0x10080084
    crc32.b s8,t3
    sw s8,96(a1)
    li a7, 0x1c48c7c4
    crc32.b t1,a7
    sw t1,100(a1)
    li t5, 0x27f33a8a
    crc32.b a6,t5
    sw a6,104(a1)
    li t5, 0x28083074
    crc32.b s6,t5
    sw s6,108(a1)
    li s6, 0x29a94208
    crc32.b a2,s6
    sw a2,112(a1)
    li s3, 0x42050184
    crc32.b s1,s3
    sw s1,116(a1)
    li s5, 0x561a6628
    crc32.b a7,s5
    sw a7,120(a1)
    li s7, 0x5ffbac3e
    crc32.b t3,s7
    sw t3,124(a1)
    li t2, 0x72a10106
    crc32.b t6,t2
    sw t6,128(a1)
    li a5, 0x809ffe48
    crc32.b s2,a5
    sw s2,132(a1)
    li s6, 0x80a27fee
    crc32.b a4,s6
    sw a4,136(a1)
    li s11, 0x820417c0
    crc32.b s10,s11
    sw s10,140(a1)
    li t0, 0xa9000610
    crc32.b a7,t0
    sw a7,144(a1)
    RV_COMPLIANCE_HALT
RV_COMPLIANCE_CODE_END

.data
RV_COMPLIANCE_DATA_BEGIN
test_results:
.fill 37,4,-1
RV_COMPLIANCE_DATA_END
