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

`ifdef ENABLE_GREV
	localparam integer GREV = 1;
`else
	localparam integer GREV = 0;
`endif

	reg clock;
	always #5 clock = (clock === 1'b0);

	reg reset = 1;
	always @(posedge clock) reset <= 0;

	testbench_ff #(.XLEN(XLEN), .GREV(GREV), .FFS(0)) uut0 (.clock(clock), .reset(reset));
	testbench_ff #(.XLEN(XLEN), .GREV(GREV), .FFS(1)) uut1 (.clock(clock), .reset(reset));
	testbench_ff #(.XLEN(XLEN), .GREV(GREV), .FFS(2)) uut2 (.clock(clock), .reset(reset));
	testbench_ff #(.XLEN(XLEN), .GREV(GREV), .FFS(3)) uut3 (.clock(clock), .reset(reset));

	always @(posedge clock) begin
		if (!reset && uut0.dout_index >= NUM_TESTS && uut1.dout_index >= NUM_TESTS &&
				uut2.dout_index >= NUM_TESTS && uut3.dout_index >= NUM_TESTS) begin
			repeat (10) @(posedge clock);
			$display("OK");
			$finish;
		end
	end
endmodule

module testbench_ff #(
	parameter integer XLEN = 32,
	parameter integer GREV = 1,
	parameter integer FFS = 1
) (
	input clock, reset
);
	reg [32+64+64+64-1:0] testdata [0:999];
	initial $readmemh(`TESTDATA, testdata);

	reg  din_valid;
	wire din_ready;
	wire dout_valid;

	reg [XLEN-1:0] din_rs1;
	reg [XLEN-1:0] din_rs2;

	reg din_insn3;
	reg din_insn13;
	reg din_insn14;

	wire [XLEN-1:0] dout_rd;

	integer din_index = 0;

	wire [31:0] next_din_index = reset ? 0 : din_index + (din_valid && din_ready);
	wire [31:0] next_insn = testdata[next_din_index][3*64 +: 32];
	wire [XLEN-1:0] next_rs1 = testdata[next_din_index][2*64 +: 64];
	wire [XLEN-1:0] next_rs2 = testdata[next_din_index][1*64 +: 64];

	always @(posedge clock) begin
		din_index <= next_din_index;
		din_valid <= (next_din_index < 1000) && |($random & 3);
		din_rs1 <= next_rs1;
		din_rs2 <= next_rs2;
		if (XLEN > 32)
			din_insn3 <= next_insn[3];
		din_insn13 <= next_insn[13];
		din_insn14 <= next_insn[14];
	end

	integer dout_index = 0;
	wire [31:0] check_insn = testdata[dout_index][3*64 +: 32];
	wire [XLEN-1:0] check_rs1 = testdata[dout_index][2*64 +: 64];
	wire [XLEN-1:0] check_rs2 = testdata[dout_index][1*64 +: 64];
	wire [XLEN-1:0] check_rd = testdata[dout_index][64:0];

	always @(posedge clock) begin
		if (!reset && dout_valid && dout_index < 1000) begin
			$display("%s %m: idx=%03d insn=0x%08x rs1=0x%016x rs2=0x%016x rd=0x%016x expected=0x%016x %-s",
					`TESTDATA, dout_index, check_insn, check_rs1, check_rs2, dout_rd, check_rd,
					dout_rd !== check_rd ? "ERROR" : "OK");
			if (dout_rd !== check_rd) $stop;
			dout_index <= dout_index + 1;
		end
	end

	rvb_bextdep #(
		.XLEN(XLEN),
		.GREV(GREV),
		.FFS(FFS)
	) uut (
		.clock      (clock     ),
		.reset      (reset     ),
		.din_valid  (din_valid ),
		.din_ready  (din_ready ),
		.din_rs1    (din_rs1   ),
		.din_rs2    (din_rs2   ),
		.din_insn3  (din_insn3 ),
		.din_insn13 (din_insn13),
		.din_insn14 (din_insn14),
		.dout_valid (dout_valid),
		.dout_rd    (dout_rd   )
	);
endmodule
