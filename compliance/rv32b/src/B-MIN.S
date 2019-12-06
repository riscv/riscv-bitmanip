#include "compliance_test.h"
#include "compliance_io.h"
#include "test_macros.h"

RV_COMPLIANCE_RV32M

RV_COMPLIANCE_CODE_BEGIN
    la a1,test_results
    li s6, 0x778bd1db
    li a0, 0xdef3c035
    min s5,s6,a0
    sw s5,0(a1)
    li s6, 0xffaace79
    li s7, 0x11e15d6b
    min t3,s6,s7
    sw t3,4(a1)
    li s9, 0x04bc5eac
    li s10, 0x33397f4e
    min a6,s9,s10
    sw a6,8(a1)
    li s10, 0x40ee4840
    li t6, 0x18331b85
    min s5,s10,t6
    sw s5,12(a1)
    li s5, 0x5a0d8ae2
    li t5, 0xfaafb8a6
    min a2,s5,t5
    sw a2,16(a1)
    li a0, 0xcccb9502
    li s2, 0xde163e74
    min a2,a0,s2
    sw a2,20(a1)
    li s9, 0x00000040
    li t2, 0x00020000
    min s3,s9,t2
    sw s3,24(a1)
    li a6, 0x00100000
    li a4, 0x00000000
    min s6,a6,a4
    sw s6,28(a1)
    li t6, 0x001815fa
    li s11, 0x001815db
    min t3,t6,s11
    sw t3,32(a1)
    li a0, 0x0263faf0
    li t4, 0x006af6f4
    min s4,a0,t4
    sw s4,36(a1)
    li s9, 0x1051ac9a
    li a0, 0x1051a9d8
    min a5,s9,a0
    sw a5,40(a1)
    li a7, 0x16070000
    li s5, 0x15020090
    min a3,a7,s5
    sw a3,44(a1)
    li s9, 0x17d47fc4
    li t6, 0x17d47fc6
    min s6,s9,t6
    sw s6,48(a1)
    li s3, 0x382e991b
    li s6, 0x382e999b
    min s1,s3,s6
    sw s1,52(a1)
    li s0, 0x3f025f9f
    li a4, 0x3f025f9e
    min t2,s0,a4
    sw t2,56(a1)
    li s1, 0x40000000
    li t6, 0x40000200
    min t4,s1,t6
    sw t4,60(a1)
    li s8, 0x41040098
    li s1, 0x41000098
    min t0,s8,s1
    sw t0,64(a1)
    li a0, 0x5332ff01
    li a4, 0x5332ff0c
    min t4,a0,a4
    sw t4,68(a1)
    li t3, 0x5583d725
    li s4, 0x5513f76d
    min a6,t3,s4
    sw a6,72(a1)
    li a3, 0x8ba9ff2d
    li a6, 0x8bf5ff1d
    min s6,a3,a6
    sw s6,76(a1)
    li a2, 0x9e7f57ab
    li s8, 0x5ebf0000
    min s6,a2,s8
    sw s6,80(a1)
    li s6, 0xa4dbf37b
    li a3, 0xa4dbf39b
    min s7,s6,a3
    sw s7,84(a1)
    li t0, 0xb58ff25f
    li s1, 0xb59df27d
    min a5,t0,s1
    sw a5,88(a1)
    li s4, 0xb5a168d9
    li a5, 0xb5a17d31
    min s3,s4,a5
    sw s3,92(a1)
    li a7, 0xbdf3d8b0
    li t2, 0xbfe2dcb0
    min s3,a7,t2
    sw s3,96(a1)
    li a5, 0xbfecbc33
    li t4, 0xbfe6bd33
    min s10,a5,t4
    sw s10,100(a1)
    li s1, 0xbff3d8b0
    li s3, 0xbfe2dcb0
    min s11,s1,s3
    sw s11,104(a1)
    li s9, 0xc104001f
    li s7, 0xc104001d
    min a4,s9,s7
    sw a4,108(a1)
    li a0, 0xde7ca325
    li t5, 0xde7ca724
    min s10,a0,t5
    sw s10,112(a1)
    li t4, 0xdef06600
    li s11, 0xdef06400
    min t6,t4,s11
    sw t6,116(a1)
    li t2, 0xe9767dca
    li s10, 0xfc05cdf8
    min s8,t2,s10
    sw s8,120(a1)
    li s6, 0xeffc84b1
    li a2, 0xeffd84b1
    min s2,s6,a2
    sw s2,124(a1)
    li t2, 0xffe2f8b0
    li t4, 0xffe2dcb0
    min s8,t2,t4
    sw s8,128(a1)
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
