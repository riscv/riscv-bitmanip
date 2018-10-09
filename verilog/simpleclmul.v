module simpleclmul (
	input clock,
	input reset, start, mul,
	input [31:0] rs1,
	input [31:0] rs2,
	output [63:0] rd,
	output busy, done
);
	parameter [0:0] DISABLE_CLMUL = 0;

	reg [4:0] state;
	reg [55:0] a;
	reg [31:0] b;
	reg [63:0] acc;

	integer i;
	reg [63:0] next_acc;

	function [127:0] carry_save;
		input [63:0] x;
		input [63:0] y;
		input [63:0] z;
		begin
			carry_save = {(mul || DISABLE_CLMUL) ? ((x & y) | (x & z) | (y & z)) << 1 : 64'd 0, x ^ y ^ z};
		end
	endfunction

	reg [63:0] s0, s1, s2, s3, s4, s5, s6, s7;
	reg [63:0] t0, t1, t2, t3, t4, t5, t6, t7, t8, t9, t10, t11, t12, t13;

	always @* begin
		s0 = {64{b[0]}} & (a << 0);
		s1 = {64{b[1]}} & (a << 1);
		s2 = {64{b[2]}} & (a << 2);
		s3 = {64{b[3]}} & (a << 3);
		s4 = {64{b[4]}} & (a << 4);
		s5 = {64{b[5]}} & (a << 5);
		s6 = {64{b[6]}} & (a << 6);
		s7 = {64{b[7]}} & (a << 7);

		// --- layer 1

		{t0, t1} = carry_save(s0, s1, s2);
		{t2, t3} = carry_save(s3, s4, s5);
		{t4, t5} = carry_save(s6, s7, acc);

		// --- layer 2

		{t6, t7} = carry_save(t0, t1, t2);
		{t8, t9} = carry_save(t3, t4, t5);

		// --- layer 3

		{t10, t11} = carry_save(t6, t7, t8);

		// --- layer 4

		{t12, t13} = carry_save(t10, t11, t9);

		// --- layer 5

		next_acc = t12 + t13;
	end

	always @(posedge clock) begin
		if (reset || start) begin
			a <= rs1;
			b <= rs2;
			acc <= 0;
			state <= !reset;
		end else begin
			a <= a << 8;
			b <= b >> 8;
			acc <= next_acc;
			state <= state << 1;
		end
	end

	assign rd = acc;
	assign busy = |state[3:0];
	assign done = state[4];
endmodule
