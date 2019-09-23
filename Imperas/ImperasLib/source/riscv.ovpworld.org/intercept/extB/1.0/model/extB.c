/*
 * Copyright (c) 2005-2019 Imperas Software Ltd., www.imperas.com
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *   http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND,
 * either express or implied.
 *
 * See the License for the specific language governing permissions and
 * limitations under the License.
 *
 */

// standard includes
#include <stdio.h>

#include "hostapi/typeMacros.h"

// VMI area includes
#include "vmi/vmiCxt.h"
#include "vmi/vmiDbg.h"
#include "vmi/vmiDecode.h"
#include "vmi/vmiMessage.h"
#include "vmi/vmiMt.h"
#include "vmi/vmiOSAttrs.h"
#include "vmi/vmiOSLib.h"
#include "vmi/vmiDoc.h"
#include "vmi/vmiRt.h"
#include "vmi/vmiVersion.h"

#define MT_CALLBACK 1

#define CPU_PREFIX "Bit Manipulation"

#define EXTB_REVISION "extB Version(0.91) August 29 2019"

#define RISCV_GPR_NUM  32
#define RV_MAX_AREGS   4

typedef Uns64 riscvAddr;

static const char *map[32] = {
    [0]  = "zero", [1]  = "ra",  [2]  = "sp",  [3]  = "gp",
    [4]  = "tp",   [5]  = "t0",  [6]  = "t1",  [7]  = "t2",
    [8]  = "s0",   [9]  = "s1",  [10] = "a0",  [11] = "a1",
    [12] = "a2",   [13] = "a3",  [14] = "a4",  [15] = "a5",
    [16] = "a6",   [17] = "a7",  [18] = "s2",  [19] = "s3",
    [20] = "s4",   [21] = "s5",  [22] = "s6",  [23] = "s7",
    [24] = "s8",   [25] = "s9",  [26] = "s10", [27] = "s11",
    [28] = "t3",   [29] = "t4",  [30] = "t5",  [31] = "t6",
};

//
// Field extraction macros
//
#define WIDTH(_W, _ARG) ((_ARG) & ((1<<(_W))-1))
#define RD(_I)    WIDTH(5,(_I)>>7)
#define RDp(_I)   WIDTH(3,(_I)>>7) | 0x8
#define RS1(_I)   WIDTH(5,(_I)>>15)
#define RS2(_I)   WIDTH(5,(_I)>>20)
#define RS3(_I)   WIDTH(5,(_I)>>27) // TBD
#define CU5(_I)   WIDTH(5,(_I)>>20)
#define CU6(_I)   WIDTH(6,(_I)>>20)
#define CU7(_I)   WIDTH(7,(_I)>>20)
#define CU12(_I)  WIDTH(12,(_I)>>20)

DEFINE_S (riscv);

////////////////////////////////////////////////////////////////////////////////
// TYPES
////////////////////////////////////////////////////////////////////////////////

//
// Supported Bit Manipulation Architecture variants
//
typedef enum extbVerE {
    RVB_0_90,                  // version 0.90
    RVB_0_91,                  // version 0.91
    RVB_LAST,                  // for sizing

    RVB_DEFAULT = RVB_0_91,    // default version
} extbVer;

typedef struct vmiosObjectS {

    Bool enable;

    // handles for the RISCV GPRs/SPRs
    vmiRegInfoCP gprCP[RISCV_GPR_NUM];
    vmiRegInfoCP misaCP;

    // SPR
    Uns64 misa;

    // 32-bit temporaries
    Uns64  rs1, rs2, rs3, rd, tmp1, tmp2;
    vmiReg reg_rd, reg_rs1, reg_rs2, reg_rs3, reg_tmp1, reg_tmp2;

    Uns64  t0;
    vmiReg reg_t0;

    Uns32 cu5, cu6, cu7, cu12;

    Uns32 xlen;

    // enhanced instruction decode table
//    vmidDecodeTableP table16;
    vmidDecodeTableP table32;

    struct {
        extbVer version;
    } params;

} vmiosObject;

///////////////////// Formal Parameter Variables structure /////////////////////

static vmiEnumParameter extbVersions[RVB_LAST+1] = {
    [RVB_0_90] = {
        .name        = "0.90",
        .value       = RVB_0_90,
        .description = "Bit Manipulation Architecture Version v0.90-20190610",
    },
    [RVB_0_91] = {
        .name        = "0.91",
        .value       = RVB_0_91,
        .description = "Bit Manipulation Architecture Version v0.91-20190829",
    },

    // KEEP LAST: terminator
    {0}
};

// Define the attributes value structure
typedef struct paramValuesS {
    VMI_ENUM_PARAM(version);
} paramValues, *paramValuesP;

//
// Define formals
//
static vmiParameter parameters[] = {
    VMI_ENUM_PARAM_SPEC_WITH_DEFAULT(paramValues, version, extbVersions, &extbVersions[RVB_0_91], "Specify required Bit Manipulation version"),
    VMI_END_PARAM
};

//
// Iterate formals
//
static VMIOS_PARAM_SPEC_FN(getParamSpecs) {
    if(!prev) {
        prev = parameters;
    } else {
        prev++;
    }
    return prev->name ? prev : 0;
}

//
// Return size of parameter structure
//
static VMIOS_PARAM_TABLE_SIZE_FN(getParamTableSize) {
    return sizeof(paramValues);
}

//
// Return Vector Extension version
//
inline static extbVer extbVersion(vmiosObjectP object) {
    return object->params.version;
}

////////////////////////////////////////////////////////////////////////////////
// ENHANCED DECODER
////////////////////////////////////////////////////////////////////////////////

//
// This macro adds a decode table entry for a specific instruction class
//
#define DECODE_ENTRY(_PRIORITY, _NAME, _FMT) \
    vmidNewEntryFmtBin(     \
        table,              \
        #_NAME,             \
        EXTB_##_NAME,       \
        _FMT,               \
        _PRIORITY           \
    )

typedef enum riscvITypeB {
    EXTB_ANDN,
    EXTB_ORN,
    EXTB_XNOR,

    EXTB_SLO,
    EXTB_SRO,
    EXTB_ROL,
    EXTB_ROR,

    EXTB_SBCLR,
    EXTB_SBSET,
    EXTB_SBINV,
    EXTB_SBEXT,
    EXTB_GORC,
    EXTB_GREV,

    EXTB_SLOI,
    EXTB_SROI,
    EXTB_RORI,

    EXTB_SBCLRI,
    EXTB_SBSETI,
    EXTB_SBINVI,
    EXTB_SBEXTI,
    EXTB_GORCI,
    EXTB_GREVI,

    EXTB_CMIX,
    EXTB_CMOV,
    EXTB_FSL,
    EXTB_FSR,
    EXTB_FSRI,

    EXTB_CLZ,
    EXTB_CTZ,
    EXTB_PCNT,
    EXTB_BMATFLIP,

    EXTB_CRC32_B,
    EXTB_CRC32_H,
    EXTB_CRC32_W,
    EXTB_CRC32_D,
    EXTB_CRC32C_B,
    EXTB_CRC32C_H,
    EXTB_CRC32C_W,
    EXTB_CRC32C_D,

    EXTB_CLMUL,
    EXTB_CLMULR,
    EXTB_CLMULH,
    EXTB_MIN,
    EXTB_MAX,
    EXTB_MINU,
    EXTB_MAXU,

    EXTB_SHFL,
    EXTB_UNSHFL,
    EXTB_BDEP,
    EXTB_BEXT,
    EXTB_PACK,
    EXTB_BMATOR,
    EXTB_BMATXOR,
    EXTB_BFP,

    EXTB_SHFLI,
    EXTB_UNSHFLI,

    EXTB_ADDIWU,
    EXTB_SLLIU_W,

    EXTB_ADDWU,
    EXTB_SUBWU,
    EXTB_ADDU_W,
    EXTB_SUBU_W,

    EXTB_SLOW,
    EXTB_SROW,
    EXTB_ROLW,
    EXTB_RORW,

    EXTB_SBCLRW,
    EXTB_SBSETW,
    EXTB_SBINVW,
    EXTB_SBEXTW,
    EXTB_GORCW,
    EXTB_GREVW,

    EXTB_SLOIW,
    EXTB_SROIW,
    EXTB_RORIW,

    EXTB_SBCLRIW,
    EXTB_SBSETIW,
    EXTB_SBINVIW,
    EXTB_GORCIW,
    EXTB_GREVIW,

    EXTB_FSLW,
    EXTB_FSRW,
    EXTB_FSRIW,

    EXTB_CLZW,
    EXTB_CTZW,
    EXTB_PCNTW,

    EXTB_CLMULW,
    EXTB_CLMULRW,
    EXTB_CLMULHW,

    EXTB_SHFLW,
    EXTB_UNSHFLW,
    EXTB_BDEPW,
    EXTB_BEXTW,
    EXTB_PACKW,
    EXTB_BFPW,

    // KEEP LAST: for sizing the array
    EXTB_LAST

} riscvITypeB;

//
// Structure defining one 32-bit decode table entry
//
typedef struct decodeEntry32S {
    riscvITypeB  type;      // entry type
    const char  *name;      // decode name
    const char  *pattern;   // decode pattern
    Int32        priority;  // decode priority
} decodeEntry32;

//
// Opaque type pointer to decodeEntry32
//
DEFINE_CS(decodeEntry32);

//
// Create one entry in decodeEntries32 table
//
#define DECODE32_ENTRY(_PRIORITY, _NAME, _PATTERN) { \
    type     : EXTB_##_NAME, \
    name     : #_NAME,       \
    pattern  : _PATTERN,     \
    priority : _PRIORITY     \
}

//    |  3                   2                   1                    |
//    |1 0 9 8 7 6 5 4 3 2 1 0 9 8 7 6 5 4 3 2 1 0 9 8 7 6 5 4 3 2 1 0|
//    |---------------------------------------------------------------|
//    |    funct7   |   rs2   |   rs1   |  f3 |    rd   |    opcode   |  R-type
//    |   rs3   | f2|   rs2   |   rs1   |  f3 |    rd   |    opcode   |  R4-type
//    |          imm          |   rs1   |  f3 |    rd   |    opcode   |  I-type
//    |---------------------------------------------------------------|

