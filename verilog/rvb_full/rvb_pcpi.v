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

module rvb_pcpi (
	input         clk,
	input         resetn,
	input         pcpi_valid,
	input  [31:0] pcpi_insn,
	input  [31:0] pcpi_rs1,
	input  [31:0] pcpi_rs2,
	input  [31:0] pcpi_rs3,

	output        pcpi_wr,
	output [31:0] pcpi_rd,
	output        pcpi_wait,
	output        pcpi_ready

`ifdef RVB_DEBUG
,	output [31:0] debug_rs2,
	output        debug_insn_bextdep,
	output        debug_insn_bitcnt,
	output        debug_insn_bmatxor,
	output        debug_insn_clmul,
	output        debug_insn_crc,
	output        debug_insn_shifter,
	output        debug_insn_simple
`endif
);
	wire din_valid;
	wire din_ready;
	wire din_decoded;

	wire dout_valid;
	wire dout_ready;

	reg busy;
	assign din_valid = pcpi_valid && !busy;
	assign dout_ready = 1;
	assign pcpi_wait = din_decoded;
	assign pcpi_ready = dout_valid;
	assign pcpi_wr = 1;

	always @(posedge clk) begin
		if (din_valid && din_ready)
			busy <= 1;
		if (dout_valid && dout_ready)
			busy <= 0;
		if (!resetn)
			busy <= 0;
	end

	rvb_full #(
		.XLEN(32)
	) worker (
		.clock      (clk        ),
		.reset      (!resetn    ),
		.din_valid  (din_valid  ),
		.din_ready  (din_ready  ),
		.din_decoded(din_decoded),
		.din_rs1    (pcpi_rs1   ),
		.din_rs2    (pcpi_rs2   ),
		.din_rs3    (pcpi_rs3   ),
		.din_insn   (pcpi_insn  ),
		.dout_valid (dout_valid ),
		.dout_ready (dout_ready ),
		.dout_rd    (pcpi_rd    )
`ifdef RVB_DEBUG
,		.debug_rs2           (debug_rs2         ),
		.debug_insn_bextdep  (debug_insn_bextdep),
		.debug_insn_bitcnt   (debug_insn_bitcnt ),
		.debug_insn_bmatxor  (debug_insn_bmatxor),
		.debug_insn_clmul    (debug_insn_clmul  ),
		.debug_insn_crc      (debug_insn_crc    ),
		.debug_insn_shifter  (debug_insn_shifter),
		.debug_insn_simple   (debug_insn_simple )
`endif
	);
endmodule
