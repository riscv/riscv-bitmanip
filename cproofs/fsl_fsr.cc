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
#include <stdlib.h>

extern "C" void test_fsl(uint64_t A, int B)
{
	uint32_t A_lo = A, A_hi = A >> 32;
	uint32_t ref = rv64b::rol(A, B) >> 32;
	uint32_t res = rv32b::fsl(A_hi, B, A_lo);
	assert(ref == res);
}

extern "C" void test_fsr(uint64_t A, int B)
{
	uint32_t A_lo = A, A_hi = A >> 32;
	uint32_t ref = rv64b::ror(A, B);
	uint32_t res = rv32b::fsr(A_lo, B, A_hi);
	assert(ref == res);
}

extern "C" void fsl_via_fsr(uint32_t A, uint32_t B, uint32_t C)
{
	uint32_t ref = rv32b::fsl(A, +B, C);
	uint32_t res = rv32b::fsr(A, -B, C);
	assert(ref == res);
}

extern "C" void fsl_imm(uint32_t x, int shamt, uint32_t y)
{
	uint32_t ref = rv32b::fsl(x, shamt, y);
	int sh6 = shamt & 63;
	if (sh6 >= 32) {
		uint32_t t = x;
		x = y, y = t;
		sh6 -= 32;
	}
	assert(ref == rv32b::fsl(x, sh6, y));
}

uint32_t shift32(uint32_t x, int shamt, uint32_t y)
{
	return rv32b::fsr(x, shamt, y);
}

extern "C" void shift32_ids(uint32_t x, int shamt, uint32_t y)
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

extern "C" void shift64_ids(uint64_t x, int shamt, uint64_t y)
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

extern "C" void shift64w_ids(uint64_t x, int shamt, uint64_t y)
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

// ------------------------------------------------------------------

void bigint_rol(uint32_t data[], int n, int shamt)
{
	if (n <= 0)
		return;

	uint32_t buffer = data[n-1];
	for (int i = n-1; i > 0; i--)
		data[i] = rv32b::fsl(data[i], shamt, data[i-1]);
	data[0] = rv32b::fsl(data[0], shamt, buffer);
}

void bigint_ror(uint32_t data[], int n, int shamt)
{
	if (n <= 0)
		return;

	uint32_t buffer = data[0];
	for (int i = 0; i < n-1; i++)
		data[i] = rv32b::fsr(data[i], shamt, data[i+1]);
	data[n-1] = rv32b::fsr(data[n-1], shamt, buffer);
}

extern "C" void test_bigint_sll_srl(uint32_t a, uint32_t b, uint32_t c, uint32_t d)
{
	uint32_t data[4] = {a, b, c, d};

	bigint_rol(data, 4, 10);
	bigint_rol(data, 4, 7);
	bigint_rol(data, 4, 4);
	bigint_rol(data, 4, 12);
	bigint_rol(data, 4, 18);
	bigint_rol(data, 4, 28);
	bigint_rol(data, 4, 1);

	bigint_ror(data, 4, 10);
	bigint_ror(data, 4, 7);
	bigint_ror(data, 4, 4);
	bigint_ror(data, 4, 12);
	bigint_ror(data, 4, 18);
	bigint_ror(data, 4, 28);
	bigint_ror(data, 4, 1);

	assert(data[0] == a);
	assert(data[1] == b);
	assert(data[2] == c);
	assert(data[3] == d);
}

// ------------------------------------------------------------------

void parse_27bit(uint32_t *idata, uint32_t *odata, int n)
{
	uint32_t lower = 0, upper = 0;
	int reserve = 0;

	while (n--) {
		if (reserve < 27) {
			uint32_t buf = *(idata++);
			lower |= rv32b::sll(buf, reserve);
			upper = reserve ? rv32b::srl(buf, -reserve) : 0;
			reserve += 32;
		}
		*(odata++) = lower & 127;
		lower = rv32b::fsr(lower, 27, upper);
		upper = rv32b::srl(upper, 27);
		reserve -= 27;
	}
}

void test_parse_27bit(const uint32_t refdata[10])
{
	uint32_t idata[10] = { /* zeros */ };
	uint32_t odata[10];

	for (int i = 0; i < 10; i++) {
		bigint_rol(idata, 10, 27);
		idata[0] &= ~127;
		idata[0] |= refdata[9-i];
	}

	parse_27bit(idata, odata, 10);

	for (int i = 0; i < 10; i++)
		assert(odata[i] == refdata[i]);
}

// ------------------------------------------------------------------

void parse_6bit_ref(const uint64_t idata[3], uint64_t odata[4], bool sign_extend)
{
	uint64_t t0 = idata[0];
	uint64_t t1 = idata[1];
	uint64_t t2 = idata[2];

	for (int i = 0; i < 32; i++) {
		int v = t2 >> (64-6);
		t2 = (t2 << 6) | (t1 >> (64-6));
		t1 = (t1 << 6) | (t0 >> (64-6));
		t0 = (t0 << 6);
		if (sign_extend && v > 0x1f)
			v |= 0xc0;
		odata[3] = (odata[3] << 8) | (odata[2] >> (64-8));
		odata[2] = (odata[2] << 8) | (odata[1] >> (64-8));
		odata[1] = (odata[1] << 8) | (odata[0] >> (64-8));
		odata[0] = (odata[0] << 8) | v;
	}
}

