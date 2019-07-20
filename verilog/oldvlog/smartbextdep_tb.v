module smartbextdep_tb;
	reg         clock;
	reg         bdep;
	reg  [31:0] rs1;
	reg  [31:0] rs2;
	wire [31:0] rd;

	smartbextdep uut (
		.clock (clock),
		.bdep  (bdep ),
		.rs1   (rs1  ),
		.rs2   (rs2  ),
		.rd    (rd   )
	);

	reg [95:0] testdata_bext [0:999];
	reg [95:0] testdata_bdep [0:999];

	initial begin
		$dumpfile("smartbextdep_tb.vcd");
		$dumpvars(0, smartbextdep_tb);

		$readmemh("testdata_bext.hex", testdata_bext);
		$readmemh("testdata_bdep.hex", testdata_bdep);

		#5 clock = 0;
		repeat (10000) #5 clock = ~clock;

		$display("TIMEOUT");
		$stop;
	end

	integer icnt, ocnt;

	initial begin
		repeat (5) @(posedge clock);

		bdep <= 0;
		for (icnt = 0; icnt < 1000; icnt = icnt+1) begin
			rs1 <= testdata_bext[icnt][95:64];
			rs2 <= testdata_bext[icnt][63:32];
			@(posedge clock);
		end

		bdep <= 1;
		for (icnt = 0; icnt < 1000; icnt = icnt+1) begin
			rs1 <= testdata_bdep[icnt][95:64];
			rs2 <= testdata_bdep[icnt][63:32];
			@(posedge clock);
		end
	end

	initial begin
		repeat (7) @(posedge clock);

		for (ocnt = 0; ocnt < 1000; ocnt = ocnt+1) begin
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
			$display("%8d: rs1=0x%08h rs2=0x%08h rd=0x%08h",
					ocnt, testdata_bdep[ocnt][95:64],
					testdata_bdep[ocnt][63:32], rd);
			if (rd != testdata_bdep[ocnt][31:0]) begin
				$display("Expected rd=0x%08h  =>  ERROR", testdata_bdep[ocnt][31:0]);
				$stop;
			end
			@(posedge clock);
		end

		repeat (10) @(posedge clock);
		$display("PASSED");
		$finish;
	end
endmodule
