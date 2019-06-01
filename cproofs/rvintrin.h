#ifndef RVINTRIN_H
#define RVINTRIN_H

#include <limits.h>
#include <stdint.h>

#if !defined(__riscv_xlen) && !defined(RVINTRIN_EMULATE)
#  warning "Target is not RISC-V. Enabling <rvintrin.h> emulation mode."
#  define RVINTRIN_EMULATE 1
#endif

#ifndef RVINTRIN_EMULATE

#if __riscv_xlen == 32
static inline int32_t _rv32_clz (int32_t rs1) { int32_t rd; __asm__ ("clz   %0, %1" : "=r"(rd) : "r"(rs1)); return rd; }
static inline int32_t _rv32_ctz (int32_t rs1) { int32_t rd; __asm__ ("ctz   %0, %1" : "=r"(rd) : "r"(rs1)); return rd; }
static inline int32_t _rv32_pcnt(int32_t rs1) { int32_t rd; __asm__ ("pcnt  %0, %1" : "=r"(rd) : "r"(rs1)); return rd; }
#else
static inline int32_t _rv32_clz (int32_t rs1) { int32_t rd; __asm__ ("clzw  %0, %1" : "=r"(rd) : "r"(rs1)); return rd; }
static inline int32_t _rv32_ctz (int32_t rs1) { int32_t rd; __asm__ ("ctzw  %0, %1" : "=r"(rd) : "r"(rs1)); return rd; }
static inline int32_t _rv32_pcnt(int32_t rs1) { int32_t rd; __asm__ ("pcntw %0, %1" : "=r"(rd) : "r"(rs1)); return rd; }

static inline int64_t _rv64_clz (int64_t rs1) { int64_t rd; __asm__ ("clz   %0, %1" : "=r"(rd) : "r"(rs1)); return rd; }
static inline int64_t _rv64_ctz (int64_t rs1) { int64_t rd; __asm__ ("ctz   %0, %1" : "=r"(rd) : "r"(rs1)); return rd; }
static inline int64_t _rv64_pcnt(int64_t rs1) { int64_t rd; __asm__ ("pcnt  %0, %1" : "=r"(rd) : "r"(rs1)); return rd; }
#endif

#if __riscv_xlen == 32
static inline int32_t _rv32_pack(int32_t rs1, int32_t rs2) { int32_t rd; __asm__ ("pack  %0, %1, %2" : "=r"(rd) : "r"(rs1), "r"(rs2)); return rd; }
#else
static inline int32_t _rv32_pack(int32_t rs1, int32_t rs2) { int32_t rd; __asm__ ("packw %0, %1, %2" : "=r"(rd) : "r"(rs1), "r"(rs2)); return rd; }
static inline int64_t _rv64_pack(int64_t rs1, int64_t rs2) { int64_t rd; __asm__ ("pack  %0, %1, %2" : "=r"(rd) : "r"(rs1), "r"(rs2)); return rd; }
#endif

static inline int32_t _rv32_min (int32_t rs1, int32_t rs2) { int32_t rd; __asm__ ("min  %0, %1, %2" : "=r"(rd) : "r"(rs1), "r"(rs2)); return rd; }
static inline int32_t _rv32_minu(int32_t rs1, int32_t rs2) { int32_t rd; __asm__ ("minu %0, %1, %2" : "=r"(rd) : "r"(rs1), "r"(rs2)); return rd; }
static inline int32_t _rv32_max (int32_t rs1, int32_t rs2) { int32_t rd; __asm__ ("max  %0, %1, %2" : "=r"(rd) : "r"(rs1), "r"(rs2)); return rd; }
static inline int32_t _rv32_maxu(int32_t rs1, int32_t rs2) { int32_t rd; __asm__ ("maxu %0, %1, %2" : "=r"(rd) : "r"(rs1), "r"(rs2)); return rd; }

#if __riscv_xlen == 64
static inline int64_t _rv64_min (int64_t rs1, int64_t rs2) { int64_t rd; __asm__ ("min  %0, %1, %2" : "=r"(rd) : "r"(rs1), "r"(rs2)); return rd; }
static inline int64_t _rv64_minu(int64_t rs1, int64_t rs2) { int64_t rd; __asm__ ("minu %0, %1, %2" : "=r"(rd) : "r"(rs1), "r"(rs2)); return rd; }
static inline int64_t _rv64_max (int64_t rs1, int64_t rs2) { int64_t rd; __asm__ ("max  %0, %1, %2" : "=r"(rd) : "r"(rs1), "r"(rs2)); return rd; }
static inline int64_t _rv64_maxu(int64_t rs1, int64_t rs2) { int64_t rd; __asm__ ("maxu %0, %1, %2" : "=r"(rd) : "r"(rs1), "r"(rs2)); return rd; }
#endif

#if __riscv_xlen == 32
static inline int32_t _rv32_sbset (int32_t rs1, int32_t rs2) { int32_t rd; __asm__ ("sbset %0, %1, %2" : "=r"(rd) : "r"(rs1), "r"(rs2)); return rd; }
static inline int32_t _rv32_sbclr (int32_t rs1, int32_t rs2) { int32_t rd; __asm__ ("sbclr %0, %1, %2" : "=r"(rd) : "r"(rs1), "r"(rs2)); return rd; }
static inline int32_t _rv32_sbinv (int32_t rs1, int32_t rs2) { int32_t rd; __asm__ ("sbinv %0, %1, %2" : "=r"(rd) : "r"(rs1), "r"(rs2)); return rd; }
static inline int32_t _rv32_sbext (int32_t rs1, int32_t rs2) { int32_t rd; __asm__ ("sbext %0, %1, %2" : "=r"(rd) : "r"(rs1), "r"(rs2)); return rd; }

