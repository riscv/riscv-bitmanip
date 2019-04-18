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

void test_fsl(uint64_t A, int B)
{
	uint32_t A_lo = A, A_hi = A >> 32;
	uint32_t ref = rv64b::rol(A, B) >> 32;
	uint32_t res = rv32b::fsl(A_hi, B, A_lo);
	assert(ref == res);
}

void test_fsr(uint64_t A, int B)
{
	uint32_t A_lo = A, A_hi = A >> 32;
	uint32_t ref = rv64b::ror(A, B);
	uint32_t res = rv32b::fsr(A_lo, B, A_hi);
	assert(ref == res);
}

void fsl_via_fsr(uint32_t A, uint32_t B, uint32_t C)
{
	uint32_t ref = rv32b::fsl(A, +B, C);
	uint32_t res = rv32b::fsr(A, -B, C);
	assert(ref == res);
}

uint32_t shift32(uint32_t x, int shamt, uint32_t y)
{
	return rv32b::fsr(x, shamt, y);
}

void shift32_ids(uint32_t x, int shamt, uint32_t y)
{
	uint32_t sx = int32_t(x) >> 31;
	int sh6 = shamt & 63;
	int sh5 = shamt & 31;

	assert(rv32b::sll(x, sh5) == shift32(x, -sh5,  0));
	assert(rv32b::srl(x, sh5) == shift32(x,  sh5,  0));
	assert(rv32b::sra(x, sh5) == shift32(x,  sh5, sx));
	assert(rv32b::slo(x, sh5) == shift32(x, -sh5, ~0));
	assert(rv32b::sro(x, sh5) == shift32(x,  sh5, ~0));
	assert(rv32b::rol(x, sh5) == shift32(x, -sh5,  x));
	assert(rv32b::ror(x, sh5) == shift32(x,  sh5,  x));

	assert(rv32b::fsl(x, sh6, y) == shift32(x, -sh6, y));
	assert(rv32b::fsr(x, sh6, y) == shift32(x,  sh6, y));
}

uint64_t shift64(uint64_t x, int shamt, uint64_t y)
{
	return rv64b::fsr(x, shamt, y);
}

void shift64_ids(uint64_t x, int shamt, uint64_t y)
{
	uint64_t sx = int64_t(x) >> 63;
	int sh7 = shamt & 127;
	int sh6 = shamt & 63;

	assert(rv64b::sll(x, sh6) == shift64(x, -sh6,  0));
	assert(rv64b::srl(x, sh6) == shift64(x,  sh6,  0));
	assert(rv64b::sra(x, sh6) == shift64(x,  sh6, sx));
	assert(rv64b::slo(x, sh6) == shift64(x, -sh6, ~0));
	assert(rv64b::sro(x, sh6) == shift64(x,  sh6, ~0));
	assert(rv64b::rol(x, sh6) == shift64(x, -sh6,  x));
	assert(rv64b::ror(x, sh6) == shift64(x,  sh6,  x));

	assert(rv64b::fsl(x, sh7, y) == shift64(x, -sh7, y));
	assert(rv64b::fsr(x, sh7, y) == shift64(x,  sh7, y));
}

uint32_t shift64w(uint64_t x, int shamt, uint64_t y)
{
	// X = XH:XL, Y = YH:YL
	x <<= 32, x >>= 32;
	y = (x |= y << 32);
	// X = YL:XL, Y = YL:XL

	return rv64b::fsr(x, shamt, y);
}

void shift64w_ids(uint64_t x, int shamt, uint64_t y)
{
	uint64_t sx = int64_t(x << 32) >> 63;
	int sh6 = shamt & 63;
	int sh5 = shamt & 31;

	assert(rv32b::sll(x, sh5) == shift64w(x, -sh5,  0));
	assert(rv32b::srl(x, sh5) == shift64w(x,  sh5,  0));

	assert(rv32b::sra(x, sh5) == shift64w(x,  sh5, sx));
	assert(rv32b::slo(x, sh5) == shift64w(x, -sh5, ~0));
	assert(rv32b::sro(x, sh5) == shift64w(x,  sh5, ~0));
	assert(rv32b::rol(x, sh5) == shift64w(x, -sh5,  x));
	assert(rv32b::ror(x, sh5) == shift64w(x,  sh5,  x));

	assert(rv32b::fsl(x, sh6, y) == shift64w(x, -sh6, y));
	assert(rv32b::fsr(x, sh6, y) == shift64w(x,  sh6, y));
}
