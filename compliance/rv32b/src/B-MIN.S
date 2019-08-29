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
    li a0, 0x00100000
    li t0, 0x00000000
    min t5,a0,t0
    sw t5,24(a1)
    li s9, 0x001815fa
    li t1, 0x001815db
    min s11,s9,t1
    sw s11,28(a1)
    li a2, 0x1051ac9a
    li t2, 0x1051a9d8
    min s7,a2,t2
    sw s7,32(a1)
    li t0, 0x16070000
    li s7, 0x15020090
    min t1,t0,s7
    sw t1,36(a1)
    li a3, 0x17d47fc4
    li a5, 0x17d47fc6
    min s8,a3,a5
    sw s8,40(a1)
    li a4, 0x382e991b
    li t1, 0x382e999b
    min t5,a4,t1
    sw t5,44(a1)
    li t1, 0x3f025f9f
    li s11, 0x3f025f9e
    min t6,t1,s11
    sw t6,48(a1)
    li s5, 0x41040098
    li t1, 0x41000098
    min a2,s5,t1
    sw a2,52(a1)
    li s4, 0x5332ff01
    li s0, 0x5332ff0c
    min s7,s4,s0
    sw s7,56(a1)
    li a2, 0x5583d725
    li s10, 0x5513f76d
    min s7,a2,s10
    sw s7,60(a1)
    li t1, 0x8ba9ff2d
    li s1, 0x8bf5ff1d
    min s10,t1,s1
    sw s10,64(a1)
    li t1, 0x9e7f57ab
    li s6, 0x5ebf0000
    min t3,t1,s6
    sw t3,68(a1)
    li t3, 0xa4dbf37b
    li a5, 0xa4dbf39b
    min s1,t3,a5
    sw s1,72(a1)
    li s4, 0xb5a168d9
    li s5, 0xb5a17d31
    min t0,s4,s5
    sw t0,76(a1)
    li s11, 0xbdf3d8b0
    li t1, 0xbfe2dcb0
    min s4,s11,t1
    sw s4,80(a1)
    li s5, 0xbff3d8b0
    li a3, 0xbfe2dcb0
    min a5,s5,a3
    sw a5,84(a1)
    li t3, 0xc104001f
    li a2, 0xc104001d
    min s0,t3,a2
    sw s0,88(a1)
    li s10, 0xde7ca325
    li t0, 0xde7ca724
    min a0,s10,t0
    sw a0,92(a1)
    li a2, 0xdef06600
    li s7, 0xdef06400
    min a5,a2,s7
    sw a5,96(a1)
    li t3, 0xe9767dca
    li a7, 0xfc05cdf8
    min s11,t3,a7
    sw s11,100(a1)
    li t0, 0xffe2f8b0
    li t2, 0xffe2dcb0
    min a7,t0,t2
    sw a7,104(a1)
    RV_COMPLIANCE_HALT
RV_COMPLIANCE_CODE_END

.data
RV_COMPLIANCE_DATA_BEGIN
test_results:
.fill 27,4,-1
RV_COMPLIANCE_DATA_END
