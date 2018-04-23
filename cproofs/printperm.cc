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

int main()
{
	for (int i = 0; i < 32; i++)
	for (int j = 0; j < 32; j++)
	{
		int ror_pos = ctz(ror(1 << i, j));
		int grev_pos = ctz(grev32(1 << i, j));
		int gzip_pos = ctz(gzip32(1 << i, j));
		int gzflip_pos = ctz(gzip32_stage0(1 << i));
		printf("%d %d %d %d %d %d\n", i, j, ror_pos, grev_pos, gzip_pos, gzflip_pos);
	}
	return 0;
}
