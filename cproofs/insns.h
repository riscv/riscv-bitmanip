// --REF-BEGIN-- clz-ctz
uint_xlen_t clz(uint_xlen_t rs1)
{
	for (int count = 0; count < XLEN; count++)
		if ((rs1 << count) >> (XLEN - 1))
			return count;
	return XLEN;
}

uint_xlen_t ctz(uint_xlen_t rs1)
{
	for (int count = 0; count < XLEN; count++)
		if ((rs1 >> count) & 1)
			return count;
	return XLEN;
}
// --REF-END--

// --REF-BEGIN-- pcnt
uint_xlen_t pcnt(uint_xlen_t rs1)
{
	int count = 0;
	for (int index = 0; index < XLEN; index++)
		count += (rs1 >> index) & 1;
	return count;
}
// --REF-END--

// --REF-BEGIN-- fast-bitcnt
uint32_t fast_clz32(uint32_t rs1)
{
	if (rs1 == 0)
		return XLEN;
	assert(sizeof(int) == 4);
	return __builtin_clz(rs1);
}

uint64_t fast_clz64(uint64_t rs1)
{
	if (rs1 == 0)
		return XLEN;
	assert(sizeof(long long) == 8);
	return __builtin_clzll(rs1);
}

uint32_t fast_ctz32(uint32_t rs1)
{
	if (rs1 == 0)
		return XLEN;
	assert(sizeof(int) == 4);
	return __builtin_ctz(rs1);
}

uint64_t fast_ctz64(uint64_t rs1)
{
	if (rs1 == 0)
		return XLEN;
	assert(sizeof(long long) == 8);
	return __builtin_ctzll(rs1);
}

uint32_t fast_pcnt32(uint32_t rs1)
{
	assert(sizeof(int) == 4);
	return __builtin_popcount(rs1);
}

uint64_t fast_pcnt64(uint64_t rs1)
{
	assert(sizeof(long long) == 8);
	return __builtin_popcountll(rs1);
}
// --REF-END--

uint_xlen_t fast_clz(uint_xlen_t rs1)
{
#if XLEN == 32
	return fast_clz32(rs1);
#else
	return fast_clz64(rs1);
#endif
}

uint_xlen_t fast_ctz(uint_xlen_t rs1)
{
#if XLEN == 32
	return fast_ctz32(rs1);
#else
	return fast_ctz64(rs1);
#endif
}

uint_xlen_t fast_pcnt(uint_xlen_t rs1)
{
#if XLEN == 32
	return fast_pcnt32(rs1);
#else
	return fast_pcnt64(rs1);
#endif
}

// --REF-BEGIN-- sxo
uint_xlen_t slo(uint_xlen_t rs1, uint_xlen_t rs2)
{
	int shamt = rs2 & (XLEN - 1);
	return ~(~rs1 << shamt);
}

uint_xlen_t sro(uint_xlen_t rs1, uint_xlen_t rs2)
{
	int shamt = rs2 & (XLEN - 1);
	return ~(~rs1 >> shamt);
}
// --REF-END--

// --REF-BEGIN-- rox
uint_xlen_t rol(uint_xlen_t rs1, uint_xlen_t rs2)
{
	int shamt = rs2 & (XLEN - 1);
	return (rs1 << shamt) | (rs1 >> ((XLEN - shamt) & (XLEN - 1)));
}

uint_xlen_t ror(uint_xlen_t rs1, uint_xlen_t rs2)
{
	int shamt = rs2 & (XLEN - 1);
	return (rs1 >> shamt) | (rs1 << ((XLEN - shamt) & (XLEN - 1)));
}
// --REF-END--

// --REF-BEGIN-- andc
uint_xlen_t andc(uint_xlen_t rs1, uint_xlen_t rs2)
{
	return rs1 & ~rs2;
}
// --REF-END--

// --REF-BEGIN-- bext
uint_xlen_t bext(uint_xlen_t rs1, uint_xlen_t rs2)
{
	uint_xlen_t r = 0;
	for (int i = 0, j = 0; i < XLEN; i++)
		if ((rs2 >> i) & 1) {
			if ((rs1 >> i) & 1)
				r |= uint_xlen_t(1) << j;
			j++;
		}
	return r;
}

uint_xlen_t bdep(uint_xlen_t rs1, uint_xlen_t rs2)
{
	uint_xlen_t r = 0;
	for (int i = 0, j = 0; i < XLEN; i++)
		if ((rs2 >> i) & 1) {
			if ((rs1 >> j) & 1)
				r |= uint_xlen_t(1) << i;
			j++;
		}
	return r;
}
// --REF-END--

