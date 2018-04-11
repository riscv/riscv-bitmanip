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
extern "C" uint32_t decode_sb_imm(uint32_t b);
extern "C" uint32_t decode_uj_imm(uint32_t b);

uint32_t decode_s_imm(uint32_t b)
{
	return insn_t(b).s_imm();
}

uint32_t decode_sb_imm(uint32_t b)
{
	return insn_t(b).sb_imm();
}

uint32_t decode_uj_imm(uint32_t b)
{
	return insn_t(b).uj_imm();
}

// ---------------------------------------------------------

void check_s_imm(insn_t insn)
{
	uint32_t ref = insn.s_imm();

	uint32_t a0 = bext32(insn.b, 0xfe000f80);
	a0 = sll32(a0, 20);
	a0 = sra32(a0, 20);

	assert(ref == a0);
}

void check_sb_imm(insn_t insn)
{
	uint32_t ref = insn.sb_imm();

	uint32_t a1 = bext32(insn.b, 0x80000080);
	uint32_t a0 = bext32(insn.b, 0x7e000f00);
	a1 = sll32(a1, 30);
	a0 = sll32(a0, 20);
	a0 = a0 | a1;
	a0 = sra32(a0, 19);

	assert(ref == a0);
}

void check_uj_imm(insn_t insn)
{
	uint32_t ref = insn.uj_imm();

	uint32_t a2 = bext32(insn.b, 0x800ff000);
	uint32_t a1 = bext32(insn.b, 0x00100000);
	uint32_t a0 = bext32(insn.b, 0x7fe00000);
	a2 = sll32(a2, 23);
	a1 = sll32(a1, 22);
	a0 = sll32(a0, 12);
	a0 = a0 | a2;
	a0 = a0 | a1;
	a0 = sra32(a0, 11);

	assert(ref == a0);
}
