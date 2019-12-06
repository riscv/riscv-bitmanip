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
    li s7, 0x00800020
    li s6, 0xcce533a0
    bfp s0,s7,s6
    sw s0,24(a1)
    li s10, 0x09280a31
    li s1, 0xbf04fb41
    bfp a5,s10,s1
    sw a5,28(a1)
    li t3, 0x09a4cf49
    li s4, 0xe07b9586
    bfp a6,t3,s4
    sw a6,32(a1)
    li t1, 0x0a0b00ea
    li s7, 0x708e0000
    bfp t5,t1,s7
    sw t5,36(a1)
    li s0, 0x0b9902f0
    li t1, 0xe0f38101
    bfp a0,s0,t1
    sw a0,40(a1)
    li s5, 0x1000000a
    li t1, 0x9421d2a1
    bfp a0,s5,t1
    sw a0,44(a1)
    li a0, 0x1098a082
    li t1, 0x0d15ff77
    bfp t0,a0,t1
    sw t0,48(a1)
    li a0, 0x21f14000
    li t0, 0x35790ba0
    bfp t3,a0,t0
    sw t3,52(a1)
    li s4, 0x2e3c4800
    li s10, 0x007d3302
    bfp s2,s4,s10
    sw s2,56(a1)
    li s5, 0x32446088
    li s6, 0x0f30013d
    bfp a7,s5,s6
    sw a7,60(a1)
    li s0, 0x3808c26c
    li s4, 0x00141913
    bfp t6,s0,s4
    sw t6,64(a1)
    li a2, 0x3e32c233
    li s10, 0x649f3a6b
    bfp s1,a2,s10
    sw s1,68(a1)
    li s10, 0x439347fc
    li t0, 0x10ff6361
    bfp s4,s10,t0
    sw s4,72(a1)
    li s4, 0x46805d70
    li s1, 0x461e171c
    bfp t2,s4,s1
    sw t2,76(a1)
    li s10, 0x55763aff
    li s4, 0xcb3a5063
    bfp s8,s10,s4
    sw s8,80(a1)
    li a4, 0x65000004
    li t1, 0x721c1db0
    bfp a7,a4,t1
    sw a7,84(a1)
    li a7, 0x65720785
    li s10, 0x874e9a8a
    bfp s2,a7,s10
    sw s2,88(a1)
    li s4, 0x65e554ce
    li t0, 0x73e100c4
    bfp a7,s4,t0
    sw a7,92(a1)
    li t2, 0x6ef00014
    li t5, 0x3ee6ccda
    bfp t1,t2,t5
    sw t1,96(a1)
    li t3, 0x70008040
    li t5, 0x0f1ffd0f
    bfp a0,t3,t5
    sw a0,100(a1)
    li t5, 0x7f88d058
    li t2, 0x3788c080
    bfp s10,t5,t2
    sw s10,104(a1)
    li t5, 0x803dc580
    li t6, 0x60f6f187
    bfp s10,t5,t6
    sw s10,108(a1)
    li a7, 0x8699861f
    li a3, 0x8341a420
    bfp t5,a7,a3
    sw t5,112(a1)
    li t2, 0x96522017
    li a7, 0x90e946ad
    bfp s1,t2,a7
    sw s1,116(a1)
    li t0, 0x9a5072ac
    li s1, 0x5b343f99
    bfp s0,t0,s1
    sw s0,120(a1)
    li s4, 0xa07646d2
    li a2, 0xc70b0bbf
    bfp s9,s4,a2
    sw s9,124(a1)
    li a4, 0xa1e6026d
    li a6, 0xf5b8607a
    bfp t1,a4,a6
    sw t1,128(a1)
    li s6, 0xa2000004
    li s7, 0xe0dd3861
    bfp a3,s6,s7
    sw a3,132(a1)
    li t3, 0xbc83790a
    li a7, 0x0b007ee4
    bfp a4,t3,a7
    sw a4,136(a1)
    li t6, 0xbf727c82
    li s9, 0x63c2cffb
    bfp t2,t6,s9
    sw t2,140(a1)
    li a7, 0xc008a4b5
    li s2, 0x01839495
    bfp s5,a7,s2
    sw s5,144(a1)
    li a7, 0xc1000002
    li s7, 0x753702f0
    bfp s5,a7,s7
    sw s5,148(a1)
    li s5, 0xc191c15a
    li a2, 0x8707f0cb
    bfp t1,s5,a2
    sw t1,152(a1)
    li t2, 0xf4e48c21
    li a7, 0xf70cd616
    bfp s5,t2,a7
    sw s5,156(a1)
    li a3, 0xf991964e
    li s7, 0xf08b494d
    bfp a4,a3,s7
    sw a4,160(a1)
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
