module tinygzip (
	input clock,
	input reset, start,
	input [31:0] rs1,
	input [4:0] rs2,
	output [31:0] rd,
	output busy, done
);
	reg [4:0] state;
	reg [4:0] mask;
	reg [31:0] buffer;

	function [31:0] gzip32_stage;
		input [31:0] src, maskL, maskR;
		input [4:0] shamt;
		begin
			gzip32_stage = src & ~(maskL | maskR);
			gzip32_stage = gzip32_stage | ((src << shamt) & maskL);
			gzip32_stage = gzip32_stage | ((src >> shamt) & maskR);
		end
	endfunction

	wire [31:0] buffer_zip8w = gzip32_stage(buffer, 32'h00ff0000, 32'h0000ff00, 8);
	wire [31:0] buffer_zip4h = gzip32_stage(buffer, 32'h0f000f00, 32'h00f000f0, 4);
	wire [31:0] buffer_zip2b = gzip32_stage(buffer, 32'h30303030, 32'h0c0c0c0c, 2);
	wire [31:0] buffer_zip1n = gzip32_stage(buffer, 32'h44444444, 32'h22222222, 1);

	wire apply_zip8w = mask[0] ? state[3] && mask[4] : state[0] && mask[4];
	wire apply_zip4h = mask[0] ? state[2] && mask[3] : state[1] && mask[3];
	wire apply_zip2b = mask[0] ? state[1] && mask[2] : state[2] && mask[2];
	wire apply_zip1n = mask[0] ? state[0] && mask[1] : state[3] && mask[1];
	wire bypass = !apply_zip8w && !apply_zip4h && !apply_zip2b && !apply_zip1n;

	always @(posedge clock) begin
		if (reset || start) begin
			buffer <= rs1;
			mask <= rs2;
			state <= !reset;
		end else begin
			(* parallel_case, full_case *)
			case (1'b1)
				apply_zip8w: buffer <= buffer_zip8w;
				apply_zip4h: buffer <= buffer_zip4h;
				apply_zip2b: buffer <= buffer_zip2b;
				apply_zip1n: buffer <= buffer_zip1n;
				bypass: buffer <= buffer;
			endcase
			state <= state << 1;
		end
	end

	assign rd = buffer;
	assign busy = |state[3:0];
	assign done = state[4];
endmodule