static inline int32_t _rv32_sbseti(int32_t rs1, int imm) { int32_t rd; __asm__ ("sbseti %0, %1, %2" : "=r"(rd) : "r"(rs1), "i"(imm)); return rd; }
static inline int32_t _rv32_sbclri(int32_t rs1, int imm) { int32_t rd; __asm__ ("sbclri %0, %1, %2" : "=r"(rd) : "r"(rs1), "i"(imm)); return rd; }
static inline int32_t _rv32_sbinvi(int32_t rs1, int imm) { int32_t rd; __asm__ ("sbinvi %0, %1, %2" : "=r"(rd) : "r"(rs1), "i"(imm)); return rd; }
static inline int32_t _rv32_sbexti(int32_t rs1, int imm) { int32_t rd; __asm__ ("sbexti %0, %1, %2" : "=r"(rd) : "r"(rs1), "i"(imm)); return rd; }
#else
static inline int32_t _rv32_sbset (int32_t rs1, int32_t rs2) { int32_t rd; __asm__ ("sbsetw %0, %1, %2" : "=r"(rd) : "r"(rs1), "r"(rs2)); return rd; }
static inline int32_t _rv32_sbclr (int32_t rs1, int32_t rs2) { int32_t rd; __asm__ ("sbclrw %0, %1, %2" : "=r"(rd) : "r"(rs1), "r"(rs2)); return rd; }
static inline int32_t _rv32_sbinv (int32_t rs1, int32_t rs2) { int32_t rd; __asm__ ("sbinvw %0, %1, %2" : "=r"(rd) : "r"(rs1), "r"(rs2)); return rd; }
static inline int32_t _rv32_sbext (int32_t rs1, int32_t rs2) { int32_t rd; __asm__ ("sbextw %0, %1, %2" : "=r"(rd) : "r"(rs1), "r"(rs2)); return rd; }

static inline int32_t _rv32_sbseti(int32_t rs1, int imm) { int32_t rd; __asm__ ("sbsetiw %0, %1, %2" : "=r"(rd) : "r"(rs1), "i"(imm)); return rd; }
static inline int32_t _rv32_sbclri(int32_t rs1, int imm) { int32_t rd; __asm__ ("sbclriw %0, %1, %2" : "=r"(rd) : "r"(rs1), "i"(imm)); return rd; }
static inline int32_t _rv32_sbinvi(int32_t rs1, int imm) { int32_t rd; __asm__ ("sbinviw %0, %1, %2" : "=r"(rd) : "r"(rs1), "i"(imm)); return rd; }
static inline int32_t _rv32_sbexti(int32_t rs1, int imm) { int32_t rd; __asm__ ("sbexti  %0, %1, %2" : "=r"(rd) : "r"(rs1), "i"(imm)); return rd; }

static inline int64_t _rv64_sbset (int64_t rs1, int64_t rs2) { int64_t rd; __asm__ ("sbset %0, %1, %2" : "=r"(rd) : "r"(rs1), "r"(rs2)); return rd; }
static inline int64_t _rv64_sbclr (int64_t rs1, int64_t rs2) { int64_t rd; __asm__ ("sbclr %0, %1, %2" : "=r"(rd) : "r"(rs1), "r"(rs2)); return rd; }
static inline int64_t _rv64_sbinv (int64_t rs1, int64_t rs2) { int64_t rd; __asm__ ("sbinv %0, %1, %2" : "=r"(rd) : "r"(rs1), "r"(rs2)); return rd; }
static inline int64_t _rv64_sbext (int64_t rs1, int64_t rs2) { int64_t rd; __asm__ ("sbext %0, %1, %2" : "=r"(rd) : "r"(rs1), "r"(rs2)); return rd; }

static inline int64_t _rv64_sbseti(int64_t rs1, int imm) { int64_t rd; __asm__ ("sbseti %0, %1, %2" : "=r"(rd) : "r"(rs1), "i"(imm)); return rd; }
static inline int64_t _rv64_sbclri(int64_t rs1, int imm) { int64_t rd; __asm__ ("sbclri %0, %1, %2" : "=r"(rd) : "r"(rs1), "i"(imm)); return rd; }
static inline int64_t _rv64_sbinvi(int64_t rs1, int imm) { int64_t rd; __asm__ ("sbinvi %0, %1, %2" : "=r"(rd) : "r"(rs1), "i"(imm)); return rd; }
static inline int64_t _rv64_sbexti(int64_t rs1, int imm) { int64_t rd; __asm__ ("sbexti %0, %1, %2" : "=r"(rd) : "r"(rs1), "i"(imm)); return rd; }
#endif

