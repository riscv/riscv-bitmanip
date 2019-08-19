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

module rvb_full #(
	parameter integer XLEN = 64
) (
	// control signals
	input             clock,          // positive edge clock
	input             reset,          // synchronous reset

	// data input
	input             din_valid,      // input is valid
	output            din_ready,      // core accepts input
	input  [XLEN-1:0] din_rs1,        // value of 1st argument
	input  [XLEN-1:0] din_rs2,        // value of 2nd argument
	input  [XLEN-1:0] din_rs3,        // value of 3rd argument
	input      [31:0] din_insn,       // value of instruction word

	// data output
	output            dout_valid,     // output is valid
	input             dout_ready,     // accept output
	output [XLEN-1:0] dout_rd         // output value
);
	wire insn_bextdep;
	wire insn_bitcnt;
	wire insn_bmatxor;
	wire insn_clmul;
	wire insn_shifter;
	wire insn_simple;
	wire insn_crc;

	wire [XLEN-1:0] imm = $signed(din_insn[31:20]);
	wire [XLEN-1:0] rs2 = din_insn[5] ? din_rs2 : imm;

	rvb_full_decoder decoder (
		.insn        (din_insn    ),
		.insn_bextdep(insn_bextdep),
		.insn_bitcnt (insn_bitcnt ),
		.insn_bmatxor(insn_bmatxor),
		.insn_clmul  (insn_clmul  ),
		.insn_shifter(insn_shifter),
		.insn_simple (insn_simple ),
		.insn_crc    (insn_crc    )
	);
endmodule

