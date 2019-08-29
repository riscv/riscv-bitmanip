#include "compliance_test.h"
#include "compliance_io.h"
#include "test_macros.h"

RV_COMPLIANCE_RV32M

RV_COMPLIANCE_CODE_BEGIN
    la a1,test_results
    li s4, 0x778bd1db
    li s2, 0xdef3c035
    sbset t4,s4,s2
    sw t4,0(a1)
    li a4, 0xffaace79
    li a5, 0x11e15d6b
    sbset t2,a4,a5
    sw t2,4(a1)
    li s7, 0x04bc5eac
    li t3, 0x33397f4e
    sbset s6,s7,t3
    sw s6,8(a1)
    li a6, 0x40ee4840
    li t1, 0x18331b85
    sbset a5,a6,t1
    sw a5,12(a1)
    li t5, 0x5a0d8ae2
    li s3, 0xfaafb8a6
    sbset a6,t5,s3
    sw a6,16(a1)
    li t6, 0xcccb9502
    li s4, 0xde163e74
    sbset a2,t6,s4
    sw a2,20(a1)
    li s4, 0x00840094
    li s3, 0x080006c0
    sbset s10,s4,s3
    sw s10,24(a1)
    li s10, 0x6e136617
    li s9, 0x68356560
    sbset t5,s10,s9
    sw t5,28(a1)
    li t6, 0x00040011
    li a3, 0xb4946212
    sbset s8,t6,a3
    sw s8,32(a1)
    li s2, 0x10000085
    li s10, 0x83262662
    sbset a0,s2,s10
    sw a0,36(a1)
    li s5, 0x1340282b
    li s11, 0x0000061b
    sbset s9,s5,s11
    sw s9,40(a1)
    li s4, 0x980807fd
    li s7, 0x980a07d2
    sbset a5,s4,s7
    sw a5,44(a1)
    li s7, 0xdff47340
    li s0, 0x00c505c1
    sbset s2,s7,s0
    sw s2,48(a1)
    li s8, 0xe46d3d40
    li a0, 0x000806db
    sbset t3,s8,a0
    sw t3,52(a1)
    li t2, 0x00022c4a
    li s8, 0x5280c5d0
    sbset s3,t2,s8
    sw s3,56(a1)
    li t0, 0x5f77971c
    li a4, 0x7601006a
    sbset a0,t0,a4
    sw a0,60(a1)
    li s0, 0x7ffd8efc
    li t5, 0x7bb326df
    sbset t0,s0,t5
    sw t0,64(a1)
    li s1, 0xf044ff7a
    li s7, 0xb6c01b9a
    sbset t1,s1,s7
    sw t1,68(a1)
    li t3, 0xfffff31c
    li s2, 0xfffffbc6
    sbset a0,t3,s2
    sw a0,72(a1)
    li s2, 0xfffffdfc
    li s6, 0x6d39aa61
    sbset s7,s2,s6
    sw s7,76(a1)
    RV_COMPLIANCE_HALT
RV_COMPLIANCE_CODE_END

.data
RV_COMPLIANCE_DATA_BEGIN
test_results:
.fill 20,4,-1
RV_COMPLIANCE_DATA_END
