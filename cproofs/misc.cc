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

extern "C" void clmul_gray1(uint16_t src)
{
	uint16_t gray_encoded = src ^ (src >> 1);
	uint16_t gray_decoded = rv32b::clmul(gray_encoded, 0x0000ffff) >> 15;
	assert(gray_decoded == src);
}

extern "C" void clmul_gray2(uint32_t src)
{
	uint32_t gray_encoded = src ^ (src >> 1);
	uint32_t gray_decoded = rv32b::clmulh(gray_encoded, -1) ^ gray_encoded;
	assert(gray_decoded == src);
}

extern "C" void clmul_gray3(uint32_t src)
{
	uint32_t gray_encoded = src ^ (src >> 1);
	uint32_t gray_decoded = rv32b::rev(rv32b::clmul(rv32b::rev(gray_encoded), -1));
	assert(gray_decoded == src);
}

// ---------------------------------------------------------

extern "C" void clmul_fanout(uint32_t src)
{
	uint32_t result = rv32b::unzip(rv32b::clmulh(src, src));
	uint32_t reference = src >> 16;
	assert(reference == result);
}

// ---------------------------------------------------------

extern "C" void crc_test()
{
	uint32_t x = 0xffffffff;
	x = rv32b::crc32_b(x ^ '1');
	x = rv32b::crc32_h(x ^ ('2' | ('3' << 8)));
	x = rv32b::crc32_w(x ^ ('4' | ('5' << 8) | ('6' << 16) | ('7' << 24)));
	x = rv32b::crc32_h(x ^ ('8' | ('9' << 8)));
	x = ~x;
	assert(x == 0xcbf43926);

	x = 0xffffffff;
	x = rv32b::crc32c_b(x ^ '1');
	x = rv32b::crc32c_h(x ^ ('2' | ('3' << 8)));
	x = rv32b::crc32c_w(x ^ ('4' | ('5' << 8) | ('6' << 16) | ('7' << 24)));
	x = rv32b::crc32c_h(x ^ ('8' | ('9' << 8)));
	x = ~x;
	assert(x == 0xe3069283);
}

// ---------------------------------------------------------

extern "C" void crc_equiv_h_bb(uint64_t x)
{
	assert(rv64b::crc32_h(x) == rv64b::crc32_b(rv64b::crc32_b(x)));
}

extern "C" void crc_equiv_w_hh(uint64_t x)
{
	assert(rv64b::crc32_w(x) == rv64b::crc32_h(rv64b::crc32_h(x)));
}

extern "C" void crc_equiv_d_ww(uint64_t x)
{
	assert(rv64b::crc32_d(x) == rv64b::crc32_w(rv64b::crc32_w(x)));
}

// ---------------------------------------------------------

extern "C" void pack_test(uint64_t x1, uint64_t x2, uint64_t x3)
{
	uint64_t rd, ref;

	rd = int32_t(0xffff0 << 12);
	rd = rv64b::pack(rd, rd);
	ref = 0xffff0000ffff0000UL;
	assert(rd == ref);

	rd = rv64b::pack(x1, x3);
	rd = int32_t(rv64b::rol(rd, x2));
	ref = int32_t(rv32b::fsl(x1, x2, x3));
	assert(rd == ref);

	rd = rv64b::pack(x1, 0);
	ref = (x1 << 32) >> 32;
	assert(rd == ref);
}

// ---------------------------------------------------------

extern "C" void min_max_test(uint32_t u1, uint32_t u2)
{
	int32_t s1 = u1, s2 = u2;

	if (s1 >= s2) assert(u1 == rv32b::max(u1, u2));
	if (s1 <= s2) assert(u2 == rv32b::max(u1, u2));

	if (s1 >= s2) assert(u2 == rv32b::min(u1, u2));
	if (s1 <= s2) assert(u1 == rv32b::min(u1, u2));

	if (u1 >= u2) assert(u1 == rv32b::maxu(u1, u2));
	if (u1 <= u2) assert(u2 == rv32b::maxu(u1, u2));

	if (u1 >= u2) assert(u2 == rv32b::minu(u1, u2));
	if (u1 <= u2) assert(u1 == rv32b::minu(u1, u2));
}

// ---------------------------------------------------------

extern "C" uint64_t reference_vectadd(uint64_t a0, uint64_t a1)
{
	uint64_t ret = 0;
	for (int i = 0; i < 8; i++)
	{
		int a = a0 >> (8*i);
		int b = a1 >> (8*i);
		uint64_t c = (a+b) & 255;
		ret |= c << (8*i);
	}
	return ret;
}

extern "C" uint64_t bitmanip_vectadd(uint64_t a0, uint64_t a1)
{
	uint64_t a2, a3;
	a2 = rv64b::orc8(0x80);
	a3 = a0 ^ a1;
	a3 = a3 & a2;
	a0 = a0 & ~a2;
	a1 = a1 & ~a2;
	a0 = a0 + a1;
	a0 = a0 ^ a3;
	return a0;
}

extern "C" void check_vectadd(uint32_t a0, uint32_t a1)
{
	uint64_t reference_y = reference_vectadd(a0, a1);
	uint64_t bitmanip_y = bitmanip_vectadd(a0, a1);
	assert(reference_y == bitmanip_y);
}

// ---------------------------------------------------------

int main()
{
	for (int i = 0; i < 1000; i++) {
		uint32_t src = xorshift32();
		clmul_gray1(src);
		clmul_gray2(src);
		clmul_gray3(src);
		clmul_fanout(src);

		uint32_t x = xorshift64();
		crc_equiv_h_bb(x);
		crc_equiv_w_hh(x);
		crc_equiv_d_ww(x);
	}
	crc_test();
	return 0;
}
