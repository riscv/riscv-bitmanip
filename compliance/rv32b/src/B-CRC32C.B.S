#include "compliance_test.h"
#include "compliance_io.h"
#include "test_macros.h"

RV_COMPLIANCE_RV32M

RV_COMPLIANCE_CODE_BEGIN
    la a1,test_results
    li a6, 0xd77b6ecd
    crc32c.b s0,a6
    sw s0,0(a1)
    li s7, 0x36a9a6d7
    crc32c.b s0,s7
    sw s0,4(a1)
    li a7, 0x219954ae
    crc32c.b s5,a7
    sw s5,8(a1)
    li a3, 0x91f3a75b
    crc32c.b s10,a3
    sw s10,12(a1)
    li s5, 0x6723f89c
    crc32c.b s2,s5
    sw s2,16(a1)
    li a7, 0x6042e65d
    crc32c.b s2,a7
    sw s2,20(a1)
    li a0, 0x00000000
    crc32c.b a4,a0
    sw a4,24(a1)
    li s0, 0x00000004
    crc32c.b a0,s0
    sw a0,28(a1)
    li s0, 0x0000002d
    crc32c.b t6,s0
    sw t6,32(a1)
    li a7, 0x00000a80
    crc32c.b s2,a7
    sw s2,36(a1)
    li a7, 0x00000dd7
    crc32c.b t5,a7
    sw t5,40(a1)
    li t3, 0x00156892
    crc32c.b a4,t3
    sw a4,44(a1)
    li a3, 0x0020aa01
    crc32c.b a4,a3
    sw a4,48(a1)
    li s3, 0x002f74a0
    crc32c.b s6,s3
    sw s6,52(a1)
    li a0, 0x00f03303
    crc32c.b a2,a0
    sw a2,56(a1)
    li a4, 0x020010d3
    crc32c.b s9,a4
    sw s9,60(a1)
    li a5, 0x020010db
    crc32c.b s4,a5
    sw s4,64(a1)
    li s6, 0x04000004
    crc32c.b a2,s6
    sw a2,68(a1)
    li s0, 0x06652557
    crc32c.b s9,s0
    sw s9,72(a1)
    li a5, 0x06807dd5
    crc32c.b s5,a5
    sw s5,76(a1)
    li s9, 0x08000ef5
    crc32c.b s11,s9
    sw s11,80(a1)
    li t6, 0x08015886
    crc32c.b a6,t6
    sw a6,84(a1)
    li a0, 0x0806a022
    crc32c.b s6,a0
    sw s6,88(a1)
    li a4, 0x0810691e
    crc32c.b t5,a4
    sw t5,92(a1)
    li s4, 0x10080084
    crc32c.b t4,s4
    sw t4,96(a1)
    li a6, 0x1c48c7c4
    crc32c.b a3,a6
    sw a3,100(a1)
    li a2, 0x27f33a8a
    crc32c.b s4,a2
    sw s4,104(a1)
    li s5, 0x28083074
    crc32c.b s10,s5
    sw s10,108(a1)
    li t0, 0x29a94208
    crc32c.b a6,t0
    sw a6,112(a1)
    li t2, 0x42050184
    crc32c.b s4,t2
    sw s4,116(a1)
    li s9, 0x561a6628
    crc32c.b t5,s9
    sw t5,120(a1)
    li a6, 0x5ffbac3e
    crc32c.b s6,a6
    sw s6,124(a1)
    li a3, 0x72a10106
    crc32c.b s9,a3
    sw s9,128(a1)
    li s4, 0x809ffe48
    crc32c.b a4,s4
    sw a4,132(a1)
    li s2, 0x80a27fee
    crc32c.b s3,s2
    sw s3,136(a1)
    li a0, 0x820417c0
    crc32c.b s9,a0
    sw s9,140(a1)
    li t0, 0xa9000610
    crc32c.b a3,t0
    sw a3,144(a1)
    RV_COMPLIANCE_HALT
RV_COMPLIANCE_CODE_END

.data
RV_COMPLIANCE_DATA_BEGIN
test_results:
.fill 37,4,-1
RV_COMPLIANCE_DATA_END
