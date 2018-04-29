module simplebextdep (
	input             clock,
	input             reset,

	input             din_valid,
	output            din_ready,
	input             din_bdep,
	input      [31:0] din_value,
	input      [31:0] din_mask,

	output            dout_valid,
	input             dout_ready,
	output     [31:0] dout_result
);
	reg bdep, running, ready;
	reg [31:0] c, m, msk, val;
	wire [31:0] b = msk & -msk;

	assign din_ready = !running || (dout_valid && dout_ready);
	assign dout_valid = running && ready;
	assign dout_result = c;

	always @(posedge clock) begin
		if (dout_valid && dout_ready) begin
			running <= 0;
			ready <= 0;
		end

		if (reset) begin
			running <= 0;
			ready <= 0;
		end else
		if (din_valid && din_ready) begin
			c <= 0;
			m <= 1;
			running <= 1;
			ready <= 0;
			bdep <= din_bdep;
			val <= din_value;
			msk <= din_mask;
		end else
		if (running && !ready) begin
			if (val & (bdep ? m : b))
				c <= c | (bdep ? b : m);
			msk <= msk & ~b;
			ready <= !(msk & ~b);
			m <= m << 1;
		end
	end
endmodule
