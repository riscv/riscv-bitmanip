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
#include <time.h>

#if (XLEN==32)
    typedef uint32_t uint_xlen_t;
    typedef  int32_t  int_xlen_t;
#   define FMT_CONST "0x%08X"

#   define MAX_IMM 31
    uint_xlen_t randomV() {
        uint_xlen_t value =random();
        return value;
    }
#else
    typedef uint64_t uint_xlen_t;
    typedef  int64_t  int_xlen_t;
#   define FMT_CONST "0x%016LX"
#   define MAX_IMM 63

    uint_xlen_t randomV() {
        uint_xlen_t value = ((uint64_t)random() << 32) | random();
        return value;
    }
#endif

#include "insns.h"
#include "../auto/asmgen.h"

#define XLEN_W 32
uint64_t grevw(uint64_t rs1, uint64_t rs2) {
    uint32_t u32 = grev32(rs1, rs2);
    uint64_t u64 = (int64_t)(int32_t)u32;
    return u64;
}
uint64_t slow(uint32_t rs1, uint32_t rs2) {
    int shamt = rs2 & (XLEN_W - 1);
    uint32_t u32 = ~(~rs1 << shamt);
    uint64_t u64 = (int64_t)(int32_t)u32;
    return u64;
}
uint64_t srow(uint32_t rs1, uint32_t rs2) {
    int shamt = rs2 & (XLEN_W - 1);
    uint32_t u32 = ~(~rs1 >> shamt);
    uint64_t u64 = (int64_t)(int32_t)u32;
    return u64;
}
uint64_t rolw(uint32_t rs1, uint32_t rs2) {
    int shamt = rs2 & (XLEN_W - 1);
    uint32_t u32 = (rs1 << shamt) | (rs1 >> ((XLEN_W - shamt) & (XLEN_W - 1)));
    uint64_t u64 = (int64_t)(int32_t)u32;
    return u64;
}
uint64_t rorw(uint32_t rs1, uint32_t rs2) {
    int shamt = rs2 & (XLEN_W - 1);
    uint32_t u32 = (rs1 >> shamt) | (rs1 << ((XLEN_W - shamt) & (XLEN_W - 1)));
    uint64_t u64 = (int64_t)(int32_t)u32;
    return u64;
}
uint64_t bsetw(uint32_t rs1, uint32_t rs2) {
    int shamt = rs2 & (XLEN_W - 1);
    uint32_t u32 = rs1 | (uint32_t(1) << shamt);
    uint64_t u64 = (int64_t)(int32_t)u32;
    return u64;
}
uint64_t bclrw(uint32_t rs1, uint32_t rs2) {
    int shamt = rs2 & (XLEN_W - 1);
    uint32_t u32 = rs1 & ~(uint32_t(1) << shamt);
    uint64_t u64 = (int64_t)(int32_t)u32;
    return u64;
}
uint64_t binvw(uint32_t rs1, uint32_t rs2){
    int shamt = rs2 & (XLEN_W - 1);
    uint32_t u32 = rs1 ^ (uint32_t(1) << shamt);
    uint64_t u64 = (int64_t)(int32_t)u32;
    return u64;
}
uint64_t bextw(uint32_t rs1, uint32_t rs2) {
    int shamt = rs2 & (XLEN_W - 1);
    uint32_t u32 = 1 & (rs1 >> shamt);
    uint64_t u64 = (int64_t)(int32_t)u32;
    return u64;
}
uint64_t fslw(uint32_t rs1, uint32_t rs2, uint32_t rs3) {
    int shamt = rs2 & (2*XLEN_W - 1);
    uint32_t A = rs1, B = rs3;
    if (shamt >= XLEN_W) {
        shamt -= XLEN_W;
        A = rs3;
        B = rs1;
    }
    uint32_t u32 = shamt ? (A << shamt) | (B >> (XLEN_W-shamt)) : A;
    uint64_t u64 = (int64_t)(int32_t)u32;
    return u64;
}
uint64_t fsrw(uint32_t rs1, uint32_t rs2, uint32_t rs3)
{
    int shamt = rs2 & (2*XLEN_W - 1);
    uint32_t A = rs1, B = rs3;
    if (shamt >= XLEN_W) {
        shamt -= XLEN_W;
        A = rs3;
        B = rs1;
    }
    uint32_t u32 = shamt ? (A >> shamt) | (B << (XLEN_W-shamt)) : A;
    uint64_t u64 = (int64_t)(int32_t)u32;
    return u64;
}
uint64_t clzw(uint32_t rs1) {
    for (int count = 0; count < XLEN_W; count++)
        if ((rs1 << count) >> (XLEN_W - 1))
            return count;
    return XLEN_W;
}
uint64_t ctzw(uint32_t rs1) {
    for (int count = 0; count < XLEN_W; count++)
        if ((rs1 >> count) & 1)
            return count;
    return XLEN_W;
}
uint64_t cpopw(uint32_t rs1) {
    int count = 0;
    for (int index = 0; index < XLEN_W; index++)
        count += (rs1 >> index) & 1;
    return count;
}
uint64_t clmulw(uint32_t rs1, uint32_t rs2) {
    uint32_t x = 0;
    for (int i = 0; i < XLEN_W; i++)
        if ((rs2 >> i) & 1)
            x ^= rs1 << i;
    uint64_t u64 = (int64_t)(int32_t)x;
    return u64;
}
uint64_t clmulhw(uint32_t rs1, uint32_t rs2) {
    uint32_t x = 0;
    for (int i = 1; i < XLEN_W; i++)
        if ((rs2 >> i) & 1)
            x ^= rs1 >> (XLEN_W-i);
    uint64_t u64 = (int64_t)(int32_t)x;
    return u64;
}
uint64_t clmulrw(uint32_t rs1, uint32_t rs2) {
    uint32_t x = 0;
    for (int i = 0; i < XLEN_W; i++)
        if ((rs2 >> i) & 1)
            x ^= rs1 >> (XLEN_W-i-1);
    uint64_t u64 = (int64_t)(int32_t)x;
    return u64;
}
uint64_t shflw(uint32_t rs1, uint32_t rs2) {
    uint32_t u32 = shfl32(rs1, rs2);
    uint64_t u64 = (int64_t)(int32_t)u32;
    return u64;
}
uint64_t unshflw(uint32_t rs1, uint32_t rs2) {
    uint32_t u32 = unshfl32(rs1, rs2);
    uint64_t u64 = (int64_t)(int32_t)u32;
    return u64;
}
uint64_t bdecompressw(uint32_t rs1, uint32_t rs2) {
    uint32_t r = 0;
    for (int i = 0, j = 0; i < XLEN_W; i++) {
        if ((rs2 >> i) & 1) {
            if ((rs1 >> j) & 1)
                r |= uint32_t(1) << i;
            j++;
        }
    }
    uint64_t u64 = (int64_t)(int32_t)r;
    return u64;
}
uint64_t bcompressw(uint32_t rs1, uint32_t rs2) {
    uint32_t r = 0;
    for (int i = 0, j = 0; i < XLEN_W; i++) {
        if ((rs2 >> i) & 1) {
            if ((rs1 >> i) & 1)
                r |= uint32_t(1) << j;
            j++;
        }
    }
    uint64_t u64 = (int64_t)(int32_t)r;
    return u64;
}
uint64_t packw(uint32_t rs1, uint32_t rs2) {
    uint32_t lower = (rs1 << XLEN_W/2) >> XLEN_W/2;
    uint32_t upper = rs2 << XLEN_W/2;

    uint32_t u32 =  upper | lower;
    uint64_t u64 = (int64_t)(int32_t)u32;

    return u64;
}