module rvb_full_decoder (
	input [31:0] insn,
	output reg insn_bextdep,
	output reg insn_bitcnt,
	output reg insn_bmatxor,
	output reg insn_clmul,
	output reg insn_shifter,
	output reg insn_simple,
	output reg insn_crc
);
	always @* begin
		insn_bextdep = 0;
		insn_bitcnt  = 0;
		insn_bmatxor = 0;
		insn_clmul   = 0;
		insn_shifter = 0;
		insn_simple  = 0;
		insn_crc     = 0;

		casez (insn)
			32'b 0100000_zzzzz_zzzzz_111_zzzzz_0110011: insn_simple = 1;  // ANDN
			32'b 0100000_zzzzz_zzzzz_110_zzzzz_0110011: insn_simple = 1;  // ORN
			32'b 0100000_zzzzz_zzzzz_100_zzzzz_0110011: insn_simple = 1;  // XNOR

			32'b 0000000_zzzzz_zzzzz_001_zzzzz_0110011: insn_shifter = 1; // SLL
			32'b 0000000_zzzzz_zzzzz_101_zzzzz_0110011: insn_shifter = 1; // SRL
			32'b 0100000_zzzzz_zzzzz_001_zzzzz_0110011: insn_bextdep = 1; // GREV
			32'b 0100000_zzzzz_zzzzz_101_zzzzz_0110011: insn_shifter = 1; // SRA
			32'b 0010000_zzzzz_zzzzz_001_zzzzz_0110011: insn_shifter = 1; // SLO
			32'b 0010000_zzzzz_zzzzz_101_zzzzz_0110011: insn_shifter = 1; // SRO
			32'b 0110000_zzzzz_zzzzz_001_zzzzz_0110011: insn_shifter = 1; // ROL
			32'b 0110000_zzzzz_zzzzz_101_zzzzz_0110011: insn_shifter = 1; // ROR

			32'b 0010100_zzzzz_zzzzz_001_zzzzz_0110011: insn_shifter = 1; // SBSET
			32'b 0100100_zzzzz_zzzzz_001_zzzzz_0110011: insn_shifter = 1; // SBCLR
			32'b 0110100_zzzzz_zzzzz_001_zzzzz_0110011: insn_shifter = 1; // SBINV
			32'b 0100100_zzzzz_zzzzz_101_zzzzz_0110011: insn_shifter = 1; // SBEXT

			32'b 00000_0zzzzzz_zzzzz_001_zzzzz_0010011: insn_shifter = 1; // SLLI
			32'b 00000_0zzzzzz_zzzzz_101_zzzzz_0010011: insn_shifter = 1; // SRLI
			32'b 01000_0zzzzzz_zzzzz_001_zzzzz_0010011: insn_bextdep = 1; // GREVI
			32'b 01000_0zzzzzz_zzzzz_101_zzzzz_0010011: insn_shifter = 1; // SRAI
			32'b 00100_0zzzzzz_zzzzz_001_zzzzz_0010011: insn_shifter = 1; // SLOI
			32'b 00100_0zzzzzz_zzzzz_101_zzzzz_0010011: insn_shifter = 1; // SROI
			32'b 01100_0zzzzzz_zzzzz_101_zzzzz_0010011: insn_shifter = 1; // RORI

			32'b 00101_0zzzzzz_zzzzz_001_zzzzz_0010011: insn_shifter = 1; // SBSETI
			32'b 01001_0zzzzzz_zzzzz_001_zzzzz_0010011: insn_shifter = 1; // SBCLRI
			32'b 01101_0zzzzzz_zzzzz_001_zzzzz_0010011: insn_shifter = 1; // SBINVI
			32'b 01001_0zzzzzz_zzzzz_101_zzzzz_0010011: insn_shifter = 1; // SBEXTI

			32'b zzzzz11_zzzzz_zzzzz_001_zzzzz_0010011: insn_simple  = 1; // CMIX
			32'b zzzzz11_zzzzz_zzzzz_101_zzzzz_0010011: insn_simple  = 1; // CMOV
			32'b zzzzz10_zzzzz_zzzzz_001_zzzzz_0010011: insn_shifter = 1; // FSL
			32'b zzzzz10_zzzzz_zzzzz_101_zzzzz_0010011: insn_shifter = 1; // FSR
			32'b zzzzz1_zzzzzz_zzzzz_101_zzzzz_0010011: insn_shifter = 1; // FSRI

			32'b 0110000_00000_zzzzz_001_zzzzz_0010011: insn_bitcnt  = 1; // CLZ
			32'b 0110000_00001_zzzzz_001_zzzzz_0010011: insn_bitcnt  = 1; // CTZ
			32'b 0110000_00010_zzzzz_001_zzzzz_0010011: insn_bitcnt  = 1; // PCNT
			32'b 0110000_00011_zzzzz_001_zzzzz_0010011: insn_bitcnt  = 1; // BMATFLIP

			32'b 0110000_10000_zzzzz_001_zzzzz_0010011: insn_crc     = 1; // CRC32.B
			32'b 0110000_10001_zzzzz_001_zzzzz_0010011: insn_crc     = 1; // CRC32.H
			32'b 0110000_10010_zzzzz_001_zzzzz_0010011: insn_crc     = 1; // CRC32.W
			32'b 0110000_10011_zzzzz_001_zzzzz_0010011: insn_crc     = 1; // CRC32.D
			32'b 0110000_11000_zzzzz_001_zzzzz_0010011: insn_crc     = 1; // CRC32C.B
			32'b 0110000_11001_zzzzz_001_zzzzz_0010011: insn_crc     = 1; // CRC32C.H
			32'b 0110000_11010_zzzzz_001_zzzzz_0010011: insn_crc     = 1; // CRC32C.W
			32'b 0110000_11011_zzzzz_001_zzzzz_0010011: insn_crc     = 1; // CRC32C.D

			32'b 0000101_zzzzz_zzzzz_001_zzzzz_0110011: insn_clmul   = 1; // CLMUL
			32'b 0000101_zzzzz_zzzzz_010_zzzzz_0110011: insn_clmul   = 1; // CLMULR
			32'b 0000101_zzzzz_zzzzz_011_zzzzz_0110011: insn_clmul   = 1; // CLMULH
			32'b 0000101_zzzzz_zzzzz_100_zzzzz_0110011: insn_simple  = 1; // MIN
			32'b 0000101_zzzzz_zzzzz_101_zzzzz_0110011: insn_simple  = 1; // MAX
			32'b 0000101_zzzzz_zzzzz_110_zzzzz_0110011: insn_simple  = 1; // MINU
			32'b 0000101_zzzzz_zzzzz_111_zzzzz_0110011: insn_simple  = 1; // MAXU

			32'b 0000100_zzzzz_zzzzz_001_zzzzz_0110011: insn_bextdep = 1; // SHFL
			32'b 0000100_zzzzz_zzzzz_101_zzzzz_0110011: insn_bextdep = 1; // UNSHFL
			32'b 0000100_zzzzz_zzzzz_010_zzzzz_0110011: insn_bextdep = 1; // BDEP
			32'b 0000100_zzzzz_zzzzz_110_zzzzz_0110011: insn_bextdep = 1; // BEXT
			32'b 0000100_zzzzz_zzzzz_100_zzzzz_0110011: insn_simple  = 1; // PACK
			32'b 0000100_zzzzz_zzzzz_011_zzzzz_0110011: insn_bmatxor = 1; // BMATOR
			32'b 0000100_zzzzz_zzzzz_111_zzzzz_0110011: insn_bmatxor = 1; // BMATXOR

			32'b 000010_zzzzzz_zzzzz_001_zzzzz_0010011: insn_bextdep = 1; // SHFLI
			32'b 000010_zzzzzz_zzzzz_101_zzzzz_0010011: insn_bextdep = 1; // UNSHFLI

			32'b zzzzzz_zzzzzz_zzzzz_100_zzzzz_0011011: insn_simple  = 1; // ADDIWU
			32'b 00001_zzzzzzz_zzzzz_001_zzzzz_0011011: insn_shifter = 1; // SLLIU.W

			32'b 0000101_zzzzz_zzzzz_000_zzzzz_0111011: insn_simple  = 1; // ADDWU
			32'b 0100101_zzzzz_zzzzz_000_zzzzz_0111011: insn_simple  = 1; // SUBWU
			32'b 0000100_zzzzz_zzzzz_000_zzzzz_0111011: insn_simple  = 1; // ADDUW
			32'b 0100100_zzzzz_zzzzz_000_zzzzz_0111011: insn_simple  = 1; // SUBUW

			32'b 0000000_zzzzz_zzzzz_001_zzzzz_0111011: insn_shifter = 1; // SLLW
			32'b 0000000_zzzzz_zzzzz_101_zzzzz_0111011: insn_shifter = 1; // SRLW
			32'b 0100000_zzzzz_zzzzz_001_zzzzz_0111011: insn_bextdep = 1; // GREVW
			32'b 0100000_zzzzz_zzzzz_101_zzzzz_0111011: insn_shifter = 1; // SRAW
			32'b 0010000_zzzzz_zzzzz_001_zzzzz_0111011: insn_shifter = 1; // SLOW
			32'b 0010000_zzzzz_zzzzz_101_zzzzz_0111011: insn_shifter = 1; // SROW
			32'b 0110000_zzzzz_zzzzz_001_zzzzz_0111011: insn_shifter = 1; // ROLW
			32'b 0110000_zzzzz_zzzzz_101_zzzzz_0111011: insn_shifter = 1; // RORW

			32'b 0010100_zzzzz_zzzzz_001_zzzzz_0111011: insn_shifter = 1; // SBSETW
			32'b 0100100_zzzzz_zzzzz_001_zzzzz_0111011: insn_shifter = 1; // SBCLRW
			32'b 0110100_zzzzz_zzzzz_001_zzzzz_0111011: insn_shifter = 1; // SBINVW
			32'b 0100100_zzzzz_zzzzz_101_zzzzz_0111011: insn_shifter = 1; // SBEXTW

			32'b 00000_0zzzzzz_zzzzz_001_zzzzz_0011011: insn_shifter = 1; // SLLIW
			32'b 00000_0zzzzzz_zzzzz_101_zzzzz_0011011: insn_shifter = 1; // SRLIW
			32'b 01000_0zzzzzz_zzzzz_001_zzzzz_0011011: insn_bextdep = 1; // GREVIW
			32'b 01000_0zzzzzz_zzzzz_101_zzzzz_0011011: insn_shifter = 1; // SRAIW
			32'b 00100_0zzzzzz_zzzzz_001_zzzzz_0011011: insn_shifter = 1; // SLOIW
			32'b 00100_0zzzzzz_zzzzz_101_zzzzz_0011011: insn_shifter = 1; // SROIW
			32'b 01100_0zzzzzz_zzzzz_101_zzzzz_0011011: insn_shifter = 1; // RORIW

			32'b 00101_0zzzzzz_zzzzz_001_zzzzz_0011011: insn_shifter = 1; // SBSETIW
			32'b 01001_0zzzzzz_zzzzz_001_zzzzz_0011011: insn_shifter = 1; // SBCLRIW
			32'b 01101_0zzzzzz_zzzzz_001_zzzzz_0011011: insn_shifter = 1; // SBINVIW

			32'b zzzzz10_zzzzz_zzzzz_001_zzzzz_0011011: insn_shifter = 1; // FSLW
			32'b zzzzz10_zzzzz_zzzzz_101_zzzzz_0011011: insn_shifter = 1; // FSRW
			32'b zzzzz1_zzzzzz_zzzzz_101_zzzzz_0011011: insn_shifter = 1; // FSRIW

			32'b 0110000_00000_zzzzz_001_zzzzz_0011011: insn_bitcnt  = 1; // CLZW
			32'b 0110000_00001_zzzzz_001_zzzzz_0011011: insn_bitcnt  = 1; // CTZW
			32'b 0110000_00010_zzzzz_001_zzzzz_0011011: insn_bitcnt  = 1; // PCNTW

			32'b 0000101_zzzzz_zzzzz_001_zzzzz_0111011: insn_clmul   = 1; // CLMULW
			32'b 0000101_zzzzz_zzzzz_010_zzzzz_0111011: insn_clmul   = 1; // CLMULRW
			32'b 0000101_zzzzz_zzzzz_011_zzzzz_0111011: insn_clmul   = 1; // CLMULHW

			32'b 0000100_zzzzz_zzzzz_001_zzzzz_0111011: insn_bextdep = 1; // SHFLW
			32'b 0000100_zzzzz_zzzzz_101_zzzzz_0111011: insn_bextdep = 1; // UNSHFLW
			32'b 0000100_zzzzz_zzzzz_010_zzzzz_0111011: insn_bextdep = 1; // BDEPW
			32'b 0000100_zzzzz_zzzzz_110_zzzzz_0111011: insn_bextdep = 1; // BEXTW
			32'b 0000100_zzzzz_zzzzz_100_zzzzz_0111011: insn_simple  = 1; // PACKW
		endcase
	end
endmodule
