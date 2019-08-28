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
    li s0, 0x00000000
    crc32.b a2,s0
    sw a2,24(a1)
    li s10, 0x00000004
    crc32.b a5,s10
    sw a5,28(a1)
    li a0, 0x0000002d
    crc32.b t3,a0
    sw t3,32(a1)
    li s4, 0x00000a80
    crc32.b t2,s4
    sw t2,36(a1)
    li t3, 0x00000dd7
    crc32.b a0,t3
    sw a0,40(a1)
    li s4, 0x00156892
    crc32.b s9,s4
    sw s9,44(a1)
    li a7, 0x0020aa01
    crc32.b s5,a7
    sw s5,48(a1)
    li s11, 0x002f74a0
    crc32.b t4,s11
    sw t4,52(a1)
    li t0, 0x00f03303
    crc32.b s5,t0
    sw s5,56(a1)
    li t2, 0x020010d3
    crc32.b s10,t2
    sw s10,60(a1)
    li s5, 0x020010db
    crc32.b a7,s5
    sw a7,64(a1)
    li a3, 0x04000004
    crc32.b t3,a3
    sw t3,68(a1)
    li s9, 0x06652557
    crc32.b a7,s9
    sw a7,72(a1)
    li s8, 0x06807dd5
    crc32.b s10,s8
    sw s10,76(a1)
    li t2, 0x08000ef5
    crc32.b s5,t2
    sw s5,80(a1)
    li s3, 0x08015886
    crc32.b a5,s3
    sw a5,84(a1)
    li t1, 0x0806a022
    crc32.b s9,t1
    sw s9,88(a1)
    li s8, 0x0810691e
    crc32.b t5,s8
    sw t5,92(a1)
    li t4, 0x10080084
    crc32.b t6,t4
    sw t6,96(a1)
    li s9, 0x1c48c7c4
    crc32.b a4,s9
    sw a4,100(a1)
    li t5, 0x27f33a8a
    crc32.b s11,t5
    sw s11,104(a1)
    li t2, 0x28083074
    crc32.b s1,t2
    sw s1,108(a1)
    li a3, 0x29a94208
    crc32.b a5,a3
    sw a5,112(a1)
    li s4, 0x42050184
    crc32.b s6,s4
    sw s6,116(a1)
    li t6, 0x561a6628
    crc32.b s3,t6
    sw s3,120(a1)
    li s4, 0x5ffbac3e
    crc32.b s8,s4
    sw s8,124(a1)
    li t1, 0x72a10106
    crc32.b t5,t1
    sw t5,128(a1)
    li t4, 0x809ffe48
    crc32.b a6,t4
    sw a6,132(a1)
    li s4, 0x80a27fee
    crc32.b t1,s4
    sw t1,136(a1)
    li s8, 0x820417c0
    crc32.b s11,s8
    sw s11,140(a1)
    li s5, 0xa9000610
    crc32.b t5,s5
    sw t5,144(a1)
    RV_COMPLIANCE_HALT
RV_COMPLIANCE_CODE_END

.data
RV_COMPLIANCE_DATA_BEGIN
test_results:
.fill 37,4,-1
RV_COMPLIANCE_DATA_END