const static decodeEntry32 decodeCommon32[] = {
    DECODE32_ENTRY(0, ANDN,     "|0100000|.....|.....|111|.....|0110011|"),  // R-type
    DECODE32_ENTRY(0, ORN,      "|0100000|.....|.....|110|.....|0110011|"),  // R-type
    DECODE32_ENTRY(0, XNOR,     "|0100000|.....|.....|100|.....|0110011|"),  // R-type

    DECODE32_ENTRY(0, SLO,      "|0010000|.....|.....|001|.....|0110011|"),  // R-type
    DECODE32_ENTRY(0, SRO,      "|0010000|.....|.....|101|.....|0110011|"),  // R-type
    DECODE32_ENTRY(0, ROL,      "|0110000|.....|.....|001|.....|0110011|"),  // R-type
    DECODE32_ENTRY(0, ROR,      "|0110000|.....|.....|101|.....|0110011|"),  // R-type

    DECODE32_ENTRY(0, SBCLR,    "|0100100|.....|.....|001|.....|0110011|"),  // R-type
    DECODE32_ENTRY(0, SBSET,    "|0010100|.....|.....|001|.....|0110011|"),  // R-type
    DECODE32_ENTRY(0, SBINV,    "|0110100|.....|.....|001|.....|0110011|"),  // R-type
    DECODE32_ENTRY(0, SBEXT,    "|0100100|.....|.....|101|.....|0110011|"),  // R-type

    DECODE32_ENTRY(0, SLOI,     "|00100|.......|.....|001|.....|0010011|"),  // I-type
    DECODE32_ENTRY(0, SROI,     "|00100|0......|.....|101|.....|0010011|"),  // I-type (force RV32/64 to overcome overlap with FSRI)
    // Error (DEC_DTEC) vmidDecode: decode table entry conflict (specify different priorities if both entries are required)
    // Error (DEC_DTEC1)     SROI       mask : 0xf800707f pattern : 0x20005013)
    // Error (DEC_DTEC2)     FSRI       mask : 0x0400707f pattern : 0x04005013)
    DECODE32_ENTRY(0, RORI,     "|01100|0......|.....|101|.....|0010011|"),  // I-type (force RV32/64 to overcome overlap with FSRI)
    // Error (DEC_DTEC) vmidDecode: decode table entry conflict (specify different priorities if both entries are required)
    // Error (DEC_DTEC1)     RORI       mask : 0xf800707f pattern : 0x60005013)
    // Error (DEC_DTEC2)     FSRI       mask : 0x0400707f pattern : 0x04005013)


    DECODE32_ENTRY(0, SBCLRI,   "|01001|.......|.....|001|.....|0010011|"),  // I-type
    DECODE32_ENTRY(0, SBSETI,   "|00101|.......|.....|001|.....|0010011|"),  // I-type
    DECODE32_ENTRY(0, SBINVI,   "|01101|.......|.....|001|.....|0010011|"),  // I-type
    DECODE32_ENTRY(0, SBEXTI,   "|01001|0......|.....|101|.....|0010011|"),  // I-type (force RV32/64 to overcome overlap with FSRI)
    // Error (DEC_DTEC) vmidDecode: decode table entry conflict (specify different priorities if both entries are required)
    // Error (DEC_DTEC1)     SBEXTI     mask : 0xf800707f pattern : 0x48005013)
    // Error (DEC_DTEC2)     FSRI       mask : 0x0400707f pattern : 0x04005013)

    DECODE32_ENTRY(0, CMIX,     "|.....11|.....|.....|001|.....|0110011|"), // R4-type
    DECODE32_ENTRY(0, CMOV,     "|.....11|.....|.....|101|.....|0110011|"), // R4-type
    DECODE32_ENTRY(0, FSL,      "|.....10|.....|.....|001|.....|0110011|"), // R4-type
    DECODE32_ENTRY(0, FSR,      "|.....10|.....|.....|101|.....|0110011|"), // R4-type
    DECODE32_ENTRY(0, FSRI,     "|.....1.|.....|.....|101|.....|0010011|"), // R4-type

    DECODE32_ENTRY(0, CLZ,      "|0110000|00000|.....|001|.....|0010011|"),  // R-type
    DECODE32_ENTRY(0, CTZ,      "|0110000|00001|.....|001|.....|0010011|"),  // R-type
    DECODE32_ENTRY(0, PCNT,     "|0110000|00010|.....|001|.....|0010011|"),  // R-type
    DECODE32_ENTRY(0, BMATFLIP, "|0110000|00011|.....|001|.....|0010011|"),  // R-type

    DECODE32_ENTRY(0, CRC32_B,  "|0110000|10000|.....|001|.....|0010011|"),  // R-type
    DECODE32_ENTRY(0, CRC32_H,  "|0110000|10001|.....|001|.....|0010011|"),  // R-type
    DECODE32_ENTRY(0, CRC32_W,  "|0110000|10010|.....|001|.....|0010011|"),  // R-type
    DECODE32_ENTRY(0, CRC32_D,  "|0110000|10011|.....|001|.....|0010011|"),  // R-type
    DECODE32_ENTRY(0, CRC32C_B, "|0110000|11000|.....|001|.....|0010011|"),  // R-type
    DECODE32_ENTRY(0, CRC32C_H, "|0110000|11001|.....|001|.....|0010011|"),  // R-type
    DECODE32_ENTRY(0, CRC32C_W, "|0110000|11010|.....|001|.....|0010011|"),  // R-type
    DECODE32_ENTRY(0, CRC32C_D, "|0110000|11011|.....|001|.....|0010011|"),  // R-type

    DECODE32_ENTRY(0, CLMUL,    "|0000101|.....|.....|001|.....|0110011|"),  // R-type
    DECODE32_ENTRY(0, CLMULR,   "|0000101|.....|.....|010|.....|0110011|"),  // R-type
    DECODE32_ENTRY(0, CLMULH,   "|0000101|.....|.....|011|.....|0110011|"),  // R-type
    DECODE32_ENTRY(0, MIN,      "|0000101|.....|.....|100|.....|0110011|"),  // R-type
    DECODE32_ENTRY(0, MAX,      "|0000101|.....|.....|101|.....|0110011|"),  // R-type
    DECODE32_ENTRY(0, MINU,     "|0000101|.....|.....|110|.....|0110011|"),  // R-type
    DECODE32_ENTRY(0, MAXU,     "|0000101|.....|.....|111|.....|0110011|"),  // R-type

    DECODE32_ENTRY(0, SHFL,     "|0000100|.....|.....|001|.....|0110011|"),  // R-type
    DECODE32_ENTRY(0, UNSHFL,   "|0000100|.....|.....|101|.....|0110011|"),  // R-type
    DECODE32_ENTRY(0, BDEP,     "|0000100|.....|.....|010|.....|0110011|"),  // R-type
    DECODE32_ENTRY(0, BEXT,     "|0000100|.....|.....|110|.....|0110011|"),  // R-type
    DECODE32_ENTRY(0, PACK,     "|0000100|.....|.....|100|.....|0110011|"),  // R-type
    DECODE32_ENTRY(0, BMATOR,   "|0000100|.....|.....|011|.....|0110011|"),  // R-type

    DECODE32_ENTRY(0, SHFLI,    "|000010|......|.....|001|.....|0010011|"),  // I-type
    DECODE32_ENTRY(0, UNSHFLI,  "|000010|......|.....|101|.....|0010011|"),  // I-type

    DECODE32_ENTRY(0, ADDIWU,   "|............|.....|100|.....|0011011|"),  // I-type
    DECODE32_ENTRY(0, SLLIU_W,  "|00001|.......|.....|001|.....|0011011|"),  // I-type

    DECODE32_ENTRY(0, ADDWU,    "|0000101|.....|.....|000|.....|0111011|"),  // R-type
    DECODE32_ENTRY(0, SUBWU,    "|0100101|.....|.....|000|.....|0111011|"),  // R-type
    DECODE32_ENTRY(0, ADDU_W,   "|0000100|.....|.....|000|.....|0111011|"),  // R-type
    DECODE32_ENTRY(0, SUBU_W,   "|0100100|.....|.....|000|.....|0111011|"),  // R-type

    DECODE32_ENTRY(0, SLOW,     "|0010000|.....|.....|001|.....|0111011|"),  // R-type
    DECODE32_ENTRY(0, SROW,     "|0010000|.....|.....|101|.....|0111011|"),  // R-type
    DECODE32_ENTRY(0, ROLW,     "|0110000|.....|.....|001|.....|0111011|"),  // R-type
    DECODE32_ENTRY(0, RORW,     "|0110000|.....|.....|101|.....|0111011|"),  // R-type

    DECODE32_ENTRY(0, SBCLRW,   "|0100100|.....|.....|001|.....|0111011|"),  // R-type
    DECODE32_ENTRY(0, SBSETW,   "|0010100|.....|.....|001|.....|0111011|"),  // R-type
    DECODE32_ENTRY(0, SBINVW,   "|0110100|.....|.....|001|.....|0111011|"),  // R-type
    DECODE32_ENTRY(0, SBEXTW,   "|0100100|.....|.....|101|.....|0111011|"),  // R-type

    DECODE32_ENTRY(0, SLOIW,    "|0010000|.....|.....|001|.....|0011011|"),  // R-type
    DECODE32_ENTRY(0, SROIW,    "|0010000|.....|.....|101|.....|0011011|"),  // R-type
    DECODE32_ENTRY(0, RORIW,    "|0110000|.....|.....|101|.....|0011011|"),  // R-type

    DECODE32_ENTRY(0, SBCLRIW,  "|0100100|.....|.....|001|.....|0011011|"),  // R-type
    DECODE32_ENTRY(0, SBSETIW,  "|0010100|.....|.....|001|.....|0011011|"),  // R-type
    DECODE32_ENTRY(0, SBINVIW,  "|0110100|.....|.....|001|.....|0011011|"),  // R-type

    DECODE32_ENTRY(0, FSLW,     "|.....10|.....|.....|001|.....|0111011|"), // R4-type
    DECODE32_ENTRY(0, FSRW,     "|.....10|.....|.....|101|.....|0111011|"), // R4-type
    DECODE32_ENTRY(0, FSRIW,    "|.....10|.....|.....|101|.....|0011011|"), // R4-type

    DECODE32_ENTRY(0, CLZW,     "|0110000|00000|.....|001|.....|0011011|"),  // R-type
    DECODE32_ENTRY(0, CTZW,     "|0110000|00001|.....|001|.....|0011011|"),  // R-type
    DECODE32_ENTRY(0, PCNTW,    "|0110000|00010|.....|001|.....|0011011|"),  // R-type

    DECODE32_ENTRY(0, CLMULW,   "|0000101|.....|.....|001|.....|0111011|"),  // R-type
    DECODE32_ENTRY(0, CLMULRW,  "|0000101|.....|.....|010|.....|0111011|"),  // R-type
    DECODE32_ENTRY(0, CLMULHW,  "|0000101|.....|.....|011|.....|0111011|"),  // R-type

    DECODE32_ENTRY(0, SHFLW,    "|0000100|.....|.....|001|.....|0111011|"),  // R-type
    DECODE32_ENTRY(0, UNSHFLW,  "|0000100|.....|.....|101|.....|0111011|"),  // R-type
    DECODE32_ENTRY(0, BDEPW,    "|0000100|.....|.....|010|.....|0111011|"),  // R-type
    DECODE32_ENTRY(0, BEXTW,    "|0000100|.....|.....|110|.....|0111011|"),  // R-type
    DECODE32_ENTRY(0, PACKW,    "|0000100|.....|.....|100|.....|0111011|"),  // R-type

    // table termination entry
    {0}
};

const static decodeEntry32 decode32_0_90[] = {
    DECODE32_ENTRY(0, GREV,     "|0100000|.....|.....|001|.....|0110011|"),  // R-type **PARAM** v0.90
    DECODE32_ENTRY(0, GREVI,    "|01000|.......|.....|001|.....|0010011|"),  // I-type **PARAM** v0.90
    DECODE32_ENTRY(0, BMATXOR,  "|0000100|.....|.....|111|.....|0110011|"),  // R-type **PARAM** v0.90
    DECODE32_ENTRY(0, GREVW,    "|0100000|.....|.....|001|.....|0111011|"),  // R-type **PARAM** v0.90
    DECODE32_ENTRY(0, GREVIW,   "|0100000|.....|.....|001|.....|0011011|"),  // R-type **PARAM** v0.90

    // table termination entry
    {0}
};

const static decodeEntry32 decode32_0_91[] = {
    DECODE32_ENTRY(0, GORC,     "|0010100|.....|.....|101|.....|0110011|"),  // R-type **PARAM** v0.91
    DECODE32_ENTRY(0, GREV,     "|0110100|.....|.....|101|.....|0110011|"),  // R-type **PARAM** v0.91
    DECODE32_ENTRY(0, GORCI,    "|00101|0......|.....|101|.....|0010011|"),  // I-type (force RV32/64 to overcome overlap with FSRI) **PARAM** v0.91
    //    Error (DEC_DTEC) vmidDecode: decode table entry conflict (specify different priorities if both entries are required)
    //    Error (DEC_DTEC1)     GORCI      mask : 0xf800707f pattern : 0x28005013)
    //    Error (DEC_DTEC2)     FSRI       mask : 0x0400707f pattern : 0x04005013)
    DECODE32_ENTRY(0, GREVI,    "|01101|0......|.....|101|.....|0010011|"),  // I-type (force RV32/64 to overcome overlap with FSRI) **PARAM** v0.91
    //    Error (DEC_DTEC) vmidDecode: decode table entry conflict (specify different priorities if both entries are required)
    //    Error (DEC_DTEC1)     GREVI      mask : 0xf800707f pattern : 0x68005013)
    //    Error (DEC_DTEC2)     FSRI       mask : 0x0400707f pattern : 0x04005013)
    DECODE32_ENTRY(0, BMATXOR,  "|0100100|.....|.....|011|.....|0110011|"),  // R-type **PARAM** v0.91
    DECODE32_ENTRY(0, BFP,      "|0000100|.....|.....|111|.....|0110011|"),  // R-type **PARAM** v0.91
    DECODE32_ENTRY(0, GORCW,    "|0010100|.....|.....|101|.....|0111011|"),  // R-type **PARAM** v0.91
    DECODE32_ENTRY(0, GREVW,    "|0110100|.....|.....|101|.....|0111011|"),  // R-type **PARAM** v0.91
    DECODE32_ENTRY(0, GORCIW,   "|0010100|.....|.....|101|.....|0011011|"),  // R-type **PARAM** v0.91
    DECODE32_ENTRY(0, GREVIW,   "|0110100|.....|.....|101|.....|0011011|"),  // R-type **PARAM** v0.91
    DECODE32_ENTRY(0, BFPW,     "|0000100|.....|.....|111|.....|0111011|"),  // R-type **PARAM** v0.91

    // table termination entry
    {0}
};

//
// Insert 32-bit instruction decode table entries from the given decode table
//
static void insertEntries32(vmidDecodeTableP table, decodeEntry32CP decEntries) {

    decodeEntry32CP decEntry;

    for(decEntry=decEntries; decEntry->pattern; decEntry++) {
        vmidNewEntryFmtBin(
            table,
            decEntry->name,
            decEntry->type,
            decEntry->pattern,
            decEntry->priority
        );
    }
}

static vmidDecodeTableP createDecodeTable32(vmiosObjectP  object) {
    vmidDecodeTableP table = vmidNewDecodeTable(32, EXTB_LAST);

    // insert common 32-bit decode table entries
    insertEntries32(table, &decodeCommon32[0]);

    extbVer version = extbVersion(object);

    // insert vector-extension-dependent 32-bit decode table entries
    if (version==RVB_0_90) {
        insertEntries32(table, &decode32_0_90[0]);

    } else if (version==RVB_0_91) {
        insertEntries32(table, &decode32_0_91[0]);
    }

    return table;
}

//
// Decode an extended instruction at the indicated address, or return
// EXTB_LAST if this is not an extended B instruction.
//
static riscvITypeB getInstrType(
    vmiosObjectP  object,
    vmiProcessorP processor,
    Addr          thisPC,
    Uns32        *instruction,
    Uns32        *bytes
) {

    Uns16 quadrant = vmicxtFetch2Byte(processor, thisPC);
    Bool  is16bit  = ((quadrant & 0x3) != 0x3);
    Bool  is32bit  = ((quadrant & 0x3) == 0x3);

    riscvITypeB type  = EXTB_LAST;

    *instruction = 0;
    *bytes = 0;

    if (is32bit) {
        *instruction = vmicxtFetch4Byte(processor, thisPC);
        *bytes = 4;
        type = vmidDecode(object->table32, *instruction);

    } else if (is16bit) {
        *instruction = vmicxtFetch2Byte(processor, thisPC);
        *bytes = 2;
//        type = vmidDecode(object->table16, *instruction);
        type = EXTB_LAST;

    } else {
        type = EXTB_LAST;
    }

    return type;
}

////////////////////////////////////////////////////////////////////////////////
// CONSTRUCTOR
////////////////////////////////////////////////////////////////////////////////

//
// Constructor
//
static VMIOS_CONSTRUCTOR_FN(constructor) {
    //
    // Determine the XLEN & MISA.B
    //
    object->misaCP = vmiosGetRegDesc(processor, "misa");
    vmiosRegRead(processor, object->misaCP, &(object->misa));

    object->enable = (object->misa >> 1) & 0x1;

    if (object->enable) {
        vmiMessage("I", CPU_PREFIX, "%s", EXTB_REVISION);
        vmiMessage("I", CPU_PREFIX, "These RISC-V Bitmanip instructions are a work in progress\n");
        vmiMessage("I", CPU_PREFIX, "These instructions and their specification may change before being accepted as\n");
        vmiMessage("I", CPU_PREFIX, "a standard by the RISC-V Foundation and so it is highly likely that implementations\n");
        vmiMessage("I", CPU_PREFIX, "made using this draft specification will not conform to the future standard.\n");
    }

    //
    // Version of Bit Manipulation spec
    //
    paramValuesP params = parameterValues;
    object->params.version = params->version;

    //
    // Are we connected to a 32, 64 or 128 bit processor
    //
    object->xlen = 0;
    Uns8 mxl = (object->misa >> 30) & 0x3;
    if (mxl == 0) {
        // Must be in the 64 bit position
        mxl = (object->misa >> 62);
    }
    if (mxl == 1) {
        object->xlen = 32;
    } else if (mxl == 2) {
        object->xlen = 64;
    } else {
        vmiMessage("F", CPU_PREFIX, "MISA register error = " FMT_640Nx , object->misa); // LCOV_EXCL_LINE
    }

    // get handles to the RISCV GPRs
    Uns32 i;
    for(i=0; i<RISCV_GPR_NUM; i++) {
        object->gprCP[i] = vmiosGetRegDesc(processor, map[i]);
    }

    // create enhanced instruction decoder
//    object->table16 = createDecodeTable16();

//    object->table32 = createDecodeTable32(object);
//    if (object->params.version == 0) {
//
//    }
    object->table32 = createDecodeTable32(object);
}

////////////////////////////////////////////////////////////////////////////////
// IMPLEMENTATION OF INSTRUCTION
////////////////////////////////////////////////////////////////////////////////
typedef enum bitmaskRegE {
    BM_RS1  = 0x01,
    BM_RS2  = 0x02,
    BM_RS3  = 0x04,
    BM_TMP1 = 0x10,
    BM_TMP2 = 0x20,
    BM_COMP = 0x40,     // Compressed Instruction Format

    BM_RR   = BM_RS1 | BM_RS2,
    BM_RRR  = BM_RR  | BM_RS3
} bitmaskReg;

