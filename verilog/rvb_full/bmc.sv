module bmc (
	input         clk,
	output        resetn,
	output reg    pcpi_valid,
	output [31:0] pcpi_insn,
	output [31:0] pcpi_rs1,
	output [31:0] pcpi_rs2,
	output [31:0] pcpi_rs3,

	output        ref_pcpi_wr,
	output [31:0] ref_pcpi_rd,
	output        ref_pcpi_wait,
	output        ref_pcpi_ready,

	output        mut_pcpi_wr,
	output [31:0] mut_pcpi_rd,
	output        mut_pcpi_wait,
	output        mut_pcpi_ready
);
	assign pcpi_insn = $anyconst;
	assign pcpi_rs1 = $anyconst;
	assign pcpi_rs2 = $anyconst;
	assign pcpi_rs3 = $anyconst;

	rvb_pcpi reference (
		.clk        (clk           ),
		.resetn     (resetn        ),
		.mutsel     (8'd 0         ),
		.pcpi_valid (pcpi_valid    ),
		.pcpi_insn  (pcpi_insn     ),
		.pcpi_rs1   (pcpi_rs1      ),
		.pcpi_rs2   (pcpi_rs2      ),
		.pcpi_rs3   (pcpi_rs3      ),
		.pcpi_wr    (ref_pcpi_wr   ),
		.pcpi_rd    (ref_pcpi_rd   ),
		.pcpi_wait  (ref_pcpi_wait ),
		.pcpi_ready (ref_pcpi_ready)
	);

	rvb_pcpi mutated (
		.clk        (clk           ),
		.resetn     (resetn        ),
		.mutsel     (8'd `mutidx   ),
		.pcpi_valid (pcpi_valid    ),
		.pcpi_insn  (pcpi_insn     ),
		.pcpi_rs1   (pcpi_rs1      ),
		.pcpi_rs2   (pcpi_rs2      ),
		.pcpi_rs3   (pcpi_rs3      ),
		.pcpi_wr    (mut_pcpi_wr   ),
		.pcpi_rd    (mut_pcpi_rd   ),
		.pcpi_wait  (mut_pcpi_wait ),
		.pcpi_ready (mut_pcpi_ready)
	);

	integer cycle = 0;
	always @(posedge clk) cycle <= cycle + 1;

	assign resetn = cycle != 0;

	initial pcpi_valid = 0;

	always @(posedge clk) begin
		if (pcpi_valid && ref_pcpi_ready)
			pcpi_valid <= 0;
		if (!resetn)
			pcpi_valid <= 1;
	end

	always @* begin
		if (resetn && ref_pcpi_ready && mut_pcpi_ready) begin
			assert (ref_pcpi_wr == mut_pcpi_wr);
			assert (ref_pcpi_rd == mut_pcpi_rd);
			assert (ref_pcpi_wait == mut_pcpi_wait);
		end
		if (resetn) begin
			assert (ref_pcpi_ready == mut_pcpi_ready);
		end
	end
endmodule
