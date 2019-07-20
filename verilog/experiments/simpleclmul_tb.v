module simpleclmul_tb;
	reg         clock;
	reg         reset;
	reg         start;
	reg         mul;
	reg  [31:0] rs1;
	reg  [31:0] rs2;
	wire [63:0] rd;
	wire        busy;
	wire        done;

	simpleclmul uut (
		.clock (clock),
		.reset (reset),
		.start (start),
		.mul   (mul  ),
		.rs1   (rs1  ),
		.rs2   (rs2  ),
		.rd    (rd   ),
		.busy  (busy ),
		.done  (done )
	);

	reg [131:0] testdata_clmul [0:999];

	initial begin
		$dumpfile("simpleclmul_tb.vcd");
		$dumpvars(0, simpleclmul_tb);

		$readmemh("testdata_clmul.hex", testdata_clmul);

		#5 clock = 0;
		repeat (20000) #5 clock = ~clock;

		$display("TIMEOUT");
		$stop;
	end

	integer icnt, ocnt;

	initial begin
		start <= 0;
		reset <= 1;
		repeat (5) @(posedge clock);
		reset <= 0;
		repeat (5) @(posedge clock);

		for (icnt = 0; icnt < 1000; icnt = icnt+1) begin
			start <= 1;
			mul <= testdata_clmul[icnt][128];
			rs1 <= testdata_clmul[icnt][127:96];
			rs2 <= testdata_clmul[icnt][95:64];
			@(posedge clock);

			start <= 0;
			mul <= 'bx;
			rs1 <= 'bx;
			rs2 <= 'bx;
			repeat (4) @(posedge clock);
			if (icnt % 3 == 0) repeat (4) @(posedge clock);
			if (icnt % 5 == 0 || icnt % 5 == 2) repeat (2) @(posedge clock);
			if (icnt % 7 == 0 || icnt % 7 == 5) @(posedge clock);
		end
	end

	initial begin
		repeat (10) @(posedge clock);

		for (ocnt = 0; ocnt < 1000; ocnt = ocnt+1) begin
			while (!done) @(posedge clock);

			$display("%8d: mul=%b rs1=%h rs2=%h rd=%h", ocnt, testdata_clmul[ocnt][128], testdata_clmul[ocnt][127:96], testdata_clmul[ocnt][95:64], rd);

			if (rd !== testdata_clmul[ocnt][63:0]) begin
				$display("Expected rd=%h  =>  ERROR", testdata_clmul[ocnt][63:0]);
				$stop;
			end

			@(posedge clock);
		end

		$display("PASSED");
		$finish;
	end
endmodule
