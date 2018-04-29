/*
 *  Copyright (C) 2017  Clifford Wolf <clifford@clifford.at>
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

module largebextdep (
	input clock,
	input bdep,
	input [31:0] rs1,
	input [31:0] rs2,
	output reg [31:0] rd
);
	wire        din_mode;
	wire [31:0] din_value;
	wire [31:0] din_mask;
	wire [31:0] dout_result;

	bextdep_direct bextdep_direct_inst (
		.din_mode   (din_mode   ),
		.din_value  (din_value  ),
		.din_mask   (din_mask   ),
		.dout_result(dout_result)
	);

	assign din_mode = bdep;
	assign din_value = rs1;
	assign din_mask = rs2;

	always @(posedge clock) begin
		rd <= dout_result;
	end
endmodule

// ========================================================================

`define bextdep_butterfly_idx_a(k, i) ((2 << (k))*((i)/(1 << (k))) + (i)%(1 << (k)))
`define bextdep_butterfly_idx_b(k, i) (`bextdep_butterfly_idx_a(k, i) + (1<<(k)))

module bextdep_direct #(
	parameter integer XLEN = 32,
	parameter integer SUMBITS = 8
) (
	input                    din_mode,
	input      [   XLEN-1:0] din_value,
	input      [   XLEN-1:0] din_mask,
	output     [   XLEN-1:0] dout_result,
	output     [SUMBITS-1:0] dout_sum
);
	wire [XLEN/2-1:0] decoder_s1, decoder_s2, decoder_s4;
	wire [XLEN/2-1:0] decoder_s8, decoder_s16, decoder_s32;
	wire [7:0] decoder_sum;

	bextdep_decoder #(
		.XLEN(XLEN),
		.FFSTAGE(0)
	) decoder (
		.mask  (din_mask   ),
		.s1    (decoder_s1 ),
		.s2    (decoder_s2 ),
		.s4    (decoder_s4 ),
		.s8    (decoder_s8 ),
		.s16   (decoder_s16),
		.s32   (decoder_s32),
		.sum   (decoder_sum)
	);

	wire [XLEN-1:0] result_fwd;
	wire [XLEN-1:0] result_bwd;

	bextdep_butterfly_fwd #(
		.XLEN(XLEN)
	) butterfly_fwd (
		.din  (din_value   ),
		.s1   (~decoder_s1 ),
		.s2   (~decoder_s2 ),
		.s4   (~decoder_s4 ),
		.s8   (~decoder_s8 ),
		.s16  (~decoder_s16),
		.s32  (~decoder_s32),
		.dout (result_fwd  )
	);

	bextdep_butterfly_bwd #(
		.XLEN(XLEN)
	) butterfly_bwd (
		.din  (din_value & din_mask),
		.s1   (~decoder_s1 ),
		.s2   (~decoder_s2 ),
		.s4   (~decoder_s4 ),
		.s8   (~decoder_s8 ),
		.s16  (~decoder_s16),
		.s32  (~decoder_s32),
		.dout (result_bwd  )
	);

	assign dout_result = din_mode ? (result_fwd & din_mask) : result_bwd;
	assign dout_sum = decoder_sum;
endmodule

// ========================================================================

module bextdep_lrotcz #(
	parameter integer N = 1,
	parameter integer M = 1
) (
	input [7:0] din,
	output [M-1:0] dout
);
	wire [2*M-1:0] mask = {M{1'b1}};
	assign dout = (mask << din[N-1:0]) >> M;
endmodule

module bextdep_decoder #(
	parameter integer XLEN = 32,
	parameter integer FFSTAGE = 1
) (
	input clock,
	input enable,
	input [XLEN-1:0] mask,
	output [XLEN/2-1:0] s1, s2, s4, s8, s16, s32,
	output [7:0] sum
);
	wire [8*XLEN-1:0] ppsdata;

	assign sum = ppsdata[8*(XLEN-1) +: 8];

	generate
		if (XLEN == 4 && !FFSTAGE) begin:pps4
			bextdep_pps4 pps_core (
				.din  (mask),
				.dout (ppsdata)
			);
		end
		if (XLEN == 8 && !FFSTAGE) begin:pps8
			bextdep_pps8 pps_core (
				.din  (mask),
				.dout (ppsdata)
			);
		end
		if (XLEN == 16 && !FFSTAGE) begin:pps16
			bextdep_pps16 pps_core (
				.din  (mask),
				.dout (ppsdata)
			);
		end
		if (XLEN == 32 && !FFSTAGE) begin:pps32
			bextdep_pps32 pps_core (
				.din  (mask),
				.dout (ppsdata)
			);
		end
		if (XLEN == 64 && !FFSTAGE) begin:pps64
			bextdep_pps64 pps_core (
				.din  (mask),
				.dout (ppsdata)
			);
		end
		if (XLEN == 32 && FFSTAGE) begin:pps32f
			bextdep_pps32f pps_core (
				.clock (clock),
				.enable(enable),
				.din   (mask),
				.dout  (ppsdata)
			);
		end
		if (XLEN == 64 && FFSTAGE) begin:pps64f
			bextdep_pps64f pps_core (
				.clock (clock),
				.enable(enable),
				.din   (mask),
				.dout  (ppsdata)
			);
		end
	endgenerate

	genvar i;
	generate
		for (i = 0; i < XLEN/2; i = i+1) begin:stage1
			bextdep_lrotcz #(.N(1), .M(1)) lrotc_zero (
				.din(ppsdata[8*(2*i + 1 - 1) +: 8]),
				.dout(s1[i])
			);
		end

		for (i = 0; i < XLEN/4; i = i+1) begin:stage2
			bextdep_lrotcz #(.N(2), .M(2)) lrotc_zero (
				.din(ppsdata[8*(4*i + 2 - 1) +: 8]),
				.dout(s2[2*i +: 2])
			);
		end

		for (i = 0; i < XLEN/8; i = i+1) begin:stage4
			bextdep_lrotcz #(.N(3), .M(4)) lrotc_zero (
				.din(ppsdata[8*(8*i + 4 - 1) +: 8]),
				.dout(s4[4*i +: 4])
			);
		end

		for (i = 0; i < XLEN/16; i = i+1) begin:stage8
			bextdep_lrotcz #(.N(4), .M(8)) lrotc_zero (
				.din(ppsdata[8*(16*i + 8 - 1) +: 8]),
				.dout(s8[8*i +: 8])
			);
		end

		for (i = 0; i < XLEN/32; i = i+1) begin:stage16
			bextdep_lrotcz #(.N(5), .M(16)) lrotc_zero (
				.din(ppsdata[8*(32*i + 16 - 1) +: 8]),
				.dout(s16[16*i +: 16])
			);
		end

		for (i = 0; i < XLEN/64; i = i+1) begin:stage32
			bextdep_lrotcz #(.N(6), .M(32)) lrotc_zero (
				.din(ppsdata[8*(64*i + 32 - 1) +: 8]),
				.dout(s32[32*i +: 32])
			);
		end
	endgenerate
endmodule

module bextdep_butterfly_fwd #(
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
				if (s32[i]) {butterfly[`bextdep_butterfly_idx_a(5, i)], butterfly[`bextdep_butterfly_idx_b(5, i)]} =
							{butterfly[`bextdep_butterfly_idx_b(5, i)], butterfly[`bextdep_butterfly_idx_a(5, i)]};
		end

		if (32 <= XLEN) begin
			for (i = 0; i < XLEN/2; i = i+1)
				if (s16[i]) {butterfly[`bextdep_butterfly_idx_a(4, i)], butterfly[`bextdep_butterfly_idx_b(4, i)]} =
							{butterfly[`bextdep_butterfly_idx_b(4, i)], butterfly[`bextdep_butterfly_idx_a(4, i)]};
		end

		if (16 <= XLEN) begin
			for (i = 0; i < XLEN/2; i = i+1)
				if (s8[i]) {butterfly[`bextdep_butterfly_idx_a(3, i)], butterfly[`bextdep_butterfly_idx_b(3, i)]} =
							{butterfly[`bextdep_butterfly_idx_b(3, i)], butterfly[`bextdep_butterfly_idx_a(3, i)]};
		end

		for (i = 0; i < XLEN/2; i = i+1)
			if (s4[i]) {butterfly[`bextdep_butterfly_idx_a(2, i)], butterfly[`bextdep_butterfly_idx_b(2, i)]} =
						{butterfly[`bextdep_butterfly_idx_b(2, i)], butterfly[`bextdep_butterfly_idx_a(2, i)]};

		for (i = 0; i < XLEN/2; i = i+1)
			if (s2[i]) {butterfly[`bextdep_butterfly_idx_a(1, i)], butterfly[`bextdep_butterfly_idx_b(1, i)]} =
						{butterfly[`bextdep_butterfly_idx_b(1, i)], butterfly[`bextdep_butterfly_idx_a(1, i)]};

		for (i = 0; i < XLEN/2; i = i+1)
			if (s1[i]) {butterfly[`bextdep_butterfly_idx_a(0, i)], butterfly[`bextdep_butterfly_idx_b(0, i)]} =
						{butterfly[`bextdep_butterfly_idx_b(0, i)], butterfly[`bextdep_butterfly_idx_a(0, i)]};
	end
endmodule

module bextdep_butterfly_bwd #(
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
			if (s1[i]) {butterfly[`bextdep_butterfly_idx_a(0, i)], butterfly[`bextdep_butterfly_idx_b(0, i)]} =
						{butterfly[`bextdep_butterfly_idx_b(0, i)], butterfly[`bextdep_butterfly_idx_a(0, i)]};

		for (i = 0; i < XLEN/2; i = i+1)
			if (s2[i]) {butterfly[`bextdep_butterfly_idx_a(1, i)], butterfly[`bextdep_butterfly_idx_b(1, i)]} =
						{butterfly[`bextdep_butterfly_idx_b(1, i)], butterfly[`bextdep_butterfly_idx_a(1, i)]};

		for (i = 0; i < XLEN/2; i = i+1)
			if (s4[i]) {butterfly[`bextdep_butterfly_idx_a(2, i)], butterfly[`bextdep_butterfly_idx_b(2, i)]} =
						{butterfly[`bextdep_butterfly_idx_b(2, i)], butterfly[`bextdep_butterfly_idx_a(2, i)]};

		if (16 <= XLEN) begin
			for (i = 0; i < XLEN/2; i = i+1)
				if (s8[i]) {butterfly[`bextdep_butterfly_idx_a(3, i)], butterfly[`bextdep_butterfly_idx_b(3, i)]} =
							{butterfly[`bextdep_butterfly_idx_b(3, i)], butterfly[`bextdep_butterfly_idx_a(3, i)]};
		end

		if (32 <= XLEN) begin
			for (i = 0; i < XLEN/2; i = i+1)
				if (s16[i]) {butterfly[`bextdep_butterfly_idx_a(4, i)], butterfly[`bextdep_butterfly_idx_b(4, i)]} =
							{butterfly[`bextdep_butterfly_idx_b(4, i)], butterfly[`bextdep_butterfly_idx_a(4, i)]};
		end

		if (64 <= XLEN) begin
			for (i = 0; i < XLEN/2; i = i+1)
				if (s32[i]) {butterfly[`bextdep_butterfly_idx_a(5, i)], butterfly[`bextdep_butterfly_idx_b(5, i)]} =
							{butterfly[`bextdep_butterfly_idx_b(5, i)], butterfly[`bextdep_butterfly_idx_a(5, i)]};
		end
	end
endmodule

// DO NOT EDIT -- Generated by ppsmaker.py (see Makefile)
module bextdep_pps4 (
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
module bextdep_pps8 (
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
module bextdep_pps16 (
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
module bextdep_pps32 (
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
module bextdep_pps64 (
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
module bextdep_pps32f (
  input clock,
  input enable,
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
  always @(posedge clock) if (enable) r23 <= e23s3;
  reg [15:0] r15;
  always @(posedge clock) if (enable) r15 <= e15s4;
  wire [15:0] e23s6 = carry_save_add(r23, r15);
  reg [15:0] r11;
  always @(posedge clock) if (enable) r11 <= e11s2;
  reg [15:0] r7;
  always @(posedge clock) if (enable) r7 <= e7s3;
  wire [15:0] e11s7 = carry_save_add(r11, r7);
  reg [15:0] r19;
  always @(posedge clock) if (enable) r19 <= e19s2;
  wire [15:0] e19s7 = carry_save_add(r19, r15);
  reg [15:0] r27;
  always @(posedge clock) if (enable) r27 <= e27s2;
  wire [15:0] e27s7 = carry_save_add(r27, e23s6);
  reg [15:0] r5;
  always @(posedge clock) if (enable) r5 <= e5s1;
  reg [15:0] r3;
  always @(posedge clock) if (enable) r3 <= e3s2;
  wire [15:0] e5s8 = carry_save_add(r5, r3);
  reg [15:0] r9;
  always @(posedge clock) if (enable) r9 <= e9s1;
  wire [15:0] e9s8 = carry_save_add(r9, r7);
  reg [15:0] r13;
  always @(posedge clock) if (enable) r13 <= e13s1;
  wire [15:0] e13s8 = carry_save_add(r13, e11s7);
  reg [15:0] r17;
  always @(posedge clock) if (enable) r17 <= e17s1;
  wire [15:0] e17s8 = carry_save_add(r17, r15);
  reg [15:0] r21;
  always @(posedge clock) if (enable) r21 <= e21s1;
  wire [15:0] e21s8 = carry_save_add(r21, e19s7);
  reg [15:0] r25;
  always @(posedge clock) if (enable) r25 <= e25s1;
  wire [15:0] e25s8 = carry_save_add(r25, e23s6);
  reg [15:0] r29;
  always @(posedge clock) if (enable) r29 <= e29s1;
  wire [15:0] e29s8 = carry_save_add(r29, e27s7);
  reg [15:0] r2;
  always @(posedge clock) if (enable) r2 <= e2s0;
  reg [15:0] r1;
  always @(posedge clock) if (enable) r1 <= e1s1;
  wire [15:0] e2s9 = carry_save_add(r2, r1);
  reg [15:0] r4;
  always @(posedge clock) if (enable) r4 <= e4s0;
  wire [15:0] e4s9 = carry_save_add(r4, r3);
  reg [15:0] r6;
  always @(posedge clock) if (enable) r6 <= e6s0;
  wire [15:0] e6s9 = carry_save_add(r6, e5s8);
  reg [15:0] r8;
  always @(posedge clock) if (enable) r8 <= e8s0;
  wire [15:0] e8s9 = carry_save_add(r8, r7);
  reg [15:0] r10;
  always @(posedge clock) if (enable) r10 <= e10s0;
  wire [15:0] e10s9 = carry_save_add(r10, e9s8);
  reg [15:0] r12;
  always @(posedge clock) if (enable) r12 <= e12s0;
  wire [15:0] e12s9 = carry_save_add(r12, e11s7);
  reg [15:0] r14;
  always @(posedge clock) if (enable) r14 <= e14s0;
  wire [15:0] e14s9 = carry_save_add(r14, e13s8);
  reg [15:0] r16;
  always @(posedge clock) if (enable) r16 <= e16s0;
  wire [15:0] e16s9 = carry_save_add(r16, r15);
  reg [15:0] r18;
  always @(posedge clock) if (enable) r18 <= e18s0;
  wire [15:0] e18s9 = carry_save_add(r18, e17s8);
  reg [15:0] r20;
  always @(posedge clock) if (enable) r20 <= e20s0;
  wire [15:0] e20s9 = carry_save_add(r20, e19s7);
  reg [15:0] r22;
  always @(posedge clock) if (enable) r22 <= e22s0;
  wire [15:0] e22s9 = carry_save_add(r22, e21s8);
  reg [15:0] r24;
  always @(posedge clock) if (enable) r24 <= e24s0;
  wire [15:0] e24s9 = carry_save_add(r24, e23s6);
  reg [15:0] r26;
  always @(posedge clock) if (enable) r26 <= e26s0;
  wire [15:0] e26s9 = carry_save_add(r26, e25s8);
  reg [15:0] r28;
  always @(posedge clock) if (enable) r28 <= e28s0;
  wire [15:0] e28s9 = carry_save_add(r28, e27s7);
  reg [15:0] r30;
  always @(posedge clock) if (enable) r30 <= e30s0;
  wire [15:0] e30s9 = carry_save_add(r30, e29s8);
  // outputs
  reg [15:0] r0;
  always @(posedge clock) if (enable) r0 <= e0s0;
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
  always @(posedge clock) if (enable) r31 <= e31s5;
  assign dout[248 +: 8] = carry_save_get(r31);
endmodule
module bextdep_pps64f (
  input clock,
  input enable,
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
  always @(posedge clock) if (enable) r47 <= e47s4;
  reg [15:0] r31;
  always @(posedge clock) if (enable) r31 <= e31s5;
  wire [15:0] e47s7 = carry_save_add(r47, r31);
  reg [15:0] r23;
  always @(posedge clock) if (enable) r23 <= e23s3;
  reg [15:0] r15;
  always @(posedge clock) if (enable) r15 <= e15s4;
  wire [15:0] e23s8 = carry_save_add(r23, r15);
  reg [15:0] r39;
  always @(posedge clock) if (enable) r39 <= e39s3;
  wire [15:0] e39s8 = carry_save_add(r39, r31);
  reg [15:0] r55;
  always @(posedge clock) if (enable) r55 <= e55s3;
  wire [15:0] e55s8 = carry_save_add(r55, e47s7);
  reg [15:0] r11;
  always @(posedge clock) if (enable) r11 <= e11s2;
  reg [15:0] r7;
  always @(posedge clock) if (enable) r7 <= e7s3;
  wire [15:0] e11s9 = carry_save_add(r11, r7);
  reg [15:0] r19;
  always @(posedge clock) if (enable) r19 <= e19s2;
  wire [15:0] e19s9 = carry_save_add(r19, r15);
  reg [15:0] r27;
  always @(posedge clock) if (enable) r27 <= e27s2;
  wire [15:0] e27s9 = carry_save_add(r27, e23s8);
  reg [15:0] r35;
  always @(posedge clock) if (enable) r35 <= e35s2;
  wire [15:0] e35s9 = carry_save_add(r35, r31);
  reg [15:0] r43;
  always @(posedge clock) if (enable) r43 <= e43s2;
  wire [15:0] e43s9 = carry_save_add(r43, e39s8);
  reg [15:0] r51;
  always @(posedge clock) if (enable) r51 <= e51s2;
  wire [15:0] e51s9 = carry_save_add(r51, e47s7);
  reg [15:0] r59;
  always @(posedge clock) if (enable) r59 <= e59s2;
  wire [15:0] e59s9 = carry_save_add(r59, e55s8);
  reg [15:0] r5;
  always @(posedge clock) if (enable) r5 <= e5s1;
  reg [15:0] r3;
  always @(posedge clock) if (enable) r3 <= e3s2;
  wire [15:0] e5s10 = carry_save_add(r5, r3);
  reg [15:0] r9;
  always @(posedge clock) if (enable) r9 <= e9s1;
  wire [15:0] e9s10 = carry_save_add(r9, r7);
  reg [15:0] r13;
  always @(posedge clock) if (enable) r13 <= e13s1;
  wire [15:0] e13s10 = carry_save_add(r13, e11s9);
  reg [15:0] r17;
  always @(posedge clock) if (enable) r17 <= e17s1;
  wire [15:0] e17s10 = carry_save_add(r17, r15);
  reg [15:0] r21;
  always @(posedge clock) if (enable) r21 <= e21s1;
  wire [15:0] e21s10 = carry_save_add(r21, e19s9);
  reg [15:0] r25;
  always @(posedge clock) if (enable) r25 <= e25s1;
  wire [15:0] e25s10 = carry_save_add(r25, e23s8);
  reg [15:0] r29;
  always @(posedge clock) if (enable) r29 <= e29s1;
  wire [15:0] e29s10 = carry_save_add(r29, e27s9);
  reg [15:0] r33;
  always @(posedge clock) if (enable) r33 <= e33s1;
  wire [15:0] e33s10 = carry_save_add(r33, r31);
  reg [15:0] r37;
  always @(posedge clock) if (enable) r37 <= e37s1;
  wire [15:0] e37s10 = carry_save_add(r37, e35s9);
  reg [15:0] r41;
  always @(posedge clock) if (enable) r41 <= e41s1;
  wire [15:0] e41s10 = carry_save_add(r41, e39s8);
  reg [15:0] r45;
  always @(posedge clock) if (enable) r45 <= e45s1;
  wire [15:0] e45s10 = carry_save_add(r45, e43s9);
  reg [15:0] r49;
  always @(posedge clock) if (enable) r49 <= e49s1;
  wire [15:0] e49s10 = carry_save_add(r49, e47s7);
  reg [15:0] r53;
  always @(posedge clock) if (enable) r53 <= e53s1;
  wire [15:0] e53s10 = carry_save_add(r53, e51s9);
  reg [15:0] r57;
  always @(posedge clock) if (enable) r57 <= e57s1;
  wire [15:0] e57s10 = carry_save_add(r57, e55s8);
  reg [15:0] r61;
  always @(posedge clock) if (enable) r61 <= e61s1;
  wire [15:0] e61s10 = carry_save_add(r61, e59s9);
  reg [15:0] r2;
  always @(posedge clock) if (enable) r2 <= e2s0;
  reg [15:0] r1;
  always @(posedge clock) if (enable) r1 <= e1s1;
  wire [15:0] e2s11 = carry_save_add(r2, r1);
  reg [15:0] r4;
  always @(posedge clock) if (enable) r4 <= e4s0;
  wire [15:0] e4s11 = carry_save_add(r4, r3);
  reg [15:0] r6;
  always @(posedge clock) if (enable) r6 <= e6s0;
  wire [15:0] e6s11 = carry_save_add(r6, e5s10);
  reg [15:0] r8;
  always @(posedge clock) if (enable) r8 <= e8s0;
  wire [15:0] e8s11 = carry_save_add(r8, r7);
  reg [15:0] r10;
  always @(posedge clock) if (enable) r10 <= e10s0;
  wire [15:0] e10s11 = carry_save_add(r10, e9s10);
  reg [15:0] r12;
  always @(posedge clock) if (enable) r12 <= e12s0;
  wire [15:0] e12s11 = carry_save_add(r12, e11s9);
  reg [15:0] r14;
  always @(posedge clock) if (enable) r14 <= e14s0;
  wire [15:0] e14s11 = carry_save_add(r14, e13s10);
  reg [15:0] r16;
  always @(posedge clock) if (enable) r16 <= e16s0;
  wire [15:0] e16s11 = carry_save_add(r16, r15);
  reg [15:0] r18;
  always @(posedge clock) if (enable) r18 <= e18s0;
  wire [15:0] e18s11 = carry_save_add(r18, e17s10);
  reg [15:0] r20;
  always @(posedge clock) if (enable) r20 <= e20s0;
  wire [15:0] e20s11 = carry_save_add(r20, e19s9);
  reg [15:0] r22;
  always @(posedge clock) if (enable) r22 <= e22s0;
  wire [15:0] e22s11 = carry_save_add(r22, e21s10);
  reg [15:0] r24;
  always @(posedge clock) if (enable) r24 <= e24s0;
  wire [15:0] e24s11 = carry_save_add(r24, e23s8);
  reg [15:0] r26;
  always @(posedge clock) if (enable) r26 <= e26s0;
  wire [15:0] e26s11 = carry_save_add(r26, e25s10);
  reg [15:0] r28;
  always @(posedge clock) if (enable) r28 <= e28s0;
  wire [15:0] e28s11 = carry_save_add(r28, e27s9);
  reg [15:0] r30;
  always @(posedge clock) if (enable) r30 <= e30s0;
  wire [15:0] e30s11 = carry_save_add(r30, e29s10);
  reg [15:0] r32;
  always @(posedge clock) if (enable) r32 <= e32s0;
  wire [15:0] e32s11 = carry_save_add(r32, r31);
  reg [15:0] r34;
  always @(posedge clock) if (enable) r34 <= e34s0;
  wire [15:0] e34s11 = carry_save_add(r34, e33s10);
  reg [15:0] r36;
  always @(posedge clock) if (enable) r36 <= e36s0;
  wire [15:0] e36s11 = carry_save_add(r36, e35s9);
  reg [15:0] r38;
  always @(posedge clock) if (enable) r38 <= e38s0;
  wire [15:0] e38s11 = carry_save_add(r38, e37s10);
  reg [15:0] r40;
  always @(posedge clock) if (enable) r40 <= e40s0;
  wire [15:0] e40s11 = carry_save_add(r40, e39s8);
  reg [15:0] r42;
  always @(posedge clock) if (enable) r42 <= e42s0;
  wire [15:0] e42s11 = carry_save_add(r42, e41s10);
  reg [15:0] r44;
  always @(posedge clock) if (enable) r44 <= e44s0;
  wire [15:0] e44s11 = carry_save_add(r44, e43s9);
  reg [15:0] r46;
  always @(posedge clock) if (enable) r46 <= e46s0;
  wire [15:0] e46s11 = carry_save_add(r46, e45s10);
  reg [15:0] r48;
  always @(posedge clock) if (enable) r48 <= e48s0;
  wire [15:0] e48s11 = carry_save_add(r48, e47s7);
  reg [15:0] r50;
  always @(posedge clock) if (enable) r50 <= e50s0;
  wire [15:0] e50s11 = carry_save_add(r50, e49s10);
  reg [15:0] r52;
  always @(posedge clock) if (enable) r52 <= e52s0;
  wire [15:0] e52s11 = carry_save_add(r52, e51s9);
  reg [15:0] r54;
  always @(posedge clock) if (enable) r54 <= e54s0;
  wire [15:0] e54s11 = carry_save_add(r54, e53s10);
  reg [15:0] r56;
  always @(posedge clock) if (enable) r56 <= e56s0;
  wire [15:0] e56s11 = carry_save_add(r56, e55s8);
  reg [15:0] r58;
  always @(posedge clock) if (enable) r58 <= e58s0;
  wire [15:0] e58s11 = carry_save_add(r58, e57s10);
  reg [15:0] r60;
  always @(posedge clock) if (enable) r60 <= e60s0;
  wire [15:0] e60s11 = carry_save_add(r60, e59s9);
  reg [15:0] r62;
  always @(posedge clock) if (enable) r62 <= e62s0;
  wire [15:0] e62s11 = carry_save_add(r62, e61s10);
  // outputs
  reg [15:0] r0;
  always @(posedge clock) if (enable) r0 <= e0s0;
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
  always @(posedge clock) if (enable) r63 <= e63s6;
  assign dout[504 +: 8] = carry_save_get(r63);
endmodule
