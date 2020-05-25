/*
 *  Copyright (C) 2020  Claire Wolf <claire@symbioticeda.com>
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

// ------------------------------------------------------------------

uint64_t lut1(uint64_t d, uint64_t s)
{
	static const uint64_t dd[4] = {
		0x0000000000000000LL,
		0x0123456789abcdefLL,
		0xfedcba9876543210LL,
		0xffffffffffffffffLL
	};
	return rv64b::xperm_n(dd[d&3], s);
}

extern "C" void check_lut1(uint64_t x, uint64_t y)
{
	uint64_t a = rv64b::xperm(x, y, 0);
	uint64_t b = lut1(x, y);
	assert(a == b);
}

// ------------------------------------------------------------------

uint64_t lut2(uint64_t d, uint64_t s)
{
	d = rv64b::gorc(rv64b::shfl(d & 0xff, -2), -16);   // 3 instructions  (+3)
	d |= rv64b::xperm_n(d, 0x3333222211110000) << 2;   // 6 instructions  (+3)
	return rv64b::xperm_n(d, s);                       // 7 instructions  (+1)
}

extern "C" void check_lut2(uint64_t x, uint64_t y)
{
	uint64_t a = rv64b::xperm(x, y, 1);
	uint64_t b = lut2(x, y);
	assert(a == b);
}

// ------------------------------------------------------------------

uint64_t lut8(uint64_t d, uint64_t s)
{
        uint64_t o = 0x1010101010101010LL;
        uint64_t p = 0xf8f8f8f8f8f8f8f8LL;
        uint64_t m = rv64b::gorc(s & p, 7);     // 2 instructions  (+2)
        s = rv64b::gorc((s & ~p) << 1, 4) + o;  // 6 instructions  (+4)
        return rv64b::xperm_n(d, s) & ~m;       // 8 instructions  (+2)
}

extern "C" void check_lut8(uint64_t x, uint64_t y)
{
	uint64_t a = rv64b::xperm_b(x, y);
	uint64_t b = lut8(x, y);
	assert(a == b);
}

// ------------------------------------------------------------------

int main()
{
	return 0;
}
