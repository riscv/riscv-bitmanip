#include "compliance_test.h"
#include "compliance_io.h"
#include "test_macros.h"

RV_COMPLIANCE_RV32M

RV_COMPLIANCE_CODE_BEGIN
    la a1,test_results
    li s5, 0x778bd1db
    li s8, 0xdef3c035
    maxu t3,s5,s8
    sw t3,0(a1)
    li s7, 0xffaace79
    li t3, 0x11e15d6b
    maxu s6,s7,t3
    sw s6,4(a1)
    li a2, 0x04bc5eac
    li a6, 0x33397f4e
    maxu t0,a2,a6
    sw t0,8(a1)
    li t6, 0x40ee4840
    li a7, 0x18331b85
    maxu s2,t6,a7
    sw s2,12(a1)
    li t1, 0x5a0d8ae2
    li a5, 0xfaafb8a6
    maxu t5,t1,a5
    sw t5,16(a1)
    li a5, 0xcccb9502
    li s7, 0xde163e74
    maxu a3,a5,s7
    sw a3,20(a1)
    li t0, 0x00000040
    li t5, 0x00020000
    maxu s4,t0,t5
    sw s4,24(a1)
    li a6, 0x00100000
    li a0, 0x00000000
    maxu t3,a6,a0
    sw t3,28(a1)
    li a3, 0x001815fa
    li s8, 0x001815db
    maxu t4,a3,s8
    sw t4,32(a1)
    li t1, 0x0263faf0
    li s4, 0x006af6f4
    maxu s7,t1,s4
    sw s7,36(a1)
    li s2, 0x1051ac9a
    li t3, 0x1051a9d8
    maxu s5,s2,t3
    sw s5,40(a1)
    li t1, 0x16070000
    li s6, 0x15020090
    maxu t6,t1,s6
    sw t6,44(a1)
    li a2, 0x17d47fc4
    li t0, 0x17d47fc6
    maxu s3,a2,t0
    sw s3,48(a1)
    li a6, 0x382e991b
    li a0, 0x382e999b
    maxu s8,a6,a0
    sw s8,52(a1)
    li s4, 0x3f025f9f
    li a7, 0x3f025f9e
    maxu a4,s4,a7
    sw a4,56(a1)
    li s9, 0x40000000
    li s5, 0x40000200
    maxu s6,s9,s5
    sw s6,60(a1)
    li a3, 0x41040098
    li a6, 0x41000098
    maxu a0,a3,a6
    sw a0,64(a1)
    li s5, 0x5332ff01
    li s10, 0x5332ff0c
    maxu s6,s5,s10
    sw s6,68(a1)
    li t1, 0x5583d725
    li s10, 0x5513f76d
    maxu a3,t1,s10
    sw a3,72(a1)
    li a5, 0x8ba9ff2d
    li t1, 0x8bf5ff1d
    maxu a4,a5,t1
    sw a4,76(a1)
    li t2, 0x9e7f57ab
    li s1, 0x5ebf0000
    maxu a6,t2,s1
    sw a6,80(a1)
    li t2, 0xa4dbf37b
    li s5, 0xa4dbf39b
    maxu a4,t2,s5
    sw a4,84(a1)
    li a7, 0xb58ff25f
    li a4, 0xb59df27d
    maxu t5,a7,a4
    sw t5,88(a1)
    li a6, 0xb5a168d9
    li s10, 0xb5a17d31
    maxu s1,a6,s10
    sw s1,92(a1)
    li a3, 0xbdf3d8b0
    li t1, 0xbfe2dcb0
    maxu a5,a3,t1
    sw a5,96(a1)
    li a4, 0xbfecbc33
    li t5, 0xbfe6bd33
    maxu s6,a4,t5
    sw s6,100(a1)
    li s8, 0xbff3d8b0
    li s0, 0xbfe2dcb0
    maxu s10,s8,s0
    sw s10,104(a1)
    li s11, 0xc104001f
    li s1, 0xc104001d
    maxu a5,s11,s1
    sw a5,108(a1)
    li t5, 0xde7ca325
    li s8, 0xde7ca724
    maxu s3,t5,s8
    sw s3,112(a1)
    li a0, 0xdef06600
    li t0, 0xdef06400
    maxu s0,a0,t0
    sw s0,116(a1)
    li s1, 0xe9767dca
    li t5, 0xfc05cdf8
    maxu t3,s1,t5
    sw t3,120(a1)
    li s9, 0xeffc84b1
    li t4, 0xeffd84b1
    maxu a6,s9,t4
    sw a6,124(a1)
    li t4, 0xffe2f8b0
    li t3, 0xffe2dcb0
    maxu s5,t4,t3
    sw s5,128(a1)
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
