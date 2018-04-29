module simplegrev (
	input clock,
	input [31:0] rs1,
	input [4:0] rs2,
	output reg [31:0] rd
);
	reg [31:0] x;

	always @* begin
		x = rs1;
		if (rs2[0]) x = ((x & 32'h55555555) <<  1) | ((x & 32'hAAAAAAAA) >>  1);
		if (rs2[1]) x = ((x & 32'h33333333) <<  2) | ((x & 32'hCCCCCCCC) >>  2);
		if (rs2[2]) x = ((x & 32'h0F0F0F0F) <<  4) | ((x & 32'hF0F0F0F0) >>  4);
		if (rs2[3]) x = ((x & 32'h00FF00FF) <<  8) | ((x & 32'hFF00FF00) >>  8);
		if (rs2[4]) x = ((x & 32'h0000FFFF) << 16) | ((x & 32'hFFFF0000) >> 16);
	end

	always @(posedge clock) begin
		rd <= x;
	end
endmodule
