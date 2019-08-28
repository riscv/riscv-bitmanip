#include "compliance_test.h"
#include "compliance_io.h"
#include "test_macros.h"

RV_COMPLIANCE_RV32M

RV_COMPLIANCE_CODE_BEGIN
    la a1,test_results
    li t4, 0x778bd1db
    li s10, 0xdef3c035
    min s6,t4,s10
    sw s6,0(a1)
    li a3, 0xffaace79
    li a5, 0x11e15d6b
    min a2,a3,a5
    sw a2,4(a1)
    li s6, 0x04bc5eac
    li a5, 0x33397f4e
    min a6,s6,a5
    sw a6,8(a1)
    li a6, 0x40ee4840
    li t2, 0x18331b85
    min t0,a6,t2
    sw t0,12(a1)
    li a2, 0x5a0d8ae2
    li a6, 0xfaafb8a6
    min t0,a2,a6
    sw t0,16(a1)
    li t5, 0xcccb9502
    li s3, 0xde163e74
    min a6,t5,s3
    sw a6,20(a1)
    li s1, 0x00100000
    li t1, 0x00000000
    min s6,s1,t1
    sw s6,24(a1)
    li t1, 0x001815fa
    li s4, 0x001815db
    min a2,t1,s4
    sw a2,28(a1)
    li s6, 0x1051ac9a
    li a4, 0x1051a9d8
    min s8,s6,a4
    sw s8,32(a1)
    li t1, 0x16070000
    li s2, 0x15020090
    min a4,t1,s2
    sw a4,36(a1)
    li t5, 0x17d47fc4
    li a6, 0x17d47fc6
    min t4,t5,a6
    sw t4,40(a1)
    li t1, 0x382e991b
    li a2, 0x382e999b
    min a7,t1,a2
    sw a7,44(a1)
    li s1, 0x3f025f9f
    li s8, 0x3f025f9e
    min s0,s1,s8
    sw s0,48(a1)
    li t0, 0x41040098
    li s7, 0x41000098
    min s10,t0,s7
    sw s10,52(a1)
    li t3, 0x5332ff01
    li s0, 0x5332ff0c
    min s1,t3,s0
    sw s1,56(a1)
    li a7, 0x5583d725
    li s5, 0x5513f76d
    min t0,a7,s5
    sw t0,60(a1)
    li a2, 0x8ba9ff2d
    li s11, 0x8bf5ff1d
    min s8,a2,s11
    sw s8,64(a1)
    li a6, 0x9e7f57ab
    li s1, 0x5ebf0000
    min t5,a6,s1
    sw t5,68(a1)
    li a0, 0xa4dbf37b
    li s10, 0xa4dbf39b
    min t5,a0,s10
    sw t5,72(a1)
    li a5, 0xb5a168d9
    li a4, 0xb5a17d31
    min s2,a5,a4
    sw s2,76(a1)
    li t2, 0xbdf3d8b0
    li s2, 0xbfe2dcb0
    min a6,t2,s2
    sw a6,80(a1)
    li s7, 0xbff3d8b0
    li a0, 0xbfe2dcb0
    min s8,s7,a0
    sw s8,84(a1)
    li s3, 0xc104001f
    li a0, 0xc104001d
    min s6,s3,a0
    sw s6,88(a1)
    li s9, 0xde7ca325
    li s7, 0xde7ca724
    min a6,s9,s7
    sw a6,92(a1)
    li s2, 0xdef06600
    li s8, 0xdef06400
    min t1,s2,s8
    sw t1,96(a1)
    li a7, 0xe9767dca
    li s2, 0xfc05cdf8
    min s3,a7,s2
    sw s3,100(a1)
    li s11, 0xffe2f8b0
    li a3, 0xffe2dcb0
    min a4,s11,a3
    sw a4,104(a1)
    RV_COMPLIANCE_HALT
RV_COMPLIANCE_CODE_END

.data
RV_COMPLIANCE_DATA_BEGIN
test_results:
.fill 27,4,-1
RV_COMPLIANCE_DATA_END
