#include "compliance_test.h"
#include "compliance_io.h"
#include "test_macros.h"

RV_COMPLIANCE_RV32M

RV_COMPLIANCE_CODE_BEGIN
    la a1,test_results
    li t4, 0x778bd1db
    li s9, 0xdef3c035
    max s3,t4,s9
    sw s3,0(a1)
    li s6, 0xffaace79
    li a0, 0x11e15d6b
    max s5,s6,a0
    sw s5,4(a1)
    li s4, 0x04bc5eac
    li a2, 0x33397f4e
    max t6,s4,a2
    sw t6,8(a1)
    li s10, 0x40ee4840
    li t6, 0x18331b85
    max s3,s10,t6
    sw s3,12(a1)
    li a4, 0x5a0d8ae2
    li s8, 0xfaafb8a6
    max t4,a4,s8
    sw t4,16(a1)
    li a7, 0xcccb9502
    li t0, 0xde163e74
    max a6,a7,t0
    sw a6,20(a1)
    li s7, 0x00100000
    li a0, 0x00000000
    max a4,s7,a0
    sw a4,24(a1)
    li s4, 0x001815fa
    li a5, 0x001815db
    max s6,s4,a5
    sw s6,28(a1)
    li a5, 0x1051ac9a
    li s6, 0x1051a9d8
    max s2,a5,s6
    sw s2,32(a1)
    li t1, 0x16070000
    li s6, 0x15020090
    max a2,t1,s6
    sw a2,36(a1)
    li s5, 0x17d47fc4
    li s4, 0x17d47fc6
    max t6,s5,s4
    sw t6,40(a1)
    li s11, 0x382e991b
    li s9, 0x382e999b
    max s10,s11,s9
    sw s10,44(a1)
    li s9, 0x3f025f9f
    li s1, 0x3f025f9e
    max t0,s9,s1
    sw t0,48(a1)
    li s3, 0x41040098
    li a0, 0x41000098
    max t2,s3,a0
    sw t2,52(a1)
    li a0, 0x5332ff01
    li t2, 0x5332ff0c
    max t6,a0,t2
    sw t6,56(a1)
    li t3, 0x5583d725
    li a3, 0x5513f76d
    max s8,t3,a3
    sw s8,60(a1)
    li a0, 0x8ba9ff2d
    li t6, 0x8bf5ff1d
    max s9,a0,t6
    sw s9,64(a1)
    li s6, 0x9e7f57ab
    li a6, 0x5ebf0000
    max s7,s6,a6
    sw s7,68(a1)
    li s7, 0xa4dbf37b
    li s4, 0xa4dbf39b
    max t1,s7,s4
    sw t1,72(a1)
    li s1, 0xb5a168d9
    li t5, 0xb5a17d31
    max s2,s1,t5
    sw s2,76(a1)
    li a0, 0xbdf3d8b0
    li s5, 0xbfe2dcb0
    max s2,a0,s5
    sw s2,80(a1)
    li t6, 0xbff3d8b0
    li s1, 0xbfe2dcb0
    max t5,t6,s1
    sw t5,84(a1)
    li s2, 0xc104001f
    li s0, 0xc104001d
    max t0,s2,s0
    sw t0,88(a1)
    li s9, 0xde7ca325
    li s4, 0xde7ca724
    max a3,s9,s4
    sw a3,92(a1)
    li t6, 0xdef06600
    li t4, 0xdef06400
    max a6,t6,t4
    sw a6,96(a1)
    li s3, 0xe9767dca
    li a6, 0xfc05cdf8
    max a5,s3,a6
    sw a5,100(a1)
    li a5, 0xffe2f8b0
    li a0, 0xffe2dcb0
    max t5,a5,a0
    sw t5,104(a1)
    RV_COMPLIANCE_HALT
RV_COMPLIANCE_CODE_END

.data
RV_COMPLIANCE_DATA_BEGIN
test_results:
.fill 27,4,-1
RV_COMPLIANCE_DATA_END
