/*
 *  Copyright (C) 2019  Clifford Wolf <clifford@clifford.at>
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

	for (int k = 0; k < 2; k++)
	{
		char filename[128];
		snprintf(filename, 128, "testdata_%d.hex", k);
		f = fopen(filename, "w");

		bool enable_64bit = (k & 1) == 0;

		for (int i = 0; i < 1000; i++)
		{
			uint32_t din_insn;
			uint64_t din_rs1 = xorshift64();
			uint64_t din_rs2 = xorshift64();
			uint64_t din_rs3 = xorshift64();
			uint64_t dout_rd;

			switch (xorshift32() % 19)
			{
			case 0: // MIN
				din_insn = 0x0a004033;
				dout_rd = enable_64bit ? rv64b::min(din_rs1, din_rs2) : rv32b::min(din_rs1, din_rs2);
				break;
			case 1: // MAX
				din_insn = 0x0a005033;
				dout_rd = enable_64bit ? rv64b::max(din_rs1, din_rs2) : rv32b::max(din_rs1, din_rs2);
				break;
			case 2: // MINU
				din_insn = 0x0a006033;
				dout_rd = enable_64bit ? rv64b::minu(din_rs1, din_rs2) : rv32b::minu(din_rs1, din_rs2);
				break;
			case 3: // MAXU
				din_insn = 0x0a007033;
				dout_rd = enable_64bit ? rv64b::maxu(din_rs1, din_rs2) : rv32b::maxu(din_rs1, din_rs2);
				break;
			case 4: // ANDN
				din_insn = 0x40007033;
				dout_rd = rv64b::andn(din_rs1, din_rs2);
				break;
			case 5: // ORN
				din_insn = 0x40006033;
				dout_rd = rv64b::orn(din_rs1, din_rs2);
				break;
			case 6: // XNOR
				din_insn = 0x40004033;
				dout_rd = rv64b::xnor(din_rs1, din_rs2);
				break;
			case 7: // PACK
				if (!enable_64bit) { i--; continue; }
				din_insn = 0x08004033;
				dout_rd = rv64b::pack(din_rs1, din_rs2);
				break;
			case 8: // PACKW
				din_insn = 0x08004033 | (enable_64bit ? 8 : 0);
				dout_rd = int32_t(rv32b::pack(din_rs1, din_rs2));
				break;
			case 9: // PACKH
				din_insn = 0x08007033;
				dout_rd = rv64b::packh(din_rs1, din_rs2);
				break;
			case 10: // PACKU
				if (!enable_64bit) { i--; continue; }
				din_insn = 0x48004033;
				dout_rd = rv64b::packu(din_rs1, din_rs2);
				break;
			case 11: // PACKUW
				din_insn = 0x48004033 | (enable_64bit ? 8 : 0);
				dout_rd = int32_t(rv32b::packu(din_rs1, din_rs2));
				break;
			case 12: // CMIX
				din_insn = 0x06001033;
				dout_rd = rv64b::cmix(din_rs1, din_rs2, din_rs3);
				break;
			case 13: // CMOV
				din_insn = 0x06005033;
				dout_rd =  rv64b::cmov(din_rs1, din_rs2, din_rs3);
				break;
			case 14: // ADDIWU
				if (!enable_64bit) { i--; continue; }
				din_insn = 0x0000401b;
				dout_rd =  rv64b::addwu(din_rs1, din_rs2);
				break;
			case 15: // ADDWU
				if (!enable_64bit) { i--; continue; }
				din_insn = 0x0a00003b;
				dout_rd =  rv64b::addwu(din_rs1, din_rs2);
				break;
			case 16: // SUBWU
				if (!enable_64bit) { i--; continue; }
				din_insn = 0x4a00003b;
				dout_rd =  rv64b::subwu(din_rs1, din_rs2);
				break;
			case 17: // ADDUW
				if (!enable_64bit) { i--; continue; }
				din_insn = 0x0800003b;
				dout_rd =  rv64b::adduw(din_rs1, din_rs2);
				break;
			case 18: // SUBUW
				if (!enable_64bit) { i--; continue; }
				din_insn = 0x4800003b;
				dout_rd =  rv64b::subuw(din_rs1, din_rs2);
				break;
			}
			fprintf(f, "%08llx_%016llx_%016llx_%016llx_%016llx\n", (long long)din_insn,
					(long long)din_rs1, (long long)din_rs2, (long long)din_rs3, (long long)dout_rd);
		}
		fclose(f);
	}

	return 0;
}