static void regProlog (
    vmiProcessorP processor,
    vmiosObjectP  object,
    Uns32         instruction,
    bitmaskReg    mask
) {
    if (mask & BM_COMP) {
        object->rd  = RDp(instruction);
        object->rs1 = RDp(instruction);
        object->rs2 = RDp(instruction);
    } else {
        object->rd  = RD(instruction);
        object->rs1 = RS1(instruction);
        object->rs2 = RS2(instruction);
    }
    object->rs3  = RS3(instruction);
    object->t0   = 5;
    object->cu5  = CU5(instruction);
    object->cu6  = CU6(instruction);
    object->cu7  = CU7(instruction);
    object->cu12 = CU12(instruction);

    object->reg_rs1  = vmimtGetExtReg(processor,  &object->rs1);
    object->reg_rs2  = vmimtGetExtReg(processor,  &object->rs2);
    object->reg_rd   = vmimtGetExtReg(processor,  &object->rd);
    object->reg_tmp1 = vmimtGetExtTemp(processor, &object->tmp1);
    object->reg_tmp2 = vmimtGetExtTemp(processor, &object->tmp2);

    if ((mask & BM_RRR) == BM_RRR) {
        object->reg_rs3  = vmimtGetExtReg(processor, &object->rs3);
        object->reg_t0   = vmimtGetExtReg(processor, &object->t0);
    }

    vmimtGetR(processor, object->xlen, object->reg_rd,  object->gprCP[object->rd]);
    vmimtGetR(processor, object->xlen, object->reg_rs1, object->gprCP[object->rs1]);
    vmimtGetR(processor, object->xlen, object->reg_rs2, object->gprCP[object->rs2]);
    vmimtGetR(processor, object->xlen, object->reg_rs3, object->gprCP[object->rs3]);
    vmimtGetR(processor, object->xlen, object->reg_t0,  object->gprCP[object->t0]);
}

static void regEpilog (
    vmiProcessorP processor,
    vmiosObjectP  object,
    Uns32         instruction
) {
    vmimtSetR(processor, object->xlen, object->gprCP[object->rd], object->reg_rd);
}

//
// Begin morph code routines
//

#define EXTB_MORPH_FN(_NAME)      \
    static void _NAME(            \
        vmiProcessorP processor,  \
        vmiosObjectP  object,     \
        Uns32         instruction \
    )

EXTB_MORPH_FN(emitCLZ) {
    regProlog(processor, object, instruction, BM_RR);
    vmimtUnopRR(object->xlen, vmi_CLZ, object->reg_rd, object->reg_rs1, 0);
    regEpilog(processor, object, instruction);
}
EXTB_MORPH_FN(emitCLZW) {
    regProlog(processor, object, instruction, BM_RR);
    vmimtUnopRR(32, vmi_CLZ, object->reg_rd, object->reg_rs1, 0);
    vmimtMoveExtendRR(object->xlen, object->reg_rd, 32, object->reg_rd, 0);
    regEpilog(processor, object, instruction);
}

EXTB_MORPH_FN(emitCTZ) {
    regProlog(processor, object, instruction, BM_RR);
    vmimtUnopRR(object->xlen, vmi_CTZ, object->reg_rd, object->reg_rs1, 0);
    regEpilog(processor, object, instruction);
}
EXTB_MORPH_FN(emitCTZW) {
    regProlog(processor, object, instruction, BM_RR);
    vmimtUnopRR(32, vmi_CTZ, object->reg_rd, object->reg_rs1, 0);
    vmimtMoveExtendRR(object->xlen, object->reg_rd, 32, object->reg_rd, 0);
    regEpilog(processor, object, instruction);
}

EXTB_MORPH_FN(emitPCNT) {
    regProlog(processor, object, instruction, BM_RR);
    vmimtUnopRR(object->xlen, vmi_CNTO, object->reg_rd, object->reg_rs1, 0);
    regEpilog(processor, object, instruction);
}
EXTB_MORPH_FN(emitPCNTW) {
    regProlog(processor, object, instruction, BM_RR);
    vmimtUnopRR(32, vmi_CNTO, object->reg_rd, object->reg_rs1, 0);
    vmimtMoveExtendRR(object->xlen, object->reg_rd, 32, object->reg_rd, 0);
    regEpilog(processor, object, instruction);
}

EXTB_MORPH_FN(emitANDN) {
    regProlog(processor, object, instruction, BM_RR);
    vmimtBinopRRR(object->xlen, vmi_ANDN, object->reg_rd, object->reg_rs1, object->reg_rs2, 0);
    regEpilog(processor, object, instruction);
}

EXTB_MORPH_FN(emitORN) {
    regProlog(processor, object, instruction, BM_RR);
    vmimtBinopRRR(object->xlen, vmi_ORN, object->reg_rd, object->reg_rs1, object->reg_rs2, 0);
    regEpilog(processor, object, instruction);
}

EXTB_MORPH_FN(emitXNOR) {
    regProlog(processor, object, instruction, BM_RR);
    vmimtBinopRRR(object->xlen, vmi_XNOR, object->reg_rd, object->reg_rs1, object->reg_rs2, 0);
    regEpilog(processor, object, instruction);
}

static void commonSB (
    vmiProcessorP processor,
    vmiosObjectP  object,
    Uns32         instruction,
    vmiBitop      op,
    Uns32         word
) {
    regProlog(processor, object, instruction, BM_RR);

    Uns32 result = (word==1) ? 32 : object->xlen;
    Uns32 shift_mask = (result - 1);

    vmimtMoveRC(object->xlen, object->reg_tmp1, 0);

    vmimtMoveRR(result, object->reg_tmp1, object->reg_rs1);
    vmimtBinopRRC(result, vmi_AND, object->reg_tmp2, object->reg_rs2, shift_mask, 0);
    if (op == vmi_BT) {
        // get the 'set' value
        vmimtBitopVR(result, 32, op, object->reg_tmp1, object->reg_tmp2, object->reg_rd);
        vmimtMoveExtendRR(result, object->reg_rd, 8, object->reg_rd, 0);
    } else {
        // get the 'rv' value
        vmimtBitopVR(result, 32, op, object->reg_tmp1, object->reg_tmp2, VMI_NOREG);
        vmimtMoveRR(result, object->reg_rd, object->reg_tmp1);
    }

    if (word) {
        vmimtMoveExtendRR(object->xlen, object->reg_rd, 32, object->reg_rd, 0);
    }

    regEpilog(processor, object, instruction);
}

// rd = rs1 | (1 << (rs2 & (XLEN -1))
EXTB_MORPH_FN(emitSBSET) {
    commonSB(processor, object, instruction, vmi_BTS, 0);
}
EXTB_MORPH_FN(emitSBSETW) {
    commonSB(processor, object, instruction, vmi_BTS, 1);
}

// rd = rs1 & ~(1 << (rs2 & (XLEN -1))
EXTB_MORPH_FN(emitSBCLR) {
    commonSB(processor, object, instruction, vmi_BTR, 0);
}
EXTB_MORPH_FN(emitSBCLRW) {
    commonSB(processor, object, instruction, vmi_BTR, 1);
}

// rd = rs1 ^ (1 << (rs2 & (XLEN -1))
EXTB_MORPH_FN(emitSBINV) {
    commonSB(processor, object, instruction, vmi_BTC, 0);
}
EXTB_MORPH_FN(emitSBINVW) {
    commonSB(processor, object, instruction, vmi_BTC, 1);
}

// rd = 1 & (rs1 >> (rs2 & (XLEN -1))
EXTB_MORPH_FN(emitSBEXT) {
    commonSB(processor, object, instruction, vmi_BT, 0);
}
EXTB_MORPH_FN(emitSBEXTW) {
    commonSB(processor, object, instruction, vmi_BT, 1);
}

static void commonSBI (
    vmiProcessorP processor,
    vmiosObjectP  object,
    Uns32         instruction,
    vmiBitop      op,
    Uns32         word
) {

    regProlog(processor, object, instruction, BM_RR);

    Uns32 result = (word==1) ? 32 : object->xlen;

    vmimtMoveRC(object->xlen, object->reg_tmp1, 0);
    vmimtMoveRR(result, object->reg_tmp1, object->reg_rs1);

    Uns32 shift = object->cu7 & (object->xlen - 1);
    vmimtMoveRC(result, object->reg_tmp2, shift);
    if (op == vmi_BT) {
        // get the 'set' value
        vmimtBitopVR(result, 32, op, object->reg_tmp1, object->reg_tmp2, object->reg_rd);
        vmimtMoveExtendRR(result, object->reg_rd, 8, object->reg_rd, 0);
    } else {
        // get the 'rv' value
        vmimtBitopVR(result, 32, op, object->reg_tmp1, object->reg_tmp2, VMI_NOREG);
        vmimtMoveRR(result, object->reg_rd, object->reg_tmp1);
    }

    if (word) {
        vmimtMoveExtendRR(object->xlen, object->reg_rd, 32, object->reg_rd, 0);
    }

    regEpilog(processor, object, instruction);
}

// rd = rs1 | (1 << (imm & (XLEN -1))
EXTB_MORPH_FN(emitSBSETI) {
    commonSBI(processor, object, instruction, vmi_BTS, 0);
}
EXTB_MORPH_FN(emitSBSETIW) {
    commonSBI(processor, object, instruction, vmi_BTS, 1);
}

// rd = rs1 & ~(1 << (imm & (XLEN -1))
EXTB_MORPH_FN(emitSBCLRI) {
    commonSBI(processor, object, instruction, vmi_BTR, 0);
}
EXTB_MORPH_FN(emitSBCLRIW) {
    commonSBI(processor, object, instruction, vmi_BTR, 1);
}

// rd = rs1 ^ (1 << (imm & (XLEN -1))
EXTB_MORPH_FN(emitSBINVI) {
    commonSBI(processor, object, instruction, vmi_BTC, 0);
}
EXTB_MORPH_FN(emitSBINVIW) {
    commonSBI(processor, object, instruction, vmi_BTC, 1);
}

// rd = 1 & (rs1 >> (imm & (XLEN -1))
EXTB_MORPH_FN(emitSBEXTI) {
    commonSBI(processor, object, instruction, vmi_BT, 0);
}

static Uns32 fsr32_c(Uns32 rs1, Uns32 rs2, Uns32 rs3) {
    Int32 XLEN = 32;
    Int32 shamt = rs2 & (2*XLEN - 1);
    Uns32 A = rs1, B = rs3;
    if (shamt >= XLEN) {
        shamt -= XLEN; A = rs3; B = rs1;
    }
    return shamt ? (A >> shamt) | (B << (XLEN-shamt)) : A;
}

static Uns64 fsr64_c(Uns64 rs1, Uns64 rs2, Uns64 rs3) {
    Int32 XLEN = 64;
    Int32 shamt = rs2 & (2*XLEN - 1);
    Uns64 A = rs1, B = rs3;
    if (shamt >= XLEN) {
        shamt -= XLEN; A = rs3; B = rs1;
    }
    return shamt ? (A >> shamt) | (B << (XLEN-shamt)) : A;
}

static void commonFSRI (
    vmiProcessorP processor,
    vmiosObjectP  object,
    Uns32         instruction,
    Uns32         word
) {
    regProlog(processor, object, instruction, BM_RRR);
    Uns32 result = (word==1) ? 32 : object->xlen;

    vmimtArgReg(result, object->reg_rs1);
    if (result==32) {
        vmimtArgUns32(object->cu6);
    } else {
        vmimtArgUns64(object->cu6);
    }
    vmimtArgReg(result, object->reg_rs3);
    if (object->xlen==32 || word) {
        vmimtCallResult((vmiCallFn)fsr32_c, object->xlen, object->reg_rd);
    } else {
        vmimtCallResult((vmiCallFn)fsr64_c, object->xlen, object->reg_rd);
    }

    if (word) {
        vmimtMoveExtendRR(object->xlen, object->reg_rd, 32, object->reg_rd, 0);
    }

    regEpilog(processor, object, instruction);
}

EXTB_MORPH_FN(emitFSRI) {
    commonFSRI(processor, object, instruction, 0);
}

EXTB_MORPH_FN(emitFSRIW) {
    commonFSRI(processor, object, instruction, 1);
}

// clear rs1 (XLEN-1):32 BEFORE operation
EXTB_MORPH_FN(emitSLLIU_W) {
    regProlog(processor, object, instruction, BM_RR);

    Uns32 shift = object->cu7 & (object->xlen - 1);
    vmimtMoveExtendRR(object->xlen, object->reg_tmp1, 32, object->reg_rs1, 0);
    vmimtBinopRRC(object->xlen, vmi_SHL, object->reg_rd, object->reg_tmp1, shift, 0);

    regEpilog(processor, object, instruction);
}

// clear rs2 (XLEN-1):32 BEFORE operation
EXTB_MORPH_FN(emitADDU_W) {
    regProlog(processor, object, instruction, BM_RR);
    vmimtMoveExtendRR(object->xlen, object->reg_tmp1, 32, object->reg_rs2, 0);
    vmimtBinopRRR(object->xlen, vmi_ADD, object->reg_rd, object->reg_rs1, object->reg_tmp1, 0);
    regEpilog(processor, object, instruction);
}

// clear rs2 (XLEN-1):32 BEFORE operation
EXTB_MORPH_FN(emitSUBU_W) {
    regProlog(processor, object, instruction, BM_RR);
    vmimtMoveExtendRR(object->xlen, object->reg_tmp1, 32, object->reg_rs2, 0);
    vmimtBinopRRR(object->xlen, vmi_SUB, object->reg_rd, object->reg_rs1, object->reg_tmp1, 0);
    regEpilog(processor, object, instruction);
}

EXTB_MORPH_FN(emitADDIWU) {
    regProlog(processor, object, instruction, BM_RR);
    vmimtBinopRRC(32, vmi_ADD, object->reg_rd, object->reg_rs1, object->cu12, 0);
    vmimtMoveExtendRR(object->xlen, object->reg_rd, 32, object->reg_rd, 0);
    regEpilog(processor, object, instruction);
}

// clear (XLEN-1):32 AFTER operation
EXTB_MORPH_FN(emitADDWU) {
    regProlog(processor, object, instruction, BM_RR);
    vmimtBinopRRR(32, vmi_ADD, object->reg_rd, object->reg_rs1, object->reg_rs2, 0);
    vmimtMoveExtendRR(object->xlen, object->reg_rd, 32, object->reg_rd, 0);
    regEpilog(processor, object, instruction);
}

EXTB_MORPH_FN(emitSUBWU) {
    regProlog(processor, object, instruction, BM_RR);
    vmimtBinopRRR(32, vmi_SUB, object->reg_rd, object->reg_rs1, object->reg_rs2, 0);
    vmimtMoveExtendRR(object->xlen, object->reg_rd, 32, object->reg_rd, 0);
    regEpilog(processor, object, instruction);
}

static void commonPACK (
    vmiProcessorP processor,
    vmiosObjectP  object,
    Uns32         instruction,
    Uns32         word
) {
    regProlog(processor, object, instruction, BM_RR);

    Uns32 result = (word==1) ? 32 : object->xlen;

    Uns32 shift = result / 2;
    vmimtMoveRR(result, object->reg_tmp1, object->reg_rs1);
    vmimtBinopRC(result, vmi_SHL, object->reg_tmp1, shift, 0);
    vmimtBinopRC(result, vmi_SHR, object->reg_tmp1, shift, 0);

    vmimtBinopRRC(result, vmi_SHL, object->reg_tmp2, object->reg_rs2, shift, 0);

    vmimtBinopRRR(result, vmi_OR, object->reg_rd, object->reg_tmp1, object->reg_tmp2, 0);

    if (word) {
        vmimtMoveExtendRR(object->xlen, object->reg_rd, 32, object->reg_rd, 0);
    }

    regEpilog(processor, object, instruction);
}

// lower = (rs1 << (XLEN/2) >> XLEN/2
// upper = rs2 << XLEN/2
EXTB_MORPH_FN(emitPACK) {
    commonPACK(processor, object, instruction, 0);
}
EXTB_MORPH_FN(emitPACKW) {
    commonPACK(processor, object, instruction, 1);
}

