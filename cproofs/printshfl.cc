/*
 *  Copyright (C) 2018  Claire Wolf <claire@symbioticeda.com>
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
		int d = rv32b::ctz(rv32b::shfl32(1 << i, mode));
		output[d] = input[i];
		assert(saved_pos[uint8_t(input[i])] <= d);
		saved_pos[uint8_t(input[i])] = d+1;
	}

	return output;
}

int main()
{
	const char *p;

	//   10987654321098765432109876543210
	p = "AAAAAAAAAAAAAAAABBBBBBBBBBBBBBBB";
	printf("-       %s\n", p);
	printf("zip8    %s\n", fmtzip32(p, 8));
	printf("zip4    %s\n", fmtzip32(p, 12));
	printf("zip2    %s\n", fmtzip32(p, 14));
	printf("zip     %s\n", fmtzip32(p, 15));


	p = "AAAAAAAABBBBBBBBAAAAAAAABBBBBBBB";
	printf("\n");
	printf("-       %s\n", p);
	printf("zip4.h  %s\n", fmtzip32(p, 4));
	printf("zip2.h  %s\n", fmtzip32(p, 6));
	printf("zip.h   %s\n", fmtzip32(p, 7));

	p = "AAAABBBBAAAABBBBAAAABBBBAAAABBBB";
	printf("\n");
	printf("-       %s\n", p);
	printf("zip2.b  %s\n", fmtzip32(p, 2));
	printf("zip.b   %s\n", fmtzip32(p, 3));

	p = "AABBAABBAABBAABBAABBAABBAABBAABB";
	printf("\n");
	printf("-       %s\n", p);
	printf("zip.n   %s\n", fmtzip32(p, 1));

	return 0;
}
