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

void identity_check(uint64_t src)
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

void bswap_check(uint64_t src)
{
	uint64_t p = 0x0102040810204080LL;
	uint64_t a = bmatxor(p, src);
	uint64_t b = bmator(p, src);
	uint64_t c = grev(src, 56);

	assert(a == c);
	assert(b == c);
}

void brevb_check(uint64_t src)
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
	x = brev(x);        // GREVI
	x = (x - 1) & ~x;   // ADDI, ANDC
	x = ~x;             // NOT
	x = brev(x);        // GREVI
	return x;
}

uint64_t rfill_brev_orc(uint64_t x)
{
	x = brev(x);        // GREVI
	x = x | ~(x - 1);   // ADDI, ORC
	x = brev(x);        // GREVI
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

void rfill_check(uint64_t x)
{
	uint64_t a = rfill_ref(x);
	uint64_t b = rfill_clz(x);
	uint64_t c = rfill_brev(x);
	uint64_t d = rfill_brev_orc(x);
	uint64_t e = rfill_bmat(x);
	assert(a == b);
	assert(a == c);
	assert(a == d);
	assert(a == e);
}

// ---------------------------------------------------------
