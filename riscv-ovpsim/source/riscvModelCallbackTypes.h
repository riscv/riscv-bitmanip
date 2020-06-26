/*
 * Copyright (c) 2005-2020 Imperas Software Ltd., www.imperas.com
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

#pragma once

// VMI header files
#include "hostapi/impTypes.h"

// model header files
#include "riscvCSRTypes.h"
#include "riscvRegisterTypes.h"
#include "riscvTypes.h"
#include "riscvTypeRefs.h"
#include "riscvVariant.h"


////////////////////////////////////////////////////////////////////////////////
// INSTRUCTION DECODE SUPPORT TYPES
////////////////////////////////////////////////////////////////////////////////

//
// Structure filled with information about a decoded instruction
//
typedef struct riscvExtInstrInfoS {

                                    // FILLED BY CLIENT
    riscvAddr         thisPC;       // instruction address
    Uns32             instruction;  // instruction word
    void             *userData;     // client-specific data

                                    // FILLED BY INSTRUCTION UNPACK
    riscvArchitecture arch;         // architecture requirements
    riscvRegDesc      r[4];         // argument registers
    riscvRegDesc      mask;         // mask register (vector instructions)
    riscvRMDesc       rm;           // rounding mode
    Uns64             c;            // constant value

} riscvExtInstrInfo;

//
// Standard instruction patterns
//
typedef enum riscvExtInstrPatternE {

                            // GPR INSTRUCTIONS
    RVIP_RD_RS1_RS2,        // op   xd, xs1, xs2
    RVIP_RD_RS1_SI,         // op   xd, xs1, imm
    RVIP_RD_RS1_SHIFT,      // op   xd, xs1, shift
    RVIP_RD_RS1_RS2_RS3,    // op   xd, xs1, xs2, xs3
    RVIP_RD_RS1_RS3_SHIFT,  // op   xd, xs1, xs2, shift

                            // FPR INSTRUCTIONS
    RVIP_FD_FS1_FS2,        // op   fd, fs1, fs2
    RVIP_FD_FS1_FS2_RM,     // op   fd, fs1, fs2, rm
    RVIP_FD_FS1_FS2_FS3_RM, // op   fd, fs1, fs2, fs3, rm
    RVIP_RD_FS1_FS2,        // op   xd, fs1, fs2

                            // VECTOR INSTRUCTIONS
    RVIP_VD_VS1_VS2_M,      // op   vd, vs1, vs2, vm
    RVIP_VD_VS1_SI_M,       // op   vd, vs1, simm, vm
    RVIP_VD_VS1_UI_M,       // op   vd, vs1, uimm, vm
    RVIP_VD_VS1_RS2_M,      // op   vd, vs1, rs2, vm
    RVIP_VD_VS1_FS2_M,      // op   vd, vs1, fs2, vm
    RVIP_RD_VS1_RS2,        // op   xd, vs1, vs2
    RVIP_RD_VS1_M,          // op   xd, vs1, vm
    RVIP_VD_RS2,            // op   vd, xs2
    RVIP_FD_VS1,            // op   fd, vs1
    RVIP_VD_FS2,            // op   vd, fs2

    RVIP_LAST               // KEEP LAST: for sizing

} riscvExtInstrPattern;

//
// Structure defining characteristics of each instruction
//
typedef struct riscvExtInstrAttrsS {
    const char          *opcode;    // opcode name
    riscvArchitecture    arch;      // architectural requirements
    riscvExtInstrPattern pattern;   // instruction pattern
    const char          *format;    // disassembly format string
    const char          *decode;    // decode string
} riscvExtInstrAttrs;

//
// Use this macro to fill decode table entries
//
#define EXT_INSTRUCTION(_ID, _NAME, _ARCH, _PATTERN, _FORMAT, _DECODE) [_ID] = { \
    opcode  : _NAME,    \
    arch    : _ARCH,    \
    pattern : _PATTERN, \
    format  : _FORMAT,  \
    decode  : _DECODE   \
}


////////////////////////////////////////////////////////////////////////////////
// INSTRUCTION TRANSLATION SUPPORT TYPES
////////////////////////////////////////////////////////////////////////////////

//
// Generic JIT code emission callback
//
#define EXT_MORPH_FN(_NAME) void _NAME(riscvExtMorphStateP state)
typedef EXT_MORPH_FN((*extMorphFn));

//
// Attributes controlling JIT code translation
//
typedef struct riscvExtMorphAttrS {
    extMorphFn            morph;    // function to translate one instruction
    octiaInstructionClass iClass;   // supplemental instruction class
    Uns32                 variant;  // required variant
} riscvExtMorphAttr;

//
// Context for JIT code translation (decoded instruction information and
// translation attributes)
//
typedef struct riscvExtMorphStateS {
    riscvExtInstrInfo   info;       // decoded instruction information
    riscvExtMorphAttrCP attrs;      // instruction attributes
    riscvP              riscv;      // current processor
    vmiosObjectP        object;     // current extension object
} riscvExtMorphState;


////////////////////////////////////////////////////////////////////////////////
// CSRS
////////////////////////////////////////////////////////////////////////////////

//
// This type defines CSR attributes together with FIFO-specific configuration
// information
//
typedef struct extCSRAttrsS {
    Uns32         extension;    // extension requirements
    riscvCSRAttrs baseAttrs;    // base attributes
} extCSRAttrs;

DEFINE_CS(extCSRAttrs);

//
// Implemented using vmiReg and optional callbacks, no mask
//
#define XCSR_ATTR_T__( \
    _ID, _NUM, _ARCH, _EXT, _ENDB,_ENDRM,_NOTR,_TVMT, _DESC, _RCB, _RWCB, _WCB \
) [XCSR_ID(_ID)] = { \
    .extension = EXTX_##_EXT,                   \
    .baseAttrs = {                              \
        name          : #_ID,                   \
        desc          : _DESC,                  \
        csrNum        : _NUM,                   \
        arch          : _ARCH,                  \
        wEndBlock     : _ENDB,                  \
        wEndRM        : _ENDRM,                 \
        noTraceChange : _NOTR,                  \
        TVMT          : _TVMT,                  \
        readCB        : _RCB,                   \
        readWriteCB   : _RWCB,                  \
        writeCB       : _WCB,                   \
        reg32         : XCSR_REG32_MT(_ID),     \
        reg64         : XCSR_REG64_MT(_ID)      \
    }                                           \
}

//
// Implemented using vmiReg and optional callbacks, constant write mask
//
#define XCSR_ATTR_TC_( \
    _ID, _NUM, _ARCH, _EXT, _ENDB,_ENDRM,_NOTR,_TVMT, _DESC, _RCB, _RWCB, _WCB \
) [XCSR_ID(_ID)] = { \
    .extension = EXTX_##_EXT,                   \
    .baseAttrs = {                              \
        name          : #_ID,                   \
        desc          : _DESC,                  \
        csrNum        : _NUM,                   \
        arch          : _ARCH,                  \
        wEndBlock     : _ENDB,                  \
        wEndRM        : _ENDRM,                 \
        noTraceChange : _NOTR,                  \
        TVMT          : _TVMT,                  \
        readCB        : _RCB,                   \
        readWriteCB   : _RWCB,                  \
        writeCB       : _WCB,                   \
        reg32         : XCSR_REG32_MT(_ID),     \
        writeMaskC32  : WM32_##_ID,             \
        reg64         : XCSR_REG64_MT(_ID),     \
        writeMaskC64  : WM64_##_ID              \
    }                                           \
}

//
// Implemented using vmiReg and optional callbacks, variable write mask
//
#define XCSR_ATTR_TV_( \
    _ID, _NUM, _ARCH, _EXT, _ENDB,_ENDRM,_NOTR,_TVMT, _DESC, _RCB, _RWCB, _WCB \
) [XCSR_ID(_ID)] = { \
    .extension = EXTX_##_EXT,                   \
    .baseAttrs = {                              \
        name          : #_ID,                   \
        desc          : _DESC,                  \
        csrNum        : _NUM,                   \
        arch          : _ARCH,                  \
        wEndBlock     : _ENDB,                  \
        wEndRM        : _ENDRM,                 \
        noTraceChange : _NOTR,                  \
        TVMT          : _TVMT,                  \
        readCB        : _RCB,                   \
        readWriteCB   : _RWCB,                  \
        writeCB       : _WCB,                   \
        reg32         : XCSR_REG32_MT(_ID),     \
        writeMaskV32  : XCSR_MASK32_MT(_ID),    \
        reg64         : XCSR_REG64_MT(_ID),     \
        writeMaskV64  : XCSR_MASK64_MT(_ID)     \
    }                                           \
}



