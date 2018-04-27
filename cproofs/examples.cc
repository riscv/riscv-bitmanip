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

uint32_t prefix_byte_nibbles_reference(uint32_t src)
{
	uint32_t a = 0;

	uint32_t k = 0x11111111;
	for (int i = 0; i < 8; i++) {
		if ((src >> i) & 1)
			a += k;
		k = k << 4;
	}

	return a;
}

uint32_t prefix_byte_nibbles_impl(uint32_t src)
{
	uint32_t a0, a1;

	a0 = src & 0xff;
	a0 = rv32b::gzip(a0, 30);
	a0 = rv32b::gzip(a0, 30);

	a1 = rv32b::sll(a0, 4);
	a0 += a1;

	a1 = rv32b::sll(a0, 8);
	a0 += a1;

	a1 = rv32b::sll(a0, 16);
	a0 += a1;

	return a0;
}

void prefix_byte_nibbles_check(uint32_t src)
{
	uint32_t a = prefix_byte_nibbles_reference(src);
	uint32_t b = prefix_byte_nibbles_impl(src);
	assert(a == b);
}

// ---------------------------------------------------------

int tenth_bit_reference(uint32_t src)
{
	int k = 0;
	for (int i = 0; i < 32; i++) {
		if ((src >> i) & 1)
			k++;
		if (k == 10)
			return i;
	}
	return 32;
}

int tenth_bit_impl(uint32_t src)
{
	uint32_t a0 = src;
	uint32_t a1 = 0x00000200;
	a0 = rv32b::bdep(a1, a0);
	a0 = rv32b::ctz(a0);
	return a0;
}

void tenth_bit_check(uint32_t src)
{
	uint32_t a = tenth_bit_reference(src);
	uint32_t b = tenth_bit_impl(src);
	assert(a == b);
}

// ---------------------------------------------------------

void zip_fanout()
{
	uint64_t x = 0x0000000012345678LL;

	uint64_t debug_a = x;
	uint64_t debug_b = rv64b::gzip(x, 56);

	assert(rv64b::gzip(x, 56) == 0x0102030405060708);
	assert(rv64b::gzip(x, 48) == 0x0012003400560078);
	assert(rv64b::gzip(x, 32) == 0x0000123400005678);
}
