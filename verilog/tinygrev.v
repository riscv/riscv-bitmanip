module tinygrev (
	input clock,
	input start,
	input [31:0] rs1,
	input [4:0] rs2,
	output [31:0] rd,
	output done
);
	reg [5:0] state;
	reg [4:0] mask;
	reg [31:0] buffer;

	wire [31:0] buffer_bfly;
	wire [31:0] buffer_bfly_unzip;

	genvar i;
	generate for (i = 0; i < 16; i = i+1) begin
		assign buffer_bfly[2*i] = (state & mask) ? buffer[2*i+1] : buffer[2*i];
		assign buffer_bfly[2*i+1] = (state & mask) ? buffer[2*i] : buffer[2*i+1];

		assign buffer_bfly_unzip[i] = buffer_bfly[2*i];
		assign buffer_bfly_unzip[16+i] = buffer_bfly[2*i+1];
	end endgenerate

	always @(posedge clock) begin
		if (start) begin
			buffer <= rs1;
			mask <= rs2;
			state <= 1;
		end else begin
			buffer <= buffer_bfly_unzip;
			state <= state << 1;
		end
	end

	assign rd = buffer;
	assign done = state[5];
endmodule
