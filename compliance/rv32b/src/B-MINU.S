#include "compliance_test.h"
#include "compliance_io.h"
#include "test_macros.h"

RV_COMPLIANCE_RV32M

RV_COMPLIANCE_CODE_BEGIN
    la a1,test_results
    li a3, 0x778bd1db
    li t6, 0xdef3c035
    minu a6,a3,t6
    sw a6,0(a1)
    li a4, 0xffaace79
    li t2, 0x11e15d6b
    minu a3,a4,t2
    sw a3,4(a1)
    li a5, 0x04bc5eac
    li s0, 0x33397f4e
    minu t3,a5,s0
    sw t3,8(a1)
    li t1, 0x40ee4840
    li s6, 0x18331b85
    minu s7,t1,s6
    sw s7,12(a1)
    li s3, 0x5a0d8ae2
    li t0, 0xfaafb8a6
    minu s9,s3,t0
    sw s9,16(a1)
    li s10, 0xcccb9502
    li t6, 0xde163e74
    minu s5,s10,t6
    sw s5,20(a1)
    li a7, 0x00100000
    li s0, 0x00000000
    minu t3,a7,s0
    sw t3,24(a1)
    li s10, 0x001815fa
    li t6, 0x001815db
    minu t1,s10,t6
    sw t1,28(a1)
    li s10, 0x1051ac9a
    li s1, 0x1051a9d8
    minu s2,s10,s1
    sw s2,32(a1)
    li s3, 0x16070000
    li s1, 0x15020090
    minu s8,s3,s1
    sw s8,36(a1)
    li a0, 0x17d47fc4
    li t0, 0x17d47fc6
    minu t5,a0,t0
    sw t5,40(a1)
    li s9, 0x382e991b
    li t1, 0x382e999b
    minu s11,s9,t1
    sw s11,44(a1)
    li a2, 0x3f025f9f
    li t2, 0x3f025f9e
    minu s7,a2,t2
    sw s7,48(a1)
    li t0, 0x41040098
    li s7, 0x41000098
    minu t1,t0,s7
    sw t1,52(a1)
    li a3, 0x5332ff01
    li a5, 0x5332ff0c
    minu s8,a3,a5
    sw s8,56(a1)
    li a4, 0x5583d725
    li t1, 0x5513f76d
    minu t5,a4,t1
    sw t5,60(a1)
    li t1, 0x8ba9ff2d
    li s11, 0x8bf5ff1d
    minu t6,t1,s11
    sw t6,64(a1)
    li s5, 0x9e7f57ab
    li t1, 0x5ebf0000
    minu a2,s5,t1
    sw a2,68(a1)
    li s4, 0xa4dbf37b
    li s0, 0xa4dbf39b
    minu s7,s4,s0
    sw s7,72(a1)
    li a2, 0xb5a168d9
    li s10, 0xb5a17d31
    minu s7,a2,s10
    sw s7,76(a1)
    li t1, 0xbdf3d8b0
    li s1, 0xbfe2dcb0
    minu s10,t1,s1
    sw s10,80(a1)
    li t1, 0xbff3d8b0
    li s6, 0xbfe2dcb0
    minu t3,t1,s6
    sw t3,84(a1)
    li t3, 0xc104001f
    li a5, 0xc104001d
    minu s1,t3,a5
    sw s1,88(a1)
    li s4, 0xde7ca325
    li s5, 0xde7ca724
    minu t0,s4,s5
    sw t0,92(a1)
    li s11, 0xdef06600
    li t1, 0xdef06400
    minu s4,s11,t1
    sw s4,96(a1)
    li s5, 0xe9767dca
    li a3, 0xfc05cdf8
    minu a5,s5,a3
    sw a5,100(a1)
    li t3, 0xffe2f8b0
    li a2, 0xffe2dcb0
    minu s0,t3,a2
    sw s0,104(a1)
    RV_COMPLIANCE_HALT
RV_COMPLIANCE_CODE_END

.data
RV_COMPLIANCE_DATA_BEGIN
test_results:
.fill 27,4,-1
RV_COMPLIANCE_DATA_END
