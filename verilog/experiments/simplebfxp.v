module simplebfxp (
	input             clock,
	input      [31:0] rs1, rs2,
	input      [ 4:0] start, len, dest,
	input             bfxpc,
	output reg [31:0] rd
);
	wire [ 4:0] ror_shamt = start - dest;
	wire [31:0] ror_dout;

	wire [31:0] lmask = 32'h ffff_ffff >> (32-dest-len);
	wire [31:0] rmask = 32'h ffff_ffff << dest;
	wire [31:0] mask = lmask & rmask;

	ror ror_inst (.din(rs1), .shamt(ror_shamt), .dout(ror_dout));

	always @(posedge clock) begin
		rd <= ((ror_dout ^ {32{bfxpc}}) & mask) | (rs2 & ~mask);
	end
endmodule

(* keep_hierarchy *)
module ror (
	input  [31:0] din,
	input  [ 4:0] shamt,
	output [31:0] dout
);
	assign dout = {din, din} >> shamt;
endmodule
