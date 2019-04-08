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

#define CPU_PREFIX "RISCV_EXTB"

#define EXTB_REVISION "extB Version(0.37-Draft) March 22 2019"

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
#define CU7(_I)   WIDTH(7,(_I)>>20)

DEFINE_S (riscv);

////////////////////////////////////////////////////////////////////////////////
// TYPES
////////////////////////////////////////////////////////////////////////////////

typedef struct vmiosObjectS {

    Bool enable;

    // handles for the RISCV GPRs
    vmiRegInfoCP riscvRegs[RISCV_GPR_NUM];

    // 32-bit temporaries
    Uns64  rs1, rs2, rs3, rd, tmp1, tmp2;
    vmiReg reg_rd, reg_rs1, reg_rs2, reg_rs3, reg_tmp1, reg_tmp2;

    Uns64  t0;
    vmiReg reg_t0;

    Uns32 cu5, cu7;

    Uns32 xlen;

    // enhanced instruction decode table
    vmidDecodeTableP table16, table32;

} vmiosObject;

// Define the attributes value structure
typedef struct paramValuesS {
    VMI_BOOL_PARAM(enable);
} paramValues, *paramValuesP;

//
// Define formals
//
static vmiParameter formals[] = {
    VMI_BOOL_PARAM_SPEC(paramValues, enable, 0, "Enable usage of the Bit Manipulation Instruction Extension"),
    VMI_END_PARAM
};

