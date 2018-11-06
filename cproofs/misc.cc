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

void clmul_gray1(uint16_t src)
{
	uint16_t gray_encoded = src ^ (src >> 1);
	uint16_t gray_decoded = rv32b::clmul(gray_encoded, 0x0000ffff) >> 15;
	assert(gray_decoded == src);
}

void clmul_gray2(uint32_t src)
{
	uint32_t gray_encoded = src ^ (src >> 1);
	uint32_t gray_decoded = rv32b::clmulh(gray_encoded, -1) ^ gray_encoded;
	assert(gray_decoded == src);
}

void clmul_gray3(uint32_t src)
{
	uint32_t gray_encoded = src ^ (src >> 1);
	uint32_t gray_decoded = rv32b::brev(rv32b::clmul(rv32b::brev(gray_encoded), -1));
	assert(gray_decoded == src);
}

// ---------------------------------------------------------

void clmul_fanout(uint32_t src)
{
	uint32_t result = rv32b::unzip(rv32b::clmulh(src, src));
	uint32_t reference = src >> 16;
	assert(reference == result);
}

// ---------------------------------------------------------

void crc_test()
{
	uint32_t x = 0xffffffff;
	x = rv32b::crc32b(x ^ '1');
	x = rv32b::crc32h(x ^ ('2' | ('3' << 8)));
	x = rv32b::crc32w(x ^ ('4' | ('5' << 8) | ('6' << 16) | ('7' << 24)));
	x = rv32b::crc32h(x ^ ('8' | ('9' << 8)));
	x = ~x;
	assert(x == 0xcbf43926);

	x = 0xffffffff;
	x = rv32b::crc32cb(x ^ '1');
	x = rv32b::crc32ch(x ^ ('2' | ('3' << 8)));
	x = rv32b::crc32cw(x ^ ('4' | ('5' << 8) | ('6' << 16) | ('7' << 24)));
	x = rv32b::crc32ch(x ^ ('8' | ('9' << 8)));
	x = ~x;
	assert(x == 0xe3069283);
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
	}
	crc_test();
	return 0;
}