#if __riscv_xlen == 32
static inline int32_t _rv32_sll    (int32_t rs1, int32_t rs2) { int32_t rd; __asm__ ("sll     %0, %1, %2" : "=r"(rd) : "r"(rs1), "r"(rs2)); return rd; }
static inline int32_t _rv32_srl    (int32_t rs1, int32_t rs2) { int32_t rd; __asm__ ("srl     %0, %1, %2" : "=r"(rd) : "r"(rs1), "r"(rs2)); return rd; }
static inline int32_t _rv32_sra    (int32_t rs1, int32_t rs2) { int32_t rd; __asm__ ("sra     %0, %1, %2" : "=r"(rd) : "r"(rs1), "r"(rs2)); return rd; }
static inline int32_t _rv32_slo    (int32_t rs1, int32_t rs2) { int32_t rd; __asm__ ("slo     %0, %1, %2" : "=r"(rd) : "r"(rs1), "r"(rs2)); return rd; }
static inline int32_t _rv32_sro    (int32_t rs1, int32_t rs2) { int32_t rd; __asm__ ("sro     %0, %1, %2" : "=r"(rd) : "r"(rs1), "r"(rs2)); return rd; }
static inline int32_t _rv32_rol    (int32_t rs1, int32_t rs2) { int32_t rd; __asm__ ("rol     %0, %1, %2" : "=r"(rd) : "r"(rs1), "r"(rs2)); return rd; }
static inline int32_t _rv32_ror    (int32_t rs1, int32_t rs2) { int32_t rd; __asm__ ("ror     %0, %1, %2" : "=r"(rd) : "r"(rs1), "r"(rs2)); return rd; }
static inline int32_t _rv32_grev   (int32_t rs1, int32_t rs2) { int32_t rd; __asm__ ("grev    %0, %1, %2" : "=r"(rd) : "r"(rs1), "r"(rs2)); return rd; }
static inline int32_t _rv32_shfl   (int32_t rs1, int32_t rs2) { int32_t rd; __asm__ ("shfl    %0, %1, %2" : "=r"(rd) : "r"(rs1), "r"(rs2)); return rd; }
static inline int32_t _rv32_unshfl (int32_t rs1, int32_t rs2) { int32_t rd; __asm__ ("unshfl  %0, %1, %2" : "=r"(rd) : "r"(rs1), "r"(rs2)); return rd; }

static inline int32_t _rv32_slli   (int32_t rs1, int imm) { int32_t rd; __asm__ ("slli    %0, %1, %2" : "=r"(rd) : "r"(rs1), "i"(imm)); return rd; }
static inline int32_t _rv32_srli   (int32_t rs1, int imm) { int32_t rd; __asm__ ("srli    %0, %1, %2" : "=r"(rd) : "r"(rs1), "i"(imm)); return rd; }
static inline int32_t _rv32_srai   (int32_t rs1, int imm) { int32_t rd; __asm__ ("srai    %0, %1, %2" : "=r"(rd) : "r"(rs1), "i"(imm)); return rd; }
static inline int32_t _rv32_sloi   (int32_t rs1, int imm) { int32_t rd; __asm__ ("sloi    %0, %1, %2" : "=r"(rd) : "r"(rs1), "i"(imm)); return rd; }
static inline int32_t _rv32_sroi   (int32_t rs1, int imm) { int32_t rd; __asm__ ("sroi    %0, %1, %2" : "=r"(rd) : "r"(rs1), "i"(imm)); return rd; }
static inline int32_t _rv32_roli   (int32_t rs1, int imm) { int32_t rd; __asm__ ("rori    %0, %1, %2" : "=r"(rd) : "r"(rs1), "i"(imm ? 32-imm : 0)); return rd; }
static inline int32_t _rv32_rori   (int32_t rs1, int imm) { int32_t rd; __asm__ ("rori    %0, %1, %2" : "=r"(rd) : "r"(rs1), "i"(imm)); return rd; }
static inline int32_t _rv32_grevi  (int32_t rs1, int imm) { int32_t rd; __asm__ ("grevi   %0, %1, %2" : "=r"(rd) : "r"(rs1), "i"(imm)); return rd; }
static inline int32_t _rv32_shfli  (int32_t rs1, int imm) { int32_t rd; __asm__ ("shfli   %0, %1, %2" : "=r"(rd) : "r"(rs1), "i"(imm)); return rd; }
static inline int32_t _rv32_unshfli(int32_t rs1, int imm) { int32_t rd; __asm__ ("unshfli %0, %1, %2" : "=r"(rd) : "r"(rs1), "i"(imm)); return rd; }
#else
static inline int32_t _rv32_sll    (int32_t rs1, int32_t rs2) { int32_t rd; __asm__ ("sllw    %0, %1, %2" : "=r"(rd) : "r"(rs1), "r"(rs2)); return rd; }
static inline int32_t _rv32_srl    (int32_t rs1, int32_t rs2) { int32_t rd; __asm__ ("srlw    %0, %1, %2" : "=r"(rd) : "r"(rs1), "r"(rs2)); return rd; }
static inline int32_t _rv32_sra    (int32_t rs1, int32_t rs2) { int32_t rd; __asm__ ("sraw    %0, %1, %2" : "=r"(rd) : "r"(rs1), "r"(rs2)); return rd; }
static inline int32_t _rv32_slo    (int32_t rs1, int32_t rs2) { int32_t rd; __asm__ ("slow    %0, %1, %2" : "=r"(rd) : "r"(rs1), "r"(rs2)); return rd; }
static inline int32_t _rv32_sro    (int32_t rs1, int32_t rs2) { int32_t rd; __asm__ ("srow    %0, %1, %2" : "=r"(rd) : "r"(rs1), "r"(rs2)); return rd; }
static inline int32_t _rv32_rol    (int32_t rs1, int32_t rs2) { int32_t rd; __asm__ ("rolw    %0, %1, %2" : "=r"(rd) : "r"(rs1), "r"(rs2)); return rd; }
static inline int32_t _rv32_ror    (int32_t rs1, int32_t rs2) { int32_t rd; __asm__ ("rorw    %0, %1, %2" : "=r"(rd) : "r"(rs1), "r"(rs2)); return rd; }
static inline int32_t _rv32_grev   (int32_t rs1, int32_t rs2) { int32_t rd; __asm__ ("grevw   %0, %1, %2" : "=r"(rd) : "r"(rs1), "r"(rs2)); return rd; }
static inline int32_t _rv32_shfl   (int32_t rs1, int32_t rs2) { int32_t rd; __asm__ ("shflw   %0, %1, %2" : "=r"(rd) : "r"(rs1), "r"(rs2)); return rd; }
static inline int32_t _rv32_unshfl (int32_t rs1, int32_t rs2) { int32_t rd; __asm__ ("unshflw %0, %1, %2" : "=r"(rd) : "r"(rs1), "r"(rs2)); return rd; }

