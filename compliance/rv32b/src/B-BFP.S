#include "compliance_test.h"
#include "compliance_io.h"
#include "test_macros.h"

RV_COMPLIANCE_RV32M

RV_COMPLIANCE_CODE_BEGIN
    la a1,test_results
    li a4, 0x778bd1db
    li t2, 0xdef3c035
    bfp a3,a4,t2
    sw a3,0(a1)
    li s6, 0xffaace79
    li t0, 0x11e15d6b
    bfp t6,s6,t0
    sw t6,4(a1)
    li s0, 0x04bc5eac
    li t4, 0x33397f4e
    bfp s7,s0,t4
    sw s7,8(a1)
    li t5, 0x40ee4840
    li s3, 0x18331b85
    bfp a6,t5,s3
    sw a6,12(a1)
    li s10, 0x5a0d8ae2
    li s2, 0xfaafb8a6
    bfp a4,s10,s2
    sw a4,16(a1)
    li t1, 0xcccb9502
    li a7, 0xde163e74
    bfp s10,t1,a7
    sw s10,20(a1)
    li s8, 0x00800020
    li a7, 0xcce533a0
    bfp a3,s8,a7
    sw a3,24(a1)
    li s7, 0x09280a31
    li s6, 0xbf04fb41
    bfp a7,s7,s6
    sw a7,28(a1)
    li s4, 0x09a4cf49
    li s0, 0xe07b9586
    bfp a3,s4,s0
    sw a3,32(a1)
    li s0, 0x0a0b00ea
    li s1, 0x708e0000
    bfp s10,s0,s1
    sw s10,36(a1)
    li a0, 0x0b9902f0
    li s8, 0xe0f38101
    bfp s10,a0,s8
    sw s10,40(a1)
    li s7, 0x1000000a
    li t4, 0x9421d2a1
    bfp a7,s7,t4
    sw a7,44(a1)
    li a4, 0x1098a082
    li t6, 0x0d15ff77
    bfp t2,a4,t6
    sw t2,48(a1)
    li t2, 0x21f14000
    li s5, 0x35790ba0
    bfp s3,t2,s5
    sw s3,52(a1)
    li t3, 0x2e3c4800
    li t0, 0x007d3302
    bfp s4,t3,t0
    sw s4,56(a1)
    li s5, 0x32446088
    li s8, 0x0f30013d
    bfp t1,s5,s8
    sw t1,60(a1)
    li t3, 0x3808c26c
    li t4, 0x00141913
    bfp s7,t3,t4
    sw s7,64(a1)
    li a3, 0x3e32c233
    li a4, 0x649f3a6b
    bfp a0,a3,a4
    sw a0,68(a1)
    li s10, 0x439347fc
    li a2, 0x10ff6361
    bfp a4,s10,a2
    sw a4,72(a1)
    li s0, 0x46805d70
    li t4, 0x461e171c
    bfp a2,s0,t4
    sw a2,76(a1)
    li s9, 0x55763aff
    li t1, 0xcb3a5063
    bfp s5,s9,t1
    sw s5,80(a1)
    li t6, 0x65000004
    li t5, 0x721c1db0
    bfp a0,t6,t5
    sw a0,84(a1)
    li a0, 0x65720785
    li s9, 0x874e9a8a
    bfp a4,a0,s9
    sw a4,88(a1)
    li a0, 0x65e554ce
    li s2, 0x73e100c4
    bfp s7,a0,s2
    sw s7,92(a1)
    li s7, 0x6ef00014
    li s6, 0x3ee6ccda
    bfp s0,s7,s6
    sw s0,96(a1)
    li s10, 0x70008040
    li s1, 0x0f1ffd0f
    bfp a5,s10,s1
    sw a5,100(a1)
    li t3, 0x7f88d058
    li s4, 0x3788c080
    bfp a6,t3,s4
    sw a6,104(a1)
    li t1, 0x803dc580
    li s7, 0x60f6f187
    bfp t5,t1,s7
    sw t5,108(a1)
    li s0, 0x8699861f
    li t1, 0x8341a420
    bfp a0,s0,t1
    sw a0,112(a1)
    li s5, 0x96522017
    li t1, 0x90e946ad
    bfp a0,s5,t1
    sw a0,116(a1)
    li a0, 0x9a5072ac
    li t1, 0x5b343f99
    bfp t0,a0,t1
    sw t0,120(a1)
    li a0, 0xa07646d2
    li t0, 0xc70b0bbf
    bfp t3,a0,t0
    sw t3,124(a1)
    li s4, 0xa1e6026d
    li s10, 0xf5b8607a
    bfp s2,s4,s10
    sw s2,128(a1)
    li s5, 0xa2000004
    li s6, 0xe0dd3861
    bfp a7,s5,s6
    sw a7,132(a1)
    li s0, 0xbc83790a
    li s4, 0x0b007ee4
    bfp t6,s0,s4
    sw t6,136(a1)
    li a2, 0xbf727c82
    li s10, 0x63c2cffb
    bfp s1,a2,s10
    sw s1,140(a1)
    li s10, 0xc008a4b5
    li t0, 0x01839495
    bfp s4,s10,t0
    sw s4,144(a1)
    li s4, 0xc1000002
    li s1, 0x753702f0
    bfp t2,s4,s1
    sw t2,148(a1)
    li s10, 0xc191c15a
    li s4, 0x8707f0cb
    bfp s8,s10,s4
    sw s8,152(a1)
    li a4, 0xf4e48c21
    li t1, 0xf70cd616
    bfp a7,a4,t1
    sw a7,156(a1)
    li a7, 0xf991964e
    li s10, 0xf08b494d
    bfp s2,a7,s10
    sw s2,160(a1)
    sw zero,164(a1)
    sw zero,168(a1)
    sw zero,172(a1)
    RV_COMPLIANCE_HALT
RV_COMPLIANCE_CODE_END

.data
RV_COMPLIANCE_DATA_BEGIN
test_results:
.fill 44,4,-1
RV_COMPLIANCE_DATA_END
