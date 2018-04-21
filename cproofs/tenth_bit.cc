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

int tenth_bit_reference(uint32_t src)
{
	int k = 0;
	for (int i = 0; i < 32; i++) {
		if ((src >> i) & 1)
			k++;
		if (k == 10)
			return i;
	}
	return 32;
}

int tenth_bit_impl(uint32_t src)
{
	uint32_t a0 = src;
	uint32_t a1 = 0x00000200;
	a0 = bdep(a1, a0);
	a0 = grev(a0, 31);
	a0 = clz(a0);
	return a0;
}

void tenth_bit_check(uint32_t src)
{
	uint32_t a = tenth_bit_reference(src);
	uint32_t b = tenth_bit_impl(src);
	assert(a == b);
}
