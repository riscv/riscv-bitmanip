#include "compliance_test.h"
#include "compliance_io.h"
#include "test_macros.h"

RV_COMPLIANCE_RV32M

RV_COMPLIANCE_CODE_BEGIN
    la a1,test_results
    li a7, 0x778bd1db
    li s8, 0xdef3c035
    max t3,a7,s8
    sw t3,0(a1)
    li a0, 0xffaace79
    li s7, 0x11e15d6b
    max t2,a0,s7
    sw t2,4(a1)
    li a5, 0x04bc5eac
    li a6, 0x33397f4e
    max a4,a5,a6
    sw a4,8(a1)
    li a2, 0x40ee4840
    li s9, 0x18331b85
    max s8,a2,s9
    sw s8,12(a1)
    li t0, 0x5a0d8ae2
    li s3, 0xfaafb8a6
    max s0,t0,s3
    sw s0,16(a1)
    li s11, 0xcccb9502
    li a3, 0xde163e74
    max s3,s11,a3
    sw s3,20(a1)
    li s2, 0x00000040
    li t3, 0x00020000
    max s5,s2,t3
    sw s5,24(a1)
    li t1, 0x00100000
    li s6, 0x00000000
    max t6,t1,s6
    sw t6,28(a1)
    li a2, 0x001815fa
    li t0, 0x001815db
    max s3,a2,t0
    sw s3,32(a1)
    li a6, 0x0263faf0
    li a0, 0x006af6f4
    max s8,a6,a0
    sw s8,36(a1)
    li s4, 0x1051ac9a
    li a7, 0x1051a9d8
    max a4,s4,a7
    sw a4,40(a1)
    li s9, 0x16070000
    li s5, 0x15020090
    max s6,s9,s5
    sw s6,44(a1)
    li a3, 0x17d47fc4
    li a6, 0x17d47fc6
    max a0,a3,a6
    sw a0,48(a1)
    li s5, 0x382e991b
    li s10, 0x382e999b
    max s6,s5,s10
    sw s6,52(a1)
    li t1, 0x3f025f9f
    li s10, 0x3f025f9e
    max a3,t1,s10
    sw a3,56(a1)
    li a5, 0x40000000
    li t1, 0x40000200
    max a4,a5,t1
    sw a4,60(a1)
    li t2, 0x41040098
    li s1, 0x41000098
    max a6,t2,s1
    sw a6,64(a1)
    li t2, 0x5332ff01
    li s5, 0x5332ff0c
    max a4,t2,s5
    sw a4,68(a1)
    li a7, 0x5583d725
    li a4, 0x5513f76d
    max t5,a7,a4
    sw t5,72(a1)
    li a6, 0x8ba9ff2d
    li s10, 0x8bf5ff1d
    max s1,a6,s10
    sw s1,76(a1)
    li a3, 0x9e7f57ab
    li t1, 0x5ebf0000
    max a5,a3,t1
    sw a5,80(a1)
    li a4, 0xa4dbf37b
    li t5, 0xa4dbf39b
    max s6,a4,t5
    sw s6,84(a1)
    li s8, 0xb58ff25f
    li s0, 0xb59df27d
    max s10,s8,s0
    sw s10,88(a1)
    li s11, 0xb5a168d9
    li s1, 0xb5a17d31
    max a5,s11,s1
    sw a5,92(a1)
    li t5, 0xbdf3d8b0
    li s8, 0xbfe2dcb0
    max s3,t5,s8
    sw s3,96(a1)
    li a0, 0xbfecbc33
    li t0, 0xbfe6bd33
    max s0,a0,t0
    sw s0,100(a1)
    li s1, 0xbff3d8b0
    li t5, 0xbfe2dcb0
    max t3,s1,t5
    sw t3,104(a1)
    li s9, 0xc104001f
    li t4, 0xc104001d
    max a6,s9,t4
    sw a6,108(a1)
    li t4, 0xde7ca325
    li t3, 0xde7ca724
    max s5,t4,t3
    sw s5,112(a1)
    li t5, 0xdef06600
    li s4, 0xdef06400
    max t6,t5,s4
    sw t6,116(a1)
    li a7, 0xe9767dca
    li s7, 0xfc05cdf8
    max t4,a7,s7
    sw t4,120(a1)
    li a4, 0xeffc84b1
    li t2, 0xeffd84b1
    max a7,a4,t2
    sw a7,124(a1)
    li a3, 0xffe2f8b0
    li t0, 0xffe2dcb0
    max s0,a3,t0
    sw s0,128(a1)
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
