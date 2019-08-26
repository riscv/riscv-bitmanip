#include "compliance_test.h"
#include "compliance_io.h"
#include "test_macros.h"

RV_COMPLIANCE_RV32M

RV_COMPLIANCE_CODE_BEGIN
    la a1,test_results
    li t6, 0x0000000000000000
    clzw s5,t6
    sd s5,0(a1)
    li s11, 0xffffffffffffffff
    clzw a4,s11
    sd a4,8(a1)
    li s10, 0xeadf76b9d77b6ecd
    clzw a4,s10
    sd a4,16(a1)
    li a7, 0x991e56a136a9a6d7
    clzw s5,a7
    sd s5,24(a1)
    li a0, 0x75be118b219954ae
    clzw t3,a0
    sd t3,32(a1)
    li a3, 0x201eccb891f3a75b
    clzw s10,a3
    sd s10,40(a1)
    li a7, 0x5259a8e16723f89c
    clzw t0,a7
    sd t0,48(a1)
    li s5, 0x80b445926042e65d
    clzw s2,s5
    sd s2,56(a1)
    RV_COMPLIANCE_HALT
RV_COMPLIANCE_CODE_END

.data
RV_COMPLIANCE_DATA_BEGIN
test_results:
.fill 8,8,-1
RV_COMPLIANCE_DATA_END
