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

module system;
	localparam MEM_DEBUG = 0;
	localparam integer TIMEOUT = 100000;

	reg clock;
	always #5 clock = (clock === 1'b0);

	reg reset = 1;
	always @(posedge clock) reset <= 0;

	integer cycles = 0;
	always @(posedge clock) cycles <= cycles + 1;

        initial begin
		// $dumpfile("system.vcd");
		// $dumpvars(0, system);
        end

	wire        trap;

	wire        mem_valid;
	wire        mem_instr;
	wire        mem_ready;
	wire [31:0] mem_addr;
	wire [31:0] mem_wdata;
	wire [ 3:0] mem_wstrb;
	wire [31:0] mem_rdata;

	wire        pcpi_valid;
	wire [31:0] pcpi_insn;
	wire [31:0] pcpi_rs1;
	wire [31:0] pcpi_rs2;
	wire [31:0] pcpi_rs3;
	wire        pcpi_wr;
	wire [31:0] pcpi_rd;
	wire        pcpi_wait;
	wire        pcpi_ready;

	reg [31:0] memory [0:2**20-1];
	initial $readmemh("firmware.hex", memory);

	assign mem_ready = 1;
	assign mem_rdata = memory[mem_addr >> 2];

	always @(posedge clock) begin
		if (!reset && mem_valid) begin
			if (mem_addr < 2**20) begin
				if (mem_wstrb[0]) memory[mem_addr >> 2][ 7: 0] = mem_wdata[ 7: 0];
				if (mem_wstrb[1]) memory[mem_addr >> 2][15: 8] = mem_wdata[15: 8];
				if (mem_wstrb[2]) memory[mem_addr >> 2][23:16] = mem_wdata[23:16];
				if (mem_wstrb[3]) memory[mem_addr >> 2][31:24] = mem_wdata[31:24];
			end
			if (mem_addr == 32'h 10000000) begin
				if (MEM_DEBUG) begin
					if (^mem_wdata[7:0] === 1'bx || mem_wdata[7:0] < 32)
						$display("> %b", mem_wdata[7:0]);
					else
						$display("> %b %c", mem_wdata[7:0], mem_wdata[7:0]);
				end else begin
					if (^mem_wdata[7:0] === 1'bx)
						$write("X");
					else
						$write("%c", mem_wdata[7:0]);
				end
			end
		end
	end

	always @(posedge clock) begin
		if (!reset && mem_valid && MEM_DEBUG) begin
			if (mem_instr)
				$display("INSN @%x: %x", mem_addr, mem_rdata);
			else if (!mem_wstrb)
				$display("RDAT @%x: %x", mem_addr, mem_rdata);
			else
				$display("WDAT @%x: %x%x%x%x", mem_addr,
						mem_wstrb[3] ? mem_wdata[31:24] : 8'bz,
						mem_wstrb[2] ? mem_wdata[23:16] : 8'bz,
						mem_wstrb[1] ? mem_wdata[15: 8] : 8'bz,
						mem_wstrb[0] ? mem_wdata[ 7: 0] : 8'bz);
		end
		if (cycles >= TIMEOUT) begin
			$display("TIMEOUT after %1d cycles", cycles);
			$finish;
		end
		if (!reset && trap) begin
			$display("TRAP after %1d cycles", cycles);
			$finish;
		end
	end

`ifdef MCY
	reg [7:0] mutsel;

	initial begin
		if (!$value$plusargs("mut=%d", mutsel)) begin
			mutsel = 0;
		end
	end
`endif

	rvb_pcpi rvb_pcpi (
		.clk        (clock     ),
		.resetn     (!reset    ),
`ifdef MCY
		.mutsel     (mutsel    ),
`endif
		.pcpi_valid (pcpi_valid),
		.pcpi_insn  (pcpi_insn ),
		.pcpi_rs1   (pcpi_rs1  ),
		.pcpi_rs2   (pcpi_rs2  ),
		.pcpi_rs3   (pcpi_rs3  ),
		.pcpi_wr    (pcpi_wr   ),
		.pcpi_rd    (pcpi_rd   ),
		.pcpi_wait  (pcpi_wait ),
		.pcpi_ready (pcpi_ready)
	);

	picorv32 #(
		.ENABLE_SHIFT(0),
		.COMPRESSED_ISA(1),
		.ENABLE_PCPI(1),
		.ENABLE_PCPI_RS3(1),
		.ENABLE_FAST_MUL(1),
		.ENABLE_DIV(1),
		.PROGADDR_RESET(32'h 00010000),
		.STACKADDR(32'h 00010000)
	) picorv32 (
		.clk        (clock     ),
		.resetn     (!reset    ),
		.trap       (trap      ),

		.mem_valid  (mem_valid ),
		.mem_instr  (mem_instr ),
		.mem_ready  (mem_ready ),
		.mem_addr   (mem_addr  ),
		.mem_wdata  (mem_wdata ),
		.mem_wstrb  (mem_wstrb ),
		.mem_rdata  (mem_rdata ),

		.pcpi_valid (pcpi_valid),
		.pcpi_insn  (pcpi_insn ),
		.pcpi_rs1   (pcpi_rs1  ),
		.pcpi_rs2   (pcpi_rs2  ),
		.pcpi_rs3   (pcpi_rs3  ),
		.pcpi_wr    (pcpi_wr   ),
		.pcpi_rd    (pcpi_rd   ),
		.pcpi_wait  (pcpi_wait ),
		.pcpi_ready (pcpi_ready)
	);
endmodule
