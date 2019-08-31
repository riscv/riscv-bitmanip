#include "compliance_test.h"
#include "compliance_io.h"
#include "test_macros.h"

RV_COMPLIANCE_RV32M

RV_COMPLIANCE_CODE_BEGIN
    la a1,test_results
    li s3, 0x778bd1db
    li a4, 0xdef3c035
    grev t4,s3,a4
    sw t4,0(a1)
    li s10, 0xffaace79
    li a2, 0x11e15d6b
    grev s4,s10,a2
    sw s4,4(a1)
    li t1, 0x04bc5eac
    li s6, 0x33397f4e
    grev s7,t1,s6
    sw s7,8(a1)
    li a5, 0x40ee4840
    li s6, 0x18331b85
    grev a3,a5,s6
    sw a3,12(a1)
    li s11, 0x5a0d8ae2
    li t0, 0xfaafb8a6
    grev a7,s11,t0
    sw a7,16(a1)
    li t0, 0xcccb9502
    li s3, 0xde163e74
    grev s0,t0,s3
    sw s0,20(a1)
    li s1, 0x00002000
    li t4, 0x40f01f17
    grev a3,s1,t4
    sw a3,24(a1)
    li t6, 0x00120210
    li t4, 0xc6fe507a
    grev a6,t6,t4
    sw a6,28(a1)
    li s1, 0x00200900
    li s4, 0xf9fceffe
    grev s5,s1,s4
    sw s5,32(a1)
    li s3, 0x002c80c0
    li a6, 0xe2d30092
    grev a5,s3,a6
    sw a5,36(a1)
    li a7, 0x04000018
    li s0, 0x2d4792d3
    grev s2,a7,s0
    sw s2,40(a1)
    li a5, 0x08c03000
    li a0, 0x3fef8b13
    grev t5,a5,a0
    sw t5,44(a1)
    li t4, 0x0e030000
    li t1, 0x0000000b
    grev s5,t4,t1
    sw s5,48(a1)
    li s5, 0x80031100
    li a0, 0xefea7d18
    grev t3,s5,a0
    sw t3,52(a1)
    li a3, 0x82200401
    li s3, 0x821d8858
    grev s4,a3,s3
    sw s4,56(a1)
    li t4, 0xc480e100
    li s4, 0x4480874c
    grev a5,t4,s4
    sw a5,60(a1)
    RV_COMPLIANCE_HALT
RV_COMPLIANCE_CODE_END

.data
RV_COMPLIANCE_DATA_BEGIN
test_results:
.fill 16,4,-1
RV_COMPLIANCE_DATA_END
