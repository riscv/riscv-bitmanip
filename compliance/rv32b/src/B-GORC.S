#include "compliance_test.h"
#include "compliance_io.h"
#include "test_macros.h"

RV_COMPLIANCE_RV32M

RV_COMPLIANCE_CODE_BEGIN
    la a1,test_results
    li t2, 0x778bd1db
    li s2, 0xdef3c035
    gorc t0,t2,s2
    sw t0,0(a1)
    li t1, 0xffaace79
    li s6, 0x11e15d6b
    gorc s7,t1,s6
    sw s7,4(a1)
    li a7, 0x04bc5eac
    li a0, 0x33397f4e
    gorc s7,a7,a0
    sw s7,8(a1)
    li t5, 0x40ee4840
    li s3, 0x18331b85
    gorc a2,t5,s3
    sw a2,12(a1)
    li a6, 0x5a0d8ae2
    li t2, 0xfaafb8a6
    gorc s0,a6,t2
    sw s0,16(a1)
    li t3, 0xcccb9502
    li s9, 0xde163e74
    gorc s4,t3,s9
    sw s4,20(a1)
    li s8, 0x00002000
    li a4, 0x40f01f17
    gorc t1,s8,a4
    sw t1,24(a1)
    li s8, 0x00120210
    li s4, 0xc6fe507a
    gorc s7,s8,s4
    sw s7,28(a1)
    li t1, 0x00200900
    li t4, 0xf9fceffe
    gorc s10,t1,t4
    sw s10,32(a1)
    li s9, 0x002c80c0
    li t2, 0xe2d30092
    gorc s3,s9,t2
    sw s3,36(a1)
    li t2, 0x04000018
    li t0, 0x2d4792d3
    gorc t6,t2,t0
    sw t6,40(a1)
    li a6, 0x08c03000
    li a4, 0x3fef8b13
    gorc s6,a6,a4
    sw s6,44(a1)
    li s2, 0x0e030000
    li s5, 0x0000000b
    gorc a6,s2,s5
    sw a6,48(a1)
    li t6, 0x80031100
    li s11, 0xefea7d18
    gorc t3,t6,s11
    sw t3,52(a1)
    li t5, 0x82200401
    li s8, 0x821d8858
    gorc t0,t5,s8
    sw t0,56(a1)
    li a0, 0xc480e100
    li t4, 0x4480874c
    gorc s4,a0,t4
    sw s4,60(a1)
    RV_COMPLIANCE_HALT
RV_COMPLIANCE_CODE_END

.data
RV_COMPLIANCE_DATA_BEGIN
test_results:
.fill 16,4,-1
RV_COMPLIANCE_DATA_END
