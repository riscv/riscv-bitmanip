module tinybmat (
	input clock,
	input reset, start, xoren,
	input [63:0] rs1,
	input [63:0] rs2,
	output [63:0] rd,
	output busy, done
);
	reg xor_mode;
	reg [8:0] state;
	reg [63:0] u; // rows of rs1
	reg [63:0] v; // cols of rs2
	reg [63:0] acc;

	integer i;
	reg [63:0] next_acc;

	always @* begin
		next_acc = acc << 8;
		for (i = 0; i < 8; i = i+1)
			next_acc[i] = xor_mode ? ^(u[63:56] & v[i*8 +: 8]) : |(u[63:56] & v[i*8 +: 8]);
	end

	always @(posedge clock) begin
		if (reset || start) begin
			xor_mode <= xoren;
			state <= !reset;
			u <= rs1;
			for (i = 0; i < 64; i = i+1)
				v[i] <= rs2[((i<<3) | (i>>3)) & 63];
		end else begin
			u[63:8] <= u;
			acc <= next_acc;
			state <= state << 1;
		end
	end

	assign rd = acc;
	assign busy = |state[7:0];
	assign done = state[8];
endmodule
