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

`ifdef ENABLE_SBOP
	localparam [0:0] SBOP = 1;
`else
	localparam [0:0] SBOP = 0;
`endif

`ifdef ENABLE_BFP
	localparam [0:0] BFP = 1;
`else
	localparam [0:0] BFP = 0;
`endif

	reg clock;
	always #5 clock = (clock === 1'b0);

	reg reset = 1;
	always @(posedge clock) reset <= 0;

	reg [32+64+64+64+64-1:0] testdata [0:999];
	initial $readmemh(`TESTDATA, testdata);

	wire din_valid = 1;
	wire dout_ready = 1;
	wire din_ready;
	wire dout_valid;

	reg [XLEN-1:0] din_rs1;
	reg [XLEN-1:0] din_rs2;
	reg [XLEN-1:0] din_rs3;

	reg din_insn3;
	reg din_insn14;
	reg din_insn26;
	reg din_insn27;
	reg din_insn29;
	reg din_insn30;

	reg [31:0] check_insn;
	reg [XLEN-1:0] check_rd;

	wire [XLEN-1:0] dout_rd;

	integer index = 0;

	wire [31:0] next_index = reset ? 0 : index + 1;
	wire [31:0] next_insn = testdata[next_index][4*64 +: 32];
	wire [XLEN-1:0] next_rs1 = testdata[next_index][3*64 +: 64];
	wire [XLEN-1:0] next_rs2 = testdata[next_index][2*64 +: 64];
	wire [XLEN-1:0] next_rs3 = testdata[next_index][1*64 +: 64];
	wire [XLEN-1:0] next_rd  = testdata[next_index][0*64 +: 64];

	always @(posedge clock) begin
		index <= next_index;
		din_rs1 <= next_rs1;
		din_rs2 <= next_rs2;
		din_rs3 <= next_rs3;
		check_insn <= next_insn;
		check_rd <= next_rd;
		if (XLEN > 32)
			din_insn3 <= next_insn[3];
		din_insn14 <= next_insn[14];
		din_insn26 <= next_insn[26];
		din_insn27 <= next_insn[27];
		din_insn29 <= next_insn[29];
		din_insn30 <= next_insn[30];
	end

	always @(posedge clock) begin
		if (!reset && index < 1000) begin
			$display("%s: idx=%03d insn=0x%08x rs1=0x%016x rs2=0x%016x rs3=0x%016x rd=0x%016x expected=0x%016x %-s",
					`TESTDATA, index, check_insn, din_rs1, din_rs2, din_rs3, dout_rd, check_rd,
					dout_rd !== check_rd ? "ERROR" : "OK");
			if (dout_rd !== check_rd) $stop;
		end
		if (!reset && index == NUM_TESTS) begin
			$display("OK");
			$finish;
		end
	end

	rvb_shifter #(
		.XLEN(XLEN),
		.SBOP(SBOP),
		.BFP(BFP)
	) uut (
		.clock      (clock     ),
		.reset      (reset     ),
		.din_valid  (din_valid ),
		.din_ready  (din_ready ),
		.din_rs1    (din_rs1   ),
		.din_rs2    (din_rs2   ),
		.din_rs3    (din_rs3   ),
		.din_insn3  (din_insn3 ),
		.din_insn14 (din_insn14),
		.din_insn26 (din_insn26),
		.din_insn27 (din_insn27),
		.din_insn29 (din_insn29),
		.din_insn30 (din_insn30),
		.dout_valid (dout_valid),
		.dout_ready (dout_ready),
		.dout_rd    (dout_rd   )
	);
endmodule
