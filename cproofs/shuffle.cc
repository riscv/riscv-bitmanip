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

uint32_t flip_alt(uint32_t x, uint32_t mask)
{
	x = unzip(x);
	x = bfly(x, mask, 4);
	return x;
}

void omega_flip_invcheck(uint32_t src, uint32_t mask)
{
	uint32_t a = omega(flip(src, mask), mask);
	assert(a == src);

	uint32_t b = flip(omega(src, mask), mask);
	assert(b == src);
}

void flip_alt_check(uint32_t src, uint32_t mask)
{
	uint32_t a = flip(src, mask);
	uint32_t b = flip_alt(src, mask);
	assert(a == b);
}

// ---------------------------------------------------------

uint32_t baseline(uint32_t x, uint32_t mask, int k)
{
	uint32_t y = 0;
	x = bfly(x, mask, 0);

	int num_blocks = 1 << k;
	int block_size = 1 << (5-k);

	for (int block = 0; block < num_blocks; block++)
	{
		int start_offset = block*block_size;
		for (int i = 0; i < block_size/2; i++)
		{
			int i1 = start_offset + 2*i;
			int i2 = start_offset + 2*i + 1;

			int o1 = start_offset + i;
			int o2 = start_offset + block_size/2 + i;

			y |= ((x >> i1) & 1) << o1;
			y |= ((x >> i2) & 1) << o2;
		}
	}

	return y;
}

void baseline_bfly_check(uint32_t x, uint32_t mask)
{
	uint32_t a = baseline(x, mask, 4);
	uint32_t b = bfly(x, mask, 0);
	assert(a == b);
}

void baseline_unzip_check(uint32_t x, uint32_t mask)
{
	uint32_t a = baseline(x, mask, 0);
	uint32_t b = unzip(bfly(x, mask, 0));
	assert(a == b);
}

// ---------------------------------------------------------

void omega_flip_bfly_check(uint32_t x, uint32_t maskA, uint32_t maskB, uint32_t maskC, uint32_t maskD, uint32_t maskE,
		uint32_t maskF, uint32_t maskG, uint32_t maskH, uint32_t maskI, uint32_t maskJ)
{
	uint32_t a = x;
	a = omega(a, maskA);
	a = omega(a, maskB);
	a = omega(a, maskC);
	a = omega(a, maskD);
	a = omega(a, maskE);
	a = flip(a, maskF);
	a = flip(a, maskG);
	a = flip(a, maskH);
	a = flip(a, maskI);
	a = flip(a, maskJ);

	uint32_t b = x;
	b = omega(b, maskA);
	b = omega(b, maskB);
	b = omega(b, maskC);
	b = omega(b, maskD);
	b = bfly(b, maskE ^ maskF, 4);
	b = flip(b, maskG);
	b = flip(b, maskH);
	b = flip(b, maskI);
	b = flip(b, maskJ);

	assert(a == b);
}
