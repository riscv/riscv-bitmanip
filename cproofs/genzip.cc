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

void check_zip_unzip_n(uint32_t src)
{
	uint32_t a = zipN(src, 4);
	uint32_t b = unzipN(src, 4);
	uint32_t c = genzip32(src, 2);
	assert(a == b);
	assert(a == c);
}

void check_zip_b(uint32_t src)
{
	uint32_t a = zipN(src, 8);
	uint32_t b = genzip32(src, 6);
	assert(a == b);
}

void check_unzip_b(uint32_t src)
{
	uint32_t a = unzipN(src, 8);
	uint32_t b = genzip32(src, 7);
	assert(a == b);
}

void check_zip_h(uint32_t src)
{
	uint32_t a = zipN(src, 16);
	uint32_t b = genzip32(src, 14);
	assert(a == b);
}

void check_unzip_h(uint32_t src)
{
	uint32_t a = unzipN(src, 16);
	uint32_t b = genzip32(src, 15);
	assert(a == b);
}

void check_zip(uint32_t src)
{
	uint32_t a = zip(src);
	uint32_t b = genzip32(src, 30);
	assert(a == b);
}

void check_gzip32(uint32_t src, uint32_t mode)
{
	uint32_t a = gzip32(src, mode);
	uint32_t b = gzip32alt(src, mode);
	uint32_t c = genzip32(src, mode);
	assert(a == b);
	assert(a == c);
}

void check_stages(uint32_t src)
{
	assert(genzip32_stage0_ref(src) == genzip32_stage0(src));
	assert(genzip32_stage1_ref(src) == genzip32_stage1(src));
	assert(genzip32_stage2_ref(src) == genzip32_stage2(src));
	assert(genzip32_stage3_ref(src) == genzip32_stage3(src));
	assert(genzip32_stage4_ref(src) == genzip32_stage4(src));
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
