#include "compliance_test.h"
#include "compliance_io.h"
#include "test_macros.h"

RV_COMPLIANCE_RV32M

RV_COMPLIANCE_CODE_BEGIN
    la a1,test_results
    li t4, 0x778bd1db
    li s9, 0xdef3c035
    minu s3,t4,s9
    sw s3,0(a1)
    li a7, 0xffaace79
    li s8, 0x11e15d6b
    minu t3,a7,s8
    sw t3,4(a1)
    li s6, 0x04bc5eac
    li s7, 0x33397f4e
    minu t3,s6,s7
    sw t3,8(a1)
    li a7, 0x40ee4840
    li a5, 0x18331b85
    minu t2,a7,a5
    sw t2,12(a1)
    li t6, 0x5a0d8ae2
    li s5, 0xfaafb8a6
    minu s11,t6,s5
    sw s11,16(a1)
    li s6, 0xcccb9502
    li t5, 0xde163e74
    minu a4,s6,t5
    sw a4,20(a1)
    li s5, 0x00000040
    li t2, 0x00020000
    minu a3,s5,t2
    sw a3,24(a1)
    li s5, 0x00100000
    li a3, 0x00000000
    minu t5,s5,a3
    sw t5,28(a1)
    li t5, 0x001815fa
    li s4, 0x001815db
    minu a5,t5,s4
    sw a5,32(a1)
    li a4, 0x0263faf0
    li s9, 0x006af6f4
    minu s8,a4,s9
    sw s8,36(a1)
    li s8, 0x1051ac9a
    li a4, 0x1051a9d8
    minu t1,s8,a4
    sw t1,40(a1)
    li t1, 0x16070000
    li t4, 0x15020090
    minu s10,t1,t4
    sw s10,44(a1)
    li t2, 0x17d47fc4
    li t0, 0x17d47fc6
    minu t6,t2,t0
    sw t6,48(a1)
    li s2, 0x382e991b
    li s5, 0x382e999b
    minu a6,s2,s5
    sw a6,52(a1)
    li t5, 0x3f025f9f
    li s8, 0x3f025f9e
    minu t0,t5,s8
    sw t0,56(a1)
    li s10, 0x40000000
    li t3, 0x40000200
    minu a0,s10,t3
    sw a0,60(a1)
    li a6, 0x41040098
    li a0, 0x41000098
    minu a7,a6,a0
    sw a7,64(a1)
    li a3, 0x5332ff01
    li s0, 0x5332ff0c
    minu s7,a3,s0
    sw s7,68(a1)
    li s8, 0x5583d725
    li a4, 0x5513f76d
    minu s9,s8,a4
    sw s9,72(a1)
    li s5, 0x8ba9ff2d
    li s1, 0x8bf5ff1d
    minu a0,s5,s1
    sw a0,76(a1)
    li a4, 0x9e7f57ab
    li t3, 0x5ebf0000
    minu t5,a4,t3
    sw t5,80(a1)
    li s2, 0xa4dbf37b
    li s8, 0xa4dbf39b
    minu s1,s2,s8
    sw s1,84(a1)
    li s2, 0xb58ff25f
    li a3, 0xb59df27d
    minu s4,s2,a3
    sw s4,88(a1)
    li s8, 0xb5a168d9
    li a3, 0xb5a17d31
    minu a2,s8,a3
    sw a2,92(a1)
    li t1, 0xbdf3d8b0
    li t3, 0xbfe2dcb0
    minu s10,t1,t3
    sw s10,96(a1)
    li s2, 0xbfecbc33
    li s5, 0xbfe6bd33
    minu t0,s2,s5
    sw t0,100(a1)
    li a4, 0xbff3d8b0
    li a7, 0xbfe2dcb0
    minu t0,a4,a7
    sw t0,104(a1)
    li a3, 0xc104001f
    li s11, 0xc104001d
    minu s1,a3,s11
    sw s1,108(a1)
    li t4, 0xde7ca325
    li s11, 0xde7ca724
    minu a3,t4,s11
    sw a3,112(a1)
    li t2, 0xdef06600
    li s7, 0xdef06400
    minu a5,t2,s7
    sw a5,116(a1)
    li s4, 0xe9767dca
    li s2, 0xfc05cdf8
    minu t5,s4,s2
    sw t5,120(a1)
    li a7, 0xeffc84b1
    li a5, 0xeffd84b1
    minu s5,a7,a5
    sw s5,124(a1)
    li s10, 0xffe2f8b0
    li s0, 0xffe2dcb0
    minu a6,s10,s0
    sw a6,128(a1)
    RV_COMPLIANCE_HALT
RV_COMPLIANCE_CODE_END

.data
RV_COMPLIANCE_DATA_BEGIN
test_results:
.fill 33,4,-1
RV_COMPLIANCE_DATA_END