uint64_t bfpw(uint32_t rs1, uint32_t rs2)
{
    uint32_t cfg = rs2 >> (XLEN_W/2);
    if ((cfg >> 30) == 2)
        cfg = cfg >> 16;
    int len = (cfg >> 8) & (XLEN_W/2-1);
    int off = cfg & (XLEN_W-1);
    len = len ? len : XLEN_W/2;
    uint32_t mask = slo(0, len) << off;
    uint32_t data = rs2 << off;
    uint32_t u32 = (data & mask) | (rs1 & ~mask);
    uint64_t u64 = (int64_t)(int32_t)u32;
    return u64;
}

uint64_t packuw(uint32_t rs1, uint32_t rs2)
{
    uint32_t lower = rs1 >> XLEN_W/2;
    uint32_t upper = (rs2 >> XLEN_W/2) << XLEN_W/2;
    uint32_t u32 = lower | upper;
    uint64_t u64 = (int64_t)(int32_t)u32;
    return u64;
}

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
void get_cmp(char *buf, char *rd, char *rs1, char *rs2, char *rs3) {
    strcpy(buf, rd);
    while(!strcmp(buf, rd) || !strcmp(buf, rs1) || !strcmp(buf, rs2) || !strcmp(buf, rs3)) {
        int id = getnum(1,31);
        sprintf(buf, "x%d", id);
    }
}

