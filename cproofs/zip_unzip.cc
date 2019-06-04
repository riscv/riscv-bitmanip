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
using namespace rv32b;
#define XLEN 32

uint_xlen_t bitmove(uint_xlen_t x, int p, int q)
{
	return ((x >> p) & 1) << q;
}

uint_xlen_t zipN(uint_xlen_t rs1, int N)
{
	uint_xlen_t x = 0;
	for (int k = 0; k < XLEN/N; k++) {
		for (int i = 0; i < N/2; i++) {
			x |= bitmove(rs1, N*k + i,       N*k + 2*i);
			x |= bitmove(rs1, N*k + i + N/2, N*k + 2*i + 1);
		}
	}
	return x;
}

uint_xlen_t unzipN(uint_xlen_t rs1, int N)
{
	uint_xlen_t x = 0;
	for (int k = 0; k < XLEN/N; k++) {
		for (int i = 0; i < N/2; i++) {
			x |= bitmove(rs1, N*k + 2*i,     N*k + i);
			x |= bitmove(rs1, N*k + 2*i + 1, N*k + i + N/2);
		}
	}
	return x;
}

uint_xlen_t swapbits(uint_xlen_t x, int p, int q)
{
	assert(p < q);
	x = x ^ ((x & (1 << p)) << (q - p));
	x = x ^ ((x & (1 << q)) >> (q - p));
	x = x ^ ((x & (1 << p)) << (q - p));
	return x;
}

uint_xlen_t bfly(uint_xlen_t rs1, uint_xlen_t mask, int N)
{
	uint_xlen_t x = rs1;
	int a = 1 << N, b = 2 * a;
	for (int i = 0; i < XLEN / 2; i++) {
		int p = b * (i / a) + i % a, q = p + a;
		if ((mask >> i) & 1)
			x = swapbits(x, p, q);
	}
	return x;
}

uint_xlen_t bxchg(uint_xlen_t rs1, uint_xlen_t rs2)
{
	uint_xlen_t upper = rs1 >> (XLEN/2);
	upper |= upper << (XLEN/2);

	uint_xlen_t lower = rs1 << (XLEN/2);
	lower |= lower >> (XLEN/2);

	return (upper & rs2) | (lower & ~rs2);
}

// ---------------------------------------------------------

extern "C" void zip_unzip_invcheck(uint32_t src)
{
	uint32_t a = zip(unzip(src));
	assert(a == src);

	uint32_t b = unzip(zip(src));
	assert(b == src);
}

extern "C" void zip4_unzip_eqcheck(uint32_t src)
{
	uint32_t a = zip(zip(zip(zip(src))));
	uint32_t b = unzip(src);
	assert(a == b);
}

extern "C" void zip_unzip4_eqcheck(uint32_t src)
{
	uint32_t a = zip(src);
	uint32_t b = unzip(unzip(unzip(unzip(src))));
	assert(a == b);
}

// ---------------------------------------------------------

extern "C" void zip_unzip_invcheck_N32(uint32_t src)
{
	uint32_t a = zipN(unzipN(src, 32), 32);
	assert(a == src);

	uint32_t b = unzipN(zipN(src, 32), 32);
	assert(b == src);
}

extern "C" void zip4_unzip_eqcheck_N32(uint32_t src)
{
	uint32_t a = zipN(zipN(zipN(zipN(src, 32), 32), 32), 32);
	uint32_t b = unzipN(src, 32);
	assert(a == b);
}

extern "C" void zip_unzip4_eqcheck_N32(uint32_t src)
{
	uint32_t a = zipN(src, 32);
	uint32_t b = unzipN(unzipN(unzipN(unzipN(src, 32), 32), 32), 32);
	assert(a == b);
}

// ---------------------------------------------------------

extern "C" void zip_unzip_invcheck_N16(uint32_t src)
{
	uint32_t a = zipN(unzipN(src, 16), 16);
	assert(a == src);

	uint32_t b = unzipN(zipN(src, 16), 16);
	assert(b == src);
}

extern "C" void zip3_unzip_eqcheck_N16(uint32_t src)
{
	uint32_t a = zipN(zipN(zipN(src, 16), 16), 16);
	uint32_t b = unzipN(src, 16);
	assert(a == b);
}

extern "C" void zip_unzip3_eqcheck_N16(uint32_t src)
{
	uint32_t a = zipN(src, 16);
	uint32_t b = unzipN(unzipN(unzipN(src, 16), 16), 16);
	assert(a == b);
}

