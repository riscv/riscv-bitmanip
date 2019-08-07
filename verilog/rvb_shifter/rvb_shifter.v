module rvb_shifter #(
	parameter integer XLEN = 64,
	parameter [0:0] SBOP = 0
) (
	// control signals
	input             clock,          // positive edge clock
	input             reset,          // synchronous reset

	// data input
	input             din_valid,      // input is valid
	output            din_ready,      // core accepts input
	input  [XLEN-1:0] din_rs1,        // value of 1st argument
	input  [XLEN-1:0] din_rs2,        // value of 2nd argument
	input  [XLEN-1:0] din_rs3,        // value of 3rd argument
	input             din_insn3,      // value of instruction bit 3
	input             din_insn14,     // value of instruction bit 14
	input             din_insn26,     // value of instruction bit 26
	input             din_insn27,     // value of instruction bit 27
	input             din_insn29,     // value of instruction bit 29
	input             din_insn30,     // value of instruction bit 30

	// data output
	output            dout_valid,     // output is valid
	input             dout_ready,     // accept output
	output [XLEN-1:0] dout_rd         // output value
);
	// 30 29 27 26 14  3   Function
	// -----------------   --------
	//  0  0  0  0  0  W   SLL
	//  0  0  0  0  1  W   SRL
	//  1  0  0  0  1  W   SRA
	//  0  1  0  0  0  W   SLO
	//  0  1  0  0  1  W   SRO
	//  1  1  0  0  0  W   ROL
	//  1  1  0  0  1  W   ROR
	// -----------------   --------
	//  -  -  -  1  0  W   FSL
	//  -  -  -  1  1  W   FSR
	// -----------------   --------
	//  0  0  1  0  0  W   SHFL
	//  0  0  1  0  1  W   UNSHFL
	// -----------------   --------
	//  0  1  1  0  0  W   SBSET
	//  1  0  1  0  0  W   SBCLR
	//  1  1  1  0  0  W   SBINV
	//  1  0  1  0  1  W   SBEXT

	assign dout_valid = din_valid;
	assign din_ready = dout_ready;

	wire wmode = (XLEN == 32) || din_insn3;
	wire sbmode = SBOP && {din_insn30, din_insn29} && din_insn27 && !din_insn26;

	// wire shfl = SHFL && {din_insn30, din_insn29, din_insn27, din_insn26} == 4'b0010;
	// wire unshfl = shfl && din_insn14;

	reg [63:0] Y;
	wire [63:0] A, B, X;
	assign A = din_rs1, B = din_rs3;
	assign dout_rd = wmode ? {{32{Y[31]}}, Y[31:0]} : Y;

	reg [63:0] aa, bb;
	reg [6:0] shamt;

	always @* begin
		shamt = din_rs2;
		aa = A;
		bb = B;

		if (wmode || !din_insn26)
			shamt[6] = 0;

		if (wmode && !din_insn26)
			shamt[5] = 0;

		if (din_insn14)
			shamt = -shamt;

		if (!din_insn26) begin
			casez ({din_insn30, din_insn29})
				2'b 0z: bb = {64{din_insn29}};
				2'b 10: bb = {64{wmode ? A[31] : A[63]}};
				2'b 11: bb = A;
			endcase
			if (sbmode && !din_insn14) begin
				aa = 1;
				bb = 0;
			end
		end
	end

	always @* begin
		Y = X;
		if (sbmode) begin
			casez ({din_insn30, din_insn29, din_insn14})
				3'b zz1: Y = 1 &  X;
				3'b 0zz: Y = A |  X;
				3'b z0z: Y = A & ~X;
				3'b 11z: Y = A ^  X;
			endcase
		end
	end

	rvb_shifter_datapath datapath (
		.A     (aa   ),
		.B     (bb   ),
		.X     (X    ),
		.shamt (shamt),
		.wmode (wmode)
	);
endmodule

module rvb_shifter_datapath (
	input  [63:0] A, B,
	output [63:0] X,
	input  [ 6:0] shamt,
	input         wmode
);
	reg [127:0] tmp, tmp2;

	wire shamt_5_0 = wmode ? 0 : shamt[5];
	wire shamt_5_1 = wmode ? 1 : shamt[5];
	wire shamt_5_2 = wmode ? 0 : shamt[5];
	wire shamt_5_3 = wmode ? 1 : shamt[5];

	wire shamt_6_0 = wmode ?  shamt[5] : shamt[6];
	wire shamt_6_1 = wmode ? !shamt[5] : shamt[6];
	wire shamt_6_2 = wmode ? !shamt[5] : shamt[6];
	wire shamt_6_3 = wmode ?  shamt[5] : shamt[6];

	always @* begin
		tmp = {B, A};

		tmp2 = tmp;
		if (shamt_5_0) tmp2[ 31: 0] = tmp[127:96];
		if (shamt_5_1) tmp2[ 63:32] = tmp[ 31: 0];
		if (shamt_5_2) tmp2[ 95:64] = tmp[ 63:32];
		if (shamt_5_3) tmp2[127:96] = tmp[ 95:64];

		tmp = tmp2;
		if (shamt_6_0) tmp[ 31: 0] = tmp2[ 95:64];
		if (shamt_6_1) tmp[ 63:32] = tmp2[127:96];
		if (shamt_6_2) tmp[ 95:64] = tmp2[ 31: 0];
		if (shamt_6_3) tmp[127:96] = tmp2[ 63:32];

		if (shamt[4]) tmp = {tmp[111:0], tmp[127:112]};
		if (shamt[3]) tmp = {tmp[119:0], tmp[127:120]};
		if (shamt[2]) tmp = {tmp[123:0], tmp[127:124]};
		if (shamt[1]) tmp = {tmp[125:0], tmp[127:126]};
		if (shamt[0]) tmp = {tmp[126:0], tmp[127:127]};
	end

	assign X = tmp;
endmodule
