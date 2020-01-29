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

const char *fmtgrev32(int mode)
{
	static char output[128];

	char *p = output;
	for (int i = 31; i >= 0; i--) {
		int d = rv32b::ctz(rv32b::grev32(1 << i, mode));
		p += sprintf(p, "%3d", d);
	}

	return output;
}

int main()
{
	printf("-       %s\n", fmtgrev32(0));
	printf("brev.p  %s\n", fmtgrev32(1));
	printf("pswap.n %s\n", fmtgrev32(2));
	printf("brev.n  %s\n", fmtgrev32(3));
	printf("nswap.b %s\n", fmtgrev32(4));
	printf("pswap.b %s\n", fmtgrev32(6));
	printf("brev.b  %s\n", fmtgrev32(7));
	printf("bswap.h %s\n", fmtgrev32(8));
	printf("nswap.h %s\n", fmtgrev32(12));
	printf("pswap.h %s\n", fmtgrev32(14));
	printf("brev.h  %s\n", fmtgrev32(15));
	printf("hswap   %s\n", fmtgrev32(16));
	printf("bswap   %s\n", fmtgrev32(24));
	printf("nswap   %s\n", fmtgrev32(28));
	printf("pswap   %s\n", fmtgrev32(30));
	printf("brev    %s\n", fmtgrev32(31));

	return 0;
}
