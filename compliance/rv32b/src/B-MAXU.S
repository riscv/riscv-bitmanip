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
    li s11, 0x00100000
    li s9, 0x00000000
    maxu s10,s11,s9
    sw s10,24(a1)
    li s9, 0x001815fa
    li s1, 0x001815db
    maxu t0,s9,s1
    sw t0,28(a1)
    li s3, 0x1051ac9a
    li a0, 0x1051a9d8
    maxu t2,s3,a0
    sw t2,32(a1)
    li a0, 0x16070000
    li t2, 0x15020090
    maxu t6,a0,t2
    sw t6,36(a1)
    li t3, 0x17d47fc4
    li a3, 0x17d47fc6
    maxu s8,t3,a3
    sw s8,40(a1)
    li a0, 0x382e991b
    li t6, 0x382e999b
    maxu s9,a0,t6
    sw s9,44(a1)
    li s6, 0x3f025f9f
    li a6, 0x3f025f9e
    maxu s7,s6,a6
    sw s7,48(a1)
    li s7, 0x41040098
    li s4, 0x41000098
    maxu t1,s7,s4
    sw t1,52(a1)
    li s1, 0x5332ff01
    li t5, 0x5332ff0c
    maxu s2,s1,t5
    sw s2,56(a1)
    li a0, 0x5583d725
    li s5, 0x5513f76d
    maxu s2,a0,s5
    sw s2,60(a1)
    li t6, 0x8ba9ff2d
    li s1, 0x8bf5ff1d
    maxu t5,t6,s1
    sw t5,64(a1)
    li s2, 0x9e7f57ab
    li s0, 0x5ebf0000
    maxu t0,s2,s0
    sw t0,68(a1)
    li s9, 0xa4dbf37b
    li s4, 0xa4dbf39b
    maxu a3,s9,s4
    sw a3,72(a1)
    li t6, 0xb5a168d9
    li t4, 0xb5a17d31
    maxu a6,t6,t4
    sw a6,76(a1)
    li s3, 0xbdf3d8b0
    li a6, 0xbfe2dcb0
    maxu a5,s3,a6
    sw a5,80(a1)
    li a5, 0xbff3d8b0
    li a0, 0xbfe2dcb0
    maxu t5,a5,a0
    sw t5,84(a1)
    li s5, 0xc104001f
    li a0, 0xc104001d
    maxu t3,s5,a0
    sw t3,88(a1)
    li t4, 0xde7ca325
    li s4, 0xde7ca724
    maxu a5,t4,s4
    sw a5,92(a1)
    li t0, 0xdef06600
    li s8, 0xdef06400
    maxu a2,t0,s8
    sw a2,96(a1)
    li s6, 0xe9767dca
    li a6, 0xfc05cdf8
    maxu s11,s6,a6
    sw s11,100(a1)
    li s9, 0xffe2f8b0
    li a3, 0xffe2dcb0
    maxu s0,s9,a3
    sw s0,104(a1)
    RV_COMPLIANCE_HALT
RV_COMPLIANCE_CODE_END

.data
RV_COMPLIANCE_DATA_BEGIN
test_results:
.fill 27,4,-1
RV_COMPLIANCE_DATA_END
