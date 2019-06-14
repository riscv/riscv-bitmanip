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
using namespace rv64b;

// ---------------------------------------------------------

extern "C" extern "C" void identity_check(uint64_t src)
{
	uint64_t p = 0x8040201008040201LL;
	uint64_t q = bmatflip(p);
	uint64_t a = bmatxor(src, p);
	uint64_t b = bmatxor(p, src);
	uint64_t c = bmator(src, p);
	uint64_t d = bmator(p, src);

	assert(a == src);
	assert(b == src);
	assert(c == src);
	assert(d == src);
	assert(p == q);
}

extern "C" extern "C" void bswap_check(uint64_t src)
{
	uint64_t p = 0x0102040810204080LL;
	uint64_t a = bmatxor(p, src);
	uint64_t b = bmator(p, src);
	uint64_t c = grev(src, 56);

	assert(a == c);
	assert(b == c);
}

extern "C" extern "C" void brevb_check(uint64_t src)
{
	uint64_t p = 0x0102040810204080LL;
	uint64_t a = bmatxor(src, p);
	uint64_t b = bmator(src, p);
	uint64_t c = grev(src, 7);

	assert(a == c);
	assert(b == c);
}

// ---------------------------------------------------------

uint64_t rfill_ref(uint64_t x)
{
	x |= x >> 1;   // SRLI, OR
	x |= x >> 2;   // SRLI, OR
	x |= x >> 4;   // SRLI, OR
	x |= x >> 8;   // SRLI, OR
	x |= x >> 16;  // SRLI, OR
	x |= x >> 32;  // SRLI, OR
	return x;
}

uint64_t rfill_clz(uint64_t x)
{
	uint64_t t;
	t = clz(x);         // CLZ
	x = (!x)-1;         // SLTIU, ADDI
	x = x >> (t & 63);  // SRL
	return x;
}

uint64_t rfill_brev(uint64_t x)
{
	x = rev(x);        // GREVI
	x = x | ~(x - 1);  // ADDI, ORN
	x = rev(x);        // GREVI
	return x;
}

uint64_t rfill_bmat(uint64_t x)
{
	uint64_t m0, m1, m2, t;

	m0 = 0xFF7F3F1F0F070301LL;  // LD
	m1 = bmatflip(m0 << 8);     // SLLI, BMATFLIP
	m2 = -1LL;                  // ADDI

	t = bmator(x, m0);          // BMATOR
	x = bmator(x, m2);          // BMATOR
	x = bmator(m1, x);          // BMATOR
	x |= t;                     // OR

	return x;
}

extern "C" void rfill_check(uint64_t x)
{
	uint64_t a = rfill_ref(x);
	uint64_t b = rfill_clz(x);
	uint64_t c = rfill_brev(x);
	uint64_t d = rfill_bmat(x);
	assert(a == b);
	assert(a == c);
	assert(a == d);
}

extern "C" void round_pow2_check(uint64_t x)
{
	uint64_t ref = rfill_ref(x-1)+1;
	uint32_t t;

	t = clz(x-1);     // ADDI, CLZ
	x = ror(!!x, t);  // SLTU, ROR

	if (!t && x) return;
	assert(ref == x);
}

// ---------------------------------------------------------

extern "C" void strlen_check(uint64_t x)
{
	unsigned char b0 = x;
	unsigned char b1 = x >> 8;
	unsigned char b2 = x >> 16;
	unsigned char b3 = x >> 24;
	unsigned char b4 = x >> 32;
	unsigned char b5 = x >> 40;
	unsigned char b6 = x >> 48;
	unsigned char b7 = x >> 56;
	int cnt = !b0 ? 0 : !b1 ? 1 : !b2 ? 2 : !b3 ? 3 : !b4 ? 4 : !b5 ? 5 : !b6 ? 6 : !b7 ? 7 : 8;

	uint64_t m = 0x0101010101010101LL;
	int cnt2 = ctz(~bmatflip(bmator(x, m)));

	// 'm' above is just bmatflip(255). So this also works:
	int cnt3 = ctz(~bmator(255, bmatflip(x)));

	assert(cnt == cnt2);
	assert(cnt == cnt3);
}

// ---------------------------------------------------------
