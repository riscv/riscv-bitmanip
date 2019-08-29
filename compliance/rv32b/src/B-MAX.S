#include "compliance_test.h"
#include "compliance_io.h"
#include "test_macros.h"

RV_COMPLIANCE_RV32M

RV_COMPLIANCE_CODE_BEGIN
    la a1,test_results
    li t5, 0x778bd1db
    li a3, 0xdef3c035
    max t1,t5,a3
    sw t1,0(a1)
    li s5, 0xffaace79
    li s8, 0x11e15d6b
    max t3,s5,s8
    sw t3,4(a1)
    li s5, 0x04bc5eac
    li s0, 0x33397f4e
    max s1,s5,s0
    sw s1,8(a1)
    li s0, 0x40ee4840
    li t4, 0x18331b85
    max s7,s0,t4
    sw s7,12(a1)
    li a6, 0x5a0d8ae2
    li t6, 0xfaafb8a6
    max t3,a6,t6
    sw t3,16(a1)
    li s11, 0xcccb9502
    li s0, 0xde163e74
    max a3,s11,s0
    sw a3,20(a1)
    li s4, 0x00100000
    li a6, 0x00000000
    max t6,s4,a6
    sw t6,24(a1)
    li s8, 0x001815fa
    li t0, 0x001815db
    max s7,s8,t0
    sw s7,28(a1)
    li t0, 0x1051ac9a
    li t5, 0x1051a9d8
    max a7,t0,t5
    sw a7,32(a1)
    li t5, 0x16070000
    li s2, 0x15020090
    max a5,t5,s2
    sw a5,36(a1)
    li a0, 0x17d47fc4
    li s3, 0x17d47fc6
    max t3,a0,s3
    sw t3,40(a1)
    li s11, 0x382e991b
    li s7, 0x382e999b
    max s9,s11,s7
    sw s9,44(a1)
    li s1, 0x3f025f9f
    li t3, 0x3f025f9e
    max t4,s1,t3
    sw t4,48(a1)
    li s5, 0x41040098
    li t6, 0x41000098
    max a7,s5,t6
    sw a7,52(a1)
    li t1, 0x5332ff01
    li t3, 0x5332ff0c
    max s0,t1,t3
    sw s0,56(a1)
    li t6, 0x5583d725
    li t5, 0x5513f76d
    max s8,t6,t5
    sw s8,60(a1)
    li a7, 0x8ba9ff2d
    li t1, 0x8bf5ff1d
    max s4,a7,t1
    sw s4,64(a1)
    li s8, 0x9e7f57ab
    li s7, 0x5ebf0000
    max t1,s8,s7
    sw t1,68(a1)
    li s0, 0xa4dbf37b
    li s2, 0xa4dbf39b
    max s1,s0,s2
    sw s1,72(a1)
    li s1, 0xb5a168d9
    li t4, 0xb5a17d31
    max a3,s1,t4
    sw a3,76(a1)
    li s1, 0xbdf3d8b0
    li s4, 0xbfe2dcb0
    max s5,s1,s4
    sw s5,80(a1)
    li a7, 0xbff3d8b0
    li s0, 0xbfe2dcb0
    max s2,a7,s0
    sw s2,84(a1)
    li t4, 0xc104001f
    li t1, 0xc104001d
    max s5,t4,t1
    sw s5,88(a1)
    li a3, 0xde7ca325
    li s3, 0xde7ca724
    max s4,a3,s3
    sw s4,92(a1)
    li a6, 0xdef06600
    li s3, 0xdef06400
    max a4,a6,s3
    sw a4,96(a1)
    li a7, 0xe9767dca
    li t6, 0xfc05cdf8
    max a0,a7,t6
    sw a0,100(a1)
    li s9, 0xffe2f8b0
    li t4, 0xffe2dcb0
    max a0,s9,t4
    sw a0,104(a1)
    RV_COMPLIANCE_HALT
RV_COMPLIANCE_CODE_END

.data
RV_COMPLIANCE_DATA_BEGIN
test_results:
.fill 27,4,-1
RV_COMPLIANCE_DATA_END
