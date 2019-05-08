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

// VMI header files
#include "vmi/vmiMessage.h"
#include "vmi/vmiMt.h"
#include "vmi/vmiRt.h"

// model header files
#include "riscvBlockState.h"
#include "riscvCSRTypes.h"
#include "riscvDecode.h"
#include "riscvDecodeTypes.h"
#include "riscvExceptions.h"
#include "riscvFunctions.h"
#include "riscvMessage.h"
#include "riscvMorph.h"
#include "riscvRegisters.h"
#include "riscvStructure.h"
#include "riscvTypeRefs.h"
#include "riscvUtils.h"
#include "riscvVM.h"


////////////////////////////////////////////////////////////////////////////////
// TYPES
////////////////////////////////////////////////////////////////////////////////

//
// Abstract type
//
DEFINE_S(iterDesc);

//
// Generic JIT code emission callback
//
#define RISCV_MORPH_FN(_NAME) void _NAME(riscvMorphStateP state)
typedef RISCV_MORPH_FN((*riscvMorphFn));

//
// Generic JIT code emission callback for vector element
//
#define RISCV_MORPHV_FN(_NAME) void _NAME(riscvMorphStateP state, iterDescP id)
typedef RISCV_MORPHV_FN((*riscvMorphVFn));

//
// Floating point control
//
typedef enum riscvFPCtrlE {

    // normal native operation configuration
    RVFP_NORMAL,

    // FMIN/FMAX configurations
    RVFP_FMIN,      // special for FMIN (2.2 specification)
    RVFP_FMAX,      // special for FMAX (2.2 specification)
    RVFP_FMIN_2_3,  // special for FMIN (2.3 specification)
    RVFP_FMAX_2_3,  // special for FMAX (2.3 specification)

    RVFP_LAST       // KEEP LAST

} riscvFPCtrl;

//
// Vector width control
//
typedef enum riscvVWCtrlE {
    RVVW_NORMAL,    // no widening or narrowing
    RVVW_NARROWx2,  // SEW = 2*SEW
    RVVW_WIDEx211,  // 2*SEW = SEW   op SEW
    RVVW_WIDEx221,  // 2*SEW = 2*SEW op SEW
    RVVW_WIDEx4,    // 4*SEW = SEW   op SEW
} riscvVWCtrl;

//
// Attributes controlling JIT code translation
//
typedef struct riscvMorphAttrS {
    riscvMorphFn          morph;        // function to translate one instruction
    riscvMorphVFn         initCB;       // called at start of vector operation
    riscvMorphVFn         opCB;         // called to implement element operation
    riscvMorphVFn         postOpCB;     // called after element operation
    riscvMorphVFn         endCB;        // called at end of vector operation
    octiaInstructionClass iClass;       // supplemental instruction class
    vmiBinop              binop    : 8; // integer binary operation
    vmiFUnop              fpUnop   : 8; // floating-point unary operation
    vmiFBinop             fpBinop  : 8; // floating-point binary operation
    vmiFTernop            fpTernop : 8; // floating-point ternary operation
    riscvFPCtrl           fpConfig : 8; // floating point configuration
    vmiFPRelation         fpRel    : 4; // floating point comparison relation
    vmiCondition          cond     : 4; // comparison condition
    riscvVWCtrl           vwCtrl   : 4; // vector width control
    Bool                  fpQNaNOk : 1; // allow QNaN in floating point compare?
    Bool                  clearFS1 : 1; // clear FS1 sign (FSgn operation)
    Bool                  negFS2   : 1; // negate FS2 sign (FSgn operation)
    Bool                  sExtend  : 1; // whether arguments sign extended
} riscvMorphAttr;

//
// Context for JIT code translation (decoded instruction information and
// translation attributes)
//
typedef struct riscvMorphStateS {
    riscvInstrInfo   info;          // decoded instruction information
    riscvMorphAttrCP attrs;         // instruction attributes
    riscvP           riscv;         // current processor
    Bool             inDelaySlot;   // whether in delay slot
} riscvMorphState;


////////////////////////////////////////////////////////////////////////////////
// UTILITIES
////////////////////////////////////////////////////////////////////////////////

//
// Return current program counter
//
inline static Uns64 getPC(riscvP riscv) {
    return vmirtGetPC((vmiProcessorP)riscv);
}

//
// Return endian for data accesses
//
inline static memEndian getDataEndian(riscvP riscv) {
    return riscv->dendian;
}

//
// Is the given vmiReg the link register?
//
static Bool isLR(vmiReg r) {
    return VMI_REG_EQUAL(r, RISCV_LR);
}

//
// Disable instruction translation (test mode)
//
inline static Bool disableMorph(riscvMorphStateP state) {
    return RISCV_DISASSEMBLE(state->riscv);
}

//
// Get the currently-enabled architectural features
//
static riscvArchitecture getCurrentArch(riscvP riscv) {
    return riscv->currentArch;
}


////////////////////////////////////////////////////////////////////////////////
// ILLEGAL INSTRUCTION HANDLING (REQUIRING PROCESSOR ONLY)
////////////////////////////////////////////////////////////////////////////////

//
// Emit call to take Illegal Instruction exception
//
static void emitIllegalInstruction(void) {
    vmimtArgProcessor();
    vmimtCallAttrs((vmiCallFn)riscvIllegalInstruction, VMCA_EXCEPTION);
}

//
// Emit Illegal Instruction description message
//
static void illegalInstructionMessageDesc(riscvP riscv, illegalDescP desc) {
    vmiMessage("W", desc->id,
        SRCREF_FMT "%s",
        SRCREF_ARGS(riscv, getPC(riscv)),
        desc->detail
    );
}

//
// Emit Illegal Instruction message and take Illegal Instruction exception
//
void riscvEmitIllegalInstructionMessageDesc(riscvP riscv, illegalDescP desc) {

    // emit message in verbose mode
    if(riscv->verbose) {
        vmimtArgProcessor();
        vmimtArgNatAddress(desc);
        vmimtCall((vmiCallFn)illegalInstructionMessageDesc);
    }

    // take Illegal Instruction exception
    emitIllegalInstruction();
}

//
// Get description for the first feature identified by the given feature id
//
static const char *getFeatureDesc(riscvArchitecture feature) {

    // get feature description
    const char *description = riscvGetFeatureName(feature);

    // sanity check description is valid
    VMI_ASSERT(
        description,
        "require non-zero feature name (feature %c)",
        riscvGetFeatureChar(feature)
    );

    return description;
}

//
// Take Illegal Instruction exception when feature is absent or not enabled
//
static void illegalInstructionAbsentArch(
    riscvP            riscv,
    riscvArchitecture missing
) {
    // report the absent or disabled feature by name
    if(riscv->verbose) {
        vmiMessage("W", CPU_PREFIX "_ADF",
            SRCREF_FMT "Illegal instruction - %s absent or inactive",
            SRCREF_ARGS(riscv, getPC(riscv)),
            getFeatureDesc(missing)
        );
    }

    // take Illegal Instruction exception
    riscvIllegalInstruction(riscv);
}

//
// Emit code to take Illegal Instruction exception when feature is absent or not
// enabled
//
static void emitIllegalInstructionAbsentArch(riscvArchitecture missing) {
    vmimtArgProcessor();
    vmimtArgUns32(missing);
    vmimtCallAttrs((vmiCallFn)illegalInstructionAbsentArch, VMCA_EXCEPTION);
}

//
// Emit code to indicate that a custom instruction is not present if verbose
//
static void emitCustomAbsent() {
    emitIllegalInstructionAbsentArch(ISA_X);
}

//
// Use block mask to validate the value of architectural features that can
// change at run time
//
static void emitBlockMask(riscvP riscv, riscvArchitecture feature) {

    // instruction width is implemented using a different code dictionary,
    // so block mask check is not required
    feature &= ~ISA_XLEN_ANY;

    // select features that can change dynamically (note that D and F features
    // can be enabled or disabled by mstatus.FS, so are included here even if
    // the misa configuration bits are read-only)
    feature &= (riscv->configInfo.archMask | ISA_DF);

    // emit block mask check for dynamic features
    if(feature) {
        vmimtValidateBlockMask(feature);
    }
}

//
// Determine if the given required feature is present and enabled (using
// blockMask if necessary)
//
static Bool isFeaturePresentMT(riscvP riscv, riscvArchitecture feature) {

    riscvArchitecture current = getCurrentArch(riscv);
    riscvArchitecture actual  = current & feature;
    riscvArchitecture present = feature & actual;

    // validate values of fields that can change at run time
    emitBlockMask(riscv, feature);

    return present;
}

//
// Validate that the given required feature is present and enabled (using
// blockMask if necessary)
//
Bool riscvRequireArchPresentMT(riscvP riscv, riscvArchitecture feature) {

    riscvArchitecture current = getCurrentArch(riscv);
    riscvArchitecture actual  = current & feature;
    riscvArchitecture absent  = feature & ~actual;

    // validate values of fields that can change at run time
    emitBlockMask(riscv, feature);

    // handle absent or disabled feature
    if(absent) {
        emitIllegalInstructionAbsentArch(absent);
    }

    return !absent;
}

//
// Validate that the given required feature is enabled (using blockMask if
// necessary)
//
static Bool requireMISAMT(riscvP riscv, char feature) {

    // sanity check missing is valid
    VMI_ASSERT(feature, "require non-zero feature letter");

    return riscvRequireArchPresentMT(riscv, 1<<(feature-'A'));
}

//
// Validate that the instruction is supported and enabled and take an Illegal
// Instruction exception if not
//
Bool riscvInstructionEnabled(riscvP riscv, riscvArchitecture requiredVariant) {

    // get current XLEN
    Uns32             XLEN     = riscvGetXlenMode(riscv);
    riscvArchitecture XLENarch = (XLEN==32) ? ISA_XLEN_32 : ISA_XLEN_64;

    // check whether instruction is supported for the current XLEN
    if(!(requiredVariant & XLENarch)) {
        emitIllegalInstructionAbsentArch(requiredVariant & ISA_XLEN_ANY);
        return False;
    }

    // validate remaining architectural feature requirements
    return riscvRequireArchPresentMT(riscv, requiredVariant & ~ISA_XLEN_ANY);
}

//
// Emit Illegal Instruction because the current mode has insufficient
// privilege
//
void riscvEmitIllegalInstructionMode(riscvP riscv) {

    riscvMode mode = getCurrentMode(riscv);

    switch(mode) {
        case RISCV_MODE_SUPERVISOR:
            ILLEGAL_INSTRUCTION_MESSAGE(riscv, "UDM", "Illegal in Supervisor mode");
            break;
        case RISCV_MODE_USER:
            ILLEGAL_INSTRUCTION_MESSAGE(riscv, "UDM", "Illegal in User mode");
            break;
        default:
            VMI_ABORT("Unexpected mode %u", mode); // LCOV_EXCL_LINE
            break;
    }
}

//
// Validate that the processor is executing at or above the given mode
//
static Bool requireModeMT(riscvP riscv, riscvMode required) {

    riscvMode actual = getCurrentMode(riscv);

    if(actual<required) {
        riscvEmitIllegalInstructionMode(riscv);
        return False;
    } else {
        return True;
    }
}

//
// Validate that the processor has Supervisor mode enabled
//
static Bool checkHaveSModeMT(riscvP riscv) {

    riscvMode actual = getCurrentMode(riscv);

    if(actual==RISCV_MODE_SUPERVISOR) {

        // always ok if currently in Supervisor mode
        return True;

    } else {

        // otherwise, require 'S' mode to be present and enabled
        return requireMISAMT(riscv, 'S');
    }
}

//
// Validate that the processor has User mode enabled
//
static Bool checkHaveUModeMT(riscvP riscv) {

    riscvMode actual = getCurrentMode(riscv);

    if(actual==RISCV_MODE_USER) {

        // always ok if currently in User mode
        return True;

    } else {

        // otherwise, require 'U' mode to be present and enabled
        return requireMISAMT(riscv, 'U');
    }
}


////////////////////////////////////////////////////////////////////////////////
// TRAPPED INSTRUCTION HANDLING
////////////////////////////////////////////////////////////////////////////////

//
// Macro encapsulating test for trapped instruction from Supervisor to Monitor
// mode when a bit is set or clear in a register
//
#define EMIT_TRAP_MASK_FIELD(_RISCV, _R, _BIT, _VALUE) \
    emitTrapInstructionMask(                \
        _RISCV,                             \
        CSR_REG_MT(_R),                     \
        WM_##_R##_##_BIT,                   \
        _VALUE ? vmi_COND_Z : vmi_COND_NZ,  \
        #_R"."#_BIT"="#_VALUE               \
    )

//
// Function called when instruction is trapped
//
static void trapInstruction(riscvP riscv, const char *reason) {

    // report the absent or disabled feature by name
    if(riscv->verbose) {
        vmiMessage("W", CPU_PREFIX "_TI",
            SRCREF_FMT "Trapped because %s",
            SRCREF_ARGS(riscv, getPC(riscv)),
            reason
        );
    }

    // take Illegal Instruction exception
    riscvIllegalInstruction(riscv);
}

//
// Emit test for Illegal Instruction instruction when a bit is set or clear in a
// register
//
static void emitTrapInstructionMask(
    riscvP       riscv,
    vmiReg       r,
    Uns32        mask,
    vmiCondition cond,
    const char  *reason
) {
    if(getCurrentMode(riscv)!=RISCV_MODE_MACHINE) {;

        vmiLabelP ok = vmimtNewLabel();

        // skip undefined instruction exception if bit is set
        vmimtTestRCJumpLabel(32, cond, r, mask, ok);

        // emit call generating Illegal Instruction exception
        vmimtArgProcessor();
        vmimtArgNatAddress(reason);
        vmimtCallAttrs((vmiCallFn)trapInstruction, VMCA_EXCEPTION);

        // here if access is legal
        vmimtInsertLabel(ok);
    }
}


////////////////////////////////////////////////////////////////////////////////
// REGISTER ACCESS
////////////////////////////////////////////////////////////////////////////////

//
// Set mstatus.FS if this is the first floating point instruction in this block
//
static void updateFS(riscvP riscv) {

    riscvBlockStateP blockState = riscv->blockState;

    if(!blockState->fpInstDone) {
        blockState->fpInstDone = True;
        vmimtBinopRC(32, vmi_OR, RISCV_CPU_REG(csr.mstatus), WM_mstatus_FS, 0);
    }
}

//
// Return VMI register for a temporary
//
static vmiReg getTmp(Uns32 i) {

    // sanity check temporary index
    VMI_ASSERT(
        i<NUM_TEMPS,
        "bad temporary index %u (maximum is %u)",
        i, NUM_TEMPS-1
    );

    return RISCV_CPU_TEMP(TMP[i]);
}

//
// Return riscvRegDesc for the indexed register
//
inline static riscvRegDesc getRVReg(riscvMorphStateP state, Uns32 argNum) {
    return state->info.r[argNum];
}

//
// Get mask for the register in a 32-bit word
//
inline static Uns32 getRegMask(riscvRegDesc r) {
    return 1 << getRIndex(r);
}

//
// Return floating point type for the given abstract register
//
static vmiFType getRegFType(riscvRegDesc r) {

    Uns32 bits = getRBits(r);

    if(isFReg(r)) {
        return VMI_FT_IEEE_754 | bits;
    } else if(isUReg(r)) {
        return VMI_FT_UNS | bits;
    } else {
        return VMI_FT_INT | bits;
    }
}

//
// Return VMI register for the given abstract register
//
vmiReg riscvGetVMIReg(riscvP riscv, riscvRegDesc r) {

    Uns32  bits   = getRBits(r);
    Uns32  index  = getRIndex(r);
    vmiReg result = VMI_NOREG;

    if(isXReg(r)) {

        // 64-bit register requires ISA_XLEN_64 feature
        if(bits==64) {
            riscvRequireArchPresentMT(riscv, ISA_XLEN_64);
        }

        // register indices >= 15 are illegal for E extension (the inverse of
        // the I feature)
        if((index<16) || riscvRequireArchPresentMT(riscv, ISA_I)) {
            result = index ? RISCV_GPR(index) : VMI_NOREG;
        }

    } else if(isFReg(r)) {

        // require either D or F
        if(riscvRequireArchPresentMT(riscv, (bits==64) ? ISA_D : ISA_F)) {
            result = RISCV_FPR(index);
        }

    } else if(isVReg(r)) {

        // require V feature
        if(riscvRequireArchPresentMT(riscv, ISA_V)) {
            result = riscvGetVReg(riscv, index);
        }

    } else {

        VMI_ABORT("Bad register specifier 0x%x", r); // LCOV_EXCL_LINE
    }

    return result;
}

//
// Return VMI register for the given abstract register
//
inline static vmiReg getVMIReg(riscvP riscv, riscvRegDesc r) {
    return riscvGetVMIReg(riscv, r);
}

//
// Do actions when a register is written (sign extending or NaN boxing, if
// required)
//
void riscvWriteRegSize(riscvP riscv, riscvRegDesc r, Uns32 srcBits) {

    vmiReg dst = getVMIReg(riscv, r);

    if(isXReg(r)) {

        Uns32 dstBits = riscvGetXlenArch(riscv);

        // sign-extend result
        vmimtMoveExtendRR(dstBits, dst, srcBits, dst, True);

        // add to record of X registers written by this instruction
        riscv->writtenXMask |= getRegMask(r);

    } else if(isFReg(r)) {

        riscvBlockStateP blockState = riscv->blockState;
        Uns32            dstBits    = riscvGetFlenArch(riscv);
        Uns32            fprMask    = getRegMask(r);

        // NaN-box result
        if(dstBits>srcBits) {
            vmimtMoveRC(dstBits-srcBits, VMI_REG_DELTA(dst,srcBits/8), -1);
            blockState->fpNaNBoxMask |= fprMask;
        } else {
            blockState->fpNaNBoxMask &= ~fprMask;
        }

        // set mstatus.FS
        updateFS(riscv);

    } else {

        VMI_ABORT("Bad register specifier 0x%x", r); // LCOV_EXCL_LINE
    }
}

//
// Do actions when a register is written (sign extending or NaN boxing, if
// required)
//
inline static void writeRegSize(riscvP riscv, riscvRegDesc r, Uns32 srcBits) {
    riscvWriteRegSize(riscv, r, srcBits);
}

//
// Do actions when a register is written (sign extending or NaN boxing, if
// required) using the derived register size
//
void riscvWriteReg(riscvP riscv, riscvRegDesc r) {
    writeRegSize(riscv, r, getRBits(r));
}

//
// Do actions when a register is written (sign extending or NaN boxing, if
// required) using the derived register size
//
inline static void writeReg(riscvP riscv, riscvRegDesc r) {
    riscvWriteReg(riscv, r);
}


////////////////////////////////////////////////////////////////////////////////
// LOAD/STORE UTILITIES
////////////////////////////////////////////////////////////////////////////////

//
// Load value from memory
//
static void emitLoadCommon(
    riscvMorphStateP state,
    vmiReg           rd,
    Uns32            rdBits,
    vmiReg           ra,
    memConstraint    constraint
) {
    Uns32     memBits = state->info.memBits;
    Uns64     offset  = state->info.c;
    Bool      sExtend = !state->info.unsExt;
    memEndian endian  = getDataEndian(state->riscv);

    vmimtLoadRRO(rdBits, memBits, offset, rd, ra, endian, sExtend, constraint);
}

//
// Store value to memory
//
static void emitStoreCommon(
    riscvMorphStateP state,
    vmiReg           rs,
    vmiReg           ra,
    memConstraint    constraint
) {
    Uns32     memBits = state->info.memBits;
    Uns64     offset  = state->info.c;
    memEndian endian  = getDataEndian(state->riscv);

    vmimtStoreRRO(memBits, offset, ra, rs, endian, constraint);
}


////////////////////////////////////////////////////////////////////////////////
// BASE INSTRUCTION CALLBACKS
////////////////////////////////////////////////////////////////////////////////

//
// No operation
//
static RISCV_MORPH_FN(emitNOP) {
    // no action
}

//
// Move value (two registers)
//
static RISCV_MORPH_FN(emitMoveRR) {

    riscvP       riscv = state->riscv;
    riscvRegDesc rdA   = getRVReg(state, 0);
    riscvRegDesc rsA   = getRVReg(state, 1);
    vmiReg       rd    = getVMIReg(riscv, rdA);
    vmiReg       rs    = getVMIReg(riscv, rsA);
    Uns32        bits  = getRBits(rdA);

    vmimtMoveRR(bits, rd, rs);

    writeReg(riscv, rdA);
}

