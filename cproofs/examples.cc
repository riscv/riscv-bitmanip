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
	a0 = rv32b::shfl(a0, 15);
	a0 = rv32b::shfl(a0, 15);

	a1 = rv32b::sll(a0, 4);
	a0 += a1;

	a1 = rv32b::sll(a0, 8);
	a0 += a1;

	a1 = rv32b::sll(a0, 16);
	a0 += a1;

	return a0;
}

extern "C" void prefix_byte_nibbles_check(uint32_t src)
{
	uint32_t a = prefix_byte_nibbles_reference(src);
	uint32_t b = prefix_byte_nibbles_impl(src);
	assert(a == b);
}

// ---------------------------------------------------------

uint32_t index_byte_nibbles_reference(uint32_t src)
{
	uint32_t a = 0;
	uint32_t k = 0;

	for (int i = 0; i < 8; i++) {
		if ((src >> i) & 1) {
			a |= (i+1) << k;
			k += 4;
		}
	}

	return a;
}

uint32_t index_byte_nibbles_impl(uint32_t src)
{
	uint32_t a0, a1;

	a0 = src & 0xff;
	a0 = rv32b::shfl(a0, 15);
	a0 = rv32b::shfl(a0, 15);

	a0 = rv32b::gorc(a0, 3);

	a1 = a0 & 0x87654321;
	a0 = rv32b::bext(a1, a0);

	return a0;
}

extern "C" void index_byte_nibbles_check(uint32_t src)
{
	uint32_t a = index_byte_nibbles_reference(src);
	uint32_t b = index_byte_nibbles_impl(src);
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

extern "C" void tenth_bit_check(uint32_t src)
{
	uint32_t a = tenth_bit_reference(src);
	uint32_t b = tenth_bit_impl(src);
	assert(a == b);
}

// ---------------------------------------------------------

extern "C" void zip_fanout()
{
	uint64_t x = 0x0000000012345678LL;

	assert(rv64b::shfl(x, 28) == 0x0102030405060708);
	assert(rv64b::shfl(x, 24) == 0x0012003400560078);
	assert(rv64b::shfl(x, 16) == 0x0000123400005678);
}

// ---------------------------------------------------------

int or_bytes_ref(uint64_t x)
{
	int value = 0;
	for (int i = 0; i < 8; i++)
		value |= (x >> (8*i)) & 255;
	return value;
}

int or_bytes_orc(uint64_t x)
{
	return rv64b::gorc(x, -8) & 255;
}

int and_bytes_ref(uint64_t x)
{
	int value = 255;
	for (int i = 0; i < 8; i++)
		value &= (x >> (8*i)) & 255;
	return value;
}

int and_bytes_orc(uint64_t x)
{
	return ~rv64b::gorc(~x, -8) & 255;
}

int xor_bytes_ref(uint64_t x)
{
	int value = 0;
	for (int i = 0; i < 8; i++)
		value ^= (x >> (8*i)) & 255;
	return value;
}

int xor_bytes_clmul(uint64_t x)
{
	uint64_t f = rv64b::gorc(0x80, -8);
	return rv64b::clmulr(x, f) & 255;
}

int xor_bytes_bmat(uint64_t x)
{
	return rv64b::bmatxor(255, x);
}

extern "C" void check_bytes(uint64_t x)
{
	assert(or_bytes_ref(x) == or_bytes_orc(x));
	assert(and_bytes_ref(x) == and_bytes_orc(x));
	assert(xor_bytes_ref(x) == xor_bytes_clmul(x));
	assert(xor_bytes_ref(x) == xor_bytes_bmat(x));
}

// ---------------------------------------------------------

// injecting a 17-bit value from a1 into bits [21:5] of a0
uint32_t inject17_ref(uint32_t a0, uint32_t a1)
{
	uint32_t t0, t1;
	t0 = rv32b::ror(a0, 5);
	t0 = rv32b::srl(t0, 17);
	t1 = rv32b::sll(a1, 15);
	t0 = t0 | t1;
	return rv32b::ror(t0, 10);
}

uint32_t inject17_bfp(uint32_t a0, uint32_t a1)
{
	uint32_t a2;
	a1 = rv32b::sll(a1, 5);
	a2 = rv32b::ror(a0, 22);
	a0 = (15<<8) | 22;
	a0 = rv32b::pack(a2, a0);
	a0 = rv32b::bfp(a1, a0);
	return a0;
}

extern "C" void check_inject17(uint32_t a0, uint32_t a1)
{
	uint32_t result_ref = inject17_ref(a0, a1);
	uint32_t result_bfp = inject17_bfp(a0, a1);
	assert(result_ref == result_bfp);
}