//
// Iterate formals
//
static VMIOS_PARAM_SPEC_FN(getParamSpecs) {
    if(!prev) {
        prev = formals;
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

typedef enum riscvExtBInstrType {
    // extension B 32bit Instructions
    EXTB_CLZ,
    EXTB_CTZ,
    EXTB_PCNT,
    EXTB_ANDC,
    EXTB_SLO,
    EXTB_SLOI,
    EXTB_SRO,
    EXTB_SROI,
    EXTB_ROL,
    EXTB_ROR,
    EXTB_RORI,
    EXTB_GREV,
    EXTB_GREVI,
    EXTB_SHFL,
    EXTB_UNSHFL,
    EXTB_SHFLI,
    EXTB_UNSHFLI,
    EXTB_BEXT,
    EXTB_BDEP,

    // extension B 16bit Instructions
    EXTB_NOT,
    EXTB_NEG,
    EXTB_BREV,

    // RISC-V XTernarybits Extension all
    EXT_CMIX,
    EXT_CMOV,
    EXT_FSL,
    EXT_FSR,

    // Additional Instructions all
    EXTB_MIN,
    EXTB_MAX,
    EXTB_MINU,
    EXTB_MAXU,
    EXTB_CLMUL,
    EXTB_CLMULH,
    EXTB_CRC32_B,
    EXTB_CRC32_H,
    EXTB_CRC32_W,
    EXTB_CRC32_D,
    EXTB_CRC32C_B,
    EXTB_CRC32C_H,
    EXTB_CRC32C_W,
    EXTB_CRC32C_D,
    EXTB_BMATXOR,
    EXTB_BMATOR,
    EXTB_BMATFLIP,

    // KEEP LAST: for sizing the array
    EXTB_LAST

} riscvExtBInstrType;

//
// Create the RISCV decode table
// https://github.com/cliffordwolf/xbitmanip/blob/master/opcodes.tex
// custom-0 0001011 = OP-IMM
// custom-1 0101011 = OP
static vmidDecodeTableP createDecodeTable32(void) {

    vmidDecodeTableP table = vmidNewDecodeTable(32, EXTB_LAST);

//    |  3                   2                   1                    |
//    |1 0 9 8 7 6 5 4 3 2 1 0 9 8 7 6 5 4 3 2 1 0 9 8 7 6 5 4 3 2 1 0|
//    |---------------------------------------------------------------|
//    |    funct7   |   rs2   |   rs1   |  f3 |    rd   |    opcode   |  R-type
//    |   rs3   | f2|   rs2   |   rs1   |  f3 |    rd   |    opcode   |  R4-type
//    |          imm          |   rs1   |  f3 |    rd   |    opcode   |  I-type
//    |---------------------------------------------------------------|

    //                         F7      RS2   RS1   F3  RD    OP
    DECODE_ENTRY(0, CLZ,      "|0110000|00000|.....|001|.....|0010011|"); // R-type
    DECODE_ENTRY(0, CTZ,      "|0110000|00001|.....|001|.....|0010011|"); // R-type
    DECODE_ENTRY(0, PCNT,     "|0110000|00010|.....|001|.....|0010011|"); // R-type
    DECODE_ENTRY(0, ANDC,     "|0000000|.....|.....|000|.....|0101011|"); // R-type (UNDEF)
    DECODE_ENTRY(0, SLO,      "|0010000|.....|.....|001|.....|0110011|"); // R-type
    DECODE_ENTRY(0, SRO,      "|0010000|.....|.....|101|.....|0110011|"); // R-type
    DECODE_ENTRY(0, SLOI,     "|00100|.......|.....|001|.....|0010011|"); // I-type
    DECODE_ENTRY(0, SROI,     "|00100|.......|.....|101|.....|0010011|"); // I-type
    DECODE_ENTRY(0, ROL,      "|0110000|.....|.....|001|.....|0110011|"); // R-type
    DECODE_ENTRY(0, ROR,      "|0110000|.....|.....|101|.....|0110011|"); // R-type
    DECODE_ENTRY(0, RORI,     "|01100|.......|.....|101|.....|0010011|"); // I-type
    DECODE_ENTRY(0, GREV,     "|0100000|.....|.....|001|.....|0110011|"); // R-type
    DECODE_ENTRY(0, GREVI,    "|01000|.......|.....|001|.....|0010011|"); // I-type
    DECODE_ENTRY(0, SHFL,     "|0000110|.....|.....|000|.....|0101011|"); // R-type (UNDEF)
    DECODE_ENTRY(0, UNSHFL,   "|0000111|.....|.....|000|.....|0101011|"); // R-type (UNDEF)
    DECODE_ENTRY(0, SHFLI,    "|10...|.......|.....|100|.....|0001011|"); // I-type (UNDEF)
    DECODE_ENTRY(0, UNSHFLI,  "|10...|.......|.....|101|.....|0001011|"); // I-type (UNDEF)
    DECODE_ENTRY(0, BEXT,     "|0001000|.....|.....|000|.....|0101011|"); // R-type (UNDEF)
    DECODE_ENTRY(0, BDEP,     "|0001001|.....|.....|000|.....|0101011|"); // R-type (UNDEF)
  //DECODE_ENTRY(0, CMIX,     "|.....|00|.....|.....|???|.....|???????|"); // R4-type (UNDEF)
  //DECODE_ENTRY(0, CMOV,     "|.....|01|.....|.....|???|.....|???????|"); // R4-type (UNDEF)
  //DECODE_ENTRY(0, FSL,      "|.....|10|.....|.....|???|.....|???????|"); // R4-type (UNDEF)
  //DECODE_ENTRY(0, FSR,      "|.....|11|.....|.....|???|.....|???????|"); // R4-type (UNDEF)
    DECODE_ENTRY(0, MIN,      "|0001010|.....|.....|000|.....|0101011|"); // R-type (UNDEF)
    DECODE_ENTRY(0, MAX,      "|0001011|.....|.....|000|.....|0101011|"); // R-type (UNDEF)
    DECODE_ENTRY(0, MINU,     "|0001100|.....|.....|000|.....|0101011|"); // R-type (UNDEF)
    DECODE_ENTRY(0, MAXU,     "|0001101|.....|.....|000|.....|0101011|"); // R-type (UNDEF)
  //DECODE_ENTRY(0, CLMUL,    "|???????|.....|.....|???|.....|0110011|"); // R-type (UNDEF)
  //DECODE_ENTRY(0, CLMULH,   "|???????|.....|.....|???|.....|0110011|"); // R-type (UNDEF)
    DECODE_ENTRY(0, CRC32_B,  "|0110000|10000|.....|001|.....|0010011|"); // R-type
    DECODE_ENTRY(0, CRC32_H,  "|0110000|10001|.....|001|.....|0010011|"); // R-type
    DECODE_ENTRY(0, CRC32_W,  "|0110000|10010|.....|001|.....|0010011|"); // R-type
    DECODE_ENTRY(0, CRC32_D,  "|0110000|10011|.....|001|.....|0010011|"); // R-type
    DECODE_ENTRY(0, CRC32C_B, "|0110000|11000|.....|001|.....|0010011|"); // R-type
    DECODE_ENTRY(0, CRC32C_H, "|0110000|11001|.....|001|.....|0010011|"); // R-type
    DECODE_ENTRY(0, CRC32C_W, "|0110000|11010|.....|001|.....|0010011|"); // R-type
    DECODE_ENTRY(0, CRC32C_D, "|0110000|11011|.....|001|.....|0010011|"); // R-type
  //DECODE_ENTRY(0, BMATXOR,  "|???????|.....|.....|???|.....|0110011|"); // R-type
  //DECODE_ENTRY(0, BMATOR,   "|???????|.....|.....|???|.....|0110011|"); // R-type
    DECODE_ENTRY(0, BMATFLIP, "|0110000|00011|.....|001|.....|0010011|"); // R-type

    return table;
}

static vmidDecodeTableP createDecodeTable16(void) {

    vmidDecodeTableP table = vmidNewDecodeTable(16, EXTB_LAST);

    //
    // handle instruction
    //                      F3  ??  R         OP
    DECODE_ENTRY(0, NEG,  "|011|000|...|00000|01|");
    DECODE_ENTRY(0, NOT,  "|011|001|...|00000|01|");
    DECODE_ENTRY(0, BREV, "|011|010|...|00000|01|");

    return table;
}

//
// Decode an extended instruction at the indicated address, or return
// EXTB_LAST if this is not an extended B instruction.
//
static riscvExtBInstrType getInstrType(
    vmiosObjectP  object,
    vmiProcessorP processor,
    Addr          thisPC,
    Uns32        *instruction
) {

    Uns16 quadrant = vmicxtFetch2Byte(processor, thisPC);
    Bool  is16bit  = ((quadrant & 0x3) != 0x3);
    Bool  is32bit  = ((quadrant & 0x3) == 0x3);

    riscvExtBInstrType type  = EXTB_LAST;

    if (is16bit) {
        *instruction = vmicxtFetch2Byte(processor, thisPC);
        type = vmidDecode(object->table16, *instruction);

    } else if (is32bit) {
        *instruction = vmicxtFetch4Byte(processor, thisPC);
        type = vmidDecode(object->table32, *instruction);

    } else {
        // error
        vmiPrintf("!16bit && !32bit\n");
        VMI_ABORT("getInstrType ? bytes");
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

    vmiMessage("I", CPU_PREFIX, "%s", EXTB_REVISION);
    Uns32 i;

    paramValuesP params = parameterValues;
    object->enable = params->enable;

    object->xlen = 32;  // TBD

    // get handles to the RISCV GPRs
    for(i=0; i<RISCV_GPR_NUM; i++) {
        object->riscvRegs[i] = vmiosGetRegDesc(processor, map[i]);
    }

    // create enhanced instruction decoder
    object->table16 = createDecodeTable16();
    object->table32 = createDecodeTable32();
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
    BM_COMP = 0x40,

    BM_MIN  = BM_RS1 | BM_RS2,
    BM_TERN = BM_RS1 | BM_RS2 | BM_RS3,
    BM_ALL  = BM_RS1 | BM_RS2 | BM_TMP1 | BM_TMP2
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
    object->rs3 = RS3(instruction);
    object->t0  = 5;
    object->cu5 = CU5(instruction);
    object->cu7 = CU7(instruction);

    object->reg_rs1  = vmimtGetExtReg(processor,  &object->rs1);
    object->reg_rs2  = vmimtGetExtReg(processor,  &object->rs2);
    object->reg_rd   = vmimtGetExtReg(processor,  &object->rd);
    if ((mask & BM_ALL) == BM_ALL) {
        object->reg_tmp1 = vmimtGetExtTemp(processor, &object->tmp1);
        object->reg_tmp2 = vmimtGetExtTemp(processor, &object->tmp2);
    }
    if ((mask & BM_TERN) == BM_TERN) {
        object->reg_rs3 = vmimtGetExtTemp(processor, &object->rs3);
        object->reg_t0  = vmimtGetExtTemp(processor, &object->t0);
    }

    vmimtGetR(processor, object->xlen, object->reg_rd,  object->riscvRegs[object->rd]);
    vmimtGetR(processor, object->xlen, object->reg_rs1, object->riscvRegs[object->rs1]);
    vmimtGetR(processor, object->xlen, object->reg_rs2, object->riscvRegs[object->rs2]);
    vmimtGetR(processor, object->xlen, object->reg_rs3, object->riscvRegs[object->rs3]);
}

static void regEpilog (
    vmiProcessorP processor,
    vmiosObjectP  object,
    Uns32         instruction
) {
    vmimtSetR(processor, object->xlen, object->riscvRegs[object->rd], object->reg_rd);
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
    regProlog(processor, object, instruction, BM_MIN);
    vmimtUnopRR(object->xlen, vmi_CLZ, object->reg_rd, object->reg_rs1, 0);
    regEpilog(processor, object, instruction);
}

EXTB_MORPH_FN(emitCTZ) {
    regProlog(processor, object, instruction, BM_MIN);
    vmimtUnopRR(object->xlen, vmi_CTZ, object->reg_rd, object->reg_rs1, 0);
    regEpilog(processor, object, instruction);
}

EXTB_MORPH_FN(emitPCNT) {
    regProlog(processor, object, instruction, BM_MIN);
    vmimtUnopRR(object->xlen, vmi_CNTO, object->reg_rd, object->reg_rs1, 0);
    regEpilog(processor, object, instruction);
}

EXTB_MORPH_FN(emitANDC) {
    regProlog(processor, object, instruction, BM_MIN);
    vmimtBinopRRR(object->xlen, vmi_ANDN, object->reg_rd, object->reg_rs1, object->reg_rs2, 0);
    regEpilog(processor, object, instruction);
}

EXTB_MORPH_FN(emitSLO) {
    regProlog(processor, object, instruction, BM_ALL);
    vmimtBinopRRR(object->xlen, vmi_SHL, object->reg_rd, object->reg_rs1, object->reg_rs2, 0);
    // tmp1 = FFFFFFFF
    vmimtMoveRC(object->xlen, object->reg_tmp1, -1);
    // tmp2(FFFFFFFF) >> SHR amount
    vmimtBinopRRC(object->xlen, vmi_AND, object->reg_tmp2, object->reg_rs2, (object->xlen - 1), 0);
    vmimtBinopRCR(object->xlen, vmi_SUB, object->reg_tmp2, object->xlen, object->reg_tmp2, 0);
    // tmp1 >> (object->xlen - tmp2)
    vmimtSetShiftMask((object->xlen*2) - 1);
    vmimtBinopRR(object->xlen, vmi_SHR, object->reg_tmp1, object->reg_tmp2, 0);
    // rd |= tmp1
    vmimtBinopRR(object->xlen, vmi_OR, object->reg_rd, object->reg_tmp1, 0);
    regEpilog(processor, object, instruction);
}

EXTB_MORPH_FN(emitSLOI) {
    regProlog(processor, object, instruction, BM_MIN);

    // SH and ONES
    Uns32 shamt = (object->xlen == 32) ? (object->cu7 & 0x1f) : object->cu7;
    Uns64 ones  = 0;
    if (shamt) {
        if (object->xlen == 32) {
            ones = (Uns32)-1 >> (object->xlen - shamt);
        } else {
            ones = (Uns64)-1 >> (object->xlen - shamt);
        }
    }

    vmimtBinopRRC(object->xlen, vmi_SHL, object->reg_rd, object->reg_rs1, shamt, 0);
    vmimtBinopRC(object->xlen, vmi_OR, object->reg_rd, ones, 0);
    regEpilog(processor, object, instruction);
}

EXTB_MORPH_FN(emitSRO) {
    regProlog(processor, object, instruction, BM_ALL);
    vmimtBinopRRR(object->xlen, vmi_SHR, object->reg_rd, object->reg_rs1, object->reg_rs2, 0);
    // tmp1 = FFFFFFFF
    vmimtMoveRC(object->xlen, object->reg_tmp1, -1);
    // tmp2 = SHL amount
    vmimtBinopRRC(object->xlen, vmi_AND, object->reg_tmp2, object->reg_rs2, (object->xlen - 1), 0);
    vmimtBinopRCR(object->xlen, vmi_SUB, object->reg_tmp2, object->xlen, object->reg_tmp2, 0);
    // tmp1 >> (object->xlen - tmp2)
    vmimtSetShiftMask((object->xlen*2) - 1);
    vmimtBinopRR(object->xlen, vmi_SHL, object->reg_tmp1, object->reg_tmp2, 0);
    // rd |= tmp1
    vmimtBinopRR(object->xlen, vmi_OR, object->reg_rd, object->reg_tmp1, 0);
    regEpilog(processor, object, instruction);
}

EXTB_MORPH_FN(emitSROI) {
    regProlog(processor, object, instruction, BM_MIN);

    // SH and ONES
    Uns32 shamt = (object->xlen == 32) ? (object->cu7 & 0x1f) : object->cu7;
    Uns64 ones  = 0;
    if (shamt) {
        if (object->xlen == 32) {
            ones = (Uns32)-1 << (object->xlen - shamt);
        } else {
            ones = (Uns64)-1 << (object->xlen - shamt);
        }
    }

    vmimtBinopRRC(object->xlen, vmi_SHR, object->reg_rd, object->reg_rs1, shamt, 0);
    vmimtBinopRC(object->xlen, vmi_OR, object->reg_rd, ones, 0);
    regEpilog(processor, object, instruction);
}

EXTB_MORPH_FN(emitROL) {
    regProlog(processor, object, instruction, BM_MIN);
    vmimtBinopRRR(object->xlen, vmi_ROL, object->reg_rd, object->reg_rs1, object->reg_rs2, 0);
    regEpilog(processor, object, instruction);
}

EXTB_MORPH_FN(emitROR) {
    regProlog(processor, object, instruction, BM_MIN);
    vmimtBinopRRR(object->xlen, vmi_ROR, object->reg_rd, object->reg_rs1, object->reg_rs2, 0);
    regEpilog(processor, object, instruction);
}

EXTB_MORPH_FN(emitRORI) {
    regProlog(processor, object, instruction, BM_MIN);
    vmimtBinopRRC(object->xlen, vmi_ROR, object->reg_rd, object->reg_rs1, object->cu7, 0);
    regEpilog(processor, object, instruction);
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

EXTB_MORPH_FN(emitGREV) {
    regProlog(processor, object, instruction, BM_ALL);
    vmimtArgReg(object->xlen, object->reg_rs1);
    vmimtArgReg(object->xlen, object->reg_rs2);
    if (object->xlen == 32) {
        vmimtCallResult((vmiCallFn)grev32_c, object->xlen, object->reg_rd);
    } else {
        vmimtCallResult((vmiCallFn)grev64_c, object->xlen, object->reg_rd);
    }
    regEpilog(processor, object, instruction);
}

EXTB_MORPH_FN(emitGREVI) {
    regProlog(processor, object, instruction, BM_ALL);
    vmimtArgReg(object->xlen, object->reg_rs1);
    if (object->xlen == 32) {
        vmimtArgUns32(object->cu7);
        vmimtCallResult((vmiCallFn)grev32_c, object->xlen, object->reg_rd);
    } else {
        vmimtArgUns64(object->cu7);
        vmimtCallResult((vmiCallFn)grev64_c, object->xlen, object->reg_rd);
    }
    regEpilog(processor, object, instruction);
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

EXTB_MORPH_FN(emitSHFL) {
    regProlog(processor, object, instruction, BM_MIN);
    vmimtArgReg(object->xlen, object->reg_rs1);
    vmimtArgReg(object->xlen, object->reg_rs2);
    if (object->xlen == 32) {
        vmimtCallResult((vmiCallFn)shfl32_c, object->xlen, object->reg_rd);
    } else {
        vmimtCallResult((vmiCallFn)shfl64_c, object->xlen, object->reg_rd);
    }
    regEpilog(processor, object, instruction);
}

EXTB_MORPH_FN(emitUNSHFL) {
    regProlog(processor, object, instruction, BM_MIN);
    vmimtArgReg(object->xlen, object->reg_rs1);
    vmimtArgReg(object->xlen, object->reg_rs2);
    if (object->xlen == 32) {
        vmimtCallResult((vmiCallFn)unshfl32_c, object->xlen, object->reg_rd);
    } else {
        vmimtCallResult((vmiCallFn)unshfl64_c, object->xlen, object->reg_rd);
    }
    regEpilog(processor, object, instruction);
}

EXTB_MORPH_FN(emitSHFLI) {
    regProlog(processor, object, instruction, BM_ALL);
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
    regProlog(processor, object, instruction, BM_ALL);
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
Uns32 bext32_c(Uns32 rs1, Uns32 rs2) {
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
Uns64 bext64_c(Uns64 rs1, Uns64 rs2) {
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
Uns32 bdep32_c(Uns32 rs1, Uns32 rs2) {
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
Uns64 bdep64_c(Uns64 rs1, Uns64 rs2) {
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

EXTB_MORPH_FN(emitBEXT) {
    regProlog(processor, object, instruction, BM_MIN);
    vmimtArgReg(object->xlen, object->reg_rs1);
    vmimtArgReg(object->xlen, object->reg_rs2);
    if (object->xlen == 32) {
        vmimtCallResult((vmiCallFn)bext32_c, object->xlen, object->reg_rd);
    } else {
        vmimtCallResult((vmiCallFn)bext64_c, object->xlen, object->reg_rd);
    }
    regEpilog(processor, object, instruction);
}

EXTB_MORPH_FN(emitBDEP) {
    regProlog(processor, object, instruction, BM_MIN);
    vmimtArgReg(object->xlen, object->reg_rs1);
    vmimtArgReg(object->xlen, object->reg_rs2);
    if (object->xlen == 32) {
        vmimtCallResult((vmiCallFn)bdep32_c, object->xlen, object->reg_rd);
    } else {
        vmimtCallResult((vmiCallFn)bdep64_c, object->xlen, object->reg_rd);
    }
    regEpilog(processor, object, instruction);
}

EXTB_MORPH_FN(emitCNOT) {
    regProlog(processor, object, instruction, BM_COMP);
    vmimtUnopRR(object->xlen, vmi_NOT, object->reg_rd, object->reg_rd, 0);
    regEpilog(processor, object, instruction);
}

EXTB_MORPH_FN(emitCNEG) {
    regProlog(processor, object, instruction, BM_COMP);
    vmimtUnopRR(object->xlen, vmi_NEG, object->reg_rd, object->reg_rd, 0);
    regEpilog(processor, object, instruction);
}

EXTB_MORPH_FN(emitCBREV) {
    regProlog(processor, object, instruction, BM_COMP);
    vmimtArgReg(object->xlen, object->reg_rd);
    if (object->xlen == 32) {
        vmimtArgUns32(-1);
        vmimtCallResult((vmiCallFn)grev32_c, object->xlen, object->reg_rd);
    } else {
        vmimtArgUns64(-1);
        vmimtCallResult((vmiCallFn)grev64_c, object->xlen, object->reg_rd);
    }
    regEpilog(processor, object, instruction);
}

EXTB_MORPH_FN(emitCMIX) {
    regProlog(processor, object, instruction, BM_TERN);
    vmimtBinopRRR(object->xlen, vmi_AND,  object->reg_rd, object->reg_rs1, object->reg_rs3, 0);
    vmimtBinopRRR(object->xlen, vmi_ANDN, object->reg_t0, object->reg_rs1, object->reg_rs3, 0);
    vmimtBinopRR(object->xlen,  vmi_OR,   object->reg_rd, object->reg_t0, 0);
    regEpilog(processor, object, instruction);

    vmimtSetR(processor, object->xlen, object->riscvRegs[object->t0], object->reg_t0);
}

EXTB_MORPH_FN(emitCMOV) {
    regProlog(processor, object, instruction, BM_TERN);
    vmimtCompareRC(object->xlen, vmi_COND_EQ, object->reg_rs3, 0, object->reg_tmp1);
    vmimtCondMoveRRR(object->xlen, object->reg_tmp1, True, object->reg_rd, object->reg_rs1, object->reg_rs2);
    regEpilog(processor, object, instruction);
}

Uns32 fsl32_c(Uns32 rs1, Uns32 rs2, Uns32 rs3) {
    Int32 XLEN = 32;
    Int32 shamt = rs2 & (2*XLEN - 1);
    Uns32 A = rs1, B = rs3;
    if (shamt >= XLEN) {
        shamt -= XLEN; A = rs3; B = rs1;
    }
    return shamt ? (A << shamt) | (B >> (XLEN-shamt)) : A;
}

Uns64 fsl64_c(Uns64 rs1, Uns64 rs2, Uns64 rs3) {
    Int64 XLEN = 64;
    Int64 shamt = rs2 & (2*XLEN - 1);
    Uns64 A = rs1, B = rs3;
    if (shamt >= XLEN) {
        shamt -= XLEN; A = rs3; B = rs1;
    }
    return shamt ? (A << shamt) | (B >> (XLEN-shamt)) : A;
}

// TBD - need pseudo code
EXTB_MORPH_FN(emitFSL) {
    regProlog(processor, object, instruction, BM_TERN);
    vmimtArgReg(object->xlen, object->reg_rs1);
    vmimtArgReg(object->xlen, object->reg_rs2);
    vmimtArgReg(object->xlen, object->reg_rs3);
    if (object->xlen == 32) {
        vmimtCallResult((vmiCallFn)fsl32_c, object->xlen, object->reg_rd);
    } else {
        vmimtCallResult((vmiCallFn)fsl64_c, object->xlen, object->reg_rd);
    }
    regEpilog(processor, object, instruction);
}

Uns32 fsr32_c(Uns32 rs1, Uns32 rs2, Uns32 rs3) {
    Int32 XLEN = 32;
    Int32 shamt = rs2 & (2*XLEN - 1);
    Uns32 A = rs1, B = rs3;
    if (shamt >= XLEN) {
        shamt -= XLEN; A = rs3; B = rs1;
    }
    return shamt ? (A >> shamt) | (B << (XLEN-shamt)) : A;
}

Uns64 fsr64_c(Uns64 rs1, Uns64 rs2, Uns64 rs3) {
    Int64 XLEN = 32;
    Int64 shamt = rs2 & (2*XLEN - 1);
    Uns64 A = rs1, B = rs3;
    if (shamt >= XLEN) {
        shamt -= XLEN; A = rs3; B = rs1;
    }
    return shamt ? (A >> shamt) | (B << (XLEN-shamt)) : A;
}

// TBD - need pseudo code
EXTB_MORPH_FN(emitFSR) {
    regProlog(processor, object, instruction, BM_TERN);
    vmimtArgReg(object->xlen, object->reg_rs1);
    vmimtArgReg(object->xlen, object->reg_rs2);
    vmimtArgReg(object->xlen, object->reg_rs3);
    if (object->xlen == 32) {
        vmimtCallResult((vmiCallFn)fsr32_c, object->xlen, object->reg_rd);
    } else {
        vmimtCallResult((vmiCallFn)fsr64_c, object->xlen, object->reg_rd);
    }
    regEpilog(processor, object, instruction);
}

EXTB_MORPH_FN(emitMIN) {
    regProlog(processor, object, instruction, BM_ALL);
    vmimtCompareRR(object->xlen, vmi_COND_L, object->reg_rs1, object->reg_rs2, object->reg_tmp1);
    vmimtCondMoveRRR(object->xlen, object->reg_tmp1, True, object->reg_rd, object->reg_rs1, object->reg_rs2);
    regEpilog(processor, object, instruction);
}

EXTB_MORPH_FN(emitMAX) {
    regProlog(processor, object, instruction, BM_ALL);
    vmimtCompareRR(object->xlen, vmi_COND_NL, object->reg_rs1, object->reg_rs2, object->reg_tmp1);
    vmimtCondMoveRRR(object->xlen, object->reg_tmp1, True, object->reg_rd, object->reg_rs1, object->reg_rs2);
    regEpilog(processor, object, instruction);
}

EXTB_MORPH_FN(emitMINU) {
    regProlog(processor, object, instruction, BM_ALL);
    vmimtCompareRR(object->xlen, vmi_COND_B, object->reg_rs1, object->reg_rs2, object->reg_tmp1);
    vmimtCondMoveRRR(object->xlen, object->reg_tmp1, True, object->reg_rd, object->reg_rs1, object->reg_rs2);
    regEpilog(processor, object, instruction);
}

EXTB_MORPH_FN(emitMAXU) {
    regProlog(processor, object, instruction, BM_ALL);
    vmimtCompareRR(object->xlen, vmi_COND_NB, object->reg_rs1, object->reg_rs2, object->reg_tmp1);
    vmimtCondMoveRRR(object->xlen, object->reg_tmp1, True, object->reg_rd, object->reg_rs1, object->reg_rs2);
    regEpilog(processor, object, instruction);
}

Uns32 clmul32_c(Uns32 rs1, Uns32 rs2) {
    Uns32 x = 0;
    Uns32 i;
    for (i = 0; i < 32; i++) {
        if ((rs2 >> i) & 1) {
            x ^= rs1 << i;
        }
    }
    return x;
}
Uns64 clmul64_c(Uns64 rs1, Uns64 rs2) {
    Uns64 x = 0;
    Uns32 i;
    for (i = 0; i < 32; i++) {
        if ((rs2 >> i) & 1) {
            x ^= rs1 << i;
        }
    }
    return x;
}
EXTB_MORPH_FN(emitCLMUL) {
    regProlog(processor, object, instruction, BM_MIN);
    vmimtArgReg(object->xlen, object->reg_rs1);
    vmimtArgReg(object->xlen, object->reg_rs2);
    if (object->xlen == 32) {
        vmimtCallResult((vmiCallFn)clmul32_c, object->xlen, object->reg_rd);
    } else {
        vmimtCallResult((vmiCallFn)clmul64_c, object->xlen, object->reg_rd);
    }
    regEpilog(processor, object, instruction);
}

Uns32 clmulh32_c(Uns32 rs1, Uns32 rs2) {
    Uns32 x = 0;
    Uns32 i;
    for (i = 1; i < 32; i++) {
        if ((rs2 >> i) & 1) {
            x ^= rs1 >> (32-i);
        }
    }
    return x;
}
Uns64 clmulh64_c(Uns64 rs1, Uns64 rs2) {
    Uns64 x = 0;
    Uns32 i;
    for (i = 1; i < 32; i++) {
        if ((rs2 >> i) & 1) {
            x ^= rs1 >> (32-i);
        }
    }
    return x;
}
EXTB_MORPH_FN(emitCLMULH) {
    regProlog(processor, object, instruction, BM_MIN);
    vmimtArgReg(object->xlen, object->reg_rs1);
    vmimtArgReg(object->xlen, object->reg_rs2);
    if (object->xlen == 32) {
        vmimtCallResult((vmiCallFn)clmulh32_c, object->xlen, object->reg_rd);
    } else {
        vmimtCallResult((vmiCallFn)clmulh64_c, object->xlen, object->reg_rd);
    }
    regEpilog(processor, object, instruction);
}

Uns32 crc32_c(Uns32 x, Uns32 nbits) {
    Uns32 i;
    for (i = 0; i < nbits; i++) {
        x = (x >> 1) ^ (0xEDB88320 & ~((x&1)-1));
    }
    return x;
}
Uns64 crc64_c(Uns64 x, Uns32 nbits) {
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
    regProlog(processor, object, instruction, BM_MIN);
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

Uns32 crc32c_c(Uns32 x, Uns32 nbits) {
    Uns32 i;
    for (i = 0; i < nbits; i++) {
        x = (x >> 1) ^ (0x82F63B78 & ~((x&1)-1));
    }
    return x;
}
Uns64 crc64c_c(Uns64 x, Uns32 nbits) {
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
    regProlog(processor, object, instruction, BM_MIN);
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

Uns64 fast_pcnt64_c(Uns64 rs1) {
    return __builtin_popcountll(rs1);
}
Uns64 bmatflip64_c(Uns64 rs1) {
    Uns64 x = rs1;
    x = shfl64_c(x, 31);
    x = shfl64_c(x, 31);
    x = shfl64_c(x, 31);
    return x;
}
Uns64 bmatxor64_c(Uns64 rs1, Uns64 rs2) {
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
    regProlog(processor, object, instruction, BM_MIN);
    vmimtArgReg(object->xlen, object->reg_rs1);
    vmimtArgReg(object->xlen, object->reg_rs2);
    if (object->xlen == 64) {
        vmimtCallResult((vmiCallFn)bmatxor64_c, object->xlen, object->reg_rd);
    }
    regEpilog(processor, object, instruction);
}

Uns64 bmator64_c(Uns64 rs1, Uns64 rs2) {
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
    regProlog(processor, object, instruction, BM_MIN);
    vmimtArgReg(object->xlen, object->reg_rs1);
    vmimtArgReg(object->xlen, object->reg_rs2);
    if (object->xlen == 64) {
        vmimtCallResult((vmiCallFn)bmator64_c, object->xlen, object->reg_rd);
    }
    regEpilog(processor, object, instruction);
}

EXTB_MORPH_FN(emitBMATFLIP) {
    regProlog(processor, object, instruction, BM_MIN);
    vmimtArgReg(object->xlen, object->reg_rs1);
    if (object->xlen == 64) {
        vmimtCallResult((vmiCallFn)bmatflip64_c, object->xlen, object->reg_rd);
    }
    regEpilog(processor, object, instruction);
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
    Uns32 instruction;
    riscvExtBInstrType type = getInstrType(object, processor, thisPC, &instruction);

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
    } else if (type==EXTB_ANDC   ) {
        emitANDC(processor, object, instruction);
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
    } else if (type==EXTB_GREV   ) {
        emitGREV(processor, object, instruction);
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
    } else if (type==EXTB_BDEP   ) {
        emitBDEP(processor, object, instruction);
    } else if (type==EXTB_NOT    ) {
        emitCNOT(processor, object, instruction);
    } else if (type==EXTB_NEG    ) {
        emitCNEG(processor, object, instruction);
    } else if (type==EXTB_BREV   ) {
        emitCBREV(processor, object, instruction);

    //
    // RISC-V XTernarybits Extension all
    //
    } else if (type==EXT_CMIX  ) {
        emitCMIX(processor, object, instruction);
    } else if (type==EXT_CMOV  ) {
        emitCMOV(processor, object, instruction);
    } else if (type==EXT_FSL   ) {
        emitFSL(processor, object, instruction);
    } else if (type==EXT_FSR   ) {
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
    } else if (type==EXTB_BMATXOR    ) {
        emitBMATXOR(processor, object, instruction);
    } else if (type==EXTB_BMATOR     ) {
        emitBMATOR(processor, object, instruction);
    } else if (type==EXTB_BMATFLIP ) {
        emitBMATFLIP(processor, object, instruction);

    } else {
        *opaque = False;
    }

    // no intercept callback specified
    return 0;
}

//
// Disassembler callback disassembling instructions
//
static void diss_addr(Uns32 xlen, Addr thisPC, char **bufferP, Uns32 instruction, vmiDisassAttrs attrs) {
    if (!(attrs & DSA_UNCOOKED)) {
        if (xlen == 32) {
            *bufferP += sprintf(*bufferP, FMT_6408x " ", thisPC);
        } else {
            *bufferP += sprintf(*bufferP, FMT_640Nx " ", thisPC);
        }
    }
}

static void diss_rdp(vmiosObjectP object, Addr thisPC, char *buffer, char *name, Uns32 instruction, vmiDisassAttrs attrs) {
    Uns32 rd  = RDp(instruction);

    diss_addr(object->xlen, thisPC, &buffer, instruction, attrs);
    sprintf(buffer, "%-7s %s", name, map[rd]);
}
#define DISS_RDP(NAME) diss_rdp(object, thisPC, buffer, NAME, instruction, attrs)

static void diss_rd_rs1(vmiosObjectP object, Addr thisPC, char *buffer, char *name, Uns32 instruction, vmiDisassAttrs attrs) {
    Uns32 rd  = RD(instruction);
    Uns32 rs1 = RS1(instruction);

    diss_addr(object->xlen, thisPC, &buffer, instruction, attrs);
    sprintf(buffer, "%-7s %s,%s", name, map[rd], map[rs1]);
}
#define DISS_RD_RS1(NAME) diss_rd_rs1(object, thisPC, buffer, NAME, instruction, attrs)

static void diss_rd_rs1_rs2(vmiosObjectP object, Addr thisPC, char *buffer, char *name, Uns32 instruction, vmiDisassAttrs attrs) {
    Uns32 rd  = RD(instruction);
    Uns32 rs1 = RS1(instruction);
    Uns32 rs2 = RS2(instruction);

    diss_addr(object->xlen, thisPC, &buffer, instruction, attrs);
    sprintf(buffer, "%-7s %s,%s,%s", name, map[rd], map[rs1], map[rs2]);
}
#define DISS_RD_RS1_RS2(NAME) diss_rd_rs1_rs2(object, thisPC, buffer, NAME, instruction, attrs)

static void diss_rd_rs1_rs2_rs3(vmiosObjectP object, Addr thisPC, char *buffer, char *name, Uns32 instruction, vmiDisassAttrs attrs) {
    Uns32 rd  = RD(instruction);
    Uns32 rs1 = RS1(instruction);
    Uns32 rs2 = RS2(instruction);
    Uns32 rs3 = RS3(instruction);

    diss_addr(object->xlen, thisPC, &buffer, instruction, attrs);
    sprintf(buffer, "%-7s %s,%s,%s,%s", name, map[rd], map[rs1], map[rs2], map[rs3]);
}
#define DISS_RD_RS1_RS2_RS3(NAME) diss_rd_rs1_rs2_rs3(object, thisPC, buffer, NAME, instruction, attrs)

static void diss_rd_rs1_imm7(vmiosObjectP object, Addr thisPC, char *buffer, char *name, Uns32 instruction, vmiDisassAttrs attrs) {
    Uns32 rd  = RD(instruction);
    Uns32 rs1 = RS1(instruction);
    Uns32 cu7 = CU7(instruction);

    diss_addr(object->xlen, thisPC, &buffer, instruction, attrs);
    sprintf(buffer, "%-7s %s,%s,%u", name, map[rd], map[rs1], cu7);
}
#define DISS_RD_RS1_IMM7(NAME) diss_rd_rs1_imm7(object, thisPC, buffer, NAME, instruction, attrs)

static VMIOS_DISASSEMBLE_FN(doDisass) {

    // decode the instruction to get the type
    Uns32 instruction;
    riscvExtBInstrType type = getInstrType(object, processor, thisPC, &instruction);

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
        } else if (type==EXTB_ANDC   ) {
            DISS_RD_RS1_RS2("andc");
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
        } else if (type==EXTB_GREV   ) {
            DISS_RD_RS1_RS2("grev");
        } else if (type==EXTB_GREVI  ) {
            DISS_RD_RS1_IMM7("grevi");
        } else if (type==EXTB_SHFL   ) {
            DISS_RD_RS1_RS2("shfl");
        } else if (type==EXTB_UNSHFL ) {
            DISS_RD_RS1_RS2("unshfl");
        } else if (type==EXTB_SHFLI  ) {
            DISS_RD_RS1_IMM7("shfli");
        } else if (type==EXTB_UNSHFLI) {
            DISS_RD_RS1_IMM7("unshfli");
        } else if (type==EXTB_BEXT   ) {
            DISS_RD_RS1_RS2("bext");
        } else if (type==EXTB_BDEP   ) {
            DISS_RD_RS1_RS2("bdep");

        //
        // Compressed TBD
        //
        } else if (type==EXTB_NOT    ) {
            DISS_RDP("c.not");
        } else if (type==EXTB_NEG    ) {
            DISS_RDP("c.neg");
        } else if (type==EXTB_BREV   ) {
            DISS_RDP("c.brev");

        //
        // RISC-V XTernarybits Extension all
        //
        } else if (type==EXT_CMIX  ) {
            DISS_RD_RS1_RS2_RS3("cmix");
        } else if (type==EXT_CMOV  ) {
            DISS_RD_RS1_RS2_RS3("cmov");
        } else if (type==EXT_FSL   ) {
            DISS_RD_RS1_RS2_RS3("fsl");
        } else if (type==EXT_FSR   ) {
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
        } else if (type==EXTB_BMATOR     ) {
            DISS_RD_RS1_RS2("bmator");
        } else if (type==EXTB_BMATFLIP ) {
            DISS_RD_RS1("bmatflip");
        } else {
            VMI_ABORT("Invalid decode");
        }

        return buffer;
    }

    return 0;
}

//
// Add documentation for Binary Manipulation instructions
//
VMIOS_DOC_FN(doDoc) {
    vmiDocNodeP extb = vmidocAddSection(0, "Binary Manipulation Extensions");
    // description
    vmidocAddText(
        extb,
        "This is an  extension library to implement the initial definition of the Bit Manipulation instructions.");
    vmidocAddText(extb,"In order to enable the B extension library, the enable parameter must be set to True");

    vmidocAddText(extb,"The Bit Manipulation defines the following:");

    vmidocAddText(extb,"RISC-V XBitmanip Extension (All - except pseudo instruction)");
    vmidocAddText(extb,"RISC-V XBit field Extension (None)");
    vmidocAddText(extb,"RISC-V XTernarybits Extension (All)");
    vmidocAddText(extb,"Additional Instructions (All)");

    vmiDocNodeP extb2 = vmidocAddSection(extb, "RISC-V XBitmanip Extension");
    vmidocAddText(extb2,"Count Leading/Trailing Zeros (clz, ctz)");
    vmidocAddText(extb2,"Count Bits Set (pcnt)");
    vmidocAddText(extb2,"And-with-complement (andc)");
    vmidocAddText(extb2,"Shift Ones (Left/Right) (slo, sloi, sro, sroi)");
    vmidocAddText(extb2,"Rotate (Left/Right) (rol, ror, rori)");
    vmidocAddText(extb2,"Generalized Reverse (grev, grevi)");
    vmidocAddText(extb2,"Generalized Shuffle (shfl, unshfl, shfli, unshfli)");
    vmidocAddText(extb2,"Bit Extract/Deposit (bext, bdep)");
    vmidocAddText(extb2,"Compressed instructions (c.not, c.neg, c.brev)");

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
    // PARAMETER CALLBACKS
    ////////////////////////////////////////////////////////////////////////

    .paramSpecsCB     = getParamSpecs,          // iterate parameter declarations
    .paramValueSizeCB = getParamTableSize,      // get parameter table size

    ////////////////////////////////////////////////////////////////////////
    // INSTRUCTION INTERCEPT ROUTINES
    ////////////////////////////////////////////////////////////////////////

    .morphCB       = doMorph,               // instruction morph callback
    .disCB         = doDisass,              // disassemble instruction

    ////////////////////////////////////////////////////////////////////////////
    // DOCUMENTATION CALLBACKS
    ////////////////////////////////////////////////////////////////////////////

    .docCB         = doDoc,                 // construct documentation

    ////////////////////////////////////////////////////////////////////////
    // ADDRESS INTERCEPT DEFINITIONS
    ////////////////////////////////////////////////////////////////////////

    .intercepts    = {{0}}
};