// ---------------------------------------------------------

extern "C" void zip_unzip_invcheck_N8(uint32_t src)
{
	uint32_t a = zipN(unzipN(src, 8), 8);
	assert(a == src);

	uint32_t b = unzipN(zipN(src, 8), 8);
	assert(b == src);
}

extern "C" void zip2_unzip_eqcheck_N8(uint32_t src)
{
	uint32_t a = zipN(zipN(src, 8), 8);
	uint32_t b = unzipN(src, 8);
	assert(a == b);
}

extern "C" void zip_unzip2_eqcheck_N8(uint32_t src)
{
	uint32_t a = zipN(src, 8);
	uint32_t b = unzipN(unzipN(src, 8), 8);
	assert(a == b);
}

// ---------------------------------------------------------

extern "C" void zip_unzip_invcheck_N4(uint32_t src)
{
	uint32_t a = zipN(unzipN(src, 4), 4);
	assert(a == src);

	uint32_t b = unzipN(zipN(src, 4), 4);
	assert(b == src);
}

extern "C" void zip_unzip_eqcheck_N4(uint32_t src)
{
	uint32_t a = zipN(src, 4);
	uint32_t b = unzipN(src, 4);
	assert(a == b);
}

// ---------------------------------------------------------

extern "C" void zip_bfly_0_check(uint32_t src, uint32_t mask)
{
	uint32_t a = src;
	uint32_t b = bfly(a, mask, 0);

	uint32_t m = mask;

	a = unzip(a);
	a = bfly(a, m, 4);
	a = zip(a);

	assert(a == b);
}

extern "C" void zip_bfly_1_check(uint32_t src, uint32_t mask)
{
	uint32_t a = src;
	uint32_t b = bfly(a, mask, 1);

	uint32_t m = mask;
	m = unzipN(m, 16);

	a = unzip(a);
	a = unzip(a);
	a = bfly(a, m, 4);
	a = zip(a);
	a = zip(a);

	assert(a == b);
}

extern "C" void zip_bfly_2_check(uint32_t src, uint32_t mask)
{
	uint32_t a = src;
	uint32_t b = bfly(a, mask, 2);

	uint32_t m = mask;
	m = unzipN(m, 16);
	m = unzipN(m, 16);

	a = zip(a);
	a = zip(a);
	a = bfly(a, m, 4);
	a = unzip(a);
	a = unzip(a);

	assert(a == b);
}

extern "C" void zip_bfly_3_check(uint32_t src, uint32_t mask)
{
	uint32_t a = src;
	uint32_t b = bfly(a, mask, 3);

	uint32_t m = mask;
	m = zipN(m, 16);

	a = zip(a);
	a = bfly(a, m, 4);
	a = unzip(a);

	assert(a == b);
}

extern "C" void bxchg_bfly_4_check(uint32_t src, uint32_t mask)
{
	uint32_t a = bxchg(src, (mask & 0xffff) ^ (~mask << 16));
	uint32_t b = bfly(src, mask, 4);

	assert(a == b);
}

// ---------------------------------------------------------

uint32_t genzip32_stage0_ref(uint32_t src)
{
	uint32_t x = 0;
	for (int i = 0; i < 32; i++) {
		int j = 0;
		j |= bitmove(i, 0, 4);
		j |= bitmove(i, 1, 3);
		j |= bitmove(i, 2, 2);
		j |= bitmove(i, 3, 1);
		j |= bitmove(i, 4, 0);
		x |= bitmove(src, i, j);
	}
	return x;
}

uint32_t genzip32_stage0(uint32_t src)
{
	uint32_t x = src & 0x88224411;
	x |= ((src <<  6) & 0x22001100) | ((src >>  6) & 0x00880044);
	x |= ((src <<  9) & 0x00440000) | ((src >>  9) & 0x00002200);
	x |= ((src << 15) & 0x44110000) | ((src >> 15) & 0x00008822);
	x |= ((src << 21) & 0x11000000) | ((src >> 21) & 0x00000088);
	return x;
}

uint32_t genzip32_stage1_ref(uint32_t src)
{
	uint32_t x = 0;
	for (int i = 0; i < 32; i++) {
		int j = 0;
		j |= bitmove(i, 0, 1);
		j |= bitmove(i, 1, 0);
		j |= bitmove(i, 2, 2);
		j |= bitmove(i, 3, 3);
		j |= bitmove(i, 4, 4);
		x |= bitmove(src, i, j);
	}
	return x;
}

