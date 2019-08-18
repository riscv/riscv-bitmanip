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

	for (int k = 0; k < 8; k++)
	{
		char filename[128];
		snprintf(filename, 128, "testdata_%d.hex", k);
		f = fopen(filename, "w");

		bool enable_64bit = (k & 1) == 0;
		bool enable_sbop = (k & 2) != 0;
		bool enable_bfp = (k & 4) != 0;

		for (int i = 0; i < 1000; i++)
		{
			uint32_t din_insn;
			uint64_t din_rs1 = xorshift64();
			uint64_t din_rs2 = xorshift64();
			uint64_t din_rs3 = xorshift64();
			uint64_t dout_rd;

			switch (xorshift32() % 28)
			{
			case 0: // SLL
				if (!enable_64bit) { i--; continue; }
				din_insn = 0x00001033;
				dout_rd = rv64b::sll(din_rs1, din_rs2);
				break;
			case 1: // SLLW
				din_insn = 0x00001033 | (enable_64bit ? 8 : 0);
				dout_rd = int32_t(rv32b::sll(din_rs1, din_rs2));
				break;
			case 2: // SRL
				if (!enable_64bit) { i--; continue; }
				din_insn = 0x00005033;
				dout_rd = rv64b::srl(din_rs1, din_rs2);
				break;
			case 3: // SRLW
				din_insn = 0x00005033 | (enable_64bit ? 8 : 0);
				dout_rd = int32_t(rv32b::srl(din_rs1, din_rs2));
				break;
			case 4: // SRA
				if (!enable_64bit) { i--; continue; }
				din_insn = 0x40005033;
				dout_rd = rv64b::sra(din_rs1, din_rs2);
				break;
			case 5: // SRAW
				din_insn = 0x40005033 | (enable_64bit ? 8 : 0);
				dout_rd = int32_t(rv32b::sra(din_rs1, din_rs2));
				break;
			case 6: // SLO
				if (!enable_64bit) { i--; continue; }
				din_insn = 0x20001033;
				dout_rd = rv64b::slo(din_rs1, din_rs2);
				break;
			case 7: // SLOW
				din_insn = 0x20001033 | (enable_64bit ? 8 : 0);
				dout_rd = int32_t(rv32b::slo(din_rs1, din_rs2));
				break;
			case 8: // SRO
				if (!enable_64bit) { i--; continue; }
				din_insn = 0x20005033;
				dout_rd = rv64b::sro(din_rs1, din_rs2);
				break;
			case 9: // SROW
				din_insn = 0x20005033 | (enable_64bit ? 8 : 0);
				dout_rd = int32_t(rv32b::sro(din_rs1, din_rs2));
				break;
			case 10: // ROL
				if (!enable_64bit) { i--; continue; }
				din_insn = 0x60001033;
				dout_rd = rv64b::rol(din_rs1, din_rs2);
				break;
			case 11: // ROLW
				din_insn = 0x60001033 | (enable_64bit ? 8 : 0);
				dout_rd = int32_t(rv32b::rol(din_rs1, din_rs2));
				break;
			case 12: // ROR
				if (!enable_64bit) { i--; continue; }
				din_insn = 0x60005033;
				dout_rd = rv64b::ror(din_rs1, din_rs2);
				break;
			case 13: // RORW
				din_insn = 0x60005033 | (enable_64bit ? 8 : 0);
				dout_rd = int32_t(rv32b::ror(din_rs1, din_rs2));
				break;
			case 14: // FSL
				if (!enable_64bit) { i--; continue; }
				din_insn = 0x04001033;
				dout_rd = rv64b::fsl(din_rs1, din_rs2, din_rs3);
				break;
			case 15: // FSLW
				din_insn = 0x04001033 | (enable_64bit ? 8 : 0);
				dout_rd = int32_t(rv32b::fsl(din_rs1, din_rs2, din_rs3));
				break;
			case 16: // FSR
				if (!enable_64bit) { i--; continue; }
				din_insn = 0x04005033;
				dout_rd = rv64b::fsr(din_rs1, din_rs2, din_rs3);
				break;
			case 17: // FSRW
				din_insn = 0x04005033 | (enable_64bit ? 8 : 0);
				dout_rd = int32_t(rv32b::fsr(din_rs1, din_rs2, din_rs3));
				break;
			case 18: // SBSET
				if (!enable_sbop) { i--; continue; }
				if (!enable_64bit) { i--; continue; }
				din_insn = 0x28001033;
				dout_rd = rv64b::sbset(din_rs1, din_rs2);
				break;
			case 19: // SBSETW
				if (!enable_sbop) { i--; continue; }
				din_insn = 0x28001033 | (enable_64bit ? 8 : 0);
				dout_rd = int32_t(rv32b::sbset(din_rs1, din_rs2));
				break;
			case 20: // SBCLR
				if (!enable_sbop) { i--; continue; }
				if (!enable_64bit) { i--; continue; }
				din_insn = 0x48001033;
				dout_rd = rv64b::sbclr(din_rs1, din_rs2);
				break;
			case 21: // SBCLRW
				if (!enable_sbop) { i--; continue; }
				din_insn = 0x48001033 | (enable_64bit ? 8 : 0);
				dout_rd = int32_t(rv32b::sbclr(din_rs1, din_rs2));
				break;
			case 22: // SBINV
				if (!enable_sbop) { i--; continue; }
				if (!enable_64bit) { i--; continue; }
				din_insn = 0x68001033;
				dout_rd = rv64b::sbinv(din_rs1, din_rs2);
				break;
			case 23: // SBINVW
				if (!enable_sbop) { i--; continue; }
				din_insn = 0x68001033 | (enable_64bit ? 8 : 0);
				dout_rd = int32_t(rv32b::sbinv(din_rs1, din_rs2));
				break;
			case 24: // SBEXT
				if (!enable_sbop) { i--; continue; }
				if (!enable_64bit) { i--; continue; }
				din_insn = 0x48005033;
				dout_rd = rv64b::sbext(din_rs1, din_rs2);
				break;
			case 25: // SBEXTW
				if (!enable_sbop) { i--; continue; }
				din_insn = 0x48005033 | (enable_64bit ? 8 : 0);
				dout_rd = int32_t(rv32b::sbext(din_rs1, din_rs2));
				break;
			case 26: // BFP
				if (!enable_bfp) { i--; continue; }
				if (!enable_64bit) { i--; continue; }
				din_insn = 0x48004033;
				dout_rd = rv64b::bfp(din_rs1, din_rs2);
				break;
			case 27: // BFPW
				if (!enable_bfp) { i--; continue; }
				din_insn = 0x48004033 | (enable_64bit ? 8 : 0);
				dout_rd = int32_t(rv32b::bfp(din_rs1, din_rs2));
				break;
			}
			fprintf(f, "%08llx_%016llx_%016llx_%016llx_%016llx\n", (long long)din_insn,
					(long long)din_rs1, (long long)din_rs2, (long long)din_rs3, (long long)dout_rd);
		}
		fclose(f);
	}

	return 0;
}
