#include "compliance_test.h"
#include "compliance_io.h"
#include "test_macros.h"

RV_COMPLIANCE_RV32M

RV_COMPLIANCE_CODE_BEGIN
    la a1,test_results
    li t6, 0x778bd1db
    li s1, 0xdef3c035
    grev s3,t6,s1
    sw s3,0(a1)
    li s10, 0xffaace79
    li t6, 0x11e15d6b
    grev s3,s10,t6
    sw s3,4(a1)
    li a4, 0x04bc5eac
    li t6, 0x33397f4e
    grev s4,a4,t6
    sw s4,8(a1)
    li s0, 0x40ee4840
    li a5, 0x18331b85
    grev s11,s0,a5
    sw s11,12(a1)
    li t1, 0x5a0d8ae2
    li s10, 0xfaafb8a6
    grev s2,t1,s10
    sw s2,16(a1)
    li s5, 0xcccb9502
    li s1, 0xde163e74
    grev s9,s5,s1
    sw s9,20(a1)
    li a7, 0x00002000
    li t6, 0x40f01f17
    grev a0,a7,t6
    sw a0,24(a1)
    li s6, 0x00120210
    li a6, 0xc6fe507a
    grev s11,s6,a6
    sw s11,28(a1)
    li s9, 0x00200900
    li t4, 0xf9fceffe
    grev a0,s9,t4
    sw a0,32(a1)
    li s9, 0x002c80c0
    li a3, 0xe2d30092
    grev s0,s9,a3
    sw s0,36(a1)
    li a6, 0x04000018
    li s7, 0x2d4792d3
    grev s5,a6,s7
    sw s5,40(a1)
    li s0, 0x08c03000
    li t2, 0x3fef8b13
    grev s7,s0,t2
    sw s7,44(a1)
    li s2, 0x0e030000
    li t2, 0x0000000b
    grev s3,s2,t2
    sw s3,48(a1)
    li s7, 0x80031100
    li t0, 0xefea7d18
    grev s9,s7,t0
    sw s9,52(a1)
    li a5, 0x82200401
    li s4, 0x821d8858
    grev s8,a5,s4
    sw s8,56(a1)
    li s0, 0xc480e100
    li s7, 0x4480874c
    grev a2,s0,s7
    sw a2,60(a1)
    RV_COMPLIANCE_HALT
RV_COMPLIANCE_CODE_END

.data
RV_COMPLIANCE_DATA_BEGIN
test_results:
.fill 16,4,-1
RV_COMPLIANCE_DATA_END
