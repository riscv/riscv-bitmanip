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
    li a5, 0x00022c4a
    li a0, 0x5280c5d0
    sbset s1,a5,a0
    sw s1,24(a1)
    li a6, 0x00040011
    li a3, 0xb4946212
    sbset a4,a6,a3
    sw a4,28(a1)
    li a6, 0x00840094
    li a3, 0x080006c0
    sbset s7,a6,a3
    sw s7,32(a1)
    li a0, 0x008a00b0
    li s6, 0x9c1d04b9
    sbset t4,a0,s6
    sw t4,36(a1)
    li a4, 0x10000085
    li s6, 0x83262662
    sbset t6,a4,s6
    sw t6,40(a1)
    li s9, 0x1340282b
    li s1, 0x0000061b
    sbset t6,s9,s1
    sw t6,44(a1)
    li s11, 0x2afd97a8
    li s2, 0x3002c6d8
    sbset t3,s11,s2
    sw t3,48(a1)
    li s5, 0x49484c00
    li a6, 0x4975d377
    sbset s11,s5,a6
    sw s11,52(a1)
    li s1, 0x5f77971c
    li s7, 0x7601006a
    sbset a6,s1,s7
    sw a6,56(a1)
    li s5, 0x6e136617
    li s10, 0x68356560
    sbset s1,s5,s10
    sw s1,60(a1)
    li a3, 0x74108058
    li t2, 0x0adcd03a
    sbset a0,a3,t2
    sw a0,64(a1)
    li s3, 0x7ffd8efc
    li t3, 0x7bb326df
    sbset a6,s3,t3
    sw a6,68(a1)
    li a5, 0x822004fa
    li t2, 0x16d7df1c
    sbset t0,a5,t2
    sw t0,72(a1)
    li s7, 0x85280b88
    li s3, 0x90c24215
    sbset s6,s7,s3
    sw s6,76(a1)
    li s7, 0x980807fd
    li t5, 0x980a07d2
    sbset t1,s7,t5
    sw t1,80(a1)
    li s10, 0x9d233768
    li a2, 0x0c00020d
    sbset t6,s10,a2
    sw t6,84(a1)
    li a3, 0xb4110962
    li s9, 0x64552f5c
    sbset s7,a3,s9
    sw s7,88(a1)
    li t6, 0xbf8b47cf
    li a0, 0xe98014eb
    sbset s11,t6,a0
    sw s11,92(a1)
    li s6, 0xdff47340
    li s2, 0x00c505c1
    sbset s11,s6,s2
    sw s11,96(a1)
    li s4, 0xe46d3d40
    li a0, 0x000806db
    sbset t6,s4,a0
    sw t6,100(a1)
    li s6, 0xf044ff7a
    li s4, 0xb6c01b9a
    sbset s8,s6,s4
    sw s8,104(a1)
    li s5, 0xfe4e45fd
    li t6, 0xcb4ef3f7
    sbset s6,s5,t6
    sw s6,108(a1)
    li s7, 0xfffff31c
    li t1, 0xfffffbc6
    sbset a6,s7,t1
    sw a6,112(a1)
    li t2, 0xfffffdfc
    li s9, 0x6d39aa61
    sbset s6,t2,s9
    sw s6,116(a1)
    RV_COMPLIANCE_HALT
RV_COMPLIANCE_CODE_END

.data
RV_COMPLIANCE_DATA_BEGIN
test_results:
.fill 30,4,-1
RV_COMPLIANCE_DATA_END