uint32_t genzip32_stage1(uint32_t src)
{
	uint32_t x = src & 0x99999999;
	x |= (src >>  1) & 0x22222222;
	x |= (src <<  1) & 0x44444444;
	return x;
}

uint32_t genzip32_stage2_ref(uint32_t src)
{
	uint32_t x = 0;
	for (int i = 0; i < 32; i++) {
		int j = 0;
		j |= bitmove(i, 0, 0);
		j |= bitmove(i, 1, 2);
		j |= bitmove(i, 2, 1);
		j |= bitmove(i, 3, 3);
		j |= bitmove(i, 4, 4);
		x |= bitmove(src, i, j);
	}
	return x;
}

uint32_t genzip32_stage2(uint32_t src)
{
	uint32_t x = src & 0xc3c3c3c3;
	x |= (src >>  2) & 0x0c0c0c0c;
	x |= (src <<  2) & 0x30303030;
	return x;
}


uint32_t genzip32_stage3_ref(uint32_t src)
{
	uint32_t x = 0;
	for (int i = 0; i < 32; i++) {
		int j = 0;
		j |= bitmove(i, 0, 0);
		j |= bitmove(i, 1, 1);
		j |= bitmove(i, 2, 3);
		j |= bitmove(i, 3, 2);
		j |= bitmove(i, 4, 4);
		x |= bitmove(src, i, j);
	}
	return x;
}

uint32_t genzip32_stage3(uint32_t src)
{
	uint32_t x = src & 0xf00ff00f;
	x |= (src >>  4) & 0x00f000f0;
	x |= (src <<  4) & 0x0f000f00;
	return x;
}

uint32_t genzip32_stage4_ref(uint32_t src)
{
	uint32_t x = 0;
	for (int i = 0; i < 32; i++) {
		int j = 0;
		j |= bitmove(i, 0, 0);
		j |= bitmove(i, 1, 1);
		j |= bitmove(i, 2, 2);
		j |= bitmove(i, 3, 4);
		j |= bitmove(i, 4, 3);
		x |= bitmove(src, i, j);
	}
	return x;
}

uint32_t genzip32_stage4(uint32_t src)
{
	uint32_t x = src & 0xff0000ff;
	x |= (src >>  8) & 0x0000ff00;
	x |= (src <<  8) & 0x00ff0000;
	return x;
}

uint32_t genzip32(uint32_t rs1, uint32_t rs2)
{
	uint32_t x = rs1;
	int mode = rs2 & 31;
	if (mode &  1) x = genzip32_stage0(x);
	if ((mode & 17) == 16 || (mode &  3) ==  3) x = genzip32_stage4(x);
	if ((mode &  9) ==  8 || (mode &  5) ==  5) x = genzip32_stage3(x);
	if ((mode &  5) ==  4 || (mode &  9) ==  9) x = genzip32_stage2(x);
	if ((mode &  3) ==  2 || (mode & 17) == 17) x = genzip32_stage1(x);
	if (mode &  1) x = genzip32_stage0(x);
	return x;
}

// ---------------------------------------------------------

extern "C" void check_zip_unzip_n(uint32_t src)
{
	uint32_t a = zipN(src, 4);
	uint32_t b = unzipN(src, 4);
	uint32_t c = genzip32(src, 2);
	assert(a == b);
	assert(a == c);
}

extern "C" void check_zip_b(uint32_t src)
{
	uint32_t a = zipN(src, 8);
	uint32_t b = genzip32(src, 6);
	assert(a == b);
}

extern "C" void check_unzip_b(uint32_t src)
{
	uint32_t a = unzipN(src, 8);
	uint32_t b = genzip32(src, 7);
	assert(a == b);
}

extern "C" void check_zip_h(uint32_t src)
{
	uint32_t a = zipN(src, 16);
	uint32_t b = genzip32(src, 14);
	assert(a == b);
}

extern "C" void check_unzip_h(uint32_t src)
{
	uint32_t a = unzipN(src, 16);
	uint32_t b = genzip32(src, 15);
	assert(a == b);
}

extern "C" void check_zip(uint32_t src)
{
	uint32_t a = zip(src);
	uint32_t b = genzip32(src, 30);
	assert(a == b);
}

extern "C" void check_gzip32(uint32_t src, uint32_t mode)
{
	uint32_t a = unshfl32(src, mode);
	uint32_t b = unshfl32alt(src, mode);
	uint32_t c = genzip32(src, (mode << 1) | 1);

	assert(a == b);
	assert(a == c);
}

