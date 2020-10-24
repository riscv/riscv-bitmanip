// RV64 replacement sequences for *W instructions
//
// 2 ops:
//     PCNTW    =>  PACK+PCNT
//     SHFLW    =>  ANDI+SHFLW
//     UNSHFLW  =>  ANDI+UNSHFLW
//     SBEXTW   =>  ANDI+SBEXT
//     BDEPW    =>  BDEP+SEXT
//     CLMULW   =>  CLMUL+SEXT
// 3 ops:
//     CLZW     =>  LI+PACK+CLZ
//     CTZW     =>  LI+PACK+CTZ
//     ROLW     =>  PACK+ROL+SEXT
//     RORW     =>  PACK+ROR+SEXT
//     GREVW    =>  ANDI+GREV+SEXT
//     GORCW    =>  ANDI+GORC+SEXT
//     SBSETW   =>  ANDI+SBSET+SEXT
//     SBCLRW   =>  ANDI+SBCLR+SEXT
//     SBINVW   =>  ANDI+SBINV+SEXT
//     BEXTW    =>  PACK+BEXT+SEXT
//     FSL      =>  PACK+ROL+SEXT
//     FSR      =>  PACK+ROR+SEXT
// 4 ops:
//     PACKW    =>  SLLW+SRLW+SLLW+OR
//     PACKUW   =>  SRLW+SRLW+SLLW+OR
//     CLMULHW  =>  PACK+PACK+CLMUL+SRL
//     CLMULRW  =>  PACK+PACK+CLMUL+SRL
// 5 or more ops:
//     BFPW     =>  over 6 instructions

#ifdef __CPROVER__
#define RVINTRIN_NOBUILTINS
#endif

#define RVINTRIN_EMULATE
#include "rvintrin.h"
#include <stdio.h>
#include <assert.h>

#ifdef __CPROVER__
#define ASSERT_X_Y \
	assert(x == y);
#else
#define ASSERT_X_Y \
	printf("%-15s 0x%016lx 0x%016lx\n", __func__, x, y); \
	assert(x == y);
#endif

extern "C" void check_clzw(int32_t a)
{
	// CLZW  =>  LI+PACK+CLZ
	int64_t x = _rv32_clz(a);
	int64_t y = _rv64_clz(_rv64_pack(-1, a));
	ASSERT_X_Y
}

extern "C" void check_ctzw(int32_t a)
{
	// CTZW  =>  LI+PACK+CTZ
	int64_t x = _rv32_ctz(a);
	int64_t y = _rv64_ctz(_rv64_pack(a, -1));
	ASSERT_X_Y
}

extern "C" void check_pcntw(int32_t a)
{
	// PCNTW  =>  PACK+PCNT
	int64_t x = _rv32_pcnt(a);
	int64_t y = _rv64_pcnt(_rv64_pack(0, a));
	ASSERT_X_Y
}

extern "C" void check_rolw(int32_t a, int32_t b)
{
	// ROLW  =>  PACK+ROL+SEXT
	int64_t x = _rv32_rol(a, b);
	int64_t y = int32_t(_rv64_rol(_rv64_pack(a, a), b));
	ASSERT_X_Y
}

extern "C" void check_rorw(int32_t a, int32_t b)
{
	// RORW  =>  PACK+ROR+SEXT
	int64_t x = _rv32_ror(a, b);
	int64_t y = int32_t(_rv64_ror(_rv64_pack(a, a), b));
	ASSERT_X_Y
}

extern "C" void check_packw(int32_t a, int32_t b)
{
	// PACKW  =>  SLLW+SRLW+SLLW+OR
	int64_t x = _rv32_pack(a, b);
	int64_t y = int32_t(uint32_t(a) << 16 >> 16) | int32_t(uint32_t(b) << 16);
	ASSERT_X_Y
}

extern "C" void check_packuw(int32_t a, int32_t b)
{
	// PACKUW  =>  SRLW+SRLW+SLLW+OR
	int64_t x = _rv32_packu(a, b);
	int64_t y = int32_t(uint32_t(a) >> 16) | int32_t(uint32_t(b) >> 16 << 16);
	ASSERT_X_Y
}

extern "C" void check_grevw(int32_t a, int32_t b)
{
	// GREVW  =>  ANDI+GREV+SEXT
	int64_t x = _rv32_grev(a, b);
	int64_t y = int32_t(_rv64_grev(a, b & 31));
	ASSERT_X_Y
}

extern "C" void check_gorcw(int32_t a, int32_t b)
{
	// GORCW  =>  ANDI+GORC+SEXT
	int64_t x = _rv32_gorc(a, b);
	int64_t y = int32_t(_rv64_gorc(a, b & 31));
	ASSERT_X_Y
}

extern "C" void check_shflw(int32_t a, int32_t b)
{
	// SHFLW  =>  ANDI+SHFLW
	int64_t x = _rv32_shfl(a, b);
	int64_t y = _rv64_shfl(a, b & 15);
	ASSERT_X_Y
}

extern "C" void check_unshflw(int32_t a, int32_t b)
{
	// UNSHFLW  =>  ANDI+UNSHFLW
	int64_t x = _rv32_unshfl(a, b);
	int64_t y = _rv64_unshfl(a, b & 15);
	ASSERT_X_Y
}

extern "C" void check_sbsetw(int32_t a, int32_t b)
{
	// SBSETW  =>  ANDI+SBSET+SEXT
	int64_t x = _rv32_sbset(a, b);
	int64_t y = int32_t(_rv64_sbset(a, b & 31));
	ASSERT_X_Y
}

