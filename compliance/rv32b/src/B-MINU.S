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
    li a7, 0x00000040
    li s5, 0x00020000
    minu a3,a7,s5
    sw a3,24(a1)
    li s9, 0x00100000
    li t6, 0x00000000
    minu s6,s9,t6
    sw s6,28(a1)
    li s3, 0x001815fa
    li s6, 0x001815db
    minu s1,s3,s6
    sw s1,32(a1)
    li s0, 0x0263faf0
    li a4, 0x006af6f4
    minu t2,s0,a4
    sw t2,36(a1)
    li s1, 0x1051ac9a
    li t6, 0x1051a9d8
    minu t4,s1,t6
    sw t4,40(a1)
    li s8, 0x16070000
    li s1, 0x15020090
    minu t0,s8,s1
    sw t0,44(a1)
    li a0, 0x17d47fc4
    li a4, 0x17d47fc6
    minu t4,a0,a4
    sw t4,48(a1)
    li t3, 0x382e991b
    li s4, 0x382e999b
    minu a6,t3,s4
    sw a6,52(a1)
    li a3, 0x3f025f9f
    li a6, 0x3f025f9e
    minu s6,a3,a6
    sw s6,56(a1)
    li a2, 0x40000000
    li s8, 0x40000200
    minu s6,a2,s8
    sw s6,60(a1)
    li s6, 0x41040098
    li a3, 0x41000098
    minu s7,s6,a3
    sw s7,64(a1)
    li t0, 0x5332ff01
    li s1, 0x5332ff0c
    minu a5,t0,s1
    sw a5,68(a1)
    li s4, 0x5583d725
    li a5, 0x5513f76d
    minu s3,s4,a5
    sw s3,72(a1)
    li a7, 0x8ba9ff2d
    li t2, 0x8bf5ff1d
    minu s3,a7,t2
    sw s3,76(a1)
    li a5, 0x9e7f57ab
    li t4, 0x5ebf0000
    minu s10,a5,t4
    sw s10,80(a1)
    li s1, 0xa4dbf37b
    li s3, 0xa4dbf39b
    minu s11,s1,s3
    sw s11,84(a1)
    li s9, 0xb58ff25f
    li s7, 0xb59df27d
    minu a4,s9,s7
    sw a4,88(a1)
    li a0, 0xb5a168d9
    li t5, 0xb5a17d31
    minu s10,a0,t5
    sw s10,92(a1)
    li t4, 0xbdf3d8b0
    li s11, 0xbfe2dcb0
    minu t6,t4,s11
    sw t6,96(a1)
    li t2, 0xbfecbc33
    li s10, 0xbfe6bd33
    minu s8,t2,s10
    sw s8,100(a1)
    li s6, 0xbff3d8b0
    li a2, 0xbfe2dcb0
    minu s2,s6,a2
    sw s2,104(a1)
    li t2, 0xc104001f
    li t4, 0xc104001d
    minu s8,t2,t4
    sw s8,108(a1)
    li a5, 0xde7ca325
    li a0, 0xde7ca724
    minu s1,a5,a0
    sw s1,112(a1)
    li a6, 0xdef06600
    li a3, 0xdef06400
    minu a4,a6,a3
    sw a4,116(a1)
    li a6, 0xe9767dca
    li a3, 0xfc05cdf8
    minu s7,a6,a3
    sw s7,120(a1)
    li a0, 0xeffc84b1
    li s6, 0xeffd84b1
    minu t4,a0,s6
    sw t4,124(a1)
    li a4, 0xffe2f8b0
    li s6, 0xffe2dcb0
    minu t6,a4,s6
    sw t6,128(a1)
    sw zero,132(a1)
    sw zero,136(a1)
    sw zero,140(a1)
    RV_COMPLIANCE_HALT
RV_COMPLIANCE_CODE_END

.data
RV_COMPLIANCE_DATA_BEGIN
test_results:
.fill 36,4,-1
RV_COMPLIANCE_DATA_END
