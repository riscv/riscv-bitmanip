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

		for (int i = 0; i < 10000; i++)
		{
			uint32_t din_insn;
			uint64_t din_rs1 = xorshift64();
			uint64_t din_rs2 = xorshift64();
			uint64_t din_rs3 = xorshift64();
			uint64_t dout_rd;

			switch (xorshift32() % 80)
			{
			case 0: // BDEP
				if (!enable_64bit) { i--; continue; }
				din_insn = 0x08002033;
				dout_rd = rv64b::bdep(din_rs1, din_rs2);
				break;
			case 1: // BEXT
				if (!enable_64bit) { i--; continue; }
				din_insn = 0x08006033;
				dout_rd = rv64b::bext(din_rs1, din_rs2);
				break;
			case 2: // SHFL
				if (!enable_64bit) { i--; continue; }
				din_insn = 0x08001033;
				dout_rd = rv64b::shfl(din_rs1, din_rs2);
				break;
			case 3: // UNSHFL
				if (!enable_64bit) { i--; continue; }
				din_insn = 0x08005033;
				dout_rd = rv64b::unshfl(din_rs1, din_rs2);
				break;
			case 4: // GORC
				if (!enable_64bit) { i--; continue; }
				din_insn = 0x28005033;
				dout_rd = rv64b::gorc(din_rs1, din_rs2);
				break;
			case 5: // GREV
				if (!enable_64bit) { i--; continue; }
				din_insn = 0x68005033;
				dout_rd = rv64b::grev(din_rs1, din_rs2);
				break;
			case 6: // BDEPW
				din_insn = enable_64bit ? 0x0800203b : 0x08002033;
				dout_rd = int32_t(rv32b::bdep(din_rs1, din_rs2));
				break;
			case 7: // BEXTW
				din_insn = enable_64bit ? 0x0800603b : 0x08006033;
				dout_rd = int32_t(rv32b::bext(din_rs1, din_rs2));
				break;
			case 8: // SHFLW
				din_insn = enable_64bit ? 0x0800103b : 0x08001033;
				dout_rd = int32_t(rv32b::shfl(din_rs1, din_rs2));
				break;
			case 9: // UNSHFLW
				din_insn = enable_64bit ? 0x0800503b : 0x08005033;
				dout_rd = int32_t(rv32b::unshfl(din_rs1, din_rs2));
				break;
			case 10: // GORCW
				din_insn = 0x28005033 | (enable_64bit ? 8 : 0);
				dout_rd = int32_t(rv32b::gorc(din_rs1, din_rs2));
				break;
			case 11: // GREVW
				din_insn = 0x68005033 | (enable_64bit ? 8 : 0);
				dout_rd = int32_t(rv32b::grev(din_rs1, din_rs2));
				break;
			case 12: // CLZ
				if (!enable_64bit) { i--; continue; }
				din_insn = 0x60001013;
				dout_rd = rv64b::clz(din_rs1);
				break;
			case 13: // CLZW
				din_insn = 0x60001013 | (enable_64bit ? 8 : 0);
				dout_rd = int32_t(rv32b::clz(din_rs1));
				break;
			case 14: // CTZ
				if (!enable_64bit) { i--; continue; }
				din_insn = 0x60101013;
				dout_rd = rv64b::ctz(din_rs1);
				break;
			case 15: // CTZW
				din_insn = 0x60101013 | (enable_64bit ? 8 : 0);
				dout_rd = int32_t(rv32b::ctz(din_rs1));
				break;
			case 16: // PCNT
				if (!enable_64bit) { i--; continue; }
				din_insn = 0x60201013;
				dout_rd = rv64b::pcnt(din_rs1);
				break;
			case 17: // PCNTW
				din_insn = 0x60201013 | (enable_64bit ? 8 : 0);
				dout_rd = int32_t(rv32b::pcnt(din_rs1));
				break;
			case 18: // BMATFLIP
				if (!enable_64bit) { i--; continue; }
				din_insn = 0x60301013;
				dout_rd = rv64b::bmatflip(din_rs1);
				break;
			case 19: // BMATXOR
				if (!enable_64bit) { i--; continue; }
				din_insn = 0x48003033;
				dout_rd = rv64b::bmatxor(din_rs1, din_rs2);
				break;
			case 20: // BMATOR
				if (!enable_64bit) { i--; continue; }
				din_insn = 0x08003033;
				dout_rd = rv64b::bmator(din_rs1, din_rs2);
				break;
			case 21: // CLMUL
				if (!enable_64bit) { i--; continue; }
				din_insn = 0x0a001033;
				dout_rd = rv64b::clmul(din_rs1, din_rs2);
				break;
			case 22: // CLMULR
				if (!enable_64bit) { i--; continue; }
				din_insn = 0x0a002033;
				dout_rd = rv64b::clmulr(din_rs1, din_rs2);
				break;
			case 23: // CLMULH
				if (!enable_64bit) { i--; continue; }
				din_insn = 0x0a003033;
				dout_rd = rv64b::clmulh(din_rs1, din_rs2);
				break;
			case 24: // CLMULW
				din_insn = enable_64bit ? 0x0a00103b : 0x0a001033;
				dout_rd = int32_t(rv32b::clmul(din_rs1, din_rs2));
				break;
			case 25: // CLMULRW
				din_insn = enable_64bit ? 0x0a00203b : 0x0a002033;
				dout_rd = int32_t(rv32b::clmulr(din_rs1, din_rs2));
				break;
			case 26: // CLMULHW
				din_insn = enable_64bit ? 0x0a00303b : 0x0a003033;
				dout_rd = int32_t(rv32b::clmulh(din_rs1, din_rs2));
				break;
			case 27: // SLL
				if (!enable_64bit) { i--; continue; }
				din_insn = 0x00001033;
				dout_rd = rv64b::sll(din_rs1, din_rs2);
				break;
			case 28: // SLLW
				din_insn = 0x00001033 | (enable_64bit ? 8 : 0);
				dout_rd = int32_t(rv32b::sll(din_rs1, din_rs2));
				break;
			case 29: // SRL
				if (!enable_64bit) { i--; continue; }
				din_insn = 0x00005033;
				dout_rd = rv64b::srl(din_rs1, din_rs2);
				break;
			case 30: // SRLW
				din_insn = 0x00005033 | (enable_64bit ? 8 : 0);
				dout_rd = int32_t(rv32b::srl(din_rs1, din_rs2));
				break;
			case 31: // SRA
				if (!enable_64bit) { i--; continue; }
				din_insn = 0x40005033;
				dout_rd = rv64b::sra(din_rs1, din_rs2);
				break;
			case 32: // SRAW
				din_insn = 0x40005033 | (enable_64bit ? 8 : 0);
				dout_rd = int32_t(rv32b::sra(din_rs1, din_rs2));
				break;
			case 33: // SLO
				if (!enable_64bit) { i--; continue; }
				din_insn = 0x20001033;
				dout_rd = rv64b::slo(din_rs1, din_rs2);
				break;
			case 34: // SLOW
				din_insn = 0x20001033 | (enable_64bit ? 8 : 0);
				dout_rd = int32_t(rv32b::slo(din_rs1, din_rs2));
				break;
			case 35: // SRO
				if (!enable_64bit) { i--; continue; }
				din_insn = 0x20005033;
				dout_rd = rv64b::sro(din_rs1, din_rs2);
				break;
			case 36: // SROW
				din_insn = 0x20005033 | (enable_64bit ? 8 : 0);
				dout_rd = int32_t(rv32b::sro(din_rs1, din_rs2));
				break;
			case 37: // ROL
				if (!enable_64bit) { i--; continue; }
				din_insn = 0x60001033;
				dout_rd = rv64b::rol(din_rs1, din_rs2);
				break;
			case 38: // ROLW
				din_insn = 0x60001033 | (enable_64bit ? 8 : 0);
				dout_rd = int32_t(rv32b::rol(din_rs1, din_rs2));
				break;
			case 39: // ROR
				if (!enable_64bit) { i--; continue; }
				din_insn = 0x60005033;
				dout_rd = rv64b::ror(din_rs1, din_rs2);
				break;
			case 40: // RORW
				din_insn = 0x60005033 | (enable_64bit ? 8 : 0);
				dout_rd = int32_t(rv32b::ror(din_rs1, din_rs2));
				break;
			case 41: // FSL
				if (!enable_64bit) { i--; continue; }
				din_insn = 0x04001033;
				dout_rd = rv64b::fsl(din_rs1, din_rs2, din_rs3);
				break;
			case 42: // FSLW
				din_insn = 0x04001033 | (enable_64bit ? 8 : 0);
				dout_rd = int32_t(rv32b::fsl(din_rs1, din_rs2, din_rs3));
				break;
			case 43: // FSR
				if (!enable_64bit) { i--; continue; }
				din_insn = 0x04005033;
				dout_rd = rv64b::fsr(din_rs1, din_rs2, din_rs3);
				break;
			case 44: // FSRW
				din_insn = 0x04005033 | (enable_64bit ? 8 : 0);
				dout_rd = int32_t(rv32b::fsr(din_rs1, din_rs2, din_rs3));
				break;
			case 45: // SBSET
				if (!enable_64bit) { i--; continue; }
				din_insn = 0x28001033;
				dout_rd = rv64b::sbset(din_rs1, din_rs2);
				break;
			case 46: // SBSETW
				din_insn = 0x28001033 | (enable_64bit ? 8 : 0);
				dout_rd = int32_t(rv32b::sbset(din_rs1, din_rs2));
				break;
			case 47: // SBCLR
				if (!enable_64bit) { i--; continue; }
				din_insn = 0x48001033;
				dout_rd = rv64b::sbclr(din_rs1, din_rs2);
				break;
			case 48: // SBCLRW
				din_insn = 0x48001033 | (enable_64bit ? 8 : 0);
				dout_rd = int32_t(rv32b::sbclr(din_rs1, din_rs2));
				break;
			case 49: // SBINV
				if (!enable_64bit) { i--; continue; }
				din_insn = 0x68001033;
				dout_rd = rv64b::sbinv(din_rs1, din_rs2);
				break;
			case 50: // SBINVW
				din_insn = 0x68001033 | (enable_64bit ? 8 : 0);
				dout_rd = int32_t(rv32b::sbinv(din_rs1, din_rs2));
				break;
			case 51: // SBEXT
				if (!enable_64bit) { i--; continue; }
				din_insn = 0x48005033;
				dout_rd = rv64b::sbext(din_rs1, din_rs2);
				break;
			case 52: // SBEXTW
				din_insn = 0x48005033 | (enable_64bit ? 8 : 0);
				dout_rd = int32_t(rv32b::sbext(din_rs1, din_rs2));
				break;
			case 53: // BFP
				if (!enable_64bit) { i--; continue; }
				din_insn = 0x08007033;
				dout_rd = rv64b::bfp(din_rs1, din_rs2);
				break;
			case 54: // BFPW
				din_insn = 0x08007033 | (enable_64bit ? 8 : 0);
				dout_rd = int32_t(rv32b::bfp(din_rs1, din_rs2));
				break;
			case 55: // MIN
				din_insn = 0x0a004033;
				dout_rd = enable_64bit ? rv64b::min(din_rs1, din_rs2) : rv32b::min(din_rs1, din_rs2);
				break;
			case 56: // MAX
				din_insn = 0x0a005033;
				dout_rd = enable_64bit ? rv64b::max(din_rs1, din_rs2) : rv32b::max(din_rs1, din_rs2);
				break;
			case 57: // MINU
				din_insn = 0x0a006033;
				dout_rd = enable_64bit ? rv64b::minu(din_rs1, din_rs2) : rv32b::minu(din_rs1, din_rs2);
				break;
			case 58: // MAXU
				din_insn = 0x0a007033;
				dout_rd = enable_64bit ? rv64b::maxu(din_rs1, din_rs2) : rv32b::maxu(din_rs1, din_rs2);
				break;
			case 59: // ANDN
				din_insn = 0x40007033;
				dout_rd = rv64b::andn(din_rs1, din_rs2);
				break;
			case 60: // ORN
				din_insn = 0x40006033;
				dout_rd = rv64b::orn(din_rs1, din_rs2);
				break;
			case 61: // XNOR
				din_insn = 0x40004033;
				dout_rd = rv64b::xnor(din_rs1, din_rs2);
				break;
			case 62: // PACK
				if (!enable_64bit) { i--; continue; }
				din_insn = 0x08004033;
				dout_rd = rv64b::pack(din_rs1, din_rs2);
				break;
			case 63: // PACKW
				din_insn = 0x08004033 | (enable_64bit ? 8 : 0);
				dout_rd = int32_t(rv32b::pack(din_rs1, din_rs2));
				break;
			case 64: // CMIX
				din_insn = 0x06001033;
				dout_rd = rv64b::cmix(din_rs1, din_rs2, din_rs3);
				break;
			case 65: // CMOV
				din_insn = 0x06005033;
				dout_rd =  rv64b::cmov(din_rs1, din_rs2, din_rs3);
				break;
			case 66: // ADDIWU
				if (!enable_64bit) { i--; continue; }
				din_insn = 0x0000401b | din_rs2 << 20;
				dout_rd =  rv64b::addwu(din_rs1, (int64_t(din_rs2) << 52) >> 52);
				break;
			case 67: // SLLIUW
				if (!enable_64bit) { i--; continue; }
				din_insn = 0x0800101b | (din_rs2 & 63) << 20;
				dout_rd =  rv64b::slliuw(din_rs1, din_rs2);
				break;
			case 68: // ADDWU
				if (!enable_64bit) { i--; continue; }
				din_insn = 0x0a00003b;
				dout_rd =  rv64b::addwu(din_rs1, din_rs2);
				break;
			case 69: // SUBWU
				if (!enable_64bit) { i--; continue; }
				din_insn = 0x4a00003b;
				dout_rd =  rv64b::subwu(din_rs1, din_rs2);
				break;
			case 70: // ADDUW
				if (!enable_64bit) { i--; continue; }
				din_insn = 0x0800003b;
				dout_rd =  rv64b::adduw(din_rs1, din_rs2);
				break;
			case 71: // SUBUW
				if (!enable_64bit) { i--; continue; }
				din_insn = 0x4800003b;
				dout_rd =  rv64b::subuw(din_rs1, din_rs2);
				break;
			case 72: // CRC32.B
				din_insn = 0x61001013;
				if (!enable_64bit) din_rs1 &= 0xFFFFFFFFLL;
				dout_rd = rv64b::crc32_b(din_rs1);
				break;
			case 73: // CRC32.H
				din_insn = 0x61101013;
				if (!enable_64bit) din_rs1 &= 0xFFFFFFFFLL;
				dout_rd = rv64b::crc32_h(din_rs1);
				break;
			case 74: // CRC32.W
				din_insn = 0x61201013;
				if (!enable_64bit) din_rs1 &= 0xFFFFFFFFLL;
				dout_rd = rv64b::crc32_w(din_rs1);
				break;
			case 75: // CRC32.D
				if (!enable_64bit) { i--; continue; }
				din_insn = 0x61301013;
				dout_rd = rv64b::crc32_d(din_rs1);
				break;
			case 76: // CRC32C.B
				din_insn = 0x61801013;
				if (!enable_64bit) din_rs1 &= 0xFFFFFFFFLL;
				dout_rd = rv64b::crc32c_b(din_rs1);
				break;
			case 77: // CRC32C.H
				din_insn = 0x61901013;
				if (!enable_64bit) din_rs1 &= 0xFFFFFFFFLL;
				dout_rd = rv64b::crc32c_h(din_rs1);
				break;
			case 78: // CRC32C.W
				din_insn = 0x61a01013;
				if (!enable_64bit) din_rs1 &= 0xFFFFFFFFLL;
				dout_rd = rv64b::crc32c_w(din_rs1);
				break;
			case 79: // CRC32C.D
				if (!enable_64bit) { i--; continue; }
				din_insn = 0x61b01013;
				dout_rd = rv64b::crc32c_d(din_rs1);
				break;
			}
			fprintf(f, "%08llx_%016llx_%016llx_%016llx_%016llx\n", (long long)din_insn,
					(long long)din_rs1, (long long)din_rs2, (long long)din_rs3, (long long)dout_rd);
		}
		fclose(f);
	}

	return 0;
}
