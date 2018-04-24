/*
 *  Copyright (C) 2018  Clifford Wolf <clifford@clifford.at>
 *
 *  Permission to use, copy, modify, and/or distribute this software for any
 *  purpose with or without fee is hereby granted, provided that the above
 *  copyright notice and this permission notice appear in all copies.
 *
 *  THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
 *  WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
 *  MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
 *  ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
 *  WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
 *  ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
 *  OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
 *
 */

#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>
#include <assert.h>

#define XLEN 32
#define LOG2_XLEN 5
typedef uint32_t uint_xlen_t;
typedef int32_t int_xlen_t;

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

#if XLEN == 32
#  define grev grev32
#else
#  define grev grev64
#endif

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

#if XLEN == 32
#  define gzip gzip32
#else
#  define gzip gzip64
#endif

// --REF-BEGIN-- zip
uint_xlen_t bitmove(uint_xlen_t x, int p, int q)
{
	return ((x >> p) & 1) << q;
}

uint_xlen_t zip(uint_xlen_t rs1)
{
	uint_xlen_t x = 0;
	for (int i = 0; i < XLEN/2; i++) {
		x |= bitmove(rs1, i,          2*i);
		x |= bitmove(rs1, i + XLEN/2, 2*i + 1);
	}
	return x;
}

uint_xlen_t unzip(uint_xlen_t rs1)
{
	uint_xlen_t x = 0;
	for (int i = 0; i < XLEN/2; i++) {
		x |= bitmove(rs1, 2*i,     i);
		x |= bitmove(rs1, 2*i + 1, i + XLEN/2);
	}
	return x;
}
// --REF-END--

// --REF-BEGIN-- zipN
uint_xlen_t zipN(uint_xlen_t rs1, int N)
{
	uint_xlen_t x = 0;
	for (int k = 0; k < XLEN/N; k++) {
		for (int i = 0; i < N/2; i++) {
			x |= bitmove(rs1, N*k + i,       N*k + 2*i);
			x |= bitmove(rs1, N*k + i + N/2, N*k + 2*i + 1);
		}
	}
	return x;
}

uint_xlen_t unzipN(uint_xlen_t rs1, int N)
{
	uint_xlen_t x = 0;
	for (int k = 0; k < XLEN/N; k++) {
		for (int i = 0; i < N/2; i++) {
			x |= bitmove(rs1, N*k + 2*i,     N*k + i);
			x |= bitmove(rs1, N*k + 2*i + 1, N*k + i + N/2);
		}
	}
	return x;
}
// --REF-END--

// --REF-BEGIN-- bfly
uint_xlen_t swapbits(uint_xlen_t x, int p, int q)
{
	assert(p < q);
	x = x ^ ((x & (1 << p)) << (q - p));
	x = x ^ ((x & (1 << q)) >> (q - p));
	x = x ^ ((x & (1 << p)) << (q - p));
	return x;
}

uint_xlen_t bfly(uint_xlen_t rs1, uint_xlen_t mask, int N)
{
	uint_xlen_t x = rs1;
	int a = 1 << N, b = 2 * a;
	for (int i = 0; i < XLEN / 2; i++) {
		int p = b * (i / a) + i % a, q = p + a;
		if ((mask >> i) & 1)
			x = swapbits(x, p, q);
	}
	return x;
}
// --REF-END--

// --REF-BEGIN-- shuffle
uint_xlen_t shuffle(uint_xlen_t rs1, uint_xlen_t rs2)
{
	uint_xlen_t mask = rs2 >> 16;
	int mode = (rs2 >> 12) & 15;
	int cmd = rs2 & 0xfff;

	if (cmd != 0 || mode > 7 + LOG2_XLEN)
		return 0;

	switch (mode)
	{
		case  0: return bfly(zip (rs1    ), mask, 0);
		case  1: return bfly(zipN(rs1,  4), mask, 0);
		case  2: return bfly(zipN(rs1,  8), mask, 0);
		case  3: return bfly(zipN(rs1, 16), mask, 0);

		case  4: return unzip (bfly(rs1, mask, 0)    );
		case  5: return unzipN(bfly(rs1, mask, 0),  4);
		case  6: return unzipN(bfly(rs1, mask, 0),  8);
		case  7: return unzipN(bfly(rs1, mask, 0), 16);

		default: return bfly(rs1, mask, mode & 7);
	}
}
// --REF-END--

// --REF-BEGIN-- bxchg
uint_xlen_t bxchg(uint_xlen_t rs1, uint_xlen_t rs2)
{
	uint_xlen_t upper = rs1 >> (XLEN/2);
	upper |= upper << (XLEN/2);

	uint_xlen_t lower = rs1 << (XLEN/2);
	lower |= lower >> (XLEN/2);

	return (upper & rs2) | (lower & ~rs2);
}
// --REF-END--


uint_xlen_t omega(uint_xlen_t x, uint_xlen_t mask)
{
	x = zip(x);
	x = bfly(x, mask, 0);
	return x;
}

uint_xlen_t flip(uint_xlen_t x, uint_xlen_t mask)
{
	x = bfly(x, mask, 0);
	x = unzip(x);
	return x;
}

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

uint32_t xs32(uint32_t x)
{
	x ^= x << 13;
	x ^= x >> 17;
	x ^= x << 5;
	return x;
}

uint32_t xorshift32()
{
	static uint32_t x32 = 123456789;
	x32 = xs32(x32);
	return x32;
}

uint64_t xorshift64()
{
	uint64_t r = xorshift32();
	return (r << 32) | xorshift32();
}

uint32_t bitmove32(uint32_t x, int p, int q)
{
	return ((x >> p) & 1) << q;
}

uint64_t bitmove64(uint64_t x, int p, int q)
{
	return ((x >> p) & 1) << q;
}