extern "C" void check_stages(uint32_t src)
{
	assert(genzip32_stage0_ref(src) == genzip32_stage0(src));
	assert(genzip32_stage1_ref(src) == genzip32_stage1(src));
	assert(genzip32_stage2_ref(src) == genzip32_stage2(src));
	assert(genzip32_stage3_ref(src) == genzip32_stage3(src));
	assert(genzip32_stage4_ref(src) == genzip32_stage4(src));
}


// ---------------------------------------------------------

extern "C" void check_pack(uint32_t x1, uint32_t x2)
{
	uint32_t res = pack(x1, x2);
	res = zip8(res);
	assert(((res >>  0) & 255) == ((x1 >> 0) & 255));
	assert(((res >>  8) & 255) == ((x2 >> 0) & 255));
	assert(((res >> 16) & 255) == ((x1 >> 8) & 255));
	assert(((res >> 24) & 255) == ((x2 >> 8) & 255));
}

// ---------------------------------------------------------

extern "C" void check_shflw(uint64_t src, int ctrl)
{
	uint64_t ref = rv64b::sextw(rv32b::shfl(src, ctrl));
	uint64_t tst = rv64b::shfl(rv64b::sextw(src), ctrl & 15);
	assert(ref == tst);
}

extern "C" void check_unshflw(uint64_t src, int ctrl)
{
	uint64_t ref = rv64b::sextw(rv32b::unshfl(src, ctrl));
	uint64_t tst = rv64b::unshfl(rv64b::sextw(src), ctrl & 15);
	assert(ref == tst);
}

// ---------------------------------------------------------

extern "C" void check_pack_bytes(uint32_t a, uint32_t b, uint32_t c, uint32_t d)
{
	uint32_t ref = (a & 255) | ((b & 255) << 8) | ((c & 255) << 16) | ((d & 255) << 24);
	uint32_t tst1 = rv32b::pack(rv32b::shfl(rv32b::pack(a, b), 8), rv32b::shfl(rv32b::pack(c, d), 8));
	uint32_t tst2 = rv32b::ror(rv32b::pack(d & 255, b & 255), 8) | rv32b::pack(a & 255, c & 255);
	assert(ref == tst1);
	assert(ref == tst2);
}

// ---------------------------------------------------------

int main()
{
	printf("\n0:");
	for (int i = 0; i < 32; i++)
		printf(" %2d",  __builtin_ctz(genzip32_stage0_ref(1 << (31-i))));
	printf("\n1:");
	for (int i = 0; i < 32; i++)
		printf(" %2d",  __builtin_ctz(genzip32_stage1_ref(1 << (31-i))));
	printf("\n2:");
	for (int i = 0; i < 32; i++)
		printf(" %2d",  __builtin_ctz(genzip32_stage2_ref(1 << (31-i))));
	printf("\n3:");
	for (int i = 0; i < 32; i++)
		printf(" %2d",  __builtin_ctz(genzip32_stage3_ref(1 << (31-i))));
	printf("\n4:");
	for (int i = 0; i < 32; i++)
		printf(" %2d",  __builtin_ctz(genzip32_stage4_ref(1 << (31-i))));
	printf("\n\n");

	uint32_t shift_left_mask[32] = { /* zeros */ };
	uint32_t shift_right_mask[32] = { /* zeros */ };

	for (int i = 0; i < 32; i++) {
		int j = __builtin_ctz(genzip32_stage0_ref(1 << i));
		if (j >= i) shift_left_mask[j-i]  |= 1 << j;
		if (j <= i) shift_right_mask[i-j] |= 1 << j;
	}

	for (int i = 0; i < 32; i++)
	{
		printf("  sll %2d: ", i);

		if (shift_left_mask[i])
			printf("0x%08x", shift_left_mask[i]);
		else
			printf("          ");

		printf("          srl %2d:", i);

		if (shift_right_mask[i])
			printf(" 0x%08x", shift_right_mask[i]);

		printf("\n");
	}

	printf("\n");

	printf("uint32_t x = src & 0x%08x;\n", shift_left_mask[0]);
	for (int i = 1; i < 32; i++)
		if (shift_left_mask[i])
			printf("x |= ((src << %2d) & 0x%08x) | ((src >> %2d) & 0x%08x);\n",
				i, shift_left_mask[i], i, shift_right_mask[i]);

	printf("\n");
	return 0;
}
