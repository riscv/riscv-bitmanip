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
    li a6, 0x00000040
    li a0, 0x00020000
    min a7,a6,a0
    sw a7,24(a1)
    li a3, 0x00100000
    li s0, 0x00000000
    min s7,a3,s0
    sw s7,28(a1)
    li s8, 0x001815fa
    li a4, 0x001815db
    min s9,s8,a4
    sw s9,32(a1)
    li s5, 0x0263faf0
    li s1, 0x006af6f4
    min a0,s5,s1
    sw a0,36(a1)
    li a4, 0x1051ac9a
    li t3, 0x1051a9d8
    min t5,a4,t3
    sw t5,40(a1)
    li s2, 0x16070000
    li s8, 0x15020090
    min s1,s2,s8
    sw s1,44(a1)
    li s2, 0x17d47fc4
    li a3, 0x17d47fc6
    min s4,s2,a3
    sw s4,48(a1)
    li s8, 0x382e991b
    li a3, 0x382e999b
    min a2,s8,a3
    sw a2,52(a1)
    li t1, 0x3f025f9f
    li t3, 0x3f025f9e
    min s10,t1,t3
    sw s10,56(a1)
    li s2, 0x40000000
    li s5, 0x40000200
    min t0,s2,s5
    sw t0,60(a1)
    li a4, 0x41040098
    li a7, 0x41000098
    min t0,a4,a7
    sw t0,64(a1)
    li a3, 0x5332ff01
    li s11, 0x5332ff0c
    min s1,a3,s11
    sw s1,68(a1)
    li t4, 0x5583d725
    li s11, 0x5513f76d
    min a3,t4,s11
    sw a3,72(a1)
    li t2, 0x8ba9ff2d
    li s7, 0x8bf5ff1d
    min a5,t2,s7
    sw a5,76(a1)
    li s4, 0x9e7f57ab
    li s2, 0x5ebf0000
    min t5,s4,s2
    sw t5,80(a1)
    li a7, 0xa4dbf37b
    li a5, 0xa4dbf39b
    min s5,a7,a5
    sw s5,84(a1)
    li s10, 0xb58ff25f
    li s0, 0xb59df27d
    min a6,s10,s0
    sw a6,88(a1)
    li t2, 0xb5a168d9
    li s0, 0xb5a17d31
    min a4,t2,s0
    sw a4,92(a1)
    li s3, 0xbdf3d8b0
    li s10, 0xbfe2dcb0
    min s5,s3,s10
    sw s5,96(a1)
    li s9, 0xbfecbc33
    li t0, 0xbfe6bd33
    min s0,s9,t0
    sw s0,100(a1)
    li s6, 0xbff3d8b0
    li s11, 0xbfe2dcb0
    min t2,s6,s11
    sw t2,104(a1)
    li a5, 0xc104001f
    li a2, 0xc104001d
    min t4,a5,a2
    sw t4,108(a1)
    li s3, 0xde7ca325
    li s10, 0xde7ca724
    min s9,s3,s10
    sw s9,112(a1)
    li s4, 0xdef06600
    li t1, 0xdef06400
    min a6,s4,t1
    sw a6,116(a1)
    li t3, 0xe9767dca
    li s0, 0xfc05cdf8
    min a2,t3,s0
    sw a2,120(a1)
    li t4, 0xeffc84b1
    li t6, 0xeffd84b1
    min s5,t4,t6
    sw s5,124(a1)
    li a7, 0xffe2f8b0
    li t1, 0xffe2dcb0
    min s6,a7,t1
    sw s6,128(a1)
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