static inline int32_t _rv32_slli   (int32_t rs1, int imm) { int32_t rd; __asm__ ("slliw   %0, %1, %2" : "=r"(rd) : "r"(rs1), "i"(imm)); return rd; }
static inline int32_t _rv32_srli   (int32_t rs1, int imm) { int32_t rd; __asm__ ("srliw   %0, %1, %2" : "=r"(rd) : "r"(rs1), "i"(imm)); return rd; }
static inline int32_t _rv32_srai   (int32_t rs1, int imm) { int32_t rd; __asm__ ("sraiw   %0, %1, %2" : "=r"(rd) : "r"(rs1), "i"(imm)); return rd; }
static inline int32_t _rv32_sloi   (int32_t rs1, int imm) { int32_t rd; __asm__ ("sloiw   %0, %1, %2" : "=r"(rd) : "r"(rs1), "i"(imm)); return rd; }
static inline int32_t _rv32_sroi   (int32_t rs1, int imm) { int32_t rd; __asm__ ("sroiw   %0, %1, %2" : "=r"(rd) : "r"(rs1), "i"(imm)); return rd; }
static inline int32_t _rv32_roli   (int32_t rs1, int imm) { int32_t rd; __asm__ ("roriw   %0, %1, %2" : "=r"(rd) : "r"(rs1), "i"(imm ? 32-imm : 0)); return rd; }
static inline int32_t _rv32_rori   (int32_t rs1, int imm) { int32_t rd; __asm__ ("roriw   %0, %1, %2" : "=r"(rd) : "r"(rs1), "i"(imm)); return rd; }
static inline int32_t _rv32_grevi  (int32_t rs1, int imm) { int32_t rd; __asm__ ("greviw  %0, %1, %2" : "=r"(rd) : "r"(rs1), "i"(imm)); return rd; }
static inline int32_t _rv32_shfli  (int32_t rs1, int imm) { int32_t rd; __asm__ ("shfli   %0, %1, %2" : "=r"(rd) : "r"(rs1), "i"(imm)); return rd; }
static inline int32_t _rv32_unshfli(int32_t rs1, int imm) { int32_t rd; __asm__ ("unshfli %0, %1, %2" : "=r"(rd) : "r"(rs1), "i"(imm)); return rd; }

static inline int64_t _rv64_sll    (int64_t rs1, int64_t rs2) { int64_t rd; __asm__ ("sll     %0, %1, %2" : "=r"(rd) : "r"(rs1), "r"(rs2)); return rd; }
static inline int64_t _rv64_srl    (int64_t rs1, int64_t rs2) { int64_t rd; __asm__ ("srl     %0, %1, %2" : "=r"(rd) : "r"(rs1), "r"(rs2)); return rd; }
static inline int64_t _rv64_sra    (int64_t rs1, int64_t rs2) { int64_t rd; __asm__ ("sra     %0, %1, %2" : "=r"(rd) : "r"(rs1), "r"(rs2)); return rd; }
static inline int64_t _rv64_slo    (int64_t rs1, int64_t rs2) { int64_t rd; __asm__ ("slo     %0, %1, %2" : "=r"(rd) : "r"(rs1), "r"(rs2)); return rd; }
static inline int64_t _rv64_sro    (int64_t rs1, int64_t rs2) { int64_t rd; __asm__ ("sro     %0, %1, %2" : "=r"(rd) : "r"(rs1), "r"(rs2)); return rd; }
static inline int64_t _rv64_rol    (int64_t rs1, int64_t rs2) { int64_t rd; __asm__ ("rol     %0, %1, %2" : "=r"(rd) : "r"(rs1), "r"(rs2)); return rd; }
static inline int64_t _rv64_ror    (int64_t rs1, int64_t rs2) { int64_t rd; __asm__ ("ror     %0, %1, %2" : "=r"(rd) : "r"(rs1), "r"(rs2)); return rd; }
static inline int64_t _rv64_grev   (int64_t rs1, int64_t rs2) { int64_t rd; __asm__ ("grev    %0, %1, %2" : "=r"(rd) : "r"(rs1), "r"(rs2)); return rd; }
static inline int64_t _rv64_shfl   (int64_t rs1, int64_t rs2) { int64_t rd; __asm__ ("shfl    %0, %1, %2" : "=r"(rd) : "r"(rs1), "r"(rs2)); return rd; }
static inline int64_t _rv64_unshfl (int64_t rs1, int64_t rs2) { int64_t rd; __asm__ ("unshfl  %0, %1, %2" : "=r"(rd) : "r"(rs1), "r"(rs2)); return rd; }

