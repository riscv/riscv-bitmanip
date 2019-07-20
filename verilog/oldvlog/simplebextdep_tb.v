module simplebextdep_tb;
	reg         clock;
	reg         reset;
	reg         start;
	reg         bdep;
	reg  [31:0] rs1;
	reg  [31:0] rs2;
	wire [31:0] rd;
	wire        busy;
	wire        done;

	simplebextdep uut (
		.clock (clock),
		.reset (reset),
		.start (start),
		.bdep  (bdep ),
		.rs1   (rs1  ),
		.rs2   (rs2  ),
		.rd    (rd   ),
		.busy  (busy ),
		.done  (done )
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
		end else if (busy || done) begin
			cycle_cnt <= cycle_cnt + 1;
			job_cnt <= job_cnt + done;
		end
	end

	initial begin
		reset <= 1;
		start <= 0;
		repeat (5) @(posedge clock);

		reset <= 0;

		bdep <= 0;
		for (icnt = 0; icnt < 1000; icnt = icnt+1) begin
			start <= 1;
			rs1 <= testdata_bext[icnt][95:64];
			rs2 <= testdata_bext[icnt][63:32];
			@(posedge clock);
			start <= 0;
			while (!done) @(posedge clock);
		end

		bdep <= 1;
		for (icnt = 0; icnt < 1000; icnt = icnt+1) begin
			start <= 1;
			rs1 <= testdata_bdep[icnt][95:64];
			rs2 <= testdata_bdep[icnt][63:32];
			@(posedge clock);
			start <= 0;
			while (!done) @(posedge clock);
		end
	end

	initial begin
		repeat (5) @(posedge clock);

		for (ocnt = 0; ocnt < 1000; ocnt = ocnt+1) begin
			while (!done) @(posedge clock);
			$display("%8d: rs1=0x%08h rs2=0x%08h rd=0x%08h",
					ocnt, testdata_bext[ocnt][95:64],
					testdata_bext[ocnt][63:32], rd);
			if (rd != testdata_bext[ocnt][31:0]) begin
				$display("Expected rd=0x%08h  =>  ERROR", testdata_bext[ocnt][31:0]);
				$stop;
			end
			@(posedge clock);
		end

		for (ocnt = 0; ocnt < 1000; ocnt = ocnt+1) begin
			while (!done) @(posedge clock);
			$display("%8d: rs1=0x%08h rs2=0x%08h rd=0x%08h",
					ocnt, testdata_bdep[ocnt][95:64],
					testdata_bdep[ocnt][63:32], rd);
			if (rd != testdata_bdep[ocnt][31:0]) begin
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
