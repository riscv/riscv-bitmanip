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
	return (rs1 << shamt) | (rs1 >> (XLEN - shamt));
}

uint_xlen_t ror(uint_xlen_t rs1, uint_xlen_t rs2)
{
	int shamt = rs2 & (XLEN - 1);
	return (rs1 >> shamt) | (rs1 << (XLEN - shamt));
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
	uint_xlen_t c = 0, m = 1, mask = rs2;
#if 1                                                       // NOREF
	for (int iter = 0; mask && iter <= XLEN; iter++) {  // NOREF
		assert(iter < XLEN);                        // NOREF
#else                                                       // NOREF
	while (mask) {
#endif                                                      // NOREF
		uint_xlen_t b = mask & -mask;
		if (rs1 & b)
			c |= m;
		mask -= b;
		m <<= 1;
	}
	return c;
}

uint_xlen_t bdep(uint_xlen_t rs1, uint_xlen_t rs2)
{
	uint_xlen_t c = 0, m = 1, mask = rs2;
#if 1                                                       // NOREF
	for (int iter = 0; mask && iter <= XLEN; iter++) {  // NOREF
		assert(iter < XLEN);                        // NOREF
#else                                                       // NOREF
	while (mask) {
#endif                                                      // NOREF
		uint_xlen_t b = mask & -mask;
		if (rs1 & m)
			c |= b;
		mask -= b;
		m <<= 1;
	}
	return c;
}
// --REF-END--

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
	if (shamt &  1) x = ((x & 0x5555555555555555ull) <<  1) |
	                    ((x & 0xAAAAAAAAAAAAAAAAull) >>  1);
	if (shamt &  2) x = ((x & 0x3333333333333333ull) <<  2) |
	                    ((x & 0xCCCCCCCCCCCCCCCCull) >>  2);
	if (shamt &  4) x = ((x & 0x0F0F0F0F0F0F0F0Full) <<  4) |
	                    ((x & 0xF0F0F0F0F0F0F0F0ull) >>  4);
	if (shamt &  8) x = ((x & 0x00FF00FF00FF00FFull) <<  8) |
	                    ((x & 0xFF00FF00FF00FF00ull) >>  8);
	if (shamt & 16) x = ((x & 0x0000FFFF0000FFFFull) << 16) |
	                    ((x & 0xFFFF0000FFFF0000ull) >> 16);
	if (shamt & 32) x = ((x & 0x00000000FFFFFFFFull) << 32) |
	                    ((x & 0xFFFFFFFF00000000ull) >> 32);
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

// --REF-BEGIN-- gzip32
uint32_t gzip32_stage(uint32_t src, uint32_t maskL, uint32_t maskR, int N)
{
	uint32_t x = src & ~(maskL | maskR);
	x |= ((src <<  N) & maskL) | ((src >>  N) & maskR);
	return x;
}

uint32_t gzip32(uint32_t rs1, uint32_t rs2)
{
	uint32_t x = rs1;
	int mode = rs2 & 31;

	if (mode & 1) {
		if (mode &  2) x = gzip32_stage(x, 0x44444444, 0x22222222, 1);
		if (mode &  4) x = gzip32_stage(x, 0x30303030, 0x0c0c0c0c, 2);
		if (mode &  8) x = gzip32_stage(x, 0x0f000f00, 0x00f000f0, 4);
		if (mode & 16) x = gzip32_stage(x, 0x00ff0000, 0x0000ff00, 8);
	} else {
		if (mode & 16) x = gzip32_stage(x, 0x00ff0000, 0x0000ff00, 8);
		if (mode &  8) x = gzip32_stage(x, 0x0f000f00, 0x00f000f0, 4);
		if (mode &  4) x = gzip32_stage(x, 0x30303030, 0x0c0c0c0c, 2);
		if (mode &  2) x = gzip32_stage(x, 0x44444444, 0x22222222, 1);
	}

	return x;
}
// --REF-END--

// --REF-BEGIN-- gzip32-alt
uint32_t gzip32_flip(uint32_t src)
{
	uint32_t x = src & 0x88224411;
	x |= ((src <<  6) & 0x22001100) | ((src >>  6) & 0x00880044);
	x |= ((src <<  9) & 0x00440000) | ((src >>  9) & 0x00002200);
	x |= ((src << 15) & 0x44110000) | ((src >> 15) & 0x00008822);
	x |= ((src << 21) & 0x11000000) | ((src >> 21) & 0x00000088);
	return x;
}

uint32_t gzip32alt(uint32_t rs1, uint32_t rs2)
{
	uint32_t x = rs1;
	int mode = rs2 & 31;

	if (mode &  1)
		x = gzip32_flip(x);

	if ((mode & 17) == 16 || (mode &  3) ==  3)
		x = gzip32_stage(x, 0x00ff0000, 0x0000ff00, 8);

	if ((mode &  9) ==  8 || (mode &  5) ==  5)
		x = gzip32_stage(x, 0x0f000f00, 0x00f000f0, 4);

	if ((mode &  5) ==  4 || (mode &  9) ==  9)
		x = gzip32_stage(x, 0x30303030, 0x0c0c0c0c, 2);

	if ((mode &  3) ==  2 || (mode & 17) == 17)
		x = gzip32_stage(x, 0x44444444, 0x22222222, 1);

	if (mode &  1)
		x = gzip32_flip(x);

	return x;
}
// --REF-END--

uint_xlen_t gzip(uint_xlen_t rs1, uint_xlen_t rs2)
{
#if XLEN == 32
	return gzip32(rs1, rs2);
#else
	assert(0);
	// return gzip64(rs1, rs2);
#endif
}

// --REF-BEGIN-- bfxp
uint_xlen_t bfxp(uint_xlen_t rs1, unsigned start, unsigned len, unsigned dest)
{
	assert(start < 32 && len < 32 && dest < 32);

	if (XLEN > 32 && len == 0)
		len = 32;

	if (start + len > XLEN || dest + len > XLEN || len == 0)
		return 0;

	uint_xlen_t x = rs1;
	x <<= XLEN-start-len;
	x >>= XLEN-len;
	x <<= dest;

	return x;
}
// --REF-END--

uint_xlen_t sll(uint_xlen_t x, int k)
{
	return x << k;
}

uint_xlen_t srl(uint_xlen_t x, int k)
{
	return x >> k;
}

uint_xlen_t sra(uint_xlen_t x, int k)
{
	if (x >> (XLEN-1))
		return ~(~x >> k);
	return x >> k;
}
