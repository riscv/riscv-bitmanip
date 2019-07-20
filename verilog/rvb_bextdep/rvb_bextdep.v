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

module rvb_bextdep #(
	parameter integer XLEN = 64,
	parameter integer GREV = 1,
	parameter integer FFS = 1
) (
	// control signals
	input             clock,          // positive edge clock
	input             reset,          // synchronous reset
	
	// data input
	input             din_valid,      // input is valid
	output            din_ready,      // core accepts input
	input  [XLEN-1:0] din_rs1,        // value of 1st argument
	input  [XLEN-1:0] din_rs2,        // value of 2nd argument
	input             din_insn3,      // value of instruction bit 3
	input             din_insn13,     // value of instruction bit 13
	input             din_insn14,     // value of instruction bit 14
	
	// data output
	output            dout_valid,     // output is valid
	output [XLEN-1:0] dout_rd         // output value
);
	// 14 13  3   Function
	// --------   --------
	//  0  0  0   GREV
	//  0  1  0   BDEP
	//  1  1  0   BEXT
	// --------   --------
	//  0  0  1   GREVW
	//  0  1  1   BDEPW
	//  1  1  1   BEXTW

	wire [1:0] din_mode = din_insn14 ? 2'b00 : din_insn13 ? 2'b01 : 2'b10;

	wire [XLEN-1:0] din_rs1_w = din_rs1 & (din_insn3 ? 64'h 0000_0000_ffff_ffff : 64'h ffff_ffff_ffff_ffff);
	wire [XLEN-1:0] din_rs2_w = din_rs2 & (din_insn3 ? (din_insn13 ? 64'h 0000_0000_ffff_ffff : 64'h 0000_0000_ffff_ffdf) : 64'h ffff_ffff_ffff_ffff);
	wire [XLEN-1:0] dout_rd_w;

	reg [2:0] din_insn3_q;
	always @(posedge clock) din_insn3_q <= {din_insn3_q, din_insn3};
	wire dout_insn3 = FFS ? din_insn3_q[FFS-1] : din_insn3;

	assign dout_rd = dout_insn3 ? {{32{dout_rd_w[31]}}, dout_rd_w[31:0]} : dout_rd_w;

	assign din_ready = 1;

	rvb_bextdep_xlen_pipeline #(
		.GREV(GREV),
		.XLEN(XLEN),
		.FFS(FFS)
	) core (
		.clock       (clock         ),
		.reset       (reset         ),
		.din_valid   (din_valid     ),
		.din_mode    (din_mode      ),
		.din_value   (din_rs1_w     ),
		.din_mask    (din_rs2_w     ),
		.dout_valid  (dout_valid    ),
		.dout_result (dout_rd_w     )
	);
endmodule

