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
    li s7, 0x00000040
    li s0, 0x00020000
    maxu s2,s7,s0
    sw s2,24(a1)
    li s8, 0x00100000
    li a0, 0x00000000
    maxu t3,s8,a0
    sw t3,28(a1)
    li t2, 0x001815fa
    li s8, 0x001815db
    maxu s3,t2,s8
    sw s3,32(a1)
    li t0, 0x0263faf0
    li a4, 0x006af6f4
    maxu a0,t0,a4
    sw a0,36(a1)
    li s0, 0x1051ac9a
    li t5, 0x1051a9d8
    maxu t0,s0,t5
    sw t0,40(a1)
    li s1, 0x16070000
    li s7, 0x15020090
    maxu t1,s1,s7
    sw t1,44(a1)
    li t3, 0x17d47fc4
    li s2, 0x17d47fc6
    maxu a0,t3,s2
    sw a0,48(a1)
    li s2, 0x382e991b
    li s6, 0x382e999b
    maxu s7,s2,s6
    sw s7,52(a1)
    li a7, 0x3f025f9f
    li t0, 0x3f025f9e
    maxu s6,a7,t0
    sw s6,56(a1)
    li t3, 0x40000000
    li a5, 0x40000200
    maxu s3,t3,a5
    sw s3,60(a1)
    li t4, 0x41040098
    li t1, 0x41000098
    maxu t3,t4,t1
    sw t3,64(a1)
    li t6, 0x5332ff01
    li s10, 0x5332ff0c
    maxu a6,t6,s10
    sw a6,68(a1)
    li s3, 0x5583d725
    li a2, 0x5513f76d
    maxu a7,s3,a2
    sw a7,72(a1)
    li s3, 0x8ba9ff2d
    li a2, 0x8bf5ff1d
    maxu t2,s3,a2
    sw t2,76(a1)
    li s2, 0x9e7f57ab
    li a5, 0x5ebf0000
    maxu s11,s2,a5
    sw s11,80(a1)
    li t4, 0xa4dbf37b
    li t5, 0xa4dbf39b
    maxu a6,t4,t5
    sw a6,84(a1)
    li s1, 0xb58ff25f
    li s0, 0xb59df27d
    maxu t2,s1,s0
    sw t2,88(a1)
    li s10, 0xb5a168d9
    li s5, 0xb5a17d31
    maxu s9,s10,s5
    sw s9,92(a1)
    li s6, 0xbdf3d8b0
    li t0, 0xbfe2dcb0
    maxu a0,s6,t0
    sw a0,96(a1)
    li t0, 0xbfecbc33
    li a5, 0xbfe6bd33
    maxu t5,t0,a5
    sw t5,100(a1)
    li a3, 0xbff3d8b0
    li s6, 0xbfe2dcb0
    maxu t6,a3,s6
    sw t6,104(a1)
    li s0, 0xc104001f
    li t5, 0xc104001d
    maxu s5,s0,t5
    sw s5,108(a1)
    li s7, 0xde7ca325
    li a7, 0xde7ca724
    maxu a3,s7,a7
    sw a3,112(a1)
    li t3, 0xdef06600
    li s4, 0xdef06400
    maxu t0,t3,s4
    sw t0,116(a1)
    li a4, 0xe9767dca
    li a7, 0xfc05cdf8
    maxu s8,a4,a7
    sw s8,120(a1)
    li t0, 0xeffc84b1
    li t5, 0xeffd84b1
    maxu s4,t0,t5
    sw s4,124(a1)
    li t1, 0xffe2f8b0
    li s2, 0xffe2dcb0
    maxu a7,t1,s2
    sw a7,128(a1)
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
