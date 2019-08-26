#include "compliance_test.h"
#include "compliance_io.h"
#include "test_macros.h"

RV_COMPLIANCE_RV32M

RV_COMPLIANCE_CODE_BEGIN
    la a1,test_results
    li s4, 0xeadf76b9d77b6ecd
    crc32.h a2,s4
    sd a2,0(a1)
    li s5, 0x991e56a136a9a6d7
    crc32.h s7,s5
    sd s7,8(a1)
    li t5, 0x75be118b219954ae
    crc32.h t1,t5
    sd t1,16(a1)
    li a7, 0x201eccb891f3a75b
    crc32.h t6,a7
    sd t6,24(a1)
    li s6, 0x5259a8e16723f89c
    crc32.h s5,s6
    sd s5,32(a1)
    li s8, 0x80b445926042e65d
    crc32.h t4,s8
    sd t4,40(a1)
    RV_COMPLIANCE_HALT
RV_COMPLIANCE_CODE_END

.data
RV_COMPLIANCE_DATA_BEGIN
test_results:
.fill 6,8,-1
RV_COMPLIANCE_DATA_END
