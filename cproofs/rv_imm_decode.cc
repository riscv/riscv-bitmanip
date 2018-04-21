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

inline uint32_t signext(uint32_t data, int len)
{
	uint32_t smask = ((data >> (len-1)) & 1) ? 0xffffffff : 0;
	return data | (smask << len);
}

inline uint32_t uintbits32(uint32_t data, int lo, int len)
{
	uint32_t b = data << (32-lo-len);
	return b >> (32-len);
}

inline uint32_t sintbits32(uint32_t data, int lo, int len)
{
	return signext(uintbits32(data, lo, len), len);
}

struct insn_t
{
	uint32_t b;
	insn_t(uint32_t b) : b(b) { }
	uint32_t x(int lo, int len) { return uintbits32(b, lo, len); }
	uint32_t xs(int lo, int len) { return sintbits32(b, lo, len); }
	uint32_t imm_sign() { return xs(31, 1); }

	inline int32_t s_imm() { return x(7, 5) + (xs(25, 7) << 5); }
	inline int32_t sb_imm() { return (x(8, 4) << 1) + (x(25,6) << 5) + (x(7,1) << 11) + (imm_sign() << 12); }
	inline int32_t u_imm() { return int32_t(b) >> 12 << 12; }
	inline int32_t uj_imm() { return (x(21, 10) << 1) + (x(20, 1) << 11) + (x(12, 8) << 12) + (imm_sign() << 20); }

	int32_t rvc_imm() { return x(2, 5) + (xs(12, 1) << 5); }
	int32_t rvc_zimm() { return x(2, 5) + (x(12, 1) << 5); }
	int32_t rvc_addi4spn_imm() { return (x(6, 1) << 2) + (x(5, 1) << 3) + (x(11, 2) << 4) + (x(7, 4) << 6); }
	int32_t rvc_addi16sp_imm() { return (x(6, 1) << 4) + (x(2, 1) << 5) + (x(5, 1) << 6) + (x(3, 2) << 7) + (xs(12, 1) << 9); }
	int32_t rvc_lwsp_imm() { return (x(4, 3) << 2) + (x(12, 1) << 5) + (x(2, 2) << 6); }
	int32_t rvc_ldsp_imm() { return (x(5, 2) << 3) + (x(12, 1) << 5) + (x(2, 3) << 6); }
	int32_t rvc_swsp_imm() { return (x(9, 4) << 2) + (x(7, 2) << 6); }
	int32_t rvc_sdsp_imm() { return (x(10, 3) << 3) + (x(7, 3) << 6); }
	int32_t rvc_lw_imm() { return (x(6, 1) << 2) + (x(10, 3) << 3) + (x(5, 1) << 6); }
	int32_t rvc_ld_imm() { return (x(10, 3) << 3) + (x(5, 2) << 6); }
	int32_t rvc_j_imm() { return (x(3, 3) << 1) + (x(11, 1) << 4) + (x(2, 1) << 5) + (x(7, 1) << 6) + (x(6, 1) << 7) +
			(x(9, 2) << 8) + (x(8, 1) << 10) + (xs(12, 1) << 11); }
	int32_t rvc_b_imm() { return (x(3, 2) << 1) + (x(10, 2) << 3) + (x(2, 1) << 5) + (x(5, 2) << 6) + (xs(12, 1) << 8); }
};

// ---------------------------------------------------------

extern "C" uint32_t decode_s_imm(uint32_t b);
extern "C" uint32_t decode_b_imm(uint32_t b);
extern "C" uint32_t decode_j_imm(uint32_t b);
extern "C" uint32_t decode_cj_imm(uint32_t b);
extern "C" uint32_t decode_cj_imm2(uint32_t b);

uint32_t decode_s_imm(uint32_t b)
{
	return insn_t(b).s_imm();
}

uint32_t decode_b_imm(uint32_t b)
{
	return insn_t(b).sb_imm();
}

uint32_t decode_j_imm(uint32_t b)
{
	return insn_t(b).uj_imm();
}

uint32_t decode_cj_imm(uint32_t b)
{
	return insn_t(b).rvc_j_imm();
}

