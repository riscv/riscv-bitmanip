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

module testbench;
	localparam integer NUM_TESTS = 1000;

	initial begin
		// $dumpfile("testbench.vcd");
		// $dumpvars(0, testbench);
	end

`ifdef ENABLE_64BIT
	localparam integer XLEN = 64;
`else
	localparam integer XLEN = 32;
`endif

	reg clock;
	always #5 clock = (clock === 1'b0);

	reg reset = 1;
	always @(posedge clock) reset <= 0;

	testbench_ff #(.XLEN(XLEN)) uut0 (.clock(clock), .reset(reset));

	always @(posedge clock) begin
		if (!reset && uut0.dout_index >= NUM_TESTS) begin
			repeat (10) @(posedge clock);
			$display("OK");
			$finish;
		end
	end
endmodule

module testbench_ff #(
	parameter integer XLEN = 32
) (
	input clock, reset
);
	reg [32+64+64+64+64-1:0] testdata [0:999];
	initial $readmemh(`TESTDATA, testdata);

	reg din_valid = 0;
	reg dout_ready = 0;
	wire din_ready;
	wire dout_valid;

	reg [XLEN-1:0] din_rs1;
	reg [XLEN-1:0] din_rs2;
	reg [XLEN-1:0] din_rs3;

	reg din_insn3;
	reg din_insn5;
	reg din_insn12;
	reg din_insn13;
	reg din_insn14;
	reg din_insn25;
	reg din_insn26;
	reg din_insn27;
	reg din_insn30;

	wire [XLEN-1:0] dout_rd;

	integer din_index = 0;

	wire [31:0] next_din_index = reset ? 0 : din_index + (din_valid && din_ready);
	wire [31:0] next_insn = testdata[next_din_index][4*64 +: 32];
	wire [XLEN-1:0] next_rs1 = testdata[next_din_index][3*64 +: 64];
	wire [XLEN-1:0] next_rs2 = testdata[next_din_index][2*64 +: 64];
	wire [XLEN-1:0] next_rs3 = testdata[next_din_index][1*64 +: 64];

	always @(posedge clock) begin
		din_index <= next_din_index;
		din_valid <= (next_din_index < 1000) && |($random & 3);
		dout_ready <= |($random & 7);
		din_rs1 <= next_rs1;
		din_rs2 <= next_rs2;
		din_rs3 <= next_rs3;
		if (XLEN == 64) begin
			din_insn3 <= next_insn[3];
			din_insn5 <= next_insn[5];
		end
		din_insn12 <= next_insn[12];
		din_insn13 <= next_insn[13];
		din_insn14 <= next_insn[14];
		din_insn25 <= next_insn[25];
		din_insn26 <= next_insn[26];
		din_insn27 <= next_insn[27];
		din_insn30 <= next_insn[30];
	end

	integer dout_index = 0;
	wire [31:0] check_insn = testdata[dout_index][4*64 +: 32];
	wire [XLEN-1:0] check_rs1 = testdata[dout_index][3*64 +: 64];
	wire [XLEN-1:0] check_rs2 = testdata[dout_index][2*64 +: 64];
	wire [XLEN-1:0] check_rs3 = testdata[dout_index][1*64 +: 64];
	wire [XLEN-1:0] check_rd = testdata[dout_index][64:0];

	always @(posedge clock) begin
		if (!reset && dout_valid && dout_ready && dout_index < 1000) begin
			$display("%s %m: idx=%03d insn=0x%08x rs1=0x%016x rs2=0x%016x rs3=0x%016x rd=0x%016x expected=0x%016x %-s",
					`TESTDATA, dout_index, check_insn, check_rs1, check_rs2, check_rs3, dout_rd, check_rd,
					dout_rd !== check_rd ? "ERROR" : "OK");
			if (dout_rd !== check_rd) $stop;
			dout_index <= dout_index + 1;
		end
	end

	rvb_simple #(
		.XLEN(XLEN)
	) uut (
		.clock      (clock     ),
		.reset      (reset     ),
		.din_valid  (din_valid ),
		.din_ready  (din_ready ),
		.din_rs1    (din_rs1   ),
		.din_rs2    (din_rs2   ),
		.din_rs3    (din_rs3   ),
		.din_insn3  (din_insn3 ),
		.din_insn5  (din_insn5 ),
		.din_insn12 (din_insn12),
		.din_insn13 (din_insn13),
		.din_insn14 (din_insn14),
		.din_insn25 (din_insn25),
		.din_insn26 (din_insn26),
		.din_insn27 (din_insn27),
		.din_insn30 (din_insn30),
		.dout_valid (dout_valid),
		.dout_ready (dout_ready),
		.dout_rd    (dout_rd   )
	);
endmodule
