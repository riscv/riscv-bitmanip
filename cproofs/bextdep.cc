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

uint32_t bext32(uint32_t rs1, uint32_t rs2)
{
	uint32_t c = 0, m = 1, mask = rs2;
	for (int iter = 0; mask; iter++) {
		assert(iter != 32);
		if (iter == 32) break;
		uint32_t b = mask & -mask;
		if (rs1 & b)
			c |= m;
		mask -= b;
		m <<= 1;
	}
	return c;
}

uint32_t bdep32(uint32_t rs1, uint32_t rs2)
{
	uint32_t c = 0, m = 1, mask = rs2;
	for (int iter = 0; mask; iter++) {
		assert(iter != 32);
		if (iter == 32) break;
		uint32_t b = mask & -mask;
		if (rs1 & m)
			c |= b;
		mask -= b;
		m <<= 1;
	}
	return c;
}

uint64_t bext64(uint64_t rs1, uint64_t rs2)
{
	uint64_t c = 0, m = 1, mask = rs2;
	for (int iter = 0; mask; iter++) {
		assert(iter != 64);
		if (iter == 64) break;
		uint64_t b = mask & -mask;
		if (rs1 & b)
			c |= m;
		mask -= b;
		m <<= 1;
	}
	return c;
}

uint64_t bdep64(uint64_t rs1, uint64_t rs2)
{
	uint64_t c = 0, m = 1, mask = rs2;
	for (int iter = 0; mask; iter++) {
		assert(iter != 64);
		if (iter == 64) break;
		uint64_t b = mask & -mask;
		if (rs1 & m)
			c |= b;
		mask -= b;
		m <<= 1;
	}
	return c;
}

// ---------------------------------------------------------

void bext32_bext64(uint64_t src, uint64_t mask)
{
	uint32_t src_lo = src;
	uint32_t src_hi = src >> 32;

	uint32_t mask_lo = mask;
	uint32_t mask_hi = mask >> 32;

	uint32_t result_lo = bext32(src_lo, mask_lo);
	uint32_t result_hi = bext32(src_hi, mask_hi);
	uint64_t result = result_lo | (uint64_t(result_hi) << pcnt(mask_lo));

	uint64_t reference = bext64(src, mask);
	assert(result == reference);
}

void bdep32_bdep64(uint64_t src, uint64_t mask)
{
	uint32_t src_lo = src;
	uint32_t src_hi = src >> 32;

	uint32_t mask_lo = mask;
	uint32_t mask_hi = mask >> 32;

	uint32_t result_lo = bdep32(src_lo, mask_lo);

	if (mask_lo == 0) {
		src_hi = src_lo;
	} else {
		int p = pcnt(mask_lo), q = 32 - p;
		src_hi = (src_hi << q) | (src_lo >> p);
	}

	uint32_t result_hi = bdep32(src_hi, mask_hi);
	uint64_t result = result_lo | (uint64_t(result_hi) << 32);

	uint64_t reference = bdep64(src, mask);
	assert(result == reference);
}

// ---------------------------------------------------------

// cbmc is a bit overwhelmed with proving the above functions. So we just
// run some traditional tests instead.
int main()
{
	for (int i = 0; i < 1000; i++) {
		uint64_t src = xorshift64();
		uint64_t mask = xorshift64();
		printf("%016llx %016llx\n", (long long)src, (long long)mask);
		bext32_bext64(src, mask);
		bdep32_bdep64(src, mask);
	}

	printf("passed.\n");
	return 0;
}
