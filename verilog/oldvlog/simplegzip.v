module simplegzip (
	input clock,
	input [31:0] rs1,
	input [4:0] rs2,
	output reg [31:0] rd
);
	reg [31:0] x;

	function [31:0] gzip32_stage;
		input [31:0] src, maskL, maskR;
		input [4:0] shamt;
		begin
			gzip32_stage = src & ~(maskL | maskR);
			gzip32_stage = gzip32_stage | ((src << shamt) & maskL);
			gzip32_stage = gzip32_stage | ((src >> shamt) & maskR);
		end
	endfunction

	always @* begin
		x = rs1;
		if (rs2[0]) begin
			if (rs2[1]) x = gzip32_stage(x, 32'h44444444, 32'h22222222, 1);
			if (rs2[2]) x = gzip32_stage(x, 32'h30303030, 32'h0c0c0c0c, 2);
			if (rs2[3]) x = gzip32_stage(x, 32'h0f000f00, 32'h00f000f0, 4);
			if (rs2[4]) x = gzip32_stage(x, 32'h00ff0000, 32'h0000ff00, 8);
		end else begin
			if (rs2[4]) x = gzip32_stage(x, 32'h00ff0000, 32'h0000ff00, 8);
			if (rs2[3]) x = gzip32_stage(x, 32'h0f000f00, 32'h00f000f0, 4);
			if (rs2[2]) x = gzip32_stage(x, 32'h30303030, 32'h0c0c0c0c, 2);
			if (rs2[1]) x = gzip32_stage(x, 32'h44444444, 32'h22222222, 1);
		end
	end

	always @(posedge clock) begin
		rd <= x;
	end
endmodule