// --REF-BEGIN-- fast-bext
uint_xlen_t fast_bext(uint_xlen_t rs1, uint_xlen_t rs2)
{
	uint_xlen_t c = 0, i = 0, mask = rs2;
	int iter = 0; // NOREF
	while (mask) {
		if (iter >= XLEN) { assert(0); return 0; } iter++; // NOREF
		uint_xlen_t b = mask & ~((mask | (mask-1)) + 1);
		c |= (rs1 & b) >> (fast_ctz(b) - i);
		i += fast_pcnt(b);
		mask -= b;
	}
	return c;
}

uint_xlen_t fast_bdep(uint_xlen_t rs1, uint_xlen_t rs2)
{
	uint_xlen_t c = 0, i = 0, mask = rs2;
	int iter = 0; // NOREF
	while (mask) {
		if (iter >= XLEN) { assert(0); return 0; } iter++; // NOREF
		uint_xlen_t b = mask & ~((mask | (mask-1)) + 1);
		c |= (rs1 << (fast_ctz(b) - i)) & b;
		i += fast_pcnt(b);
		mask -= b;
	}
	return c;
}
// --REF-END--

#if 0
// --REF-BEGIN-- fast-bext-bmi2
uint32_t fast_bext32(uint32_t rs1, uint32_t rs2)
{
	return _pext_u32(rs1, rs2);
}

uint64_t fast_bext64(uint64_t rs1, uint64_t rs2)
{
	return _pext_u64(rs1, rs2);
}

uint32_t fast_bdep32(uint32_t rs1, uint32_t rs2)
{
	return _pdep_u32(rs1, rs2);
}

uint64_t fast_bdep64(uint64_t rs1, uint64_t rs2)
{
	return _pdep_u64(rs1, rs2);
}
// --REF-END--
#endif

// --REF-BEGIN-- grev
uint32_t grev32(uint32_t rs1, uint32_t rs2)
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

uint64_t grev64(uint64_t rs1, uint64_t rs2)
{
	uint64_t x = rs1;
	int shamt = rs2 & 63;
	if (shamt &  1) x = ((x & 0x5555555555555555LL) <<  1) |
	                    ((x & 0xAAAAAAAAAAAAAAAALL) >>  1);
	if (shamt &  2) x = ((x & 0x3333333333333333LL) <<  2) |
	                    ((x & 0xCCCCCCCCCCCCCCCCLL) >>  2);
	if (shamt &  4) x = ((x & 0x0F0F0F0F0F0F0F0FLL) <<  4) |
	                    ((x & 0xF0F0F0F0F0F0F0F0LL) >>  4);
	if (shamt &  8) x = ((x & 0x00FF00FF00FF00FFLL) <<  8) |
	                    ((x & 0xFF00FF00FF00FF00LL) >>  8);
	if (shamt & 16) x = ((x & 0x0000FFFF0000FFFFLL) << 16) |
	                    ((x & 0xFFFF0000FFFF0000LL) >> 16);
	if (shamt & 32) x = ((x & 0x00000000FFFFFFFFLL) << 32) |
	                    ((x & 0xFFFFFFFF00000000LL) >> 32);
	return x;
}
// --REF-END--

uint_xlen_t grev(uint_xlen_t rs1, uint_xlen_t rs2)
{
#if XLEN == 32
	return grev32(rs1, rs2);
#else
	return grev64(rs1, rs2);
#endif
}

#define GREV_PSEUDO_OP(_arg, _name) uint_xlen_t _name(uint_xlen_t rs1) { return grev(rs1, _arg); }

#if XLEN == 32
GREV_PSEUDO_OP( 1, brev_p)
GREV_PSEUDO_OP( 2, pswap_n)
GREV_PSEUDO_OP( 3, brev_n)
GREV_PSEUDO_OP( 4, nswap_p)
GREV_PSEUDO_OP( 6, pswap_b)
GREV_PSEUDO_OP( 7, brev_b)
GREV_PSEUDO_OP( 8, bswap_h)
GREV_PSEUDO_OP(12, nswap_h)
GREV_PSEUDO_OP(14, pswap_h)
GREV_PSEUDO_OP(15, brev_h)
GREV_PSEUDO_OP(16, hswap)
GREV_PSEUDO_OP(24, bswap)
GREV_PSEUDO_OP(28, nswap)
GREV_PSEUDO_OP(30, pswap)
GREV_PSEUDO_OP(31, brev)
#else
GREV_PSEUDO_OP( 1, brev_p)
GREV_PSEUDO_OP( 2, pswap_n)
GREV_PSEUDO_OP( 3, brev_n)
GREV_PSEUDO_OP( 4, nswap_p)
GREV_PSEUDO_OP( 6, pswap_b)
GREV_PSEUDO_OP( 7, brev_b)
GREV_PSEUDO_OP( 8, bswap_h)
GREV_PSEUDO_OP(12, nswap_h)
GREV_PSEUDO_OP(14, pswap_h)
GREV_PSEUDO_OP(15, brev_h)
GREV_PSEUDO_OP(16, hswap_w)
GREV_PSEUDO_OP(24, bswap_w)
GREV_PSEUDO_OP(28, nswap_w)
GREV_PSEUDO_OP(30, pswap_w)
GREV_PSEUDO_OP(31, brev_w)
GREV_PSEUDO_OP(32, wswap)
GREV_PSEUDO_OP(48, hswap)
GREV_PSEUDO_OP(56, bswap)
GREV_PSEUDO_OP(60, nswap)
GREV_PSEUDO_OP(62, pswap)
GREV_PSEUDO_OP(63, brev)
#endif