static void commonSxO(
        vmiProcessorP processor,
        vmiosObjectP  object,
        Uns32         instruction,
        vmiBinop      op,
        Uns32         word) {

    regProlog(processor, object, instruction, BM_RR);

    Uns32 result = (word==1) ? 32 : object->xlen;

    // tmp1 = ~rs1
    vmimtMoveRR(result, object->reg_tmp1, object->reg_rs1);
    vmimtUnopR(result, vmi_NOT, object->reg_tmp1, 0);
    // tmp1 << (rs2 & (XLEN-1))
    vmimtBinopRR(result, op, object->reg_tmp1, object->reg_rs2, 0);
    // rd = ~tmp1
    vmimtUnopR(result, vmi_NOT, object->reg_tmp1, 0);
    vmimtMoveRR(result, object->reg_rd, object->reg_tmp1);

    if (word) {
        vmimtMoveExtendRR(object->xlen, object->reg_rd, 32, object->reg_rd, 0);
    }

    regEpilog(processor, object, instruction);
}

EXTB_MORPH_FN(emitSLO) {
    commonSxO(processor, object, instruction, vmi_SHL, 0);
}

EXTB_MORPH_FN(emitSLOW){
    commonSxO(processor, object, instruction, vmi_SHL, 1);
}

static void commonSxOI(
        vmiProcessorP processor,
        vmiosObjectP  object,
        Uns32         instruction,
        vmiBinop      op,
        Uns32         word) {

    regProlog(processor, object, instruction, BM_RR);

    Uns32 result = (word==1) ? 32 : object->xlen;

    // SH and ONES
    Uns32 shamt = (result==32) ? object->cu5 : object->cu7;
    Uns32 shone = (object->xlen - shamt);
    Uns64 ones  = 0;
    if (shamt) {
        if (result==32) {
            if (op==vmi_SHL) {
                ones = (Uns32)-1 >> shone;
            }
            if (op==vmi_SHR) {
                ones = (Uns32)-1 << shone;
            }
        } else {
            if (op==vmi_SHL) {
                ones = (Uns64)-1 >> shone;
            }
            if (op==vmi_SHR) {
                ones = (Uns64)-1 << shone;
            }
        }
    }

    vmimtBinopRRC(result, op, object->reg_rd, object->reg_rs1, shamt, 0);
    vmimtBinopRC(result, vmi_OR, object->reg_rd, ones, 0);

    if (word) {
        vmimtMoveExtendRR(object->xlen, object->reg_rd, 32, object->reg_rd, 0);
    }

    regEpilog(processor, object, instruction);
}

EXTB_MORPH_FN(emitSLOI) {
    commonSxOI(processor, object, instruction, vmi_SHL, 0);
}

EXTB_MORPH_FN(emitSLOIW) {
    commonSxOI(processor, object, instruction, vmi_SHL, 1);
}

EXTB_MORPH_FN(emitSRO) {
    commonSxO(processor, object, instruction, vmi_SHR, 0);
}

EXTB_MORPH_FN(emitSROW) {
    commonSxO(processor, object, instruction, vmi_SHR, 1);
}

EXTB_MORPH_FN(emitSROI) {
    commonSxOI(processor, object, instruction, vmi_SHR, 0);
}

EXTB_MORPH_FN(emitSROIW) {
    commonSxOI(processor, object, instruction, vmi_SHR, 1);
}

EXTB_MORPH_FN(emitROL) {
    regProlog(processor, object, instruction, BM_RR);
    vmimtBinopRRR(object->xlen, vmi_ROL, object->reg_rd, object->reg_rs1, object->reg_rs2, 0);
    regEpilog(processor, object, instruction);
}
EXTB_MORPH_FN(emitROLW) {
    regProlog(processor, object, instruction, BM_RR);
    vmimtMoveRC(object->xlen, object->reg_tmp1, 0);
    vmimtBinopRRR(32, vmi_ROL, object->reg_tmp1, object->reg_rs1, object->reg_rs2, 0);
    vmimtMoveRR(object->xlen, object->reg_rd, object->reg_tmp1);
    regEpilog(processor, object, instruction);
}

EXTB_MORPH_FN(emitROR) {
    regProlog(processor, object, instruction, BM_RR);
    vmimtBinopRRR(object->xlen, vmi_ROR, object->reg_rd, object->reg_rs1, object->reg_rs2, 0);
    regEpilog(processor, object, instruction);
}

EXTB_MORPH_FN(emitRORW) {
    regProlog(processor, object, instruction, BM_RR);
    vmimtMoveRC(object->xlen, object->reg_tmp1, 0);
    vmimtBinopRRR(32, vmi_ROR, object->reg_tmp1, object->reg_rs1, object->reg_rs2, 0);
    vmimtMoveRR(object->xlen, object->reg_rd, object->reg_tmp1);
    regEpilog(processor, object, instruction);
}

EXTB_MORPH_FN(emitRORI) {
    regProlog(processor, object, instruction, BM_RR);
    vmimtBinopRRC(object->xlen, vmi_ROR, object->reg_rd, object->reg_rs1, object->cu7, 0);
    regEpilog(processor, object, instruction);
}

EXTB_MORPH_FN(emitRORIW) {
    regProlog(processor, object, instruction, BM_RR);
    vmimtMoveRC(object->xlen, object->reg_tmp1, 0);
    vmimtBinopRRC(32, vmi_ROR, object->reg_tmp1, object->reg_rs1, object->cu5, 0);
    vmimtMoveRR(object->xlen, object->reg_rd, object->reg_tmp1);
    regEpilog(processor, object, instruction);
}

//
// GORC Callbacks
//
static Uns32 gorc32_c(Uns32 rs1, Uns32 rs2) {
    Uns32 x = rs1;
    Uns32 shamt = rs2 & 31;
    if (shamt & 1)  x |= ((x & 0x55555555) << 1)  | ((x & 0xAAAAAAAA) >> 1);
    if (shamt & 2)  x |= ((x & 0x33333333) << 2)  | ((x & 0xCCCCCCCC) >> 2);
    if (shamt & 4)  x |= ((x & 0x0F0F0F0F) << 4)  | ((x & 0xF0F0F0F0) >> 4);
    if (shamt & 8)  x |= ((x & 0x00FF00FF) << 8)  | ((x & 0xFF00FF00) >> 8);
    if (shamt & 16) x |= ((x & 0x0000FFFF) << 16) | ((x & 0xFFFF0000) >> 16);
    return x;
}
static Uns64 gorc64_c(Uns64 rs1, Uns64 rs2) {
    Uns64 x = rs1;
    Uns32 shamt = rs2 & 63;
    if (shamt & 1)  x |= ((x & 0x5555555555555555LL) << 1)  | ((x & 0xAAAAAAAAAAAAAAAALL) >> 1);
    if (shamt & 2)  x |= ((x & 0x3333333333333333LL) << 2)  | ((x & 0xCCCCCCCCCCCCCCCCLL) >> 2);
    if (shamt & 4)  x |= ((x & 0x0F0F0F0F0F0F0F0FLL) << 4)  | ((x & 0xF0F0F0F0F0F0F0F0LL) >> 4);
    if (shamt & 8)  x |= ((x & 0x00FF00FF00FF00FFLL) << 8)  | ((x & 0xFF00FF00FF00FF00LL) >> 8);
    if (shamt & 16) x |= ((x & 0x0000FFFF0000FFFFLL) << 16) | ((x & 0xFFFF0000FFFF0000LL) >> 16);
    if (shamt & 32) x |= ((x & 0x00000000FFFFFFFFLL) << 32) | ((x & 0xFFFFFFFF00000000LL) >> 32);
    return x;
}
static void commonGORC(
        vmiProcessorP processor,
        vmiosObjectP  object,
        Uns32         instruction,
        Uns32         word) {

    regProlog(processor, object, instruction, BM_RR);
    Uns32 result = (word==1) ? 32 : object->xlen;

    vmimtArgReg(result, object->reg_rs1);
    vmimtArgReg(result, object->reg_rs2);
    if (object->xlen==32 || word) {
        vmimtCallResult((vmiCallFn)gorc32_c, object->xlen, object->reg_rd);
    } else {
        vmimtCallResult((vmiCallFn)gorc64_c, object->xlen, object->reg_rd);
    }

    if (word) {
        vmimtMoveExtendRR(object->xlen, object->reg_rd, 32, object->reg_rd, 0);
    }

    regEpilog(processor, object, instruction);
}
EXTB_MORPH_FN(emitGORC) {
    commonGORC(processor, object, instruction, 0);
}
EXTB_MORPH_FN(emitGORCW){
    commonGORC(processor, object, instruction, 1);
}

static void commonGORCI(
        vmiProcessorP processor,
        vmiosObjectP  object,
        Uns32         instruction,
        Uns32         word) {

    regProlog(processor, object, instruction, BM_RR);
    Uns32 result = (word==1) ? 32 : object->xlen;

    vmimtArgReg(result, object->reg_rs1);
    if (object->xlen==32 || word) {
        vmimtArgUns32(object->cu7);
        vmimtCallResult((vmiCallFn)gorc32_c, object->xlen, object->reg_rd);
    } else {
        vmimtArgUns64(object->cu7);
        vmimtCallResult((vmiCallFn)gorc64_c, object->xlen, object->reg_rd);
    }

    if (word) {
        vmimtMoveExtendRR(object->xlen, object->reg_rd, 32, object->reg_rd, 0);
    }

    regEpilog(processor, object, instruction);
}

EXTB_MORPH_FN(emitGORCI) {
    commonGORCI(processor, object, instruction, 0);
}
EXTB_MORPH_FN(emitGORCIW){
    commonGORCI(processor, object, instruction, 1);
}

//
// GREV Callbacks
//
static Uns32 grev32_c(Uns32 rs1, Uns32 rs2) {
    Uns32 x = rs1;
    Uns32 shamt = rs2 & 31;
    if (shamt & 1)  x = ((x & 0x55555555) << 1)  | ((x & 0xAAAAAAAA) >> 1);
    if (shamt & 2)  x = ((x & 0x33333333) << 2)  | ((x & 0xCCCCCCCC) >> 2);
    if (shamt & 4)  x = ((x & 0x0F0F0F0F) << 4)  | ((x & 0xF0F0F0F0) >> 4);
    if (shamt & 8)  x = ((x & 0x00FF00FF) << 8)  | ((x & 0xFF00FF00) >> 8);
    if (shamt & 16) x = ((x & 0x0000FFFF) << 16) | ((x & 0xFFFF0000) >> 16);
    return x;
}
static Uns64 grev64_c(Uns64 rs1, Uns64 rs2) {
    Uns64 x = rs1;
    Uns32 shamt = rs2 & 63;
    if (shamt & 1)  x = ((x & 0x5555555555555555LL) << 1)  | ((x & 0xAAAAAAAAAAAAAAAALL) >> 1);
    if (shamt & 2)  x = ((x & 0x3333333333333333LL) << 2)  | ((x & 0xCCCCCCCCCCCCCCCCLL) >> 2);
    if (shamt & 4)  x = ((x & 0x0F0F0F0F0F0F0F0FLL) << 4)  | ((x & 0xF0F0F0F0F0F0F0F0LL) >> 4);
    if (shamt & 8)  x = ((x & 0x00FF00FF00FF00FFLL) << 8)  | ((x & 0xFF00FF00FF00FF00LL) >> 8);
    if (shamt & 16) x = ((x & 0x0000FFFF0000FFFFLL) << 16) | ((x & 0xFFFF0000FFFF0000LL) >> 16);
    if (shamt & 32) x = ((x & 0x00000000FFFFFFFFLL) << 32) | ((x & 0xFFFFFFFF00000000LL) >> 32);
    return x;
}
static void commonGREV(
        vmiProcessorP processor,
        vmiosObjectP  object,
        Uns32         instruction,
        Uns32         word) {

    regProlog(processor, object, instruction, BM_RR);
    Uns32 result = (word==1) ? 32 : object->xlen;

    vmimtArgReg(result, object->reg_rs1);
    vmimtArgReg(result, object->reg_rs2);
    if (object->xlen==32 || word) {
        vmimtCallResult((vmiCallFn)grev32_c, object->xlen, object->reg_rd);
    } else {
        vmimtCallResult((vmiCallFn)grev64_c, object->xlen, object->reg_rd);
    }

    if (word) {
        vmimtMoveExtendRR(object->xlen, object->reg_rd, 32, object->reg_rd, 0);
    }

    regEpilog(processor, object, instruction);
}

EXTB_MORPH_FN(emitGREV) {
    commonGREV(processor, object, instruction, 0);
}
EXTB_MORPH_FN(emitGREVW){
    commonGREV(processor, object, instruction, 1);
}

static void commonGREVI(
        vmiProcessorP processor,
        vmiosObjectP  object,
        Uns32         instruction,
        Uns32         word) {

    regProlog(processor, object, instruction, BM_RR);
    Uns32 result = (word==1) ? 32 : object->xlen;

    vmimtArgReg(result, object->reg_rs1);
    if (object->xlen==32 || word) {
        vmimtArgUns32(object->cu7);
        vmimtCallResult((vmiCallFn)grev32_c, object->xlen, object->reg_rd);
    } else {
        vmimtArgUns64(object->cu7);
        vmimtCallResult((vmiCallFn)grev64_c, object->xlen, object->reg_rd);
    }

    if (word) {
        vmimtMoveExtendRR(object->xlen, object->reg_rd, 32, object->reg_rd, 0);
    }

    regEpilog(processor, object, instruction);
}

EXTB_MORPH_FN(emitGREVI) {
    commonGREVI(processor, object, instruction, 0);
}
EXTB_MORPH_FN(emitGREVIW){
    commonGREVI(processor, object, instruction, 1);
}