//
// Move value (one register and constant)
//
static RISCV_MORPH_FN(emitMoveRC) {

    riscvP       riscv = state->riscv;
    riscvRegDesc rdA   = getRVReg(state, 0);
    vmiReg       rd    = getVMIReg(riscv, rdA);
    Uns32        bits  = getRBits(rdA);
    Uns64        c     = state->info.c;

    vmimtMoveRC(bits, rd, c);

    writeReg(riscv, rdA);
}

//
// Move PC-relative constant
//
static RISCV_MORPH_FN(emitMoveRPC) {

    riscvP       riscv = state->riscv;
    riscvRegDesc rdA   = getRVReg(state, 0);
    vmiReg       rd    = getVMIReg(riscv, rdA);
    Uns32        bits  = getRBits(rdA);
    Uns64        c     = state->info.c;

    // when in a delayed instruction context, base on that address
    if(state->inDelaySlot) {
        vmimtMoveRR(bits, rd, RISCV_JUMP_BASE);
    } else {
        vmimtMoveRSimPC(bits, rd);
    }

    vmimtBinopRC(bits, state->attrs->binop, rd, c, 0);

    writeReg(riscv, rdA);
}

//
// Implement generic Binop (three registers)
//
static RISCV_MORPH_FN(emitBinopRRR) {

    riscvP       riscv = state->riscv;
    riscvRegDesc rdA   = getRVReg(state, 0);
    riscvRegDesc rs1A  = getRVReg(state, 1);
    riscvRegDesc rs2A  = getRVReg(state, 2);
    vmiReg       rd    = getVMIReg(riscv, rdA);
    vmiReg       rs1   = getVMIReg(riscv, rs1A);
    vmiReg       rs2   = getVMIReg(riscv, rs2A);
    Uns32        bits  = getRBits(rdA);

    vmimtBinopRRR(bits, state->attrs->binop, rd, rs1, rs2, 0);

    writeReg(riscv, rdA);
}

//
// Implement generic Mulop (three registers, selecting result upper half)
//
static RISCV_MORPH_FN(emitMulopHRRR) {

    riscvP       riscv = state->riscv;
    riscvRegDesc rdA   = getRVReg(state, 0);
    riscvRegDesc rs1A  = getRVReg(state, 1);
    riscvRegDesc rs2A  = getRVReg(state, 2);
    vmiReg       rd    = getVMIReg(riscv, rdA);
    vmiReg       rs1   = getVMIReg(riscv, rs1A);
    vmiReg       rs2   = getVMIReg(riscv, rs2A);
    Uns32        bits  = getRBits(rdA);

    vmimtMulopRRR(bits, state->attrs->binop, rd, VMI_NOREG, rs1, rs2, 0);

    writeReg(riscv, rdA);
}

//
// Do arithmetic negation of rH:rL and return the upper half of the result
//
static Uns64 doNEG128H(Uns64 rL, Uns64 rH) {

    // bitwise negate value
    rH = ~rH;
    rL = ~rL;

    // increment bitwise-negated value
    rL += 1;
    if(!rL) {rH++;}

    // return result upper half
    return rH;
}

//
// Emit code to negate the given register
//
static void emitNegate(Uns32 bits, vmiReg rL, vmiReg rH) {

    if(bits<=64) {

        // implement using VMI primitive
        vmimtUnopRR(bits, vmi_NEG, rL, rL, 0);

    } else if(bits==128) {

        // implement using embedded call (updating only
        vmimtArgReg(64, rL);
        vmimtArgReg(64, rH);
        vmimtCallResultAttrs((vmiCallFn)doNEG128H, 64, rH, VMCA_PURE);

    } else {

        // report unimplemented bits
        VMI_ABORT("Bad bits %u", bits); // LCOV_EXCL_LINE
    }
}

//
// Implement MULHSU instruction  (three registers, selecting result upper half)
//
static RISCV_MORPH_FN(emitMULHSU) {

    riscvP       riscv    = state->riscv;
    riscvRegDesc rdA      = getRVReg(state, 0);
    riscvRegDesc rs1A     = getRVReg(state, 1);
    riscvRegDesc rs2A     = getRVReg(state, 2);
    vmiReg       rd       = getVMIReg(riscv, rdA);
    vmiReg       rs1      = getVMIReg(riscv, rs1A);
    vmiReg       rs2      = getVMIReg(riscv, rs2A);
    Uns32        bits     = getRBits(rdA);
    vmiReg       flag     = getTmp(0);
    vmiReg       temprs1  = getTmp(1);
    vmiReg       resultHL = getTmp(1);
    vmiReg       resultL  = resultHL;
    vmiReg       resultH  = VMI_REG_DELTA(resultHL, bits/8);
    vmiLabelP    pos1     = vmimtNewLabel();
    vmiLabelP    pos2     = vmimtNewLabel();

    // determine if rs1 is negative
    vmimtCompareRC(bits, vmi_COND_L, rs1, 0, flag);

    // negate rs1 if it is negative
    vmimtMoveRR(bits, temprs1, rs1);
    vmimtCondJumpLabel(flag, False, pos1);
    vmimtUnopRR(bits, vmi_NEG, temprs1, temprs1, 0);
    vmimtInsertLabel(pos1);

    // unsigned multiply (rs1 * rs2)
    vmimtMulopRRR(bits, vmi_MUL, resultH, resultL, temprs1, rs2, 0);

    // negate rd if rs1 was negative
    vmimtCondJumpLabel(flag, False, pos2);
    emitNegate(bits*2, resultL, resultH);
    vmimtInsertLabel(pos2);

    // save result
    vmimtMoveRR(bits, rd, resultH);

    writeReg(riscv, rdA);
}

//
// Implement generic Cmpop (three registers)
//
static RISCV_MORPH_FN(emitCmpopRRR) {

    riscvP       riscv = state->riscv;
    riscvRegDesc rdA   = getRVReg(state, 0);
    riscvRegDesc rs1A  = getRVReg(state, 1);
    riscvRegDesc rs2A  = getRVReg(state, 2);
    vmiReg       rd    = getVMIReg(riscv, rdA);
    vmiReg       rs1   = getVMIReg(riscv, rs1A);
    vmiReg       rs2   = getVMIReg(riscv, rs2A);
    Uns32        bits  = getRBits(rdA);

    vmimtCompareRR(bits, state->attrs->cond, rs1, rs2, rd);

    writeRegSize(riscv, rdA, 8);
}

//
// Implement generic Binop (two registers and constant)
//
static RISCV_MORPH_FN(emitBinopRRC) {

    riscvP       riscv = state->riscv;
    riscvRegDesc rdA   = getRVReg(state, 0);
    riscvRegDesc rs1A  = getRVReg(state, 1);
    vmiReg       rd    = getVMIReg(riscv, rdA);
    vmiReg       rs1   = getVMIReg(riscv, rs1A);
    Uns32        bits  = getRBits(rdA);
    Uns64        c     = state->info.c;

    vmimtBinopRRC(bits, state->attrs->binop, rd, rs1, c, 0);

    writeReg(riscv, rdA);
}

//
// Implement generic Cmpop (two registers and constant)
//
static RISCV_MORPH_FN(emitCmpopRRC) {

    riscvP       riscv = state->riscv;
    riscvRegDesc rdA   = getRVReg(state, 0);
    riscvRegDesc rs1A  = getRVReg(state, 1);
    vmiReg       rd    = getVMIReg(riscv, rdA);
    vmiReg       rs1   = getVMIReg(riscv, rs1A);
    Uns32        bits  = getRBits(rdA);
    Uns64        c     = state->info.c;

    vmimtCompareRC(bits, state->attrs->cond, rs1, c, rd);

    writeRegSize(riscv, rdA, 8);
}

//
// Get alignment constraint for load/store operations
//
static memConstraint getLoadStoreConstraint(riscvMorphStateP state) {

    riscvP riscv     = state->riscv;
    Bool   unaligned = riscv->configInfo.unaligned;

    return unaligned ? MEM_CONSTRAINT_NONE : MEM_CONSTRAINT_ALIGNED;
}

//
// Get alignment constraint for atomic operations (must be aligned prior to
// version 2.3)
//
static memConstraint getLoadStoreConstraintAMO(riscvMorphStateP state) {

    riscvP riscv        = state->riscv;
    Bool   unaligned    = riscv->configInfo.unaligned;
    Bool   unalignedAMO = riscv->configInfo.unalignedAMO && unaligned;

    return unalignedAMO ? MEM_CONSTRAINT_NONE : MEM_CONSTRAINT_ALIGNED;
}

//
// Get alignment constraint for LR/SC operations (always aligned)
//
static memConstraint getLoadStoreConstraintLR(riscvMorphStateP state) {

    return MEM_CONSTRAINT_ALIGNED;
}

//
// Load value from memory
//
static RISCV_MORPH_FN(emitLoad) {

    riscvP        riscv      = state->riscv;
    riscvRegDesc  rdA        = getRVReg(state, 0);
    riscvRegDesc  raA        = getRVReg(state, 1);
    vmiReg        rd         = getVMIReg(riscv, rdA);
    vmiReg        ra         = getVMIReg(riscv, raA);
    Uns32         rdBits     = getRBits(rdA);
    memConstraint constraint = getLoadStoreConstraint(state);

    // call common code to perform load
    emitLoadCommon(state, rd, rdBits, ra, constraint);

    writeReg(riscv, rdA);
}

//
// Store value to memory
//
static RISCV_MORPH_FN(emitStore) {

    riscvP        riscv      = state->riscv;
    riscvRegDesc  rsA        = getRVReg(state, 0);
    riscvRegDesc  raA        = getRVReg(state, 1);
    vmiReg        rs         = getVMIReg(riscv, rsA);
    vmiReg        ra         = getVMIReg(riscv, raA);
    memConstraint constraint = getLoadStoreConstraint(state);

    // call common code to perform store
    emitStoreCommon(state, rs, ra, constraint);
}

//
// Is constant target address aligned?
//
static Bool isTargetAddressAlignedC(riscvP riscv, Uns64 tgt) {

    if(!(tgt&0x2)) {

        // address is aligned
        return True;

    } else if(isFeaturePresentMT(riscv, ISA_C)) {

        // compressed instructions enabled
        return True;

    } else {

        // address is not aligned
        return False;
    }
}

//
// Take Instruction Address Misaligned exception
//
static void emitTargetAddressUnalignedC(riscvP riscv, Uns64 tgt) {

    vmiCallFn exceptCB = (vmiCallFn)riscvInstructionAddressMisaligned;

    // emit call generating Instruction Address Misaligned exception
    vmimtArgProcessor();
    vmimtArgUns64(tgt);
    vmimtCallAttrs(exceptCB, VMCA_EXCEPTION);
}

//
// Validate target address in register is aligned and take exception if not
//
static void checkTargetAddressAlignedR(riscvP riscv, Uns32 bits, vmiReg ra) {

    if(!isFeaturePresentMT(riscv, ISA_C)) {

        vmiLabelP ok       = vmimtNewLabel();
        vmiCallFn exceptCB = (vmiCallFn)riscvInstructionAddressMisaligned;

        // skip misaligned instruction exception if bit[1] is clear
        vmimtTestRCJumpLabel(32, vmi_COND_Z, ra, 0x2, ok);

        // extend target address to 64 bits
        vmiReg tmp = getTmp(0);
        vmimtMoveExtendRR(64, tmp, bits, ra, False);

        // emit call generating Illegal Instruction exception
        vmimtArgProcessor();
        vmimtArgReg(64, ra);
        vmimtCallAttrs(exceptCB, VMCA_EXCEPTION);

        // here if access is legal
        vmimtInsertLabel(ok);
    }
}

//
// Branch based on register comparison
//
static RISCV_MORPH_FN(emitBranchRR) {

    riscvP       riscv = state->riscv;
    riscvRegDesc rs1A  = getRVReg(state, 0);
    riscvRegDesc rs2A  = getRVReg(state, 1);
    vmiReg       rs1   = getVMIReg(riscv, rs1A);
    vmiReg       rs2   = getVMIReg(riscv, rs2A);
    Uns32        bits  = getRBits(rs1A);
    Uns64        tgt   = state->info.c;
    vmiReg       tmp   = getTmp(0);

    // do comparison
    vmimtCompareRR(bits, state->attrs->cond, rs1, rs2, tmp);

    // validate target address alignment
    if(!isTargetAddressAlignedC(riscv, tgt)) {

        vmiLabelP noBranch = vmimtNewLabel();

        // skip alignment test if condition is False
        vmimtCondJumpLabel(tmp, False, noBranch);

        // take Instruction Address Misaligned exception
        emitTargetAddressUnalignedC(riscv, tgt);

        // here if address is aligned
        vmimtInsertLabel(noBranch);
    }

    // do branch
    vmimtCondJump(tmp, True, 0, tgt, VMI_NOREG, vmi_JH_RELATIVE);
}

//
// Return link address if the current instruction requires it
//
static Uns64 getLinkPC(riscvMorphStateP state, vmiReg *lrP) {

    Uns64 linkPC = state->info.thisPC + state->info.bytes;

    if(state->inDelaySlot) {

        vmimtGetDelaySlotNextPC(*lrP, True);

        *lrP   = VMI_NOREG;
        linkPC = 0;
    }

    return linkPC;
}

//
// Jump to constant target address
//
static RISCV_MORPH_FN(emitJAL) {

    riscvP       riscv  = state->riscv;
    riscvRegDesc lrA    = getRVReg(state, 0);
    vmiReg       lr     = getVMIReg(riscv, lrA);
    Uns64        tgt    = state->info.c;
    vmiJumpHint  hint   = isLR(lr) ? vmi_JH_CALL : vmi_JH_NONE;

    // validate target address alignment
    if(!isTargetAddressAlignedC(riscv, tgt)) {
        emitTargetAddressUnalignedC(riscv, tgt);
    }

    // emit call using calculated linkPC and adjusted lr
    Uns64 linkPC = getLinkPC(state, &lr);
    vmimtUncondJump(linkPC, tgt, lr, hint|vmi_JH_RELATIVE);
}

//
// Jump to register target address
//
static RISCV_MORPH_FN(emitJALR) {

    riscvP       riscv  = state->riscv;
    riscvRegDesc lrA    = getRVReg(state, 0);
    riscvRegDesc raA    = getRVReg(state, 1);
    vmiReg       lr     = getVMIReg(riscv, lrA);
    vmiReg       ra     = getVMIReg(riscv, raA);
    Uns32        bits   = getRBits(lrA);
    Uns64        offset = state->info.c;
    vmiJumpHint  hint;

    // calculate target address if required
    if(offset) {
        vmiReg tmp = getTmp(0);
        vmimtBinopRRC(bits, vmi_ADD, tmp, ra, offset, 0);
        ra = tmp;
    }

    // validate target address alignment
    checkTargetAddressAlignedR(riscv, bits, ra);

    // derive jump hint
    if(isLR(ra)) {
        hint = vmi_JH_RETURN;
    } else if(isLR(lr)) {
        hint = vmi_JH_CALL;
    } else {
        hint = vmi_JH_NONE;
    }

    // emit call using calculated linkPC and adjusted lr
    Uns64 linkPC = getLinkPC(state, &lr);
    vmimtUncondJumpReg(linkPC, ra, lr, hint|vmi_JH_RELATIVE);
}


////////////////////////////////////////////////////////////////////////////////
// ATOMIC MEMORY OPERATIONS
////////////////////////////////////////////////////////////////////////////////

//
// Function type implement generic AMO operation
//
#define AMO_FN(_NAME) void _NAME( \
    riscvMorphStateP state, \
    Uns32            bits,  \
    vmiReg           rd,    \
    vmiReg           ra,    \
    vmiReg           rb     \
)
typedef AMO_FN((*amoCB));

//
// Atomic memory operation using defined VMI binop
//
static void emitAMOCommonRRR(riscvMorphStateP state, amoCB opCB) {

    riscvP        riscv      = state->riscv;
    riscvRegDesc  rdA        = getRVReg(state, 0);
    riscvRegDesc  rsA        = getRVReg(state, 1);
    riscvRegDesc  raA        = getRVReg(state, 2);
    vmiReg        rd         = getVMIReg(riscv, rdA);
    vmiReg        rs         = getVMIReg(riscv, rsA);
    vmiReg        ra         = getVMIReg(riscv, raA);
    Uns32         bits       = getRBits(rdA);
    memConstraint constraint = getLoadStoreConstraintAMO(state);
    vmiReg        tmp1       = getTmp(0);
    vmiReg        tmp2       = getTmp(1);

    // for this instruction, memBits is bits
    state->info.memBits = bits;

    // this is an atomic operation
    vmimtAtomic();

    // generate Store/AMO exception in preference to Load exception
    vmimtTryStoreRC(bits, 0, ra, constraint);

    // generate results using tmp1 and tmp2
    emitLoadCommon(state, tmp1, bits, ra, constraint);
    opCB(state, bits, tmp2, tmp1, rs);
    emitStoreCommon(state, tmp2, ra, constraint);
    vmimtMoveRR(bits, rd, tmp1);

    writeReg(riscv, rdA);
}

//
// AMO binop callback
//
static AMO_FN(emitAMOBinopRRRCB) {
    vmimtBinopRRR(bits, state->attrs->binop, rd, ra, rb, 0);
}

//
// AMO cmpop callback
//
static AMO_FN(emitAMOCmpopRRRCB) {

    vmiReg tf = getTmp(2);

    vmimtCompareRR(bits, state->attrs->cond, ra, rb, tf);
    vmimtCondMoveRRR(bits, tf, True, rd, ra, rb);
}

//
// AMO swap callback
//
static AMO_FN(emitAMOSwapRRRCB) {
    vmimtMoveRR(bits, rd, rb);
}

//
// Atomic memory operation using defined VMI binop
//
static RISCV_MORPH_FN(emitAMOBinopRRR) {
    emitAMOCommonRRR(state, emitAMOBinopRRRCB);
}

//
// Atomic memory operation using defined VMI cmpop
//
static RISCV_MORPH_FN(emitAMOCmpopRRR) {
    emitAMOCommonRRR(state, emitAMOCmpopRRRCB);
}

//
// Atomic memory operation using swap
//
static RISCV_MORPH_FN(emitAMOSwapRRR) {
    emitAMOCommonRRR(state, emitAMOSwapRRRCB);
}


////////////////////////////////////////////////////////////////////////////////
// LR/SC INSTRUCTIONS
////////////////////////////////////////////////////////////////////////////////

//
// This defines exclusive tag bits
//
inline static Uns32 getEABits(riscvMorphStateP state) {
    return riscvGetXlenArch(state->riscv);
}

//
// This defines exclusive tag bits
//
inline static Uns32 getModeBits(riscvMorphStateP state) {
    return riscvGetXlenMode(state->riscv);
}

//
// Generate exclusive access tag address ra in register rtag
//
static void generateEATag(riscvMorphStateP state, vmiReg rtag, vmiReg ra) {

    Uns32 bits   = getEABits(state);
    Uns32 raBits = getModeBits(state);

    vmimtMoveExtendRR(bits, rtag, raBits, ra, 0);
    vmimtBinopRC(bits, vmi_AND, rtag, state->riscv->exclusiveTagMask, 0);
}

//
// Emit code to start exclusive access to address ra
//
static void startEA(riscvMorphStateP state, vmiReg ra) {

    // instruction must execute atomically but should not be classed as atomic
    // by instruction attributes (it is OCL_IC_EXCLUSIVE)
    vmimtAtomic();
    vmimtInstructionClassSub(OCL_IC_ATOMIC);

    // generate exclusive access tag for this address
    generateEATag(state, RISCV_EA_TAG, ra);
}

//
// Validate the exclusive access and jump to label 'done' if it is invalid,
// setting rd to 1
//
static vmiLabelP validateEA(
    riscvMorphStateP state,
    vmiReg           ra,
    vmiReg           rd,
    Uns32            rdBits
) {
    vmiLabelP done = vmimtNewLabel();
    vmiLabelP ok   = vmimtNewLabel();
    vmiReg    t    = getTmp(0);

    // generate exclusive access tag for this address
    generateEATag(state, t, ra);

    // do load and store tags match?
    vmimtCompareRR(getEABits(state), vmi_COND_EQ, RISCV_EA_TAG, t, t);

    // commit store if tags match
    vmimtCondJumpLabel(t, True, ok);

    // indicate store failed
    vmimtMoveRC(rdBits, rd, 1);

    // jump to instruction end
    vmimtUncondJumpLabel(done);

    // here to commit store
    vmimtInsertLabel(ok);

    return done;
}

