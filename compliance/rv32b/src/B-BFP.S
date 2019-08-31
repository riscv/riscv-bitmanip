#include "compliance_test.h"
#include "compliance_io.h"
#include "test_macros.h"

RV_COMPLIANCE_RV32M

RV_COMPLIANCE_CODE_BEGIN
    la a1,test_results
    li t4, 0x778bd1db
    li s10, 0xdef3c035
    bfp s6,t4,s10
    sw s6,0(a1)
    li s6, 0xffaace79
    li a0, 0x11e15d6b
    bfp s5,s6,a0
    sw s5,4(a1)
    li t0, 0x04bc5eac
    li a6, 0x33397f4e
    bfp s11,t0,a6
    sw s11,8(a1)
    li a3, 0x40ee4840
    li a2, 0x18331b85
    bfp t5,a3,a2
    sw t5,12(a1)
    li s8, 0x5a0d8ae2
    li a2, 0xfaafb8a6
    bfp t2,s8,a2
    sw t2,16(a1)
    li s0, 0xcccb9502
    li a5, 0xde163e74
    bfp s11,s0,a5
    sw s11,20(a1)
    li s6, 0x00800020
    li t5, 0xcce533a0
    bfp s2,s6,t5
    sw s2,24(a1)
    li s9, 0x09280a31
    li s11, 0xbf04fb41
    bfp s3,s9,s11
    sw s3,28(a1)
    li s0, 0x09a4cf49
    li a4, 0xe07b9586
    bfp a3,s0,a4
    sw a3,32(a1)
    li s3, 0x0a0b00ea
    li a7, 0x708e0000
    bfp s10,s3,a7
    sw s10,36(a1)
    li s2, 0x0b9902f0
    li s5, 0xe0f38101
    bfp t1,s2,s5
    sw t1,40(a1)
    li s6, 0x1000000a
    li s11, 0x9421d2a1
    bfp s9,s6,s11
    sw s9,44(a1)
    li s7, 0x1098a082
    li s8, 0x0d15ff77
    bfp a7,s7,s8
    sw a7,48(a1)
    li s2, 0x21f14000
    li a7, 0x35790ba0
    bfp a4,s2,a7
    sw a4,52(a1)
    li a5, 0x2e3c4800
    li a2, 0x007d3302
    bfp s3,a5,a2
    sw s3,56(a1)
    li a0, 0x32446088
    li t2, 0x0f30013d
    bfp a5,a0,t2
    sw a5,60(a1)
    li t6, 0x3808c26c
    li s8, 0x00141913
    bfp a2,t6,s8
    sw a2,64(a1)
    li s8, 0x3e32c233
    li s5, 0x649f3a6b
    bfp t0,s8,s5
    sw t0,68(a1)
    li s1, 0x439347fc
    li s11, 0x10ff6361
    bfp a5,s1,s11
    sw a5,72(a1)
    li s10, 0x46805d70
    li a4, 0x461e171c
    bfp a5,s10,a4
    sw a5,76(a1)
    li t2, 0x55763aff
    li a7, 0xcb3a5063
    bfp a4,t2,a7
    sw a4,80(a1)
    li s4, 0x65000004
    li a3, 0x721c1db0
    bfp t2,s4,a3
    sw t2,84(a1)
    li s3, 0x65720785
    li t0, 0x874e9a8a
    bfp s0,s3,t0
    sw s0,88(a1)
    li s4, 0x65e554ce
    li t0, 0x73e100c4
    bfp s2,s4,t0
    sw s2,92(a1)
    li t2, 0x6ef00014
    li a5, 0x3ee6ccda
    bfp s10,t2,a5
    sw s10,96(a1)
    li s9, 0x70008040
    li a0, 0x0f1ffd0f
    bfp t2,s9,a0
    sw t2,100(a1)
    li s9, 0x7f88d058
    li t2, 0x3788c080
    bfp s0,s9,t2
    sw s0,104(a1)
    li t2, 0x803dc580
    li s8, 0x60f6f187
    bfp a4,t2,s8
    sw a4,108(a1)
    li t0, 0x8699861f
    li t2, 0x8341a420
    bfp s9,t0,t2
    sw s9,112(a1)
    li s2, 0x96522017
    li a5, 0x90e946ad
    bfp a3,s2,a5
    sw a3,116(a1)
    li s8, 0x9a5072ac
    li a7, 0x5b343f99
    bfp a3,s8,a7
    sw a3,120(a1)
    li s7, 0xa07646d2
    li s6, 0xc70b0bbf
    bfp a7,s7,s6
    sw a7,124(a1)
    li s4, 0xa1e6026d
    li s0, 0xf5b8607a
    bfp a3,s4,s0
    sw a3,128(a1)
    li s0, 0xa2000004
    li s1, 0xe0dd3861
    bfp s10,s0,s1
    sw s10,132(a1)
    li a0, 0xbc83790a
    li s8, 0x0b007ee4
    bfp s10,a0,s8
    sw s10,136(a1)
    li s7, 0xbf727c82
    li t4, 0x63c2cffb
    bfp a7,s7,t4
    sw a7,140(a1)
    li a4, 0xc008a4b5
    li t6, 0x01839495
    bfp t2,a4,t6
    sw t2,144(a1)
    li t2, 0xc1000002
    li s5, 0x753702f0
    bfp s3,t2,s5
    sw s3,148(a1)
    li t3, 0xc191c15a
    li t0, 0x8707f0cb
    bfp s4,t3,t0
    sw s4,152(a1)
    li s5, 0xf4e48c21
    li s8, 0xf70cd616
    bfp t1,s5,s8
    sw t1,156(a1)
    li t3, 0xf991964e
    li t4, 0xf08b494d
    bfp s7,t3,t4
    sw s7,160(a1)
    RV_COMPLIANCE_HALT
RV_COMPLIANCE_CODE_END

.data
RV_COMPLIANCE_DATA_BEGIN
test_results:
.fill 41,4,-1
RV_COMPLIANCE_DATA_END
