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

void rv32_bmi1_bextr(uint32_t src, uint32_t start, uint32_t len)
{
	if (start >= 32 || len >= 32 || start+len >= 32)
		return;

	uint32_t a = (src >> start) & ((1 << len)-1);

	uint32_t b = start + len;
	b = slo32(0, b);
	b = src & b;
	b = b >> start;

	assert(a == b);
}

void rv32_bmi1_blsi(uint32_t x)
{
	uint32_t a = x & -x;

	uint32_t b = -x;
	b = x & b;

	assert(a == b);
}

void rv32_bmi1_blsmsk(uint32_t x)
{
	uint32_t a = x ^ (x - 1);

	uint32_t b = x - 1;
	b = x ^ b;

	assert(a == b);
}

void rv32_bmi1_blsr(uint32_t x)
{
	uint32_t a = x & (x - 1);

	uint32_t b = x - 1;
	b = x & b;

	assert(a == b);
}

// ---------------------------------------------------------

void rv32_bmi2_bzhi(uint32_t x, uint32_t k)
{
	if (k >= 32)
		return;

	uint32_t a = x & ((1 << k)-1);

	uint32_t b = slo32(0, k);
	b = x & b;

	assert(a == b);
}

// ---------------------------------------------------------

void rv32_tbm_bextr(uint32_t src, uint32_t start, uint32_t len)
{
	if (start >= 32 || len >= 32 || start+len >= 32)
		return;

	uint32_t a = (src >> start) & ((1 << len)-1);

	uint32_t b = src << (32-start-len);
	b = b >> (32-len);

	assert(a == b);
}

void rv32_tbm_blcfill(uint32_t x)
{
	uint32_t a = x & (x + 1);

	uint32_t b = x + 1;
	b = x & b;

	assert(a == b);
}

void rv32_tbm_blci(uint32_t x)
{
	uint32_t a = x | ~(x + 1);

	uint32_t b = x + 1;
	b = ~b;
	b = x | b;

	assert(a == b);
}

void rv32_tbm_blcic(uint32_t x)
{
	uint32_t a = ~x | (x + 1);

	uint32_t b = x + 1;
	b = x & ~b;
	b = ~b;

	assert(a == b);
}

void rv32_tbm_blcmsk(uint32_t x)
{
	uint32_t a = x ^ (x + 1);

	uint32_t b = x + 1;
	b = x ^ b;

	assert(a == b);
}

void rv32_tbm_blcs(uint32_t x)
{
	uint32_t a = x | (x + 1);

	uint32_t b = x + 1;
	b = x | b;

	assert(a == b);
}

void rv32_tbm_blsfill(uint32_t x)
{
	uint32_t a = x | (x - 1);

	uint32_t b = x - 1;
	b = x | b;

	assert(a == b);
}

void rv32_tbm_blsic(uint32_t x)
{
	uint32_t a = ~x | (x - 1);

	uint32_t b = x - 1;
	b = x & ~b;
	b = ~b;

	assert(a == b);
}

void rv32_tbm_t1mskc(uint32_t x)
{
	uint32_t a = ~x | (x + 1);

	uint32_t b = x + 1;
	b = x & ~b;
	b = ~b;

	assert(a == b);
}

void rv32_tbm_t1msk(uint32_t x)
{
	uint32_t a = ~x & (x - 1);

	uint32_t b = x - 1;
	b = b & ~x;

	assert(a == b);
}