//
// Do actions required to terminate exclusive access
//
static void clearEA(riscvMorphStateP state) {

    // exclusiveTag becomes RISCV_NO_TAG to indicate no active access
    vmimtMoveRC(getEABits(state), RISCV_EA_TAG, RISCV_NO_TAG);
}

//
// Do actions required to complete exclusive access
//
static void endEA(
    riscvMorphStateP state,
    vmiReg           rd,
    Uns32            rdBits,
    vmiLabelP        done
) {
    // indicate store succeeded
    vmimtMoveRC(rdBits, rd, 0);

    // insert target label for aborted stores
    vmimtInsertLabel(done);

    // terminate exclusive access
    clearEA(state);
}

//
// Emit code for LR
//
static RISCV_MORPH_FN(emitLR) {

    riscvP        riscv      = state->riscv;
    riscvRegDesc  rdA        = getRVReg(state, 0);
    riscvRegDesc  raA        = getRVReg(state, 1);
    vmiReg        rd         = getVMIReg(riscv, rdA);
    vmiReg        ra         = getVMIReg(riscv, raA);
    Uns32         rdBits     = getRBits(rdA);
    memConstraint constraint = getLoadStoreConstraintLR(state);

    // for this instruction, memBits is rdBits
    state->info.memBits = rdBits;

    // indicate LR is now active at address ra
    startEA(state, ra);

    // call common code to perform load
    emitLoadCommon(state, rd, rdBits, ra, constraint);

    writeReg(riscv, rdA);
}

//
// Emit code for SC
//
static RISCV_MORPH_FN(emitSC) {

    riscvP        riscv      = state->riscv;
    riscvRegDesc  rdA        = getRVReg(state, 0);
    riscvRegDesc  rsA        = getRVReg(state, 1);
    riscvRegDesc  raA        = getRVReg(state, 2);
    vmiReg        rd         = getVMIReg(riscv, rdA);
    vmiReg        rs         = getVMIReg(riscv, rsA);
    vmiReg        ra         = getVMIReg(riscv, raA);
    Uns32         rdBits     = getRBits(rdA);
    memConstraint constraint = getLoadStoreConstraintLR(state);

    // for this instruction, memBits is rsBits
    state->info.memBits = getRBits(rsA);

    // validate SC attempt at address ra
    vmiLabelP done = validateEA(state, ra, rd, rdBits);

    // call common code to perform store
    emitStoreCommon(state, rs, ra, constraint);

    // complete SC attempt
    endEA(state, rd, rdBits, done);

    writeReg(riscv, rdA);
}


////////////////////////////////////////////////////////////////////////////////
// SYSTEM INSTRUCTIONS
////////////////////////////////////////////////////////////////////////////////

//
// This defines the type of a non-returning exception callback
//
#define EXCEPTION_FN(_NAME) void _NAME(riscvP riscv)
typedef EXCEPTION_FN((*exceptionFn));

//
// Emit code to an embedded exception function
//
static void emitException(exceptionFn cb) {
    vmimtArgProcessor();
    vmimtCallAttrs((vmiCallFn)cb, VMCA_EXCEPTION);
}

//
// Implement ECALL instruction
//
static RISCV_MORPH_FN(emitECALL) {
    emitException(riscvECALL);
}

//
// Implement EBREAK instruction
//
static RISCV_MORPH_FN(emitEBREAK) {
    emitException(riscvEBREAK);
}

//
// Implement MRET instruction
//
static RISCV_MORPH_FN(emitMRET) {

    riscvP riscv = state->riscv;

    // this instruction must be executed in Machine mode
    requireModeMT(riscv, RISCV_MODE_MACHINE);

    emitException(riscvMRET);
}

//
// Implement SRET instruction
//
static RISCV_MORPH_FN(emitSRET) {

    riscvP riscv = state->riscv;

    // this instruction requires Supervisor mode to be implemented
    checkHaveSModeMT(riscv);

    // this instruction must be executed in Machine mode or Supervisor mode
    requireModeMT(riscv, RISCV_MODE_SUPERVISOR);

    // instruction is trapped if mstatus.TSR=1
    EMIT_TRAP_MASK_FIELD(riscv, mstatus, TSR, 1);

    emitException(riscvSRET);
}

//
// Implement URET instruction
//
static RISCV_MORPH_FN(emitURET) {

    riscvP riscv = state->riscv;

    // this instruction requires User mode to be implemented
    checkHaveUModeMT(riscv);

    emitException(riscvURET);
}

//
// Implement WFI instruction
//
static RISCV_MORPH_FN(emitWFI) {

    riscvP            riscv = state->riscv;
    riscvArchitecture arch  = getCurrentArch(riscv);

    // this instruction must be executed in Machine mode or Supervisor mode
    // unless User mode interrupts are implemented
    if(!(arch&ISA_N)) {
        requireModeMT(riscv, RISCV_MODE_SUPERVISOR);
    }

    // instruction is trapped if mstatus.TW=1
    EMIT_TRAP_MASK_FIELD(riscv, mstatus, TW, 1);

    // wait for interrupt (unless this is treated as a NOP)
    if(!riscv->configInfo.wfi_is_nop) {
        vmimtArgProcessor();
        vmimtCall((vmiCallFn)riscvWFI);
    }
}

//
// Implement SFENCE.VMA instruction
//
static RISCV_MORPH_FN(emitSFENCE_VMA) {

    riscvP       riscv      = state->riscv;
    riscvRegDesc VADDRrA    = getRVReg(state, 0);
    riscvRegDesc ASIDrA     = getRVReg(state, 1);
    vmiReg       VADDRr     = getVMIReg(riscv, VADDRrA);
    vmiReg       ASIDr      = getVMIReg(riscv, ASIDrA);
    Uns32        bits       = getRBits(VADDRrA);
    Bool         haveVADDRr = !VMI_ISNOREG(VADDRr);
    Bool         haveASIDr  = !VMI_ISNOREG(ASIDr);

    // this instruction requires Supervisor mode to be implemented
    checkHaveSModeMT(riscv);

    // this instruction must be executed in Machine mode or Supervisor mode
    requireModeMT(riscv, RISCV_MODE_SUPERVISOR);

    // instruction is trapped if mstatus.TVM=1
    EMIT_TRAP_MASK_FIELD(riscv, mstatus, TVM, 1);

    // emit processor argument
    vmimtArgProcessor();

    // emit VA argument if required
    if(haveVADDRr) {
        vmiReg tmp = getTmp(0);
        vmimtMoveExtendRR(64, tmp, bits, VADDRr, 0);
        vmimtArgReg(64, tmp);
    }

    // emit ASID argument if required
    if(haveASIDr) {
        vmimtArgReg(32, ASIDr);
    }

    // emit call
    if(!haveVADDRr && !haveASIDr) {
        vmimtCall((vmiCallFn)riscvVMInvalidateAll);
    } else if(!haveVADDRr) {
        vmimtCall((vmiCallFn)riscvVMInvalidateAllASID);
    } else if(!haveASIDr) {
        vmimtCall((vmiCallFn)riscvVMInvalidateVA);
    } else {
        vmimtCall((vmiCallFn)riscvVMInvalidateVAASID);
    }
}


////////////////////////////////////////////////////////////////////////////////
// CSR ACCESS INSTRUCTIONS
////////////////////////////////////////////////////////////////////////////////

//
// Indicate whether CSR must be read
//
static Bool doCSRRead(riscvMorphStateP state, vmiReg rd) {
    return (!VMI_ISNOREG(rd) || (state->info.csrUpdate!=RV_CSR_RW));
}

//
// Indicate whether CSR must be written (depending on whether rs1 is zero)
//
static Bool doCSRWriteRS1(riscvMorphStateP state, vmiReg rs1) {
    return (!VMI_ISNOREG(rs1) || (state->info.csrUpdate==RV_CSR_RW));
}

//
// Indicate whether CSR must be written (depending on whether imm is zero)
//
static Bool doCSRWriteImm(riscvMorphStateP state, Uns64 imm) {
    return (imm || (state->info.csrUpdate==RV_CSR_RW));
}

//
// Implement CSR access, either with two GPRs or GPR and immediate
//
static void emitCSRRCommon(riscvMorphStateP state, vmiReg rs1, Bool write) {

    riscvP          riscv = state->riscv;
    Uns32           csr   = state->info.csr;
    riscvRegDesc    rdA   = getRVReg(state, 0);
    vmiReg          rd    = getVMIReg(riscv, rdA);
    Uns32           bits  = getRBits(rdA);
    Bool            read  = doCSRRead(state, rd);
    riscvCSRAttrsCP attrs = riscvValidateCSRAccess(riscv, csr, read, write);

    // action only required for valid access
    if(attrs) {

        vmiReg rdTmp = read ? getTmp(0) : VMI_NOREG;

        // handle traps if mstatus.TVM=1 (e.g. satp register)
        if(attrs->TVMT) {
            EMIT_TRAP_MASK_FIELD(riscv, mstatus, TVM, 1);
        }

        // emit code to read the CSR if required
        if(read) {
            riscvEmitCSRRead(attrs, riscv, rdTmp, write);
        }

        // emit code to write the CSR if required
        if(write) {

            vmiReg rs1Tmp = write ? getTmp(1) : VMI_NOREG;
            vmiReg cbTmp  = getTmp(2);
            Bool   useRS1 = !VMI_ISNOREG(rs1);
            Uns64  c      = state->info.c;

            switch(state->info.csrUpdate) {

                case RV_CSR_RW:
                    if(useRS1) {
                        rs1Tmp = rs1;
                    } else {
                        vmimtMoveRC(bits, rs1Tmp, c);
                    }
                    break;

                case RV_CSR_RS:
                    if(useRS1) {
                        vmimtBinopRRR(bits, vmi_OR, rs1Tmp, rdTmp, rs1, 0);
                    } else {
                        vmimtBinopRRC(bits, vmi_OR, rs1Tmp, rdTmp, c, 0);
                    }
                    break;

                case RV_CSR_RC:
                    if(useRS1) {
                        vmimtBinopRRR(bits, vmi_ANDN, rs1Tmp, rdTmp, rs1, 0);
                    } else {
                        vmimtBinopRRC(bits, vmi_ANDN, rs1Tmp, rdTmp, c, 0);
                    }
                    break;

                default:
                    VMI_ABORT("unimplemented case"); // LCOV_EXCL_LINE
            }

            // do the write
            riscvEmitCSRWrite(attrs, riscv, rs1Tmp, cbTmp);

            // adjust code generator state after CSR write if required
            if(attrs->wstateCB) {
                attrs->wstateCB(state, useRS1);
            }
        }

        // commit read value
        vmimtMoveRR(bits, rd, rdTmp);
        writeReg(riscv, rdA);
    }
}

//
// Implement CSR access (two GPRs)
//
static RISCV_MORPH_FN(emitCSRR) {

    riscvP       riscv = state->riscv;
    riscvRegDesc rs1A  = getRVReg(state, 1);
    vmiReg       rs1   = getVMIReg(riscv, rs1A);
    Bool         write = doCSRWriteRS1(state, rs1);

    emitCSRRCommon(state, rs1, write);
}

//
// Implement CSR access (GPR and immediate)
//
static RISCV_MORPH_FN(emitCSRRI) {

    Bool write = doCSRWriteImm(state, state->info.c);

    emitCSRRCommon(state, VMI_NOREG, write);
}


////////////////////////////////////////////////////////////////////////////////
// FLOATING POINT DATA HANDLING UTILITIES
////////////////////////////////////////////////////////////////////////////////

//
// Int32 macros
//
#define INT32_MIN           0x80000000
#define INT32_MAX           0x7fffffff

//
// Uns32 macros
//
#define UNS32_MIN           0x00000000
#define UNS32_MAX           0xffffffff

//
// Int64 macros
//
#define INT64_MIN           0x8000000000000000ULL
#define INT64_MAX           0x7fffffffffffffffULL

//
// Uns64 macros
//
#define UNS64_MIN           0x0000000000000000ULL
#define UNS64_MAX           0xffffffffffffffffULL

//
// Flt32 macros
//
#define FP32_EXP_ONES       0xff
#define FP32_EXP_SHIFT      23
#define FP32_SIGN_SHIFT     31
#define FP32_SIGN_MASK      (1<<FP32_SIGN_SHIFT)

#define FP32_SIGN(_F)       (((_F) & FP32_SIGN_MASK) != 0)
#define FP32_EXPONENT(_F)   (((_F) & 0x7f800000) >> FP32_EXP_SHIFT)
#define FP32_FRACTION(_F)   ((_F) & ((1<<FP32_EXP_SHIFT)-1))

#define FP32_PLUS_ZERO      (0)
#define FP32_MINUS_ZERO     (FP32_SIGN_MASK)
#define FP32_ISZERO(_F)     (((_F) & ~0x80000000) == 0)
#define FP32_ZERO(_S)       ((_S) ? FP32_MINUS_ZERO : FP32_PLUS_ZERO)

#define FP32_PLUS_INFINITY  (0x7f800000)
#define FP32_MINUS_INFINITY (0xff800000)
#define FP32_INFINITY(_S)   ((_S) ? FP32_MINUS_INFINITY : FP32_PLUS_INFINITY)

#define FP32_DEFAULT_QNAN   0x7fc00000
#define FP32_QNAN_MASK      0x00400000

//
// Flt64 macros
//
#define FP64_EXP_ONES       0x7ff
#define FP64_EXP_SHIFT      52
#define FP64_SIGN_SHIFT     63
#define FP64_SIGN_MASK      (1ULL<<FP64_SIGN_SHIFT)

#define FP64_SIGN(_F)       (((_F) & FP64_SIGN_MASK) != 0)
#define FP64_EXPONENT(_F)   (((_F) & 0x7ff0000000000000ULL) >> FP64_EXP_SHIFT)
#define FP64_FRACTION(_F)   ((_F) & ((1ULL<<FP64_EXP_SHIFT)-1))

#define FP64_PLUS_ZERO      (0ULL)
#define FP64_MINUS_ZERO     (FP64_SIGN_MASK)
#define FP64_ISZERO(_F)     ((_F) & ~0x8000000000000000ULL) == 0)
#define FP64_ZERO(_S)       ((_S) ? FP64_MINUS_ZERO : FP64_PLUS_ZERO)

#define FP64_PLUS_INFINITY  (0x7ff0000000000000ULL)
#define FP64_MINUS_INFINITY (0xfff0000000000000ULL)
#define FP64_INFINITY(_S)   ((_S) ? FP64_MINUS_INFINITY : FP64_PLUS_INFINITY)

#define FP64_DEFAULT_QNAN   0x7ff8000000000000ULL
#define FP64_QNAN_MASK      0x0008000000000000ULL


//
// Is the Flt32 value a NaN or infinity?
//
inline static Bool isNaNorInf32(Uns32 value) {
    return FP32_EXPONENT(value)==FP32_EXP_ONES;
}

//
// Is the Flt64 value a NaN or infinity?
//
inline static Bool isNaNorInf64(Uns64 value) {
    return FP64_EXPONENT(value)==FP64_EXP_ONES;
}

//
// Is the Flt32 value a NaN?
//
inline static Bool isNaN32(Uns32 value) {
    return isNaNorInf32(value) && FP32_FRACTION(value);
}

//
// Is the Flt64 value a NaN?
//
inline static Bool isNaN64(Uns64 value) {
    return isNaNorInf64(value) && FP64_FRACTION(value);
}

//
// Is the Flt32 value an infinity?
//
inline static Bool isInf32(Uns32 value) {
    return isNaNorInf32(value) && !FP32_FRACTION(value);
}

//
// Is the Flt64 value an infinity?
//
inline static Bool isInf64(Uns64 value) {
    return isNaNorInf64(value) && !FP64_FRACTION(value);
}

//
// Is the Flt32 value a denormal?
//
inline static Bool isDenorm32(Uns32 value) {
    return !FP32_EXPONENT(value) && FP32_FRACTION(value);
}

//
// Is the Flt64 value a denormal?
//
inline static Bool isDenorm64(Uns64 value) {
    return !FP64_EXPONENT(value) && FP64_FRACTION(value);
}

//
// Is the Flt32 value a zero?
//
inline static Bool isZero32(Uns32 value) {
    return !(value & ~FP32_SIGN_MASK);
}

//
// Is the Flt64 value a zero?
//
inline static Bool isZero64(Uns64 value) {
    return !(value & ~FP64_SIGN_MASK);
}

//
// Is the Flt32 value a QNaN?
//
inline static Bool isQNaN32(Uns32 value) {
    return isNaN32(value) && (value & FP32_QNAN_MASK);
}

//
// Is the Flt64 value a QNaN?
//
inline static Bool isQNaN64(Uns64 value) {
    return isNaN64(value) && (value & FP64_QNAN_MASK);
}

//
// Is the Flt32 value an SNaN?
//
inline static Bool isSNaN32(Uns32 value) {
    return isNaN32(value) && !(value & FP32_QNAN_MASK);
}

//
// Is the Flt64 value an SNaN?
//
inline static Bool isSNaN64(Uns64 value) {
    return isNaN64(value) && !(value & FP64_QNAN_MASK);
}

//
// Return VMI register for the given abstract register which may require a NaN
// box test if it is floating point
//
vmiReg riscvGetVMIRegFS(riscvP riscv, riscvRegDesc r, vmiReg tmp) {

    Uns32  bits   = getRBits(r);
    vmiReg result = getVMIReg(riscv, r);

    if(isFReg(r)) {

        Uns32 archBits = riscvGetFlenArch(riscv);
        Uns32 fprMask  = getRegMask(r);

        // handle possible switch to QNaN-valued temporary if the source
        // register is smaller than the architectural register size and not
        // known to be NaN-boxed
        if((archBits>bits) && !(riscv->blockState->fpNaNBoxMask&fprMask)) {

            // use temporary corresponding to the input argument
            vmiReg upper = VMI_REG_DELTA(result,bits/8);

            // is the upper half all ones?
            vmimtCompareRC(bits, vmi_COND_EQ, upper, -1, tmp);

            // seed the apparent value, depending on whether the source is
            // correctly NaN-boxed
            vmimtCondMoveRRC(bits, tmp, True, tmp, result, FP32_DEFAULT_QNAN);

            // use the temporary as a source
            result = tmp;
        }
    }

    return result;
}

//
// Return VMI register for the given abstract register which may require a NaN
// box test if it is floating point
//
inline static vmiReg getVMIRegFS(riscvP riscv, riscvRegDesc r, vmiReg tmp) {
    return riscvGetVMIRegFS(riscv, r, tmp);
}

//
// Adjust JIT code generator state after write of floating point register
//
void riscvWFS(riscvMorphStateP state, Bool useRS1) {
    updateFS(state->riscv);
}


////////////////////////////////////////////////////////////////////////////////
// GENERAL QNAN/INDETERMINATE HANDLERS
////////////////////////////////////////////////////////////////////////////////

//
// 32-bit QNaN result - return default QNaN
//
static VMI_FP_QNAN32_RESULT_FN(handleQNaN32) {
    return FP32_DEFAULT_QNAN;
}

//
// 64-bit QNaN result - return default QNaN
//
static VMI_FP_QNAN64_RESULT_FN(handleQNaN64) {
    return FP64_DEFAULT_QNAN;
}

//
// 32-bit indeterminate result (NOTE: signed and unsigned results have distinct
// indeterminate patterns)
//
static VMI_FP_IND32_RESULT_FN(handleIndeterminate32) {

    Uns32 result = 0;

    if(value.type == vmi_FT_32_IEEE_754) {
        if(value.f32Parts.sign && !isNaN32(value.u32)) {
            result = isSigned ? INT32_MIN : UNS32_MIN;
        } else {
            result = isSigned ? INT32_MAX : UNS32_MAX;
        }
    } else if(value.type == vmi_FT_64_IEEE_754) {
        if(value.f64Parts.sign && !isNaN64(value.u64)) {
            result = isSigned ? INT32_MIN : UNS32_MIN;
        } else {
            result = isSigned ? INT32_MAX : UNS32_MAX;
        }
    } else {
        VMI_ABORT("unimplemented type %u", value.type); // LCOV_EXCL_LINE
    }

    return result;
}

