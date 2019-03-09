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

void shift_ids(uint32_t x, int shamt)
{
	uint32_t sext_x = int32_t(x) >> 31;
	shamt &= 31;

	assert(rv32b::sll(x, shamt) == rv32b::fsl(x, shamt, 0));
	assert(rv32b::srl(x, shamt) == rv32b::fsr(x, shamt, 0));
	assert(rv32b::sra(x, shamt) == rv32b::fsr(x, shamt, sext_x));
	assert(rv32b::slo(x, shamt) == rv32b::fsl(x, shamt, ~0));
	assert(rv32b::sro(x, shamt) == rv32b::fsr(x, shamt, ~0));
	assert(rv32b::ror(x, shamt) == rv32b::fsr(x, shamt, x));
	assert(rv32b::rol(x, shamt) == rv32b::fsl(x, shamt, x));
}