//
// SHFL Callbacks
//
static Uns32 shuffle32_stage(Uns32 src, Uns32 maskL, Uns32 maskR, int N) {
    Uns32 x = src & ~(maskL | maskR);
    x |= ((src << N) & maskL) | ((src >> N) & maskR);
    return x;
}
static Uns32 shfl32_c(Uns32 rs1, Uns32 rs2) {
    Uns32 x = rs1;
    Uns32 shamt = rs2 & 15;
    if (shamt & 8) x = shuffle32_stage(x, 0x00ff0000, 0x0000ff00, 8);
    if (shamt & 4) x = shuffle32_stage(x, 0x0f000f00, 0x00f000f0, 4);
    if (shamt & 2) x = shuffle32_stage(x, 0x30303030, 0x0c0c0c0c, 2);
    if (shamt & 1) x = shuffle32_stage(x, 0x44444444, 0x22222222, 1);
    return x;
}
static Uns32 unshfl32_c(Uns32 rs1, Uns32 rs2) {
    Uns32 x = rs1;
    Uns32 shamt = rs2 & 15;
    if (shamt & 1) x = shuffle32_stage(x, 0x44444444, 0x22222222, 1);
    if (shamt & 2) x = shuffle32_stage(x, 0x30303030, 0x0c0c0c0c, 2);
    if (shamt & 4) x = shuffle32_stage(x, 0x0f000f00, 0x00f000f0, 4);
    if (shamt & 8) x = shuffle32_stage(x, 0x00ff0000, 0x0000ff00, 8);
    return x;
}
static Uns64 shuffle64_stage(Uns64 src, Uns64 maskL, Uns64 maskR, int N) {
    Uns64 x = src & ~(maskL | maskR);
    x |= ((src << N) & maskL) | ((src >> N) & maskR);
    return x;
}
static Uns64 shfl64_c(Uns64 rs1, Uns64 rs2) {
    Uns64 x = rs1;
    Uns32 shamt = rs2 & 31;

    if (shamt & 16) x = shuffle64_stage(x, 0x0000ffff00000000LL, 0x00000000ffff0000LL, 16);
    if (shamt & 8)  x = shuffle64_stage(x, 0x00ff000000ff0000LL, 0x0000ff000000ff00LL, 8);
    if (shamt & 4)  x = shuffle64_stage(x, 0x0f000f000f000f00LL, 0x00f000f000f000f0LL, 4);
    if (shamt & 2)  x = shuffle64_stage(x, 0x3030303030303030LL, 0x0c0c0c0c0c0c0c0cLL, 2);
    if (shamt & 1)  x = shuffle64_stage(x, 0x4444444444444444LL, 0x2222222222222222LL, 1);
    return x;
}
static Uns64 unshfl64_c(Uns64 rs1, Uns64 rs2) {
    Uns64 x = rs1;
    Uns32 shamt = rs2 & 31;
    if (shamt & 1)  x = shuffle64_stage(x, 0x4444444444444444LL, 0x2222222222222222LL, 1);
    if (shamt & 2)  x = shuffle64_stage(x, 0x3030303030303030LL, 0x0c0c0c0c0c0c0c0cLL, 2);
    if (shamt & 4)  x = shuffle64_stage(x, 0x0f000f000f000f00LL, 0x00f000f000f000f0LL, 4);
    if (shamt & 8)  x = shuffle64_stage(x, 0x00ff000000ff0000LL, 0x0000ff000000ff00LL, 8);
    if (shamt & 16) x = shuffle64_stage(x, 0x0000ffff00000000LL, 0x00000000ffff0000LL, 16);
    return x;
}

static void commonSHFL (
    vmiProcessorP processor,
    vmiosObjectP  object,
    Uns32         instruction,
    Uns32         word
) {
    regProlog(processor, object, instruction, BM_RR);
    Uns32 result = (word==1) ? 32 : object->xlen;

    vmimtArgReg(result, object->reg_rs1);
    vmimtArgReg(result, object->reg_rs2);
    if (object->xlen==32 || word) {
        vmimtCallResult((vmiCallFn)shfl32_c, object->xlen, object->reg_rd);
    } else {
        vmimtCallResult((vmiCallFn)shfl64_c, object->xlen, object->reg_rd);
    }

    if (word) {
        vmimtMoveExtendRR(object->xlen, object->reg_rd, 32, object->reg_rd, 0);
    }

    regEpilog(processor, object, instruction);
}

EXTB_MORPH_FN(emitSHFL) {
    commonSHFL(processor, object, instruction, 0);
}
EXTB_MORPH_FN(emitSHFLW) {
    commonSHFL(processor, object, instruction, 1);
}

static void commonUNSHFL (
    vmiProcessorP processor,
    vmiosObjectP  object,
    Uns32         instruction,
    Uns32         word
) {
    regProlog(processor, object, instruction, BM_RR);
    Uns32 result = (word==1) ? 32 : object->xlen;

    vmimtArgReg(result, object->reg_rs1);
    vmimtArgReg(result, object->reg_rs2);
    if (object->xlen==32 || word) {
        vmimtCallResult((vmiCallFn)unshfl32_c, object->xlen, object->reg_rd);
    } else {
        vmimtCallResult((vmiCallFn)unshfl64_c, object->xlen, object->reg_rd);
    }

    if (word) {
        vmimtMoveExtendRR(object->xlen, object->reg_rd, 32, object->reg_rd, 0);
    }

    regEpilog(processor, object, instruction);
}

EXTB_MORPH_FN(emitUNSHFL) {
    commonUNSHFL(processor, object, instruction, 0);
}
EXTB_MORPH_FN(emitUNSHFLW) {
    commonUNSHFL(processor, object, instruction, 1);
}

EXTB_MORPH_FN(emitSHFLI) {
    regProlog(processor, object, instruction, BM_RR);
    vmimtArgReg(object->xlen, object->reg_rs1);
    if (object->xlen == 32) {
        vmimtArgUns32(object->cu7);
        vmimtCallResult((vmiCallFn)shfl32_c, object->xlen, object->reg_rd);
    } else {
        vmimtArgUns64(object->cu7);
        vmimtCallResult((vmiCallFn)shfl64_c, object->xlen, object->reg_rd);
    }
    regEpilog(processor, object, instruction);
}

EXTB_MORPH_FN(emitUNSHFLI) {
    regProlog(processor, object, instruction, BM_RR);
    vmimtArgReg(object->xlen, object->reg_rs1);
    if (object->xlen == 32) {
        vmimtArgUns32(object->cu7);
        vmimtCallResult((vmiCallFn)unshfl32_c, object->xlen, object->reg_rd);
    } else {
        vmimtArgUns64(object->cu7);
        vmimtCallResult((vmiCallFn)unshfl64_c, object->xlen, object->reg_rd);
    }
    regEpilog(processor, object, instruction);
}

//
// Bit Extract/deposit
//
static Uns32 bext32_c(Uns32 rs1, Uns32 rs2) {
    Uns32 r = 0;
    Uns32 i, j;
    for (i = 0, j = 0; i < 32; i++) {
        if ((rs2 >> i) & 1) {
            if ((rs1 >> i) & 1) {
                r |= (Uns32)1 << j;
            }
            j++;
        }
    }
    return r;
}
static Uns64 bext64_c(Uns64 rs1, Uns64 rs2) {
    Uns64 r = 0;
    Uns32 i, j;
    for (i = 0, j = 0; i < 64; i++) {
        if ((rs2 >> i) & 1) {
            if ((rs1 >> i) & 1) {
                r |= (Uns64)1ULL << j;
            }
            j++;
        }
    }
    return r;
}
static Uns32 bdep32_c(Uns32 rs1, Uns32 rs2) {
    Uns32 r = 0;
    Uns32 i, j;
    for (i = 0, j = 0; i < 32; i++) {
        if ((rs2 >> i) & 1) {
            if ((rs1 >> j) & 1) {
                r |= (Uns32)1 << i;
            }
            j++;
        }
    }
    return r;
}
static Uns64 bdep64_c(Uns64 rs1, Uns64 rs2) {
    Uns64 r = 0;
    Uns32 i, j;
    for (i = 0, j = 0; i < 64; i++) {
        if ((rs2 >> i) & 1) {
            if ((rs1 >> j) & 1) {
                r |= (Uns64)1ULL << i;
            }
            j++;
        }
    }
    return r;
}

static void commonBEXT (
    vmiProcessorP processor,
    vmiosObjectP  object,
    Uns32         instruction,
    Uns32         word
) {
    regProlog(processor, object, instruction, BM_RR);
    Uns32 result = (word==1) ? 32 : object->xlen;

    vmimtArgReg(result, object->reg_rs1);
    vmimtArgReg(result, object->reg_rs2);
    if (object->xlen==32 || word) {
        vmimtCallResult((vmiCallFn)bext32_c, object->xlen, object->reg_rd);
    } else {
        vmimtCallResult((vmiCallFn)bext64_c, object->xlen, object->reg_rd);
    }

    if (word) {
        vmimtMoveExtendRR(object->xlen, object->reg_rd, 32, object->reg_rd, 0);
    }

    regEpilog(processor, object, instruction);
}

EXTB_MORPH_FN(emitBEXT) {
    commonBEXT(processor, object, instruction, 0);
}
EXTB_MORPH_FN(emitBEXTW) {
    commonBEXT(processor, object, instruction, 1);
}

static void commonBDEP (
    vmiProcessorP processor,
    vmiosObjectP  object,
    Uns32         instruction,
    Uns32         word
) {
    regProlog(processor, object, instruction, BM_RR);
    Uns32 result = (word==1) ? 32 : object->xlen;

    vmimtArgReg(result, object->reg_rs1);
    vmimtArgReg(result, object->reg_rs2);
    if (object->xlen==32 || word) {
        vmimtCallResult((vmiCallFn)bdep32_c, object->xlen, object->reg_rd);
    } else {
        vmimtCallResult((vmiCallFn)bdep64_c, object->xlen, object->reg_rd);
    }

    if (word) {
        vmimtMoveExtendRR(object->xlen, object->reg_rd, 32, object->reg_rd, 0);
    }

    regEpilog(processor, object, instruction);
}

EXTB_MORPH_FN(emitBDEP) {
    commonBDEP(processor, object, instruction, 0);
}
EXTB_MORPH_FN(emitBDEPW) {
    commonBDEP(processor, object, instruction, 1);
}

EXTB_MORPH_FN(emitCMIX) {
    regProlog(processor, object, instruction, BM_RRR);
    vmimtBinopRRR(object->xlen, vmi_AND,  object->reg_tmp1, object->reg_rs1,  object->reg_rs2,  0); // save to tmp to not clobber next
    vmimtBinopRRR(object->xlen, vmi_ANDN, object->reg_tmp2, object->reg_rs3,  object->reg_rs2,  0);
    vmimtBinopRRR(object->xlen, vmi_OR,   object->reg_rd,   object->reg_tmp1, object->reg_tmp2, 0);
    regEpilog(processor, object, instruction);
}

EXTB_MORPH_FN(emitCMOV) {
    regProlog(processor, object, instruction, BM_RRR);
    vmimtCompareRC(object->xlen, vmi_COND_NE, object->reg_rs2, 0, object->reg_tmp1);
    vmimtCondMoveRRR(object->xlen, object->reg_tmp1, True, object->reg_rd, object->reg_rs1, object->reg_rs3);
    regEpilog(processor, object, instruction);
}

static Uns32 fsl32_c(Uns32 rs1, Uns32 rs2, Uns32 rs3) {
    Int32 XLEN = 32;
    Int32 shamt = rs2 & (2*XLEN - 1);
    Uns32 A = rs1, B = rs3;
    if (shamt >= XLEN) {
        shamt -= XLEN; A = rs3; B = rs1;
    }
    return shamt ? (A << shamt) | (B >> (XLEN-shamt)) : A;
}

static Uns64 fsl64_c(Uns64 rs1, Uns64 rs2, Uns64 rs3) {
    Int32 XLEN = 64;
    Int32 shamt = rs2 & (2*XLEN - 1);
    Uns64 A = rs1, B = rs3;
    if (shamt >= XLEN) {
        shamt -= XLEN; A = rs3; B = rs1;
    }
    return shamt ? (A << shamt) | (B >> (XLEN-shamt)) : A;
}

static void commonFSL (
    vmiProcessorP processor,
    vmiosObjectP  object,
    Uns32         instruction,
    Uns32         word
) {
    regProlog(processor, object, instruction, BM_RRR);
    Uns32 result = (word==1) ? 32 : object->xlen;

    vmimtArgReg(result, object->reg_rs1);
    vmimtArgReg(result, object->reg_rs2);
    vmimtArgReg(result, object->reg_rs3);
    if (object->xlen==32 || word) {
        vmimtCallResult((vmiCallFn)fsl32_c, object->xlen, object->reg_rd);
    } else {
        vmimtCallResult((vmiCallFn)fsl64_c, object->xlen, object->reg_rd);
    }

    if (word) {
        vmimtMoveExtendRR(object->xlen, object->reg_rd, 32, object->reg_rd, 0);
    }

    regEpilog(processor, object, instruction);
}

EXTB_MORPH_FN(emitFSL) {
    commonFSL(processor, object, instruction, 0);
}
EXTB_MORPH_FN(emitFSLW) {
    commonFSL(processor, object, instruction, 1);
}

static void commonFSR (
    vmiProcessorP processor,
    vmiosObjectP  object,
    Uns32         instruction,
    Uns32         word
) {
    regProlog(processor, object, instruction, BM_RRR);
    Uns32 result = (word==1) ? 32 : object->xlen;

    vmimtArgReg(result, object->reg_rs1);
    vmimtArgReg(result, object->reg_rs2);
    vmimtArgReg(result, object->reg_rs3);
    if (object->xlen==32 || word) {
        vmimtCallResult((vmiCallFn)fsr32_c, object->xlen, object->reg_rd);
    } else {
        vmimtCallResult((vmiCallFn)fsr64_c, object->xlen, object->reg_rd);
    }

    if (word) {
        vmimtMoveExtendRR(object->xlen, object->reg_rd, 32, object->reg_rd, 0);
    }

    regEpilog(processor, object, instruction);
}

EXTB_MORPH_FN(emitFSR) {
    commonFSR(processor, object, instruction, 0);
}
EXTB_MORPH_FN(emitFSRW) {
    commonFSR(processor, object, instruction, 1);
}

EXTB_MORPH_FN(emitMIN) {
    regProlog(processor, object, instruction, BM_RR);
    vmimtCompareRR(object->xlen, vmi_COND_L, object->reg_rs1, object->reg_rs2, object->reg_tmp1);
    vmimtCondMoveRRR(object->xlen, object->reg_tmp1, True, object->reg_rd, object->reg_rs1, object->reg_rs2);
    regEpilog(processor, object, instruction);
}

EXTB_MORPH_FN(emitMAX) {
    regProlog(processor, object, instruction, BM_RR);
    vmimtCompareRR(object->xlen, vmi_COND_NL, object->reg_rs1, object->reg_rs2, object->reg_tmp1);
    vmimtCondMoveRRR(object->xlen, object->reg_tmp1, True, object->reg_rd, object->reg_rs1, object->reg_rs2);
    regEpilog(processor, object, instruction);
}

EXTB_MORPH_FN(emitMINU) {
    regProlog(processor, object, instruction, BM_RR);
    vmimtCompareRR(object->xlen, vmi_COND_B, object->reg_rs1, object->reg_rs2, object->reg_tmp1);
    vmimtCondMoveRRR(object->xlen, object->reg_tmp1, True, object->reg_rd, object->reg_rs1, object->reg_rs2);
    regEpilog(processor, object, instruction);
}

EXTB_MORPH_FN(emitMAXU) {
    regProlog(processor, object, instruction, BM_RR);
    vmimtCompareRR(object->xlen, vmi_COND_NB, object->reg_rs1, object->reg_rs2, object->reg_tmp1);
    vmimtCondMoveRRR(object->xlen, object->reg_tmp1, True, object->reg_rd, object->reg_rs1, object->reg_rs2);
    regEpilog(processor, object, instruction);
}

static Uns32 clmul32_c(Uns32 rs1, Uns32 rs2) {
    Int32 XLEN = 32;
    Uns32 x = 0;
    Uns32 i;
    for (i = 0; i < XLEN; i++) {
        if ((rs2 >> i) & 1) {
            x ^= rs1 << i;
        }
    }
    return x;
}
static Uns64 clmul64_c(Uns64 rs1, Uns64 rs2) {
    Int32 XLEN = 64;
    Uns64 x = 0;
    Uns32 i;
    for (i = 0; i < XLEN; i++) {
        if ((rs2 >> i) & 1) {
            x ^= rs1 << i;
        }
    }
    return x;
}
static void commonCLMUL (
    vmiProcessorP processor,
    vmiosObjectP  object,
    Uns32         instruction,
    Uns32         word
) {

    regProlog(processor, object, instruction, BM_RR);
    Uns32 result = (word==1) ? 32 : object->xlen;

    vmimtArgReg(result, object->reg_rs1);
    vmimtArgReg(result, object->reg_rs2);
    if (object->xlen==32 || word) {
        vmimtCallResult((vmiCallFn)clmul32_c, object->xlen, object->reg_rd);
    } else {
        vmimtCallResult((vmiCallFn)clmul64_c, object->xlen, object->reg_rd);
    }

    if (word) {
        vmimtMoveExtendRR(object->xlen, object->reg_rd, 32, object->reg_rd, 0);
    }

    regEpilog(processor, object, instruction);
}
EXTB_MORPH_FN(emitCLMUL) {
    commonCLMUL(processor, object, instruction, 0);
}
EXTB_MORPH_FN(emitCLMULW) {
    commonCLMUL(processor, object, instruction, 1);
}