//
// 64-bit indeterminate result (NOTE: signed and unsigned results have distinct
// indeterminate patterns)
//
static VMI_FP_IND64_RESULT_FN(handleIndeterminate64) {

    Uns64 result = 0;

    if(value.type == vmi_FT_32_IEEE_754) {
        if(value.f32Parts.sign && !isNaN32(value.u32)) {
            result = isSigned ? INT64_MIN : UNS64_MIN;
        } else {
            result = isSigned ? INT64_MAX : UNS64_MAX;
        }
    } else if(value.type == vmi_FT_64_IEEE_754) {
        if(value.f64Parts.sign && !isNaN64(value.u64)) {
            result = isSigned ? INT64_MIN : UNS64_MIN;
        } else {
            result = isSigned ? INT64_MAX : UNS64_MAX;
        }
    } else {
        VMI_ABORT("unimplemented type %u", value.type); // LCOV_EXCL_LINE
    }

    return result;
}


////////////////////////////////////////////////////////////////////////////////
// ISA VERSION 2.2 MIN/MAX RESULT HANDLERS
////////////////////////////////////////////////////////////////////////////////

//
// Common routine for 32-bit FMIN/FMAX result
//
static Uns32 doMinMax32_2_2(
    Uns32       result32,
    vmiFPArgP   args,
    vmiFPFlagsP setFlags
) {
    Uns32 arg0 = args[0].u32;
    Uns32 arg1 = args[1].u32;

    if(isSNaN32(arg0) || isSNaN32(arg1)) {
        setFlags->f.I = 1;
        result32 = FP32_DEFAULT_QNAN;
    } else if(isNaN32(arg0) && isNaN32(arg1)) {
        result32 = FP32_DEFAULT_QNAN;
    } else if(isNaN32(arg0)) {
        result32 = arg1;
    } else if(isNaN32(arg1)) {
        result32 = arg0;
    }

    return result32;
}

//
// Common routine for 64-bit FMIN/FMAX result
//
static Uns64 doMinMax64_2_2(
    Uns64       result64,
    vmiFPArgP   args,
    vmiFPFlagsP setFlags
) {
    Uns64 arg0 = args[0].u64;
    Uns64 arg1 = args[1].u64;

    if(isSNaN64(arg0) || isSNaN64(arg1)) {
        setFlags->f.I = 1;
        result64 = FP64_DEFAULT_QNAN;
    } else if(isNaN64(arg0) && isNaN64(arg1)) {
        result64 = FP64_DEFAULT_QNAN;
    } else if(isNaN64(arg0)) {
        result64 = arg1;
    } else if(isNaN64(arg1)) {
        result64 = arg0;
    }

    return result64;
}

//
// 32-bit FMIN result handler
//
static VMI_FP_32_RESULT_FN(doFMin32_2_2) {

    if(isZero32(args[0].u32) && isZero32(args[1].u32)) {
        result32 = args[1].u32;
    } else if(isNaNorInf32(result32)) {
        result32 = doMinMax32_2_2(result32, args, setFlags);
    }

    return result32;
}

//
// 32-bit FMAX result handler
//
static VMI_FP_32_RESULT_FN(doFMax32_2_2) {

    if(isZero32(args[0].u32) && isZero32(args[1].u32)) {
        result32 = args[0].u32;
    } else if(isNaNorInf32(result32)) {
        result32 = doMinMax32_2_2(result32, args, setFlags);
    }

    return result32;
}

//
// 64-bit FMIN result handler
//
static VMI_FP_64_RESULT_FN(doFMin64_2_2) {

    if(isZero64(args[0].u64) && isZero64(args[1].u64)) {
        result64 = args[1].u64;
    } else if(isNaNorInf64(result64)) {
        result64 = doMinMax64_2_2(result64, args, setFlags);
    }

    return result64;
}

//
// 64-bit FMAX result handler
//
static VMI_FP_64_RESULT_FN(doFMax64_2_2) {

    if(isZero64(args[0].u64) && isZero64(args[1].u64)) {
        result64 = args[0].u64;
    } else if(isNaNorInf64(result64)) {
        result64 = doMinMax64_2_2(result64, args, setFlags);
    }

    return result64;
}


////////////////////////////////////////////////////////////////////////////////
// ISA VERSION 2.3 MIN/MAX RESULT HANDLERS
////////////////////////////////////////////////////////////////////////////////

//
// Common routine for 32-bit FMIN/FMAX result
//
static Uns32 doMinMax32_2_3(
    Uns32       result32,
    vmiFPArgP   args,
    vmiFPFlagsP setFlags
) {
    Uns32 arg0 = args[0].u32;
    Uns32 arg1 = args[1].u32;

    if(isSNaN32(arg0) || isSNaN32(arg1)) {
        setFlags->f.I = 1;
    }

    if(isNaN32(arg0) && isNaN32(arg1)) {
        result32 = FP32_DEFAULT_QNAN;
    } else if(isNaN32(arg0)) {
        result32 = arg1;
    } else if(isNaN32(arg1)) {
        result32 = arg0;
    }

    return result32;
}

//
// Common routine for 64-bit FMIN/FMAX result
//
static Uns64 doMinMax64_2_3(
    Uns64       result64,
    vmiFPArgP   args,
    vmiFPFlagsP setFlags
) {
    Uns64 arg0 = args[0].u64;
    Uns64 arg1 = args[1].u64;

    if(isSNaN64(arg0) || isSNaN64(arg1)) {
        setFlags->f.I = 1;
    }

    if(isNaN64(arg0) && isNaN64(arg1)) {
        result64 = FP64_DEFAULT_QNAN;
    } else if(isNaN64(arg0)) {
        result64 = arg1;
    } else if(isNaN64(arg1)) {
        result64 = arg0;
    }

    return result64;
}

//
// 32-bit FMIN result handler
//
static VMI_FP_32_RESULT_FN(doFMin32_2_3) {

    if(isZero32(args[0].u32) && isZero32(args[1].u32)) {
        result32 = args[0].u32 | args[1].u32;
    } else if(isNaNorInf32(result32)) {
        result32 = doMinMax32_2_3(result32, args, setFlags);
    }

    return result32;
}

//
// 32-bit FMAX result handler
//
static VMI_FP_32_RESULT_FN(doFMax32_2_3) {

    if(isZero32(args[0].u32) && isZero32(args[1].u32)) {
        result32 = args[0].u32 & args[1].u32;
    } else if(isNaNorInf32(result32)) {
        result32 = doMinMax32_2_3(result32, args, setFlags);
    }

    return result32;
}

//
// 64-bit FMIN result handler
//
static VMI_FP_64_RESULT_FN(doFMin64_2_3) {

    if(isZero64(args[0].u64) && isZero64(args[1].u64)) {
        result64 = args[0].u64 | args[1].u64;
    } else if(isNaNorInf64(result64)) {
        result64 = doMinMax64_2_3(result64, args, setFlags);
    }

    return result64;
}

//
// 64-bit FMAX result handler
//
static VMI_FP_64_RESULT_FN(doFMax64_2_3) {

    if(isZero64(args[0].u64) && isZero64(args[1].u64)) {
        result64 = args[0].u64 & args[1].u64;
    } else if(isNaNorInf64(result64)) {
        result64 = doMinMax64_2_3(result64, args, setFlags);
    }

    return result64;
}


////////////////////////////////////////////////////////////////////////////////
// FLOATING POINT CONFIGURATION AND CONTROL
////////////////////////////////////////////////////////////////////////////////

//
// Define one vmiFPConfig
//
#define FPU_CONFIG(_QH32, _QH64, _R32,  _R64) {         \
    .QNaN32                  = FP32_DEFAULT_QNAN,       \
    .QNaN64                  = FP64_DEFAULT_QNAN,       \
    .QNaN32ResultCB          = _QH32,                   \
    .QNaN64ResultCB          = _QH64,                   \
    .indeterminate32ResultCB = handleIndeterminate32,   \
    .indeterminate64ResultCB = handleIndeterminate64,   \
    .fp32ResultCB            = _R32,                    \
    .fp64ResultCB            = _R64,                    \
    .suppressFlags           = {f:{D:1}},               \
    .stickyFlags             = True                     \
}

//
// Table of floating point operation configurations
//
const static vmiFPConfig fpConfigs[RVFP_LAST] = {

    // normal native operation configuration
    [RVFP_NORMAL]   = FPU_CONFIG(handleQNaN32, handleQNaN64, 0, 0),

    // FMIN/FMAX configurations
    [RVFP_FMIN]     = FPU_CONFIG(0, 0, doFMin32_2_2, doFMin64_2_2),
    [RVFP_FMAX]     = FPU_CONFIG(0, 0, doFMax32_2_2, doFMax64_2_2),
    [RVFP_FMIN_2_3] = FPU_CONFIG(0, 0, doFMin32_2_3, doFMin64_2_3),
    [RVFP_FMAX_2_3] = FPU_CONFIG(0, 0, doFMax32_2_3, doFMax64_2_3),
};

//
// Configure FPU
//
void riscvConfigureFPU(riscvP riscv) {
    vmirtConfigureFPU((vmiProcessorP)riscv, &fpConfigs[RVFP_NORMAL]);
}

//
// Return rounding control for riscvRMDesc
//
inline static vmiFPRC mapRMDescToRC(riscvRMDesc rm) {

    static const vmiFPRC map[] = {
        [RV_RM_CURRENT] = vmi_FPR_CURRENT,
        [RV_RM_RTE]     = vmi_FPR_NEAREST,
        [RV_RM_RTZ]     = vmi_FPR_ZERO,
        [RV_RM_RDN]     = vmi_FPR_NEG_INF,
        [RV_RM_RUP]     = vmi_FPR_POS_INF,
        [RV_RM_RMM]     = vmi_FPR_AWAY,
        [RV_RM_BAD5]    = vmi_FPR_CURRENT,
        [RV_RM_BAD6]    = vmi_FPR_CURRENT
    };

    return map[rm];
}

//
// Return rounding control for rounding mode in FPSR
//
inline static vmiFPRC mapFRMToRC(Uns8 frm) {

    static const vmiFPRC map[] = {
        [0] = vmi_FPR_NEAREST,
        [1] = vmi_FPR_ZERO,
        [2] = vmi_FPR_NEG_INF,
        [3] = vmi_FPR_POS_INF,
        [4] = vmi_FPR_AWAY,
        [5] = -1,
        [6] = -1,
        [7] = -1
    };

    return map[frm];
}

//
// Update current rounding mode
//
void riscvSetRM(riscvP riscv, Uns8 newRM) {

    vmiFPRC rc = mapFRMToRC(newRM);

    if(rc==-1) {

        riscv->fpInvalidRM = True;

    } else {

        vmiFPControlWord cw = {
            .IM = 1, .DM = 1, .ZM = 1, .OM = 1, .UM = 1, .PM = 1, .RC = rc
        };

        vmirtSetFPControlWord((vmiProcessorP)riscv, cw);

        riscv->fpInvalidRM = False;
    }
}


////////////////////////////////////////////////////////////////////////////////
// FLOATING POINT INSTRUCTIONS
////////////////////////////////////////////////////////////////////////////////

//
// Validate the given rounding mode is legal and emit an Illegal Instruction
// exception call if not
//
static Bool emitCheckLegalRM(riscvP riscv, riscvRMDesc rm) {

    riscvBlockStateP blockState = riscv->blockState;
    Bool             validRM    = True;

    if(rm >= RV_RM_BAD5) {

        // static check for illegal mode
        ILLEGAL_INSTRUCTION_MESSAGE(riscv, "IRM", "Illegal rounding mode");
        validRM = False;

    } else if((rm==RV_RM_CURRENT) && !blockState->fpRMChecked) {

        // dynamic check of current mode required (first time in block only)
        vmiLabelP ok = vmimtNewLabel();
        vmimtTestRCJumpLabel(8, vmi_COND_Z, RISCV_INVALID_RM, rm, ok);
        ILLEGAL_INSTRUCTION_MESSAGE(riscv, "IRM", "Illegal rounding mode");
        vmimtInsertLabel(ok);

        // subsequent operations do not require a mode check
        blockState->fpRMChecked = True;
    }

    return validRM;
}

//
// Update current rounding mode if required
//
static Bool emitSetOperationRM(riscvMorphStateP state) {

    riscvP      riscv   = state->riscv;
    riscvRMDesc rm      = state->info.rm;
    Bool        validRM = emitCheckLegalRM(riscv, rm);

    if(validRM) {
        vmimtFSetRounding(mapRMDescToRC(rm));
    }

    return validRM;
}

//
// Return floating point control to use for the current instruction
//
static vmiFPConfigCP getFPControl(riscvMorphStateP state) {

    riscvFPCtrl   ctrl   = state->attrs->fpConfig;
    vmiFPConfigCP result = 0;

    if(ctrl) {

        // fmin/fmax result handling changes from version 2.3
        if(RISCV_USER_VERSION(state->riscv) <= RVUV_2_2) {
            // no action unless User version >= 2.3
        } else if(ctrl==RVFP_FMIN) {
            ctrl = RVFP_FMIN_2_3;
        } else if(ctrl==RVFP_FMAX) {
            ctrl = RVFP_FMAX_2_3;
        } else {
            VMI_ABORT("unexpected control %u", ctrl); // LCOV_EXCL_LINE
        }
    }

    // return selected control
    if(ctrl) {
        result = &fpConfigs[ctrl];
    }

    return result;
}

//
// Move floating point value (two registers)
//
static RISCV_MORPH_FN(emitFMoveRR) {

    riscvP       riscv = state->riscv;
    riscvRegDesc fdA   = getRVReg(state, 0);
    riscvRegDesc fs1A  = getRVReg(state, 1);
    vmiReg       fd    = getVMIReg(riscv, fdA);
    vmiReg       fs1   = getVMIRegFS(riscv, fs1A, getTmp(0));
    Uns32        bits  = getRBits(fdA);

    vmimtMoveRR(bits, fd, fs1);

    writeReg(riscv, fdA);
}

//
// Implement floating point unop
//
static RISCV_MORPH_FN(emitFUnop) {

    riscvP        riscv = state->riscv;
    riscvRegDesc  fdA   = getRVReg(state, 0);
    riscvRegDesc  fs1A  = getRVReg(state, 1);
    vmiReg        fd    = getVMIReg(riscv, fdA);
    vmiReg        fs1   = getVMIRegFS(riscv, fs1A, getTmp(1));
    vmiFType      type  = getRegFType(fdA);
    vmiFUnop      op    = state->attrs->fpUnop;
    vmiFPConfigCP ctrl  = getFPControl(state);

    if(emitSetOperationRM(state)) {
        vmimtFUnopRR(type, op, fd, fs1, RISCV_FP_FLAGS, ctrl);
        writeReg(riscv, fdA);
    }
}

//
// Implement floating point binop
//
static RISCV_MORPH_FN(emitFBinop) {

    riscvP        riscv = state->riscv;
    riscvRegDesc  fdA   = getRVReg(state, 0);
    riscvRegDesc  fs1A  = getRVReg(state, 1);
    riscvRegDesc  fs2A  = getRVReg(state, 2);
    vmiReg        fd    = getVMIReg(riscv, fdA);
    vmiReg        fs1   = getVMIRegFS(riscv, fs1A, getTmp(1));
    vmiReg        fs2   = getVMIRegFS(riscv, fs2A, getTmp(2));
    vmiFType      type  = getRegFType(fdA);
    vmiFBinop     op    = state->attrs->fpBinop;
    vmiFPConfigCP ctrl  = getFPControl(state);

    if(emitSetOperationRM(state)) {
        vmimtFBinopRRR(type, op, fd, fs1, fs2, RISCV_FP_FLAGS, ctrl);
        writeReg(riscv, fdA);
    }
}

//
// Implement floating point ternop
//
static RISCV_MORPH_FN(emitFTernop) {

    riscvP        riscv = state->riscv;
    riscvRegDesc  fdA   = getRVReg(state, 0);
    riscvRegDesc  fs1A  = getRVReg(state, 1);
    riscvRegDesc  fs2A  = getRVReg(state, 2);
    riscvRegDesc  fs3A  = getRVReg(state, 3);
    vmiReg        fd    = getVMIReg(riscv, fdA);
    vmiReg        fs1   = getVMIRegFS(riscv, fs1A, getTmp(1));
    vmiReg        fs2   = getVMIRegFS(riscv, fs2A, getTmp(2));
    vmiReg        fs3   = getVMIRegFS(riscv, fs3A, getTmp(3));
    vmiFType      type  = getRegFType(fdA);
    vmiFTernop    op    = state->attrs->fpTernop;
    vmiFPConfigCP ctrl  = getFPControl(state);

    if(emitSetOperationRM(state)) {
        vmimtFTernopRRRR(type, op, fd, fs1, fs2, fs3, RISCV_FP_FLAGS, False, ctrl);
        writeReg(riscv, fdA);
    }
}

//
// Implement floating point conversion
//
static RISCV_MORPH_FN(emitFConvert) {

    riscvP        riscv = state->riscv;
    riscvRegDesc  fdA   = getRVReg(state, 0);
    riscvRegDesc  fsA   = getRVReg(state, 1);
    vmiReg        fd    = getVMIReg(riscv, fdA);
    vmiReg        fs    = getVMIRegFS(riscv, fsA, getTmp(1));
    vmiFType      typeD = getRegFType(fdA);
    vmiFType      typeS = getRegFType(fsA);
    vmiFPRC       rc    = mapRMDescToRC(state->info.rm);
    vmiFPConfigCP ctrl  = getFPControl(state);

    if(emitCheckLegalRM(riscv, state->info.rm)) {
        vmimtFConvertRR(typeD, fd, typeS, fs, rc, RISCV_FP_FLAGS, ctrl);
        writeReg(riscv, fdA);
    }
}

//
// Implement floating point comparison
//
static RISCV_MORPH_FN(emitFCompare) {

    riscvP        riscv     = state->riscv;
    riscvRegDesc  rdA       = getRVReg(state, 0);
    riscvRegDesc  fs1A      = getRVReg(state, 1);
    riscvRegDesc  fs2A      = getRVReg(state, 2);
    vmiReg        rd        = getVMIReg(riscv, rdA);
    vmiReg        fs1       = getVMIRegFS(riscv, fs1A, getTmp(1));
    vmiReg        fs2       = getVMIRegFS(riscv, fs2A, getTmp(2));
    vmiFType      typeS     = getRegFType(fs1A);
    vmiFPRelation relation  = state->attrs->fpRel;
    vmiFlags      flags     = {f:{[vmi_ZF]=rd}, negate:vmi_FN_ZF};
    Bool          allowQNaN = state->attrs->fpQNaNOk;
    vmiFPConfigCP ctrl      = getFPControl(state);

    // set least-significant byte of 'rd' with the required result
    vmimtFCompareRR(typeS, rd, fs1, fs2, RISCV_FP_FLAGS, allowQNaN, ctrl);
    vmimtBinopRC(8, vmi_AND, rd, relation, &flags);

    writeRegSize(riscv, rdA, 8);
}

//
// Implement fsgnj, fsgnjn or fsgnjx operation
//
static RISCV_MORPH_FN(emitFSgn) {

    riscvP       riscv = state->riscv;
    riscvRegDesc fdA   = getRVReg(state, 0);
    riscvRegDesc fs1A  = getRVReg(state, 1);
    riscvRegDesc fs2A  = getRVReg(state, 2);
    vmiReg       fd    = getVMIReg(riscv, fdA);
    vmiReg       fs1   = getVMIRegFS(riscv, fs1A, getTmp(1));
    vmiReg       fs2   = getVMIRegFS(riscv, fs2A, getTmp(2));
    Uns32        bits  = getRBits(fdA);
    Uns64        mask  = (-1ULL<<(bits-1));
    vmiReg       tmp   = getTmp(0);

    // get required section of fs1 in tmp
    if(state->attrs->clearFS1) {
        vmimtBinopRRC(bits, vmi_AND, tmp, fs1, ~mask, 0);
    } else {
        vmimtMoveRR(bits, tmp, fs1);
    }

    // get required section of fs2
    vmimtBinopRRC(bits, vmi_AND, fd, fs2, mask, 0);

    // negate fd sign if required
    if(state->attrs->negFS2) {
        vmimtBinopRC(bits, vmi_XOR, fd, mask, 0);
    }

    // merge with tmp
    vmimtBinopRR(bits, vmi_XOR, fd, tmp, 0);

    writeReg(riscv, fdA);
}