static inline int64_t _rv64_slli   (int64_t rs1, int imm) { int64_t rd; __asm__ ("slli    %0, %1, %2" : "=r"(rd) : "r"(rs1), "i"(imm)); return rd; }
static inline int64_t _rv64_srli   (int64_t rs1, int imm) { int64_t rd; __asm__ ("srli    %0, %1, %2" : "=r"(rd) : "r"(rs1), "i"(imm)); return rd; }
static inline int64_t _rv64_srai   (int64_t rs1, int imm) { int64_t rd; __asm__ ("srai    %0, %1, %2" : "=r"(rd) : "r"(rs1), "i"(imm)); return rd; }
static inline int64_t _rv64_sloi   (int64_t rs1, int imm) { int64_t rd; __asm__ ("sloi    %0, %1, %2" : "=r"(rd) : "r"(rs1), "i"(imm)); return rd; }
static inline int64_t _rv64_sroi   (int64_t rs1, int imm) { int64_t rd; __asm__ ("sroi    %0, %1, %2" : "=r"(rd) : "r"(rs1), "i"(imm)); return rd; }
static inline int64_t _rv64_roli   (int64_t rs1, int imm) { int64_t rd; __asm__ ("rori    %0, %1, %2" : "=r"(rd) : "r"(rs1), "i"(imm ? 64-imm : 0)); return rd; }
static inline int64_t _rv64_rori   (int64_t rs1, int imm) { int64_t rd; __asm__ ("rori    %0, %1, %2" : "=r"(rd) : "r"(rs1), "i"(imm)); return rd; }
static inline int64_t _rv64_grevi  (int64_t rs1, int imm) { int64_t rd; __asm__ ("grevi   %0, %1, %2" : "=r"(rd) : "r"(rs1), "i"(imm)); return rd; }
static inline int64_t _rv64_shfli  (int64_t rs1, int imm) { int64_t rd; __asm__ ("shfli   %0, %1, %2" : "=r"(rd) : "r"(rs1), "i"(imm)); return rd; }
static inline int64_t _rv64_unshfli(int64_t rs1, int imm) { int64_t rd; __asm__ ("unshfli %0, %1, %2" : "=r"(rd) : "r"(rs1), "i"(imm)); return rd; }
#endif

#if __riscv_xlen == 32
static inline int32_t _rv32_bext(int32_t rs1, int32_t rs2) { int32_t rd; __asm__ ("bext  %0, %1, %2" : "=r"(rd) : "r"(rs1), "r"(rs2)); return rd; }
static inline int32_t _rv32_bdep(int32_t rs1, int32_t rs2) { int32_t rd; __asm__ ("bdep  %0, %1, %2" : "=r"(rd) : "r"(rs1), "r"(rs2)); return rd; }
#else
static inline int32_t _rv32_bext(int32_t rs1, int32_t rs2) { int32_t rd; __asm__ ("bextw %0, %1, %2" : "=r"(rd) : "r"(rs1), "r"(rs2)); return rd; }
static inline int32_t _rv32_bdep(int32_t rs1, int32_t rs2) { int32_t rd; __asm__ ("bdepw %0, %1, %2" : "=r"(rd) : "r"(rs1), "r"(rs2)); return rd; }

static inline int64_t _rv64_bext(int64_t rs1, int64_t rs2) { int64_t rd; __asm__ ("bext  %0, %1, %2" : "=r"(rd) : "r"(rs1), "r"(rs2)); return rd; }
static inline int64_t _rv64_bdep(int64_t rs1, int64_t rs2) { int64_t rd; __asm__ ("bdep  %0, %1, %2" : "=r"(rd) : "r"(rs1), "r"(rs2)); return rd; }
#endif

// TBD: clmul[h[x]], crc32.[bhwd], crc32c.[bhwd]
// TBD: bmatxor, bmator, bmatflip
// TBD: cmix, cmov, fsl, fsr

#else // RVINTRIN_EMULATE

#if UINT_MAX != 0xffffffffU
#  error "<rvintrin.h> emulation mode only supports systems with sizeof(int) = 4."
#endif

#if (ULLONG_MAX == 0xffffffffLLU) || (ULLONG_MAX != 0xffffffffffffffffLLU)
#  error "<rvintrin.h> emulation mode only supports systems with sizeof(long long) = 8."
#endif

static inline int32_t _rv32_clz(int32_t rs1) { return rs1 ? __builtin_clz(rs1)   : 32; }
static inline int64_t _rv64_clz(int64_t rs1) { return rs1 ? __builtin_clzll(rs1) : 64; }

static inline int32_t _rv32_ctz(int32_t rs1) { return rs1 ? __builtin_ctz(rs1)   : 32; }
static inline int64_t _rv64_ctz(int64_t rs1) { return rs1 ? __builtin_ctzll(rs1) : 64; }

static inline int32_t _rv32_pcnt(int32_t rs1) { __builtin_popcount(rs1);   }
static inline int64_t _rv64_pcnt(int64_t rs1) { __builtin_popcountll(rs1); }

