#include "compliance_test.h"
#include "compliance_io.h"
#include "test_macros.h"

RV_COMPLIANCE_RV32M

RV_COMPLIANCE_CODE_BEGIN
    la a1,test_results
    li s9, 0x778bd1db
    li t2, 0xdef3c035
    sbset s0,s9,t2
    sw s0,0(a1)
    li a7, 0xffaace79
    li s8, 0x11e15d6b
    sbset t3,a7,s8
    sw t3,4(a1)
    li t0, 0x04bc5eac
    li a6, 0x33397f4e
    sbset s11,t0,a6
    sw s11,8(a1)
    li s1, 0x40ee4840
    li t4, 0x18331b85
    sbset t3,s1,t4
    sw t3,12(a1)
    li t0, 0x5a0d8ae2
    li a2, 0xfaafb8a6
    sbset s8,t0,a2
    sw s8,16(a1)
    li t6, 0xcccb9502
    li a7, 0xde163e74
    sbset s2,t6,a7
    sw s2,20(a1)
    li s6, 0x00840094
    li a6, 0x080006c0
    sbset s11,s6,a6
    sw s11,24(a1)
    li s9, 0x6e136617
    li a3, 0x68356560
    sbset s0,s9,a3
    sw s0,28(a1)
    li s0, 0x00040011
    li t2, 0xb4946212
    sbset s7,s0,t2
    sw s7,32(a1)
    li s7, 0x10000085
    li t0, 0x83262662
    sbset s9,s7,t0
    sw s9,36(a1)
    li s0, 0x1340282b
    li s7, 0x0000061b
    sbset a2,s0,s7
    sw a2,40(a1)
    li t6, 0x980807fd
    li s11, 0x980a07d2
    sbset s0,t6,s11
    sw s0,44(a1)
    li t0, 0xdff47340
    li t5, 0x00c505c1
    sbset s4,t0,t5
    sw s4,48(a1)
    li a6, 0xe46d3d40
    li a0, 0x000806db
    sbset t3,a6,a0
    sw t3,52(a1)
    li a3, 0x00022c4a
    li s8, 0x5280c5d0
    sbset t4,a3,s8
    sw t4,56(a1)
    li t1, 0x5f77971c
    li s4, 0x7601006a
    sbset s7,t1,s4
    sw s7,60(a1)
    li s2, 0x7ffd8efc
    li t3, 0x7bb326df
    sbset s5,s2,t3
    sw s5,64(a1)
    li t1, 0xf044ff7a
    li s6, 0xb6c01b9a
    sbset t6,t1,s6
    sw t6,68(a1)
    li a2, 0xfffff31c
    li t0, 0xfffffbc6
    sbset s3,a2,t0
    sw s3,72(a1)
    li a6, 0xfffffdfc
    li a0, 0x6d39aa61
    sbset s8,a6,a0
    sw s8,76(a1)
    RV_COMPLIANCE_HALT
RV_COMPLIANCE_CODE_END

.data
RV_COMPLIANCE_DATA_BEGIN
test_results:
.fill 20,4,-1
RV_COMPLIANCE_DATA_END
