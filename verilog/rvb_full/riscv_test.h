#ifndef _ENV_PICORV32_H
#define _ENV_PICORV32_H

#include "encoding.h"

#define RVTEST_RV32U                                                    \
  .macro init;                                                          \
  .endm

#define RVTEST_RV32M                                                    \
  .macro init;                                                          \
  RVTEST_ENABLE_MACHINE;                                                \
  .endm

#define RVTEST_RV32S                                                    \
  .macro init;                                                          \
  RVTEST_ENABLE_SUPERVISOR;                                             \
  .endm

#define RVTEST_CODE_BEGIN                                               \
        .text;                                                          \
        .global RVTEST_SYM(testcode);                                   \
RVTEST_SYM(testcode):                                                   \
        sw ra,  test_sav_ra,  t0;                                       \
        sw sp,  test_sav_sp,  t0;                                       \
        sw gp,  test_sav_gp,  t0;                                       \
        sw tp,  test_sav_tp,  t0;                                       \
        sw s0,  test_sav_s0,  t0;                                       \
        sw s1,  test_sav_s1,  t0;                                       \
        sw s2,  test_sav_s2,  t0;                                       \
        sw s3,  test_sav_s3,  t0;                                       \
        sw s4,  test_sav_s4,  t0;                                       \
        sw s5,  test_sav_s5,  t0;                                       \
        sw s6,  test_sav_s6,  t0;                                       \
        sw s7,  test_sav_s7,  t0;                                       \
        sw s8,  test_sav_s8,  t0;                                       \
        sw s9,  test_sav_s9,  t0;                                       \
        sw s10, test_sav_s10, t0;                                       \
        sw s11, test_sav_s11, t0

#define RVTEST_CODE_END                                                 \
end_testcode:                                                           \
        lw ra,  test_sav_ra;                                            \
        lw sp,  test_sav_sp;                                            \
        lw gp,  test_sav_gp;                                            \
        lw tp,  test_sav_tp;                                            \
        lw s0,  test_sav_s0;                                            \
        lw s1,  test_sav_s1;                                            \
        lw s2,  test_sav_s2;                                            \
        lw s3,  test_sav_s3;                                            \
        lw s4,  test_sav_s4;                                            \
        lw s5,  test_sav_s5;                                            \
        lw s6,  test_sav_s6;                                            \
        lw s7,  test_sav_s7;                                            \
        lw s8,  test_sav_s8;                                            \
        lw s9,  test_sav_s9;                                            \
        lw s10, test_sav_s10;                                           \
        lw s11, test_sav_s11;                                           \
        ret; unimp

//-----------------------------------------------------------------------
// Pass/Fail Macro
//-----------------------------------------------------------------------
#define RVTEST_SYNC nop

#define RVTEST_PASS                                                     \
        RVTEST_SYNC;                                                    \
        li TESTNUM, 1;                                                  \
        SWSIG (0, TESTNUM);                                             \
        j end_testcode

#define TESTNUM gp
#define RVTEST_FAIL                                                     \
        RVTEST_SYNC;                                                    \
1:      beqz TESTNUM, 1b;                                               \
        sll TESTNUM, TESTNUM, 1;                                        \
        or TESTNUM, TESTNUM, 1;                                         \
        SWSIG (0, TESTNUM);                                             \
        ebreak

//-----------------------------------------------------------------------
// Data Section Macro
//-----------------------------------------------------------------------

#define EXTRA_DATA                                                      \
        .align 4;                                                       \
	test_sav_ra:  .word 0;                                          \
	test_sav_sp:  .word 0;                                          \
	test_sav_gp:  .word 0;                                          \
	test_sav_tp:  .word 0;                                          \
	test_sav_s0:  .word 0;                                          \
	test_sav_s1:  .word 0;                                          \
	test_sav_s2:  .word 0;                                          \
	test_sav_s3:  .word 0;                                          \
	test_sav_s4:  .word 0;                                          \
	test_sav_s5:  .word 0;                                          \
	test_sav_s6:  .word 0;                                          \
	test_sav_s7:  .word 0;                                          \
	test_sav_s8:  .word 0;                                          \
	test_sav_s9:  .word 0;                                          \
	test_sav_s10: .word 0;                                          \
	test_sav_s11: .word 0

#define RVTEST_DATA_BEGIN                                               \
        EXTRA_DATA;                                                     \
        .align 4;                                                       \
	.global RVTEST_SYM(signature);                                  \
	RVTEST_SYM(signature):

#define RVTEST_DATA_END                                                 \
        .align 4

#endif
