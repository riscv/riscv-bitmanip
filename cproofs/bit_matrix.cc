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

	uint64_t m = 0x0101010101010101L;
	int cnt2 = ctz(~bmatflip(bmator(x, m)));

	// 'm' above is just bmatflip(255). So this also works:
	int cnt3 = ctz(~bmator(255, bmatflip(x)));

	// less elegant, but more compressed instructions:
	int cnt4 = ctz(~bmator(x, -1L)) >> 3;

	int64_t t = x;
	t = t | grev(t, 1);
	t = t | grev(t, 2);
	t = t | grev(t, 4);
	int cnt5 = ctz(~t) >> 3;

	assert(cnt == cnt2);
	assert(cnt == cnt3);
	assert(cnt == cnt4);
	assert(cnt == cnt5);

	if (bmator(x, -1L) == -1L) {
		assert(t == -1L);
		assert(cnt == 8);
	} else {
		assert(t != -1L);
		assert(cnt != 8);
	}
}

// ---------------------------------------------------------

void reference_conv8x8(const uint64_t x[8], uint64_t y[8])
{
	for (int i = 0; i < 8; i++) {
		uint64_t temp = 0;
		for (int j = 0; j < 8; j++)
			temp |= ((x[j] >> (8*i)) & 255) << (8*j);
		y[i] = temp;
	}
}

void bitmanip_conv8x8(const uint64_t x[8], uint64_t y[8])
{
	uint64_t x0_x1_31_00 = rv64b::pack(x[0], x[1]);
	uint64_t x2_x3_31_00 = rv64b::pack(x[2], x[3]);
	uint64_t x4_x5_31_00 = rv64b::pack(x[4], x[5]);
	uint64_t x6_x7_31_00 = rv64b::pack(x[6], x[7]);

	uint64_t x0_x1_63_32 = rv64b::packu(x[0], x[1]);
	uint64_t x2_x3_63_32 = rv64b::packu(x[2], x[3]);
	uint64_t x4_x5_63_32 = rv64b::packu(x[4], x[5]);
	uint64_t x6_x7_63_32 = rv64b::packu(x[6], x[7]);

	uint64_t x0_x1_31_00_z = rv64b::unzip16(x0_x1_31_00);
	uint64_t x2_x3_31_00_z = rv64b::unzip16(x2_x3_31_00);
	uint64_t x4_x5_31_00_z = rv64b::unzip16(x4_x5_31_00);
	uint64_t x6_x7_31_00_z = rv64b::unzip16(x6_x7_31_00);

	uint64_t x0_x1_63_32_z = rv64b::unzip16(x0_x1_63_32);
	uint64_t x2_x3_63_32_z = rv64b::unzip16(x2_x3_63_32);
	uint64_t x4_x5_63_32_z = rv64b::unzip16(x4_x5_63_32);
	uint64_t x6_x7_63_32_z = rv64b::unzip16(x6_x7_63_32);

	uint64_t x0_x1_x2_x3_15_00 = rv64b::pack (x0_x1_31_00_z, x2_x3_31_00_z);
	uint64_t x4_x5_x6_x7_15_00 = rv64b::pack (x4_x5_31_00_z, x6_x7_31_00_z);
	uint64_t x0_x1_x2_x3_31_16 = rv64b::packu(x0_x1_31_00_z, x2_x3_31_00_z);
	uint64_t x4_x5_x6_x7_31_16 = rv64b::packu(x4_x5_31_00_z, x6_x7_31_00_z);

	uint64_t x0_x1_x2_x3_47_32 = rv64b::pack (x0_x1_63_32_z, x2_x3_63_32_z);
	uint64_t x4_x5_x6_x7_47_32 = rv64b::pack (x4_x5_63_32_z, x6_x7_63_32_z);
	uint64_t x0_x1_x2_x3_63_48 = rv64b::packu(x0_x1_63_32_z, x2_x3_63_32_z);
	uint64_t x4_x5_x6_x7_63_48 = rv64b::packu(x4_x5_63_32_z, x6_x7_63_32_z);

	uint64_t x0_x1_x2_x3_15_00_z = rv64b::unzip8(x0_x1_x2_x3_15_00);
	uint64_t x4_x5_x6_x7_15_00_z = rv64b::unzip8(x4_x5_x6_x7_15_00);
	uint64_t x0_x1_x2_x3_31_16_z = rv64b::unzip8(x0_x1_x2_x3_31_16);
	uint64_t x4_x5_x6_x7_31_16_z = rv64b::unzip8(x4_x5_x6_x7_31_16);

	uint64_t x0_x1_x2_x3_47_32_z = rv64b::unzip8(x0_x1_x2_x3_47_32);
	uint64_t x4_x5_x6_x7_47_32_z = rv64b::unzip8(x4_x5_x6_x7_47_32);
	uint64_t x0_x1_x2_x3_63_48_z = rv64b::unzip8(x0_x1_x2_x3_63_48);
	uint64_t x4_x5_x6_x7_63_48_z = rv64b::unzip8(x4_x5_x6_x7_63_48);

	y[0] = rv64b::pack (x0_x1_x2_x3_15_00_z, x4_x5_x6_x7_15_00_z);
	y[1] = rv64b::packu(x0_x1_x2_x3_15_00_z, x4_x5_x6_x7_15_00_z);
	y[2] = rv64b::pack (x0_x1_x2_x3_31_16_z, x4_x5_x6_x7_31_16_z);
	y[3] = rv64b::packu(x0_x1_x2_x3_31_16_z, x4_x5_x6_x7_31_16_z);

	y[4] = rv64b::pack (x0_x1_x2_x3_47_32_z, x4_x5_x6_x7_47_32_z);
	y[5] = rv64b::packu(x0_x1_x2_x3_47_32_z, x4_x5_x6_x7_47_32_z);
	y[6] = rv64b::pack (x0_x1_x2_x3_63_48_z, x4_x5_x6_x7_63_48_z);
	y[7] = rv64b::packu(x0_x1_x2_x3_63_48_z, x4_x5_x6_x7_63_48_z);
}

extern "C" void conv8x8_check(uint64_t x0, uint64_t x1, uint64_t x2, uint64_t x3,
		uint64_t x4, uint64_t x5, uint64_t x6, uint64_t x7)
{
	const uint64_t x[8] = {x0, x1, x2, x3, x4, x5, x6, x7};

	uint64_t reference_y[8], bitmanip_y[8];
	reference_conv8x8(x, reference_y);
	bitmanip_conv8x8(x, bitmanip_y);

	for (int i = 0; i < 8; i++)
		assert(reference_y[i] == bitmanip_y[i]);

	uint64_t bitmanip_x[8];
	bitmanip_conv8x8(bitmanip_y, bitmanip_x);

	for (int i = 0; i < 8; i++)
		assert(x[i] == bitmanip_x[i]);
}
