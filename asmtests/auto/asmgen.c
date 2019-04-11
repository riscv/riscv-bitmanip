// RISC-V Bit Manipulation Instruction Support
//
// Copyright (c) 2019, Imperas Software Ltd. Additions
// All rights reserved.
//
// Redistribution and use in source and binary forms, with or without
// modification, are permitted provided that the following conditions are met:
//      * Redistributions of source code must retain the above copyright
//        notice, this list of conditions and the following disclaimer.
//      * Redistributions in binary form must reproduce the above copyright
//        notice, this list of conditions and the following disclaimer in the
//        documentation and/or other materials provided with the distribution.
//      * the name of Imperas Software Ltd. nor the
//        names of its contributors may be used to endorse or promote products
//        derived from this software without specific prior written permission.
//
// THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS
// IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO,
// THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR
// PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL Codasip Ltd., Imperas Software Ltd.
// BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
// DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
// LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
// ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
// (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF
// THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.


#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <string.h>
#include <assert.h>

#define XLEN 32
#define LOG2_XLEN 5
typedef uint32_t uint_xlen_t;
typedef int32_t int_xlen_t;
#include "insns.h"
#undef XLEN
#undef LOG2_XLEN

#include "../auto/asmgen.h"

int getnum(int lo, int hi) {
    int id = lo + (random() % (1+hi-lo));
    return id;
}

// x0 -> x31
int get_r(char *buf) {
    int id = getnum(0,31);
    sprintf(buf, "x%d", id);
    return id;
}
// x8 -> x15
int get_cr(char *buf) {
    int id = getnum(8,15);
    sprintf(buf, "x%d", id);
    return id;
}
// Compare register (not rD, rs1 or rs2)
void get_cmp(char *buf, char *rd, char *rs1, char *rs2) {
    strcpy(buf, rd);
    while(!strcmp(buf, rd) || !strcmp(buf, rs1) || !strcmp(buf, rs2)) {
        int id = getnum(1,31);
        sprintf(buf, "x%d", id);
    }
}