//
// Enumeration of FClass values
//
typedef enum riscvFClassE {
    RVFC_NINF    = 1<<0,
    RVFC_NNORM   = 1<<1,
    RVFC_NDENORM = 1<<2,
    RVFC_NZERO   = 1<<3,
    RVFC_PZERO   = 1<<4,
    RVFC_PDENORM = 1<<5,
    RVFC_PNORM   = 1<<6,
    RVFC_PINF    = 1<<7,
    RVFC_SNAN    = 1<<8,
    RVFC_QNAN    = 1<<9,
} riscvFClass;

//
// Implement 32-bit FClass operation
//
static riscvFClass doFClass32(Uns32 value) {

    Bool        isSigned = (value & FP32_SIGN_MASK) && True;
    riscvFClass result;

    if(isSNaN32(value)) {
        result = RVFC_SNAN;
    } else if(isQNaN32(value)) {
        result = RVFC_QNAN;
    } else if(isInf32(value)) {
        result = isSigned ? RVFC_NINF : RVFC_PINF;
    } else if(isDenorm32(value)) {
        result = isSigned ? RVFC_NDENORM : RVFC_PDENORM;
    } else if(isZero32(value)) {
        result = isSigned ? RVFC_NZERO : RVFC_PZERO;
    } else {
        result = isSigned ? RVFC_NNORM : RVFC_PNORM;
    }

    return result;
}

//
// Implement 64-bit FClass operation
//
static riscvFClass doFClass64(Uns64 value) {

    Bool        isSigned = (value & FP64_SIGN_MASK) && True;
    riscvFClass result;

    if(isSNaN64(value)) {
        result = RVFC_SNAN;
    } else if(isQNaN64(value)) {
        result = RVFC_QNAN;
    } else if(isInf64(value)) {
        result = isSigned ? RVFC_NINF : RVFC_PINF;
    } else if(isDenorm64(value)) {
        result = isSigned ? RVFC_NDENORM : RVFC_PDENORM;
    } else if(isZero64(value)) {
        result = isSigned ? RVFC_NZERO : RVFC_PZERO;
    } else {
        result = isSigned ? RVFC_NNORM : RVFC_PNORM;
    }

    return result;
}

//
// Implement fclass operation
//
static RISCV_MORPH_FN(emitFClass) {

    riscvP       riscv = state->riscv;
    riscvRegDesc rdA   = getRVReg(state, 0);
    riscvRegDesc fs1A  = getRVReg(state, 1);
    vmiReg       rd    = getVMIReg(riscv, rdA);
    vmiReg       fs1   = getVMIRegFS(riscv, fs1A, getTmp(1));
    Uns32        bitsD = 32;
    Uns32        bitsS = getRBits(fs1A);
    vmiCallFn    cb    = 0;

    // get function implementing fclass
    if(bitsS==32) {
        cb = (vmiCallFn)doFClass32;
    } else if(bitsS==64) {
        cb = (vmiCallFn)doFClass64;
    } else {
        VMI_ABORT("unimplemented bits %u", bitsS); // LCOV_EXCL_LINE
    }

    // call function
    vmimtArgReg(bitsS, fs1);
    vmimtCallResultAttrs(cb, bitsD, rd, VMCA_PURE);

    writeRegSize(riscv, rdA, bitsD);
}


////////////////////////////////////////////////////////////////////////////////
// VECTOR UNIT CONFIGURATION
////////////////////////////////////////////////////////////////////////////////

//
// Configure vector extension
//
void riscvConfigureVector(riscvP riscv) {

    if(riscv->configInfo.arch & ISA_V) {

        Uns32 vRegBytes   = riscv->configInfo.VLEN/8;
        Uns32 stripeBytes = riscv->configInfo.SLEN/8;
        Uns32 stripes     = vRegBytes/stripeBytes;
        Uns32 stripe;
        Uns32 byte;
        Uns32 i;

        // iterate over stripes
        for(stripe=0; stripe<stripes; stripe++) {

            // iterate over stripe bytes
            for(byte=0; byte<stripeBytes; byte++) {

                // initialize LMULx1 index table
                for(i=0; i<1; i++) {

                    Uns32 index = byte + (stripeBytes*i) + (stripe*stripeBytes*1);
                    Uns32 value = byte + (vRegBytes*i) + (stripe*stripeBytes);

                    riscv->offsetsLMULx1[index] = value;
                }

                // initialize LMULx2 index table
                for(i=0; i<2; i++) {

                    Uns32 index = byte + (stripeBytes*i) + (stripe*stripeBytes*2);
                    Uns32 value = byte + (vRegBytes*i) + (stripe*stripeBytes);

                    riscv->offsetsLMULx2[index] = value;
                }

                // initialize LMULx4 index table
                for(i=0; i<4; i++) {

                    Uns32 index = byte + (stripeBytes*i) + (stripe*stripeBytes*4);
                    Uns32 value = byte + (vRegBytes*i) + (stripe*stripeBytes);

                    riscv->offsetsLMULx4[index] = value;
                }

                // initialize LMULx8 index table
                for(i=0; i<8; i++) {

                    Uns32 index = byte + (stripeBytes*i) + (stripe*stripeBytes*8);
                    Uns32 value = byte + (vRegBytes*i) + (stripe*stripeBytes);

                    riscv->offsetsLMULx8[index] = value;
                }
            }
        }

        // show derived vector indices if required
        if(RISCV_DEBUG_VECTIDX(riscv)) {

            vmiPrintf(
                "\nVLEN=%u SLEN=%u\n",
                riscv->configInfo.VLEN,
                riscv->configInfo.SLEN
            );

            vmiPrintf("\nLMULx2 TABLE\n");
            for(i=0; i<2; i++) {
                for(byte=0; byte<vRegBytes; byte++) {
                    vmiPrintf("%3u ", riscv->offsetsLMULx2[i*vRegBytes+byte]);
                }
                vmiPrintf("\n");
            }

            vmiPrintf("\nLMULx4 TABLE\n");
            for(i=0; i<4; i++) {
                for(byte=0; byte<vRegBytes; byte++) {
                    vmiPrintf("%3u ", riscv->offsetsLMULx4[i*vRegBytes+byte]);
                }
                vmiPrintf("\n");
            }

            vmiPrintf("\nLMULx8 TABLE\n");
            for(i=0; i<8; i++) {
                for(byte=0; byte<vRegBytes; byte++) {
                    vmiPrintf("%3u ", riscv->offsetsLMULx8[i*vRegBytes+byte]);
                }
                vmiPrintf("\n");
            }

            vmiPrintf("\n");
        }
    }
}


////////////////////////////////////////////////////////////////////////////////
// VECTOR OPERATION DISPATCH
////////////////////////////////////////////////////////////////////////////////

//
// This type describes a base register of a given size
//
typedef struct baseDescS {
    vmiReg reg;     // base register
    Uns8   bytes;   // size of this base
    Bool   striped; // whether a striped base
} baseDesc, *baseDescP;

//
// Context for generic vector operation
//
typedef struct iterDescS {
    riscvVLMULMt VLMUL;                 // effective VLMUL
    riscvSEWMt   SEW;                   // effective SEW
    Uns32        MLEN;                  // effective MLEN
    vmiReg       mask;                  // mask register
    vmiReg       r[RV_MAX_AREGS];       // argument registers
    baseDesc     base[NUM_BASE_REGS];   // base registers
    Uns32        vBytesMax;             // vector size (including padding)
    vmiLabelP    masked;                // target if element not selected by mask
    vmiLabelP    skip;                  // target if body is skipped
    void        *userData;              // operation-specific data
    Bool         striped;               // whether striped operand layout
} iterDesc;

//
// Dispatch vector callback function
//
inline static void dispatchVector(
    riscvMorphStateP state,
    riscvMorphVFn    vectorCB,
    iterDescP        id
) {
    if(vectorCB) {
        vectorCB(state, id);
    }
}

//
// Convert vsew field to riscvSEWMt type
//
inline static riscvSEWMt vsewToSEW(Uns32 vsew) {
    return 8<<vsew;
}

//
// Convert vlmul field to riscvVLMULMt type
//
inline static riscvVLMULMt vlmulToVLMUL(Uns32 vlmul) {
    return 1<<vlmul;
}

//
// Return a base register to use for the given element size
//
static vmiReg *getBaseRegister(iterDescP id, Uns32 bytes, Bool striped) {

    Uns32 i;

    for(i=0; i<NUM_BASE_REGS; i++) {

        baseDescP base = &id->base[i];

        if(!base->bytes) {

            base->reg     = RISCV_CPU_VBASE(i);
            base->bytes   = bytes;
            base->striped = striped;

            return &base->reg;

        } else if((base->striped==striped) && (base->bytes==bytes)) {

            return &base->reg;
        }
    }

    VMI_ABORT("too many base registers"); // LCOV_EXCL_LINE
    return 0;
}

//
// Zero vstart register
//
static void setVStartZero(riscvMorphStateP state) {

    state->riscv->blockState->VStartZeroMt = True;

    vmimtMoveRC(32, CSR_REG_MT(vstart), 0);
}

//
// Get effective vector length multiplier
//
static riscvVLMULMt getVLMULMt(riscvP riscv) {

    riscvBlockStateP blockState = riscv->blockState;
    riscvVLMULMt     VLMUL      = blockState->VLMULMt;

    if(VLMUL==VLMULMT_UNKNOWN) {

        vmimtPolymorphicBlock(RISCV_VTYPE_KEY);

        blockState->VLMULMt = VLMUL = vlmulToVLMUL(RD_CSR_FIELD(riscv, vtype, vlmul));
    }

    return VLMUL;
}

//
// Return SEW for the current vector operation
//
static riscvSEWMt getSEWMt(riscvP riscv) {

    riscvBlockStateP blockState = riscv->blockState;
    riscvSEWMt       SEW        = blockState->SEWMt;

    if(SEW==SEWMT_UNKNOWN) {

        vmimtPolymorphicBlock(RISCV_VTYPE_KEY);

        blockState->SEWMt = SEW = vsewToSEW(RD_CSR_FIELD(riscv, vtype, vsew));
    }

    return SEW;
}

//
// Get effective zero/non-zero/max vector length
//
static riscvVLClassMt getVLClassMt(riscvMorphStateP state) {

    riscvP           riscv      = state->riscv;
    riscvBlockStateP blockState = riscv->blockState;
    riscvVLClassMt   vlClass    = blockState->VLClassMt;

    if(vlClass==VLCLASSMT_UNKNOWN) {

        Uns32        vl    = RD_CSR(riscv, vl);
        riscvSEWMt   SEW   = getSEWMt(riscv);
        riscvVLMULMt VLMUL = getVLMULMt(riscv);
        Uns32        vlMax = riscv->configInfo.VLEN*VLMUL/SEW;

        vmimtPolymorphicBlock(RISCV_VTYPE_KEY);

        if(!vl) {
            vlClass = VLCLASSMT_ZERO;
        } else if(vl>=vlMax) {
            vlClass = VLCLASSMT_MAX;
        } else {
            vlClass = VLCLASSMT_NONZERO;
        }

        blockState->VLClassMt = vlClass;
    }

    return vlClass;
}

//
// Return width multiplier for widening/narrowing operations
//
inline static Uns32 getWidthMultiplier(riscvVWCtrl vwCtrl) {

    static const Uns8 map[] = {
        [RVVW_NORMAL]   = 1,
        [RVVW_NARROWx2] = 2,
        [RVVW_WIDEx211] = 2,
        [RVVW_WIDEx221] = 2,
        [RVVW_WIDEx4]   = 4,
    };

    return map[vwCtrl];
}

//
// Return width multiplier for operation Nth vector argument
//
static Uns32 getWidthMultiplierN(riscvVWCtrl vwCtrl, Uns32 argIndex) {

    // clamp argument index to maximum
    if(argIndex>2) {
        argIndex = 2;
    }

    // lookup table giving element width multipliers for vector arguments 0, 1
    // and other (including mask)
    static const Uns8 map[][3] = {
        [RVVW_NORMAL]   = {1,1,1},
        [RVVW_NARROWx2] = {1,2,1},
        [RVVW_WIDEx211] = {2,1,1},
        [RVVW_WIDEx221] = {2,2,1},
        [RVVW_WIDEx4]   = {4,1,1},
    };

    return map[vwCtrl][argIndex];
}

//
// Is the index of the given register in the mask?
//
inline static Bool regInMask(riscvRegDesc rA, Uns32 mask) {
    return mask & (1<<getRIndex(rA));
}

//
// When a destination is widened with respect to a source, validate no source
// overlaps the wide destination
//
static Bool validateWideNarrowOverlap(riscvMorphStateP state, Uns32 mulD) {

    riscvP       riscv   = state->riscv;
    riscvVLMULMt VLMUL   = getVLMULMt(riscv)*mulD;
    riscvRegDesc mask    = state->info.mask;
    riscvRegDesc rD      = getRVReg(state, 0);
    Uns32        index   = getRIndex(rD);
    Uns32        badMask = 0;
    Bool         ok      = True;
    Uns32        i;

    // construct mask of registers that may not be sources
    for(i=0; i<VLMUL; i++) {
        Uns32 part = i+index;
        if(part<VREG_NUM) {
            badMask |= (1<<part);
        }
    }

    // if mask is present, validate no overlap
    if(mask && regInMask(mask, badMask)) {
        ok = False;
    }

    // validate no overlap for all other vector sources
    for(i=1; i<RV_MAX_AREGS; i++) {
        riscvRegDesc rA = getRVReg(state, i);
        if(isVReg(rA) && regInMask(rA, badMask)) {
            ok = False;
        }
    }

    return ok;
}

//
// Validate widening/narrowing arguments
//
static Bool validateWideNarrow(riscvMorphStateP state) {

    riscvVWCtrl vwCtrl = state->attrs->vwCtrl;
    Uns32       mul    = getWidthMultiplier(vwCtrl);
    Bool        ok     = True;

    if(mul != 1) {

        riscvP       riscv = state->riscv;
        riscvSEWMt   SEW   = mul * getSEWMt(riscv);
        riscvVLMULMt VLMUL = mul * getVLMULMt(riscv);
        Uns32        mulD  = getWidthMultiplierN(vwCtrl, 0);

        if(SEW>riscv->configInfo.ELEN) {
            ILLEGAL_INSTRUCTION_MESSAGE(riscv, "ISEW", "Illegal widened SEW");
            ok = False;
        } else if(VLMUL>VLMULMT_8) {
            ILLEGAL_INSTRUCTION_MESSAGE(riscv, "IVLMUL", "Illegal widened VLMUL");
            ok = False;
        } else if((mulD!=1) && !validateWideNarrowOverlap(state, mulD)) {
            ILLEGAL_INSTRUCTION_MESSAGE(riscv, "IOVP", "Illegal register overlap");
            ok = False;
        }
    }

    return ok;
}

//
// Widen source operands if required
//
static void widenOperands(riscvMorphStateP state, iterDescP id) {

    riscvVWCtrl vwCtrl = state->attrs->vwCtrl;
    Uns32       mul    = getWidthMultiplier(vwCtrl);
    Uns32       tmpIdx = NUM_TEMPS;
    Uns32       i;

    // process each operand
    for(i=0; i<RV_MAX_AREGS; i++) {

        riscvRegDesc rA = getRVReg(state, i);

        // handle each vector argument
        if(isVReg(rA)) {

            Uns32 mulA = getWidthMultiplierN(vwCtrl, i);

            // detect arguments requiring extension
            if(mulA!=mul) {

                riscvSEWMt srcSEW  = getSEWMt(state->riscv);
                riscvSEWMt dstSEW  = srcSEW * mul;
                vmiReg     tmpA    = getTmp(--tmpIdx);
                Bool       sExtend = state->attrs->sExtend;

                // extend to temporary
                vmimtMoveExtendRR(dstSEW, tmpA, srcSEW, id->r[i], sExtend);

                // use extended temporary as source or destination
                id->r[i] = tmpA;
            }
        }
    }
}

//
// Return VMI register for the given abstract vector register
//
static vmiReg getVMIVReg(riscvMorphStateP state, riscvRegDesc r, Uns32 argIndex) {

    riscvP       riscv  = state->riscv;
    riscvVWCtrl  vwCtrl = state->attrs->vwCtrl;
    Uns32        mulE   = getWidthMultiplierN(vwCtrl, argIndex);
    riscvVLMULMt VLMUL  = getVLMULMt(riscv)*mulE;
    Uns32        index  = getRIndex(r);

    // validate register index is a multiple of the current VLMUL
    if(index & (VLMUL-1)) {
        ILLEGAL_INSTRUCTION_MESSAGE(riscv, "IVI", "Illegal vector register index");
    }

    return getVMIReg(riscv, r);
}

//
// Return a Boolean indicating whether the register requires its top part to be
// zeroed
//
static Bool requireTopZero(riscvP riscv, riscvRegDesc rdA) {

    riscvBlockStateP blockState = riscv->blockState;
    Uns32            index      = getRIndex(rdA);
    Uns32            mask       = 1<<index;
    Bool             result     = !(blockState->VZeroTopMt & mask);

    blockState->VZeroTopMt |= mask;

    return result;
}

//
// Fill all registers for a vector operation
//
static void getMaskedOpRegisters(riscvMorphStateP state, iterDescP id) {

    riscvP       riscv = state->riscv;
    riscvRegDesc mask  = state->info.mask;
    Uns32        i;

    id->mask = mask ? getVMIVReg(state, mask, 2) : VMI_NOREG;

    for(i=0; i<RV_MAX_AREGS; i++) {

        riscvRegDesc rA = getRVReg(state, i);
        vmiReg       r  = VMI_NOREG;

        if(isVReg(rA)) {
            r = getVMIVReg(state, rA, i);
        } else if(rA) {
            r = getVMIReg(riscv, rA);
        }

        id->r[i] = r;
    }
}

//
// Convert vector register to indexed register
//
static void getIndexedRegister(
    iterDescP id,
    vmiReg   *rP,
    Uns32     stride,
    Uns32     vecBytes,
    Bool      striped
) {
    if(!VMI_ISNOREG(*rP)) {
        vmiReg *baseP = getBaseRegister(id, stride, striped);
        vmimtGetIndexedRegister(rP, baseP, vecBytes);
    }
}

//
// Convert vector argument registers to indexed registers
//
static void getIndexedVRegisters(
    riscvMorphStateP state,
    iterDescP        id,
    Bool             striped
) {
    riscvVWCtrl vwCtrl   = state->attrs->vwCtrl;
    Uns32       strideV  = id->SEW/8;
    Uns32       vecBytes = state->riscv->configInfo.VLEN/8*id->VLMUL;
    Uns32       i;

    for(i=0; i<RV_MAX_AREGS; i++) {

        if(isVReg(getRVReg(state, i))) {

            Uns32 mulE = getWidthMultiplierN(vwCtrl, i);

            getIndexedRegister(
                id, &id->r[i], strideV*mulE, vecBytes*mulE, striped
            );
        }
    }
}

//
// Adjust vector base registers to account for offset
//
static void addOffsetToBaseRegisters(
    riscvMorphStateP state,
    iterDescP        id,
    vmiReg           offset
) {
    Uns32 i;

    for(i=0; i<NUM_BASE_REGS; i++) {

        baseDescP base = &id->base[i];

        if(base->bytes) {

            Uns32 eScale   = base->bytes*8/id->SEW;
            Uns32 vecBytes = id->vBytesMax * eScale;

            vmimtAddBaseR(base->reg, offset, base->bytes, vecBytes, False, False);
        }
    }
}

//
// Return offset index table register for the current operation
//
static vmiReg getOffsetIndexTable(
    riscvMorphStateP state,
    iterDescP        id,
    vmiReg          *offsetBaseP,
    Uns32            eBytes
) {
    Uns32        eScale     = eBytes*8/id->SEW;
    riscvVLMULMt VLMUL      = id->VLMUL*eScale;
    vmiReg       offsetIdx  = VMI_NOREG;
    Uns32        tableBytes = id->vBytesMax*eScale * sizeof(riscvStrideOffset);

    // get table for the given VLMUL
    if(VLMUL==VLMULMT_1) {
        offsetIdx = RISCV_OFFSETS_LMULx1;
    } else if(VLMUL==VLMULMT_2) {
        offsetIdx = RISCV_OFFSETS_LMULx2;
    } else if(VLMUL==VLMULMT_4) {
        offsetIdx = RISCV_OFFSETS_LMULx4;
    } else if(VLMUL==VLMULMT_8) {
        offsetIdx = RISCV_OFFSETS_LMULx8;
    } else {
        VMI_ABORT("Unexpected VLMUL %u", VLMUL); // LCOV_EXCL_LINE
    }

    // convert to indexed register
    vmimtGetIndexedRegister(&offsetIdx, offsetBaseP, tableBytes);

    return offsetIdx;
}

