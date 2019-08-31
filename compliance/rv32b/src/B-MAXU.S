#include "compliance_test.h"
#include "compliance_io.h"
#include "test_macros.h"

RV_COMPLIANCE_RV32M

RV_COMPLIANCE_CODE_BEGIN
    la a1,test_results
    li s9, 0x778bd1db
    li t2, 0xdef3c035
    maxu s0,s9,t2
    sw s0,0(a1)
    li t5, 0xffaace79
    li s9, 0x11e15d6b
    maxu a7,t5,s9
    sw a7,4(a1)
    li a0, 0x04bc5eac
    li s7, 0x33397f4e
    maxu t2,a0,s7
    sw t2,8(a1)
    li s9, 0x40ee4840
    li s10, 0x18331b85
    maxu a6,s9,s10
    sw a6,12(a1)
    li a5, 0x5a0d8ae2
    li a4, 0xfaafb8a6
    maxu t4,a5,a4
    sw t4,16(a1)
    li t0, 0xcccb9502
    li a3, 0xde163e74
    maxu s2,t0,a3
    sw s2,20(a1)
    li s6, 0x00000040
    li a6, 0x00020000
    maxu s11,s6,a6
    sw s11,24(a1)
    li s9, 0x00100000
    li a3, 0x00000000
    maxu s0,s9,a3
    sw s0,28(a1)
    li s0, 0x001815fa
    li t2, 0x001815db
    maxu s7,s0,t2
    sw s7,32(a1)
    li s7, 0x0263faf0
    li t0, 0x006af6f4
    maxu s9,s7,t0
    sw s9,36(a1)
    li s0, 0x1051ac9a
    li s7, 0x1051a9d8
    maxu a2,s0,s7
    sw a2,40(a1)
    li t6, 0x16070000
    li s11, 0x15020090
    maxu s0,t6,s11
    sw s0,44(a1)
    li t0, 0x17d47fc4
    li t5, 0x17d47fc6
    maxu s4,t0,t5
    sw s4,48(a1)
    li a6, 0x382e991b
    li a0, 0x382e999b
    maxu t3,a6,a0
    sw t3,52(a1)
    li a3, 0x3f025f9f
    li s8, 0x3f025f9e
    maxu t4,a3,s8
    sw t4,56(a1)
    li t1, 0x40000000
    li s4, 0x40000200
    maxu s7,t1,s4
    sw s7,60(a1)
    li s2, 0x41040098
    li t3, 0x41000098
    maxu s5,s2,t3
    sw s5,64(a1)
    li t1, 0x5332ff01
    li s6, 0x5332ff0c
    maxu t6,t1,s6
    sw t6,68(a1)
    li a2, 0x5583d725
    li t0, 0x5513f76d
    maxu s3,a2,t0
    sw s3,72(a1)
    li a6, 0x8ba9ff2d
    li a0, 0x8bf5ff1d
    maxu s8,a6,a0
    sw s8,76(a1)
    li s4, 0x9e7f57ab
    li a7, 0x5ebf0000
    maxu a4,s4,a7
    sw a4,80(a1)
    li s9, 0xa4dbf37b
    li s5, 0xa4dbf39b
    maxu s6,s9,s5
    sw s6,84(a1)
    li a3, 0xb58ff25f
    li a6, 0xb59df27d
    maxu a0,a3,a6
    sw a0,88(a1)
    li s5, 0xb5a168d9
    li s10, 0xb5a17d31
    maxu s6,s5,s10
    sw s6,92(a1)
    li t1, 0xbdf3d8b0
    li s10, 0xbfe2dcb0
    maxu a3,t1,s10
    sw a3,96(a1)
    li a5, 0xbfecbc33
    li t1, 0xbfe6bd33
    maxu a4,a5,t1
    sw a4,100(a1)
    li t2, 0xbff3d8b0
    li s1, 0xbfe2dcb0
    maxu a6,t2,s1
    sw a6,104(a1)
    li t2, 0xc104001f
    li s5, 0xc104001d
    maxu a4,t2,s5
    sw a4,108(a1)
    li a7, 0xde7ca325
    li a4, 0xde7ca724
    maxu t5,a7,a4
    sw t5,112(a1)
    li a6, 0xdef06600
    li s10, 0xdef06400
    maxu s1,a6,s10
    sw s1,116(a1)
    li a3, 0xe9767dca
    li t1, 0xfc05cdf8
    maxu a5,a3,t1
    sw a5,120(a1)
    li a4, 0xeffc84b1
    li t5, 0xeffd84b1
    maxu s6,a4,t5
    sw s6,124(a1)
    li s8, 0xffe2f8b0
    li s0, 0xffe2dcb0
    maxu s10,s8,s0
    sw s10,128(a1)
    RV_COMPLIANCE_HALT
RV_COMPLIANCE_CODE_END

.data
RV_COMPLIANCE_DATA_BEGIN
test_results:
.fill 33,4,-1
RV_COMPLIANCE_DATA_END
