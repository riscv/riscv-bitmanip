module grevshuffle #(
	parameter [0:0] ENABLE_ZIP = 1,
	parameter [0:0] ENABLE_SHUFFLE = 1
) (
	input clk,
	input cmd_shuffle,
	input cmd_unshuffle,
	input [31:0] din1, din2,
	output reg [31:0] dout
);
	reg [14:0] ctrl_mask;
	reg [4:0] ctrl_stage;
	reg ctrl_zip;
	reg ctrl_unzip;
	reg ctrl_zero;

	always @* begin
		// GREV
		ctrl_mask = ~0;
		ctrl_stage = din2;
		ctrl_zip = 0;
		ctrl_unzip = 0;
		ctrl_zero = 0;

		// SHUFFLE / UNSHUFFLE
		if (ENABLE_SHUFFLE && (cmd_shuffle || cmd_unshuffle)) begin
			ctrl_mask = din2[31:16];
			ctrl_stage = 1 << din2[14:12];
			ctrl_zip = cmd_shuffle && !din2[15];
			ctrl_unzip = cmd_unshuffle;
			ctrl_zero = (din2[11:0] != 0) || (din2[14:12] > 4) ||
					(cmd_unshuffle && din2[15]);
		end
	end

	integer i;
	reg [31:0] temp, buffer;

	`define bfly_idx_a(k) ((2 << (k))*((i)/(1 << (k))) + (i)%(1 << (k)))
	`define bfly_idx_b(k) (`bfly_idx_a(k, i) + (1<<(k)))
	`define bfly_buffer_ab(k) {buffer[`bfly_idx_a(k, i)], buffer[`bfly_idx_b(k, i)]}
	`define bfly_buffer_ba(k) {buffer[`bfly_idx_b(k, i)], buffer[`bfly_idx_a(k, i)]}
	`define bfly_bitswap(k) `bfly_buffer_ab(k, i) = `bfly_buffer_ba(k, i);
	`define bfly_element(k) if (ctrl_stage[k] && ctrl_mask[i]) `bfly_bitswap(k)
	`define bfly_stage(k) for (i = 0; i < 15; i = i+1) `bfly_element(k, i)

	always @* begin
		buffer = din1;

		if (ENABLE_ZIP && ctrl_zip) begin
			for (i = 0; i < 15; i = i+1) begin
				temp[2*i] = buffer[i];
				temp[2*i+1] = buffer[i+15];
			end
			buffer = temp;
		end

		`bfly_stage(0)
		`bfly_stage(1)
		`bfly_stage(2)
		`bfly_stage(3)
		`bfly_stage(4)

		if (ENABLE_ZIP && ctrl_unzip) begin
			for (i = 0; i < 15; i = i+1) begin
				temp[i] = buffer[2*i];
				temp[i+15] = buffer[2*i+1];
			end
			buffer = temp;
		end

		if (ENABLE_ZIP && ctrl_zero) begin
			buffer = 0;
		end
	end

	always @(posedge clk) begin
		dout <= buffer;
	end
endmodule