uint32_t decode_cj_imm2(uint32_t b)
{
	static const uint16_t table[64] = {
		0x0000, 0x0000, 0x0000, 0x0000, 0x0020, 0x0020, 0x0020, 0x0020,
		0x0002, 0x0002, 0x0002, 0x0002, 0x0022, 0x0022, 0x0022, 0x0022,
		0x0000, 0x0004, 0x0008, 0x000c, 0x0080, 0x0084, 0x0088, 0x008c,
		0x0040, 0x0044, 0x0048, 0x004c, 0x00c0, 0x00c4, 0x00c8, 0x00cc,
		0x0000, 0x0400, 0x0100, 0x0500, 0x0200, 0x0600, 0x0300, 0x0700,
		0x0010, 0x0410, 0x0110, 0x0510, 0x0210, 0x0610, 0x0310, 0x0710,
		0x0000, 0xf800, 0x0000, 0xf800, 0x0000, 0xf800, 0x0000, 0xf800,
		0x0000, 0xf800, 0x0000, 0xf800, 0x0000, 0xf800, 0x0000, 0xf800,
	};

	uint32_t x = 0;
	x |= int16_t(table[ 0 + ((b >>  0) & 15)]);
	x |= int16_t(table[16 + ((b >>  4) & 15)]);
	x |= int16_t(table[32 + ((b >>  8) & 15)]);
	x |= int16_t(table[48 + ((b >> 12) & 15)]);

	return x;
}

// ---------------------------------------------------------

void check_s_imm(insn_t insn)
{
	uint32_t ref = insn.s_imm();

	uint32_t a0 = insn.b;
	uint32_t t0;

	t0 = 0xfe000f80;
	a0 = bext(a0, t0);
	a0 = sll(a0, 20);
	a0 = sra(a0, 20);

	assert(ref == a0);
}

void check_b_imm(insn_t insn)
{
	uint32_t ref = insn.sb_imm();

	uint32_t a0 = insn.b;
	uint32_t t0;

	a0 = ror(a0, 8);
	t0 = 0x804eb000;
	a0 = shuffle(a0, t0);
	t0 = 0x80fe0e01;
	a0 = bext(a0, t0);
	a0 = sll(a0, 20);
	a0 = sra(a0, 19);

	assert(ref == a0);
}

void check_j_imm(insn_t insn)
{
	uint32_t ref = insn.uj_imm();

	uint32_t a0 = insn.b;
	uint32_t t0;

	t0 = 0x0fffb000;
	a0 = shuffle(a0, t0);
	t0 = 0x0f40a000;
	a0 = shuffle(a0, t0);
	t0 = 0x70fec000;
	a0 = shuffle(a0, t0);
	t0 = 0x8ff170fe;
	a0 = bext(a0, t0);
	a0 = sll(a0, 12);
	a0 = sra(a0, 11);

	assert(ref == a0);
}

void check_j_imm2(insn_t insn)
{
	uint32_t ref = insn.uj_imm();

	uint32_t a0 = insn.b;
	uint32_t t0, a1, a2;

	t0 = 0x800ff000;
	a1 = 0x00100000;
	a2 = bext(a0, t0);
	a1 = a1 & a0;
	a0 = sll(a0, 1);
	a0 = srl(a0, 22);
	a2 = sll(a2, 23);
	a1 = sll(a1, 2);
	a0 = sll(a0, 12);
	a0 = a0 | a2;
	a0 = a0 | a1;
	a0 = sra(a0, 11);

	assert(ref == a0);
}

void check_cj_imm(insn_t insn)
{
	uint32_t ref = insn.rvc_j_imm();

	uint32_t a0 = insn.b;
	uint32_t t0;

	a0 = grev(a0, 1);
	t0 = 0xebcac000;
	a0 = shuffle(a0, t0);
	t0 = 0xe3469000;
	a0 = shuffle(a0, t0);
	t0 = 0x8bc20464;
	a0 = bext(a0, t0);
	a0 = sll(a0, 21);
	a0 = sra(a0, 20);

	assert(ref == a0);
}

void check_cj_imm2(insn_t insn)
{
	uint32_t ref = insn.rvc_j_imm();
	uint32_t x = decode_cj_imm2(insn.b);

	assert(ref == x);
}

#if 0
int main()
{
	printf("---- table for decode_cj_imm2() ----\n");

	uint16_t table[64] = { /* zeros */ };

	int perm[16] = {
		/* 15 */ 12, 12, 12, 12, /* 12 */
		/* 11 */ 12,  8, 10,  9, /*  8 */
		/*  7 */  6,  7,  2, 11, /*  4 */
		/*  3 */  5,  4,  3,  0, /*  0 */
	};

	for (int i = 0; i < 4; i++)
	for (int j = 0; j < 16; j++)
	{
		uint16_t v = 0;

		for (int k = 0; k < 16; k++)
		{
			int p = perm[15-k];

			if (p == 0)
				continue;

			p -= 4*i;

			if (p < 0 || 3 < p)
				continue;

			if ((j & (1 << p)) == 0)
				continue;

			v |= 1 << k;
		}

		table[16*i + j] = v;
	}

	for (int i = 0; i < 64; i++)
		printf("%s0x%04x%s", i%8 == 0 ? "" : ", ",
				table[i], i%8 == 7 ? ",\n" : "");

	return 0;
}
#endif