#undef GREV_PSEUDO_OP

// --REF-BEGIN-- gzip32
uint32_t shuffle32_stage(uint32_t src, uint32_t maskL, uint32_t maskR, int N)
{
	uint32_t x = src & ~(maskL | maskR);
	x |= ((src <<  N) & maskL) | ((src >>  N) & maskR);
	return x;
}

uint32_t shfl32(uint32_t rs1, uint32_t rs2)
{
	uint32_t x = rs1;
	int shamt = rs2 & 15;

	if (shamt & 8) x = shuffle32_stage(x, 0x00ff0000, 0x0000ff00, 8);
	if (shamt & 4) x = shuffle32_stage(x, 0x0f000f00, 0x00f000f0, 4);
	if (shamt & 2) x = shuffle32_stage(x, 0x30303030, 0x0c0c0c0c, 2);
	if (shamt & 1) x = shuffle32_stage(x, 0x44444444, 0x22222222, 1);

	return x;
}

uint32_t unshfl32(uint32_t rs1, uint32_t rs2)
{
	uint32_t x = rs1;
	int shamt = rs2 & 15;

	if (shamt & 1) x = shuffle32_stage(x, 0x44444444, 0x22222222, 1);
	if (shamt & 2) x = shuffle32_stage(x, 0x30303030, 0x0c0c0c0c, 2);
	if (shamt & 4) x = shuffle32_stage(x, 0x0f000f00, 0x00f000f0, 4);
	if (shamt & 8) x = shuffle32_stage(x, 0x00ff0000, 0x0000ff00, 8);

	return x;
}
// --REF-END--

// --REF-BEGIN-- gzip64
uint64_t shuffle64_stage(uint64_t src, uint64_t maskL, uint64_t maskR, int N)
{
	uint64_t x = src & ~(maskL | maskR);
	x |= ((src <<  N) & maskL) | ((src >>  N) & maskR);
	return x;
}

uint64_t shfl64(uint64_t rs1, uint64_t rs2)
{
	uint64_t x = rs1;
	int shamt = rs2 & 31;

	if (shamt & 16) x = shuffle64_stage(x, 0x0000ffff00000000LL,
	                                       0x00000000ffff0000LL, 16);
	if (shamt &  8) x = shuffle64_stage(x, 0x00ff000000ff0000LL,
	                                       0x0000ff000000ff00LL, 8);
	if (shamt &  4) x = shuffle64_stage(x, 0x0f000f000f000f00LL,
	                                       0x00f000f000f000f0LL, 4);
	if (shamt &  2) x = shuffle64_stage(x, 0x3030303030303030LL,
	                                       0x0c0c0c0c0c0c0c0cLL, 2);
	if (shamt &  1) x = shuffle64_stage(x, 0x4444444444444444LL,
	                                       0x2222222222222222LL, 1);

	return x;
}

uint64_t unshfl64(uint64_t rs1, uint64_t rs2)
{
	uint64_t x = rs1;
	int shamt = rs2 & 31;

	if (shamt &  1) x = shuffle64_stage(x, 0x4444444444444444LL,
	                                       0x2222222222222222LL, 1);
	if (shamt &  2) x = shuffle64_stage(x, 0x3030303030303030LL,
	                                       0x0c0c0c0c0c0c0c0cLL, 2);
	if (shamt &  4) x = shuffle64_stage(x, 0x0f000f000f000f00LL,
	                                       0x00f000f000f000f0LL, 4);
	if (shamt &  8) x = shuffle64_stage(x, 0x00ff000000ff0000LL,
	                                       0x0000ff000000ff00LL, 8);
	if (shamt & 16) x = shuffle64_stage(x, 0x0000ffff00000000LL,
	                                       0x00000000ffff0000LL, 16);

	return x;
}
// --REF-END--

