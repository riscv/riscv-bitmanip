#include "compliance_test.h"
#include "compliance_io.h"
#include "test_macros.h"

RV_COMPLIANCE_RV32M

RV_COMPLIANCE_CODE_BEGIN
    la a1,test_results
    li t5, 0x778bd1db
    li s9, 0xdef3c035
    sbset a7,t5,s9
    sw a7,0(a1)
    li a7, 0xffaace79
    li a3, 0x11e15d6b
    sbset a6,a7,a3
    sw a6,4(a1)
    li s3, 0x04bc5eac
    li t0, 0x33397f4e
    sbset s9,s3,t0
    sw s9,8(a1)
    li s11, 0x40ee4840
    li t0, 0x18331b85
    sbset a7,s11,t0
    sw a7,12(a1)
    li s1, 0x5a0d8ae2
    li s9, 0xfaafb8a6
    sbset s5,s1,s9
    sw s5,16(a1)
    li s2, 0xcccb9502
    li a2, 0xde163e74
    sbset s7,s2,a2
    sw s7,20(a1)
    li s11, 0x00022c4a
    li s2, 0x5280c5d0
    sbset t3,s11,s2
    sw t3,24(a1)
    li s5, 0x00040011
    li a6, 0xb4946212
    sbset s11,s5,a6
    sw s11,28(a1)
    li s1, 0x00840094
    li s7, 0x080006c0
    sbset a6,s1,s7
    sw a6,32(a1)
    li s5, 0x008a00b0
    li s10, 0x9c1d04b9
    sbset s1,s5,s10
    sw s1,36(a1)
    li a3, 0x10000085
    li t2, 0x83262662
    sbset a0,a3,t2
    sw a0,40(a1)
    li s3, 0x1340282b
    li t3, 0x0000061b
    sbset a6,s3,t3
    sw a6,44(a1)
    li a5, 0x2afd97a8
    li t2, 0x3002c6d8
    sbset t0,a5,t2
    sw t0,48(a1)
    li s7, 0x49484c00
    li s3, 0x4975d377
    sbset s6,s7,s3
    sw s6,52(a1)
    li s7, 0x5f77971c
    li t5, 0x7601006a
    sbset t1,s7,t5
    sw t1,56(a1)
    li s10, 0x6e136617
    li a2, 0x68356560
    sbset t6,s10,a2
    sw t6,60(a1)
    li a3, 0x74108058
    li s9, 0x0adcd03a
    sbset s7,a3,s9
    sw s7,64(a1)
    li t6, 0x7ffd8efc
    li a0, 0x7bb326df
    sbset s11,t6,a0
    sw s11,68(a1)
    li s6, 0x822004fa
    li s2, 0x16d7df1c
    sbset s11,s6,s2
    sw s11,72(a1)
    li s4, 0x85280b88
    li a0, 0x90c24215
    sbset t6,s4,a0
    sw t6,76(a1)
    li s6, 0x980807fd
    li s4, 0x980a07d2
    sbset s8,s6,s4
    sw s8,80(a1)
    li s5, 0x9d233768
    li t6, 0x0c00020d
    sbset s6,s5,t6
    sw s6,84(a1)
    li s7, 0xb4110962
    li t1, 0x64552f5c
    sbset a6,s7,t1
    sw a6,88(a1)
    li t2, 0xbf8b47cf
    li s9, 0xe98014eb
    sbset s6,t2,s9
    sw s6,92(a1)
    li s2, 0xdff47340
    li a5, 0x00c505c1
    sbset t3,s2,a5
    sw t3,96(a1)
    li t1, 0xe46d3d40
    li s2, 0x000806db
    sbset s7,t1,s2
    sw s7,100(a1)
    li s2, 0xf044ff7a
    li t6, 0xb6c01b9a
    sbset s0,s2,t6
    sw s0,104(a1)
    li t2, 0xfe4e45fd
    li t3, 0xcb4ef3f7
    sbset t1,t2,t3
    sw t1,108(a1)
    li s7, 0xfffff31c
    li a2, 0xfffffbc6
    sbset a7,s7,a2
    sw a7,112(a1)
    li s3, 0xfffffdfc
    li t0, 0x6d39aa61
    sbset a5,s3,t0
    sw a5,116(a1)
    RV_COMPLIANCE_HALT
RV_COMPLIANCE_CODE_END

.data
RV_COMPLIANCE_DATA_BEGIN
test_results:
.fill 30,4,-1
RV_COMPLIANCE_DATA_END
