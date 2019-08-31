#include "compliance_test.h"
#include "compliance_io.h"
#include "test_macros.h"

RV_COMPLIANCE_RV32M

RV_COMPLIANCE_CODE_BEGIN
    la a1,test_results
    li a3, 0x778bd1db
    li t6, 0xdef3c035
    min a6,a3,t6
    sw a6,0(a1)
    li t1, 0xffaace79
    li t0, 0x11e15d6b
    min a0,t1,t0
    sw a0,4(a1)
    li s6, 0x04bc5eac
    li t0, 0x33397f4e
    min t6,s6,t0
    sw t6,8(a1)
    li a5, 0x40ee4840
    li a7, 0x18331b85
    min t5,a5,a7
    sw t5,12(a1)
    li t5, 0x5a0d8ae2
    li s10, 0xfaafb8a6
    min a0,t5,s10
    sw a0,16(a1)
    li a0, 0xcccb9502
    li t2, 0xde163e74
    min s5,a0,t2
    sw s5,20(a1)
    li t3, 0x00000040
    li a7, 0x00020000
    min s11,t3,a7
    sw s11,24(a1)
    li t0, 0x00100000
    li t2, 0x00000000
    min a7,t0,t2
    sw a7,28(a1)
    li t3, 0x001815fa
    li a7, 0x001815db
    min s0,t3,a7
    sw s0,32(a1)
    li s4, 0x0263faf0
    li s9, 0x006af6f4
    min s7,s4,s9
    sw s7,36(a1)
    li t5, 0x1051ac9a
    li s1, 0x1051a9d8
    min a2,t5,s1
    sw a2,40(a1)
    li s8, 0x16070000
    li s4, 0x15020090
    min s7,s8,s4
    sw s7,44(a1)
    li s9, 0x17d47fc4
    li t2, 0x17d47fc6
    min s3,s9,t2
    sw s3,48(a1)
    li a6, 0x382e991b
    li a4, 0x382e999b
    min s6,a6,a4
    sw s6,52(a1)
    li t6, 0x3f025f9f
    li s11, 0x3f025f9e
    min t3,t6,s11
    sw t3,56(a1)
    li a0, 0x40000000
    li t4, 0x40000200
    min s4,a0,t4
    sw s4,60(a1)
    li s9, 0x41040098
    li a0, 0x41000098
    min a5,s9,a0
    sw a5,64(a1)
    li a7, 0x5332ff01
    li s5, 0x5332ff0c
    min a3,a7,s5
    sw a3,68(a1)
    li s9, 0x5583d725
    li t6, 0x5513f76d
    min s6,s9,t6
    sw s6,72(a1)
    li s3, 0x8ba9ff2d
    li s6, 0x8bf5ff1d
    min s1,s3,s6
    sw s1,76(a1)
    li s0, 0x9e7f57ab
    li a4, 0x5ebf0000
    min t2,s0,a4
    sw t2,80(a1)
    li s1, 0xa4dbf37b
    li t6, 0xa4dbf39b
    min t4,s1,t6
    sw t4,84(a1)
    li s8, 0xb58ff25f
    li s1, 0xb59df27d
    min t0,s8,s1
    sw t0,88(a1)
    li a0, 0xb5a168d9
    li a4, 0xb5a17d31
    min t4,a0,a4
    sw t4,92(a1)
    li t3, 0xbdf3d8b0
    li s4, 0xbfe2dcb0
    min a6,t3,s4
    sw a6,96(a1)
    li a3, 0xbfecbc33
    li a6, 0xbfe6bd33
    min s6,a3,a6
    sw s6,100(a1)
    li a2, 0xbff3d8b0
    li s8, 0xbfe2dcb0
    min s6,a2,s8
    sw s6,104(a1)
    li s6, 0xc104001f
    li a3, 0xc104001d
    min s7,s6,a3
    sw s7,108(a1)
    li t0, 0xde7ca325
    li s1, 0xde7ca724
    min a5,t0,s1
    sw a5,112(a1)
    li s4, 0xdef06600
    li a5, 0xdef06400
    min s3,s4,a5
    sw s3,116(a1)
    li a7, 0xe9767dca
    li t2, 0xfc05cdf8
    min s3,a7,t2
    sw s3,120(a1)
    li a5, 0xeffc84b1
    li t4, 0xeffd84b1
    min s10,a5,t4
    sw s10,124(a1)
    li s1, 0xffe2f8b0
    li s3, 0xffe2dcb0
    min s11,s1,s3
    sw s11,128(a1)
    RV_COMPLIANCE_HALT
RV_COMPLIANCE_CODE_END

.data
RV_COMPLIANCE_DATA_BEGIN
test_results:
.fill 33,4,-1
RV_COMPLIANCE_DATA_END
