module reference_ror (
	input clock,
	input [31:0] din,
	input [4:0] shamt,
	output reg [31:0] dout
);
	always @(posedge clock)
		dout <= {din, din} >> shamt;
endmodule