#define PROLOG_CR(FUNC,TEST) \
    char rdN[8], rdRef[8]; \
    uint_xlen_t rdVi, rdVo; \
    int rd  = get_cr(rdN); \
    get_cmp(rdRef, rdN, rdN, rdN, rdN); \
    rdVi = 0; \
    rdVi = randomV(); \
    if (rd) rdVo = FUNC(rdVi); \
    printf("# Test %d: (ref=%s) %s(rd=%s/" FMT_CONST ")=>" FMT_CONST "\n", TEST, rdRef, #FUNC, rdN, rdVi, rdVo); \
    printf(".l_" #FUNC "_%d_Start:\n", TEST); \
    printf("    %-8s %3s, " FMT_CONST "\n",   "li",  rdN,   rdVi); \
    printf("    c%-7s %d\n",            #FUNC, rd); \
    printf("    %-8s %3s, " FMT_CONST "\n",   "li",  rdRef, rdVo); \
    printf("    %-8s %3s, %3s, 1f\n",  "beq", rdN,   rdRef);

#define PROLOG_CR2(FUNC,ALIAS,TEST) \
    char rdN[8], rdRef[8]; \
    uint_xlen_t rdVi, rdVo; \
    int rd  = get_cr(rdN); \
    get_cmp(rdRef, rdN, rdN, rdN, rdN); \
    rdVi = 0; \
    rdVi = randomV(); \
    if (rd) rdVo = FUNC(rdVi); \
    printf("# Test %d: (ref=%s) %s(rd=%s/" FMT_CONST ")=>" FMT_CONST "\n", TEST, rdRef, #ALIAS, rdN, rdVi, rdVo); \
    printf(".l_" #ALIAS "_%d_Start:\n", TEST); \
    printf("    %-8s %3s, " FMT_CONST "\n",   "li",  rdN,   rdVi); \
    printf("    c%-7s %d\n",            #ALIAS, rd); \
    printf("    %-8s %3s, " FMT_CONST "\n",   "li",  rdRef, rdVo); \
    printf("    %-8s %3s, %3s, 1f\n",  "beq", rdN,   rdRef);

#define PROLOG_RR(FUNC,TEST) \
    char rdN[8], rdRef[8], rs1N[8]; \
    uint_xlen_t rs1V, rdV; \
    int rd  = get_r(rdN); \
    int rs1 = get_r(rs1N); \
    get_cmp(rdRef, rdN, rs1N, rs1N, rs1N); \
    rs1V = 0; \
    rdV  = 0; \
    if (rs1) rs1V = randomV(); \
    if (rd)  rdV = FUNC(rs1V); \
    printf("# Test %d: (ref=%s) %s(rs1=%s/" FMT_CONST ") => (rd=%s/" FMT_CONST ")\n", TEST, rdRef, #FUNC, rs1N, rs1V, rdN, rdV); \
    printf(".l_" #FUNC "_%d_Start:\n", TEST); \
    printf("    %-8s %3s, " FMT_CONST "\n",   "li",  rs1N,  rs1V); \
    printf("    %-8s %d %d\n",         #FUNC, rd,    rs1); \
    printf("    %-8s %3s, " FMT_CONST "\n",   "li",  rdRef, rdV); \
    printf("    %-8s %3s, %3s, 1f\n",  "beq", rdN,   rdRef);

#define PROLOG_RRR(FUNC,TEST) \
    char rdN[8], rdRef[8], rs1N[8], rs2N[8]; \
    uint_xlen_t rs1V, rs2V, rdV; \
    int rd  = get_r(rdN); \
    int rs1 = get_r(rs1N); \
    int rs2 = get_r(rs2N); \
    get_cmp(rdRef, rdN, rs1N, rs2N, rs2N); \
    rs1V = 0; \
    rs2V = 0; \
    rdV  = 0; \
    if (rs1) rs1V = randomV(); \
    if (rs2) rs2V = randomV(); \
    \
    if (rs1 == rs2 ) { \
        rs2V = rs1V; \
    } \
    if (rd)  rdV = FUNC(rs1V, rs2V); \
    printf("# Test %d: (ref=%s) %s(rs1=%s/" FMT_CONST ")(rs2=%s/" FMT_CONST ") => (rd=%s/" FMT_CONST ")\n", TEST, rdRef, #FUNC, rs1N, rs1V, rs2N, rs2V, rdN, rdV); \
    printf(".l_" #FUNC "_%d_Start:\n", TEST); \
    printf("    %-8s %3s, " FMT_CONST "\n",   "li",  rs1N,  rs1V); \
    printf("    %-8s %3s, " FMT_CONST "\n",   "li",  rs2N,  rs2V); \
    printf("    %-8s %d %d %d\n",      #FUNC, rd,    rs1,   rs2); \
    printf("    %-8s %3s, " FMT_CONST "\n",   "li",  rdRef, rdV); \
    printf("    %-8s %3s, %3s, 1f\n",  "beq", rdN,   rdRef);

#define PROLOG_RRI(FUNC,FUNCI,TEST) \
    char rdN[8], rdRef[8], rs1N[8]; \
    uint_xlen_t rs1V, rdV; \
    int rd  = get_r(rdN); \
    int rs1 = get_r(rs1N); \
    int imm = getnum(0,MAX_IMM); \
    get_cmp(rdRef, rdN, rs1N, rs1N, rs1N); \
    rs1V = 0; \
    rdV  = 0; \
    if (rs1) rs1V = randomV(); \
    if (rd)  rdV = FUNC(rs1V, imm); \
    printf("# Test %d: (ref=%s) (rs1=%s/" FMT_CONST ") %s (imm=%d) => (rd=%s/" FMT_CONST ")\n", TEST, rdRef, rs1N, rs1V, #FUNCI, imm, rdN, rdV); \
    printf(".l_" #FUNCI "_%d_Start:\n", TEST); \
    printf("    %-8s %3s, " FMT_CONST "\n",   "li",  rs1N,  rs1V); \
    printf("    %-8s %d %d %d\n",      #FUNCI, rd,    rs1,   imm); \
    printf("    %-8s %3s, " FMT_CONST "\n",   "li",  rdRef, rdV); \
    printf("    %-8s %3s, %3s, 1f\n",  "beq", rdN,   rdRef);

// rd, rs1, rs3, rs2
#define PROLOG_RRRR(FUNC,TEST) \
    char rdN[8], rdRef[8], rs1N[8], rs2N[8], rs3N[8]; \
    uint_xlen_t rs1V, rs2V, rs3V, rdV; \
    int rd  = get_r(rdN); \
    int rs1 = get_r(rs1N); \
    int rs2 = get_r(rs2N); \
    int rs3 = get_r(rs3N); \
    get_cmp(rdRef, rdN, rs1N, rs2N, rs3N); \
    rs1V = 0; \
    rs2V = 0; \
    rs3V = 0; \
    rdV  = 0; \
    if (rs1) rs1V = randomV(); \
    if (rs2) rs2V = randomV(); \
    if (rs3) rs3V = randomV(); \
    \
    if (rs1 == rs2 ) { \
        rs2V = rs1V; \
    } \
    if (rs1 == rs3) { \
        rs3V = rs1V; \
    } \
    if (rs2 == rs3) { \
        rs2V = rs3V; \
    } \
    if (rd)  rdV = FUNC(rs1V, rs2V, rs3V); \
    printf("# Test %d: (ref=%s) %s(rs1=%s/" FMT_CONST ")(rs2=%s/" FMT_CONST ")(rs3=%s/" FMT_CONST ") => (rd=%s/" FMT_CONST ")\n", TEST, rdRef, #FUNC, rs1N, rs1V, rs2N, rs2V, rs3N, rs3V, rdN, rdV); \
    printf(".l_" #FUNC "_%d_Start:\n", TEST); \
    printf("    %-8s %3s, " FMT_CONST "\n",   "li",  rs1N,  rs1V); \
    printf("    %-8s %3s, " FMT_CONST "\n",   "li",  rs2N,  rs2V); \
    printf("    %-8s %3s, " FMT_CONST "\n",   "li",  rs3N,  rs3V); \
    printf("    %-8s %d %d %d %d\n",    #FUNC, rd,    rs1,   rs2,  rs3); \
    printf("    %-8s %3s, " FMT_CONST "\n",   "li",  rdRef, rdV); \
    printf("    %-8s %3s, %3s, 1f\n",  "beq", rdN,   rdRef);

// rd, rs1, rs3, imm
#define PROLOG_RRRI(FUNC,FUNCI,TEST) \
    char rdN[8], rdRef[8], rs1N[8], rs3N[8]; \
    uint_xlen_t rs1V, rs3V, rdV; \
    int rd  = get_r(rdN); \
    int rs1 = get_r(rs1N); \
    int rs3 = get_r(rs3N); \
    int imm = getnum(0,31); \
    get_cmp(rdRef, rdN, rs1N, rs1N, rs3N); \
    rs1V = 0; \
    rs3V = 0; \
    rdV  = 0; \
    if (rs1) rs1V = randomV(); \
    if (rs3) rs3V = randomV(); \
    \
    if (rs1 == rs3) { \
        rs3V = rs1V; \
    } \
    if (rd)  rdV = FUNC(rs1V, imm, rs3V); \
    printf("# Test %d: (ref=%s) %s(rs1=%s/" FMT_CONST ")(imm=%d)(rs3=%s/" FMT_CONST ") => (rd=%s/" FMT_CONST ")\n", TEST, rdRef, #FUNCI, rs1N, rs1V, imm, rs3N, rs3V, rdN, rdV); \
    printf(".l_" #FUNCI "_%d_Start:\n", TEST); \
    printf("    %-8s %3s, " FMT_CONST "\n",    "li",  rs1N,  rs1V); \
    printf("    %-8s %3s, " FMT_CONST "\n",    "li",  rs3N,  rs3V); \
    printf("    %-8s %d %d %d %d\n",    #FUNCI, rd,    rs1,   imm,  rs3); \
    printf("    %-8s %3s, " FMT_CONST "\n",    "li",  rdRef, rdV); \
    printf("    %-8s %3s, %3s, 1f\n",  "beq",  rdN,   rdRef);

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

void do_clz(int test) {
    PROLOG_RR(clz, test);
    EPILOG(clz, test);
}
void do_clzw(int test) {
    PROLOG_RR(clzw, test);
    EPILOG(clzw, test);
}
void do_ctz(int test) {
    PROLOG_RR(ctz, test);
    EPILOG(ctz, test);
}
void do_ctzw(int test) {
    PROLOG_RR(ctzw, test);
    EPILOG(ctzw, test);
}
void do_cpop(int test) {
    PROLOG_RR(cpop, test);
    EPILOG(cpop, test);
}
void do_cpopw(int test) {
    PROLOG_RR(cpopw, test);
    EPILOG(cpopw, test);
}
void do_sextb(int test) {
    PROLOG_RR(sextb, test);
    EPILOG(sextb, test);
}
void do_sexth(int test) {
    PROLOG_RR(sexth, test);
    EPILOG(sexth, test);
}
void do_andn(int test) {
    PROLOG_RRR(andn, test);
    EPILOG(andn, test);
}
void do_orn(int test) {
    PROLOG_RRR(orn, test);
    EPILOG(orn, test);
}
void do_xnor(int test) {
    PROLOG_RRR(xnor, test);
    EPILOG(xnor, test);
}
void do_slo(int test) {
    PROLOG_RRR(slo, test);
    EPILOG(slo, test);
}
void do_slow(int test) {
    PROLOG_RRR(slow, test);
    EPILOG(slow, test);
}
void do_sro(int test) {
    PROLOG_RRR(sro, test);
    EPILOG(sro, test);
}
void do_srow(int test) {
    PROLOG_RRR(srow, test);
    EPILOG(srow, test);
}
void do_sloi(int test) {
    PROLOG_RRI(slo, sloi, test);
    EPILOG(sloi, test);
}
void do_sloiw(int test) {
    PROLOG_RRI(slow, sloiw, test);
    EPILOG(sloiw, test);
}
void do_sroi(int test) {
    PROLOG_RRI(sro, sroi, test);
    EPILOG(sroi, test);
}
void do_sroiw(int test) {
    PROLOG_RRI(srow, sroiw, test);
    EPILOG(sroiw, test);
}
void do_rol(int test) {
    PROLOG_RRR(rol, test);
    EPILOG(rol, test);
}
void do_rolw(int test) {
    PROLOG_RRR(rolw, test);
    EPILOG(rolw, test);
}
void do_ror(int test) {
    PROLOG_RRR(ror, test);
    EPILOG(ror, test);
}
void do_rorw(int test) {
    PROLOG_RRR(rorw, test);
    EPILOG(rorw, test);
}
void do_bset(int test) {
    PROLOG_RRR(bset, test);
    EPILOG(bset, test);
}
void do_bsetw(int test) {
    PROLOG_RRR(bsetw, test);
    EPILOG(bsetw, test);
}
void do_bclr(int test) {
    PROLOG_RRR(bclr, test);
    EPILOG(bclr, test);
}
void do_bclrw(int test) {
    PROLOG_RRR(bclrw, test);
    EPILOG(bclrw, test);
}
void do_binv(int test) {
    PROLOG_RRR(binv, test);
    EPILOG(binv, test);
}
void do_binvw(int test) {
    PROLOG_RRR(binvw, test);
    EPILOG(binvw, test);
}
void do_bext(int test) {
    PROLOG_RRR(bext, test);
    EPILOG(bext, test);
}
void do_bextw(int test) {
    PROLOG_RRR(bextw, test);
    EPILOG(bextw, test);
}
void do_bseti(int test) {
    PROLOG_RRI(bset, bseti, test);
    EPILOG(bseti, test);
}
void do_bsetiw(int test) {
    PROLOG_RRI(bsetw, bsetiw, test);
    EPILOG(bsetiw, test);
}
void do_bclri(int test) {
    PROLOG_RRI(bclr, bclri, test);
    EPILOG(bclri, test);
}
void do_bclriw(int test) {
    PROLOG_RRI(bclrw, bclriw, test);
    EPILOG(bclriw, test);
}
void do_binvi(int test) {
    PROLOG_RRI(binv, binvi, test);
    EPILOG(binvi, test);
}
void do_binviw(int test) {
    PROLOG_RRI(binvw, binviw, test);
    EPILOG(binviw, test);
}
void do_bexti(int test) {
    PROLOG_RRI(bext, bexti, test);
    EPILOG(bexti, test);
}
void do_rori(int test) {
    PROLOG_RRI(ror, rori, test);
    EPILOG(rori, test);
}
void do_roriw(int test) {
    PROLOG_RRI(rorw, roriw, test);
    EPILOG(roriw, test);
}
void do_grev(int test) {
    PROLOG_RRR(grev, test);
    EPILOG(grev, test);
}
void do_grevw(int test) {
    PROLOG_RRR(grevw, test);
    EPILOG(grevw, test);
}
void do_grevi(int test) {
    PROLOG_RRI(grev, grevi, test);
    EPILOG(grevi, test);
}
void do_shfl(int test) {
    PROLOG_RRR(shfl, test);
    EPILOG(shfl, test);
}
void do_shflw(int test) {
    PROLOG_RRR(shflw, test);
    EPILOG(shflw, test);
}
void do_shfli(int test) {
    PROLOG_RRI(shfl, shfli, test);
    EPILOG(shfli, test);
}
void do_unshfl(int test) {
    PROLOG_RRR(unshfl, test);
    EPILOG(unshfl, test);
}
void do_unshflw(int test) {
    PROLOG_RRR(unshflw, test);
    EPILOG(unshflw, test);
}
void do_unshfli(int test) {
    PROLOG_RRI(unshfl, unshfli, test);
    EPILOG(unshfli, test);
}
void do_bcompress(int test) {
    PROLOG_RRR(bcompress, test);
    EPILOG(bcompress, test);
}
void do_bcompressw(int test) {
    PROLOG_RRR(bcompressw, test);
    EPILOG(bcompressw, test);
}
void do_bdecompress(int test) {
    PROLOG_RRR(bdecompress, test);
    EPILOG(bdecompress, test);
}
void do_bdecompressw(int test) {
    PROLOG_RRR(bdecompressw, test);
    EPILOG(bdecompressw, test);
}
void do_pack(int test) {
    PROLOG_RRR(pack, test);
    EPILOG(pack, test);
}
void do_packu(int test) {
    PROLOG_RRR(packu, test);
    EPILOG(packu, test);
}
void do_packh(int test) {
    PROLOG_RRR(packh, test);
    EPILOG(packh, test);
}
void do_packw(int test) {
    PROLOG_RRR(packw, test);
    EPILOG(packw, test);
}
void do_packuw(int test) {
    PROLOG_RRR(packuw, test);
    EPILOG(packuw, test);
}
void do_bfpw(int test) {
    PROLOG_RRR(bfpw, test);
    EPILOG(bfpw, test);
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

// TODO - check side effect t0 register
void do_cmix(int test) {
    PROLOG_RRRR(cmix, test);
    EPILOG(cmix, test);
}
void do_cmov(int test) {
    PROLOG_RRRR(cmov, test);
    EPILOG(cmov, test);
}
void do_fsl(int test) {
    PROLOG_RRRR(fsl, test);
    EPILOG(fsl, test);
}
void do_fslw(int test) {
    PROLOG_RRRR(fslw, test);
    EPILOG(fslw, test);
}
void do_fsr(int test) {
    PROLOG_RRRR(fsr, test);
    EPILOG(fsr, test);
}
void do_fsri(int test) {
    PROLOG_RRRI(fsr, fsri, test);
    EPILOG(fsri, test);
}
void do_fsrw(int test) {
    PROLOG_RRRR(fsrw, test);
    EPILOG(fsrw, test);
}
void do_fsriw(int test) {
    PROLOG_RRRI(fsrw, fsriw, test);
    EPILOG(fsriw, test);
}
void do_min(int test) {
    PROLOG_RRR(min, test);
    EPILOG(min, test);
}
void do_max(int test) {
    PROLOG_RRR(max, test);
    EPILOG(max, test);
}

void do_minu(int test) {
    PROLOG_RRR(minu, test);
    EPILOG(minu, test);
}

void do_maxu(int test) {
    PROLOG_RRR(maxu, test);
    EPILOG(maxu, test);
}

void do_clmul(int test) {
    PROLOG_RRR(clmul, test);
    EPILOG(clmul, test);
}
void do_clmulw(int test) {
    PROLOG_RRR(clmulw, test);
    EPILOG(clmulw, test);
}

void do_clmulr(int test) {
    PROLOG_RRR(clmulr, test);
    EPILOG(clmulr, test);
}
void do_clmulrw(int test) {
    PROLOG_RRR(clmulrw, test);
    EPILOG(clmulrw, test);
}

void do_clmulh(int test) {
    PROLOG_RRR(clmulh, test);
    EPILOG(clmulh, test);
}
void do_clmulhw(int test) {
    PROLOG_RRR(clmulhw, test);
    EPILOG(clmulhw, test);
}
void do_adduw(int test) {
    PROLOG_RRR(adduw, test);
    EPILOG(adduw, test);
}
void do_bfp(int test) {
    PROLOG_RRR(bfp, test);
    EPILOG(bfp, test);
}

#if (XLEN==64)
void do_crc32_d(int test) {
    PROLOG_RR(crc32_d, test);
    EPILOG(crc32_d, test);
}
void do_crc32c_d(int test) {
    PROLOG_RR(crc32c_d, test);
    EPILOG(crc32c_d, test);
}
void do_bmatxor(int test) {
    PROLOG_RRR(bmatxor, test);
    EPILOG(bmatxor, test);
}
void do_bmator(int test) {
    PROLOG_RRR(bmator, test);
    EPILOG(bmator, test);
}
void do_bmatflip(int test) {
    PROLOG_RR(bmatflip, test);
    EPILOG(bmatflip, test);
}
#endif

// arg1 = num instructions
int main(int argc, char **argv) {
    printf("#include \"extB.S.include\"\n");
    printf("\n");
    printf("\n");

    printf("INIT_START_TEST:\n");
    printf("    j START_TEST\n");

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

    printf("START_TEST:\n");
    printf("    la x2, test_result\n");
    printf("    li x1, 0\n");
    printf("    sw x1, 0(x2)\n");
    printf("\n");

    int iter = 100;
    if (argc > 1) iter = atoi(argv[1]);
    if (argc > 2) {
        // Randomize
        int seed = time(NULL);
        srand(seed);
    }

    int test = 0;
//    while (test < iter) {
//        do_orn(++test);
//    }
    while (test < iter) {
        do_andn(++test);
        do_orn(++test);
        do_xnor(++test);

//        do_slo(++test);
//        do_sro(++test);
        do_rol(++test);
        do_ror(++test);

        //do_bclr(++test);
        //do_bset(++test);
        //do_binv(++test);
        //do_bext(++test);
        // gorc
        do_grev(++test);

//        do_sloi(++test);
//        do_sroi(++test);
        do_rori(++test);

        //do_bclri(++test);
        //do_bseti(++test);
        //do_binvi(++test);
//        do_bexti(++test);
        // gorci
        do_grevi(++test);

        do_cmix(++test);
        do_cmov(++test);
        do_fsl(++test);
        do_fsr(++test);
        do_fsri(++test);

        do_clz(++test);
        do_ctz(++test);
//        do_cpop(++test);
        do_sextb(++test);
        do_sexth(++test);
#if (XLEN==64)
        do_bmatflip(++test);
#endif

        do_crc32_b(++test);
        do_crc32_h(++test);
        do_crc32_w(++test);
#if (XLEN==64)
        do_crc32_d(++test);
#endif
        do_crc32c_b(++test);
        do_crc32c_h(++test);
        do_crc32c_w(++test);
#if (XLEN==64)
        do_crc32c_d(++test);
#endif

        do_clmul(++test);
        do_clmulr(++test);
        do_clmulh(++test);
        do_min(++test);
        do_max(++test);
        do_minu(++test);
        do_maxu(++test);

        do_shfl(++test);
        do_unshfl(++test);
        //do_bdecompress(++test);
        //do_bcompress(++test);
        do_pack(++test);
        do_packu(++test);
#if (XLEN==64)
        do_bmator(++test);
        do_bmatxor(++test);
#endif
        do_packh(++test);
        do_bfp(++test);

        do_shfli(++test);
        do_unshfli(++test);

#if (XLEN==64)
        // slliuw

//        do_adduw(++test);

//        do_slow(++test);
//        do_srow(++test);
        do_rolw(++test);
        do_rorw(++test);


        //do_bclrw(++test);
        //do_bsetw(++test);
        //do_binvw(++test);
        //do_bextw(++test);
        // gorcw
        do_grevw(++test);

//        do_sloiw(++test);
//        do_sroiw(++test);
        do_roriw(++test);

        //do_bclriw(++test);
        //do_bsetiw(++test);
        //do_binviw(++test);
        // gorciw
        // greviw

        do_fslw(++test);
        do_fsrw(++test);
        do_fsriw(++test);

        do_clzw(++test);
        do_ctzw(++test);
//        do_cpopw(++test);

//        do_clmulw(++test);
//        do_clmulrw(++test);
//        do_clmulhw(++test);

        do_shflw(++test);
        do_unshflw(++test);
        //do_bdecompressw(++test);
        //do_bcompressw(++test);
        do_packw(++test);
        do_packuw(++test);
        do_bfpw(++test);
#endif
    }

    printf("test_complete:\n");
    printf("    la x2, test_pass\n");
    printf("    jr x2\n");
    printf("\n");

    printf(".align 4\n");
    printf("test_result:\n");
    printf("    .fill 1, 4, -1\n");
    printf("str_Test_Pass:\n");
    printf("    .string \"Test Pass\"\n");
    printf("str_Test_Fail:\n");
    printf("    .string \"Test Fail\"\n");

    return 0;
}

