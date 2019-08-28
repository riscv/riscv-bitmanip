#include "compliance_test.h"
#include "compliance_io.h"
#include "test_macros.h"

RV_COMPLIANCE_RV32M

RV_COMPLIANCE_CODE_BEGIN
    la a1,test_results
    li t5, 0x778bd1db
    li a3, 0xdef3c035
    maxu t1,t5,a3
    sw t1,0(a1)
    li t1, 0xffaace79
    li t0, 0x11e15d6b
    maxu a0,t1,t0
    sw a0,4(a1)
    li t5, 0x04bc5eac
    li t6, 0x33397f4e
    maxu s1,t5,t6
    sw s1,8(a1)
    li t2, 0x40ee4840
    li s1, 0x18331b85
    maxu t1,t2,s1
    sw t1,12(a1)
    li a5, 0x5a0d8ae2
    li s6, 0xfaafb8a6
    maxu a3,a5,s6
    sw a3,16(a1)
    li a2, 0xcccb9502
    li s9, 0xde163e74
    maxu s8,a2,s9
    sw s8,20(a1)
    li t2, 0x00100000
    li a0, 0x00000000
    maxu t6,t2,a0
    sw t6,24(a1)
    li s1, 0x001815fa
    li s2, 0x001815db
    maxu a2,s1,s2
    sw a2,28(a1)
    li s6, 0x1051ac9a
    li a4, 0x1051a9d8
    maxu s11,s6,a4
    sw s11,32(a1)
    li s6, 0x16070000
    li t5, 0x15020090
    maxu a4,s6,t5
    sw a4,36(a1)
    li s4, 0x17d47fc4
    li a6, 0x17d47fc6
    maxu t6,s4,a6
    sw t6,40(a1)
    li s8, 0x382e991b
    li t0, 0x382e999b
    maxu s7,s8,t0
    sw s7,44(a1)
    li t0, 0x3f025f9f
    li t5, 0x3f025f9e
    maxu a7,t0,t5
    sw a7,48(a1)
    li t5, 0x41040098
    li s2, 0x41000098
    maxu a5,t5,s2
    sw a5,52(a1)
    li a0, 0x5332ff01
    li s3, 0x5332ff0c
    maxu t3,a0,s3
    sw t3,56(a1)
    li s11, 0x5583d725
    li s7, 0x5513f76d
    maxu s9,s11,s7
    sw s9,60(a1)
    li s1, 0x8ba9ff2d
    li t3, 0x8bf5ff1d
    maxu t4,s1,t3
    sw t4,64(a1)
    li s5, 0x9e7f57ab
    li t6, 0x5ebf0000
    maxu a7,s5,t6
    sw a7,68(a1)
    li t1, 0xa4dbf37b
    li t3, 0xa4dbf39b
    maxu s0,t1,t3
    sw s0,72(a1)
    li t6, 0xb5a168d9
    li t5, 0xb5a17d31
    maxu s8,t6,t5
    sw s8,76(a1)
    li a7, 0xbdf3d8b0
    li t1, 0xbfe2dcb0
    maxu s4,a7,t1
    sw s4,80(a1)
    li s8, 0xbff3d8b0
    li s7, 0xbfe2dcb0
    maxu t1,s8,s7
    sw t1,84(a1)
    li s0, 0xc104001f
    li s2, 0xc104001d
    maxu s1,s0,s2
    sw s1,88(a1)
    li s1, 0xde7ca325
    li t4, 0xde7ca724
    maxu a3,s1,t4
    sw a3,92(a1)
    li s1, 0xdef06600
    li s4, 0xdef06400
    maxu s5,s1,s4
    sw s5,96(a1)
    li a7, 0xe9767dca
    li s0, 0xfc05cdf8
    maxu s2,a7,s0
    sw s2,100(a1)
    li t4, 0xffe2f8b0
    li t1, 0xffe2dcb0
    maxu s5,t4,t1
    sw s5,104(a1)
    RV_COMPLIANCE_HALT
RV_COMPLIANCE_CODE_END

.data
RV_COMPLIANCE_DATA_BEGIN
test_results:
.fill 27,4,-1
RV_COMPLIANCE_DATA_END