//
// Convert vector registers to indexed registers
//
static void startVectorOp(riscvMorphStateP state, iterDescP id, void *userData) {

    riscvP      riscv  = state->riscv;
    Uns32       VLEN   = riscv->configInfo.VLEN;
    Uns32       SLEN   = riscv->configInfo.SLEN;
    riscvVWCtrl vwCtrl = state->attrs->vwCtrl;

    // fill operation-specific data
    id->userData  = userData;
    id->VLMUL     = getVLMULMt(riscv);
    id->SEW       = getSEWMt(riscv);
    id->MLEN      = id->SEW/id->VLMUL;
    id->striped   = ((vwCtrl!=RVVW_NORMAL) || (id->VLMUL>1)) && (VLEN>SLEN);
    id->vBytesMax = riscv->configInfo.VLEN * id->VLMUL / 8;

    // get stride and total vector bytes
    Uns32 strideM  = id->MLEN/8;
    Uns32 vecBytes = VLEN/8;

    // get indexed mask register if mask stride is a byte multiple (otherwise
    // masking requires a bit test operation)
    if(strideM) {
        getIndexedRegister(id, &id->mask, strideM, vecBytes, False);
    }

    // convert vector argument registers to indexed registers unless they are
    // striped (in which case, this is done inside the vector loop)
    if(!id->striped) {
        getIndexedVRegisters(state, id, False);
    }

    // set first-fault active indication if required
    if(state->info.isFF) {
        vmimtMoveRC(8, RISCV_FF, True);
    }

    if(!riscv->blockState->VStartZeroMt) {

        vmiReg vstart = CSR_REG_MT(vstart);

        // clamp initial vstart to maximum vl
        vmiLabelP noClamp = vmimtNewLabel();
        vmimtCompareRRJumpLabel(32, vmi_COND_LE, vstart, RISCV_VLMAX, noClamp);
        vmimtMoveRR(32, vstart, RISCV_VLMAX);
        vmimtInsertLabel(noClamp);

        // adjust vector base registers to account for non-zero vstart
        addOffsetToBaseRegisters(state, id, vstart);

        // go to zero extension operation if vstart equals maximum vl
        id->skip = vmimtNewLabel();
        vmimtCompareRRJumpLabel(32, vmi_COND_EQ, vstart, RISCV_VLMAX, id->skip);
    }

    // call operation-specific initialization if required
    dispatchVector(state, state->attrs->initCB, id);
}

//
// Increment unstriped base registers at the end of a vector operation
//
static void updateUnstripedBaseRegisters(iterDescP id) {

    Uns32 i;

    for(i=0; i<NUM_BASE_REGS; i++) {

        baseDescP base = &id->base[i];

        if(base->bytes && !base->striped) {
            vmimtAddBaseC(base->reg, base->bytes, 0);
        }
    }
}

//
// Update striped base registers
//
static void updateStripedBaseRegisters(riscvMorphStateP state, iterDescP id) {

    Uns32  offsetBits = IMPERAS_POINTER_BITS;
    vmiReg offset     = getTmp(NUM_TEMPS-1);
    Uns32  lutEBytes  = sizeof(riscvStrideOffset);
    Uns32  lutEBits   = lutEBytes * 8;
    Uns32  bytes;
    Uns32  i;

    // convert vector argument registers to indexed registers
    getIndexedVRegisters(state, id, True);

    // process each possible element size
    for(bytes=1; bytes<=8; bytes*=2) {

        // process each base register
        for(i=0; i<NUM_BASE_REGS; i++) {

            baseDescP base = &id->base[i];

            if(base->striped && (base->bytes==bytes)) {

                vmiReg index      = CSR_REG_MT(vstart);
                vmiReg offsetBase = RISCV_OFFSET_BASE;
                Uns32  scale      = bytes*lutEBytes;
                Uns32  eScale     = bytes*8/id->SEW;
                Uns32  lutBytes   = VBYTES_MAX * lutEBytes * id->VLMUL * eScale;
                Uns32  vecBytes   = id->vBytesMax * eScale;

                // get index table to use
                vmiReg offsetIdx = getOffsetIndexTable(
                    state, id, &offsetBase, bytes
                );

                // handle table offset scale > 8
                if(scale>8) {
                    vmimtBinopRRC(offsetBits, vmi_MUL, offset, index, scale, 0);
                    index = offset;
                    scale = 1;
                }

                // adjust table base using scaled index
                vmimtAddBaseR(offsetBase, index, scale, lutBytes, False, False);

                // get offset from table
                vmimtMoveExtendRR(offsetBits, offset, lutEBits, offsetIdx, False);

                // update base
                vmimtAddBaseR(base->reg, offset, 1, vecBytes, False, False);
            }
        }
    }
}

//
// Kill striped base registers
//
static void killStripedBaseRegisters(riscvMorphStateP state, iterDescP id) {

    Uns32  i;

    // process each base register
    for(i=0; i<NUM_BASE_REGS; i++) {

        baseDescP base = &id->base[i];

        if(base->striped) {
            base->bytes = 0;
        }
    }
}

//
// Start one loop iteration
//
static void startVectorLoop(riscvMorphStateP state, iterDescP id) {

    // handle element masking if required
    if(!VMI_ISNOREG(id->mask)) {

        riscvP riscv   = state->riscv;
        Uns32  VLEN    = riscv->configInfo.VLEN;
        vmiReg vstart  = CSR_REG_MT(vstart);
        Uns32  strideM = id->MLEN/8;

        // create target label if element is masked out
        id->masked = vmimtNewLabel();

        if(strideM) {

            // mask stride is a byte multiple: simple bit test
            vmimtTestRCJumpLabel(32, vmi_COND_Z, id->mask, 1, id->masked);

        } else {

            // mask stride is not a byte multiple: bit test and jump
            vmiReg mbit = vstart;

            // scale bit index if required
            if(id->MLEN!=1) {
                mbit = getTmp(NUM_TEMPS-1);
                vmimtBinopRRC(32, vmi_MUL, mbit, vstart, id->MLEN, 0);
            }

            // do bit operation
            vmimtTestBitVRJumpLabel(VLEN, 32, False, id->mask, mbit, id->masked);
        }
    }

    // handle vector register striping if required
    if(id->striped) {
        updateStripedBaseRegisters(state, id);
    }
}

//
// End one loop iteration
//
static void endVectorLoop(riscvMorphStateP state, iterDescP id, vmiLabelP loop) {

    vmiReg vstart = CSR_REG_MT(vstart);

    // here if element is not selected by mask
    if(id->masked) {
        vmimtInsertLabel(id->masked);
    }

    // call operation-specific post-element function if required
    dispatchVector(state, state->attrs->postOpCB, id);

    // increment unstriped base registers
    updateUnstripedBaseRegisters(id);

    // increment vstart and go if not done
    vmimtBinopRC(32, vmi_ADD, vstart, 1, 0);
    vmimtCompareRRJumpLabel(32, vmi_COND_L, vstart, RISCV_VLMAX, loop);
}

//
// Convert vector registers to indexed registers
//
static void endVectorOp(
    riscvMorphStateP state,
    iterDescP        id,
    riscvVLClassMt   vlClass
) {
    riscvP       riscv   = state->riscv;
    riscvRegDesc rdA     = getRVReg(state, 0);
    Bool         zeroTop = requireTopZero(riscv, rdA);
    vmiLabelP    noZero  = 0;

    // call operation-specific post-operation function if required
    dispatchVector(state, state->attrs->endCB, id);

    // here if body is skipped because initial vstart > vl
    if(id->skip) {
        vmimtInsertLabel(id->skip);
    }

    // fill top part of target register with zero if required
    if(zeroTop && (vlClass!=VLCLASSMT_MAX)) {

        Uns32     vecBitsxN = riscv->configInfo.VLEN*id->VLMUL;
        Uns32     vecElemxN = vecBitsxN/id->SEW;
        vmiReg    vstart    = CSR_REG_MT(vstart);
        vmiReg    count     = getTmp(NUM_TEMPS-1);

        // insert code to skip zeroing of top half if first fault has been
        // triggered
        if(state->info.isFF) {
            noZero = vmimtNewLabel();
            vmimtCondJumpLabel(RISCV_FF, False, noZero);
        }

        if(id->striped) {

            vmiLabelP done = vmimtNewLabel();
            vmiLabelP loop = vmimtNewLabel();

            vmimtCompareRCJumpLabel(32, vmi_COND_EQ, vstart, vecElemxN, done);

            // here for next iteration
            vmimtInsertLabel(loop);

            // update striped base registers for this iteration
            updateStripedBaseRegisters(state, id);

            // zero target register element
            vmimtMoveRC(id->SEW, id->r[0], 0);

            // kill striped base registers for this iteration
            killStripedBaseRegisters(state, id);

            // increment vstart and repeat if not done
            vmimtBinopRC(32, vmi_ADD, vstart, 1, 0);
            vmimtCompareRCJumpLabel(32, vmi_COND_NE, vstart, vecElemxN, loop);

            // here if done
            vmimtInsertLabel(done);

        } else {

            // calculate number of elements to clear
            vmimtBinopRCR(32, vmi_SUB, count, vecElemxN, vstart, 0);

            // zero register top part (can be zero, in which case no zeroing is
            // required)
            vmimtZeroRV(
                vecBitsxN, id->r[0], 32, count, 0, id->SEW/8, vmi_CC_EQ_ZERO
            );
        }
    }

    // clear first-fault active indication if required
    if(state->info.isFF) {

        // here if zeroing of top half is skipped
        vmimtInsertLabel(noZero);

        // set first-fault active indication
        vmimtMoveRC(8, RISCV_FF, False);

        // terminate the block after this instruction because VL may be modified
        // if an exception is trapped
        vmimtEndBlock();
    }
}

//
// Emit code to dispatch a vector operation
//
static void emitVMaskedOp(riscvMorphStateP state, void *userData) {

    iterDesc       id      = {0};
    riscvVLClassMt vlClass = getVLClassMt(state);

    // fill all registers for a vector operation (NOTE: this can cause Illegal
    // Instruction exceptions for inappropriate register arguments, so it must
    // be done before zero-length vector check)
    getMaskedOpRegisters(state, &id);

    if(!validateWideNarrow(state)) {

        // widening/narrowing argument widths are invalid

    } else if(vlClass==VLCLASSMT_ZERO) {

        // if vector length is zero, a special case is to take no action except
        // to zero vstart on completion

    } else {

        // vector length is non-zero (normal case)
        vmiLabelP   loop   = vmimtNewLabel();
        riscvVWCtrl vwCtrl = state->attrs->vwCtrl;
        Uns32       mul    = getWidthMultiplier(vwCtrl);

        // start a new vector operation
        startVectorOp(state, &id, userData);

        // loop to here
        vmimtInsertLabel(loop);

        // do actions at start of vector loop
        startVectorLoop(state, &id);

        // widen source operands if required
        widenOperands(state, &id);

        // do operation on one element, scaling the operation SEW if required
        id.SEW *= mul;
        dispatchVector(state, state->attrs->opCB, &id);
        id.SEW /= mul;

        // kill striped base registers for this iteration
        killStripedBaseRegisters(state, &id);

        // repeat until done
        endVectorLoop(state, &id, loop);

        // perform actions at end of instruction
        endVectorOp(state, &id, vlClass);
    }

    // zero vstart register on instruction completion
    setVStartZero(state);
}


////////////////////////////////////////////////////////////////////////////////
// VECTOR CSR UPDATE
////////////////////////////////////////////////////////////////////////////////

//
// Adjust JIT code generator state after write of vstart CSR
//
void riscvWVStart(riscvMorphStateP state, Bool useRS1) {

    riscvBlockStateP blockState = state->riscv->blockState;

    if(!useRS1 && (state->info.csrUpdate==RV_CSR_RW) && !state->info.c) {
        blockState->VStartZeroMt = True;
    } else {
        blockState->VStartZeroMt = False;
    }
}

//
// Adjust JIT code generator state after write of vtype CSR
//
void riscvWVType(riscvMorphStateP state, Bool useRS1) {

    if(!useRS1 && (state->info.csrUpdate==RV_CSR_RW)) {

        // get vtype fields
        CSR_REG_DECL(vtype) = {u32 : {bits:state->info.c & WM32_vtype}};

        // write of constant value to vtype
        riscvP       riscv = state->riscv;
        riscvVLMULMt VLMUL = vlmulToVLMUL(vtype.u32.fields.vlmul);
        riscvSEWMt   SEW   = riscvValidSEW(riscv, vtype.u32.fields.vsew);

        // update morph-time SEW and VLMUL, which are now known
        riscv->blockState->SEWMt   = SEW;
        riscv->blockState->VLMULMt = VLMUL;

    } else {

        // terminate the block after this instruction because SEW and VLMUL are
        // now unknown
        vmimtEndBlock();
    }
}

//
// Is the specified SEW valid?
//
riscvSEWMt riscvValidSEW(riscvP riscv, Uns8 vsew) {

    Uns32 SEW = vsewToSEW(vsew);

    return (SEW<=riscv->configInfo.ELEN) ? SEW : SEWMT_UNKNOWN;
}

//
// Update VL, SEW and VLMUL
//
static Uns32 setVLSEWLMULInt(riscvP riscv, Uns32 vl, Uns32 vsew, Uns32 vlmul) {

    if(!riscvValidSEW(riscv, vsew)) {

        // report invalid SEW
        if(riscv->verbose) {
            vmiMessage("W", CPU_PREFIX "_ADF",
                SRCREF_FMT "Illegal instruction - Unsupported SEW e%u",
                SRCREF_ARGS(riscv, getPC(riscv)),
                vsewToSEW(vsew)
            );
        }

        // take Illegal Instruction exception
        riscvIllegalInstruction(riscv);

    } else {

        // update vtype CSR
        riscvSetVType(riscv, vsew, vlmul);

        // update vl CSR
        riscvSetVL(riscv, vl);

        // set matching polymorphic key and clamped vl
        riscvRefreshVectorKey(riscv);
    }

    return RD_CSR(riscv, vl);
}

//
// VSetVL to specified size
//
static Uns32 setVLSEWLMUL(riscvP riscv, Uns32 vl, Uns32 vtypeBits) {

    CSR_REG_DECL(vtype) = {u32 : {bits:vtypeBits}};

    Uns32 vsew  = vtype.u32.fields.vsew;
    Uns32 vlmul = vtype.u32.fields.vlmul;

    return setVLSEWLMULInt(riscv, vl, vsew, vlmul);
}

//
// VSetVL to maximum supported size
//
static Uns32 setMaxVLSEWLMUL(riscvP riscv, Uns32 vtypeBits) {

    CSR_REG_DECL(vtype) = {u32 : {bits:vtypeBits}};

    Uns32 vsew  = vtype.u32.fields.vsew;
    Uns32 vlmul = vtype.u32.fields.vlmul;

    // compute effective VLMAX
    Uns32        VLEN  = riscv->configInfo.VLEN;
    riscvSEWMt   SEW   = vsewToSEW(vsew);
    riscvVLMULMt VLMUL = vlmulToVLMUL(vlmul);
    Uns32        VLMAX = (VLMUL*VLEN)/SEW;

    return setVLSEWLMULInt(riscv, VLMAX, vsew, vlmul);
}

//
// Handle the first source argument of VSetVL
//
static vmiCallFn handleVSetVLArg1(Uns32 bits, vmiReg rs1) {

    if(VMI_ISNOREG(rs1)) {
        return (vmiCallFn)setMaxVLSEWLMUL;
    } else {
        vmimtArgReg(bits, rs1);
        return (vmiCallFn)setVLSEWLMUL;
    }
}

//
// Implement VSetVL <rd>, <rs1>, <rs2> operation
//
static RISCV_MORPH_FN(emitVSetVLRRR) {

    riscvP       riscv = state->riscv;
    riscvRegDesc rdA   = getRVReg(state, 0);
    riscvRegDesc rs1A  = getRVReg(state, 1);
    riscvRegDesc rs2A  = getRVReg(state, 2);
    vmiReg       rd    = getVMIReg(riscv, rdA);
    vmiReg       rs1   = getVMIReg(riscv, rs1A);
    vmiReg       rs2   = getVMIReg(riscv, rs2A);
    Uns32        bits  = 32;

    // call function (may cause exception for invalid SEW)
    vmimtArgProcessor();
    vmiCallFn cb = handleVSetVLArg1(bits, rs1);
    vmimtArgReg(bits, rs2);
    vmimtCallResultAttrs(cb, bits, rd, VMCA_EXCEPTION|VMCA_NO_INVALIDATE);
    writeRegSize(riscv, rdA, bits);

    // terminate the block after this instruction because SEW and VLMUL are
    // now unknown
    vmimtEndBlock();
}

//
// Implement VSetVL <rd>, <rs1>, <vtypei> operation
//
static RISCV_MORPH_FN(emitVSetVLRRC) {

    riscvP       riscv = state->riscv;
    riscvRegDesc rdA   = getRVReg(state, 0);
    riscvRegDesc rs1A  = getRVReg(state, 1);
    vmiReg       rd    = getVMIReg(riscv, rdA);
    vmiReg       rs1   = getVMIReg(riscv, rs1A);
    Uns32        bits  = 32;
    Uns8         vsew  = state->info.vsew;
    Uns8         vlmul = state->info.vlmul;
    riscvSEWMt   SEW   = riscvValidSEW(riscv, vsew);

    if(!SEW) {

        // take Illegal Instruction exception
        ILLEGAL_INSTRUCTION_MESSAGE(riscv, "ISEW", "Unsupported SEW");

    } else {

        // call function (invalid SEW is checked here and therefore does not
        // cause exceptions from within the callback)
        vmimtArgProcessor();
        vmiCallFn cb = handleVSetVLArg1(bits, rs1);
        vmimtArgUns32((vsew<<2)+vlmul);
        vmimtCallResultAttrs(cb, bits, rd, VMCA_NO_INVALIDATE);
        writeRegSize(riscv, rdA, bits);

        if(VMI_ISNOREG(rs1)) {

            riscvBlockStateP blockState = riscv->blockState;
            riscvVLMULMt     VLMUL      = vlmulToVLMUL(vlmul);

            // reset knowledge of registers that have top parts zeroed unless
            // previous configuration had the same VLMUL and was also set to
            // maximum size
            if(
                (blockState->VLClassMt != VLCLASSMT_MAX) ||
                (blockState->VLMULMt   != VLMUL)
            ) {
                blockState->VZeroTopMt = 0;
            }

            // update morph-time VLClass, SEW and VLMUL, which are now known,
            // and reset record of vectors known to have top half zeroed
            blockState->VLClassMt = VLCLASSMT_MAX;
            blockState->SEWMt     = SEW;
            blockState->VLMULMt   = VLMUL;

        } else {

            // terminate the block after this instruction because VLClass is now
            // unknown
            vmimtEndBlock();
        }
    }
}


////////////////////////////////////////////////////////////////////////////////
// VECTOR MEMORY ACCESS INSTRUCTIONS
////////////////////////////////////////////////////////////////////////////////

//
// Operation-specific data for vector loads and stores
//
typedef struct VLdStInfoS {
    vmiReg raTmp;       // temporary address register
    Uns32  raBits;      // address register bits
    Uns32  memBits;     // memory bits
    Bool   isValid;     // whether SEW/memBits combination valid
} VLdStInfo, *VLdStInfoP;

//
// Return the memory element size in bits
//
static Uns32 getVMemBits(riscvMorphStateP state) {

    Uns32 memBits = state->info.memBits;

    if(memBits==-1) {
        memBits = getSEWMt(state->riscv);
    }

    return memBits;
}

//
// Is the specified SEW/memBits pair legal?
//
inline static Bool legalVMemBits(riscvSEWMt SEW, Uns32 memBits) {
    return memBits<=SEW;
}

//
// Operation-specific initialization for unit-stride loads and stores
//
static RISCV_MORPHV_FN(emitVLdStUInitCB) {

    riscvP     riscv   = state->riscv;
    VLdStInfoP ud      = id->userData;
    vmiReg     ra      = id->r[1];
    vmiReg     raTmp   = ud->raTmp;
    Uns32      raBits  = ud->raBits;
    Uns32      memBits = ud->memBits;
    vmiReg     vstart  = CSR_REG_MT(vstart);

    // validate SEW/memBits combination
    ud->isValid = legalVMemBits(id->SEW, memBits);

    // prepare temporary address register if size specifications are legal
    if(!ud->isValid) {
        ILLEGAL_INSTRUCTION_MESSAGE(riscv, "IMB", "SEW < memory element bits");
    } else if(riscv->blockState->VStartZeroMt) {
        vmimtMoveRR(raBits, raTmp, ra);
    } else if(memBits==SEWMT_8) {
        vmimtBinopRRR(raBits, vmi_ADD, raTmp, ra, vstart, 0);
    } else {
        vmimtBinopRRC(raBits, vmi_MUL, raTmp, vstart, memBits>>3, 0);
        vmimtBinopRR(raBits, vmi_ADD, raTmp, ra, 0);
    }
}