extern "C" void check_sbclrw(int32_t a, int32_t b)
{
	// SBCLRW  =>  ANDI+SBCLR+SEXT
	int64_t x = _rv32_sbclr(a, b);
	int64_t y = int32_t(_rv64_sbclr(a, b & 31));
	ASSERT_X_Y
}

extern "C" void check_sbinvw(int32_t a, int32_t b)
{
	// SBINVW  =>  ANDI+SBINV+SEXT
	int64_t x = _rv32_sbinv(a, b);
	int64_t y = int32_t(_rv64_sbinv(a, b & 31));
	ASSERT_X_Y
}

extern "C" void check_sbextw(int32_t a, int32_t b)
{
	// SBEXTW  =>  ANDI+SBEXT
	int64_t x = _rv32_sbext(a, b);
	int64_t y = _rv64_sbext(a, b & 31);
	ASSERT_X_Y
}

extern "C" void check_bextw(int32_t a, int32_t b)
{
	// BEXTW  =>  PACK+BEXT+SEXT
	int64_t x = _rv32_bext(a, b);
	int64_t y = int32_t(_rv64_bext(a, _rv64_pack(b, 0)));
	ASSERT_X_Y
}

extern "C" void check_bdepw(int32_t a, int32_t b)
{
	// BDEPW  =>  BDEP+SEXT
	int64_t x = _rv32_bdep(a, b);
	int64_t y = int32_t(_rv64_bdep(a, b));
	ASSERT_X_Y
}

extern "C" void check_bfpw(int32_t a, int32_t b)
{
	// BFPW  =>  over 6 instructions
}

extern "C" void check_clmulw(int32_t a, int32_t b)
{
	// CLMULW  =>  CLMUL+SEXT
	int64_t x = _rv32_clmul(a, b);
	int64_t y = int32_t(_rv64_clmul(a, b));
	ASSERT_X_Y
}

extern "C" void check_clmulhw(int32_t a, int32_t b)
{
	// CLMULHW  =>  PACK+PACK+CLMUL+SRL
	int64_t x = _rv32_clmulh(a, b);
	int64_t y = _rv64_clmul(_rv64_pack(a, 0), _rv64_pack(b, 0)) >> 32;
	ASSERT_X_Y
}

extern "C" void check_clmulrw(int32_t a, int32_t b)
{
	// CLMULRW  =>  PACK+PACK+CLMUL+SRL
	int64_t x = _rv32_clmulr(a, b);
	int64_t y = _rv64_clmulr(_rv64_pack(0, a), _rv64_pack(0, b)) >> 32;
	ASSERT_X_Y
}

extern "C" void check_fslw(int32_t a, int32_t b, int32_t shamt)
{
	// FSL  =>  PACK+ROL+SEXT
	int64_t x = _rv32_fsl(a, b, shamt);
	int64_t y = int32_t(_rv64_rol(_rv64_pack(a, b), shamt));
	ASSERT_X_Y
}

extern "C" void check_fsrw(int32_t a, int32_t b, int shamt)
{
	// FSR  =>  PACK+ROR+SEXT
	int64_t x = _rv32_fsr(a, b, shamt);
	int64_t y = int32_t(_rv64_ror(_rv64_pack(a, b), shamt));
	ASSERT_X_Y
}

uint32_t words[] = {
	0x00000000,
	0x00000001,
	0x10000000,
	0xffffffff,

	0x00000002,
	0x00000003,
	0x00000004,
	0x00000005,
	0x00000006,
	0x00000007,
	0x00000008,

	0x0000000f,
	0x00000010,
	0x0000001f,
	0x00000020,
	0x0000002f,
	0x00000030,
	0x0000003f,
	0x00000040,

	0x553ebec8,
	0xe1cb336b,
	0x4a7df08f,
	0xea06e56c,
	0x392ba9db,
	0x30974724,
	0x42575109,
	0x78fd7ee1,
	0xd587bc37,
	0x55c2f80f,
	0x34d586f0,
	0xa5049e6f,
	0x283b556a,
	0xee6c741e,
	0xdf80e242,
	0xd4b35bab
};

int main()
{
	int nwords = sizeof(words)/sizeof(*words);
	for (int i = 0; i < nwords; i++)
	{
		printf("== 0x%08x\n", words[i]);
		check_clzw(words[i]);
		check_ctzw(words[i]);
		check_pcntw(words[i]);

		for (int j = 0; j < nwords; j++)
		{
			printf("= 0x%08x 0x%08x\n", words[i], words[j]);
			check_rolw(words[i], words[j]);
			check_rorw(words[i], words[j]);
			check_packw(words[i], words[j]);
			check_packuw(words[i], words[j]);
			check_grevw(words[i], words[j]);
			check_gorcw(words[i], words[j]);
			check_shflw(words[i], words[j]);
			check_unshflw(words[i], words[j]);
			check_sbsetw(words[i], words[j]);
			check_sbclrw(words[i], words[j]);
			check_sbinvw(words[i], words[j]);
			check_sbextw(words[i], words[j]);
			check_bextw(words[i], words[j]);
			check_bdepw(words[i], words[j]);
			check_bfpw(words[i], words[j]);
			check_clmulw(words[i], words[j]);
			check_clmulhw(words[i], words[j]);
			check_clmulrw(words[i], words[j]);
			for (int k = -1; k < 33; k++) {
				check_fslw(words[i], words[j], k);
				check_fsrw(words[i], words[j], k);
			}
		}
	}
	printf("OKAY.\n");
	return 0;
}
