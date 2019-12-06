#include "compliance_test.h"
#include "compliance_io.h"
#include "test_macros.h"

RV_COMPLIANCE_RV32M

RV_COMPLIANCE_CODE_BEGIN
    la a1,test_results
    li s2, 0xeadf76b9d77b6ecd
    crc32c.b a5,s2
    sd a5,0(a1)
    li a4, 0x991e56a136a9a6d7
    crc32c.b a3,a4
    sd a3,8(a1)
    li a0, 0x75be118b219954ae
    crc32c.b a4,a0
    sd a4,16(a1)
    li t0, 0x201eccb891f3a75b
    crc32c.b s11,t0
    sd s11,24(a1)
    li a2, 0x5259a8e16723f89c
    crc32c.b s5,a2
    sd s5,32(a1)
    li a5, 0x80b445926042e65d
    crc32c.b t5,a5
    sd t5,40(a1)
    RV_COMPLIANCE_HALT
RV_COMPLIANCE_CODE_END

.data
RV_COMPLIANCE_DATA_BEGIN
test_results:
.fill 6,8,-1
RV_COMPLIANCE_DATA_END