static inline int32_t _rv32_pack(int32_t rs1, int32_t rs2) { return (rs1 & 0x0000ffff)   | (rs2 << 16); }
static inline int64_t _rv64_pack(int64_t rs1, int64_t rs2) { return (rs1 & 0xffffffffLL) | (rs2 << 32); }

static inline int32_t _rv32_min (int32_t rs1, int32_t rs2) { return rs1 < rs2 ? rs1 : rs2; }
static inline int32_t _rv32_minu(int32_t rs1, int32_t rs2) { return (uint32_t)rs1 < (uint32_t)rs2 ? rs1 : rs2; }
static inline int32_t _rv32_max (int32_t rs1, int32_t rs2) { return rs1 > rs2 ? rs1 : rs2; }
static inline int32_t _rv32_maxu(int32_t rs1, int32_t rs2) { return (uint32_t)rs1 > (uint32_t)rs2 ? rs1 : rs2; }

static inline int64_t _rv64_min (int64_t rs1, int64_t rs2) { return rs1 < rs2 ? rs1 : rs2; }
static inline int64_t _rv64_minu(int64_t rs1, int64_t rs2) { return (uint64_t)rs1 < (uint64_t)rs2 ? rs1 : rs2; }
static inline int64_t _rv64_max (int64_t rs1, int64_t rs2) { return rs1 > rs2 ? rs1 : rs2; }
static inline int64_t _rv64_maxu(int64_t rs1, int64_t rs2) { return (uint64_t)rs1 > (uint64_t)rs2 ? rs1 : rs2; }

static inline int32_t _rv32_sbset (int32_t rs1, int32_t rs2) { return rs1 |  (1   << (rs2 & 31)); }
static inline int32_t _rv32_sbclr (int32_t rs1, int32_t rs2) { return rs1 & ~(1   << (rs2 & 31)); }
static inline int32_t _rv32_sbinv (int32_t rs1, int32_t rs2) { return rs1 ^  (1   << (rs2 & 31)); }
static inline int32_t _rv32_sbext (int32_t rs1, int32_t rs2) { return 1   &  (rs1 >> (rs2 & 31)); }

static inline int32_t _rv32_sbseti(int32_t rs1, int imm) { return _rv32_sbset(rs1, imm); }
static inline int32_t _rv32_sbclri(int32_t rs1, int imm) { return _rv32_sbclr(rs1, imm); }
static inline int32_t _rv32_sbinvi(int32_t rs1, int imm) { return _rv32_sbinv(rs1, imm); }
static inline int32_t _rv32_sbexti(int32_t rs1, int imm) { return _rv32_sbext(rs1, imm); }

static inline int64_t _rv64_sbset (int64_t rs1, int64_t rs2) { return rs1 |  (1LL << (rs2 & 63)); }
static inline int64_t _rv64_sbclr (int64_t rs1, int64_t rs2) { return rs1 & ~(1LL << (rs2 & 63)); }
static inline int64_t _rv64_sbinv (int64_t rs1, int64_t rs2) { return rs1 ^  (1LL << (rs2 & 63)); }
static inline int64_t _rv64_sbext (int64_t rs1, int64_t rs2) { return 1LL &  (rs1 >> (rs2 & 63)); }

static inline int64_t _rv64_sbseti(int64_t rs1, int imm) { return _rv64_sbset(rs1, imm); }
static inline int64_t _rv64_sbclri(int64_t rs1, int imm) { return _rv64_sbclr(rs1, imm); }
static inline int64_t _rv64_sbinvi(int64_t rs1, int imm) { return _rv64_sbinv(rs1, imm); }
static inline int64_t _rv64_sbexti(int64_t rs1, int imm) { return _rv64_sbext(rs1, imm); }

static inline int32_t _rv32_sll    (int32_t rs1, int32_t rs2) { return rs1 << (rs2 & 31); }
static inline int32_t _rv32_srl    (int32_t rs1, int32_t rs2) { return (uint32_t)rs1 >> (rs2 & 31); }
static inline int32_t _rv32_sra    (int32_t rs1, int32_t rs2) { return rs1 >> (rs2 & 31); }
static inline int32_t _rv32_slo    (int32_t rs1, int32_t rs2) { return ~(~rs1 << (rs2 & 31)); }
static inline int32_t _rv32_sro    (int32_t rs1, int32_t rs2) { return ~(~(uint32_t)rs1 >> (rs2 & 31)); }
static inline int32_t _rv32_rol    (int32_t rs1, int32_t rs2) { return _rv32_sll(rs1, rs2) | _rv32_srl(rs1, -rs2); }
static inline int32_t _rv32_ror    (int32_t rs1, int32_t rs2) { return _rv32_srl(rs1, rs2) | _rv32_sll(rs1, -rs2); }

static inline int32_t _rv32_grev(int32_t rs1, int32_t rs2)
{
	uint32_t x = rs1;
	int shamt = rs2 & 31;
	if (shamt &  1) x = ((x & 0x55555555) <<  1) | ((x & 0xAAAAAAAA) >>  1);
	if (shamt &  2) x = ((x & 0x33333333) <<  2) | ((x & 0xCCCCCCCC) >>  2);
	if (shamt &  4) x = ((x & 0x0F0F0F0F) <<  4) | ((x & 0xF0F0F0F0) >>  4);
	if (shamt &  8) x = ((x & 0x00FF00FF) <<  8) | ((x & 0xFF00FF00) >>  8);
	if (shamt & 16) x = ((x & 0x0000FFFF) << 16) | ((x & 0xFFFF0000) >> 16);
	return x;
}