void parse_6bit_fsl(const uint64_t idata[3], uint64_t odata[4])
{
	uint64_t mask = 0x3f3f3f3f3f3f3f3fLL;

	uint64_t t0 = idata[0];
	uint64_t t1 = idata[1];
	uint64_t t2 = idata[2];
	uint64_t t3;

	t3 = t2 >> 16;
	t3 = rv64b::bdep(t3, mask);

	t2 = rv64b::fsl(t2, 32, t1);
	t2 = rv64b::bdep(t2, mask);

	t1 = rv64b::fsl(t1, 16, t0);
	t1 = rv64b::bdep(t1, mask);

	t0 = rv64b::bdep(t0, mask);

	odata[0] = t0;
	odata[1] = t1;
	odata[2] = t2;
	odata[3] = t3;
}

void parse_6bit_nofsl(const uint64_t idata[3], uint64_t odata[4])
{
	uint64_t mask = 0x3f3f3f3f3f3f3f3f;

	uint64_t t0 = idata[0];
	uint64_t t1 = idata[1];
	uint64_t t2 = idata[2];
	uint64_t t3, a0;

	t3 = t2 >> 16;
	t3 = rv64b::bdep(t3, mask);

	t2 = t2 << 32;
	a0 = t1 >> 32;
	t2 = t2 | a0;
	t2 = rv64b::bdep(t2, mask);

	t1 = t1 << 16;
	a0 = t0 >> 48;
	t1 = t1 | a0;
	t1 = rv64b::bdep(t1, mask);

	t0 = rv64b::bdep(t0, mask);

	odata[0] = t0;
	odata[1] = t1;
	odata[2] = t2;
	odata[3] = t3;
}

void parse_6bit_sext_bmat(uint64_t iodata[4])
{
	uint64_t matrix = 0x80c0e01008040201;
	iodata[0] = rv64b::bmator(iodata[0], matrix);
	iodata[1] = rv64b::bmator(iodata[1], matrix);
	iodata[2] = rv64b::bmator(iodata[2], matrix);
	iodata[3] = rv64b::bmator(iodata[3], matrix);
}

void parse_6bit_sext_nobmat(uint64_t iodata[4])
{
	uint64_t mask = 0x6060606060606060;
	iodata[0] = (iodata[0] + mask) ^ mask;
	iodata[1] = (iodata[1] + mask) ^ mask;
	iodata[2] = (iodata[2] + mask) ^ mask;
	iodata[3] = (iodata[3] + mask) ^ mask;
}

void test_parse_6bit()
{
	uint64_t idata[3];
	uint64_t odata_ref[4];
	uint64_t odata_uut[4];

	for (int i = 0; i < 1000; i++)
	{
		idata[0] = xorshift64();
		idata[1] = xorshift64();
		idata[2] = xorshift64();

		switch (i % 4)
		{
		case 0:
			// printf("== parse_6bit_fsl ==\n");
			parse_6bit_ref(idata, odata_ref, false);
			parse_6bit_fsl(idata, odata_uut);
			break;
		case 1:
			// printf("== parse_6bit_nofsl ==\n");
			parse_6bit_ref(idata, odata_ref, false);
			parse_6bit_nofsl(idata, odata_uut);
			break;
		case 2:
			// printf("== parse_6bit_sext_bmat ==\n");
			parse_6bit_ref(idata, odata_ref, true);
			parse_6bit_ref(idata, odata_uut, false);
			parse_6bit_sext_bmat(odata_uut);
			break;
		case 3:
			// printf("== parse_6bit_sext_nobmat ==\n");
			parse_6bit_ref(idata, odata_ref, true);
			parse_6bit_ref(idata, odata_uut, false);
			parse_6bit_sext_nobmat(odata_uut);
			break;
		default:
			abort();
		}

	#if 0
		printf("I0: 0x%016llx\n", (long long)idata[0]);
		printf("I1: 0x%016llx\n", (long long)idata[1]);
		printf("I2: 0x%016llx\n\n", (long long)idata[2]);

		printf("O0: 0x%016llx\n", (long long)odata_ref[0]);
		printf("O1: 0x%016llx\n", (long long)odata_ref[1]);
		printf("O2: 0x%016llx\n", (long long)odata_ref[2]);
		printf("O3: 0x%016llx\n\n", (long long)odata_ref[3]);

		printf("O0: 0x%016llx\n", (long long)odata_uut[0]);
		printf("O1: 0x%016llx\n", (long long)odata_uut[1]);
		printf("O2: 0x%016llx\n", (long long)odata_uut[2]);
		printf("O3: 0x%016llx\n\n", (long long)odata_uut[3]);
	#endif

		assert(odata_ref[0] == odata_uut[0]);
		assert(odata_ref[1] == odata_uut[1]);
		assert(odata_ref[2] == odata_uut[2]);
		assert(odata_ref[3] == odata_uut[3]);
	}
}

// ------------------------------------------------------------------

int main()
{
	const uint32_t refdata[10] = {1, 2, 3, 4, 5, 6, 7, 8, 9, 10};
	test_parse_27bit(refdata);
	test_parse_6bit();
	printf("Okay.\n");
}
