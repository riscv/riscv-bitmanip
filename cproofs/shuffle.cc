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

uint32_t omega(uint32_t x, uint32_t mask)
{
	x = zip32(x);
	x = bfly32(x, mask, 0);
	return x;
}

uint32_t flip(uint32_t x, uint32_t mask)
{
	x = bfly32(x, mask, 0);
	x = unzip32(x);
	return x;
}

void omega_flip_invcheck(uint32_t src, uint32_t mask)
{
	uint32_t a = omega(flip(src, mask), mask);
	assert(a == src);

	uint32_t b = flip(omega(src, mask), mask);
	assert(b == src);
}
