module simplebitcnt (
	input clock,
	input clz, ctz,
	input [31:0] rs1,
	output reg [31:0] rd
);
	reg [31:0] x, y;
	integer i;

	always @* begin
		x = rs1;

		if (clz) begin
			x = ((x & 32'h55555555) <<  1) | ((x & 32'hAAAAAAAA) >>  1);
			x = ((x & 32'h33333333) <<  2) | ((x & 32'hCCCCCCCC) >>  2);
			x = ((x & 32'h0F0F0F0F) <<  4) | ((x & 32'hF0F0F0F0) >>  4);
			x = ((x & 32'h00FF00FF) <<  8) | ((x & 32'hFF00FF00) >>  8);
			x = ((x & 32'h0000FFFF) << 16) | ((x & 32'hFFFF0000) >> 16);
		end

		if (clz || ctz) begin
			x = (x-1) & ~x;
		end

		y = 0;
		for (i = 0; i < 32; i = i + 1) begin
			y = y + x[i];
		end
	end

	always @(posedge clock) begin
		rd <= y;
	end
endmodule
