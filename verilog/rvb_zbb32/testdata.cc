/*
 *  Copyright (C) 2019  Claire Wolf <claire@symbioticeda.com>
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

#include <stdio.h>
#include "../../cproofs/common.h"

int main()
{
	FILE *f;

	for (int k = 0; k < 1; k++)
	{
		char filename[128];
		snprintf(filename, 128, "testdata_%d.hex", k);
		f = fopen(filename, "w");

		for (int i = 0; i < 10000; i++)
		{
			uint32_t din_insn;
			uint32_t din_rs1 = xorshift32();
			uint32_t din_rs2 = xorshift32();
			uint32_t dout_rd;

			switch (xorshift32() % 21)
			{
			case 0: // REV
				din_insn = 0x69f05013;
				dout_rd = rv32b::rev(din_rs1);
				break;
			case 1: // REV8
				din_insn = 0x69805013;
				dout_rd = rv32b::rev8(din_rs1);
				break;
			case 2: // ORC.B
				din_insn = 0x28705013;
				din_rs1 &= xorshift32();
				din_rs1 &= xorshift32();
				dout_rd = rv32b::orc_b(din_rs1);
				break;
			case 3: // CLZ
				din_insn = 0x60001013;
				dout_rd = rv32b::clz(din_rs1);
				break;
			case 4: // CTZ
				din_insn = 0x60101013;
				dout_rd = rv32b::ctz(din_rs1);
				break;
			case 5: // PCNT
				din_insn = 0x60201013;
				dout_rd = rv32b::pcnt(din_rs1);
				break;
			case 6: // SLL
				din_insn = 0x00001033;
				dout_rd = rv32b::sll(din_rs1, din_rs2);
				break;
			case 7: // SRL
				din_insn = 0x00005033;
				dout_rd = rv32b::srl(din_rs1, din_rs2);
				break;
			case 8: // SRA
				din_insn = 0x40005033;
				dout_rd = rv32b::sra(din_rs1, din_rs2);
				break;
			case 9: // SLO
				din_insn = 0x20001033;
				dout_rd = rv32b::slo(din_rs1, din_rs2);
				break;
			case 10: // SRO
				din_insn = 0x20005033;
				dout_rd = rv32b::sro(din_rs1, din_rs2);
				break;
			case 11: // ROL
				din_insn = 0x60001033;
				dout_rd = rv32b::rol(din_rs1, din_rs2);
				break;
			case 12: // ROR
				din_insn = 0x60005033;
				dout_rd = rv32b::ror(din_rs1, din_rs2);
				break;
			case 13: // MIN
				din_insn = 0x0a004033;
				dout_rd = rv32b::min(din_rs1, din_rs2);
				break;
			case 14: // MAX
				din_insn = 0x0a005033;
				dout_rd = rv32b::max(din_rs1, din_rs2);
				break;
			case 15: // MINU
				din_insn = 0x0a006033;
				dout_rd =  rv32b::minu(din_rs1, din_rs2);
				break;
			case 16: // MAXU
				din_insn = 0x0a007033;
				dout_rd =  rv32b::maxu(din_rs1, din_rs2);
				break;
			case 17: // ANDN
				din_insn = 0x40007033;
				dout_rd = rv32b::andn(din_rs1, din_rs2);
				break;
			case 18: // ORN
				din_insn = 0x40006033;
				dout_rd = rv32b::orn(din_rs1, din_rs2);
				break;
			case 19: // XNOR
				din_insn = 0x40004033;
				dout_rd = rv32b::xnor(din_rs1, din_rs2);
				break;
			case 20: // PACK
				din_insn = 0x08004033;
				dout_rd = rv32b::pack(din_rs1, din_rs2);
				break;
			}
			fprintf(f, "%08llx_%08llx_%08llx_%08llx\n", (long long)din_insn,
					(long long)din_rs1, (long long)din_rs2, (long long)dout_rd);
		}
		fclose(f);
	}

	return 0;
}
