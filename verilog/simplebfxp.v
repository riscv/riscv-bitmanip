module simplebfxp (
	input             clock,
	input      [31:0] rs1,
	input      [ 4:0] start, len, dest,
	output reg [31:0] rd
);
	always @(posedge clock) begin
		if (start+len > 32 || dest+len > 32) begin
			rd <= 0;
		end else begin
			rd <= ((rs1 << (32-start-len)) >> (32-len)) << dest;
		end
	end
endmodule
