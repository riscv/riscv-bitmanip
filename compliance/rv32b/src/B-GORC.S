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
    li t3, 0x00002000
    li a7, 0x40f01f17
    gorc s11,t3,a7
    sw s11,24(a1)
    li s5, 0x00120210
    li t2, 0xc6fe507a
    gorc a3,s5,t2
    sw a3,28(a1)
    li t0, 0x00200900
    li t2, 0xf9fceffe
    gorc a7,t0,t2
    sw a7,32(a1)
    li s5, 0x002c80c0
    li a3, 0xe2d30092
    gorc t5,s5,a3
    sw t5,36(a1)
    li t3, 0x04000018
    li a7, 0x2d4792d3
    gorc s0,t3,a7
    sw s0,40(a1)
    li t5, 0x08c03000
    li s4, 0x3fef8b13
    gorc a5,t5,s4
    sw a5,44(a1)
    li s4, 0x0e030000
    li s9, 0x0000000b
    gorc s7,s4,s9
    sw s7,48(a1)
    li a4, 0x80031100
    li s9, 0xefea7d18
    gorc s8,a4,s9
    sw s8,52(a1)
    li t5, 0x82200401
    li s1, 0x821d8858
    gorc a2,t5,s1
    sw a2,56(a1)
    li s8, 0xc480e100
    li a4, 0x4480874c
    gorc t1,s8,a4
    sw t1,60(a1)
    RV_COMPLIANCE_HALT
RV_COMPLIANCE_CODE_END

.data
RV_COMPLIANCE_DATA_BEGIN
test_results:
.fill 16,4,-1
RV_COMPLIANCE_DATA_END
