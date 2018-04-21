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
	uint32_t a = zip(unzip(src));
	assert(a == src);

	uint32_t b = unzip(zip(src));
	assert(b == src);
}

void zip4_unzip_eqcheck(uint32_t src)
{
	uint32_t a = zip(zip(zip(zip(src))));
	uint32_t b = unzip(src);
	assert(a == b);
}

void zip_unzip4_eqcheck(uint32_t src)
{
	uint32_t a = zip(src);
	uint32_t b = unzip(unzip(unzip(unzip(src))));
	assert(a == b);
}

// ---------------------------------------------------------

void zip_unzip_invcheck_N32(uint32_t src)
{
	uint32_t a = zipN(unzipN(src, 32), 32);
	assert(a == src);

	uint32_t b = unzipN(zipN(src, 32), 32);
	assert(b == src);
}

void zip4_unzip_eqcheck_N32(uint32_t src)
{
	uint32_t a = zipN(zipN(zipN(zipN(src, 32), 32), 32), 32);
	uint32_t b = unzipN(src, 32);
	assert(a == b);
}

void zip_unzip4_eqcheck_N32(uint32_t src)
{
	uint32_t a = zipN(src, 32);
	uint32_t b = unzipN(unzipN(unzipN(unzipN(src, 32), 32), 32), 32);
	assert(a == b);
}

// ---------------------------------------------------------

void zip_unzip_invcheck_N16(uint32_t src)
{
	uint32_t a = zipN(unzipN(src, 16), 16);
	assert(a == src);

	uint32_t b = unzipN(zipN(src, 16), 16);
	assert(b == src);
}

void zip3_unzip_eqcheck_N16(uint32_t src)
{
	uint32_t a = zipN(zipN(zipN(src, 16), 16), 16);
	uint32_t b = unzipN(src, 16);
	assert(a == b);
}

void zip_unzip3_eqcheck_N16(uint32_t src)
{
	uint32_t a = zipN(src, 16);
	uint32_t b = unzipN(unzipN(unzipN(src, 16), 16), 16);
	assert(a == b);
}

// ---------------------------------------------------------

void zip_unzip_invcheck_N8(uint32_t src)
{
	uint32_t a = zipN(unzipN(src, 8), 8);
	assert(a == src);

	uint32_t b = unzipN(zipN(src, 8), 8);
	assert(b == src);
}

void zip2_unzip_eqcheck_N8(uint32_t src)
{
	uint32_t a = zipN(zipN(src, 8), 8);
	uint32_t b = unzipN(src, 8);
	assert(a == b);
}

void zip_unzip2_eqcheck_N8(uint32_t src)
{
	uint32_t a = zipN(src, 8);
	uint32_t b = unzipN(unzipN(src, 8), 8);
	assert(a == b);
}

// ---------------------------------------------------------

void zip_unzip_invcheck_N4(uint32_t src)
{
	uint32_t a = zipN(unzipN(src, 4), 4);
	assert(a == src);

	uint32_t b = unzipN(zipN(src, 4), 4);
	assert(b == src);
}

void zip_unzip_eqcheck_N4(uint32_t src)
{
	uint32_t a = zipN(src, 4);
	uint32_t b = unzipN(src, 4);
	assert(a == b);
}
