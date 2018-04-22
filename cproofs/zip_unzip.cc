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

#include "common.h"

// ---------------------------------------------------------

void zip_unzip_invcheck(uint32_t src)
{
	uint32_t a = zip(unzip(src));
	assert(a == src);

	uint32_t b = unzip(zip(src));
	assert(b == src);
}

void zip4_unzip_eqcheck(uint32_t src)
{
	uint32_t a = zip(zip(zip(zip(src))));
	uint32_t b = unzip(src);
	assert(a == b);
}

void zip_unzip4_eqcheck(uint32_t src)
{
	uint32_t a = zip(src);
	uint32_t b = unzip(unzip(unzip(unzip(src))));
	assert(a == b);
}

// ---------------------------------------------------------

void zip_unzip_invcheck_N32(uint32_t src)
{
	uint32_t a = zipN(unzipN(src, 32), 32);
	assert(a == src);

	uint32_t b = unzipN(zipN(src, 32), 32);
	assert(b == src);
}

void zip4_unzip_eqcheck_N32(uint32_t src)
{
	uint32_t a = zipN(zipN(zipN(zipN(src, 32), 32), 32), 32);
	uint32_t b = unzipN(src, 32);
	assert(a == b);
}

void zip_unzip4_eqcheck_N32(uint32_t src)
{
	uint32_t a = zipN(src, 32);
	uint32_t b = unzipN(unzipN(unzipN(unzipN(src, 32), 32), 32), 32);
	assert(a == b);
}

// ---------------------------------------------------------

void zip_unzip_invcheck_N16(uint32_t src)
{
	uint32_t a = zipN(unzipN(src, 16), 16);
	assert(a == src);

	uint32_t b = unzipN(zipN(src, 16), 16);
	assert(b == src);
}

void zip3_unzip_eqcheck_N16(uint32_t src)
{
	uint32_t a = zipN(zipN(zipN(src, 16), 16), 16);
	uint32_t b = unzipN(src, 16);
	assert(a == b);
}

void zip_unzip3_eqcheck_N16(uint32_t src)
{
	uint32_t a = zipN(src, 16);
	uint32_t b = unzipN(unzipN(unzipN(src, 16), 16), 16);
	assert(a == b);
}

// ---------------------------------------------------------

void zip_unzip_invcheck_N8(uint32_t src)
{
	uint32_t a = zipN(unzipN(src, 8), 8);
	assert(a == src);

	uint32_t b = unzipN(zipN(src, 8), 8);
	assert(b == src);
}

void zip2_unzip_eqcheck_N8(uint32_t src)
{
	uint32_t a = zipN(zipN(src, 8), 8);
	uint32_t b = unzipN(src, 8);
	assert(a == b);
}

void zip_unzip2_eqcheck_N8(uint32_t src)
{
	uint32_t a = zipN(src, 8);
	uint32_t b = unzipN(unzipN(src, 8), 8);
	assert(a == b);
}

// ---------------------------------------------------------

void zip_unzip_invcheck_N4(uint32_t src)
{
	uint32_t a = zipN(unzipN(src, 4), 4);
	assert(a == src);

	uint32_t b = unzipN(zipN(src, 4), 4);
	assert(b == src);
}

void zip_unzip_eqcheck_N4(uint32_t src)
{
	uint32_t a = zipN(src, 4);
	uint32_t b = unzipN(src, 4);
	assert(a == b);
}

// ---------------------------------------------------------

void zip_bfly_0_check(uint32_t src, uint32_t mask)
{
	uint32_t a = src;
	uint32_t b = bfly(a, mask, 0);

	uint32_t m = mask;

	a = unzip(a);
	a = bfly(a, m, 4);
	a = zip(a);

	assert(a == b);
}

void zip_bfly_1_check(uint32_t src, uint32_t mask)
{
	uint32_t a = src;
	uint32_t b = bfly(a, mask, 1);

	uint32_t m = mask;
	m = unzipN(m, 16);

	a = unzip(a);
	a = unzip(a);
	a = bfly(a, m, 4);
	a = zip(a);
	a = zip(a);

	assert(a == b);
}

void zip_bfly_2_check(uint32_t src, uint32_t mask)
{
	uint32_t a = src;
	uint32_t b = bfly(a, mask, 2);

	uint32_t m = mask;
	m = unzipN(m, 16);
	m = unzipN(m, 16);

	a = zip(a);
	a = zip(a);
	a = bfly(a, m, 4);
	a = unzip(a);
	a = unzip(a);

	assert(a == b);
}

void zip_bfly_3_check(uint32_t src, uint32_t mask)
{
	uint32_t a = src;
	uint32_t b = bfly(a, mask, 3);

	uint32_t m = mask;
	m = zipN(m, 16);

	a = zip(a);
	a = bfly(a, m, 4);
	a = unzip(a);

	assert(a == b);
}

// ---------------------------------------------------------

#if 0
uint_xlen_t bitsmove(uint_xlen_t x, int p, int q, int n)
{
	return ((x >> p) & ((1 << n)-1)) << q;
}

uint32_t blockzip_2(uint32_t rs1)
{
	uint_xlen_t x = 0;
	for (int i = 0; i < XLEN/4; i++) {
		x |= bitsmove(rs1, 2*i,          4*i,     2);
		x |= bitsmove(rs1, 2*i + XLEN/2, 4*i + 2, 2);
	}
	return x;
}

uint32_t blockzip_4(uint32_t rs1)
{
	uint_xlen_t x = 0;
	for (int i = 0; i < XLEN/8; i++) {
		x |= bitsmove(rs1, 4*i,          8*i,     4);
		x |= bitsmove(rs1, 4*i + XLEN/2, 8*i + 4, 4);
	}
	return x;
}

uint32_t blockzip_8(uint32_t rs1)
{
	uint_xlen_t x = 0;
	for (int i = 0; i < XLEN/16; i++) {
		x |= bitsmove(rs1, 8*i,          16*i,     8);
		x |= bitsmove(rs1, 8*i + XLEN/2, 16*i + 8, 8);
	}
	return x;
}

uint32_t blockzip_16(uint32_t rs1)
{
	uint_xlen_t x = 0;
	for (int i = 0; i < XLEN/32; i++) {
		x |= bitsmove(rs1, 16*i,          32*i,      16);
		x |= bitsmove(rs1, 16*i + XLEN/2, 32*i + 16, 16);
	}
	return x;
}

void blockzip_2_check(uint32_t src)
{
	uint32_t a = src;
	a = blockzip_2(a);

	uint32_t b = src;
	b = unzipN(b, 4);
	b = unzipN(b, 8);

	printf("== 0x%08x 0x%08x 0x%08x%s\n", src, a, b, a == b ? " ok" : "");
	// assert(a == b);
}

int main()
{
	for (int i = 0; i < 32; i++)
		blockzip_2_check(1 << i);
	return 0;
}
#endif
