module tinygrev_tb;
	reg         clock;
	reg         reset;
	reg         start;
	reg  [31:0] rs1;
	reg  [ 4:0] rs2;
	wire [31:0] rd;
	wire        busy;
	wire        done;

	tinygrev uut (
		.clock (clock),
		.reset (reset),
		.start (start),
		.rs1   (rs1  ),
		.rs2   (rs2  ),
		.rd    (rd   ),
		.busy  (busy ),
		.done  (done )
	);

	reg [71:0] testdata_grev [0:999];

	initial begin
		$dumpfile("tinygrev_tb.vcd");
		$dumpvars(0, tinygrev_tb);

		$readmemh("testdata_grev.hex", testdata_grev);

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
			rs1 <= testdata_grev[icnt][71:40];
			rs2 <= testdata_grev[icnt][39:32];
			@(posedge clock);

			start <= 0;
			rs1 <= 'bx;
			rs2 <= 'bx;
			repeat (5) @(posedge clock);
			if (icnt % 3 == 0) repeat (4) @(posedge clock);
			if (icnt % 5 == 0 || icnt % 5 == 2) repeat (2) @(posedge clock);
			if (icnt % 7 == 0 || icnt % 7 == 5) @(posedge clock);
		end
	end

	initial begin
		repeat (10) @(posedge clock);

		for (ocnt = 0; ocnt < 1000; ocnt = ocnt+1) begin
			while (!done) @(posedge clock);

			$display("%8d: rs1=%h rs2=%h rd=%h", ocnt, testdata_grev[ocnt][71:40], testdata_grev[ocnt][39:32], rd);

			if (rd !== testdata_grev[ocnt][31:0]) begin
				$display("Expected rd=%h  =>  ERROR", testdata_grev[ocnt][31:0]);
				$stop;
			end

			@(posedge clock);
		end

		$display("PASSED");
		$finish;
	end
endmodule
