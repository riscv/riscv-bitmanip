module rocketmuldiv_check (
	input         clock,
	input         reset,
	output        io_req_ready,
	input         io_req_valid,
	input  [3:0]  io_req_bits_fn,
	input  [31:0] io_req_bits_in1,
	input  [31:0] io_req_bits_in2,
	input  [4:0]  io_req_bits_tag,
	input         io_kill,
	input         io_resp_ready,
	output        io_resp_valid,
	output [31:0] io_resp_bits_data,
	output [4:0]  io_resp_bits_tag
);
	integer cycle = 0;

	always @(posedge clock) begin
		assume (reset == (cycle < 5));
		assume (io_req_valid == (cycle == 7));
		assume ($stable(io_req_bits_fn));
		assume ($stable(io_req_bits_in1));
		assume ($stable(io_req_bits_in2));
		assume (io_kill == 0);
		assume (io_resp_ready == 1);

		if (!reset) begin
			assert (!io_req_valid || io_req_ready);

			case (cycle)
				12: cover (io_resp_valid);
				41: cover (io_resp_valid);
				42: cover (io_resp_valid);
				43: cover (io_resp_valid);
				default: assert (!io_resp_valid);
			endcase

			if (io_resp_valid && io_resp_ready) begin
				restrict (io_req_bits_in1 > 2);
				restrict (io_req_bits_in2 > 2);
				restrict (io_resp_bits_data > 2);

				cover (io_req_bits_fn == 0);  // cmdMul=1 cmdHi=0 lhsSigned=1 rhsSigned=1
				cover (io_req_bits_fn == 1);  // cmdMul=1 cmdHi=1 lhsSigned=1 rhsSigned=1
				cover (io_req_bits_fn == 2);  // cmdMul=1 cmdHi=1 lhsSigned=1 rhsSigned=0
				cover (io_req_bits_fn == 3);  // cmdMul=1 cmdHi=1 lhsSigned=0 rhsSigned=0

				cover (io_req_bits_fn == 4);  // cmdMul=0 cmdHi=0 lhsSigned=1 rhsSigned=1
				cover (io_req_bits_fn == 5);  // cmdMul=0 cmdHi=0 lhsSigned=0 rhsSigned=0
				cover (io_req_bits_fn == 6);  // cmdMul=0 cmdHi=1 lhsSigned=1 rhsSigned=1
				cover (io_req_bits_fn == 7);  // cmdMul=0 cmdHi=1 lhsSigned=0 rhsSigned=0

				cover (io_req_bits_fn == 8);  // cmdMul=1 cmdHi=0 lhsSigned=1 rhsSigned=1
				cover (io_req_bits_fn == 9);  // cmdMul=1 cmdHi=1 lhsSigned=1 rhsSigned=1
				cover (io_req_bits_fn == 10); // cmdMul=1 cmdHi=1 lhsSigned=1 rhsSigned=0
				cover (io_req_bits_fn == 11); // cmdMul=1 cmdHi=1 lhsSigned=0 rhsSigned=0

				cover (io_req_bits_fn == 12); // cmdMul=0 cmdHi=0 lhsSigned=1 rhsSigned=1
				cover (io_req_bits_fn == 13); // cmdMul=0 cmdHi=0 lhsSigned=0 rhsSigned=0
				cover (io_req_bits_fn == 14); // cmdMul=0 cmdHi=1 lhsSigned=1 rhsSigned=1
				cover (io_req_bits_fn == 15); // cmdMul=0 cmdHi=1 lhsSigned=0 rhsSigned=0
			end
		end

		cycle <= cycle + 1;
	end

	rocketmuldiv uut (
		.clock            (clock            ),
		.reset            (reset            ),
		.io_req_ready     (io_req_ready     ),
		.io_req_valid     (io_req_valid     ),
		.io_req_bits_fn   (io_req_bits_fn   ),
		.io_req_bits_in1  (io_req_bits_in1  ),
		.io_req_bits_in2  (io_req_bits_in2  ),
		.io_req_bits_tag  (io_req_bits_tag  ),
		.io_kill          (io_kill          ),
		.io_resp_ready    (io_resp_ready    ),
		.io_resp_valid    (io_resp_valid    ),
		.io_resp_bits_data(io_resp_bits_data),
		.io_resp_bits_tag (io_resp_bits_tag )
	);
endmodule