static Uns32 clmulr32_c(Uns32 rs1, Uns32 rs2) {
    Int32 XLEN = 32;
    Uns32 x = 0;
    Uns32 i;
    for (i = 0; i < XLEN; i++) {
        if ((rs2 >> i) & 1) {
            x ^= rs1 >> (XLEN-i-1);
        }
    }
    return x;
}
static Uns64 clmulr64_c(Uns64 rs1, Uns64 rs2) {
    Int32 XLEN = 64;
    Uns64 x = 0;
    Uns32 i;
    for (i = 0; i < XLEN; i++) {
        if ((rs2 >> i) & 1) {
            x ^= rs1 >> (XLEN-i-1);
        }
    }
    return x;
}

static void commonCLMULR (
    vmiProcessorP processor,
    vmiosObjectP  object,
    Uns32         instruction,
    Uns32         word
) {

    regProlog(processor, object, instruction, BM_RR);
    Uns32 result = (word==1) ? 32 : object->xlen;

    vmimtArgReg(result, object->reg_rs1);
    vmimtArgReg(result, object->reg_rs2);
    if (object->xlen==32 || word) {
        vmimtCallResult((vmiCallFn)clmulr32_c, object->xlen, object->reg_rd);
    } else {
        vmimtCallResult((vmiCallFn)clmulr64_c, object->xlen, object->reg_rd);
    }

    if (word) {
        vmimtMoveExtendRR(object->xlen, object->reg_rd, 32, object->reg_rd, 0);
    }

    regEpilog(processor, object, instruction);
}
EXTB_MORPH_FN(emitCLMULR) {
    commonCLMULR(processor, object, instruction, 0);

}
EXTB_MORPH_FN(emitCLMULRW) {
    commonCLMULR(processor, object, instruction, 1);
}

static Uns32 clmulh32_c(Uns32 rs1, Uns32 rs2) {
    Int32 XLEN = 32;
    Uns32 x = 0;
    Uns32 i;
    for (i = 1; i < XLEN; i++) {
        if ((rs2 >> i) & 1) {
            x ^= rs1 >> (XLEN-i);
        }
    }
    return x;
}
static Uns64 clmulh64_c(Uns64 rs1, Uns64 rs2) {
    Int32 XLEN = 64;
    Uns64 x = 0;
    Uns32 i;
    for (i = 1; i < XLEN; i++) {
        if ((rs2 >> i) & 1) {
            x ^= rs1 >> (XLEN-i);
        }
    }
    return x;
}
static void commonCLMULH (
    vmiProcessorP processor,
    vmiosObjectP  object,
    Uns32         instruction,
    Uns32         word
) {
    regProlog(processor, object, instruction, BM_RR);
    Uns32 result = (word==1) ? 32 : object->xlen;

    vmimtArgReg(result, object->reg_rs1);
    vmimtArgReg(result, object->reg_rs2);
    if (object->xlen==32 || word) {
        vmimtCallResult((vmiCallFn)clmulh32_c, object->xlen, object->reg_rd);
    } else {
        vmimtCallResult((vmiCallFn)clmulh64_c, object->xlen, object->reg_rd);
    }

    if (word) {
        vmimtMoveExtendRR(object->xlen, object->reg_rd, 32, object->reg_rd, 0);
    }

    regEpilog(processor, object, instruction);
}

EXTB_MORPH_FN(emitCLMULH) {
    commonCLMULH(processor, object, instruction, 0);
}
EXTB_MORPH_FN(emitCLMULHW) {
    commonCLMULH(processor, object, instruction, 1);
}

static Uns32 crc32_c(Uns32 x, Uns32 nbits) {
    Uns32 i;
    for (i = 0; i < nbits; i++) {
        x = (x >> 1) ^ (0xEDB88320 & ~((x&1)-1));
    }
    return x;
}
static Uns64 crc64_c(Uns64 x, Uns32 nbits) {
    Uns32 i;
    for (i = 0; i < nbits; i++) {
        x = (x >> 1) ^ (0xEDB88320 & ~((x&1)-1));
    }
    return x;
}
static void emitCRC32(
        vmiProcessorP processor,
        vmiosObjectP  object,
        Uns32         instruction,
        Uns32         size
) {
    regProlog(processor, object, instruction, BM_RR);
    vmimtArgReg(object->xlen, object->reg_rs1);
    vmimtArgUns32(size);
    if (object->xlen == 32) {
        vmimtCallResult((vmiCallFn)crc32_c, object->xlen, object->reg_rd);
    } else {
        vmimtCallResult((vmiCallFn)crc64_c, object->xlen, object->reg_rd);
    }
    regEpilog(processor, object, instruction);
}
EXTB_MORPH_FN(emitCRC32_B) {
    emitCRC32(processor, object, instruction, 8);
}

EXTB_MORPH_FN(emitCRC32_H) {
    emitCRC32(processor, object, instruction, 16);
}

EXTB_MORPH_FN(emitCRC32_W) {
    emitCRC32(processor, object, instruction, 32);
}

EXTB_MORPH_FN(emitCRC32_D) {
    emitCRC32(processor, object, instruction, 64);
}

static Uns32 crc32c_c(Uns32 x, Uns32 nbits) {
    Uns32 i;
    for (i = 0; i < nbits; i++) {
        x = (x >> 1) ^ (0x82F63B78 & ~((x&1)-1));
    }
    return x;
}
static Uns64 crc64c_c(Uns64 x, Uns32 nbits) {
    Uns32 i;
    for (i = 0; i < nbits; i++) {
        x = (x >> 1) ^ (0x82F63B78 & ~((x&1)-1));
    }
    return x;
}
static void emitCRC32C(
        vmiProcessorP processor,
        vmiosObjectP  object,
        Uns32         instruction,
        Uns32         size
) {
    regProlog(processor, object, instruction, BM_RR);
    vmimtArgReg(object->xlen, object->reg_rs1);
    vmimtArgUns32(size);
    if (object->xlen == 32) {
        vmimtCallResult((vmiCallFn)crc32c_c, object->xlen, object->reg_rd);
    } else {
        vmimtCallResult((vmiCallFn)crc64c_c, object->xlen, object->reg_rd);
    }
    regEpilog(processor, object, instruction);
}

EXTB_MORPH_FN(emitCRC32C_B) {
    emitCRC32C(processor, object, instruction, 8);
}

EXTB_MORPH_FN(emitCRC32C_H) {
    emitCRC32C(processor, object, instruction, 16);
}

EXTB_MORPH_FN(emitCRC32C_W) {
    emitCRC32C(processor, object, instruction, 32);
}

EXTB_MORPH_FN(emitCRC32C_D) {
    emitCRC32C(processor, object, instruction, 64);
}

static Uns64 fast_pcnt64_c(Uns64 rs1) {
    return __builtin_popcountll(rs1);
}
static Uns64 bmatflip64_c(Uns64 rs1) {
    Uns64 x = rs1;
    x = shfl64_c(x, 31);
    x = shfl64_c(x, 31);
    x = shfl64_c(x, 31);
    return x;
}
static Uns64 bmatxor64_c(Uns64 rs1, Uns64 rs2) {
    // transpose of rs2
    Uns64 rs2t = bmatflip64_c(rs2);
    Uns8  u[8]; // rows of rs1
    Uns8  v[8]; // cols of rs2
    Uns32 i;
    for (i = 0; i < 8; i++) {
        u[i] = rs1 >> (i*8);
        v[i] = rs2t >> (i*8);
    }
    Uns64 x = 0;
    for (i = 0; i < 64; i++) {
        if (fast_pcnt64_c(u[i / 8] & v[i % 8]) & 1) {
            x |= 1LL << i;
        }
    }
    return x;
}
EXTB_MORPH_FN(emitBMATXOR) {
    regProlog(processor, object, instruction, BM_RR);
    vmimtArgReg(object->xlen, object->reg_rs1);
    vmimtArgReg(object->xlen, object->reg_rs2);
    if (object->xlen == 64) {
        vmimtCallResult((vmiCallFn)bmatxor64_c, object->xlen, object->reg_rd);
    }
    regEpilog(processor, object, instruction);
}

static Uns64 bmator64_c(Uns64 rs1, Uns64 rs2) {
    // transpose of rs2
    Uns64 rs2t = bmatflip64_c(rs2);
    Uns8  u[8]; // rows of rs1
    Uns8  v[8]; // cols of rs2
    Uns32 i;
    for (i = 0; i < 8; i++) {
        u[i] = rs1 >> (i*8);
        v[i] = rs2t >> (i*8);
    }
    Uns64 x = 0;
    for (i = 0; i < 64; i++) {
        if ((u[i / 8] & v[i % 8]) != 0) {
            x |= 1LL << i;
        }
    }
    return x;
}
EXTB_MORPH_FN(emitBMATOR) {
    regProlog(processor, object, instruction, BM_RR);
    vmimtArgReg(object->xlen, object->reg_rs1);
    vmimtArgReg(object->xlen, object->reg_rs2);
    if (object->xlen == 64) {
        vmimtCallResult((vmiCallFn)bmator64_c, object->xlen, object->reg_rd);
    }
    regEpilog(processor, object, instruction);
}

EXTB_MORPH_FN(emitBMATFLIP) {
    regProlog(processor, object, instruction, BM_RR);
    vmimtArgReg(object->xlen, object->reg_rs1);
    if (object->xlen == 64) {
        vmimtCallResult((vmiCallFn)bmatflip64_c, object->xlen, object->reg_rd);
    }
    regEpilog(processor, object, instruction);
}

static Uns32 rol32(Uns32 rs1, Uns32 rs2) {
    Int32 XLEN = 32;
    Int32 shamt = rs2 & (XLEN - 1);
    return (rs1 << shamt) | (rs1 >> ((XLEN - shamt) & (XLEN - 1)));
}
static Uns32 slo32(Uns32 rs1, Uns32 rs2) {
    Int32 XLEN = 32;
    Int32 shamt = rs2 & (XLEN - 1);
    return ~(~rs1 << shamt);
}
static Uns32 bfp32_c(Uns32 rs1, Uns32 rs2) {
    Int32 XLEN = 32;
    Int32 len = (rs2 >> 24) & 15;
    Int32 off = (rs2 >> 16) & (XLEN-1);
    len = len ? len : 16;
    Uns32 mask = rol32(slo32(0, len), off);
    Uns32 data = rol32(rs2, off);
    return (data & mask) | (rs1 & ~mask);
}

static Uns64 rol64(Uns64 rs1, Uns64 rs2) {
    Int32 XLEN = 64;
    Int32 shamt = rs2 & (XLEN - 1);
    return (rs1 << shamt) | (rs1 >> ((XLEN - shamt) & (XLEN - 1)));
}
static Uns64 slo64(Uns64 rs1, Uns64 rs2) {
    Int32 XLEN = 64;
    Int32 shamt = rs2 & (XLEN - 1);
    return ~(~rs1 << shamt);
}
static Uns64 bfp64_c(Uns64 rs1, Uns64 rs2) {
    Int32 XLEN = 64;
    Int32 len = (rs2 >> 24) & 15;
    Int32 off = (rs2 >> 16) & (XLEN-1);
    len = len ? len : 16;
    Uns64 mask = rol64(slo64(0, len), off);
    Uns64 data = rol64(rs2, off);
    return (data & mask) | (rs1 & ~mask);
}

static void commonBFP (
    vmiProcessorP processor,
    vmiosObjectP  object,
    Uns32         instruction,
    Uns32         word
) {
    regProlog(processor, object, instruction, BM_RR);
    Uns32 result = (word==1) ? 32 : object->xlen;

    vmimtArgReg(result, object->reg_rs1);
    vmimtArgReg(result, object->reg_rs2);
    if (object->xlen==32 || word) {
        vmimtCallResult((vmiCallFn)bfp32_c, object->xlen, object->reg_rd);
    } else {
        vmimtCallResult((vmiCallFn)bfp64_c, object->xlen, object->reg_rd);
    }

    if (word) {
        vmimtMoveExtendRR(object->xlen, object->reg_rd, 32, object->reg_rd, 0);
    }

    regEpilog(processor, object, instruction);
}

EXTB_MORPH_FN(emitBFP) {
    commonBFP(processor, object, instruction, 0);
}

EXTB_MORPH_FN(emitBFPW) {
    commonBFP(processor, object, instruction, 1);
}


//
// End morph code routines
//

