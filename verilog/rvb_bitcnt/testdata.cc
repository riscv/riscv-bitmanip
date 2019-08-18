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

	for (int k = 0; k < 4; k++)
	{
		char filename[128];
		snprintf(filename, 128, "testdata_%d.hex", k);
		f = fopen(filename, "w");

		bool enable_64bit = (k & 1) == 0;
		bool enable_bmat = (k & 2) != 0;

		for (int i = 0; i < 1000; i++)
		{
			uint32_t din_insn;
			uint64_t din_rs1 = xorshift64();
			uint64_t dout_rd;

			switch (xorshift32() % 7)
			{
			case 0: // CLZ
				if (!enable_64bit) { i--; continue; }
				din_insn = 0x60001013;
				dout_rd = rv64b::clz(din_rs1);
				break;
			case 1: // CLZW
				din_insn = 0x60001013 | (enable_64bit ? 8 : 0);
				dout_rd = int32_t(rv32b::clz(din_rs1));
				break;
			case 2: // CTZ
				if (!enable_64bit) { i--; continue; }
				din_insn = 0x60101013;
				dout_rd = rv64b::ctz(din_rs1);
				break;
			case 3: // CTZW
				din_insn = 0x60101013 | (enable_64bit ? 8 : 0);
				dout_rd = int32_t(rv32b::ctz(din_rs1));
				break;
			case 4: // PCNT
				if (!enable_64bit) { i--; continue; }
				din_insn = 0x60201013;
				dout_rd = rv64b::pcnt(din_rs1);
				break;
			case 5: // PCNTW
				din_insn = 0x60201013 | (enable_64bit ? 8 : 0);
				dout_rd = int32_t(rv32b::pcnt(din_rs1));
				break;
			case 6: // BMATFLIP
				if (!enable_64bit) { i--; continue; }
				if (!enable_bmat) { i--; continue; }
				din_insn = 0x60301013;
				dout_rd = rv64b::bmatflip(din_rs1);
				break;
			}
			fprintf(f, "%08llx_%016llx_%016llx\n", (long long)din_insn,
					(long long)din_rs1, (long long)dout_rd);
		}
		fclose(f);
	}

	return 0;
}
