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

void bext32_bext64(uint64_t src, uint64_t mask)
{
	uint32_t src_lo = src;
	uint32_t src_hi = src >> 32;

	uint32_t mask_lo = mask;
	uint32_t mask_hi = mask >> 32;

	uint32_t result_lo = rv32b::bext(src_lo, mask_lo);
	uint32_t result_hi = rv32b::bext(src_hi, mask_hi);
	uint64_t result = result_lo | (uint64_t(result_hi) << rv32b::pcnt(mask_lo));

	uint64_t reference = rv64b::bext(src, mask);
	assert(result == reference);
}

void bdep32_bdep64(uint64_t src, uint64_t mask)
{
	uint32_t src_lo = src;
	uint32_t src_hi = src >> 32;

	uint32_t mask_lo = mask;
	uint32_t mask_hi = mask >> 32;

	uint32_t result_lo = rv32b::bdep(src_lo, mask_lo);

	int p = rv32b::pcnt(mask_lo), q = 32 - p;
	src_hi = (uint64_t(src_hi) << q) | (uint64_t(src_lo) >> p);

	uint32_t result_hi = rv32b::bdep(src_hi, mask_hi);
	uint64_t result = result_lo | (uint64_t(result_hi) << 32);

	uint64_t reference = rv64b::bdep(src, mask);
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
		// printf("%016llx %016llx\n", (long long)src, (long long)mask);
		bext32_bext64(src, mask);
		bext32_bext64(src, mask & 0xffffffff00000000LL);
		bdep32_bdep64(src, mask);
		bdep32_bdep64(src, mask & 0xffffffff00000000LL);
	}
	for (int i = 0; i < 64; i++)
	for (int j = 0; j < 64; j++) {
		uint64_t src = 1LL << i;
		uint64_t mask = 1LL << j;
		// printf("%016llx %016llx\n", (long long)src, (long long)mask);
		bext32_bext64(src, mask);
		bdep32_bdep64(src, mask);
	}
	printf("passed.\n");
	return 0;
}
