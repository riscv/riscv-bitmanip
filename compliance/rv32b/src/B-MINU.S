#include "compliance_test.h"
#include "compliance_io.h"
#include "test_macros.h"

RV_COMPLIANCE_RV32M

RV_COMPLIANCE_CODE_BEGIN
    la a1,test_results
    li t1, 0x778bd1db
    li t0, 0xdef3c035
    minu a0,t1,t0
    sw a0,0(a1)
    li s5, 0xffaace79
    li s0, 0x11e15d6b
    minu s1,s5,s0
    sw s1,4(a1)
    li a6, 0x04bc5eac
    li t1, 0x33397f4e
    minu a5,a6,t1
    sw a5,8(a1)
    li a7, 0x40ee4840
    li t0, 0x18331b85
    minu a6,a7,t0
    sw a6,12(a1)
    li a4, 0x5a0d8ae2
    li s0, 0xfaafb8a6
    minu s9,a4,s0
    sw s9,16(a1)
    li s4, 0xcccb9502
    li t3, 0xde163e74
    minu a0,s4,t3
    sw a0,20(a1)
    li t2, 0x00000040
    li t0, 0x00020000
    minu t6,t2,t0
    sw t6,24(a1)
    li s2, 0x00100000
    li s5, 0x00000000
    minu a6,s2,s5
    sw a6,28(a1)
    li t5, 0x001815fa
    li s8, 0x001815db
    minu t0,t5,s8
    sw t0,32(a1)
    li s10, 0x0263faf0
    li t3, 0x006af6f4
    minu a0,s10,t3
    sw a0,36(a1)
    li a6, 0x1051ac9a
    li a0, 0x1051a9d8
    minu a7,a6,a0
    sw a7,40(a1)
    li a3, 0x16070000
    li s0, 0x15020090
    minu s7,a3,s0
    sw s7,44(a1)
    li s8, 0x17d47fc4
    li a4, 0x17d47fc6
    minu s9,s8,a4
    sw s9,48(a1)
    li s5, 0x382e991b
    li s1, 0x382e999b
    minu a0,s5,s1
    sw a0,52(a1)
    li a4, 0x3f025f9f
    li t3, 0x3f025f9e
    minu t5,a4,t3
    sw t5,56(a1)
    li s2, 0x40000000
    li s8, 0x40000200
    minu s1,s2,s8
    sw s1,60(a1)
    li s2, 0x41040098
    li a3, 0x41000098
    minu s4,s2,a3
    sw s4,64(a1)
    li s8, 0x5332ff01
    li a3, 0x5332ff0c
    minu a2,s8,a3
    sw a2,68(a1)
    li t1, 0x5583d725
    li t3, 0x5513f76d
    minu s10,t1,t3
    sw s10,72(a1)
    li s2, 0x8ba9ff2d
    li s5, 0x8bf5ff1d
    minu t0,s2,s5
    sw t0,76(a1)
    li a4, 0x9e7f57ab
    li a7, 0x5ebf0000
    minu t0,a4,a7
    sw t0,80(a1)
    li a3, 0xa4dbf37b
    li s11, 0xa4dbf39b
    minu s1,a3,s11
    sw s1,84(a1)
    li t4, 0xb58ff25f
    li s11, 0xb59df27d
    minu a3,t4,s11
    sw a3,88(a1)
    li t2, 0xb5a168d9
    li s7, 0xb5a17d31
    minu a5,t2,s7
    sw a5,92(a1)
    li s4, 0xbdf3d8b0
    li s2, 0xbfe2dcb0
    minu t5,s4,s2
    sw t5,96(a1)
    li a7, 0xbfecbc33
    li a5, 0xbfe6bd33
    minu s5,a7,a5
    sw s5,100(a1)
    li s10, 0xbff3d8b0
    li s0, 0xbfe2dcb0
    minu a6,s10,s0
    sw a6,104(a1)
    li t2, 0xc104001f
    li s0, 0xc104001d
    minu a4,t2,s0
    sw a4,108(a1)
    li s3, 0xde7ca325
    li s10, 0xde7ca724
    minu s5,s3,s10
    sw s5,112(a1)
    li s9, 0xdef06600
    li t0, 0xdef06400
    minu s0,s9,t0
    sw s0,116(a1)
    li s6, 0xe9767dca
    li s11, 0xfc05cdf8
    minu t2,s6,s11
    sw t2,120(a1)
    li a5, 0xeffc84b1
    li a2, 0xeffd84b1
    minu t4,a5,a2
    sw t4,124(a1)
    li s3, 0xffe2f8b0
    li s10, 0xffe2dcb0
    minu s9,s3,s10
    sw s9,128(a1)
    RV_COMPLIANCE_HALT
RV_COMPLIANCE_CODE_END

.data
RV_COMPLIANCE_DATA_BEGIN
test_results:
.fill 33,4,-1
RV_COMPLIANCE_DATA_END
