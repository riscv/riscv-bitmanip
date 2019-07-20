module genzip (
	input [31:0] din,
	input [4:0] mode,
	output [31:0] dout,
);
	function [4:0] idxswap;
		input [4:0] idx;
		input [2:0] p, q;
		begin
			idxswap = idx;
			idxswap[p] = idx[q];
			idxswap[q] = idx[p];
		end
	endfunction

	wire [31:0] stage_0_0, stage_0_1, stage_0_2, stage_0_3;
	wire [31:0] stage_1_0, stage_1_1, stage_1_2, stage_1_3;

	genvar i;
	generate for (i = 0; i < 32; i = i+1) begin
		assign stage_0_0[i] = mode[4] ? din[idxswap(i, 4, 3)] : din[i];
		assign stage_0_1[i] = mode[3] ? stage_0_0[idxswap(i, 3, 2)] : stage_0_0[i];
		assign stage_0_2[i] = mode[2] ? stage_0_1[idxswap(i, 2, 1)] : stage_0_1[i];
		assign stage_0_3[i] = mode[1] ? stage_0_2[idxswap(i, 1, 0)] : stage_0_2[i];
		
		assign stage_1_0[i] = mode[4] ? din[idxswap(i, 1, 0)] : din[i];
		assign stage_1_1[i] = mode[3] ? stage_1_0[idxswap(i, 2, 1)] : stage_1_0[i];
		assign stage_1_2[i] = mode[2] ? stage_1_1[idxswap(i, 3, 2)] : stage_1_1[i];
		assign stage_1_3[i] = mode[1] ? stage_1_2[idxswap(i, 4, 3)] : stage_1_2[i];
	end endgenerate

	assign dout = mode[0] ? stage_1_3 : stage_0_3;
endmodule