//
// Morpher callback
//
static VMIOS_MORPH_FN(doMorph) {
    //
    // Extensions are disabled
    //
    if (!object->enable) {
        *opaque = False;
        return 0;
    }

    // decode the instruction to get the type
    Uns32 instruction, bytes;
    riscvITypeB type = getInstrType(object, processor, thisPC, &instruction, &bytes);

    *opaque = True;

    //
    // RISC-V XBitmanip Extension all (except pseudo instruction)
    //
    if        (type==EXTB_CLZ    ) {
        emitCLZ(processor, object, instruction);
    } else if (type==EXTB_CTZ    ) {
        emitCTZ(processor, object, instruction);
    } else if (type==EXTB_PCNT   ) {
        emitPCNT(processor, object, instruction);
    } else if (type==EXTB_ANDN   ) {
        emitANDN(processor, object, instruction);

    } else if (type==EXTB_ORN   ) {
        emitORN(processor, object, instruction);
    } else if (type==EXTB_XNOR   ) {
        emitXNOR(processor, object, instruction);
    } else if (type==EXTB_SBSET  ) {
        emitSBSET(processor, object, instruction);
    } else if (type==EXTB_SBCLR  ) {
        emitSBCLR(processor, object, instruction);
    } else if (type==EXTB_SBINV  ) {
        emitSBINV(processor, object, instruction);
    } else if (type==EXTB_SBEXT  ) {
        emitSBEXT(processor, object, instruction);
    } else if (type==EXTB_SBSETI ) {
        emitSBSETI(processor, object, instruction);
    } else if (type==EXTB_SBCLRI ) {
        emitSBCLRI(processor, object, instruction);
    } else if (type==EXTB_SBINVI ) {
        emitSBINVI(processor, object, instruction);
    } else if (type==EXTB_SBEXTI ) {
        emitSBEXTI(processor, object, instruction);
    } else if (type==EXTB_FSRI   ) {
        emitFSRI(processor, object, instruction);

    } else if (type==EXTB_ADDIWU && (object->xlen==64)) {
        emitADDIWU(processor, object, instruction);
    } else if (type==EXTB_SLLIU_W && (object->xlen==64)) {
        emitSLLIU_W(processor, object, instruction);
    } else if (type==EXTB_ADDU_W && (object->xlen==64)) {
        emitADDU_W(processor, object, instruction);
    } else if (type==EXTB_SUBU_W && (object->xlen==64)) {
        emitSUBU_W(processor, object, instruction);
    } else if (type==EXTB_ADDWU && (object->xlen==64)) {
        emitADDWU(processor, object, instruction);
    } else if (type==EXTB_SUBWU && (object->xlen==64)) {
        emitSUBWU(processor, object, instruction);

    } else if (type==EXTB_SLO    ) {
        emitSLO(processor, object, instruction);
    } else if (type==EXTB_SLOI   ) {
        emitSLOI(processor, object, instruction);
    } else if (type==EXTB_SRO    ) {
        emitSRO(processor, object, instruction);
    } else if (type==EXTB_SROI   ) {
        emitSROI(processor, object, instruction);
    } else if (type==EXTB_ROL    ) {
        emitROL(processor, object, instruction);
    } else if (type==EXTB_ROR    ) {
        emitROR(processor, object, instruction);
    } else if (type==EXTB_RORI   ) {
        emitRORI(processor, object, instruction);
    } else if (type==EXTB_GORC   ) {
        emitGORC(processor, object, instruction);
    } else if (type==EXTB_GREV   ) {
        emitGREV(processor, object, instruction);
    } else if (type==EXTB_GORCI  ) {
        emitGORCI(processor, object, instruction);
    } else if (type==EXTB_GREVI  ) {
        emitGREVI(processor, object, instruction);
    } else if (type==EXTB_SHFL   ) {
        emitSHFL(processor, object, instruction);
    } else if (type==EXTB_UNSHFL ) {
        emitUNSHFL(processor, object, instruction);
    } else if (type==EXTB_SHFLI  ) {
        emitSHFLI(processor, object, instruction);
    } else if (type==EXTB_UNSHFLI) {
        emitUNSHFLI(processor, object, instruction);
    } else if (type==EXTB_BEXT   ) {
        emitBEXT(processor, object, instruction);
    } else if (type==EXTB_PACK   ) {
        emitPACK(processor, object, instruction);
    } else if (type==EXTB_BDEP   ) {
        emitBDEP(processor, object, instruction);
//    } else if (type==EXTB_NOT    ) {
//        emitCNOT(processor, object, instruction);

    //
    // RISC-V XTernarybits Extension all
    //
    } else if (type==EXTB_CMIX  ) {
        emitCMIX(processor, object, instruction);
    } else if (type==EXTB_CMOV  ) {
        emitCMOV(processor, object, instruction);
    } else if (type==EXTB_FSL   ) {
        emitFSL(processor, object, instruction);
    } else if (type==EXTB_FSR   ) {
        emitFSR(processor, object, instruction);

    //
    // Additional Instructions all
    //
    } else if (type==EXTB_MIN    ) {
        emitMIN(processor, object, instruction);
    } else if (type==EXTB_MAX    ) {
        emitMAX(processor, object, instruction);
    } else if (type==EXTB_MINU   ) {
        emitMINU(processor, object, instruction);
    } else if (type==EXTB_MAXU   ) {
        emitMAXU(processor, object, instruction);
    } else if (type==EXTB_CLMUL      ) {
        emitCLMUL(processor, object, instruction);
    } else if (type==EXTB_CLMULR     ) {
        emitCLMULR(processor, object, instruction);
    } else if (type==EXTB_CLMULH     ) {
        emitCLMULH(processor, object, instruction);
    } else if (type==EXTB_CRC32_B    ) {
        emitCRC32_B(processor, object, instruction);
    } else if (type==EXTB_CRC32_H    ) {
        emitCRC32_H(processor, object, instruction);
    } else if (type==EXTB_CRC32_W    ) {
        emitCRC32_W(processor, object, instruction);
    } else if (type==EXTB_CRC32_D    ) {
        emitCRC32_D(processor, object, instruction);
    } else if (type==EXTB_CRC32C_B   ) {
        emitCRC32C_B(processor, object, instruction);
    } else if (type==EXTB_CRC32C_H   ) {
        emitCRC32C_H(processor, object, instruction);
    } else if (type==EXTB_CRC32C_W   ) {
        emitCRC32C_W(processor, object, instruction);
    } else if (type==EXTB_CRC32C_D   ) {
        emitCRC32C_D(processor, object, instruction);
    } else if (type==EXTB_BMATXOR && (object->xlen==64)) {
        emitBMATXOR(processor, object, instruction);
    } else if (type==EXTB_BFP) {
        emitBFP(processor, object, instruction);
    } else if (type==EXTB_BMATOR && (object->xlen==64)) {
        emitBMATOR(processor, object, instruction);
    } else if (type==EXTB_BMATFLIP && (object->xlen==64)) {
        emitBMATFLIP(processor, object, instruction);

    // Additions in version 0.90
    } else if (type==EXTB_GORCW && (object->xlen==64)) {
        emitGORCW(processor, object, instruction);
    } else if (type==EXTB_GREVW && (object->xlen==64)) {
        emitGREVW(processor, object, instruction);
    } else if (type==EXTB_SLOW && (object->xlen==64)) {
        emitSLOW(processor, object, instruction);
    } else if (type==EXTB_SROW && (object->xlen==64)) {
        emitSROW(processor, object, instruction);
    } else if (type==EXTB_ROLW && (object->xlen==64)) {
        emitROLW(processor, object, instruction);
    } else if (type==EXTB_RORW && (object->xlen==64)) {
        emitRORW(processor, object, instruction);
    } else if (type==EXTB_SBSETW && (object->xlen==64)) {
        emitSBSETW(processor, object, instruction);
    } else if (type==EXTB_SBCLRW && (object->xlen==64)) {
        emitSBCLRW(processor, object, instruction);
    } else if (type==EXTB_SBINVW && (object->xlen==64)) {
        emitSBINVW(processor, object, instruction);
    } else if (type==EXTB_SBEXTW && (object->xlen==64)) {
        emitSBEXTW(processor, object, instruction);
    } else if (type==EXTB_GORCIW && (object->xlen==64)) {
        emitGORCIW(processor, object, instruction);
    } else if (type==EXTB_GREVIW && (object->xlen==64)) {
        emitGREVIW(processor, object, instruction);
    } else if (type==EXTB_SLOIW && (object->xlen==64)) {
        emitSLOIW(processor, object, instruction);
    } else if (type==EXTB_SROIW && (object->xlen==64)) {
        emitSROIW(processor, object, instruction);
    } else if (type==EXTB_RORIW && (object->xlen==64)) {
        emitRORIW(processor, object, instruction);
    } else if (type==EXTB_SBSETIW && (object->xlen==64)) {
        emitSBSETIW(processor, object, instruction);
    } else if (type==EXTB_SBCLRIW && (object->xlen==64)) {
        emitSBCLRIW(processor, object, instruction);
    } else if (type==EXTB_SBINVIW && (object->xlen==64)) {
        emitSBINVIW(processor, object, instruction);
    } else if (type==EXTB_FSLW && (object->xlen==64)) {
        emitFSLW(processor, object, instruction);
    } else if (type==EXTB_FSRW && (object->xlen==64)) {
        emitFSRW(processor, object, instruction);
    } else if (type==EXTB_FSRIW && (object->xlen==64)) {
        emitFSRIW(processor, object, instruction);
    } else if (type==EXTB_CLZW && (object->xlen==64)) {
        emitCLZW(processor, object, instruction);
    } else if (type==EXTB_CTZW && (object->xlen==64)) {
        emitCTZW(processor, object, instruction);
    } else if (type==EXTB_PCNTW && (object->xlen==64)) {
        emitPCNTW(processor, object, instruction);
    } else if (type==EXTB_CLMULW && (object->xlen==64)) {
        emitCLMULW(processor, object, instruction);
    } else if (type==EXTB_CLMULRW && (object->xlen==64)) {
        emitCLMULRW(processor, object, instruction);
    } else if (type==EXTB_CLMULHW && (object->xlen==64)) {
        emitCLMULHW(processor, object, instruction);
    } else if (type==EXTB_SHFLW && (object->xlen==64)) {
        emitSHFLW(processor, object, instruction);
    } else if (type==EXTB_UNSHFLW && (object->xlen==64)) {
        emitUNSHFLW(processor, object, instruction);
    } else if (type==EXTB_BDEPW && (object->xlen==64)) {
        emitBDEPW(processor, object, instruction);
    } else if (type==EXTB_BEXTW && (object->xlen==64)) {
        emitBEXTW(processor, object, instruction);
    } else if (type==EXTB_PACKW && (object->xlen==64)) {
        emitPACKW(processor, object, instruction);
    } else if (type==EXTB_BFPW && (object->xlen==64)) {
        emitBFPW(processor, object, instruction);

    } else {
        *opaque = False;
    }

    // no intercept callback specified
    return 0;
}

//
// Disassembler callback disassembling instructions
//
static void print_instr(Uns32 xlen, Addr thisPC, char **bufferP, Uns32 instruction, Uns32 bytes, vmiDisassAttrs attrs) {
    if (!(attrs & DSA_UNCOOKED)) {
        if (bytes==4) {
            *bufferP += sprintf(*bufferP, "%04x ", instruction); // padded with 4 spaces
        } else if (bytes==2) {
            *bufferP += sprintf(*bufferP, "%02x     ", instruction);
        }
    }
}

//static void diss_rdp(vmiosObjectP object, Addr thisPC, char *buffer, char *name, Uns32 instruction, Uns32 bytes, vmiDisassAttrs attrs) {
//    Uns32 rd  = RDp(instruction);
//
//    print_instr(object->xlen, thisPC, &buffer, instruction, bytes, attrs);
//    sprintf(buffer, "%-7s %s", name, map[rd]);
//}
//#define DISS_RDP(NAME) diss_rdp(object, thisPC, buffer, NAME, instruction, bytes, attrs)

static void diss_rd_rs1(vmiosObjectP object, Addr thisPC, char *buffer, char *name, Uns32 instruction, Uns32 bytes, vmiDisassAttrs attrs) {
    Uns32 rd  = RD(instruction);
    Uns32 rs1 = RS1(instruction);

    print_instr(object->xlen, thisPC, &buffer, instruction, bytes, attrs);
    sprintf(buffer, "%-7s %s,%s", name, map[rd], map[rs1]);
}
#define DISS_RD_RS1(NAME) diss_rd_rs1(object, thisPC, buffer, NAME, instruction, bytes, attrs)

static void diss_rd_rs1_rs2(vmiosObjectP object, Addr thisPC, char *buffer, char *name, Uns32 instruction, Uns32 bytes, vmiDisassAttrs attrs) {
    Uns32 rd  = RD(instruction);
    Uns32 rs1 = RS1(instruction);
    Uns32 rs2 = RS2(instruction);

    print_instr(object->xlen, thisPC, &buffer, instruction, bytes, attrs);
    sprintf(buffer, "%-7s %s,%s,%s", name, map[rd], map[rs1], map[rs2]);
}
#define DISS_RD_RS1_RS2(NAME) diss_rd_rs1_rs2(object, thisPC, buffer, NAME, instruction, bytes, attrs)

static void diss_rd_rs1_rs2_rs3(vmiosObjectP object, Addr thisPC, char *buffer, char *name, Uns32 instruction, Uns32 bytes, vmiDisassAttrs attrs) {
    Uns32 rd  = RD(instruction);
    Uns32 rs1 = RS1(instruction);
    Uns32 rs2 = RS2(instruction);
    Uns32 rs3 = RS3(instruction);

    print_instr(object->xlen, thisPC, &buffer, instruction, bytes, attrs);
    sprintf(buffer, "%-7s %s,%s,%s,%s", name, map[rd], map[rs1], map[rs2], map[rs3]);
}
#define DISS_RD_RS1_RS2_RS3(NAME) diss_rd_rs1_rs2_rs3(object, thisPC, buffer, NAME, instruction, bytes, attrs)

static void diss_rd_rs1_rs3_imm5(vmiosObjectP object, Addr thisPC, char *buffer, char *name, Uns32 instruction, Uns32 bytes, vmiDisassAttrs attrs) {
    Uns32 rd  = RD(instruction);
    Uns32 rs1 = RS1(instruction);
    Uns32 rs3 = RS3(instruction);
    Uns32 cu5 = CU5(instruction);

    print_instr(object->xlen, thisPC, &buffer, instruction, bytes, attrs);
    sprintf(buffer, "%-7s %s,%s,%s,%u", name, map[rd], map[rs1], map[rs3], cu5);
}
#define DISS_RD_RS1_RS3_IMM5(NAME) diss_rd_rs1_rs3_imm5(object, thisPC, buffer, NAME, instruction, bytes, attrs)

static void diss_rd_rs1_rs3_imm6(vmiosObjectP object, Addr thisPC, char *buffer, char *name, Uns32 instruction, Uns32 bytes, vmiDisassAttrs attrs) {
    Uns32 rd  = RD(instruction);
    Uns32 rs1 = RS1(instruction);
    Uns32 rs3 = RS3(instruction);
    Uns32 cu6 = CU6(instruction);

    print_instr(object->xlen, thisPC, &buffer, instruction, bytes, attrs);
    sprintf(buffer, "%-7s %s,%s,%s,%u", name, map[rd], map[rs1], map[rs3], cu6);
}
#define DISS_RD_RS1_RS3_IMM6(NAME) diss_rd_rs1_rs3_imm6(object, thisPC, buffer, NAME, instruction, bytes, attrs)

static void diss_rd_rs1_imm12(vmiosObjectP object, Addr thisPC, char *buffer, char *name, Uns32 instruction, Uns32 bytes, vmiDisassAttrs attrs) {
    Uns32 rd   = RD(instruction);
    Uns32 rs1  = RS1(instruction);
    Uns32 cu12 = CU12(instruction);

    print_instr(object->xlen, thisPC, &buffer, instruction, bytes, attrs);
    sprintf(buffer, "%-7s %s,%s,%u", name, map[rd], map[rs1], cu12);
}
#define DISS_RD_RS1_IMM12(NAME) diss_rd_rs1_imm12(object, thisPC, buffer, NAME, instruction, bytes, attrs)

static void diss_rd_rs1_imm7(vmiosObjectP object, Addr thisPC, char *buffer, char *name, Uns32 instruction, Uns32 bytes, vmiDisassAttrs attrs) {
    Uns32 rd  = RD(instruction);
    Uns32 rs1 = RS1(instruction);
    Uns32 cu7 = CU7(instruction);

    print_instr(object->xlen, thisPC, &buffer, instruction, bytes, attrs);
    sprintf(buffer, "%-7s %s,%s,%u", name, map[rd], map[rs1], cu7);
}
#define DISS_RD_RS1_IMM7(NAME) diss_rd_rs1_imm7(object, thisPC, buffer, NAME, instruction, bytes, attrs)

static void diss_rd_rs1_imm6(vmiosObjectP object, Addr thisPC, char *buffer, char *name, Uns32 instruction, Uns32 bytes, vmiDisassAttrs attrs) {
    Uns32 rd  = RD(instruction);
    Uns32 rs1 = RS1(instruction);
    Uns32 cu6 = CU6(instruction);

    print_instr(object->xlen, thisPC, &buffer, instruction, bytes, attrs);
    sprintf(buffer, "%-7s %s,%s,%u", name, map[rd], map[rs1], cu6);
}
#define DISS_RD_RS1_IMM6(NAME) diss_rd_rs1_imm6(object, thisPC, buffer, NAME, instruction, bytes, attrs)


