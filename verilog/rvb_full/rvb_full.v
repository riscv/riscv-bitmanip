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
	output            din_decoded,    // core can decode insn
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

	rvb_full_decoder #(.XLEN(XLEN)) decoder (
		.insn        (din_insn    ),
		.insn_bextdep(insn_bextdep),
		.insn_bitcnt (insn_bitcnt ),
		.insn_bmatxor(insn_bmatxor),
		.insn_clmul  (insn_clmul  ),
		.insn_shifter(insn_shifter),
		.insn_simple (insn_simple ),
		.insn_crc    (insn_crc    )
	);

	wire busy;
	assign din_decoded = insn_bextdep || insn_bitcnt || insn_bmatxor || insn_clmul || insn_shifter || insn_simple || insn_crc;
	assign din_ready = !reset && !busy && din_decoded;


	// ---- Input Stage ----

	reg in_bextdep;
	reg in_bitcnt;
	reg in_bmatxor;
	reg in_clmul;
	reg in_shifter;
	reg in_simple;
	reg in_crc;

	wire in_bextdep_ready;
	wire in_bitcnt_ready;
	wire in_bmatxor_ready;
	wire in_clmul_ready;
	wire in_shifter_ready;
	wire in_simple_ready;
	wire in_crc_ready = in_crc;

	reg [XLEN-1:0] in_rs1, in_rs2, in_rs3;
	reg [31:0] in_insn;

	always @(posedge clock) begin
		if (in_bextdep_ready) in_bextdep <= 0;
		if (in_bitcnt_ready ) in_bitcnt  <= 0;
		if (in_bmatxor_ready) in_bmatxor <= 0;
		if (in_clmul_ready  ) in_clmul   <= 0;
		if (in_shifter_ready) in_shifter <= 0;
		if (in_simple_ready ) in_simple  <= 0;
		if (in_crc_ready    ) in_crc     <= 0;

		if (din_ready && din_valid) begin
			in_bextdep <= insn_bextdep;
			in_bitcnt  <= insn_bitcnt;
			in_bmatxor <= insn_bmatxor;
			in_clmul   <= insn_clmul;
			in_shifter <= insn_shifter;
			in_simple  <= insn_simple;
			in_crc     <= insn_crc;
			in_rs1     <= din_rs1;
			in_rs2     <= din_rs2;
			in_rs3     <= din_rs3;
			in_insn    <= din_insn;
		end

		if (reset) begin
			in_bextdep <= 0;
			in_bitcnt  <= 0;
			in_bmatxor <= 0;
			in_clmul   <= 0;
			in_shifter <= 0;
			in_simple  <= 0;
			in_crc     <= 0;
		end
	end


	// ---- Process Stage ----

	wire [XLEN-1:0] out_bextdep;
	wire [XLEN-1:0] out_bitcnt;
	wire [XLEN-1:0] out_bmatxor;
	wire [XLEN-1:0] out_clmul;
	wire [XLEN-1:0] out_shifter;
	wire [XLEN-1:0] out_simple;
	wire [XLEN-1:0] out_crc = 0;

	wire out_bextdep_valid;
	wire out_bitcnt_valid;
	wire out_bmatxor_valid;
	wire out_clmul_valid;
	wire out_shifter_valid;
	wire out_simple_valid;
	wire out_crc_valid = in_crc;
	wire out_ready;

	rvb_bextdep #(
		.XLEN(XLEN),
		.GREV(1),
		.SHFL(1),
		.FFS(0)
	) rvb_bextdep (
		.clock      (clock      ),
		.reset      (reset      ),
		.din_valid  (in_bextdep ),
		.din_ready  (in_bextdep_ready),
		.din_rs1    (in_rs1     ),
		.din_rs2    (in_rs2     ),
		.din_insn3  (in_insn[3] ),
		.din_insn13 (in_insn[13]),
		.din_insn14 (in_insn[14]),
		.din_insn30 (in_insn[30]),
		.dout_valid (out_bextdep_valid),
		.dout_ready (out_ready  ),
		.dout_rd    (out_bextdep)
	);

	rvb_bitcnt #(
		.XLEN(XLEN),
		.BMAT(1)
	) rvb_bitcnt (
		.clock      (clock      ),
		.reset      (reset      ),
		.din_valid  (in_bitcnt  ),
		.din_ready  (in_bitcnt_ready),
		.din_rs1    (in_rs1     ),
		.din_insn3  (in_insn[3] ),
		.din_insn20 (in_insn[20]),
		.din_insn21 (in_insn[21]),
		.dout_valid (out_bitcnt_valid),
		.dout_ready (out_ready  ),
		.dout_rd    (out_bitcnt )
	);

	generate if (XLEN == 64) begin:bmatxor
		rvb_bmatxor #(
			.CYCLES(0)
		) rvb_bmatxor (
			.clock      (clock      ),
			.reset      (reset      ),
			.din_valid  (in_bmatxor ),
			.din_ready  (in_bmatxor_ready),
			.din_rs1    (in_rs1     ),
			.din_rs2    (in_rs2     ),
			.din_insn14 (in_insn[14]),
			.dout_valid (out_bmatxor_valid),
			.dout_ready (out_ready  ),
			.dout_rd    (out_bmatxor)
		);
	end else begin
		assign out_bmatxor = 0;
		assign out_bmatxor_valid = 0;
		assign in_bmatxor_ready = 1;
	end endgenerate

	rvb_clmul #(
		.XLEN(XLEN)
	) rvb_clmul (
		.clock      (clock      ),
		.reset      (reset      ),
		.din_valid  (in_clmul   ),
		.din_ready  (in_clmul_ready),
		.din_rs1    (in_rs1     ),
		.din_rs2    (in_rs2     ),
		.din_insn3  (in_insn[3] ),
		.din_insn12 (in_insn[12]),
		.din_insn13 (in_insn[13]),
		.dout_valid (out_clmul_valid),
		.dout_ready (out_ready  ),
		.dout_rd    (out_clmul  )
	);

	rvb_shifter #(
		.XLEN(XLEN),
		.SBOP(1),
		.BFP(1)
	) rvb_shifter (
		.clock      (clock      ),
		.reset      (reset      ),
		.din_valid  (in_shifter ),
		.din_ready  (in_shifter_ready),
		.din_rs1    (in_rs1     ),
		.din_rs2    (in_rs2     ),
		.din_rs3    (in_rs3     ),
		.din_insn3  (in_insn[3] ),
		.din_insn12 (in_insn[12]),
		.din_insn14 (in_insn[14]),
		.din_insn26 (in_insn[26]),
		.din_insn27 (in_insn[27]),
		.din_insn29 (in_insn[29]),
		.din_insn30 (in_insn[30]),
		.dout_valid (out_shifter_valid),
		.dout_ready (out_ready  ),
		.dout_rd    (out_shifter)
	);

	rvb_simple #(
		.XLEN(XLEN)
	) rvb_simple (
		.clock      (clock      ),
		.reset      (reset      ),
		.din_valid  (in_simple  ),
		.din_ready  (in_simple_ready),
		.din_rs1    (in_rs1     ),
		.din_rs2    (in_rs2     ),
		.din_rs3    (in_rs3     ),
		.din_insn3  (in_insn[3] ),
		.din_insn5  (in_insn[5] ),
		.din_insn12 (in_insn[12]),
		.din_insn13 (in_insn[13]),
		.din_insn14 (in_insn[14]),
		.din_insn25 (in_insn[25]),
		.din_insn26 (in_insn[26]),
		.din_insn27 (in_insn[27]),
		.din_insn30 (in_insn[30]),
		.dout_valid (out_simple_valid),
		.dout_ready (out_ready  ),
		.dout_rd    (out_simple )
	);


	// ---- Output Stage ----

	reg output_valid;
	reg [XLEN-1:0] output_value;

	assign out_ready = !dout_valid || dout_ready;

	always @(posedge clock) begin
		if (dout_valid && dout_ready) begin
			output_valid <= 0;
		end
		if (out_ready) begin
			(* parallel_case *)
			case (1'b1)
				out_bextdep_valid: begin output_valid <= 1; output_value <= out_bextdep; end
				out_bitcnt_valid:  begin output_valid <= 1; output_value <= out_bitcnt;  end
				out_bmatxor_valid: begin output_valid <= 1; output_value <= out_bmatxor; end
				out_clmul_valid:   begin output_valid <= 1; output_value <= out_clmul;   end
				out_shifter_valid: begin output_valid <= 1; output_value <= out_shifter; end
				out_simple_valid:  begin output_valid <= 1; output_value <= out_simple;  end
				out_crc_valid:     begin output_valid <= 1; output_value <= out_crc;     end
			endcase
		end
		if (reset) begin
			output_valid <= 0;
		end
	end

	assign dout_valid = !reset && output_valid;
	assign dout_rd = output_value;


	// ---- Arbiter ----

	reg busy_reg;
	wire out_any_valid = out_bextdep_valid || out_bitcnt_valid || out_bmatxor_valid || out_clmul_valid || out_shifter_valid || out_simple_valid || out_crc_valid;
	assign busy = busy_reg && !(out_ready && out_any_valid);

	always @(posedge clock) begin
		if (in_bextdep) busy_reg <= 1;
		if (in_bitcnt ) busy_reg <= 1;
		if (in_bmatxor) busy_reg <= 1;
		if (in_clmul  ) busy_reg <= 1;
		if (in_shifter) busy_reg <= 1;
		if (in_simple ) busy_reg <= 1;
		if (in_crc    ) busy_reg <= 1;
		if (out_ready && out_any_valid) busy_reg <= 0;
		if (reset) busy_reg <= 0;
	end
endmodule

module rvb_full_decoder #(
	parameter integer XLEN = 64
) (
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

		(* parallel_case *)
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

			32'b zzzzz11_zzzzz_zzzzz_001_zzzzz_0110011: insn_simple  = 1; // CMIX
			32'b zzzzz11_zzzzz_zzzzz_101_zzzzz_0110011: insn_simple  = 1; // CMOV
			32'b zzzzz10_zzzzz_zzzzz_001_zzzzz_0110011: insn_shifter = 1; // FSL
			32'b zzzzz10_zzzzz_zzzzz_101_zzzzz_0110011: insn_shifter = 1; // FSR
			32'b zzzzz1_zzzzzz_zzzzz_101_zzzzz_0010011: insn_shifter = 1; // FSRI

			32'b 0110000_00000_zzzzz_001_zzzzz_0010011: insn_bitcnt  = 1; // CLZ
			32'b 0110000_00001_zzzzz_001_zzzzz_0010011: insn_bitcnt  = 1; // CTZ
			32'b 0110000_00010_zzzzz_001_zzzzz_0010011: insn_bitcnt  = 1; // PCNT
			32'b 0110000_00011_zzzzz_001_zzzzz_0010011: if (XLEN == 64) insn_bitcnt  = 1; // BMATFLIP

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
			32'b 0100100_zzzzz_zzzzz_100_zzzzz_0110011: insn_shifter = 1; // BFP
			32'b 0000100_zzzzz_zzzzz_011_zzzzz_0110011: if (XLEN == 64) insn_bmatxor = 1; // BMATOR
			32'b 0000100_zzzzz_zzzzz_111_zzzzz_0110011: if (XLEN == 64) insn_bmatxor = 1; // BMATXOR

			32'b 000010_zzzzzz_zzzzz_001_zzzzz_0010011: insn_bextdep = 1; // SHFLI
			32'b 000010_zzzzzz_zzzzz_101_zzzzz_0010011: insn_bextdep = 1; // UNSHFLI

			32'b zzzzzz_zzzzzz_zzzzz_100_zzzzz_0011011: if (XLEN == 64) insn_simple  = 1; // ADDIWU
			32'b 00001_zzzzzzz_zzzzz_001_zzzzz_0011011: if (XLEN == 64) insn_shifter = 1; // SLLIU.W

			32'b 0000101_zzzzz_zzzzz_000_zzzzz_0111011: if (XLEN == 64) insn_simple  = 1; // ADDWU
			32'b 0100101_zzzzz_zzzzz_000_zzzzz_0111011: if (XLEN == 64) insn_simple  = 1; // SUBWU
			32'b 0000100_zzzzz_zzzzz_000_zzzzz_0111011: if (XLEN == 64) insn_simple  = 1; // ADDUW
			32'b 0100100_zzzzz_zzzzz_000_zzzzz_0111011: if (XLEN == 64) insn_simple  = 1; // SUBUW

			32'b 0000000_zzzzz_zzzzz_001_zzzzz_0111011: if (XLEN == 64) insn_shifter = 1; // SLLW
			32'b 0000000_zzzzz_zzzzz_101_zzzzz_0111011: if (XLEN == 64) insn_shifter = 1; // SRLW
			32'b 0100000_zzzzz_zzzzz_001_zzzzz_0111011: if (XLEN == 64) insn_bextdep = 1; // GREVW
			32'b 0100000_zzzzz_zzzzz_101_zzzzz_0111011: if (XLEN == 64) insn_shifter = 1; // SRAW
			32'b 0010000_zzzzz_zzzzz_001_zzzzz_0111011: if (XLEN == 64) insn_shifter = 1; // SLOW
			32'b 0010000_zzzzz_zzzzz_101_zzzzz_0111011: if (XLEN == 64) insn_shifter = 1; // SROW
			32'b 0110000_zzzzz_zzzzz_001_zzzzz_0111011: if (XLEN == 64) insn_shifter = 1; // ROLW
			32'b 0110000_zzzzz_zzzzz_101_zzzzz_0111011: if (XLEN == 64) insn_shifter = 1; // RORW

			32'b 0010100_zzzzz_zzzzz_001_zzzzz_0111011: if (XLEN == 64) insn_shifter = 1; // SBSETW
			32'b 0100100_zzzzz_zzzzz_001_zzzzz_0111011: if (XLEN == 64) insn_shifter = 1; // SBCLRW
			32'b 0110100_zzzzz_zzzzz_001_zzzzz_0111011: if (XLEN == 64) insn_shifter = 1; // SBINVW
			32'b 0100100_zzzzz_zzzzz_101_zzzzz_0111011: if (XLEN == 64) insn_shifter = 1; // SBEXTW

			32'b 00000_0zzzzzz_zzzzz_001_zzzzz_0011011: if (XLEN == 64) insn_shifter = 1; // SLLIW
			32'b 00000_0zzzzzz_zzzzz_101_zzzzz_0011011: if (XLEN == 64) insn_shifter = 1; // SRLIW
			32'b 01000_0zzzzzz_zzzzz_001_zzzzz_0011011: if (XLEN == 64) insn_bextdep = 1; // GREVIW
			32'b 01000_0zzzzzz_zzzzz_101_zzzzz_0011011: if (XLEN == 64) insn_shifter = 1; // SRAIW
			32'b 00100_0zzzzzz_zzzzz_001_zzzzz_0011011: if (XLEN == 64) insn_shifter = 1; // SLOIW
			32'b 00100_0zzzzzz_zzzzz_101_zzzzz_0011011: if (XLEN == 64) insn_shifter = 1; // SROIW
			32'b 01100_0zzzzzz_zzzzz_101_zzzzz_0011011: if (XLEN == 64) insn_shifter = 1; // RORIW

			32'b 00101_0zzzzzz_zzzzz_001_zzzzz_0011011: if (XLEN == 64) insn_shifter = 1; // SBSETIW
			32'b 01001_0zzzzzz_zzzzz_001_zzzzz_0011011: if (XLEN == 64) insn_shifter = 1; // SBCLRIW
			32'b 01101_0zzzzzz_zzzzz_001_zzzzz_0011011: if (XLEN == 64) insn_shifter = 1; // SBINVIW

			32'b zzzzz10_zzzzz_zzzzz_001_zzzzz_0111011: if (XLEN == 64) insn_shifter = 1; // FSLW
			32'b zzzzz10_zzzzz_zzzzz_101_zzzzz_0111011: if (XLEN == 64) insn_shifter = 1; // FSRW
			32'b zzzzz1_zzzzzz_zzzzz_101_zzzzz_0011011: if (XLEN == 64) insn_shifter = 1; // FSRIW

			32'b 0110000_00000_zzzzz_001_zzzzz_0011011: if (XLEN == 64) insn_bitcnt  = 1; // CLZW
			32'b 0110000_00001_zzzzz_001_zzzzz_0011011: if (XLEN == 64) insn_bitcnt  = 1; // CTZW
			32'b 0110000_00010_zzzzz_001_zzzzz_0011011: if (XLEN == 64) insn_bitcnt  = 1; // PCNTW

			32'b 0000101_zzzzz_zzzzz_001_zzzzz_0111011: if (XLEN == 64) insn_clmul   = 1; // CLMULW
			32'b 0000101_zzzzz_zzzzz_010_zzzzz_0111011: if (XLEN == 64) insn_clmul   = 1; // CLMULRW
			32'b 0000101_zzzzz_zzzzz_011_zzzzz_0111011: if (XLEN == 64) insn_clmul   = 1; // CLMULHW

			32'b 0000100_zzzzz_zzzzz_001_zzzzz_0111011: if (XLEN == 64) insn_bextdep = 1; // SHFLW
			32'b 0000100_zzzzz_zzzzz_101_zzzzz_0111011: if (XLEN == 64) insn_bextdep = 1; // UNSHFLW
			32'b 0000100_zzzzz_zzzzz_010_zzzzz_0111011: if (XLEN == 64) insn_bextdep = 1; // BDEPW
			32'b 0000100_zzzzz_zzzzz_110_zzzzz_0111011: if (XLEN == 64) insn_bextdep = 1; // BEXTW
			32'b 0000100_zzzzz_zzzzz_100_zzzzz_0111011: if (XLEN == 64) insn_simple  = 1; // PACKW
			32'b 0100100_zzzzz_zzzzz_100_zzzzz_0111011: if (XLEN == 64) insn_shifter = 1; // BFPW
		endcase
	end
endmodule
