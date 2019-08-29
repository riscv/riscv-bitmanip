#include "compliance_test.h"
#include "compliance_io.h"
#include "test_macros.h"

RV_COMPLIANCE_RV32M

RV_COMPLIANCE_CODE_BEGIN
    la a1,test_results
    li t4, 0x778bd1db
    li s9, 0xdef3c035
    minu s3,t4,s9
    sw s3,0(a1)
    li a7, 0xffaace79
    li s8, 0x11e15d6b
    minu t3,a7,s8
    sw t3,4(a1)
    li s6, 0x04bc5eac
    li s7, 0x33397f4e
    minu t3,s6,s7
    sw t3,8(a1)
    li a7, 0x40ee4840
    li a5, 0x18331b85
    minu t2,a7,a5
    sw t2,12(a1)
    li t6, 0x5a0d8ae2
    li s5, 0xfaafb8a6
    minu s11,t6,s5
    sw s11,16(a1)
    li s6, 0xcccb9502
    li t5, 0xde163e74
    minu a4,s6,t5
    sw a4,20(a1)
    li t1, 0x00100000
    li a2, 0x00000000
    minu a7,t1,a2
    sw a7,24(a1)
    li s1, 0x001815fa
    li s8, 0x001815db
    minu s0,s1,s8
    sw s0,28(a1)
    li t0, 0x1051ac9a
    li s7, 0x1051a9d8
    minu s10,t0,s7
    sw s10,32(a1)
    li t3, 0x16070000
    li s0, 0x15020090
    minu s1,t3,s0
    sw s1,36(a1)
    li a7, 0x17d47fc4
    li s5, 0x17d47fc6
    minu t0,a7,s5
    sw t0,40(a1)
    li a2, 0x382e991b
    li s11, 0x382e999b
    minu s8,a2,s11
    sw s8,44(a1)
    li a6, 0x3f025f9f
    li s1, 0x3f025f9e
    minu t5,a6,s1
    sw t5,48(a1)
    li a0, 0x41040098
    li s10, 0x41000098
    minu t5,a0,s10
    sw t5,52(a1)
    li a5, 0x5332ff01
    li a4, 0x5332ff0c
    minu s2,a5,a4
    sw s2,56(a1)
    li t2, 0x5583d725
    li s2, 0x5513f76d
    minu a6,t2,s2
    sw a6,60(a1)
    li s7, 0x8ba9ff2d
    li a0, 0x8bf5ff1d
    minu s8,s7,a0
    sw s8,64(a1)
    li s3, 0x9e7f57ab
    li a0, 0x5ebf0000
    minu s6,s3,a0
    sw s6,68(a1)
    li s9, 0xa4dbf37b
    li s7, 0xa4dbf39b
    minu a6,s9,s7
    sw a6,72(a1)
    li s2, 0xb5a168d9
    li s8, 0xb5a17d31
    minu t1,s2,s8
    sw t1,76(a1)
    li a7, 0xbdf3d8b0
    li s2, 0xbfe2dcb0
    minu s3,a7,s2
    sw s3,80(a1)
    li s11, 0xbff3d8b0
    li a3, 0xbfe2dcb0
    minu a4,s11,a3
    sw a4,84(a1)
    li a3, 0xc104001f
    li t3, 0xc104001d
    minu a7,a3,t3
    sw a7,88(a1)
    li t1, 0xde7ca325
    li t4, 0xde7ca724
    minu a7,t1,t4
    sw a7,92(a1)
    li a0, 0xdef06600
    li a7, 0xdef06400
    minu t1,a0,a7
    sw t1,96(a1)
    li s5, 0xe9767dca
    li t2, 0xfc05cdf8
    minu a3,s5,t2
    sw a3,100(a1)
    li s5, 0xffe2f8b0
    li a3, 0xffe2dcb0
    minu t5,s5,a3
    sw t5,104(a1)
    RV_COMPLIANCE_HALT
RV_COMPLIANCE_CODE_END

.data
RV_COMPLIANCE_DATA_BEGIN
test_results:
.fill 27,4,-1
RV_COMPLIANCE_DATA_END