//
// Per-element callback for unit-stride loads
//
static RISCV_MORPHV_FN(emitVLdUCB) {

    VLdStInfoP ud = id->userData;

    // load one element if legal memBits/SEW combination
    if(ud->isValid) {
        vmimtLoadRRO(
            id->SEW,
            ud->memBits,
            0,
            id->r[0],
            ud->raTmp,
            getDataEndian(state->riscv),
            !state->info.unsExt,
            MEM_CONSTRAINT_ALIGNED
        );
    }
}

//
// Per-element callback for unit-stride stores
//
static RISCV_MORPHV_FN(emitVStUCB) {

    VLdStInfoP ud = id->userData;

    // load one element if legal memBits/SEW combination
    if(ud->isValid) {
        vmimtStoreRRO(
            ud->memBits,
            0,
            ud->raTmp,
            id->r[0],
            getDataEndian(state->riscv),
            MEM_CONSTRAINT_ALIGNED
        );
    }
}

//
// Operation-specific post-operation callback for unit-stride loads and stores
//
static RISCV_MORPHV_FN(emitVLdStUPostOpCB) {

    VLdStInfoP ud = id->userData;

    // increment source pointer if legal memBits/SEW combination
    if(ud->isValid) {
        vmimtBinopRC(ud->raBits, vmi_ADD, ud->raTmp, ud->memBits>>3, 0);
    }
}

//
// Implement vector load / store (unit-stride)
//
static RISCV_MORPH_FN(emitVLdStU) {

    // get operation context
    VLdStInfo info = {
        raTmp   : getTmp(0),
        raBits  : getRBits(getRVReg(state, 1)),
        memBits : getVMemBits(state)
    };

    // dispatch operation
    emitVMaskedOp(state, &info);
}


////////////////////////////////////////////////////////////////////////////////
// VECTOR SINGLE WIDTH INTEGER INSTRUCTIONS
////////////////////////////////////////////////////////////////////////////////

//
// Per-element callback for single-width integer instructions with two register
// operands
//
static RISCV_MORPHV_FN(emitVRSingleIntCB) {

    vmiReg arg2 = id->r[2];

    vmimtBinopRRR(id->SEW, state->attrs->binop, id->r[0], id->r[1], arg2, 0);
}

//
// Per-element callback for single-width integer instructions with register and
// constant operands
//
static RISCV_MORPHV_FN(emitVISingleIntCB) {

    Uns64 arg2 = state->info.c;

    vmimtBinopRRC(id->SEW, state->attrs->binop, id->r[0], id->r[1], arg2, 0);
}

//
// Per-element callback for single-width integer min/max instructions with two
// register operands
//
static RISCV_MORPHV_FN(emitVRMinMaxIntCB) {

    vmiReg arg2 = id->r[2];
    vmiReg flag = getTmp(0);

    vmimtCompareRR(id->SEW, state->attrs->cond, id->r[1], arg2, flag);
    vmimtCondMoveRRR(id->SEW, flag, True, id->r[0], id->r[1], arg2);
}


////////////////////////////////////////////////////////////////////////////////
// VECTOR SIMPLE INSTRUCTION DISPATCH (NO SPECIFIC DATA)
////////////////////////////////////////////////////////////////////////////////

//
// Implement vector load / store (unit-stride)
//
static RISCV_MORPH_FN(emitVSimple) {
    emitVMaskedOp(state, 0);
}


////////////////////////////////////////////////////////////////////////////////
// INSTRUCTION TABLE
////////////////////////////////////////////////////////////////////////////////

