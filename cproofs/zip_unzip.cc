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

void zip_unzip_invcheck(uint32_t src)
{
	uint32_t a = zip32(unzip32(src));
	assert(a == src);

	uint32_t b = unzip32(zip32(src));
	assert(b == src);
}

void zip4_unzip_eqcheck(uint32_t src)
{
	uint32_t a = zip32(zip32(zip32(zip32(src))));
	uint32_t b = unzip32(src);
	assert(a == b);
}

void zip_unzip4_eqcheck(uint32_t src)
{
	uint32_t a = zip32(src);
	uint32_t b = unzip32(unzip32(unzip32(unzip32(src))));
	assert(a == b);
}
