#ifdef __CPROVER__
#define RVINTRIN_NOBUILTINS
#endif

#define RVINTRIN_EMULATE
#include "rvintrin.h"
#include <stdio.h>
#include <assert.h>

extern "C" void check_clzw(int32_t a)
{
	// CLZW  =>  PACK+CLZ+ADDI
	int64_t x = _rv32_clz(a);
	int64_t y = _rv64_clz(_rv64_pack(a, 0))-32;
	assert(x == y);
}

extern "C" void check_ctzw(int32_t a)
{
	// CTZW  =>  PACK+CTZ+ADDI
	int64_t x = _rv32_ctz(a);
	int64_t y = _rv64_ctz(_rv64_pack(0, a))-32;
	assert(x == y);
}

extern "C" void check_pcntw(int32_t a)
{
	// PCNTW  =>  PACK+PCNT
	int64_t x = _rv32_pcnt(a);
	int64_t y = _rv64_pcnt(_rv64_pack(0, a));
	assert(x == y);
}

extern "C" void check_rolw(int32_t a, int32_t b)
{
	// ROLW  =>  PACK+ROL+SEXT
	int64_t x = _rv32_rol(a, b);
	int64_t y = int32_t(_rv64_rol(_rv64_pack(a, a), b));
	assert(x == y);
}

extern "C" void check_rorw(int32_t a, int32_t b)
{
	// RORW  =>  PACK+ROR+SEXT
	int64_t x = _rv32_ror(a, b);
	int64_t y = int32_t(_rv64_ror(_rv64_pack(a, a), b));
	assert(x == y);
}

extern "C" void check_packw(int32_t a, int32_t b)
{
	// PACKW  =>  SLLW+SRLW+SLLW+OR
	int64_t x = _rv32_pack(a, b);
	int64_t y = int32_t(uint32_t(a) << 16 >> 16) | int32_t(uint32_t(b) << 16);
	assert(x == y);
}

extern "C" void check_packuw(int32_t a, int32_t b)
{
	// PACKUW  =>  SRLW+SRLW+SLLW+OR
	int64_t x = _rv32_packu(a, b);
	int64_t y = int32_t(uint32_t(a) >> 16) | int32_t(uint32_t(b) >> 16 << 16);
	assert(x == y);
}

extern "C" void check_grevw(int32_t a, int32_t b)
{
	// GREVW  =>  ANDI+GREV+SEXT
	int64_t x = _rv32_grev(a, b);
	int64_t y = int32_t(_rv64_grev(a, b & 31));
	assert(x == y);
}

extern "C" void check_gorcw(int32_t a, int32_t b)
{
	// GORCW  =>  ANDI+GORC+SEXT
	int64_t x = _rv32_gorc(a, b);
	int64_t y = int32_t(_rv64_gorc(a, b & 31));
	assert(x == y);
}

extern "C" void check_shflw(int32_t a, int32_t b)
{
	// SHFLW  =>  ANDI+SHFLW
	int64_t x = _rv32_shfl(a, b);
	int64_t y = _rv64_shfl(a, b & 15);
	assert(x == y);
}

extern "C" void check_unshflw(int32_t a, int32_t b)
{
	// UNSHFLW  =>  ANDI+UNSHFLW
	int64_t x = _rv32_unshfl(a, b);
	int64_t y = _rv64_unshfl(a, b & 15);
	assert(x == y);
}

extern "C" void check_sbsetw(int32_t a, int32_t b)
{
	// SBSETW  =>  ANDI+SBSET+SEXT
	int64_t x = _rv32_sbset(a, b);
	int64_t y = int32_t(_rv64_sbset(a, b & 31));
	assert(x == y);
}

extern "C" void check_sbclrw(int32_t a, int32_t b)
{
	// SBCLRW  =>  ANDI+SBCLR+SEXT
	int64_t x = _rv32_sbclr(a, b);
	int64_t y = int32_t(_rv64_sbclr(a, b & 31));
	assert(x == y);
}

extern "C" void check_sbinvw(int32_t a, int32_t b)
{
	// SBINVW  =>  ANDI+SBINV+SEXT
	int64_t x = _rv32_sbinv(a, b);
	int64_t y = int32_t(_rv64_sbinv(a, b & 31));
	assert(x == y);
}

extern "C" void check_sbextw(int32_t a, int32_t b)
{
	// SBEXTW  =>  ANDI+SBEXT
	int64_t x = _rv32_sbext(a, b);
	int64_t y = _rv64_sbext(a, b & 31);
	assert(x == y);
}

extern "C" void check_bextw(int32_t a, int32_t b)
{
	// BEXTW  =>  PACK+BEXT+SEXT
	int64_t x = _rv32_bext(a, b);
	int64_t y = int32_t(_rv64_bext(a, _rv64_pack(b, 0)));
	assert(x == y);
}

extern "C" void check_bdepw(int32_t a, int32_t b)
{
	// BDEPW  =>  BDEP+SEXT
	int64_t x = _rv32_bdep(a, b);
	int64_t y = int32_t(_rv64_bdep(a, b));
	assert(x == y);
}

extern "C" void check_bfpw(int32_t a, int32_t b)
{
	// TBD
}

extern "C" void check_clmulw(int32_t a, int32_t b)
{
	// TBD
}

extern "C" void check_clmulhw(int32_t a, int32_t b)
{
	// TBD
}

extern "C" void check_clmulrw(int32_t a, int32_t b)
{
	// TBD
}

extern "C" void check_fslw(int32_t a, int32_t b)
{
	// TBD
}

extern "C" void check_fsrw(int32_t a, int32_t b)
{
	// TBD
}