static inline uint32_t _rvintrin_shuffle32_stage(uint32_t src, uint32_t maskL, uint32_t maskR, int N)
{
	uint32_t x = src & ~(maskL | maskR);
	x |= ((src <<  N) & maskL) | ((src >>  N) & maskR);
	return x;
}

static inline int32_t _rv32_shfl(int32_t rs1, int32_t rs2)
{
	uint32_t x = rs1;
	int shamt = rs2 & 15;

	if (shamt & 8) x = _rvintrin_shuffle32_stage(x, 0x00ff0000, 0x0000ff00, 8);
	if (shamt & 4) x = _rvintrin_shuffle32_stage(x, 0x0f000f00, 0x00f000f0, 4);
	if (shamt & 2) x = _rvintrin_shuffle32_stage(x, 0x30303030, 0x0c0c0c0c, 2);
	if (shamt & 1) x = _rvintrin_shuffle32_stage(x, 0x44444444, 0x22222222, 1);

	return x;
}

static inline int32_t _rv32_unshfl(int32_t rs1, int32_t rs2)
{
	uint32_t x = rs1;
	int shamt = rs2 & 15;

	if (shamt & 1) x = _rvintrin_shuffle32_stage(x, 0x44444444, 0x22222222, 1);
	if (shamt & 2) x = _rvintrin_shuffle32_stage(x, 0x30303030, 0x0c0c0c0c, 2);
	if (shamt & 4) x = _rvintrin_shuffle32_stage(x, 0x0f000f00, 0x00f000f0, 4);
	if (shamt & 8) x = _rvintrin_shuffle32_stage(x, 0x00ff0000, 0x0000ff00, 8);

	return x;
}

static inline int32_t _rv32_slli   (int32_t rs1, int imm) { return _rv32_sll   (rs1, imm); }
static inline int32_t _rv32_srli   (int32_t rs1, int imm) { return _rv32_srl   (rs1, imm); }
static inline int32_t _rv32_srai   (int32_t rs1, int imm) { return _rv32_sra   (rs1, imm); }
static inline int32_t _rv32_sloi   (int32_t rs1, int imm) { return _rv32_slo   (rs1, imm); }
static inline int32_t _rv32_sroi   (int32_t rs1, int imm) { return _rv32_sro   (rs1, imm); }
static inline int32_t _rv32_roli   (int32_t rs1, int imm) { return _rv32_rol   (rs1, imm); }
static inline int32_t _rv32_rori   (int32_t rs1, int imm) { return _rv32_ror   (rs1, imm); }
static inline int32_t _rv32_grevi  (int32_t rs1, int imm) { return _rv32_grev  (rs1, imm); }
static inline int32_t _rv32_shfli  (int32_t rs1, int imm) { return _rv32_shfl  (rs1, imm); }
static inline int32_t _rv32_unshfli(int32_t rs1, int imm) { return _rv32_unshfl(rs1, imm); }

static inline int64_t _rv64_sll    (int64_t rs1, int64_t rs2) { return rs1 << (rs2 & 63); }
static inline int64_t _rv64_srl    (int64_t rs1, int64_t rs2) { return (uint64_t)rs1 >> (rs2 & 63); }
static inline int64_t _rv64_sra    (int64_t rs1, int64_t rs2) { return rs1 >> (rs2 & 63); }
static inline int64_t _rv64_slo    (int64_t rs1, int64_t rs2) { return ~(~rs1 << (rs2 & 63)); }
static inline int64_t _rv64_sro    (int64_t rs1, int64_t rs2) { return ~(~(uint64_t)rs1 >> (rs2 & 63)); }
static inline int64_t _rv64_rol    (int64_t rs1, int64_t rs2) { return _rv64_sll(rs1, rs2) | _rv64_srl(rs1, -rs2); }
static inline int64_t _rv64_ror    (int64_t rs1, int64_t rs2) { return _rv64_srl(rs1, rs2) | _rv64_sll(rs1, -rs2); }

static inline int64_t _rv64_grev(int64_t rs1, int64_t rs2)
{
	uint64_t x = rs1;
	int shamt = rs2 & 63;
	if (shamt &  1) x = ((x & 0x5555555555555555LL) <<  1) | ((x & 0xAAAAAAAAAAAAAAAALL) >>  1);
	if (shamt &  2) x = ((x & 0x3333333333333333LL) <<  2) | ((x & 0xCCCCCCCCCCCCCCCCLL) >>  2);
	if (shamt &  4) x = ((x & 0x0F0F0F0F0F0F0F0FLL) <<  4) | ((x & 0xF0F0F0F0F0F0F0F0LL) >>  4);
	if (shamt &  8) x = ((x & 0x00FF00FF00FF00FFLL) <<  8) | ((x & 0xFF00FF00FF00FF00LL) >>  8);
	if (shamt & 16) x = ((x & 0x0000FFFF0000FFFFLL) << 16) | ((x & 0xFFFF0000FFFF0000LL) >> 16);
	if (shamt & 32) x = ((x & 0x00000000FFFFFFFFLL) << 32) | ((x & 0xFFFFFFFF00000000LL) >> 32);
	return x;
}

