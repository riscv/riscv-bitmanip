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
    li s10, 0x00000040
    li s9, 0x00020000
    max t5,s10,s9
    sw t5,24(a1)
    li t6, 0x00100000
    li a3, 0x00000000
    max s8,t6,a3
    sw s8,28(a1)
    li s2, 0x001815fa
    li s10, 0x001815db
    max a0,s2,s10
    sw a0,32(a1)
    li s5, 0x0263faf0
    li s11, 0x006af6f4
    max s9,s5,s11
    sw s9,36(a1)
    li s4, 0x1051ac9a
    li s7, 0x1051a9d8
    max a5,s4,s7
    sw a5,40(a1)
    li s7, 0x16070000
    li s0, 0x15020090
    max s2,s7,s0
    sw s2,44(a1)
    li s8, 0x17d47fc4
    li a0, 0x17d47fc6
    max t3,s8,a0
    sw t3,48(a1)
    li t2, 0x382e991b
    li s8, 0x382e999b
    max s3,t2,s8
    sw s3,52(a1)
    li t0, 0x3f025f9f
    li a4, 0x3f025f9e
    max a0,t0,a4
    sw a0,56(a1)
    li s0, 0x40000000
    li t5, 0x40000200
    max t0,s0,t5
    sw t0,60(a1)
    li s1, 0x41040098
    li s7, 0x41000098
    max t1,s1,s7
    sw t1,64(a1)
    li t3, 0x5332ff01
    li s2, 0x5332ff0c
    max a0,t3,s2
    sw a0,68(a1)
    li s2, 0x5583d725
    li s6, 0x5513f76d
    max s7,s2,s6
    sw s7,72(a1)
    li a7, 0x8ba9ff2d
    li t0, 0x8bf5ff1d
    max s6,a7,t0
    sw s6,76(a1)
    li t3, 0x9e7f57ab
    li a5, 0x5ebf0000
    max s3,t3,a5
    sw s3,80(a1)
    li t4, 0xa4dbf37b
    li t1, 0xa4dbf39b
    max t3,t4,t1
    sw t3,84(a1)
    li t6, 0xb58ff25f
    li s10, 0xb59df27d
    max a6,t6,s10
    sw a6,88(a1)
    li s3, 0xb5a168d9
    li a2, 0xb5a17d31
    max a7,s3,a2
    sw a7,92(a1)
    li s3, 0xbdf3d8b0
    li a2, 0xbfe2dcb0
    max t2,s3,a2
    sw t2,96(a1)
    li s2, 0xbfecbc33
    li a5, 0xbfe6bd33
    max s11,s2,a5
    sw s11,100(a1)
    li t4, 0xbff3d8b0
    li t5, 0xbfe2dcb0
    max a6,t4,t5
    sw a6,104(a1)
    li s1, 0xc104001f
    li s0, 0xc104001d
    max t2,s1,s0
    sw t2,108(a1)
    li s10, 0xde7ca325
    li s5, 0xde7ca724
    max s9,s10,s5
    sw s9,112(a1)
    li s6, 0xdef06600
    li t0, 0xdef06400
    max a0,s6,t0
    sw a0,116(a1)
    li t0, 0xe9767dca
    li a5, 0xfc05cdf8
    max t5,t0,a5
    sw t5,120(a1)
    li a3, 0xeffc84b1
    li s6, 0xeffd84b1
    max t6,a3,s6
    sw t6,124(a1)
    li s0, 0xffe2f8b0
    li t5, 0xffe2dcb0
    max s5,s0,t5
    sw s5,128(a1)
    RV_COMPLIANCE_HALT
RV_COMPLIANCE_CODE_END

.data
RV_COMPLIANCE_DATA_BEGIN
test_results:
.fill 33,4,-1
RV_COMPLIANCE_DATA_END