`define rvb_bextdep_butterfly_idx_a(k, i) ((2 << (k))*((i)/(1 << (k))) + (i)%(1 << (k)))
`define rvb_bextdep_butterfly_idx_b(k, i) (`rvb_bextdep_butterfly_idx_a(k, i) + (1<<(k)))

module rvb_bextdep_xlen_pipeline #(
	parameter integer GREV = 1,
	parameter integer XLEN = 32,
	parameter integer FFS = 1
) (
	input                 clock,
	input                 reset,

	input                 din_valid,
	input      [     1:0] din_mode,
	input      [XLEN-1:0] din_value,
	input      [XLEN-1:0] din_mask,

	output reg            dout_valid,
	output reg [XLEN-1:0] dout_result
);
	wire [XLEN/2-1:0] decoder_s1, decoder_s2, decoder_s4;
	wire [XLEN/2-1:0] decoder_s8, decoder_s16, decoder_s32;

	rvb_bextdep_decoder #(
		.XLEN(XLEN),
		.FFSTAGE(FFS == 3)
	) decoder (
		.clock (clock      ),
		.mask  (din_mask   ),
		.s1    (decoder_s1 ),
		.s2    (decoder_s2 ),
		.s4    (decoder_s4 ),
		.s8    (decoder_s8 ),
		.s16   (decoder_s16),
		.s32   (decoder_s32)
	);

	reg valid_t;
	reg [1:0] din_mode_t;
	reg [XLEN-1:0] din_value_t, din_mask_t;

	reg valid_r;
	reg [1:0] din_mode_r;
	reg [XLEN-1:0] din_value_r, din_mask_r;
	reg [XLEN/2-1:0] decoder_s1_r, decoder_s2_r, decoder_s4_r;
	reg [XLEN/2-1:0] decoder_s8_r, decoder_s16_r, decoder_s32_r;

	generate
		if (FFS == 3) begin
			always @(posedge clock) begin
				valid_t <= din_valid;
				din_mode_t <= din_mode;
				din_value_t <= din_value;
				din_mask_t <= din_mask;

				valid_r <= valid_t;
				din_mode_r <= din_mode_t;
				din_value_r <= din_value_t;
				din_mask_r <= din_mask_t;

				decoder_s1_r <= decoder_s1;
				decoder_s2_r <= decoder_s2;
				decoder_s4_r <= decoder_s4;
				decoder_s8_r <= decoder_s8;
				decoder_s16_r <= decoder_s16;
				decoder_s32_r <= decoder_s32;

				if (reset) begin
					valid_t <= 0;
					valid_r <= 0;
				end
			end
		end else
		if (FFS == 2) begin
			always @(posedge clock) begin
				valid_r <= din_valid;
				din_mode_r <= din_mode;
				din_value_r <= din_value;
				din_mask_r <= din_mask;

				decoder_s1_r <= decoder_s1;
				decoder_s2_r <= decoder_s2;
				decoder_s4_r <= decoder_s4;
				decoder_s8_r <= decoder_s8;
				decoder_s16_r <= decoder_s16;
				decoder_s32_r <= decoder_s32;

				if (reset) begin
					valid_r <= 0;
				end
			end
		end else begin
			always @* begin
				valid_r = !reset && din_valid;

				din_mode_r = din_mode;
				din_value_r = din_value;
				din_mask_r = din_mask;

				decoder_s1_r = decoder_s1;
				decoder_s2_r = decoder_s2;
				decoder_s4_r = decoder_s4;
				decoder_s8_r = decoder_s8;
				decoder_s16_r = decoder_s16;
				decoder_s32_r = decoder_s32;
			end
		end
	endgenerate

	wire [XLEN-1:0] result_fwd;
	wire [XLEN-1:0] result_bwd;

	rvb_bextdep_butterfly_fwd #(
		.XLEN(XLEN)
	) butterfly_fwd (
		.din  (din_value_r   ),
		.s1   (~decoder_s1_r ),
		.s2   (~decoder_s2_r ),
		.s4   (~decoder_s4_r ),
		.s8   (~decoder_s8_r ),
		.s16  (~decoder_s16_r),
		.s32  (~decoder_s32_r),
		.dout (result_fwd    )
	);

	rvb_bextdep_butterfly_bwd #(
		.XLEN(XLEN)
	) butterfly_bwd (
		.din  ((GREV && din_mode_r[1]) ? din_value_r : (din_value_r & din_mask_r)),
		.s1   ((GREV && din_mode_r[1]) ? {XLEN/2{din_mask_r[0]}} : ~decoder_s1_r ),
		.s2   ((GREV && din_mode_r[1]) ? {XLEN/2{din_mask_r[1]}} : ~decoder_s2_r ),
		.s4   ((GREV && din_mode_r[1]) ? {XLEN/2{din_mask_r[2]}} : ~decoder_s4_r ),
		.s8   ((GREV && din_mode_r[1]) ? {XLEN/2{din_mask_r[3]}} : ~decoder_s8_r ),
		.s16  ((GREV && din_mode_r[1]) ? {XLEN/2{din_mask_r[4]}} : ~decoder_s16_r),
		.s32  ((GREV && din_mode_r[1]) ? {XLEN/2{din_mask_r[5]}} : ~decoder_s32_r),
		.dout (result_bwd)
	);

	generate if (FFS) begin
		always @(posedge clock) begin
			dout_valid <= 0;
			dout_result <= 'bx;
			if (!reset && valid_r) begin
				dout_valid <= 1;
				dout_result <= din_mode_r[0] ? (result_fwd & din_mask_r) : result_bwd;
			end
		end
	end else begin
		always @* begin
			dout_valid = din_valid;
			dout_result = din_mode_r[0] ? (result_fwd & din_mask_r) : result_bwd;
		end
	end endgenerate
endmodule

// ========================================================================

module rvb_bextdep_lrotcz #(
	parameter integer N = 1,
	parameter integer M = 1
) (
	input [7:0] din,
	output [M-1:0] dout
);
	wire [2*M-1:0] mask = {M{1'b1}};
	assign dout = (mask << din[N-1:0]) >> M;
endmodule

module rvb_bextdep_decoder #(
	parameter integer XLEN = 32,
	parameter integer FFSTAGE = 1
) (
	input clock,
	input [XLEN-1:0] mask,
	output [XLEN/2-1:0] s1, s2, s4, s8, s16, s32,
	output [7:0] sum
);
	wire [8*XLEN-1:0] ppsdata;

	assign sum = ppsdata[8*(XLEN-1) +: 8];

	generate
		if (XLEN == 4 && !FFSTAGE) begin:pps4
			rvb_bextdep_pps4 pps_core (
				.din  (mask),
				.dout (ppsdata)
			);
		end
		if (XLEN == 8 && !FFSTAGE) begin:pps8
			rvb_bextdep_pps8 pps_core (
				.din  (mask),
				.dout (ppsdata)
			);
		end
		if (XLEN == 16 && !FFSTAGE) begin:pps16
			rvb_bextdep_pps16 pps_core (
				.din  (mask),
				.dout (ppsdata)
			);
		end
		if (XLEN == 32 && !FFSTAGE) begin:pps32
			rvb_bextdep_pps32 pps_core (
				.din  (mask),
				.dout (ppsdata)
			);
		end
		if (XLEN == 64 && !FFSTAGE) begin:pps64
			rvb_bextdep_pps64 pps_core (
				.din  (mask),
				.dout (ppsdata)
			);
		end
		if (XLEN == 32 && FFSTAGE) begin:pps32f
			rvb_bextdep_pps32f pps_core (
				.clock (clock),
				.din   (mask),
				.dout  (ppsdata)
			);
		end
		if (XLEN == 64 && FFSTAGE) begin:pps64f
			rvb_bextdep_pps64f pps_core (
				.clock (clock),
				.din   (mask),
				.dout  (ppsdata)
			);
		end
	endgenerate

	genvar i;
	generate
		for (i = 0; i < XLEN/2; i = i+1) begin:stage1
			rvb_bextdep_lrotcz #(.N(1), .M(1)) lrotc_zero (
				.din(ppsdata[8*(2*i + 1 - 1) +: 8]),
				.dout(s1[i])
			);
		end

		for (i = 0; i < XLEN/4; i = i+1) begin:stage2
			rvb_bextdep_lrotcz #(.N(2), .M(2)) lrotc_zero (
				.din(ppsdata[8*(4*i + 2 - 1) +: 8]),
				.dout(s2[2*i +: 2])
			);
		end

		for (i = 0; i < XLEN/8; i = i+1) begin:stage4
			rvb_bextdep_lrotcz #(.N(3), .M(4)) lrotc_zero (
				.din(ppsdata[8*(8*i + 4 - 1) +: 8]),
				.dout(s4[4*i +: 4])
			);
		end

		for (i = 0; i < XLEN/16; i = i+1) begin:stage8
			rvb_bextdep_lrotcz #(.N(4), .M(8)) lrotc_zero (
				.din(ppsdata[8*(16*i + 8 - 1) +: 8]),
				.dout(s8[8*i +: 8])
			);
		end

		for (i = 0; i < XLEN/32; i = i+1) begin:stage16
			rvb_bextdep_lrotcz #(.N(5), .M(16)) lrotc_zero (
				.din(ppsdata[8*(32*i + 16 - 1) +: 8]),
				.dout(s16[16*i +: 16])
			);
		end

		for (i = 0; i < XLEN/64; i = i+1) begin:stage32
			rvb_bextdep_lrotcz #(.N(6), .M(32)) lrotc_zero (
				.din(ppsdata[8*(64*i + 32 - 1) +: 8]),
				.dout(s32[32*i +: 32])
			);
		end
	endgenerate
endmodule

module rvb_bextdep_butterfly_fwd #(
	parameter integer XLEN = 32,
	parameter integer FFSTAGE = 1
) (
	input [XLEN-1:0] din,
	input [XLEN/2-1:0] s1, s2, s4, s8, s16, s32,
	output [XLEN-1:0] dout
);
	reg [XLEN-1:0] butterfly;
	assign dout = butterfly;

	integer k, i;
	always @* begin
		butterfly = din;

		if (64 <= XLEN) begin
			for (i = 0; i < XLEN/2; i = i+1)
				if (s32[i]) {butterfly[`rvb_bextdep_butterfly_idx_a(5, i)], butterfly[`rvb_bextdep_butterfly_idx_b(5, i)]} =
							{butterfly[`rvb_bextdep_butterfly_idx_b(5, i)], butterfly[`rvb_bextdep_butterfly_idx_a(5, i)]};
		end

		if (32 <= XLEN) begin
			for (i = 0; i < XLEN/2; i = i+1)
				if (s16[i]) {butterfly[`rvb_bextdep_butterfly_idx_a(4, i)], butterfly[`rvb_bextdep_butterfly_idx_b(4, i)]} =
							{butterfly[`rvb_bextdep_butterfly_idx_b(4, i)], butterfly[`rvb_bextdep_butterfly_idx_a(4, i)]};
		end

		if (16 <= XLEN) begin
			for (i = 0; i < XLEN/2; i = i+1)
				if (s8[i]) {butterfly[`rvb_bextdep_butterfly_idx_a(3, i)], butterfly[`rvb_bextdep_butterfly_idx_b(3, i)]} =
							{butterfly[`rvb_bextdep_butterfly_idx_b(3, i)], butterfly[`rvb_bextdep_butterfly_idx_a(3, i)]};
		end

		for (i = 0; i < XLEN/2; i = i+1)
			if (s4[i]) {butterfly[`rvb_bextdep_butterfly_idx_a(2, i)], butterfly[`rvb_bextdep_butterfly_idx_b(2, i)]} =
						{butterfly[`rvb_bextdep_butterfly_idx_b(2, i)], butterfly[`rvb_bextdep_butterfly_idx_a(2, i)]};

		for (i = 0; i < XLEN/2; i = i+1)
			if (s2[i]) {butterfly[`rvb_bextdep_butterfly_idx_a(1, i)], butterfly[`rvb_bextdep_butterfly_idx_b(1, i)]} =
						{butterfly[`rvb_bextdep_butterfly_idx_b(1, i)], butterfly[`rvb_bextdep_butterfly_idx_a(1, i)]};

		for (i = 0; i < XLEN/2; i = i+1)
			if (s1[i]) {butterfly[`rvb_bextdep_butterfly_idx_a(0, i)], butterfly[`rvb_bextdep_butterfly_idx_b(0, i)]} =
						{butterfly[`rvb_bextdep_butterfly_idx_b(0, i)], butterfly[`rvb_bextdep_butterfly_idx_a(0, i)]};
	end
endmodule

module rvb_bextdep_butterfly_bwd #(
	parameter integer XLEN = 32,
	parameter integer FFSTAGE = 1
) (
	input [XLEN-1:0] din,
	input [XLEN/2-1:0] s1, s2, s4, s8, s16, s32,
	output [XLEN-1:0] dout
);
	reg [XLEN-1:0] butterfly;
	assign dout = butterfly;

	integer k, i;
	always @* begin
		butterfly = din;

		for (i = 0; i < XLEN/2; i = i+1)
			if (s1[i]) {butterfly[`rvb_bextdep_butterfly_idx_a(0, i)], butterfly[`rvb_bextdep_butterfly_idx_b(0, i)]} =
						{butterfly[`rvb_bextdep_butterfly_idx_b(0, i)], butterfly[`rvb_bextdep_butterfly_idx_a(0, i)]};

		for (i = 0; i < XLEN/2; i = i+1)
			if (s2[i]) {butterfly[`rvb_bextdep_butterfly_idx_a(1, i)], butterfly[`rvb_bextdep_butterfly_idx_b(1, i)]} =
						{butterfly[`rvb_bextdep_butterfly_idx_b(1, i)], butterfly[`rvb_bextdep_butterfly_idx_a(1, i)]};

		for (i = 0; i < XLEN/2; i = i+1)
			if (s4[i]) {butterfly[`rvb_bextdep_butterfly_idx_a(2, i)], butterfly[`rvb_bextdep_butterfly_idx_b(2, i)]} =
						{butterfly[`rvb_bextdep_butterfly_idx_b(2, i)], butterfly[`rvb_bextdep_butterfly_idx_a(2, i)]};

		if (16 <= XLEN) begin
			for (i = 0; i < XLEN/2; i = i+1)
				if (s8[i]) {butterfly[`rvb_bextdep_butterfly_idx_a(3, i)], butterfly[`rvb_bextdep_butterfly_idx_b(3, i)]} =
							{butterfly[`rvb_bextdep_butterfly_idx_b(3, i)], butterfly[`rvb_bextdep_butterfly_idx_a(3, i)]};
		end

		if (32 <= XLEN) begin
			for (i = 0; i < XLEN/2; i = i+1)
				if (s16[i]) {butterfly[`rvb_bextdep_butterfly_idx_a(4, i)], butterfly[`rvb_bextdep_butterfly_idx_b(4, i)]} =
							{butterfly[`rvb_bextdep_butterfly_idx_b(4, i)], butterfly[`rvb_bextdep_butterfly_idx_a(4, i)]};
		end

		if (64 <= XLEN) begin
			for (i = 0; i < XLEN/2; i = i+1)
				if (s32[i]) {butterfly[`rvb_bextdep_butterfly_idx_a(5, i)], butterfly[`rvb_bextdep_butterfly_idx_b(5, i)]} =
							{butterfly[`rvb_bextdep_butterfly_idx_b(5, i)], butterfly[`rvb_bextdep_butterfly_idx_a(5, i)]};
		end
	end
endmodule

// ========================================================================

module rvb_bextdep_pps4 (
  input [3:0] din,
  output [31:0] dout
);
  function [15:0] carry_save_add;
    input [15:0] a, b;
    reg [7:0] x, y;
    begin
      x = a[15:8] ^ a[7:0] ^ b[7:0];
      y = ((a[15:8] & a[7:0]) | (a[15:8] & b[7:0]) | (a[7:0] & b[7:0])) << 1;
      carry_save_add[7:0] = x ^ y ^ b[15:8];
      carry_save_add[15:8] = ((x & y) | (x & b[15:8]) | (y & b[15:8])) << 1;
    end
  endfunction
  function [7:0] carry_save_get;
    input [15:0] a;
    begin
      carry_save_get = a[7:0] + a[15:8];
    end
  endfunction
  // inputs
  wire [15:0] e0s0 = {15'b0, din[0 +: 1]};
  wire [15:0] e1s0 = {15'b0, din[1 +: 1]};
  wire [15:0] e2s0 = {15'b0, din[2 +: 1]};
  wire [15:0] e3s0 = {15'b0, din[3 +: 1]};
  // forward pass
  wire [15:0] e1s1 = carry_save_add(e1s0, e0s0);
  wire [15:0] e3s1 = carry_save_add(e3s0, e2s0);
  wire [15:0] e3s2 = carry_save_add(e3s1, e1s1);
  // backward pass
  wire [15:0] e2s3 = carry_save_add(e2s0, e1s1);
  // outputs
  assign dout[0 +: 8] = carry_save_get(e0s0);
  assign dout[8 +: 8] = carry_save_get(e1s1);
  assign dout[16 +: 8] = carry_save_get(e2s3);
  assign dout[24 +: 8] = carry_save_get(e3s2);
endmodule
module rvb_bextdep_pps8 (
  input [7:0] din,
  output [63:0] dout
);
  function [15:0] carry_save_add;
    input [15:0] a, b;
    reg [7:0] x, y;
    begin
      x = a[15:8] ^ a[7:0] ^ b[7:0];
      y = ((a[15:8] & a[7:0]) | (a[15:8] & b[7:0]) | (a[7:0] & b[7:0])) << 1;
      carry_save_add[7:0] = x ^ y ^ b[15:8];
      carry_save_add[15:8] = ((x & y) | (x & b[15:8]) | (y & b[15:8])) << 1;
    end
  endfunction
  function [7:0] carry_save_get;
    input [15:0] a;
    begin
      carry_save_get = a[7:0] + a[15:8];
    end
  endfunction
  // inputs
  wire [15:0] e0s0 = {15'b0, din[0 +: 1]};
  wire [15:0] e1s0 = {15'b0, din[1 +: 1]};
  wire [15:0] e2s0 = {15'b0, din[2 +: 1]};
  wire [15:0] e3s0 = {15'b0, din[3 +: 1]};
  wire [15:0] e4s0 = {15'b0, din[4 +: 1]};
  wire [15:0] e5s0 = {15'b0, din[5 +: 1]};
  wire [15:0] e6s0 = {15'b0, din[6 +: 1]};
  wire [15:0] e7s0 = {15'b0, din[7 +: 1]};
  // forward pass
  wire [15:0] e1s1 = carry_save_add(e1s0, e0s0);
  wire [15:0] e3s1 = carry_save_add(e3s0, e2s0);
  wire [15:0] e5s1 = carry_save_add(e5s0, e4s0);
  wire [15:0] e7s1 = carry_save_add(e7s0, e6s0);
  wire [15:0] e3s2 = carry_save_add(e3s1, e1s1);
  wire [15:0] e7s2 = carry_save_add(e7s1, e5s1);
  wire [15:0] e7s3 = carry_save_add(e7s2, e3s2);
  // backward pass
  wire [15:0] e5s4 = carry_save_add(e5s1, e3s2);
  wire [15:0] e2s5 = carry_save_add(e2s0, e1s1);
  wire [15:0] e4s5 = carry_save_add(e4s0, e3s2);
  wire [15:0] e6s5 = carry_save_add(e6s0, e5s4);
  // outputs
  assign dout[0 +: 8] = carry_save_get(e0s0);
  assign dout[8 +: 8] = carry_save_get(e1s1);
  assign dout[16 +: 8] = carry_save_get(e2s5);
  assign dout[24 +: 8] = carry_save_get(e3s2);
  assign dout[32 +: 8] = carry_save_get(e4s5);
  assign dout[40 +: 8] = carry_save_get(e5s4);
  assign dout[48 +: 8] = carry_save_get(e6s5);
  assign dout[56 +: 8] = carry_save_get(e7s3);
endmodule
module rvb_bextdep_pps16 (
  input [15:0] din,
  output [127:0] dout
);
  function [15:0] carry_save_add;
    input [15:0] a, b;
    reg [7:0] x, y;
    begin
      x = a[15:8] ^ a[7:0] ^ b[7:0];
      y = ((a[15:8] & a[7:0]) | (a[15:8] & b[7:0]) | (a[7:0] & b[7:0])) << 1;
      carry_save_add[7:0] = x ^ y ^ b[15:8];
      carry_save_add[15:8] = ((x & y) | (x & b[15:8]) | (y & b[15:8])) << 1;
    end
  endfunction
  function [7:0] carry_save_get;
    input [15:0] a;
    begin
      carry_save_get = a[7:0] + a[15:8];
    end
  endfunction
  // inputs
  wire [15:0] e0s0 = {15'b0, din[0 +: 1]};
  wire [15:0] e1s0 = {15'b0, din[1 +: 1]};
  wire [15:0] e2s0 = {15'b0, din[2 +: 1]};
  wire [15:0] e3s0 = {15'b0, din[3 +: 1]};
  wire [15:0] e4s0 = {15'b0, din[4 +: 1]};
  wire [15:0] e5s0 = {15'b0, din[5 +: 1]};
  wire [15:0] e6s0 = {15'b0, din[6 +: 1]};
  wire [15:0] e7s0 = {15'b0, din[7 +: 1]};
  wire [15:0] e8s0 = {15'b0, din[8 +: 1]};
  wire [15:0] e9s0 = {15'b0, din[9 +: 1]};
  wire [15:0] e10s0 = {15'b0, din[10 +: 1]};
  wire [15:0] e11s0 = {15'b0, din[11 +: 1]};
  wire [15:0] e12s0 = {15'b0, din[12 +: 1]};
  wire [15:0] e13s0 = {15'b0, din[13 +: 1]};
  wire [15:0] e14s0 = {15'b0, din[14 +: 1]};
  wire [15:0] e15s0 = {15'b0, din[15 +: 1]};
  // forward pass
  wire [15:0] e1s1 = carry_save_add(e1s0, e0s0);
  wire [15:0] e3s1 = carry_save_add(e3s0, e2s0);
  wire [15:0] e5s1 = carry_save_add(e5s0, e4s0);
  wire [15:0] e7s1 = carry_save_add(e7s0, e6s0);
  wire [15:0] e9s1 = carry_save_add(e9s0, e8s0);
  wire [15:0] e11s1 = carry_save_add(e11s0, e10s0);
  wire [15:0] e13s1 = carry_save_add(e13s0, e12s0);
  wire [15:0] e15s1 = carry_save_add(e15s0, e14s0);
  wire [15:0] e3s2 = carry_save_add(e3s1, e1s1);
  wire [15:0] e7s2 = carry_save_add(e7s1, e5s1);
  wire [15:0] e11s2 = carry_save_add(e11s1, e9s1);
  wire [15:0] e15s2 = carry_save_add(e15s1, e13s1);
  wire [15:0] e7s3 = carry_save_add(e7s2, e3s2);
  wire [15:0] e15s3 = carry_save_add(e15s2, e11s2);
  wire [15:0] e15s4 = carry_save_add(e15s3, e7s3);
  // backward pass
  wire [15:0] e11s5 = carry_save_add(e11s2, e7s3);
  wire [15:0] e5s6 = carry_save_add(e5s1, e3s2);
  wire [15:0] e9s6 = carry_save_add(e9s1, e7s3);
  wire [15:0] e13s6 = carry_save_add(e13s1, e11s5);
  wire [15:0] e2s7 = carry_save_add(e2s0, e1s1);
  wire [15:0] e4s7 = carry_save_add(e4s0, e3s2);
  wire [15:0] e6s7 = carry_save_add(e6s0, e5s6);
  wire [15:0] e8s7 = carry_save_add(e8s0, e7s3);
  wire [15:0] e10s7 = carry_save_add(e10s0, e9s6);
  wire [15:0] e12s7 = carry_save_add(e12s0, e11s5);
  wire [15:0] e14s7 = carry_save_add(e14s0, e13s6);
  // outputs
  assign dout[0 +: 8] = carry_save_get(e0s0);
  assign dout[8 +: 8] = carry_save_get(e1s1);
  assign dout[16 +: 8] = carry_save_get(e2s7);
  assign dout[24 +: 8] = carry_save_get(e3s2);
  assign dout[32 +: 8] = carry_save_get(e4s7);
  assign dout[40 +: 8] = carry_save_get(e5s6);
  assign dout[48 +: 8] = carry_save_get(e6s7);
  assign dout[56 +: 8] = carry_save_get(e7s3);
  assign dout[64 +: 8] = carry_save_get(e8s7);
  assign dout[72 +: 8] = carry_save_get(e9s6);
  assign dout[80 +: 8] = carry_save_get(e10s7);
  assign dout[88 +: 8] = carry_save_get(e11s5);
  assign dout[96 +: 8] = carry_save_get(e12s7);
  assign dout[104 +: 8] = carry_save_get(e13s6);
  assign dout[112 +: 8] = carry_save_get(e14s7);
  assign dout[120 +: 8] = carry_save_get(e15s4);
endmodule
module rvb_bextdep_pps32 (
  input [31:0] din,
  output [255:0] dout
);
  function [15:0] carry_save_add;
    input [15:0] a, b;
    reg [7:0] x, y;
    begin
      x = a[15:8] ^ a[7:0] ^ b[7:0];
      y = ((a[15:8] & a[7:0]) | (a[15:8] & b[7:0]) | (a[7:0] & b[7:0])) << 1;
      carry_save_add[7:0] = x ^ y ^ b[15:8];
      carry_save_add[15:8] = ((x & y) | (x & b[15:8]) | (y & b[15:8])) << 1;
    end
  endfunction
  function [7:0] carry_save_get;
    input [15:0] a;
    begin
      carry_save_get = a[7:0] + a[15:8];
    end
  endfunction
  // inputs
  wire [15:0] e0s0 = {15'b0, din[0 +: 1]};
  wire [15:0] e1s0 = {15'b0, din[1 +: 1]};
  wire [15:0] e2s0 = {15'b0, din[2 +: 1]};
  wire [15:0] e3s0 = {15'b0, din[3 +: 1]};
  wire [15:0] e4s0 = {15'b0, din[4 +: 1]};
  wire [15:0] e5s0 = {15'b0, din[5 +: 1]};
  wire [15:0] e6s0 = {15'b0, din[6 +: 1]};
  wire [15:0] e7s0 = {15'b0, din[7 +: 1]};
  wire [15:0] e8s0 = {15'b0, din[8 +: 1]};
  wire [15:0] e9s0 = {15'b0, din[9 +: 1]};
  wire [15:0] e10s0 = {15'b0, din[10 +: 1]};
  wire [15:0] e11s0 = {15'b0, din[11 +: 1]};
  wire [15:0] e12s0 = {15'b0, din[12 +: 1]};
  wire [15:0] e13s0 = {15'b0, din[13 +: 1]};
  wire [15:0] e14s0 = {15'b0, din[14 +: 1]};
  wire [15:0] e15s0 = {15'b0, din[15 +: 1]};
  wire [15:0] e16s0 = {15'b0, din[16 +: 1]};
  wire [15:0] e17s0 = {15'b0, din[17 +: 1]};
  wire [15:0] e18s0 = {15'b0, din[18 +: 1]};
  wire [15:0] e19s0 = {15'b0, din[19 +: 1]};
  wire [15:0] e20s0 = {15'b0, din[20 +: 1]};
  wire [15:0] e21s0 = {15'b0, din[21 +: 1]};
  wire [15:0] e22s0 = {15'b0, din[22 +: 1]};
  wire [15:0] e23s0 = {15'b0, din[23 +: 1]};
  wire [15:0] e24s0 = {15'b0, din[24 +: 1]};
  wire [15:0] e25s0 = {15'b0, din[25 +: 1]};
  wire [15:0] e26s0 = {15'b0, din[26 +: 1]};
  wire [15:0] e27s0 = {15'b0, din[27 +: 1]};
  wire [15:0] e28s0 = {15'b0, din[28 +: 1]};
  wire [15:0] e29s0 = {15'b0, din[29 +: 1]};
  wire [15:0] e30s0 = {15'b0, din[30 +: 1]};
  wire [15:0] e31s0 = {15'b0, din[31 +: 1]};
  // forward pass
  wire [15:0] e1s1 = carry_save_add(e1s0, e0s0);
  wire [15:0] e3s1 = carry_save_add(e3s0, e2s0);
  wire [15:0] e5s1 = carry_save_add(e5s0, e4s0);
  wire [15:0] e7s1 = carry_save_add(e7s0, e6s0);
  wire [15:0] e9s1 = carry_save_add(e9s0, e8s0);
  wire [15:0] e11s1 = carry_save_add(e11s0, e10s0);
  wire [15:0] e13s1 = carry_save_add(e13s0, e12s0);
  wire [15:0] e15s1 = carry_save_add(e15s0, e14s0);
  wire [15:0] e17s1 = carry_save_add(e17s0, e16s0);
  wire [15:0] e19s1 = carry_save_add(e19s0, e18s0);
  wire [15:0] e21s1 = carry_save_add(e21s0, e20s0);
  wire [15:0] e23s1 = carry_save_add(e23s0, e22s0);
  wire [15:0] e25s1 = carry_save_add(e25s0, e24s0);
  wire [15:0] e27s1 = carry_save_add(e27s0, e26s0);
  wire [15:0] e29s1 = carry_save_add(e29s0, e28s0);
  wire [15:0] e31s1 = carry_save_add(e31s0, e30s0);
  wire [15:0] e3s2 = carry_save_add(e3s1, e1s1);
  wire [15:0] e7s2 = carry_save_add(e7s1, e5s1);
  wire [15:0] e11s2 = carry_save_add(e11s1, e9s1);
  wire [15:0] e15s2 = carry_save_add(e15s1, e13s1);
  wire [15:0] e19s2 = carry_save_add(e19s1, e17s1);
  wire [15:0] e23s2 = carry_save_add(e23s1, e21s1);
  wire [15:0] e27s2 = carry_save_add(e27s1, e25s1);
  wire [15:0] e31s2 = carry_save_add(e31s1, e29s1);
  wire [15:0] e7s3 = carry_save_add(e7s2, e3s2);
  wire [15:0] e15s3 = carry_save_add(e15s2, e11s2);
  wire [15:0] e23s3 = carry_save_add(e23s2, e19s2);
  wire [15:0] e31s3 = carry_save_add(e31s2, e27s2);
  wire [15:0] e15s4 = carry_save_add(e15s3, e7s3);
  wire [15:0] e31s4 = carry_save_add(e31s3, e23s3);
  wire [15:0] e31s5 = carry_save_add(e31s4, e15s4);
  // backward pass
  wire [15:0] e23s6 = carry_save_add(e23s3, e15s4);
  wire [15:0] e11s7 = carry_save_add(e11s2, e7s3);
  wire [15:0] e19s7 = carry_save_add(e19s2, e15s4);
  wire [15:0] e27s7 = carry_save_add(e27s2, e23s6);
  wire [15:0] e5s8 = carry_save_add(e5s1, e3s2);
  wire [15:0] e9s8 = carry_save_add(e9s1, e7s3);
  wire [15:0] e13s8 = carry_save_add(e13s1, e11s7);
  wire [15:0] e17s8 = carry_save_add(e17s1, e15s4);
  wire [15:0] e21s8 = carry_save_add(e21s1, e19s7);
  wire [15:0] e25s8 = carry_save_add(e25s1, e23s6);
  wire [15:0] e29s8 = carry_save_add(e29s1, e27s7);
  wire [15:0] e2s9 = carry_save_add(e2s0, e1s1);
  wire [15:0] e4s9 = carry_save_add(e4s0, e3s2);
  wire [15:0] e6s9 = carry_save_add(e6s0, e5s8);
  wire [15:0] e8s9 = carry_save_add(e8s0, e7s3);
  wire [15:0] e10s9 = carry_save_add(e10s0, e9s8);
  wire [15:0] e12s9 = carry_save_add(e12s0, e11s7);
  wire [15:0] e14s9 = carry_save_add(e14s0, e13s8);
  wire [15:0] e16s9 = carry_save_add(e16s0, e15s4);
  wire [15:0] e18s9 = carry_save_add(e18s0, e17s8);
  wire [15:0] e20s9 = carry_save_add(e20s0, e19s7);
  wire [15:0] e22s9 = carry_save_add(e22s0, e21s8);
  wire [15:0] e24s9 = carry_save_add(e24s0, e23s6);
  wire [15:0] e26s9 = carry_save_add(e26s0, e25s8);
  wire [15:0] e28s9 = carry_save_add(e28s0, e27s7);
  wire [15:0] e30s9 = carry_save_add(e30s0, e29s8);
  // outputs
  assign dout[0 +: 8] = carry_save_get(e0s0);
  assign dout[8 +: 8] = carry_save_get(e1s1);
  assign dout[16 +: 8] = carry_save_get(e2s9);
  assign dout[24 +: 8] = carry_save_get(e3s2);
  assign dout[32 +: 8] = carry_save_get(e4s9);
  assign dout[40 +: 8] = carry_save_get(e5s8);
  assign dout[48 +: 8] = carry_save_get(e6s9);
  assign dout[56 +: 8] = carry_save_get(e7s3);
  assign dout[64 +: 8] = carry_save_get(e8s9);
  assign dout[72 +: 8] = carry_save_get(e9s8);
  assign dout[80 +: 8] = carry_save_get(e10s9);
  assign dout[88 +: 8] = carry_save_get(e11s7);
  assign dout[96 +: 8] = carry_save_get(e12s9);
  assign dout[104 +: 8] = carry_save_get(e13s8);
  assign dout[112 +: 8] = carry_save_get(e14s9);
  assign dout[120 +: 8] = carry_save_get(e15s4);
  assign dout[128 +: 8] = carry_save_get(e16s9);
  assign dout[136 +: 8] = carry_save_get(e17s8);
  assign dout[144 +: 8] = carry_save_get(e18s9);
  assign dout[152 +: 8] = carry_save_get(e19s7);
  assign dout[160 +: 8] = carry_save_get(e20s9);
  assign dout[168 +: 8] = carry_save_get(e21s8);
  assign dout[176 +: 8] = carry_save_get(e22s9);
  assign dout[184 +: 8] = carry_save_get(e23s6);
  assign dout[192 +: 8] = carry_save_get(e24s9);
  assign dout[200 +: 8] = carry_save_get(e25s8);
  assign dout[208 +: 8] = carry_save_get(e26s9);
  assign dout[216 +: 8] = carry_save_get(e27s7);
  assign dout[224 +: 8] = carry_save_get(e28s9);
  assign dout[232 +: 8] = carry_save_get(e29s8);
  assign dout[240 +: 8] = carry_save_get(e30s9);
  assign dout[248 +: 8] = carry_save_get(e31s5);
endmodule
module rvb_bextdep_pps64 (
  input [63:0] din,
  output [511:0] dout
);
  function [15:0] carry_save_add;
    input [15:0] a, b;
    reg [7:0] x, y;
    begin
      x = a[15:8] ^ a[7:0] ^ b[7:0];
      y = ((a[15:8] & a[7:0]) | (a[15:8] & b[7:0]) | (a[7:0] & b[7:0])) << 1;
      carry_save_add[7:0] = x ^ y ^ b[15:8];
      carry_save_add[15:8] = ((x & y) | (x & b[15:8]) | (y & b[15:8])) << 1;
    end
  endfunction
  function [7:0] carry_save_get;
    input [15:0] a;
    begin
      carry_save_get = a[7:0] + a[15:8];
    end
  endfunction
  // inputs
  wire [15:0] e0s0 = {15'b0, din[0 +: 1]};
  wire [15:0] e1s0 = {15'b0, din[1 +: 1]};
  wire [15:0] e2s0 = {15'b0, din[2 +: 1]};
  wire [15:0] e3s0 = {15'b0, din[3 +: 1]};
  wire [15:0] e4s0 = {15'b0, din[4 +: 1]};
  wire [15:0] e5s0 = {15'b0, din[5 +: 1]};
  wire [15:0] e6s0 = {15'b0, din[6 +: 1]};
  wire [15:0] e7s0 = {15'b0, din[7 +: 1]};
  wire [15:0] e8s0 = {15'b0, din[8 +: 1]};
  wire [15:0] e9s0 = {15'b0, din[9 +: 1]};
  wire [15:0] e10s0 = {15'b0, din[10 +: 1]};
  wire [15:0] e11s0 = {15'b0, din[11 +: 1]};
  wire [15:0] e12s0 = {15'b0, din[12 +: 1]};
  wire [15:0] e13s0 = {15'b0, din[13 +: 1]};
  wire [15:0] e14s0 = {15'b0, din[14 +: 1]};
  wire [15:0] e15s0 = {15'b0, din[15 +: 1]};
  wire [15:0] e16s0 = {15'b0, din[16 +: 1]};
  wire [15:0] e17s0 = {15'b0, din[17 +: 1]};
  wire [15:0] e18s0 = {15'b0, din[18 +: 1]};
  wire [15:0] e19s0 = {15'b0, din[19 +: 1]};
  wire [15:0] e20s0 = {15'b0, din[20 +: 1]};
  wire [15:0] e21s0 = {15'b0, din[21 +: 1]};
  wire [15:0] e22s0 = {15'b0, din[22 +: 1]};
  wire [15:0] e23s0 = {15'b0, din[23 +: 1]};
  wire [15:0] e24s0 = {15'b0, din[24 +: 1]};
  wire [15:0] e25s0 = {15'b0, din[25 +: 1]};
  wire [15:0] e26s0 = {15'b0, din[26 +: 1]};
  wire [15:0] e27s0 = {15'b0, din[27 +: 1]};
  wire [15:0] e28s0 = {15'b0, din[28 +: 1]};
  wire [15:0] e29s0 = {15'b0, din[29 +: 1]};
  wire [15:0] e30s0 = {15'b0, din[30 +: 1]};
  wire [15:0] e31s0 = {15'b0, din[31 +: 1]};
  wire [15:0] e32s0 = {15'b0, din[32 +: 1]};
  wire [15:0] e33s0 = {15'b0, din[33 +: 1]};
  wire [15:0] e34s0 = {15'b0, din[34 +: 1]};
  wire [15:0] e35s0 = {15'b0, din[35 +: 1]};
  wire [15:0] e36s0 = {15'b0, din[36 +: 1]};
  wire [15:0] e37s0 = {15'b0, din[37 +: 1]};
  wire [15:0] e38s0 = {15'b0, din[38 +: 1]};
  wire [15:0] e39s0 = {15'b0, din[39 +: 1]};
  wire [15:0] e40s0 = {15'b0, din[40 +: 1]};
  wire [15:0] e41s0 = {15'b0, din[41 +: 1]};
  wire [15:0] e42s0 = {15'b0, din[42 +: 1]};
  wire [15:0] e43s0 = {15'b0, din[43 +: 1]};
  wire [15:0] e44s0 = {15'b0, din[44 +: 1]};
  wire [15:0] e45s0 = {15'b0, din[45 +: 1]};
  wire [15:0] e46s0 = {15'b0, din[46 +: 1]};
  wire [15:0] e47s0 = {15'b0, din[47 +: 1]};
  wire [15:0] e48s0 = {15'b0, din[48 +: 1]};
  wire [15:0] e49s0 = {15'b0, din[49 +: 1]};
  wire [15:0] e50s0 = {15'b0, din[50 +: 1]};
  wire [15:0] e51s0 = {15'b0, din[51 +: 1]};
  wire [15:0] e52s0 = {15'b0, din[52 +: 1]};
  wire [15:0] e53s0 = {15'b0, din[53 +: 1]};
  wire [15:0] e54s0 = {15'b0, din[54 +: 1]};
  wire [15:0] e55s0 = {15'b0, din[55 +: 1]};
  wire [15:0] e56s0 = {15'b0, din[56 +: 1]};
  wire [15:0] e57s0 = {15'b0, din[57 +: 1]};
  wire [15:0] e58s0 = {15'b0, din[58 +: 1]};
  wire [15:0] e59s0 = {15'b0, din[59 +: 1]};
  wire [15:0] e60s0 = {15'b0, din[60 +: 1]};
  wire [15:0] e61s0 = {15'b0, din[61 +: 1]};
  wire [15:0] e62s0 = {15'b0, din[62 +: 1]};
  wire [15:0] e63s0 = {15'b0, din[63 +: 1]};
  // forward pass
  wire [15:0] e1s1 = carry_save_add(e1s0, e0s0);
  wire [15:0] e3s1 = carry_save_add(e3s0, e2s0);
  wire [15:0] e5s1 = carry_save_add(e5s0, e4s0);
  wire [15:0] e7s1 = carry_save_add(e7s0, e6s0);
  wire [15:0] e9s1 = carry_save_add(e9s0, e8s0);
  wire [15:0] e11s1 = carry_save_add(e11s0, e10s0);
  wire [15:0] e13s1 = carry_save_add(e13s0, e12s0);
  wire [15:0] e15s1 = carry_save_add(e15s0, e14s0);
  wire [15:0] e17s1 = carry_save_add(e17s0, e16s0);
  wire [15:0] e19s1 = carry_save_add(e19s0, e18s0);
  wire [15:0] e21s1 = carry_save_add(e21s0, e20s0);
  wire [15:0] e23s1 = carry_save_add(e23s0, e22s0);
  wire [15:0] e25s1 = carry_save_add(e25s0, e24s0);
  wire [15:0] e27s1 = carry_save_add(e27s0, e26s0);
  wire [15:0] e29s1 = carry_save_add(e29s0, e28s0);
  wire [15:0] e31s1 = carry_save_add(e31s0, e30s0);
  wire [15:0] e33s1 = carry_save_add(e33s0, e32s0);
  wire [15:0] e35s1 = carry_save_add(e35s0, e34s0);
  wire [15:0] e37s1 = carry_save_add(e37s0, e36s0);
  wire [15:0] e39s1 = carry_save_add(e39s0, e38s0);
  wire [15:0] e41s1 = carry_save_add(e41s0, e40s0);
  wire [15:0] e43s1 = carry_save_add(e43s0, e42s0);
  wire [15:0] e45s1 = carry_save_add(e45s0, e44s0);
  wire [15:0] e47s1 = carry_save_add(e47s0, e46s0);
  wire [15:0] e49s1 = carry_save_add(e49s0, e48s0);
  wire [15:0] e51s1 = carry_save_add(e51s0, e50s0);
  wire [15:0] e53s1 = carry_save_add(e53s0, e52s0);
  wire [15:0] e55s1 = carry_save_add(e55s0, e54s0);
  wire [15:0] e57s1 = carry_save_add(e57s0, e56s0);
  wire [15:0] e59s1 = carry_save_add(e59s0, e58s0);
  wire [15:0] e61s1 = carry_save_add(e61s0, e60s0);
  wire [15:0] e63s1 = carry_save_add(e63s0, e62s0);
  wire [15:0] e3s2 = carry_save_add(e3s1, e1s1);
  wire [15:0] e7s2 = carry_save_add(e7s1, e5s1);
  wire [15:0] e11s2 = carry_save_add(e11s1, e9s1);
  wire [15:0] e15s2 = carry_save_add(e15s1, e13s1);
  wire [15:0] e19s2 = carry_save_add(e19s1, e17s1);
  wire [15:0] e23s2 = carry_save_add(e23s1, e21s1);
  wire [15:0] e27s2 = carry_save_add(e27s1, e25s1);
  wire [15:0] e31s2 = carry_save_add(e31s1, e29s1);
  wire [15:0] e35s2 = carry_save_add(e35s1, e33s1);
  wire [15:0] e39s2 = carry_save_add(e39s1, e37s1);
  wire [15:0] e43s2 = carry_save_add(e43s1, e41s1);
  wire [15:0] e47s2 = carry_save_add(e47s1, e45s1);
  wire [15:0] e51s2 = carry_save_add(e51s1, e49s1);
  wire [15:0] e55s2 = carry_save_add(e55s1, e53s1);
  wire [15:0] e59s2 = carry_save_add(e59s1, e57s1);
  wire [15:0] e63s2 = carry_save_add(e63s1, e61s1);
  wire [15:0] e7s3 = carry_save_add(e7s2, e3s2);
  wire [15:0] e15s3 = carry_save_add(e15s2, e11s2);
  wire [15:0] e23s3 = carry_save_add(e23s2, e19s2);
  wire [15:0] e31s3 = carry_save_add(e31s2, e27s2);
  wire [15:0] e39s3 = carry_save_add(e39s2, e35s2);
  wire [15:0] e47s3 = carry_save_add(e47s2, e43s2);
  wire [15:0] e55s3 = carry_save_add(e55s2, e51s2);
  wire [15:0] e63s3 = carry_save_add(e63s2, e59s2);
  wire [15:0] e15s4 = carry_save_add(e15s3, e7s3);
  wire [15:0] e31s4 = carry_save_add(e31s3, e23s3);
  wire [15:0] e47s4 = carry_save_add(e47s3, e39s3);
  wire [15:0] e63s4 = carry_save_add(e63s3, e55s3);
  wire [15:0] e31s5 = carry_save_add(e31s4, e15s4);
  wire [15:0] e63s5 = carry_save_add(e63s4, e47s4);
  wire [15:0] e63s6 = carry_save_add(e63s5, e31s5);
  // backward pass
  wire [15:0] e47s7 = carry_save_add(e47s4, e31s5);
  wire [15:0] e23s8 = carry_save_add(e23s3, e15s4);
  wire [15:0] e39s8 = carry_save_add(e39s3, e31s5);
  wire [15:0] e55s8 = carry_save_add(e55s3, e47s7);
  wire [15:0] e11s9 = carry_save_add(e11s2, e7s3);
  wire [15:0] e19s9 = carry_save_add(e19s2, e15s4);
  wire [15:0] e27s9 = carry_save_add(e27s2, e23s8);
  wire [15:0] e35s9 = carry_save_add(e35s2, e31s5);
  wire [15:0] e43s9 = carry_save_add(e43s2, e39s8);
  wire [15:0] e51s9 = carry_save_add(e51s2, e47s7);
  wire [15:0] e59s9 = carry_save_add(e59s2, e55s8);
  wire [15:0] e5s10 = carry_save_add(e5s1, e3s2);
  wire [15:0] e9s10 = carry_save_add(e9s1, e7s3);
  wire [15:0] e13s10 = carry_save_add(e13s1, e11s9);
  wire [15:0] e17s10 = carry_save_add(e17s1, e15s4);
  wire [15:0] e21s10 = carry_save_add(e21s1, e19s9);
  wire [15:0] e25s10 = carry_save_add(e25s1, e23s8);
  wire [15:0] e29s10 = carry_save_add(e29s1, e27s9);
  wire [15:0] e33s10 = carry_save_add(e33s1, e31s5);
  wire [15:0] e37s10 = carry_save_add(e37s1, e35s9);
  wire [15:0] e41s10 = carry_save_add(e41s1, e39s8);
  wire [15:0] e45s10 = carry_save_add(e45s1, e43s9);
  wire [15:0] e49s10 = carry_save_add(e49s1, e47s7);
  wire [15:0] e53s10 = carry_save_add(e53s1, e51s9);
  wire [15:0] e57s10 = carry_save_add(e57s1, e55s8);
  wire [15:0] e61s10 = carry_save_add(e61s1, e59s9);
  wire [15:0] e2s11 = carry_save_add(e2s0, e1s1);
  wire [15:0] e4s11 = carry_save_add(e4s0, e3s2);
  wire [15:0] e6s11 = carry_save_add(e6s0, e5s10);
  wire [15:0] e8s11 = carry_save_add(e8s0, e7s3);
  wire [15:0] e10s11 = carry_save_add(e10s0, e9s10);
  wire [15:0] e12s11 = carry_save_add(e12s0, e11s9);
  wire [15:0] e14s11 = carry_save_add(e14s0, e13s10);
  wire [15:0] e16s11 = carry_save_add(e16s0, e15s4);
  wire [15:0] e18s11 = carry_save_add(e18s0, e17s10);
  wire [15:0] e20s11 = carry_save_add(e20s0, e19s9);
  wire [15:0] e22s11 = carry_save_add(e22s0, e21s10);
  wire [15:0] e24s11 = carry_save_add(e24s0, e23s8);
  wire [15:0] e26s11 = carry_save_add(e26s0, e25s10);
  wire [15:0] e28s11 = carry_save_add(e28s0, e27s9);
  wire [15:0] e30s11 = carry_save_add(e30s0, e29s10);
  wire [15:0] e32s11 = carry_save_add(e32s0, e31s5);
  wire [15:0] e34s11 = carry_save_add(e34s0, e33s10);
  wire [15:0] e36s11 = carry_save_add(e36s0, e35s9);
  wire [15:0] e38s11 = carry_save_add(e38s0, e37s10);
  wire [15:0] e40s11 = carry_save_add(e40s0, e39s8);
  wire [15:0] e42s11 = carry_save_add(e42s0, e41s10);
  wire [15:0] e44s11 = carry_save_add(e44s0, e43s9);
  wire [15:0] e46s11 = carry_save_add(e46s0, e45s10);
  wire [15:0] e48s11 = carry_save_add(e48s0, e47s7);
  wire [15:0] e50s11 = carry_save_add(e50s0, e49s10);
  wire [15:0] e52s11 = carry_save_add(e52s0, e51s9);
  wire [15:0] e54s11 = carry_save_add(e54s0, e53s10);
  wire [15:0] e56s11 = carry_save_add(e56s0, e55s8);
  wire [15:0] e58s11 = carry_save_add(e58s0, e57s10);
  wire [15:0] e60s11 = carry_save_add(e60s0, e59s9);
  wire [15:0] e62s11 = carry_save_add(e62s0, e61s10);
  // outputs
  assign dout[0 +: 8] = carry_save_get(e0s0);
  assign dout[8 +: 8] = carry_save_get(e1s1);
  assign dout[16 +: 8] = carry_save_get(e2s11);
  assign dout[24 +: 8] = carry_save_get(e3s2);
  assign dout[32 +: 8] = carry_save_get(e4s11);
  assign dout[40 +: 8] = carry_save_get(e5s10);
  assign dout[48 +: 8] = carry_save_get(e6s11);
  assign dout[56 +: 8] = carry_save_get(e7s3);
  assign dout[64 +: 8] = carry_save_get(e8s11);
  assign dout[72 +: 8] = carry_save_get(e9s10);
  assign dout[80 +: 8] = carry_save_get(e10s11);
  assign dout[88 +: 8] = carry_save_get(e11s9);
  assign dout[96 +: 8] = carry_save_get(e12s11);
  assign dout[104 +: 8] = carry_save_get(e13s10);
  assign dout[112 +: 8] = carry_save_get(e14s11);
  assign dout[120 +: 8] = carry_save_get(e15s4);
  assign dout[128 +: 8] = carry_save_get(e16s11);
  assign dout[136 +: 8] = carry_save_get(e17s10);
  assign dout[144 +: 8] = carry_save_get(e18s11);
  assign dout[152 +: 8] = carry_save_get(e19s9);
  assign dout[160 +: 8] = carry_save_get(e20s11);
  assign dout[168 +: 8] = carry_save_get(e21s10);
  assign dout[176 +: 8] = carry_save_get(e22s11);
  assign dout[184 +: 8] = carry_save_get(e23s8);
  assign dout[192 +: 8] = carry_save_get(e24s11);
  assign dout[200 +: 8] = carry_save_get(e25s10);
  assign dout[208 +: 8] = carry_save_get(e26s11);
  assign dout[216 +: 8] = carry_save_get(e27s9);
  assign dout[224 +: 8] = carry_save_get(e28s11);
  assign dout[232 +: 8] = carry_save_get(e29s10);
  assign dout[240 +: 8] = carry_save_get(e30s11);
  assign dout[248 +: 8] = carry_save_get(e31s5);
  assign dout[256 +: 8] = carry_save_get(e32s11);
  assign dout[264 +: 8] = carry_save_get(e33s10);
  assign dout[272 +: 8] = carry_save_get(e34s11);
  assign dout[280 +: 8] = carry_save_get(e35s9);
  assign dout[288 +: 8] = carry_save_get(e36s11);
  assign dout[296 +: 8] = carry_save_get(e37s10);
  assign dout[304 +: 8] = carry_save_get(e38s11);
  assign dout[312 +: 8] = carry_save_get(e39s8);
  assign dout[320 +: 8] = carry_save_get(e40s11);
  assign dout[328 +: 8] = carry_save_get(e41s10);
  assign dout[336 +: 8] = carry_save_get(e42s11);
  assign dout[344 +: 8] = carry_save_get(e43s9);
  assign dout[352 +: 8] = carry_save_get(e44s11);
  assign dout[360 +: 8] = carry_save_get(e45s10);
  assign dout[368 +: 8] = carry_save_get(e46s11);
  assign dout[376 +: 8] = carry_save_get(e47s7);
  assign dout[384 +: 8] = carry_save_get(e48s11);
  assign dout[392 +: 8] = carry_save_get(e49s10);
  assign dout[400 +: 8] = carry_save_get(e50s11);
  assign dout[408 +: 8] = carry_save_get(e51s9);
  assign dout[416 +: 8] = carry_save_get(e52s11);
  assign dout[424 +: 8] = carry_save_get(e53s10);
  assign dout[432 +: 8] = carry_save_get(e54s11);
  assign dout[440 +: 8] = carry_save_get(e55s8);
  assign dout[448 +: 8] = carry_save_get(e56s11);
  assign dout[456 +: 8] = carry_save_get(e57s10);
  assign dout[464 +: 8] = carry_save_get(e58s11);
  assign dout[472 +: 8] = carry_save_get(e59s9);
  assign dout[480 +: 8] = carry_save_get(e60s11);
  assign dout[488 +: 8] = carry_save_get(e61s10);
  assign dout[496 +: 8] = carry_save_get(e62s11);
  assign dout[504 +: 8] = carry_save_get(e63s6);
endmodule
module rvb_bextdep_pps32f (
  input clock,
  input [31:0] din,
  output [255:0] dout
);
  function [15:0] carry_save_add;
    input [15:0] a, b;
    reg [7:0] x, y;
    begin
      x = a[15:8] ^ a[7:0] ^ b[7:0];
      y = ((a[15:8] & a[7:0]) | (a[15:8] & b[7:0]) | (a[7:0] & b[7:0])) << 1;
      carry_save_add[7:0] = x ^ y ^ b[15:8];
      carry_save_add[15:8] = ((x & y) | (x & b[15:8]) | (y & b[15:8])) << 1;
    end
  endfunction
  function [7:0] carry_save_get;
    input [15:0] a;
    begin
      carry_save_get = a[7:0] + a[15:8];
    end
  endfunction
  // inputs
  wire [15:0] e0s0 = {15'b0, din[0 +: 1]};
  wire [15:0] e1s0 = {15'b0, din[1 +: 1]};
  wire [15:0] e2s0 = {15'b0, din[2 +: 1]};
  wire [15:0] e3s0 = {15'b0, din[3 +: 1]};
  wire [15:0] e4s0 = {15'b0, din[4 +: 1]};
  wire [15:0] e5s0 = {15'b0, din[5 +: 1]};
  wire [15:0] e6s0 = {15'b0, din[6 +: 1]};
  wire [15:0] e7s0 = {15'b0, din[7 +: 1]};
  wire [15:0] e8s0 = {15'b0, din[8 +: 1]};
  wire [15:0] e9s0 = {15'b0, din[9 +: 1]};
  wire [15:0] e10s0 = {15'b0, din[10 +: 1]};
  wire [15:0] e11s0 = {15'b0, din[11 +: 1]};
  wire [15:0] e12s0 = {15'b0, din[12 +: 1]};
  wire [15:0] e13s0 = {15'b0, din[13 +: 1]};
  wire [15:0] e14s0 = {15'b0, din[14 +: 1]};
  wire [15:0] e15s0 = {15'b0, din[15 +: 1]};
  wire [15:0] e16s0 = {15'b0, din[16 +: 1]};
  wire [15:0] e17s0 = {15'b0, din[17 +: 1]};
  wire [15:0] e18s0 = {15'b0, din[18 +: 1]};
  wire [15:0] e19s0 = {15'b0, din[19 +: 1]};
  wire [15:0] e20s0 = {15'b0, din[20 +: 1]};
  wire [15:0] e21s0 = {15'b0, din[21 +: 1]};
  wire [15:0] e22s0 = {15'b0, din[22 +: 1]};
  wire [15:0] e23s0 = {15'b0, din[23 +: 1]};
  wire [15:0] e24s0 = {15'b0, din[24 +: 1]};
  wire [15:0] e25s0 = {15'b0, din[25 +: 1]};
  wire [15:0] e26s0 = {15'b0, din[26 +: 1]};
  wire [15:0] e27s0 = {15'b0, din[27 +: 1]};
  wire [15:0] e28s0 = {15'b0, din[28 +: 1]};
  wire [15:0] e29s0 = {15'b0, din[29 +: 1]};
  wire [15:0] e30s0 = {15'b0, din[30 +: 1]};
  wire [15:0] e31s0 = {15'b0, din[31 +: 1]};
  // forward pass
  wire [15:0] e1s1 = carry_save_add(e1s0, e0s0);
  wire [15:0] e3s1 = carry_save_add(e3s0, e2s0);
  wire [15:0] e5s1 = carry_save_add(e5s0, e4s0);
  wire [15:0] e7s1 = carry_save_add(e7s0, e6s0);
  wire [15:0] e9s1 = carry_save_add(e9s0, e8s0);
  wire [15:0] e11s1 = carry_save_add(e11s0, e10s0);
  wire [15:0] e13s1 = carry_save_add(e13s0, e12s0);
  wire [15:0] e15s1 = carry_save_add(e15s0, e14s0);
  wire [15:0] e17s1 = carry_save_add(e17s0, e16s0);
  wire [15:0] e19s1 = carry_save_add(e19s0, e18s0);
  wire [15:0] e21s1 = carry_save_add(e21s0, e20s0);
  wire [15:0] e23s1 = carry_save_add(e23s0, e22s0);
  wire [15:0] e25s1 = carry_save_add(e25s0, e24s0);
  wire [15:0] e27s1 = carry_save_add(e27s0, e26s0);
  wire [15:0] e29s1 = carry_save_add(e29s0, e28s0);
  wire [15:0] e31s1 = carry_save_add(e31s0, e30s0);
  wire [15:0] e3s2 = carry_save_add(e3s1, e1s1);
  wire [15:0] e7s2 = carry_save_add(e7s1, e5s1);
  wire [15:0] e11s2 = carry_save_add(e11s1, e9s1);
  wire [15:0] e15s2 = carry_save_add(e15s1, e13s1);
  wire [15:0] e19s2 = carry_save_add(e19s1, e17s1);
  wire [15:0] e23s2 = carry_save_add(e23s1, e21s1);
  wire [15:0] e27s2 = carry_save_add(e27s1, e25s1);
  wire [15:0] e31s2 = carry_save_add(e31s1, e29s1);
  wire [15:0] e7s3 = carry_save_add(e7s2, e3s2);
  wire [15:0] e15s3 = carry_save_add(e15s2, e11s2);
  wire [15:0] e23s3 = carry_save_add(e23s2, e19s2);
  wire [15:0] e31s3 = carry_save_add(e31s2, e27s2);
  wire [15:0] e15s4 = carry_save_add(e15s3, e7s3);
  wire [15:0] e31s4 = carry_save_add(e31s3, e23s3);
  wire [15:0] e31s5 = carry_save_add(e31s4, e15s4);
  // backward pass
  reg [15:0] r23;
  always @(posedge clock) r23 <= e23s3;
  reg [15:0] r15;
  always @(posedge clock) r15 <= e15s4;
  wire [15:0] e23s6 = carry_save_add(r23, r15);
  reg [15:0] r11;
  always @(posedge clock) r11 <= e11s2;
  reg [15:0] r7;
  always @(posedge clock) r7 <= e7s3;
  wire [15:0] e11s7 = carry_save_add(r11, r7);
  reg [15:0] r19;
  always @(posedge clock) r19 <= e19s2;
  wire [15:0] e19s7 = carry_save_add(r19, r15);
  reg [15:0] r27;
  always @(posedge clock) r27 <= e27s2;
  wire [15:0] e27s7 = carry_save_add(r27, e23s6);
  reg [15:0] r5;
  always @(posedge clock) r5 <= e5s1;
  reg [15:0] r3;
  always @(posedge clock) r3 <= e3s2;
  wire [15:0] e5s8 = carry_save_add(r5, r3);
  reg [15:0] r9;
  always @(posedge clock) r9 <= e9s1;
  wire [15:0] e9s8 = carry_save_add(r9, r7);
  reg [15:0] r13;
  always @(posedge clock) r13 <= e13s1;
  wire [15:0] e13s8 = carry_save_add(r13, e11s7);
  reg [15:0] r17;
  always @(posedge clock) r17 <= e17s1;
  wire [15:0] e17s8 = carry_save_add(r17, r15);
  reg [15:0] r21;
  always @(posedge clock) r21 <= e21s1;
  wire [15:0] e21s8 = carry_save_add(r21, e19s7);
  reg [15:0] r25;
  always @(posedge clock) r25 <= e25s1;
  wire [15:0] e25s8 = carry_save_add(r25, e23s6);
  reg [15:0] r29;
  always @(posedge clock) r29 <= e29s1;
  wire [15:0] e29s8 = carry_save_add(r29, e27s7);
  reg [15:0] r2;
  always @(posedge clock) r2 <= e2s0;
  reg [15:0] r1;
  always @(posedge clock) r1 <= e1s1;
  wire [15:0] e2s9 = carry_save_add(r2, r1);
  reg [15:0] r4;
  always @(posedge clock) r4 <= e4s0;
  wire [15:0] e4s9 = carry_save_add(r4, r3);
  reg [15:0] r6;
  always @(posedge clock) r6 <= e6s0;
  wire [15:0] e6s9 = carry_save_add(r6, e5s8);
  reg [15:0] r8;
  always @(posedge clock) r8 <= e8s0;
  wire [15:0] e8s9 = carry_save_add(r8, r7);
  reg [15:0] r10;
  always @(posedge clock) r10 <= e10s0;
  wire [15:0] e10s9 = carry_save_add(r10, e9s8);
  reg [15:0] r12;
  always @(posedge clock) r12 <= e12s0;
  wire [15:0] e12s9 = carry_save_add(r12, e11s7);
  reg [15:0] r14;
  always @(posedge clock) r14 <= e14s0;
  wire [15:0] e14s9 = carry_save_add(r14, e13s8);
  reg [15:0] r16;
  always @(posedge clock) r16 <= e16s0;
  wire [15:0] e16s9 = carry_save_add(r16, r15);
  reg [15:0] r18;
  always @(posedge clock) r18 <= e18s0;
  wire [15:0] e18s9 = carry_save_add(r18, e17s8);
  reg [15:0] r20;
  always @(posedge clock) r20 <= e20s0;
  wire [15:0] e20s9 = carry_save_add(r20, e19s7);
  reg [15:0] r22;
  always @(posedge clock) r22 <= e22s0;
  wire [15:0] e22s9 = carry_save_add(r22, e21s8);
  reg [15:0] r24;
  always @(posedge clock) r24 <= e24s0;
  wire [15:0] e24s9 = carry_save_add(r24, e23s6);
  reg [15:0] r26;
  always @(posedge clock) r26 <= e26s0;
  wire [15:0] e26s9 = carry_save_add(r26, e25s8);
  reg [15:0] r28;
  always @(posedge clock) r28 <= e28s0;
  wire [15:0] e28s9 = carry_save_add(r28, e27s7);
  reg [15:0] r30;
  always @(posedge clock) r30 <= e30s0;
  wire [15:0] e30s9 = carry_save_add(r30, e29s8);
  // outputs
  reg [15:0] r0;
  always @(posedge clock) r0 <= e0s0;
  assign dout[0 +: 8] = carry_save_get(r0);
  assign dout[8 +: 8] = carry_save_get(r1);
  assign dout[16 +: 8] = carry_save_get(e2s9);
  assign dout[24 +: 8] = carry_save_get(r3);
  assign dout[32 +: 8] = carry_save_get(e4s9);
  assign dout[40 +: 8] = carry_save_get(e5s8);
  assign dout[48 +: 8] = carry_save_get(e6s9);
  assign dout[56 +: 8] = carry_save_get(r7);
  assign dout[64 +: 8] = carry_save_get(e8s9);
  assign dout[72 +: 8] = carry_save_get(e9s8);
  assign dout[80 +: 8] = carry_save_get(e10s9);
  assign dout[88 +: 8] = carry_save_get(e11s7);
  assign dout[96 +: 8] = carry_save_get(e12s9);
  assign dout[104 +: 8] = carry_save_get(e13s8);
  assign dout[112 +: 8] = carry_save_get(e14s9);
  assign dout[120 +: 8] = carry_save_get(r15);
  assign dout[128 +: 8] = carry_save_get(e16s9);
  assign dout[136 +: 8] = carry_save_get(e17s8);
  assign dout[144 +: 8] = carry_save_get(e18s9);
  assign dout[152 +: 8] = carry_save_get(e19s7);
  assign dout[160 +: 8] = carry_save_get(e20s9);
  assign dout[168 +: 8] = carry_save_get(e21s8);
  assign dout[176 +: 8] = carry_save_get(e22s9);
  assign dout[184 +: 8] = carry_save_get(e23s6);
  assign dout[192 +: 8] = carry_save_get(e24s9);
  assign dout[200 +: 8] = carry_save_get(e25s8);
  assign dout[208 +: 8] = carry_save_get(e26s9);
  assign dout[216 +: 8] = carry_save_get(e27s7);
  assign dout[224 +: 8] = carry_save_get(e28s9);
  assign dout[232 +: 8] = carry_save_get(e29s8);
  assign dout[240 +: 8] = carry_save_get(e30s9);
  reg [15:0] r31;
  always @(posedge clock) r31 <= e31s5;
  assign dout[248 +: 8] = carry_save_get(r31);
endmodule
module rvb_bextdep_pps64f (
  input clock,
  input [63:0] din,
  output [511:0] dout
);
  function [15:0] carry_save_add;
    input [15:0] a, b;
    reg [7:0] x, y;
    begin
      x = a[15:8] ^ a[7:0] ^ b[7:0];
      y = ((a[15:8] & a[7:0]) | (a[15:8] & b[7:0]) | (a[7:0] & b[7:0])) << 1;
      carry_save_add[7:0] = x ^ y ^ b[15:8];
      carry_save_add[15:8] = ((x & y) | (x & b[15:8]) | (y & b[15:8])) << 1;
    end
  endfunction
  function [7:0] carry_save_get;
    input [15:0] a;
    begin
      carry_save_get = a[7:0] + a[15:8];
    end
  endfunction
  // inputs
  wire [15:0] e0s0 = {15'b0, din[0 +: 1]};
  wire [15:0] e1s0 = {15'b0, din[1 +: 1]};
  wire [15:0] e2s0 = {15'b0, din[2 +: 1]};
  wire [15:0] e3s0 = {15'b0, din[3 +: 1]};
  wire [15:0] e4s0 = {15'b0, din[4 +: 1]};
  wire [15:0] e5s0 = {15'b0, din[5 +: 1]};
  wire [15:0] e6s0 = {15'b0, din[6 +: 1]};
  wire [15:0] e7s0 = {15'b0, din[7 +: 1]};
  wire [15:0] e8s0 = {15'b0, din[8 +: 1]};
  wire [15:0] e9s0 = {15'b0, din[9 +: 1]};
  wire [15:0] e10s0 = {15'b0, din[10 +: 1]};
  wire [15:0] e11s0 = {15'b0, din[11 +: 1]};
  wire [15:0] e12s0 = {15'b0, din[12 +: 1]};
  wire [15:0] e13s0 = {15'b0, din[13 +: 1]};
  wire [15:0] e14s0 = {15'b0, din[14 +: 1]};
  wire [15:0] e15s0 = {15'b0, din[15 +: 1]};
  wire [15:0] e16s0 = {15'b0, din[16 +: 1]};
  wire [15:0] e17s0 = {15'b0, din[17 +: 1]};
  wire [15:0] e18s0 = {15'b0, din[18 +: 1]};
  wire [15:0] e19s0 = {15'b0, din[19 +: 1]};
  wire [15:0] e20s0 = {15'b0, din[20 +: 1]};
  wire [15:0] e21s0 = {15'b0, din[21 +: 1]};
  wire [15:0] e22s0 = {15'b0, din[22 +: 1]};
  wire [15:0] e23s0 = {15'b0, din[23 +: 1]};
  wire [15:0] e24s0 = {15'b0, din[24 +: 1]};
  wire [15:0] e25s0 = {15'b0, din[25 +: 1]};
  wire [15:0] e26s0 = {15'b0, din[26 +: 1]};
  wire [15:0] e27s0 = {15'b0, din[27 +: 1]};
  wire [15:0] e28s0 = {15'b0, din[28 +: 1]};
  wire [15:0] e29s0 = {15'b0, din[29 +: 1]};
  wire [15:0] e30s0 = {15'b0, din[30 +: 1]};
  wire [15:0] e31s0 = {15'b0, din[31 +: 1]};
  wire [15:0] e32s0 = {15'b0, din[32 +: 1]};
  wire [15:0] e33s0 = {15'b0, din[33 +: 1]};
  wire [15:0] e34s0 = {15'b0, din[34 +: 1]};
  wire [15:0] e35s0 = {15'b0, din[35 +: 1]};
  wire [15:0] e36s0 = {15'b0, din[36 +: 1]};
  wire [15:0] e37s0 = {15'b0, din[37 +: 1]};
  wire [15:0] e38s0 = {15'b0, din[38 +: 1]};
  wire [15:0] e39s0 = {15'b0, din[39 +: 1]};
  wire [15:0] e40s0 = {15'b0, din[40 +: 1]};
  wire [15:0] e41s0 = {15'b0, din[41 +: 1]};
  wire [15:0] e42s0 = {15'b0, din[42 +: 1]};
  wire [15:0] e43s0 = {15'b0, din[43 +: 1]};
  wire [15:0] e44s0 = {15'b0, din[44 +: 1]};
  wire [15:0] e45s0 = {15'b0, din[45 +: 1]};
  wire [15:0] e46s0 = {15'b0, din[46 +: 1]};
  wire [15:0] e47s0 = {15'b0, din[47 +: 1]};
  wire [15:0] e48s0 = {15'b0, din[48 +: 1]};
  wire [15:0] e49s0 = {15'b0, din[49 +: 1]};
  wire [15:0] e50s0 = {15'b0, din[50 +: 1]};
  wire [15:0] e51s0 = {15'b0, din[51 +: 1]};
  wire [15:0] e52s0 = {15'b0, din[52 +: 1]};
  wire [15:0] e53s0 = {15'b0, din[53 +: 1]};
  wire [15:0] e54s0 = {15'b0, din[54 +: 1]};
  wire [15:0] e55s0 = {15'b0, din[55 +: 1]};
  wire [15:0] e56s0 = {15'b0, din[56 +: 1]};
  wire [15:0] e57s0 = {15'b0, din[57 +: 1]};
  wire [15:0] e58s0 = {15'b0, din[58 +: 1]};
  wire [15:0] e59s0 = {15'b0, din[59 +: 1]};
  wire [15:0] e60s0 = {15'b0, din[60 +: 1]};
  wire [15:0] e61s0 = {15'b0, din[61 +: 1]};
  wire [15:0] e62s0 = {15'b0, din[62 +: 1]};
  wire [15:0] e63s0 = {15'b0, din[63 +: 1]};
  // forward pass
  wire [15:0] e1s1 = carry_save_add(e1s0, e0s0);
  wire [15:0] e3s1 = carry_save_add(e3s0, e2s0);
  wire [15:0] e5s1 = carry_save_add(e5s0, e4s0);
  wire [15:0] e7s1 = carry_save_add(e7s0, e6s0);
  wire [15:0] e9s1 = carry_save_add(e9s0, e8s0);
  wire [15:0] e11s1 = carry_save_add(e11s0, e10s0);
  wire [15:0] e13s1 = carry_save_add(e13s0, e12s0);
  wire [15:0] e15s1 = carry_save_add(e15s0, e14s0);
  wire [15:0] e17s1 = carry_save_add(e17s0, e16s0);
  wire [15:0] e19s1 = carry_save_add(e19s0, e18s0);
  wire [15:0] e21s1 = carry_save_add(e21s0, e20s0);
  wire [15:0] e23s1 = carry_save_add(e23s0, e22s0);
  wire [15:0] e25s1 = carry_save_add(e25s0, e24s0);
  wire [15:0] e27s1 = carry_save_add(e27s0, e26s0);
  wire [15:0] e29s1 = carry_save_add(e29s0, e28s0);
  wire [15:0] e31s1 = carry_save_add(e31s0, e30s0);
  wire [15:0] e33s1 = carry_save_add(e33s0, e32s0);
  wire [15:0] e35s1 = carry_save_add(e35s0, e34s0);
  wire [15:0] e37s1 = carry_save_add(e37s0, e36s0);
  wire [15:0] e39s1 = carry_save_add(e39s0, e38s0);
  wire [15:0] e41s1 = carry_save_add(e41s0, e40s0);
  wire [15:0] e43s1 = carry_save_add(e43s0, e42s0);
  wire [15:0] e45s1 = carry_save_add(e45s0, e44s0);
  wire [15:0] e47s1 = carry_save_add(e47s0, e46s0);
  wire [15:0] e49s1 = carry_save_add(e49s0, e48s0);
  wire [15:0] e51s1 = carry_save_add(e51s0, e50s0);
  wire [15:0] e53s1 = carry_save_add(e53s0, e52s0);
  wire [15:0] e55s1 = carry_save_add(e55s0, e54s0);
  wire [15:0] e57s1 = carry_save_add(e57s0, e56s0);
  wire [15:0] e59s1 = carry_save_add(e59s0, e58s0);
  wire [15:0] e61s1 = carry_save_add(e61s0, e60s0);
  wire [15:0] e63s1 = carry_save_add(e63s0, e62s0);
  wire [15:0] e3s2 = carry_save_add(e3s1, e1s1);
  wire [15:0] e7s2 = carry_save_add(e7s1, e5s1);
  wire [15:0] e11s2 = carry_save_add(e11s1, e9s1);
  wire [15:0] e15s2 = carry_save_add(e15s1, e13s1);
  wire [15:0] e19s2 = carry_save_add(e19s1, e17s1);
  wire [15:0] e23s2 = carry_save_add(e23s1, e21s1);
  wire [15:0] e27s2 = carry_save_add(e27s1, e25s1);
  wire [15:0] e31s2 = carry_save_add(e31s1, e29s1);
  wire [15:0] e35s2 = carry_save_add(e35s1, e33s1);
  wire [15:0] e39s2 = carry_save_add(e39s1, e37s1);
  wire [15:0] e43s2 = carry_save_add(e43s1, e41s1);
  wire [15:0] e47s2 = carry_save_add(e47s1, e45s1);
  wire [15:0] e51s2 = carry_save_add(e51s1, e49s1);
  wire [15:0] e55s2 = carry_save_add(e55s1, e53s1);
  wire [15:0] e59s2 = carry_save_add(e59s1, e57s1);
  wire [15:0] e63s2 = carry_save_add(e63s1, e61s1);
  wire [15:0] e7s3 = carry_save_add(e7s2, e3s2);
  wire [15:0] e15s3 = carry_save_add(e15s2, e11s2);
  wire [15:0] e23s3 = carry_save_add(e23s2, e19s2);
  wire [15:0] e31s3 = carry_save_add(e31s2, e27s2);
  wire [15:0] e39s3 = carry_save_add(e39s2, e35s2);
  wire [15:0] e47s3 = carry_save_add(e47s2, e43s2);
  wire [15:0] e55s3 = carry_save_add(e55s2, e51s2);
  wire [15:0] e63s3 = carry_save_add(e63s2, e59s2);
  wire [15:0] e15s4 = carry_save_add(e15s3, e7s3);
  wire [15:0] e31s4 = carry_save_add(e31s3, e23s3);
  wire [15:0] e47s4 = carry_save_add(e47s3, e39s3);
  wire [15:0] e63s4 = carry_save_add(e63s3, e55s3);
  wire [15:0] e31s5 = carry_save_add(e31s4, e15s4);
  wire [15:0] e63s5 = carry_save_add(e63s4, e47s4);
  wire [15:0] e63s6 = carry_save_add(e63s5, e31s5);
  // backward pass
  reg [15:0] r47;
  always @(posedge clock) r47 <= e47s4;
  reg [15:0] r31;
  always @(posedge clock) r31 <= e31s5;
  wire [15:0] e47s7 = carry_save_add(r47, r31);
  reg [15:0] r23;
  always @(posedge clock) r23 <= e23s3;
  reg [15:0] r15;
  always @(posedge clock) r15 <= e15s4;
  wire [15:0] e23s8 = carry_save_add(r23, r15);
  reg [15:0] r39;
  always @(posedge clock) r39 <= e39s3;
  wire [15:0] e39s8 = carry_save_add(r39, r31);
  reg [15:0] r55;
  always @(posedge clock) r55 <= e55s3;
  wire [15:0] e55s8 = carry_save_add(r55, e47s7);
  reg [15:0] r11;
  always @(posedge clock) r11 <= e11s2;
  reg [15:0] r7;
  always @(posedge clock) r7 <= e7s3;
  wire [15:0] e11s9 = carry_save_add(r11, r7);
  reg [15:0] r19;
  always @(posedge clock) r19 <= e19s2;
  wire [15:0] e19s9 = carry_save_add(r19, r15);
  reg [15:0] r27;
  always @(posedge clock) r27 <= e27s2;
  wire [15:0] e27s9 = carry_save_add(r27, e23s8);
  reg [15:0] r35;
  always @(posedge clock) r35 <= e35s2;
  wire [15:0] e35s9 = carry_save_add(r35, r31);
  reg [15:0] r43;
  always @(posedge clock) r43 <= e43s2;
  wire [15:0] e43s9 = carry_save_add(r43, e39s8);
  reg [15:0] r51;
  always @(posedge clock) r51 <= e51s2;
  wire [15:0] e51s9 = carry_save_add(r51, e47s7);
  reg [15:0] r59;
  always @(posedge clock) r59 <= e59s2;
  wire [15:0] e59s9 = carry_save_add(r59, e55s8);
  reg [15:0] r5;
  always @(posedge clock) r5 <= e5s1;
  reg [15:0] r3;
  always @(posedge clock) r3 <= e3s2;
  wire [15:0] e5s10 = carry_save_add(r5, r3);
  reg [15:0] r9;
  always @(posedge clock) r9 <= e9s1;
  wire [15:0] e9s10 = carry_save_add(r9, r7);
  reg [15:0] r13;
  always @(posedge clock) r13 <= e13s1;
  wire [15:0] e13s10 = carry_save_add(r13, e11s9);
  reg [15:0] r17;
  always @(posedge clock) r17 <= e17s1;
  wire [15:0] e17s10 = carry_save_add(r17, r15);
  reg [15:0] r21;
  always @(posedge clock) r21 <= e21s1;
  wire [15:0] e21s10 = carry_save_add(r21, e19s9);
  reg [15:0] r25;
  always @(posedge clock) r25 <= e25s1;
  wire [15:0] e25s10 = carry_save_add(r25, e23s8);
  reg [15:0] r29;
  always @(posedge clock) r29 <= e29s1;
  wire [15:0] e29s10 = carry_save_add(r29, e27s9);
  reg [15:0] r33;
  always @(posedge clock) r33 <= e33s1;
  wire [15:0] e33s10 = carry_save_add(r33, r31);
  reg [15:0] r37;
  always @(posedge clock) r37 <= e37s1;
  wire [15:0] e37s10 = carry_save_add(r37, e35s9);
  reg [15:0] r41;
  always @(posedge clock) r41 <= e41s1;
  wire [15:0] e41s10 = carry_save_add(r41, e39s8);
  reg [15:0] r45;
  always @(posedge clock) r45 <= e45s1;
  wire [15:0] e45s10 = carry_save_add(r45, e43s9);
  reg [15:0] r49;
  always @(posedge clock) r49 <= e49s1;
  wire [15:0] e49s10 = carry_save_add(r49, e47s7);
  reg [15:0] r53;
  always @(posedge clock) r53 <= e53s1;
  wire [15:0] e53s10 = carry_save_add(r53, e51s9);
  reg [15:0] r57;
  always @(posedge clock) r57 <= e57s1;
  wire [15:0] e57s10 = carry_save_add(r57, e55s8);
  reg [15:0] r61;
  always @(posedge clock) r61 <= e61s1;
  wire [15:0] e61s10 = carry_save_add(r61, e59s9);
  reg [15:0] r2;
  always @(posedge clock) r2 <= e2s0;
  reg [15:0] r1;
  always @(posedge clock) r1 <= e1s1;
  wire [15:0] e2s11 = carry_save_add(r2, r1);
  reg [15:0] r4;
  always @(posedge clock) r4 <= e4s0;
  wire [15:0] e4s11 = carry_save_add(r4, r3);
  reg [15:0] r6;
  always @(posedge clock) r6 <= e6s0;
  wire [15:0] e6s11 = carry_save_add(r6, e5s10);
  reg [15:0] r8;
  always @(posedge clock) r8 <= e8s0;
  wire [15:0] e8s11 = carry_save_add(r8, r7);
  reg [15:0] r10;
  always @(posedge clock) r10 <= e10s0;
  wire [15:0] e10s11 = carry_save_add(r10, e9s10);
  reg [15:0] r12;
  always @(posedge clock) r12 <= e12s0;
  wire [15:0] e12s11 = carry_save_add(r12, e11s9);
  reg [15:0] r14;
  always @(posedge clock) r14 <= e14s0;
  wire [15:0] e14s11 = carry_save_add(r14, e13s10);
  reg [15:0] r16;
  always @(posedge clock) r16 <= e16s0;
  wire [15:0] e16s11 = carry_save_add(r16, r15);
  reg [15:0] r18;
  always @(posedge clock) r18 <= e18s0;
  wire [15:0] e18s11 = carry_save_add(r18, e17s10);
  reg [15:0] r20;
  always @(posedge clock) r20 <= e20s0;
  wire [15:0] e20s11 = carry_save_add(r20, e19s9);
  reg [15:0] r22;
  always @(posedge clock) r22 <= e22s0;
  wire [15:0] e22s11 = carry_save_add(r22, e21s10);
  reg [15:0] r24;
  always @(posedge clock) r24 <= e24s0;
  wire [15:0] e24s11 = carry_save_add(r24, e23s8);
  reg [15:0] r26;
  always @(posedge clock) r26 <= e26s0;
  wire [15:0] e26s11 = carry_save_add(r26, e25s10);
  reg [15:0] r28;
  always @(posedge clock) r28 <= e28s0;
  wire [15:0] e28s11 = carry_save_add(r28, e27s9);
  reg [15:0] r30;
  always @(posedge clock) r30 <= e30s0;
  wire [15:0] e30s11 = carry_save_add(r30, e29s10);
  reg [15:0] r32;
  always @(posedge clock) r32 <= e32s0;
  wire [15:0] e32s11 = carry_save_add(r32, r31);
  reg [15:0] r34;
  always @(posedge clock) r34 <= e34s0;
  wire [15:0] e34s11 = carry_save_add(r34, e33s10);
  reg [15:0] r36;
  always @(posedge clock) r36 <= e36s0;
  wire [15:0] e36s11 = carry_save_add(r36, e35s9);
  reg [15:0] r38;
  always @(posedge clock) r38 <= e38s0;
  wire [15:0] e38s11 = carry_save_add(r38, e37s10);
  reg [15:0] r40;
  always @(posedge clock) r40 <= e40s0;
  wire [15:0] e40s11 = carry_save_add(r40, e39s8);
  reg [15:0] r42;
  always @(posedge clock) r42 <= e42s0;
  wire [15:0] e42s11 = carry_save_add(r42, e41s10);
  reg [15:0] r44;
  always @(posedge clock) r44 <= e44s0;
  wire [15:0] e44s11 = carry_save_add(r44, e43s9);
  reg [15:0] r46;
  always @(posedge clock) r46 <= e46s0;
  wire [15:0] e46s11 = carry_save_add(r46, e45s10);
  reg [15:0] r48;
  always @(posedge clock) r48 <= e48s0;
  wire [15:0] e48s11 = carry_save_add(r48, e47s7);
  reg [15:0] r50;
  always @(posedge clock) r50 <= e50s0;
  wire [15:0] e50s11 = carry_save_add(r50, e49s10);
  reg [15:0] r52;
  always @(posedge clock) r52 <= e52s0;
  wire [15:0] e52s11 = carry_save_add(r52, e51s9);
  reg [15:0] r54;
  always @(posedge clock) r54 <= e54s0;
  wire [15:0] e54s11 = carry_save_add(r54, e53s10);
  reg [15:0] r56;
  always @(posedge clock) r56 <= e56s0;
  wire [15:0] e56s11 = carry_save_add(r56, e55s8);
  reg [15:0] r58;
  always @(posedge clock) r58 <= e58s0;
  wire [15:0] e58s11 = carry_save_add(r58, e57s10);
  reg [15:0] r60;
  always @(posedge clock) r60 <= e60s0;
  wire [15:0] e60s11 = carry_save_add(r60, e59s9);
  reg [15:0] r62;
  always @(posedge clock) r62 <= e62s0;
  wire [15:0] e62s11 = carry_save_add(r62, e61s10);
  // outputs
  reg [15:0] r0;
  always @(posedge clock) r0 <= e0s0;
  assign dout[0 +: 8] = carry_save_get(r0);
  assign dout[8 +: 8] = carry_save_get(r1);
  assign dout[16 +: 8] = carry_save_get(e2s11);
  assign dout[24 +: 8] = carry_save_get(r3);
  assign dout[32 +: 8] = carry_save_get(e4s11);
  assign dout[40 +: 8] = carry_save_get(e5s10);
  assign dout[48 +: 8] = carry_save_get(e6s11);
  assign dout[56 +: 8] = carry_save_get(r7);
  assign dout[64 +: 8] = carry_save_get(e8s11);
  assign dout[72 +: 8] = carry_save_get(e9s10);
  assign dout[80 +: 8] = carry_save_get(e10s11);
  assign dout[88 +: 8] = carry_save_get(e11s9);
  assign dout[96 +: 8] = carry_save_get(e12s11);
  assign dout[104 +: 8] = carry_save_get(e13s10);
  assign dout[112 +: 8] = carry_save_get(e14s11);
  assign dout[120 +: 8] = carry_save_get(r15);
  assign dout[128 +: 8] = carry_save_get(e16s11);
  assign dout[136 +: 8] = carry_save_get(e17s10);
  assign dout[144 +: 8] = carry_save_get(e18s11);
  assign dout[152 +: 8] = carry_save_get(e19s9);
  assign dout[160 +: 8] = carry_save_get(e20s11);
  assign dout[168 +: 8] = carry_save_get(e21s10);
  assign dout[176 +: 8] = carry_save_get(e22s11);
  assign dout[184 +: 8] = carry_save_get(e23s8);
  assign dout[192 +: 8] = carry_save_get(e24s11);
  assign dout[200 +: 8] = carry_save_get(e25s10);
  assign dout[208 +: 8] = carry_save_get(e26s11);
  assign dout[216 +: 8] = carry_save_get(e27s9);
  assign dout[224 +: 8] = carry_save_get(e28s11);
  assign dout[232 +: 8] = carry_save_get(e29s10);
  assign dout[240 +: 8] = carry_save_get(e30s11);
  assign dout[248 +: 8] = carry_save_get(r31);
  assign dout[256 +: 8] = carry_save_get(e32s11);
  assign dout[264 +: 8] = carry_save_get(e33s10);
  assign dout[272 +: 8] = carry_save_get(e34s11);
  assign dout[280 +: 8] = carry_save_get(e35s9);
  assign dout[288 +: 8] = carry_save_get(e36s11);
  assign dout[296 +: 8] = carry_save_get(e37s10);
  assign dout[304 +: 8] = carry_save_get(e38s11);
  assign dout[312 +: 8] = carry_save_get(e39s8);
  assign dout[320 +: 8] = carry_save_get(e40s11);
  assign dout[328 +: 8] = carry_save_get(e41s10);
  assign dout[336 +: 8] = carry_save_get(e42s11);
  assign dout[344 +: 8] = carry_save_get(e43s9);
  assign dout[352 +: 8] = carry_save_get(e44s11);
  assign dout[360 +: 8] = carry_save_get(e45s10);
  assign dout[368 +: 8] = carry_save_get(e46s11);
  assign dout[376 +: 8] = carry_save_get(e47s7);
  assign dout[384 +: 8] = carry_save_get(e48s11);
  assign dout[392 +: 8] = carry_save_get(e49s10);
  assign dout[400 +: 8] = carry_save_get(e50s11);
  assign dout[408 +: 8] = carry_save_get(e51s9);
  assign dout[416 +: 8] = carry_save_get(e52s11);
  assign dout[424 +: 8] = carry_save_get(e53s10);
  assign dout[432 +: 8] = carry_save_get(e54s11);
  assign dout[440 +: 8] = carry_save_get(e55s8);
  assign dout[448 +: 8] = carry_save_get(e56s11);
  assign dout[456 +: 8] = carry_save_get(e57s10);
  assign dout[464 +: 8] = carry_save_get(e58s11);
  assign dout[472 +: 8] = carry_save_get(e59s9);
  assign dout[480 +: 8] = carry_save_get(e60s11);
  assign dout[488 +: 8] = carry_save_get(e61s10);
  assign dout[496 +: 8] = carry_save_get(e62s11);
  reg [15:0] r63;
  always @(posedge clock) r63 <= e63s6;
  assign dout[504 +: 8] = carry_save_get(r63);
endmodule
