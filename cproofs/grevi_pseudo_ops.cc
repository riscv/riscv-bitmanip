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

void rv32_brev(uint32_t x)
{
	uint32_t a = grev32(x, 31);
	uint32_t b = 0;

	for (int i = 0; i < 32; i++)
		b |= bitmove32(x, i, 31-i);

	assert(a == b);
}

void rv32_brev_h(uint32_t x)
{
	uint32_t a = grev32(x, 15);
	uint32_t b = 0;

	for (int i = 0; i < 16; i++)
	{
		b |= bitmove32(x,    i,    15-i);
		b |= bitmove32(x, 16+i, 16+15-i);
	}

	assert(a == b);
}

void rv32_brev_b(uint32_t x)
{
	uint32_t a = grev32(x, 7);
	uint32_t b = 0;

	for (int i = 0; i < 8; i++)
	{
		b |= bitmove32(x,    i,    7-i);
		b |= bitmove32(x,  8+i,  8+7-i);
		b |= bitmove32(x, 16+i, 16+7-i);
		b |= bitmove32(x, 24+i, 24+7-i);
	}

	assert(a == b);
}

void rv32_bswap(uint32_t x)
{
	uint32_t a = grev32(x, 24);
	uint32_t b = 0;

	b |= (x & 0x000000ff) << 24;
	b |= (x & 0x0000ff00) <<  8;
	b |= (x & 0x00ff0000) >>  8;
	b |= (x & 0xff000000) >> 24;

	assert(a == b);
}

void rv32_bswap_h(uint32_t x)
{
	uint32_t a = grev32(x, 8);
	uint32_t b = 0;

	b |= (x & 0x000000ff) << 8;
	b |= (x & 0x0000ff00) >> 8;
	b |= (x & 0x00ff0000) << 8;
	b |= (x & 0xff000000) >> 8;

	assert(a == b);
}

void rv32_hswap(uint32_t x)
{
	uint32_t a = grev32(x, 16);
	uint32_t b = 0;

	b |= (x & 0x0000ffff) << 16;
	b |= (x & 0xffff0000) >> 16;

	assert(a == b);
}

// ---------------------------------------------------------

void rv64_brev(uint64_t x)
{
	uint64_t a = grev64(x, 63);
	uint64_t b = 0;

	for (int i = 0; i < 64; i++)
		b |= bitmove64(x, i, 63-i);

	assert(a == b);
}

void rv64_brev_w(uint64_t x)
{
	uint64_t a = grev64(x, 31);
	uint64_t b = 0;

	for (int i = 0; i < 32; i++)
	{
		b |= bitmove64(x,    i,    31-i);
		b |= bitmove64(x, 32+i, 32+31-i);
	}

	assert(a == b);
}

void rv64_brev_h(uint64_t x)
{
	uint64_t a = grev64(x, 15);
	uint64_t b = 0;

	for (int i = 0; i < 16; i++)
	{
		b |= bitmove64(x,    i,    15-i);
		b |= bitmove64(x, 16+i, 16+15-i);
		b |= bitmove64(x, 32+i, 32+15-i);
		b |= bitmove64(x, 48+i, 48+15-i);
	}

	assert(a == b);
}

void rv64_brev_b(uint64_t x)
{
	uint64_t a = grev64(x, 7);
	uint64_t b = 0;

	for (int i = 0; i < 8; i++)
	{
		b |= bitmove64(x,    i,    7-i);
		b |= bitmove64(x,  8+i,  8+7-i);
		b |= bitmove64(x, 16+i, 16+7-i);
		b |= bitmove64(x, 24+i, 24+7-i);
		b |= bitmove64(x, 32+i, 32+7-i);
		b |= bitmove64(x, 40+i, 40+7-i);
		b |= bitmove64(x, 48+i, 48+7-i);
		b |= bitmove64(x, 56+i, 56+7-i);
	}

	assert(a == b);
}

void rv64_bswap(uint64_t x)
{
	uint64_t a = grev64(x, 56);
	uint64_t b = 0;

	for (int i = 0; i < 8; i++)
		b |= ((x >> (8*i)) & 0xff) << (8*(7-i));

	assert(a == b);
}

void rv64_bswap_h(uint64_t x)
{
	uint64_t a = grev64(x, 8);
	uint64_t b = 0;

	for (int i = 0; i < 8; i++) {
		int j = (i & ~1) | (1-(i & 1));
		b |= ((x >> (8*i)) & 0xff) << (8*j);
	}

	assert(a == b);
}

void rv64_bswap_w(uint64_t x)
{
	uint64_t a = grev64(x, 24);
	uint64_t b = 0;

	for (int i = 0; i < 8; i++) {
		int j = (i & ~3) | (3-(i & 3));
		b |= ((x >> (8*i)) & 0xff) << (8*j);
	}

	assert(a == b);
}

void rv64_hswap(uint64_t x)
{
	uint64_t a = grev64(x, 48);
	uint64_t b = 0;

	for (int i = 0; i < 4; i++) {
		int j = 3-i;
		b |= ((x >> (16*i)) & 0xffff) << (16*j);
	}

	assert(a == b);
}

void rv64_hswap_w(uint64_t x)
{
	uint64_t a = grev64(x, 16);
	uint64_t b = 0;

	for (int i = 0; i < 4; i++) {
		int j = (i & ~1) | (1-(i & 1));
		b |= ((x >> (16*i)) & 0xffff) << (16*j);
	}

	assert(a == b);
}

void rv64_wswap(uint64_t x)
{
	uint64_t a = grev64(x, 32);
	uint64_t b = 0;

	b |= x >> 32;
	b |= x << 32;

	assert(a == b);
}
