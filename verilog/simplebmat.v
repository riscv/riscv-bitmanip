module simplebmat (
	input clock,
	input xoren,
	input [63:0] rs1,
	input [63:0] rs2,
	output reg [63:0] rd
);
	integer i;

	reg [63:0] u; // rows of rs1
	reg [63:0] v; // cols of rs2
	reg [63:0] x;

	always @* begin
		u = rs1;
		for (i = 0; i < 64; i = i+1)
			v[i] = rs2[((i<<3) | (i>>3)) & 63];

		for (i = 0; i < 64; i = i+1)
			x[i] = xoren ? ^(u[(i>>3)*8 +: 8] & v[(i&7)*8 +: 8]) :
			               |(u[(i>>3)*8 +: 8] & v[(i&7)*8 +: 8]);
	end

	always @(posedge clock) begin
		rd <= x;
	end
endmodule