static inline uint64_t _rvintrin_shuffle64_stage(uint64_t src, uint64_t maskL, uint64_t maskR, int N)
{
	uint64_t x = src & ~(maskL | maskR);
	x |= ((src <<  N) & maskL) | ((src >>  N) & maskR);
	return x;
}

static inline int64_t _rv64_shfl(int64_t rs1, int64_t rs2)
{
	uint64_t x = rs1;
	int shamt = rs2 & 31;
	if (shamt & 16) x = _rvintrin_shuffle64_stage(x, 0x0000ffff00000000LL, 0x00000000ffff0000LL, 16);
	if (shamt &  8) x = _rvintrin_shuffle64_stage(x, 0x00ff000000ff0000LL, 0x0000ff000000ff00LL,  8);
	if (shamt &  4) x = _rvintrin_shuffle64_stage(x, 0x0f000f000f000f00LL, 0x00f000f000f000f0LL,  4);
	if (shamt &  2) x = _rvintrin_shuffle64_stage(x, 0x3030303030303030LL, 0x0c0c0c0c0c0c0c0cLL,  2);
	if (shamt &  1) x = _rvintrin_shuffle64_stage(x, 0x4444444444444444LL, 0x2222222222222222LL,  1);
	return x;
}

static inline int64_t _rv64_unshfl(int64_t rs1, int64_t rs2)
{
	uint64_t x = rs1;
	int shamt = rs2 & 31;
	if (shamt &  1) x = _rvintrin_shuffle64_stage(x, 0x4444444444444444LL, 0x2222222222222222LL,  1);
	if (shamt &  2) x = _rvintrin_shuffle64_stage(x, 0x3030303030303030LL, 0x0c0c0c0c0c0c0c0cLL,  2);
	if (shamt &  4) x = _rvintrin_shuffle64_stage(x, 0x0f000f000f000f00LL, 0x00f000f000f000f0LL,  4);
	if (shamt &  8) x = _rvintrin_shuffle64_stage(x, 0x00ff000000ff0000LL, 0x0000ff000000ff00LL,  8);
	if (shamt & 16) x = _rvintrin_shuffle64_stage(x, 0x0000ffff00000000LL, 0x00000000ffff0000LL, 16);
	return x;
}

static inline int64_t _rv64_slli   (int64_t rs1, int imm) { return _rv64_sll   (rs1, imm); }
static inline int64_t _rv64_srli   (int64_t rs1, int imm) { return _rv64_srl   (rs1, imm); }
static inline int64_t _rv64_srai   (int64_t rs1, int imm) { return _rv64_sra   (rs1, imm); }
static inline int64_t _rv64_sloi   (int64_t rs1, int imm) { return _rv64_slo   (rs1, imm); }
static inline int64_t _rv64_sroi   (int64_t rs1, int imm) { return _rv64_sro   (rs1, imm); }
static inline int64_t _rv64_roli   (int64_t rs1, int imm) { return _rv64_rol   (rs1, imm); }
static inline int64_t _rv64_rori   (int64_t rs1, int imm) { return _rv64_ror   (rs1, imm); }
static inline int64_t _rv64_grevi  (int64_t rs1, int imm) { return _rv64_grev  (rs1, imm); }
static inline int64_t _rv64_shfli  (int64_t rs1, int imm) { return _rv64_shfl  (rs1, imm); }
static inline int64_t _rv64_unshfli(int64_t rs1, int imm) { return _rv64_unshfl(rs1, imm); }

static inline int32_t _rv32_bext(int32_t rs1, int32_t rs2)
{
	uint32_t c = 0, i = 0, data = rs1, mask = rs2;
	while (mask) {
		uint32_t b = mask & ~((mask | (mask-1)) + 1);
		c |= (data & b) >> (_rv32_ctz(b) - i);
		i += _rv32_pcnt(b);
		mask -= b;
	}
	return c;
}

static inline int32_t _rv32_bdep(int32_t rs1, int32_t rs2)
{
	uint32_t c = 0, i = 0, data = rs1, mask = rs2;
	while (mask) {
		uint32_t b = mask & ~((mask | (mask-1)) + 1);
		c |= (data << (_rv32_ctz(b) - i)) & b;
		i += _rv32_pcnt(b);
		mask -= b;
	}
	return c;
}

static inline int64_t _rv64_bext(int64_t rs1, int64_t rs2)
{
	uint64_t c = 0, i = 0, data = rs1, mask = rs2;
	while (mask) {
		uint64_t b = mask & ~((mask | (mask-1)) + 1);
		c |= (data & b) >> (_rv64_ctz(b) - i);
		i += _rv64_pcnt(b);
		mask -= b;
	}
	return c;
}

static inline int64_t _rv64_bdep(int64_t rs1, int64_t rs2)
{
	uint64_t c = 0, i = 0, data = rs1, mask = rs2;
	while (mask) {
		uint32_t b = mask & ~((mask | (mask-1)) + 1);
		c |= (data << (_rv64_ctz(b) - i)) & b;
		i += _rv64_pcnt(b);
		mask -= b;
	}
	return c;
}

// TBD: clmul[h[x]], crc32.[bhwd], crc32c.[bhwd]
// TBD: bmatxor, bmator, bmatflip
// TBD: cmix, cmov, fsl, fsr

#endif // RVINTRIN_EMULATE
#endif // RVINTRIN_H