#include "compliance_test.h"
#include "compliance_io.h"
#include "test_macros.h"

RV_COMPLIANCE_RV32M

RV_COMPLIANCE_CODE_BEGIN
    la a1,test_results
    li a5, 0xeadf76b9d77b6ecd
    crc32c.h s11,a5
    sd s11,0(a1)
    li s6, 0x991e56a136a9a6d7
    crc32c.h s5,s6
    sd s5,8(a1)
    li t2, 0x75be118b219954ae
    crc32c.h t0,t2
    sd t0,16(a1)
    li s6, 0x201eccb891f3a75b
    crc32c.h t6,s6
    sd t6,24(a1)
    li a6, 0x5259a8e16723f89c
    crc32c.h t0,a6
    sd t0,32(a1)
    li a7, 0x80b445926042e65d
    crc32c.h t2,a7
    sd t2,40(a1)
    RV_COMPLIANCE_HALT
RV_COMPLIANCE_CODE_END

.data
RV_COMPLIANCE_DATA_BEGIN
test_results:
.fill 6,8,-1
RV_COMPLIANCE_DATA_END
