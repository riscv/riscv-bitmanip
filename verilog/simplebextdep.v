module simplebextdep (
	input clock,
	input reset, start, bdep,
	input [31:0] rs1, rs2,
	output [31:0] rd,
	output busy, done
);
	reg mode, running, ready;
	reg [31:0] c, m, msk, val;
	wire [31:0] b = msk & -msk;

	always @(posedge clock) begin
		if (reset || start) begin
			c <= 0;
			m <= 1;
			running <= !reset;
			ready <= 0;
			mode <= bdep;
			val <= rs1;
			msk <= rs2;
		end else
		if (running && !ready) begin
			if (val & (mode ? m : b))
				c <= c | (mode ? b : m);
			msk <= msk & ~b;
			ready <= !(msk & ~b);
			m <= m << 1;
		end else begin
			running <= 0;
		end
	end

	assign busy = running && !ready;
	assign done = running && ready;
	assign rd = c;
endmodule