#define PROLOG_CR(FUNC,TEST) \
    char rdN[8], rdRef[8]; \
    uint_xlen_t rdVi, rdVo; \
    int rd  = get_cr(rdN); \
    get_cmp(rdRef, rdN, rdN, rdN); \
    rdVi = 0; \
    rdVi = random(); \
    if (rd) rdVo = FUNC(rdVi); \
    printf("# Test %d: (ref=%s) %s(rd=%s/0x%08X)=>0x%08X\n", TEST, rdRef, #FUNC, rdN, rdVi, rdVo); \
    printf(".l_" #FUNC "_%d_Start:\n", TEST); \
    printf("    %-8s %3s, 0x%08X\n",   "li",  rdN,   rdVi); \
    printf("    c%-7s %d\n",            #FUNC, rd); \
    printf("    %-8s %3s, 0x%08X\n",   "li",  rdRef, rdVo); \
    printf("    %-8s %3s, %3s, 1f\n",  "beq", rdN,   rdRef);

#define PROLOG_CR2(FUNC,ALIAS,TEST) \
    char rdN[8], rdRef[8]; \
    uint_xlen_t rdVi, rdVo; \
    int rd  = get_cr(rdN); \
    get_cmp(rdRef, rdN, rdN, rdN); \
    rdVi = 0; \
    rdVi = random(); \
    if (rd) rdVo = FUNC(rdVi); \
    printf("# Test %d: (ref=%s) %s(rd=%s/0x%08X)=>0x%08X\n", TEST, rdRef, #ALIAS, rdN, rdVi, rdVo); \
    printf(".l_" #ALIAS "_%d_Start:\n", TEST); \
    printf("    %-8s %3s, 0x%08X\n",   "li",  rdN,   rdVi); \
    printf("    c%-7s %d\n",            #ALIAS, rd); \
    printf("    %-8s %3s, 0x%08X\n",   "li",  rdRef, rdVo); \
    printf("    %-8s %3s, %3s, 1f\n",  "beq", rdN,   rdRef);

#define PROLOG_RR(FUNC,TEST) \
    char rdN[8], rdRef[8], rs1N[8]; \
    uint_xlen_t rs1V, rdV; \
    int rd  = get_r(rdN); \
    int rs1 = get_r(rs1N); \
    get_cmp(rdRef, rdN, rs1N, rs1N); \
    rs1V = 0; \
    rdV  = 0; \
    if (rs1) rs1V = random(); \
    if (rd)  rdV = FUNC(rs1V); \
    printf("# Test %d: (ref=%s) %s(rs1=%s/0x%08X) => (rd=%s/0x%08X)\n", TEST, rdRef, #FUNC, rs1N, rs1V, rdN, rdV); \
    printf(".l_" #FUNC "_%d_Start:\n", TEST); \
    printf("    %-8s %3s, 0x%08X\n",   "li",  rs1N,  rs1V); \
    printf("    %-8s %d %d\n",         #FUNC, rd,    rs1); \
    printf("    %-8s %3s, 0x%08X\n",   "li",  rdRef, rdV); \
    printf("    %-8s %3s, %3s, 1f\n",  "beq", rdN,   rdRef);

#define PROLOG_RRR(FUNC,TEST) \
    char rdN[8], rdRef[8], rs1N[8], rs2N[8]; \
    uint_xlen_t rs1V, rs2V, rdV; \
    int rd  = get_r(rdN); \
    int rs1 = get_r(rs1N); \
    int rs2 = get_r(rs2N); \
    get_cmp(rdRef, rdN, rs1N, rs2N); \
    rs1V = 0; \
    rs2V = 0; \
    rdV  = 0; \
    if (rs1) rs1V = random(); \
    if (rs1 == rs2) { \
        rs2V = rs1V; \
    } else if (rs2) { \
        rs2V = random(); \
    } \
    if (rd)  rdV = FUNC(rs1V, rs2V); \
    printf("# Test %d: (ref=%s) (rs1=%s/0x%08X) %s (rs2=%s/0x%08X) => (rd=%s/0x%08X)\n", TEST, rdRef, rs1N, rs1V, #FUNC, rs2N, rs2V, rdN, rdV); \
    printf(".l_" #FUNC "_%d_Start:\n", TEST); \
    printf("    %-8s %3s, 0x%08X\n",   "li",  rs1N,  rs1V); \
    printf("    %-8s %3s, 0x%08X\n",   "li",  rs2N,  rs2V); \
    printf("    %-8s %d %d %d\n",      #FUNC, rd,    rs1,   rs2); \
    printf("    %-8s %3s, 0x%08X\n",   "li",  rdRef, rdV); \
    printf("    %-8s %3s, %3s, 1f\n",  "beq", rdN,   rdRef);

#define PROLOG_RRI(FUNC,FUNCI,TEST) \
    char rdN[8], rdRef[8], rs1N[8]; \
    uint_xlen_t rs1V, rdV; \
    int rd  = get_r(rdN); \
    int rs1 = get_r(rs1N); \
    int imm = getnum(0,63); \
    get_cmp(rdRef, rdN, rs1N, rs1N); \
    rs1V = 0; \
    rdV  = 0; \
    if (rs1) rs1V = random(); \
    if (rd)  rdV = FUNC(rs1V, imm); \
    printf("# Test %d: (ref=%s) (rs1=%s/0x%08X) %s (imm=%d) => (rd=%s/0x%08X)\n", TEST, rdRef, rs1N, rs1V, #FUNCI, imm, rdN, rdV); \
    printf(".l_" #FUNCI "_%d_Start:\n", TEST); \
    printf("    %-8s %3s, 0x%08X\n",   "li",  rs1N,  rs1V); \
    printf("    %-8s %d %d %d\n",      #FUNCI, rd,    rs1,   imm); \
    printf("    %-8s %3s, 0x%08X\n",   "li",  rdRef, rdV); \
    printf("    %-8s %3s, %3s, 1f\n",  "beq", rdN,   rdRef);

#define EPILOG(FUNC,TEST) \
    printf(".l_" #FUNC "_%d_Fail:\n", TEST); \
    printf("    %-8s  x1, %d\n",   "li", TEST); \
    printf("    %-8s  x2, test_fail\n", "la"); \
    printf("    %-8s  x0, x2\n",   "jalr"); \
    printf("1:\n"); \
    printf("\n");

uint_xlen_t neg(uint_xlen_t rs1) {
    return -(rs1);
}
uint_xlen_t fnot(uint_xlen_t rs1) {
    return ~(rs1);
}

void do_clz(int test) {
    PROLOG_RR(clz, test);
    EPILOG(clz, test);
}
void do_ctz(int test) {
    PROLOG_RR(ctz, test);
    EPILOG(ctz, test);
}
void do_pcnt(int test) {
    PROLOG_RR(pcnt, test);
    EPILOG(pcnt, test);
}
void do_andc(int test) {
    PROLOG_RRR(andc, test);
    EPILOG(andc, test);
}
void do_slo(int test) {
    PROLOG_RRR(slo, test);
    EPILOG(slo, test);
}
void do_sro(int test) {
    PROLOG_RRR(sro, test);
    EPILOG(sro, test);
}
void do_sloi(int test) {
    PROLOG_RRI(slo, sloi, test);
    EPILOG(sloi, test);
}
void do_sroi(int test) {
    PROLOG_RRI(sro, sroi, test);
    EPILOG(sroi, test);
}
void do_rol(int test) {
    PROLOG_RRR(rol, test);
    EPILOG(rol, test);
}
void do_ror(int test) {
    PROLOG_RRR(ror, test);
    EPILOG(ror, test);
}
void do_rori(int test) {
    PROLOG_RRI(ror, rori, test);
    EPILOG(rori, test);
}
void do_grev(int test) {
    PROLOG_RRR(grev, test);
    EPILOG(grev, test);
}
void do_grevi(int test) {
    PROLOG_RRI(grev, grevi, test);
    EPILOG(grevi, test);
}
void do_shfl(int test) {
    PROLOG_RRR(shfl, test);
    EPILOG(shfl, test);
}
void do_shfli(int test) {
    PROLOG_RRI(shfl, shfli, test);
    EPILOG(shfli, test);
}
void do_unshfl(int test) {
    PROLOG_RRR(unshfl, test);
    EPILOG(unshfl, test);
}
void do_unshfli(int test) {
    PROLOG_RRI(unshfl, unshfli, test);
    EPILOG(unshfli, test);
}
void do_bext(int test) {
    PROLOG_RRR(bext, test);
    EPILOG(bext, test);
}
void do_bdep(int test) {
    PROLOG_RRR(bdep, test);
    EPILOG(bdep, test);
}
void do_neg(int test) {
    PROLOG_CR(neg, test);
    EPILOG(neg, test);
}
void do_not(int test) {
    PROLOG_CR2(fnot, not, test);
    EPILOG(not, test);
}
void do_cbrev(int test) {
    PROLOG_CR(brev, test);
    EPILOG(brev, test);
}
void do_crc32_b(int test) {
    PROLOG_RR(crc32_b, test);
    EPILOG(crc32_b, test);
}
void do_crc32_h(int test) {
    PROLOG_RR(crc32_h, test);
    EPILOG(crc32_h, test);
}
void do_crc32_w(int test) {
    PROLOG_RR(crc32_w, test);
    EPILOG(crc32_w, test);
}
void do_crc32c_b(int test) {
    PROLOG_RR(crc32c_b, test);
    EPILOG(crc32c_b, test);
}
void do_crc32c_h(int test) {
    PROLOG_RR(crc32c_h, test);
    EPILOG(crc32c_h, test);
}
void do_crc32c_w(int test) {
    PROLOG_RR(crc32c_w, test);
    EPILOG(crc32c_w, test);
}

void do_bmatflip(int test) {
    PROLOG_RR(bmatflip, test);
    EPILOG(bmatflip, test);
}

// arg1 = num instructions
int main(int argc, char **argv) {
    printf(".include \"extB.S.include\"\n");
    printf("\n");
    printf("START_TEST:\n");
    printf("    la x2, test_result\n");
    printf("    li x1, 0\n");
    printf("    sw x1, 0(x2)\n");
    printf("\n");

    int iter = 100;
    if (argc > 1) iter = atoi(argv[1]);

    int test = 0;
    while (test < iter) {
        do_clz(++test);
        do_ctz(++test);
        do_pcnt(++test);
        do_andc(++test);
        do_slo(++test);
        do_sro(++test);
        do_sloi(++test);
        do_sroi(++test);
        do_rol(++test);
        do_ror(++test);
        do_rori(++test);
        do_grev(++test);
        do_grevi(++test);
        do_shfl(++test);
        do_unshfl(++test);
        do_shfli(++test);
        do_unshfli(++test);
        do_bext(++test);
        do_bdep(++test);
//        do_cmix(++test);
//        do_cmov(++test);
//        do_fsl(++test);
//        do_fsr(++test);
//        do_min(++test);
//        do_max(++test);
//        do_minu(++test);
//        do_manu(++test);
//        do_clmul(++test);
//        do_clmulh(++test);
        do_crc32_b(++test);
        do_crc32_h(++test);
        do_crc32_w(++test);
//        do_crc32_d(++test);
        do_crc32c_b(++test);
        do_crc32c_h(++test);
        do_crc32c_w(++test);
//        do_crc32c_d(++test);
//        do_bmatxor(++test);
//        do_bmator(++test);
//        do_bmatflip(++test);
        do_neg(++test);
        do_not(++test);
        do_cbrev(++test);
    }

    printf("test_complete:\n");
    printf("    %-8s  x0, %s\n", "jal", "test_pass");
    printf("\n");

    printf("test_fail:\n");
    printf("    WRITE_LOG str_Test_Fail\n");
    printf("    la x2, test_result\n");
    printf("    sw x1, 0(x2)\n");
    printf("    li gp, 0\n");
    printf("    EXIT_TEST\n");
    printf("\n");

    printf("test_pass:\n");
    printf("    WRITE_LOG str_Test_Pass\n");
    printf("    li x1, 0\n");   // Assign 0 to test
    printf("    la x2, test_result\n");
    printf("    sw x1, 0(x2)\n");
    printf("    li gp, 1\n");
    printf("    EXIT_TEST\n");
    printf("\n");

    printf("test_result:\n");
    printf("    .fill 1, 4, -1\n");

    printf("str_Test_Pass:\n");
    printf("    .string \"Test Pass\"\n");
    printf("str_Test_Fail:\n");
    printf("    .string \"Test Fail\"\n");

    return 0;
}