uint_xlen_t shfl(uint_xlen_t rs1, uint_xlen_t rs2)
{
#if XLEN == 32
	return shfl32(rs1, rs2);
#else
	return shfl64(rs1, rs2);
#endif
}

uint_xlen_t unshfl(uint_xlen_t rs1, uint_xlen_t rs2)
{
#if XLEN == 32
	return unshfl32(rs1, rs2);
#else
	return unshfl64(rs1, rs2);
#endif
}

#define SHFL_PSEUDO_OP(_arg, _name) \
  uint_xlen_t _name(uint_xlen_t rs1) { return shfl(rs1, _arg); }  \
  uint_xlen_t un ## _name(uint_xlen_t rs1) { return unshfl(rs1, _arg); }  \

#if XLEN == 32
SHFL_PSEUDO_OP( 1, zip_n)
SHFL_PSEUDO_OP( 2, zip2_b)
SHFL_PSEUDO_OP( 3, zip_b)
SHFL_PSEUDO_OP( 4, zip4_h)
SHFL_PSEUDO_OP( 6, zip2_h)
SHFL_PSEUDO_OP( 7, zip_h)
SHFL_PSEUDO_OP( 8, zip8)
SHFL_PSEUDO_OP(12, zip4)
SHFL_PSEUDO_OP(14, zip2)
SHFL_PSEUDO_OP(15, zip)
#else
SHFL_PSEUDO_OP( 1, zip_n)
SHFL_PSEUDO_OP( 2, zip2_b)
SHFL_PSEUDO_OP( 3, zip_b)
SHFL_PSEUDO_OP( 4, zip4_h)
SHFL_PSEUDO_OP( 6, zip2_h)
SHFL_PSEUDO_OP( 7, zip_h)
SHFL_PSEUDO_OP( 8, zip8_w)
SHFL_PSEUDO_OP(12, zip4_w)
SHFL_PSEUDO_OP(14, zip2_w)
SHFL_PSEUDO_OP(15, zip_w)
SHFL_PSEUDO_OP(16, zip16)
SHFL_PSEUDO_OP(24, zip8)
SHFL_PSEUDO_OP(28, zip4)
SHFL_PSEUDO_OP(30, zip2)
SHFL_PSEUDO_OP(31, zip)
#endif

#undef SHFL_PSEUDO_OP

// --REF-BEGIN-- gzip32-alt
uint32_t shuffle32_flip(uint32_t src)
{
	uint32_t x = src & 0x88224411;
	x |= ((src <<  6) & 0x22001100) | ((src >>  6) & 0x00880044);
	x |= ((src <<  9) & 0x00440000) | ((src >>  9) & 0x00002200);
	x |= ((src << 15) & 0x44110000) | ((src >> 15) & 0x00008822);
	x |= ((src << 21) & 0x11000000) | ((src >> 21) & 0x00000088);
	return x;
}

uint32_t unshfl32alt(uint32_t rs1, uint32_t rs2)
{
	uint32_t shfl_mode = 0;
	if (rs2 & 1) shfl_mode |= 8;
	if (rs2 & 2) shfl_mode |= 4;
	if (rs2 & 4) shfl_mode |= 2;
	if (rs2 & 8) shfl_mode |= 1;

	uint32_t x = rs1;
	x = shuffle32_flip(x);
	x = shfl32(x, shfl_mode);
	x = shuffle32_flip(x);

	return x;
}
// --REF-END--

// --REF-BEGIN-- minmax
int_xlen_t min(int_xlen_t rs1, int_xlen_t rs2)
{
	return rs1 < rs2 ? rs1 : rs2;
}

int_xlen_t max(int_xlen_t rs1, int_xlen_t rs2)
{
	return rs1 > rs2 ? rs1 : rs2;
}

uint_xlen_t minu(uint_xlen_t rs1, uint_xlen_t rs2)
{
	return rs1 < rs2 ? rs1 : rs2;
}

uint_xlen_t maxu(uint_xlen_t rs1, uint_xlen_t rs2)
{
	return rs1 > rs2 ? rs1 : rs2;
}
// --REF-END--

// --REF-BEGIN-- clmul
uint_xlen_t clmul(uint_xlen_t rs1, uint_xlen_t rs2)
{
	uint_xlen_t x = 0;
	for (int i = 0; i < XLEN; i++)
		if ((rs2 >> i) & 1)
			x ^= rs1 << i;
	return x;
}

