#include "compliance_test.h"
#include "compliance_io.h"
#include "test_macros.h"

RV_COMPLIANCE_RV32M

RV_COMPLIANCE_CODE_BEGIN
    la a1,test_results
    li s4, 0xd77b6ecd
    crc32.h s6,s4
    sw s6,0(a1)
    li s1, 0x36a9a6d7
    crc32.h t5,s1
    sw t5,4(a1)
    li s11, 0x219954ae
    crc32.h a3,s11
    sw a3,8(a1)
    li t2, 0x91f3a75b
    crc32.h a6,t2
    sw a6,12(a1)
    li s5, 0x6723f89c
    crc32.h t5,s5
    sw t5,16(a1)
    li s4, 0x6042e65d
    crc32.h a2,s4
    sw a2,20(a1)
    RV_COMPLIANCE_HALT
RV_COMPLIANCE_CODE_END

.data
RV_COMPLIANCE_DATA_BEGIN
test_results:
.fill 6,4,-1
RV_COMPLIANCE_DATA_END
