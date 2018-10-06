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

const char *fmtzip32(const char *input, int mode)
{
	static char output[33];
	int saved_pos[256] = { /* zeros */ };

	for (int i = 0; i < 32; i++)
	{
		uint32_t d = rv32b::ctz(rv32b::shfl32(1 << i, mode));
		output[d] = input[i];
		assert(saved_pos[uint8_t(input[i])] <= i);
		saved_pos[uint8_t(input[i])] = i+1;
	}

	return output;
}

const char *fmtgrev32(const char *input, int mode)
{
	static char output[33];
	int saved_pos[256] = { /* zeros */ };

	for (int i = 0; i < 32; i++)
	{
		uint32_t d = rv32b::ctz(rv32b::grev32(1 << i, mode));
		output[d] = input[i];
		assert(saved_pos[uint8_t(input[i])] <= i);
		saved_pos[uint8_t(input[i])] = i+1;
	}

	return output;
}

int main()
{
	const char *p;

	//   10123456789012345678901234567890
	p = "ABCDEFGHJKLMNPQRSTUVWXYZ23456789";
	printf("-       %s\n", p);
	printf("zip.n   %s\n", fmtzip32(p, 1));
	printf("zip2.b  %s\n", fmtzip32(p, 2));
	printf("zip.b   %s\n", fmtzip32(p, 3));
	printf("zip4.h  %s\n", fmtzip32(p, 4));
	printf("zip2.h  %s\n", fmtzip32(p, 6));
	printf("zip.h   %s\n", fmtzip32(p, 7));
	printf("zip8    %s\n", fmtzip32(p, 8));
	printf("zip4    %s\n", fmtzip32(p, 12));
	printf("zip2    %s\n", fmtzip32(p, 14));
	printf("zip     %s\n", fmtzip32(p, 15));

	printf("brev.p  %s\n", fmtgrev32(p, 1));
	printf("pswap.n %s\n", fmtgrev32(p, 2));
	printf("brev.n  %s\n", fmtgrev32(p, 3));
	printf("nswap.b %s\n", fmtgrev32(p, 4));
	printf("pswap.b %s\n", fmtgrev32(p, 6));
	printf("brev.b  %s\n", fmtgrev32(p, 7));
	printf("bswap.h %s\n", fmtgrev32(p, 8));
	printf("nswap.h %s\n", fmtgrev32(p, 12));
	printf("pswap.h %s\n", fmtgrev32(p, 14));
	printf("brev.h  %s\n", fmtgrev32(p, 15));
	printf("hswap   %s\n", fmtgrev32(p, 16));
	printf("bswap   %s\n", fmtgrev32(p, 24));
	printf("nswap   %s\n", fmtgrev32(p, 28));
	printf("pswap   %s\n", fmtgrev32(p, 30));
	printf("brev    %s\n", fmtgrev32(p, 31));

	return 0;
}