//
// Dispatch table for instruction translation
//
const static riscvMorphAttr dispatchTable[] = {

    // move pseudo-instructions (register and constant source)
    [RV_IT_MV_R]        = {morph:emitMoveRR},
    [RV_IT_MV_C]        = {morph:emitMoveRC},

    // base R-type instructions
    [RV_IT_ADD_R]       = {morph:emitBinopRRR,  binop:vmi_ADD,    iClass:OCL_IC_INTEGER},
    [RV_IT_AND_R]       = {morph:emitBinopRRR,  binop:vmi_AND,    iClass:OCL_IC_INTEGER},
    [RV_IT_OR_R]        = {morph:emitBinopRRR,  binop:vmi_OR,     iClass:OCL_IC_INTEGER},
    [RV_IT_SLL_R]       = {morph:emitBinopRRR,  binop:vmi_SHL,    iClass:OCL_IC_INTEGER},
    [RV_IT_SLT_R]       = {morph:emitCmpopRRR,  cond :vmi_COND_L, iClass:OCL_IC_INTEGER},
    [RV_IT_SLTU_R]      = {morph:emitCmpopRRR,  cond :vmi_COND_B, iClass:OCL_IC_INTEGER},
    [RV_IT_SRA_R]       = {morph:emitBinopRRR,  binop:vmi_SAR,    iClass:OCL_IC_INTEGER},
    [RV_IT_SRL_R]       = {morph:emitBinopRRR,  binop:vmi_SHR,    iClass:OCL_IC_INTEGER},
    [RV_IT_SUB_R]       = {morph:emitBinopRRR,  binop:vmi_SUB,    iClass:OCL_IC_INTEGER},
    [RV_IT_XOR_R]       = {morph:emitBinopRRR,  binop:vmi_XOR,    iClass:OCL_IC_INTEGER},

    // M-extension R-type instructions
    [RV_IT_DIV_R]       = {morph:emitBinopRRR,  binop:vmi_IDIV,   iClass:OCL_IC_INTEGER},
    [RV_IT_DIVU_R]      = {morph:emitBinopRRR,  binop:vmi_DIV,    iClass:OCL_IC_INTEGER},
    [RV_IT_MUL_R]       = {morph:emitBinopRRR,  binop:vmi_MUL,    iClass:OCL_IC_INTEGER},
    [RV_IT_MULH_R]      = {morph:emitMulopHRRR, binop:vmi_IMUL,   iClass:OCL_IC_INTEGER},
    [RV_IT_MULHSU_R]    = {morph:emitMULHSU                   ,   iClass:OCL_IC_INTEGER},
    [RV_IT_MULHU_R]     = {morph:emitMulopHRRR, binop:vmi_MUL,    iClass:OCL_IC_INTEGER},
    [RV_IT_REM_R]       = {morph:emitBinopRRR,  binop:vmi_IREM,   iClass:OCL_IC_INTEGER},
    [RV_IT_REMU_R]      = {morph:emitBinopRRR,  binop:vmi_REM,    iClass:OCL_IC_INTEGER},

    // base I-type instructions
    [RV_IT_ADDI_I]      = {morph:emitBinopRRC,  binop:vmi_ADD,    iClass:OCL_IC_INTEGER},
    [RV_IT_ANDI_I]      = {morph:emitBinopRRC,  binop:vmi_AND,    iClass:OCL_IC_INTEGER},
    [RV_IT_JALR_I]      = {morph:emitJALR                                              },
    [RV_IT_ORI_I]       = {morph:emitBinopRRC,  binop:vmi_OR,     iClass:OCL_IC_INTEGER},
    [RV_IT_SLTI_I]      = {morph:emitCmpopRRC,  cond :vmi_COND_L, iClass:OCL_IC_INTEGER},
    [RV_IT_SLTIU_I]     = {morph:emitCmpopRRC,  cond :vmi_COND_B, iClass:OCL_IC_INTEGER},
    [RV_IT_SLLI_I]      = {morph:emitBinopRRC,  binop:vmi_SHL,    iClass:OCL_IC_INTEGER},
    [RV_IT_SRAI_I]      = {morph:emitBinopRRC,  binop:vmi_SAR,    iClass:OCL_IC_INTEGER},
    [RV_IT_SRLI_I]      = {morph:emitBinopRRC,  binop:vmi_SHR,    iClass:OCL_IC_INTEGER},
    [RV_IT_XORI_I]      = {morph:emitBinopRRC,  binop:vmi_XOR,    iClass:OCL_IC_INTEGER},

    // base I-type instructions for load and store
    [RV_IT_L_I]         = {morph:emitLoad },
    [RV_IT_S_I]         = {morph:emitStore},

    // base I-type instructions for CSR access (register)
    [RV_IT_CSRR_I]      = {morph:emitCSRR,   iClass:OCL_IC_SYSREG  },

    // base I-type instructions for CSR access (constant)
    [RV_IT_CSRRI_I]     = {morph:emitCSRRI,  iClass:OCL_IC_SYSREG  },

    // miscellaneous system I-type instructions
    [RV_IT_EBREAK_I]    = {morph:emitEBREAK, iClass:OCL_IC_SYSTEM  },
    [RV_IT_ECALL_I]     = {morph:emitECALL,  iClass:OCL_IC_SYSTEM  },
    [RV_IT_FENCEI_I]    = {morph:emitNOP,    iClass:OCL_IC_IBARRIER},
    [RV_IT_MRET_I]      = {morph:emitMRET,   iClass:OCL_IC_SYSTEM  },
    [RV_IT_SRET_I]      = {morph:emitSRET,   iClass:OCL_IC_SYSTEM  },
    [RV_IT_URET_I]      = {morph:emitURET,   iClass:OCL_IC_SYSTEM  },
    [RV_IT_WFI_I]       = {morph:emitWFI,    iClass:OCL_IC_SYSTEM  },

    // system fence I-type instruction
    [RV_IT_FENCE_I]     = {morph:emitNOP,    iClass:OCL_IC_DBARRIER},

    // system fence R-type instruction
    [RV_IT_FENCE_VMA_R] = {morph:emitSFENCE_VMA, iClass:OCL_IC_SYSTEM|OCL_IC_MMU},

    // base U-type instructions
    [RV_IT_AUIPC_U]     = {morph:emitMoveRPC, binop:vmi_ADD, iClass:OCL_IC_INTEGER},

    // base B-type instructions
    [RV_IT_BEQ_B]       = {morph:emitBranchRR, cond:vmi_COND_EQ},
    [RV_IT_BGE_B]       = {morph:emitBranchRR, cond:vmi_COND_NL},
    [RV_IT_BGEU_B]      = {morph:emitBranchRR, cond:vmi_COND_NB},
    [RV_IT_BLT_B]       = {morph:emitBranchRR, cond:vmi_COND_L },
    [RV_IT_BLTU_B]      = {morph:emitBranchRR, cond:vmi_COND_B },
    [RV_IT_BNE_B]       = {morph:emitBranchRR, cond:vmi_COND_NE},

    // base J-type instructions
    [RV_IT_JAL_J]       = {morph:emitJAL},

    // A-extension R-type instructions
    [RV_IT_AMOADD_R]    = {morph:emitAMOBinopRRR, binop:vmi_ADD    },
    [RV_IT_AMOAND_R]    = {morph:emitAMOBinopRRR, binop:vmi_AND    },
    [RV_IT_AMOMAX_R]    = {morph:emitAMOCmpopRRR, cond :vmi_COND_NL},
    [RV_IT_AMOMAXU_R]   = {morph:emitAMOCmpopRRR, cond :vmi_COND_NB},
    [RV_IT_AMOMIN_R]    = {morph:emitAMOCmpopRRR, cond :vmi_COND_L },
    [RV_IT_AMOMINU_R]   = {morph:emitAMOCmpopRRR, cond :vmi_COND_B },
    [RV_IT_AMOOR_R]     = {morph:emitAMOBinopRRR, binop:vmi_OR     },
    [RV_IT_AMOSWAP_R]   = {morph:emitAMOSwapRRR                    },
    [RV_IT_AMOXOR_R]    = {morph:emitAMOBinopRRR, binop:vmi_XOR    },
    [RV_IT_LR_R]        = {morph:emitLR, iClass:OCL_IC_EXCLUSIVE   },
    [RV_IT_SC_R]        = {morph:emitSC, iClass:OCL_IC_EXCLUSIVE   },

    // F-extension and D-extension R-type instructions
    [RV_IT_FMV_R]       = {                      morph:emitFMoveRR                                                      },
    [RV_IT_FABS_R]      = {fpConfig:RVFP_NORMAL, morph:emitFUnop,    fpUnop  : vmi_FQABS                                },
    [RV_IT_FADD_R]      = {fpConfig:RVFP_NORMAL, morph:emitFBinop,   fpBinop : vmi_FADD                                 },
    [RV_IT_FCLASS_R]    = {fpConfig:RVFP_NORMAL, morph:emitFClass,                         iClass:OCL_IC_FLOAT          },
    [RV_IT_FCVT_R]      = {fpConfig:RVFP_NORMAL, morph:emitFConvert                                                     },
    [RV_IT_FDIV_R]      = {fpConfig:RVFP_NORMAL, morph:emitFBinop,   fpBinop : vmi_FDIV,   iClass:OCL_IC_DIVIDE         },
    [RV_IT_FEQ_R]       = {fpConfig:RVFP_NORMAL, morph:emitFCompare, fpRel   : vmi_FPRL_EQUAL,               fpQNaNOk: 1},
    [RV_IT_FLE_R]       = {fpConfig:RVFP_NORMAL, morph:emitFCompare, fpRel   : vmi_FPRL_LESS|vmi_FPRL_EQUAL, fpQNaNOk: 0},
    [RV_IT_FLT_R]       = {fpConfig:RVFP_NORMAL, morph:emitFCompare, fpRel   : vmi_FPRL_LESS,                fpQNaNOk: 0},
    [RV_IT_FMAX_R]      = {fpConfig:RVFP_FMAX,   morph:emitFBinop,   fpBinop : vmi_FMAX                                 },
    [RV_IT_FMIN_R]      = {fpConfig:RVFP_FMIN,   morph:emitFBinop,   fpBinop : vmi_FMIN                                 },
    [RV_IT_FMUL_R]      = {fpConfig:RVFP_NORMAL, morph:emitFBinop,   fpBinop : vmi_FMUL,   iClass:OCL_IC_MULTIPLY       },
    [RV_IT_FNEG_R]      = {fpConfig:RVFP_NORMAL, morph:emitFUnop,    fpUnop  : vmi_FQNEG                                },
    [RV_IT_FSGNJ_R]     = {fpConfig:RVFP_NORMAL, morph:emitFSgn,     clearFS1:1, negFS2:0, iClass:OCL_IC_FLOAT          },
    [RV_IT_FSGNJN_R]    = {fpConfig:RVFP_NORMAL, morph:emitFSgn,     clearFS1:1, negFS2:1, iClass:OCL_IC_FLOAT          },
    [RV_IT_FSGNJX_R]    = {fpConfig:RVFP_NORMAL, morph:emitFSgn,     clearFS1:0, negFS2:0, iClass:OCL_IC_FLOAT          },
    [RV_IT_FSQRT_R]     = {fpConfig:RVFP_NORMAL, morph:emitFUnop,    fpUnop  : vmi_FSQRT,  iClass:OCL_IC_SQRT           },
    [RV_IT_FSUB_R]      = {fpConfig:RVFP_NORMAL, morph:emitFBinop,   fpBinop : vmi_FSUB                                 },

    // F-extension and D-extension R4-type instructions
    [RV_IT_FMADD_R4]    = {fpConfig:RVFP_NORMAL, morph:emitFTernop,  fpTernop: vmi_FMADD,  iClass:OCL_IC_FMA            },
    [RV_IT_FMSUB_R4]    = {fpConfig:RVFP_NORMAL, morph:emitFTernop,  fpTernop: vmi_FMSUB,  iClass:OCL_IC_FMA            },
    [RV_IT_FNMADD_R4]   = {fpConfig:RVFP_NORMAL, morph:emitFTernop,  fpTernop: vmi_FNMADD, iClass:OCL_IC_FMA            },
    [RV_IT_FNMSUB_R4]   = {fpConfig:RVFP_NORMAL, morph:emitFTernop,  fpTernop: vmi_FNMSUB, iClass:OCL_IC_FMA            },

    // X-extension instructions
    [RV_IT_CUSTOM]      = {morph:emitCustomAbsent },

    // V-extension R-type instructions
    [RV_IT_VSETVL_R]    = {morph:emitVSetVLRRR},

    // V-extension I-type
    [RV_IT_VSETVL_I]    = {morph:emitVSetVLRRC},

    // V-extension load/store instructions
    [RV_IT_VL_I]        = {morph:emitVLdStU,  opCB:emitVLdUCB, initCB:emitVLdStUInitCB, postOpCB:emitVLdStUPostOpCB},
//  TODO: RV_IT_VLS_I,
//  TODO: RV_IT_VLX_I,
    [RV_IT_VS_I]        = {morph:emitVLdStU,  opCB:emitVStUCB, initCB:emitVLdStUInitCB, postOpCB:emitVLdStUPostOpCB},
//  TODO: RV_IT_VSS_I,
//  TODO: RV_IT_VSX_I,

    // V-extension IVV-type instructions
    [RV_IT_VADD_VV]     = {morph:emitVSimple, opCB:emitVRSingleIntCB, binop:vmi_ADD},
    [RV_IT_VSUB_VV]     = {morph:emitVSimple, opCB:emitVRSingleIntCB, binop:vmi_SUB},
    [RV_IT_VMINU_VV]    = {morph:emitVSimple, opCB:emitVRMinMaxIntCB, cond :vmi_COND_B},
    [RV_IT_VMIN_VV]     = {morph:emitVSimple, opCB:emitVRMinMaxIntCB, cond :vmi_COND_L},
    [RV_IT_VMAXU_VV]    = {morph:emitVSimple, opCB:emitVRMinMaxIntCB, cond :vmi_COND_NB},
    [RV_IT_VMAX_VV]     = {morph:emitVSimple, opCB:emitVRMinMaxIntCB, cond :vmi_COND_NL},
    [RV_IT_VAND_VV]     = {morph:emitVSimple, opCB:emitVRSingleIntCB, binop:vmi_AND},
    [RV_IT_VOR_VV]      = {morph:emitVSimple, opCB:emitVRSingleIntCB, binop:vmi_OR },
    [RV_IT_VXOR_VV]     = {morph:emitVSimple, opCB:emitVRSingleIntCB, binop:vmi_XOR},
//  TODO: RV_IT_VRGATHER_VV,
//  TODO: RV_IT_VADC_VV,
//  TODO: RV_IT_VSBC_VV,
//  TODO: RV_IT_VMERGE_VV,
//  TODO: RV_IT_VSEQ_VV,
//  TODO: RV_IT_VSNE_VV,
//  TODO: RV_IT_VSLTU_VV,
//  TODO: RV_IT_VSLT_VV,
//  TODO: RV_IT_VSLEU_VV,
//  TODO: RV_IT_VSLE_VV,
//  TODO: RV_IT_VSGTU_VV,
//  TODO: RV_IT_VSGT_VV,
//  TODO: RV_IT_VSADDU_VV,
//  TODO: RV_IT_VSADD_VV,
//  TODO: RV_IT_VSSUBU_VV,
//  TODO: RV_IT_VSSUB_VV,
//  TODO: RV_IT_VAADD_VV,
//  TODO: RV_IT_VSLL_VV,
//  TODO: RV_IT_VASUB_VV,
//  TODO: RV_IT_VSMUL_VV,
//  TODO: RV_IT_VSRL_VV,
//  TODO: RV_IT_VSRA_VV,
//  TODO: RV_IT_VSSRL_VV,
//  TODO: RV_IT_VSSRA_VV,
//  TODO: RV_IT_VNSRL_VV,
//  TODO: RV_IT_VNSRA_VV,
//  TODO: RV_IT_VNCLIPU_VV,
//  TODO: RV_IT_VNCLIP_VV,
//  TODO: RV_IT_VWREDSUMU_VS,
//  TODO: RV_IT_VWREDSUM_VS,
//  TODO: RV_IT_VDOTU_VV,
//  TODO: RV_IT_VDOT_VV,
//  TODO: RV_IT_VWSMACCU_VV,
//  TODO: RV_IT_VWSMACC_VV,
//  TODO: RV_IT_VWSMSCCU_VV,
//  TODO: RV_IT_VWSMSCC_VV,

    // V-extension FVV-type instructions
//  TODO: RV_IT_VFADD_VV,
//  TODO: RV_IT_VFREDSUM_VS,
//  TODO: RV_IT_VFSUB_VV,
//  TODO: RV_IT_VFREDOSUM_VS,
//  TODO: RV_IT_VFMIN_VV,
//  TODO: RV_IT_VFREDMIN_VS,
//  TODO: RV_IT_VFMAX_VV,
//  TODO: RV_IT_VFREDMAX_VS,
//  TODO: RV_IT_VFSGNJ_VV,
//  TODO: RV_IT_VFSGNJN_VV,
//  TODO: RV_IT_VFSGNJX_VV,
//  TODO: RV_IT_VFMV_F_S,
//  TODO: RV_IT_VFEQ_VV,
//  TODO: RV_IT_VFLTE_VV,
//  TODO: RV_IT_VFORD_VV,
//  TODO: RV_IT_VFLT_VV,
//  TODO: RV_IT_VFNE_VV,
//  TODO: RV_IT_VFDIV_VV,
//  TODO: RV_IT_VFCVT_XUF_V,
//  TODO: RV_IT_VFCVT_XF_V,
//  TODO: RV_IT_VFCVT_FXU_V,
//  TODO: RV_IT_VFCVT_FX_V,
//  TODO: RV_IT_VFWCVT_XUF_V,
//  TODO: RV_IT_VFWCVT_XF_V,
//  TODO: RV_IT_VFWCVT_FXU_V,
//  TODO: RV_IT_VFWCVT_FX_V,
//  TODO: RV_IT_VFWCVT_FF_V,
//  TODO: RV_IT_VFNCVT_XUF_V,
//  TODO: RV_IT_VFNCVT_XF_V,
//  TODO: RV_IT_VFNCVT_FXU_V,
//  TODO: RV_IT_VFNCVT_FX_V,
//  TODO: RV_IT_VFNCVT_FF_V,
//  TODO: RV_IT_VFSQRT_V,
//  TODO: RV_IT_VFCLASS_V,
//  TODO: RV_IT_VFMUL_VV,
//  TODO: RV_IT_VFMADD_VV,
//  TODO: RV_IT_VFNMADD_VV,
//  TODO: RV_IT_VFMSUB_VV,
//  TODO: RV_IT_VFNMSUB_VV,
//  TODO: RV_IT_VFMACC_VV,
//  TODO: RV_IT_VFNMACC_VV,
//  TODO: RV_IT_VFMSAC_VV,
//  TODO: RV_IT_VFNMSAC_VV,
//  TODO: RV_IT_VFWADD_VV,
//  TODO: RV_IT_VFWREDSUM_VS,
//  TODO: RV_IT_VFWSUB_VV,
//  TODO: RV_IT_VFWREDOSUM_VS,
//  TODO: RV_IT_VFWADD_WV,
//  TODO: RV_IT_VFWSUB_WV,
//  TODO: RV_IT_VFWMUL_VV,
//  TODO: RV_IT_VFDOT_VV,
//  TODO: RV_IT_VFWMACC_VV,
//  TODO: RV_IT_VFWNMACC_VV,
//  TODO: RV_IT_VFWMSAC_VV,
//  TODO: RV_IT_VFWNMSAC_VV,

    // V-extension MVV-type instructions
//  TODO: RV_IT_VREDSUM_VS,
//  TODO: RV_IT_VREDAND_VS,
//  TODO: RV_IT_VREDOR_VS,
//  TODO: RV_IT_VREDXOR_VS,
//  TODO: RV_IT_VREDMINU_VS,
//  TODO: RV_IT_VREDMIN_VS,
//  TODO: RV_IT_VREDMAXU_VS,
//  TODO: RV_IT_VREDMAX_VS,
//  TODO: RV_IT_VEXT_X_V,
//  TODO: RV_IT_VMPOPC_M,
//  TODO: RV_IT_VMFIRST_M,
//  TODO: RV_IT_VMSBF_M,
//  TODO: RV_IT_VMSOF_M,
//  TODO: RV_IT_VMSIF_M,
//  TODO: RV_IT_VMIOTA_M,
//  TODO: RV_IT_VID_V,
//  TODO: RV_IT_VCOMPRESS_VM,
//  TODO: RV_IT_VMANDNOT_MM,
//  TODO: RV_IT_VMAND_MM,
//  TODO: RV_IT_VMOR_MM,
//  TODO: RV_IT_VMXOR_MM,
//  TODO: RV_IT_VMORNOT_MM,
//  TODO: RV_IT_VMNAND_MM,
//  TODO: RV_IT_VMNOR_MM,
//  TODO: RV_IT_VMXNOR_MM,
    [RV_IT_VDIVU_VV]    = {morph:emitVSimple, opCB:emitVRSingleIntCB, binop:vmi_DIV},
    [RV_IT_VDIV_VV]     = {morph:emitVSimple, opCB:emitVRSingleIntCB, binop:vmi_IDIV},
    [RV_IT_VREMU_VV]    = {morph:emitVSimple, opCB:emitVRSingleIntCB, binop:vmi_REM},
    [RV_IT_VREM_VV]     = {morph:emitVSimple, opCB:emitVRSingleIntCB, binop:vmi_IREM},
//  TODO: RV_IT_VMULHU_VV,
    [RV_IT_VMUL_VV]     = {morph:emitVSimple, opCB:emitVRSingleIntCB, binop:vmi_MUL},
//  TODO: V_IT_VMULHSU_VV,
//  TODO: V_IT_VMULH_VV,
//  TODO: V_IT_VMADD_VV,
//  TODO: V_IT_VMSUB_VV,
//  TODO: V_IT_VMACC_VV,
//  TODO: V_IT_VMSAC_VV,
    [RV_IT_VWADDU_VV]   = {morph:emitVSimple, opCB:emitVRSingleIntCB, binop:vmi_ADD, vwCtrl:RVVW_WIDEx211, sExtend:0},
    [RV_IT_VWADD_VV]    = {morph:emitVSimple, opCB:emitVRSingleIntCB, binop:vmi_ADD, vwCtrl:RVVW_WIDEx211, sExtend:1},
    [RV_IT_VWSUBU_VV]   = {morph:emitVSimple, opCB:emitVRSingleIntCB, binop:vmi_SUB, vwCtrl:RVVW_WIDEx211, sExtend:0},
    [RV_IT_VWSUB_VV]    = {morph:emitVSimple, opCB:emitVRSingleIntCB, binop:vmi_SUB, vwCtrl:RVVW_WIDEx211, sExtend:1},
    [RV_IT_VWADDU_WV]   = {morph:emitVSimple, opCB:emitVRSingleIntCB, binop:vmi_ADD, vwCtrl:RVVW_WIDEx221, sExtend:0},
    [RV_IT_VWADD_WV]    = {morph:emitVSimple, opCB:emitVRSingleIntCB, binop:vmi_ADD, vwCtrl:RVVW_WIDEx221, sExtend:1},
    [RV_IT_VWSUBU_WV]   = {morph:emitVSimple, opCB:emitVRSingleIntCB, binop:vmi_SUB, vwCtrl:RVVW_WIDEx221, sExtend:0},
    [RV_IT_VWSUB_WV]    = {morph:emitVSimple, opCB:emitVRSingleIntCB, binop:vmi_SUB, vwCtrl:RVVW_WIDEx221, sExtend:1},
//  TODO: V_IT_VWMULU_VV,
//  TODO: V_IT_VWMULSU_VV,
//  TODO: V_IT_VWMUL_VV,
//  TODO: V_IT_VWMACCU_VV,
//  TODO: V_IT_VWMACC_VV,
//  TODO: V_IT_VWMSACU_VV,
//  TODO: V_IT_VWMSAC_VV,

    // V-extension IVI-type instructions
    [RV_IT_VADD_VI]     = {morph:emitVSimple, opCB:emitVISingleIntCB, binop:vmi_ADD},
    [RV_IT_VRSUB_VI]    = {morph:emitVSimple, opCB:emitVISingleIntCB, binop:vmi_RSUB},
    [RV_IT_VAND_VI]     = {morph:emitVSimple, opCB:emitVISingleIntCB, binop:vmi_AND},
    [RV_IT_VOR_VI]      = {morph:emitVSimple, opCB:emitVISingleIntCB, binop:vmi_OR },
    [RV_IT_VXOR_VI]     = {morph:emitVSimple, opCB:emitVISingleIntCB, binop:vmi_XOR},
//  TODO: RV_IT_VRGATHER_VI,
//  TODO: RV_IT_VSLIDEUP_VI,
//  TODO: RV_IT_VSLIDEDOWN_VI,
//  TODO: RV_IT_VADC_VI,
//  TODO: RV_IT_VMERGE_VI,
//  TODO: RV_IT_VSEQ_VI,
//  TODO: RV_IT_VSNE_VI,
//  TODO: RV_IT_VSLEU_VI,
//  TODO: RV_IT_VSLE_VI,
//  TODO: RV_IT_VSGTU_VI,
//  TODO: RV_IT_VSGT_VI,
//  TODO: RV_IT_VSADDU_VI,
//  TODO: RV_IT_VSADD_VI,
//  TODO: RV_IT_VAADD_VI,
//  TODO: RV_IT_VSLL_VI,
//  TODO: RV_IT_VSRL_VI,
//  TODO: RV_IT_VSRA_VI,
//  TODO: RV_IT_VSSRL_VI,
//  TODO: RV_IT_VSSRA_VI,
//  TODO: RV_IT_VNSRL_VI,
//  TODO: RV_IT_VNSRA_VI,
//  TODO: RV_IT_VNCLIPU_VI,
//  TODO: RV_IT_VNCLIP_VI,

    // V-extension IVX-type instructions
    [RV_IT_VADD_VX]     = {morph:emitVSimple, opCB:emitVRSingleIntCB, binop:vmi_ADD},
    [RV_IT_VSUB_VX]     = {morph:emitVSimple, opCB:emitVRSingleIntCB, binop:vmi_SUB},
    [RV_IT_VRSUB_VX]    = {morph:emitVSimple, opCB:emitVRSingleIntCB, binop:vmi_RSUB},
    [RV_IT_VMINU_VX]    = {morph:emitVSimple, opCB:emitVRMinMaxIntCB, cond :vmi_COND_B},
    [RV_IT_VMIN_VX]     = {morph:emitVSimple, opCB:emitVRMinMaxIntCB, cond :vmi_COND_L},
    [RV_IT_VMAXU_VX]    = {morph:emitVSimple, opCB:emitVRMinMaxIntCB, cond :vmi_COND_NB},
    [RV_IT_VMAX_VX]     = {morph:emitVSimple, opCB:emitVRMinMaxIntCB, cond :vmi_COND_NL},
    [RV_IT_VAND_VX]     = {morph:emitVSimple, opCB:emitVRSingleIntCB, binop:vmi_AND},
    [RV_IT_VOR_VX]      = {morph:emitVSimple, opCB:emitVRSingleIntCB, binop:vmi_OR },
    [RV_IT_VXOR_VX]     = {morph:emitVSimple, opCB:emitVRSingleIntCB, binop:vmi_XOR},
//  TODO: RV_IT_VRGATHER_VX,
//  TODO: RV_IT_VSLIDEUP_VX,
//  TODO: RV_IT_VSLIDEDOWN_VX,
//  TODO: RV_IT_VADC_VX,
//  TODO: RV_IT_VSBC_VX,
//  TODO: RV_IT_VMERGE_VX,
//  TODO: RV_IT_VSEQ_VX,
//  TODO: RV_IT_VSNE_VX,
//  TODO: RV_IT_VSLTU_VX,
//  TODO: RV_IT_VSLT_VX,
//  TODO: RV_IT_VSLEU_VX,
//  TODO: RV_IT_VSLE_VX,
//  TODO: RV_IT_VSGTU_VX,
//  TODO: RV_IT_VSGT_VX,
//  TODO: RV_IT_VSADDU_VX,
//  TODO: RV_IT_VSADD_VX,
//  TODO: RV_IT_VSSUBU_VX,
//  TODO: RV_IT_VSSUB_VX,
//  TODO: RV_IT_VAADD_VX,
//  TODO: RV_IT_VSLL_VX,
//  TODO: RV_IT_VASUB_VX,
//  TODO: RV_IT_VSMUL_VX,
//  TODO: RV_IT_VSRL_VX,
//  TODO: RV_IT_VSRA_VX,
//  TODO: RV_IT_VSSRL_VX,
//  TODO: RV_IT_VSSRA_VX,
//  TODO: RV_IT_VNSRL_VX,
//  TODO: RV_IT_VNSRA_VX,
//  TODO: RV_IT_VNCLIPU_VX,
//  TODO: RV_IT_VNCLIP_VX,
//  TODO: RV_IT_VWSMACCU_VX,
//  TODO: RV_IT_VWSMACC_VX,
//  TODO: RV_IT_VWSMSCCU_VX,
//  TODO: RV_IT_VWSMSCC_VX,

    // V-extension FVF-type instructions
//  TODO: RV_IT_VFADD_VF,
//  TODO: RV_IT_VFSUB_VF,
//  TODO: RV_IT_VFMIN_VF,
//  TODO: RV_IT_VFMAX_VF,
//  TODO: RV_IT_VFSGNJ_VF,
//  TODO: RV_IT_VFSGNJN_VF,
//  TODO: RV_IT_VFSGNJX_VF,
//  TODO: RV_IT_VFMV_S_F,
//  TODO: RV_IT_VFMERGE_VF,
//  TODO: RV_IT_VFEQ_VF,
//  TODO: RV_IT_VFLTE_VF,
//  TODO: RV_IT_VFORD_VF,
//  TODO: RV_IT_VFLT_VF,
//  TODO: RV_IT_VFNE_VF,
//  TODO: RV_IT_VFGT_VF,
//  TODO: RV_IT_VFGTE_VF,
//  TODO: RV_IT_VFDIV_VF,
//  TODO: RV_IT_VFRDIV_VF,
//  TODO: RV_IT_VFMUL_VF,
//  TODO: RV_IT_VFMADD_VF,
//  TODO: RV_IT_VFNMADD_VF,
//  TODO: RV_IT_VFMSUB_VF,
//  TODO: RV_IT_VFNMSUB_VF,
//  TODO: RV_IT_VFMACC_VF,
//  TODO: RV_IT_VFNMACC_VF,
//  TODO: RV_IT_VFMSAC_VF,
//  TODO: RV_IT_VFNMSAC_VF,
//  TODO: RV_IT_VFWADD_VF,
//  TODO: RV_IT_VFWSUB_VF,
//  TODO: RV_IT_VFWADD_WF,
//  TODO: RV_IT_VFWSUB_WF,
//  TODO: RV_IT_VFWMUL_VF,
//  TODO: RV_IT_VFWMACC_VF,
//  TODO: RV_IT_VFWNMACC_VF,
//  TODO: RV_IT_VFWMSAC_VF,
//  TODO: RV_IT_VFWNMSAC_VF,

    // V-extension MVX-type instructions
//  TODO: RV_IT_VMV_S_X,
//  TODO: RV_IT_VSLIDE1UP_VX,
//  TODO: RV_IT_VSLIDE1DOWN_VX,
    [RV_IT_VDIVU_VX]    = {morph:emitVSimple, opCB:emitVRSingleIntCB, binop:vmi_DIV},
    [RV_IT_VDIV_VX]     = {morph:emitVSimple, opCB:emitVRSingleIntCB, binop:vmi_IDIV},
    [RV_IT_VREMU_VX]    = {morph:emitVSimple, opCB:emitVRSingleIntCB, binop:vmi_REM},
    [RV_IT_VREM_VX]     = {morph:emitVSimple, opCB:emitVRSingleIntCB, binop:vmi_IREM},
//  TODO: RV_IT_VMULHU_VX,
    [RV_IT_VMUL_VX]     = {morph:emitVSimple, opCB:emitVRSingleIntCB, binop:vmi_MUL},
//  TODO: RV_IT_VMULHSU_VX,
//  TODO: RV_IT_VMULH_VX,
//  TODO: RV_IT_VMADD_VX,
//  TODO: RV_IT_VMSUB_VX,
//  TODO: RV_IT_VMACC_VX,
//  TODO: RV_IT_VMSAC_VX,
//  TODO: RV_IT_VWADDU_VX,
//  TODO: RV_IT_VWADD_VX,
//  TODO: RV_IT_VWSUBU_VX,
//  TODO: RV_IT_VWSUB_VX,
//  TODO: RV_IT_VWADDU_WX,
//  TODO: RV_IT_VWADD_WX,
//  TODO: RV_IT_VWSUBU_WX,
//  TODO: RV_IT_VWSUB_WX,
//  TODO: RV_IT_VWMULU_VX,
//  TODO: RV_IT_VWMULSU_VX,
//  TODO: RV_IT_VWMUL_VX,
//  TODO: RV_IT_VWMACCU_VX,
//  TODO: RV_IT_VWMACC_VX,
//  TODO: RV_IT_VWMSACU_VX,
//  TODO: RV_IT_VWMSAC_VX,

    // KEEP LAST
    [RV_IT_LAST]        = {0}
};

//
// Called at the start of a new code block
//
VMI_START_END_BLOCK_FN(riscvStartBlock) {

    riscvP           riscv     = (riscvP)processor;
    riscvBlockStateP thisState = blockState;

    // save currently-active block state and set new state
    thisState->prevState = riscv->blockState;
    riscv->blockState    = thisState;

    // no single-precision registers are known to be NaN-boxed initially
    thisState->fpNaNBoxMask = 0;

    // no floating-point instructions have been seen initially if management
    // of floating point state using mstatus.FS is required
    thisState->fpInstDone = riscv->configInfo.fs_always_dirty;

    // current rounding mode is not checked initially
    thisState->fpRMChecked = False;

    // current vector configuration is not known initially
    thisState->SEWMt        = SEWMT_UNKNOWN;
    thisState->VLMULMt      = VLMULMT_UNKNOWN;
    thisState->VLClassMt    = VLCLASSMT_UNKNOWN;
    thisState->VZeroTopMt   = 0;
    thisState->VStartZeroMt = False;
}

//
// Called at the end of a new code block
//
VMI_START_END_BLOCK_FN(riscvEndBlock) {

    riscvP           riscv     = (riscvP)processor;
    riscvBlockStateP thisState = blockState;

    // sanity check that the current block is being ended
    VMI_ASSERT(
        thisState==riscv->blockState,
        "unexpected mismatched blockState at end of block"
    );

    // restore previously-active block state
    riscv->blockState = thisState->prevState;
}

//
// Instruction Morpher
//
VMI_MORPH_FN(riscvMorph) {

    riscvP          riscv = (riscvP)processor;
    riscvMorphState state;

    // get instruction and instruction type
    riscvDecode(riscv, thisPC, &state.info);

    state.attrs       = &dispatchTable[state.info.type];
    state.riscv       = riscv;
    state.inDelaySlot = inDelaySlot;

    // clear mask of X registers targeted by this instruction
    riscv->writtenXMask = 0;

    if(disableMorph(&state)) {

        // no action if in disassembly mode

    } else if(state.info.type==RV_IT_LAST) {

        // take Illegal Instruction exception
        ILLEGAL_INSTRUCTION_MESSAGE(riscv, "UDEC", "Undecoded instruction");

    } else if(!riscvInstructionEnabled(riscv, state.info.arch)) {

        // instruction not enabled

    } else if(state.attrs->morph) {

        // call derived model preMorph function if required
        if(riscv->cb.preMorph) {
            riscv->cb.preMorph(riscv);
        }

        // translate the instruction
        vmimtInstructionClassAdd(state.attrs->iClass);
        state.attrs->morph(&state);

        // call derived model postMorph function if required
        if(riscv->cb.postMorph) {
            riscv->cb.postMorph(riscv);
        }

    } else {

        // here if no morph callback specified
        vmiMessage("F", CPU_PREFIX "_UIMP", // LCOV_EXCL_LINE
            SRCREF_FMT "unimplemented",
            SRCREF_ARGS(riscv, thisPC)
        );
    }
}

//
// Adjust results for divide-by-zero and integer overflow
//
VMI_ARITH_RESULT_FN(riscvArithResult) {

    if(!divideInfo->divisor) {

        // divide by zero
        divideResults->quotient  = -1;
        divideResults->remainder = divideInfo->dividendLSW;

    } else {

        // integer overflow
        divideResults->quotient  = divideInfo->dividendLSW;
        divideResults->remainder = 0;
    }
}