static void diss_rd_rs1_imm5(vmiosObjectP object, Addr thisPC, char *buffer, char *name, Uns32 instruction, Uns32 bytes, vmiDisassAttrs attrs) {
    Uns32 rd  = RD(instruction);
    Uns32 rs1 = RS1(instruction);
    Uns32 cu5 = CU5(instruction);

    print_instr(object->xlen, thisPC, &buffer, instruction, bytes, attrs);
    sprintf(buffer, "%-7s %s,%s,%u", name, map[rd], map[rs1], cu5);
}
#define DISS_RD_RS1_IMM5(NAME) diss_rd_rs1_imm5(object, thisPC, buffer, NAME, instruction, bytes, attrs)

static VMIOS_DISASSEMBLE_FN(doDisass) {

    // decode the instruction to get the type
    Uns32 instruction, bytes;
    riscvITypeB type = getInstrType(object, processor, thisPC, &instruction, &bytes);

    if (type != EXTB_LAST) {
        static char buffer[256];

        //
        // RISC-V XBitmanip Extension all (except pseudo instruction)
        //
        if        (type==EXTB_CLZ    ) {
            DISS_RD_RS1("clz");
        } else if (type==EXTB_CTZ    ) {
            DISS_RD_RS1("ctz");
        } else if (type==EXTB_PCNT   ) {
            DISS_RD_RS1("pcnt");
        } else if (type==EXTB_ANDN   ) {
            DISS_RD_RS1_RS2("andn");

        } else if (type==EXTB_ORN   ) {
            DISS_RD_RS1_RS2("orn");
        } else if (type==EXTB_XNOR   ) {
            DISS_RD_RS1_RS2("xnor");
        } else if (type==EXTB_SBSET  ) {
            DISS_RD_RS1_RS2("sbset");
        } else if (type==EXTB_SBCLR  ) {
            DISS_RD_RS1_RS2("sbclr");
        } else if (type==EXTB_SBINV  ) {
            DISS_RD_RS1_RS2("sbinv");
        } else if (type==EXTB_SBEXT  ) {
            DISS_RD_RS1_RS2("sbext");
        } else if (type==EXTB_SBSETI ) {
            DISS_RD_RS1_IMM7("sbseti");
        } else if (type==EXTB_SBCLRI ) {
            DISS_RD_RS1_IMM7("sbclri");
        } else if (type==EXTB_SBINVI ) {
            DISS_RD_RS1_IMM7("sbinvi");
        } else if (type==EXTB_SBEXTI ) {
            DISS_RD_RS1_IMM7("sbexti");
        } else if (type==EXTB_FSRI   ) {
            DISS_RD_RS1_RS3_IMM6("fsri");

        } else if (type==EXTB_ADDIWU ) {
            DISS_RD_RS1_IMM12("addiwu");
        } else if (type==EXTB_SLLIU_W ) {
            DISS_RD_RS1_IMM7("slliu.w");
        } else if (type==EXTB_ADDWU ) {
            DISS_RD_RS1_RS2("addwu");
        } else if (type==EXTB_SUBWU ) {
            DISS_RD_RS1_RS2("subwu");
        } else if (type==EXTB_ADDU_W ) {
            DISS_RD_RS1_RS2("addu.w");
        } else if (type==EXTB_SUBU_W ) {
            DISS_RD_RS1_RS2("subu.w");

        } else if (type==EXTB_SLO    ) {
            DISS_RD_RS1_RS2("slo");
        } else if (type==EXTB_SLOI   ) {
            DISS_RD_RS1_IMM7("sloi");
        } else if (type==EXTB_SRO    ) {
            DISS_RD_RS1_RS2("sro");
        } else if (type==EXTB_SROI   ) {
            DISS_RD_RS1_IMM7("sroi");
        } else if (type==EXTB_ROL    ) {
            DISS_RD_RS1_RS2("rol");
        } else if (type==EXTB_ROR    ) {
            DISS_RD_RS1_RS2("ror");
        } else if (type==EXTB_RORI   ) {
            DISS_RD_RS1_IMM7("rori");
        } else if (type==EXTB_GORC   ) {
            DISS_RD_RS1_RS2("gorc");
        } else if (type==EXTB_GREV   ) {
            DISS_RD_RS1_RS2("grev");
        } else if (type==EXTB_GORCI  ) {
            DISS_RD_RS1_IMM7("gorci");
        } else if (type==EXTB_GREVI  ) {
            DISS_RD_RS1_IMM7("grevi");
        } else if (type==EXTB_SHFL   ) {
            DISS_RD_RS1_RS2("shfl");
        } else if (type==EXTB_UNSHFL ) {
            DISS_RD_RS1_RS2("unshfl");
        } else if (type==EXTB_SHFLI  ) {
            DISS_RD_RS1_IMM6("shfli");
        } else if (type==EXTB_UNSHFLI) {
            DISS_RD_RS1_IMM6("unshfli");
        } else if (type==EXTB_BEXT   ) {
            DISS_RD_RS1_RS2("bext");
        } else if (type==EXTB_BDEP   ) {
            DISS_RD_RS1_RS2("bdep");
//        } else if (type==EXTB_NOT    ) {
//            DISS_RDP("c.not");

        // RISC-V XTernarybits Extension all
        //
        } else if (type==EXTB_CMIX  ) {
            DISS_RD_RS1_RS2_RS3("cmix");
        } else if (type==EXTB_CMOV  ) {
            DISS_RD_RS1_RS2_RS3("cmov");
        } else if (type==EXTB_FSL   ) {
            DISS_RD_RS1_RS2_RS3("fsl");
        } else if (type==EXTB_FSR   ) {
            DISS_RD_RS1_RS2_RS3("fsr");

        //
        // Additional Instructions all
        //
        } else if (type==EXTB_MIN    ) {
            DISS_RD_RS1_RS2("min");
        } else if (type==EXTB_MAX    ) {
            DISS_RD_RS1_RS2("max");
        } else if (type==EXTB_MINU   ) {
            DISS_RD_RS1_RS2("minu");
        } else if (type==EXTB_MAXU   ) {
            DISS_RD_RS1_RS2("maxu");
        } else if (type==EXTB_CLMUL      ) {
            DISS_RD_RS1_RS2("clmul");
        } else if (type==EXTB_CLMULR     ) {

        // Additions in version 0.90
        } else if (type==EXTB_GORCW) {
            DISS_RD_RS1_RS2("gorcw");
        } else if (type==EXTB_GREVW) {
            DISS_RD_RS1_RS2("grevw");
        } else if (type==EXTB_SLOW) {
            DISS_RD_RS1_RS2("slow");
        } else if (type==EXTB_SROW) {
            DISS_RD_RS1_RS2("srow");
        } else if (type==EXTB_ROLW) {
            DISS_RD_RS1_RS2("rolw");
        } else if (type==EXTB_RORW) {
            DISS_RD_RS1_RS2("rorw");
        } else if (type==EXTB_SBSETW) {
            DISS_RD_RS1_RS2("sbsetw");
        } else if (type==EXTB_SBCLRW) {
            DISS_RD_RS1_RS2("sbclrw");
        } else if (type==EXTB_SBINVW) {
            DISS_RD_RS1_RS2("sbinvw");
        } else if (type==EXTB_SBEXTW) {
            DISS_RD_RS1_RS2("sbextw");
        } else if (type==EXTB_GORCIW) {
            DISS_RD_RS1_IMM5("gorciw");
        } else if (type==EXTB_GREVIW) {
            DISS_RD_RS1_IMM5("greviw");
        } else if (type==EXTB_SLOIW) {
            DISS_RD_RS1_IMM5("sloiw");
        } else if (type==EXTB_SROIW) {
            DISS_RD_RS1_IMM5("sroiw");
        } else if (type==EXTB_RORIW) {
            DISS_RD_RS1_IMM5("roriw");
        } else if (type==EXTB_SBSETIW) {
            DISS_RD_RS1_IMM5("sbsetiw");
        } else if (type==EXTB_SBCLRIW) {
            DISS_RD_RS1_IMM5("sbclriw");
        } else if (type==EXTB_SBINVIW) {
            DISS_RD_RS1_IMM5("sbinviw");
        } else if (type==EXTB_FSLW) {
            DISS_RD_RS1_RS2_RS3("fslw");
        } else if (type==EXTB_FSRW) {
            DISS_RD_RS1_RS2_RS3("fsrw");
        } else if (type==EXTB_FSRIW) {
            DISS_RD_RS1_RS3_IMM5("fsriw");
        } else if (type==EXTB_CLZW) {
            DISS_RD_RS1("clzw");
        } else if (type==EXTB_CTZW) {
            DISS_RD_RS1("ctzw");
        } else if (type==EXTB_PCNTW) {
            DISS_RD_RS1("pcntw");
        } else if (type==EXTB_CLMULW) {
            DISS_RD_RS1_RS2("clmulw");
        } else if (type==EXTB_CLMULRW) {
            DISS_RD_RS1_RS2("clmulrw");
        } else if (type==EXTB_CLMULHW) {
            DISS_RD_RS1_RS2("clmulhw");
        } else if (type==EXTB_SHFLW) {
            DISS_RD_RS1_RS2("shflw");
        } else if (type==EXTB_UNSHFLW) {
            DISS_RD_RS1_RS2("unshflw");
        } else if (type==EXTB_BDEPW) {
            DISS_RD_RS1_RS2("bdepw");
        } else if (type==EXTB_BEXTW) {
            DISS_RD_RS1_RS2("bextw");
        } else if (type==EXTB_PACKW) {
            DISS_RD_RS1_RS2("packw");
        } else if (type==EXTB_BFPW) {
            DISS_RD_RS1_RS2("bfpw");

        } else if (type==EXTB_CLMULH     ) {
            DISS_RD_RS1_RS2("clmulh");
        } else if (type==EXTB_CRC32_B    ) {
            DISS_RD_RS1("crc32.b");
        } else if (type==EXTB_CRC32_H    ) {
            DISS_RD_RS1("crc32.h");
        } else if (type==EXTB_CRC32_W    ) {
            DISS_RD_RS1("crc32.w");
        } else if (type==EXTB_CRC32_D    ) {
            DISS_RD_RS1("crc32.d");
        } else if (type==EXTB_CRC32C_B   ) {
            DISS_RD_RS1("crc32c.b");
        } else if (type==EXTB_CRC32C_H   ) {
            DISS_RD_RS1("crc32c.h");
        } else if (type==EXTB_CRC32C_W   ) {
            DISS_RD_RS1("crc32c.w");
        } else if (type==EXTB_CRC32C_D   ) {
            DISS_RD_RS1("crc32c.d");
        } else if (type==EXTB_BMATXOR    ) {
            DISS_RD_RS1_RS2("bmatxor");
        } else if (type==EXTB_BFP        ) {
            DISS_RD_RS1_RS2("bfp");
        } else if (type==EXTB_BMATOR     ) {
            DISS_RD_RS1_RS2("bmator");
        } else if (type==EXTB_BMATFLIP ) {
            DISS_RD_RS1("bmatflip");

        } else {
            return 0;
        }

        return buffer;
    }

    return 0;
}

//
// Add documentation for Binary Manipulation instructions
//
// LCOV_EXCL_START
VMIOS_DOC_FN(doDoc) {
    vmiDocNodeP extb = vmidocAddSection(0, "Binary Manipulation Extensions");
    // description
    vmidocAddText(
        extb,
        "This is an  extension library to implement the initial definition of the Bit Manipulation instructions.");
    vmidocAddText(extb,"In order to enable the B extension library, the MISA.B bit must be set to 1");

    vmidocAddText(extb,"The Bit Manipulation defines the following:");

    vmidocAddText(extb,"RISC-V XBitmanip Extension (All - except pseudo instruction)");
    vmidocAddText(extb,"RISC-V XBit field Extension (None)");
    vmidocAddText(extb,"RISC-V XTernarybits Extension (All)");
    vmidocAddText(extb,"Additional Instructions (All)");

    vmiDocNodeP extb2 = vmidocAddSection(extb, "RISC-V XBitmanip Extension");
    vmidocAddText(extb2,"Count Leading/Trailing Zeros (clz, ctz)");
    vmidocAddText(extb2,"Count Bits Set (pcnt)");
    vmidocAddText(extb2,"And-with-complement (andn)");
    vmidocAddText(extb2,"Shift Ones (Left/Right) (slo, sloi, sro, sroi)");
    vmidocAddText(extb2,"Rotate (Left/Right) (rol, ror, rori)");
    vmidocAddText(extb2,"Generalized Reverse (grev, grevi)");
    vmidocAddText(extb2,"Generalized Shuffle (shfl, unshfl, shfli, unshfli)");
    vmidocAddText(extb2,"Bit Extract/Deposit (bext, bdep)");
    vmidocAddText(extb2,"Compressed instructions (c.not)");

    vmiDocNodeP extb4 = vmidocAddSection(extb, "RISC-V XTernarybits Extension");
    vmidocAddText(extb4,"Conditional mix (cmix)");
    vmidocAddText(extb4,"Conditional move (cmov)");
    vmidocAddText(extb4,"Funnel shift (fsl, fsr)");

    vmiDocNodeP extb5 = vmidocAddSection(extb, "Additional Instructions");
    vmidocAddText(extb5,"Min/max instructions (min, max, minu, maxu)");
    vmidocAddText(extb5,"Carry-less multiply (clmul, clmulh)");
    vmidocAddText(extb5,"CRC instructions (crc32.[bhwd], crc32c.[bhwd])");
    vmidocAddText(extb5,"Bit-matrix operations (bmatxor, bmator, bmatflip)");

    vmidocProcessor(processor, extb);
}
// LCOV_EXCL_STOP

////////////////////////////////////////////////////////////////////////////////
// INTERCEPT ATTRIBUTES
////////////////////////////////////////////////////////////////////////////////

vmiosAttr modelAttrs = {

    ////////////////////////////////////////////////////////////////////////
    // VERSION
    ////////////////////////////////////////////////////////////////////////

    .versionString = VMI_VERSION,           // version string
    .modelType     = VMI_INTERCEPT_LIBRARY, // type
    .packageName   = EXTB_REVISION,         // description
    .objectSize    = sizeof(vmiosObject),   // size in bytes of OSS object

    ////////////////////////////////////////////////////////////////////////
    // CONSTRUCTOR/DESTRUCTOR ROUTINES
    ////////////////////////////////////////////////////////////////////////

    .constructorCB = constructor,           // object constructor

    ////////////////////////////////////////////////////////////////////////
    // INSTRUCTION INTERCEPT ROUTINES
    ////////////////////////////////////////////////////////////////////////

    .morphCB       = doMorph,               // instruction morph callback
    .disCB         = doDisass,              // disassemble instruction

    ////////////////////////////////////////////////////////////////////////
    // PARAMETER CALLBACKS
    ////////////////////////////////////////////////////////////////////////

    .paramSpecsCB     = getParamSpecs,          // iterate parameter declarations
    .paramValueSizeCB = getParamTableSize,      // get parameter table size

    ////////////////////////////////////////////////////////////////////////////
    // DOCUMENTATION CALLBACKS
    ////////////////////////////////////////////////////////////////////////////

    .docCB         = doDoc,                 // construct documentation

    ////////////////////////////////////////////////////////////////////////
    // ADDRESS INTERCEPT DEFINITIONS
    ////////////////////////////////////////////////////////////////////////

    .intercepts    = {{0}}
};

