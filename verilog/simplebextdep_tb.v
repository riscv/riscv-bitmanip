module simplebextdep_tb;
	reg         clock, reset;

	reg         din_valid;
	wire        din_ready;
	reg         din_bdep;
	reg  [31:0] din_value;
	reg  [31:0] din_mask;

	wire        dout_valid;
	reg         dout_ready;
	wire [31:0] dout_result;

	simplebextdep uut (
		.clock       (clock      ),
		.reset       (reset      ),
		.din_valid   (din_valid  ),
		.din_ready   (din_ready  ),
		.din_bdep    (din_bdep   ),
		.din_value   (din_value  ),
		.din_mask    (din_mask   ),
		.dout_valid  (dout_valid ),
		.dout_ready  (dout_ready ),
		.dout_result (dout_result)
	);

	reg [95:0] testdata_bext [0:999];
	reg [95:0] testdata_bdep [0:999];

	initial begin
		$dumpfile("simplebextdep_tb.vcd");
		$dumpvars(0, simplebextdep_tb);

		$readmemh("testdata_bext.hex", testdata_bext);
		$readmemh("testdata_bdep.hex", testdata_bdep);

		#5 clock = 0;
		repeat (100000) #5 clock = ~clock;

		$display("TIMEOUT");
		$stop;
	end

	integer icnt, ocnt;
	integer cycle_cnt, job_cnt;

	always @(posedge clock) begin
		if (reset) begin
			cycle_cnt <= 0;
			job_cnt <= 0;
		end else if (din_valid) begin
			cycle_cnt <= cycle_cnt + 1;
			job_cnt <= job_cnt + (din_valid && din_ready);
		end
	end

	initial begin
		reset <= 1;
		din_valid <= 0;
		din_bdep <= 0;
		din_value <= 0;
		din_mask <= 0;
		repeat (5) @(posedge clock);

		reset <= 0;
		din_valid <= 1;

		din_bdep <= 0;
		for (icnt = 0; icnt < 1000; icnt = icnt+1) begin
			din_value <= testdata_bext[icnt][95:64];
			din_mask <= testdata_bext[icnt][63:32];
			@(posedge clock);
			while (!din_ready) @(posedge clock);
		end

		din_bdep <= 1;
		for (icnt = 0; icnt < 1000; icnt = icnt+1) begin
			din_value <= testdata_bdep[icnt][95:64];
			din_mask <= testdata_bdep[icnt][63:32];
			@(posedge clock);
			while (!din_ready) @(posedge clock);
		end

		din_valid <= 0;
	end

	initial begin
		dout_ready <= 1;
		repeat (5) @(posedge clock);

		for (ocnt = 0; ocnt < 1000; ocnt = ocnt+1) begin
			while (!dout_valid) @(posedge clock);
			$display("%8d: rs1=0x%08h rs2=0x%08h rd=0x%08h",
					ocnt, testdata_bext[ocnt][95:64],
					testdata_bext[ocnt][63:32], dout_result);
			if (dout_result != testdata_bext[ocnt][31:0]) begin
				$display("Expected rd=0x%08h  =>  ERROR", testdata_bext[ocnt][31:0]);
				$stop;
			end
			@(posedge clock);
		end

		for (ocnt = 0; ocnt < 1000; ocnt = ocnt+1) begin
			while (!dout_valid) @(posedge clock);
			$display("%8d: rs1=0x%08h rs2=0x%08h rd=0x%08h",
					ocnt, testdata_bdep[ocnt][95:64],
					testdata_bdep[ocnt][63:32], dout_result);
			if (dout_result != testdata_bdep[ocnt][31:0]) begin
				$display("Expected rd=0x%08h  =>  ERROR", testdata_bdep[ocnt][31:0]);
				$stop;
			end
			@(posedge clock);
		end

		repeat (100) @(posedge clock);
		$display("Average cycles/job: %2d", cycle_cnt / job_cnt);
		$display("PASSED");
		$finish;
	end
endmodule