uint_xlen_t clmulh(uint_xlen_t rs1, uint_xlen_t rs2)
{
	uint_xlen_t x = 0;
	for (int i = 1; i < XLEN; i++)
		if ((rs2 >> i) & 1)
			x ^= rs1 >> (XLEN-i);
	return x;
}
// --REF-END--

// --REF-BEGIN-- bmat
uint64_t bmatflip(uint64_t rs1)
{
	uint64_t x = rs1;
	x = shfl64(x, 31);
	x = shfl64(x, 31);
	x = shfl64(x, 31);
	return x;
}

uint64_t bmatxor(uint64_t rs1, uint64_t rs2)
{
	// transpose of rs2
	uint64_t rs2t = bmatflip(rs2);

	uint8_t u[8]; // rows of rs1
	uint8_t v[8]; // cols of rs2

	for (int i = 0; i < 8; i++) {
		u[i] = rs1 >> (i*8);
		v[i] = rs2t >> (i*8);
	}

	uint64_t x = 0;
	for (int i = 0; i < 64; i++) {
		if (pcnt(u[i / 8] & v[i % 8]) & 1)
			x |= 1LL << i;
	}

	return x;
}

uint64_t bmator(uint64_t rs1, uint64_t rs2)
{
	// transpose of rs2
	uint64_t rs2t = bmatflip(rs2);

	uint8_t u[8]; // rows of rs1
	uint8_t v[8]; // cols of rs2

	for (int i = 0; i < 8; i++) {
		u[i] = rs1 >> (i*8);
		v[i] = rs2t >> (i*8);
	}

	uint64_t x = 0;
	for (int i = 0; i < 64; i++) {
		if ((u[i / 8] & v[i % 8]) != 0)
			x |= 1LL << i;
	}

	return x;
}
// --REF-END--

// --REF-BEGIN-- crc
uint_xlen_t crc32(uint_xlen_t x, int nbits)
{
	for (int i = 0; i < nbits; i++)
		x = (x >> 1) ^ (0xEDB88320 & ~((x&1)-1));
	return x;
}

uint_xlen_t crc32c(uint_xlen_t x, int nbits)
{
	for (int i = 0; i < nbits; i++)
		x = (x >> 1) ^ (0x82F63B78 & ~((x&1)-1));
	return x;
}

uint_xlen_t crc32_b(uint_xlen_t rs1) { return crc32(rs1, 8); }
uint_xlen_t crc32_h(uint_xlen_t rs1) { return crc32(rs1, 16); }
uint_xlen_t crc32_w(uint_xlen_t rs1) { return crc32(rs1, 32); }

uint_xlen_t crc32c_b(uint_xlen_t rs1) { return crc32c(rs1, 8); }
uint_xlen_t crc32c_h(uint_xlen_t rs1) { return crc32c(rs1, 16); }
uint_xlen_t crc32c_w(uint_xlen_t rs1) { return crc32c(rs1, 32); }

#if XLEN > 32
uint_xlen_t crc32_d (uint_xlen_t rs1) { return crc32 (rs1, 64); }
uint_xlen_t crc32c_d(uint_xlen_t rs1) { return crc32c(rs1, 64); }
#endif
// --REF-END--

// --REF-BEGIN-- bfxp
uint_xlen_t bfxp(uint_xlen_t rs1, uint_xlen_t rs2,
		unsigned start, unsigned len, unsigned dest)
{
	assert(start < XLEN && len < XLEN && dest < XLEN);

	assert(start + len <= XLEN);
	assert(dest + len <= XLEN);
	assert(len != 0);

	uint_xlen_t x = rs1;
	x <<= XLEN-start-len;
	x >>= XLEN-len;
	x <<= dest;

	uint_xlen_t y = ~uint_xlen_t(0);
	y <<= XLEN-start-len;
	y >>= XLEN-len;
	y <<= dest;

	return x | (rs2 & ~y);
}

uint_xlen_t bfxpc(uint_xlen_t rs1, uint_xlen_t rs2,
		unsigned start, unsigned len, unsigned dest)
{
	return bfxp(~rs1, rs2, start, len, dest);
}
// --REF-END--

uint_xlen_t sll(uint_xlen_t x, int k)
{
	int shamt = k & (XLEN - 1);
	return x << shamt;
}

uint_xlen_t srl(uint_xlen_t x, int k)
{
	int shamt = k & (XLEN - 1);
	return x >> shamt;
}

uint_xlen_t sra(uint_xlen_t x, int k)
{
	int shamt = k & (XLEN - 1);
	if (x >> (XLEN-1))
		return ~(~x >> shamt);
	return x >> shamt;
}
