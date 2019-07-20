module simplegzip_tb;
	reg         clock;
	reg  [31:0] rs1;
	reg  [ 4:0] rs2;
	wire [31:0] rd;

	simplegzip uut (
		.clock (clock),
		.rs1   (rs1  ),
		.rs2   (rs2  ),
		.rd    (rd   )
	);

	reg [71:0] testdata_gzip [0:999];

	initial begin
		$dumpfile("simplegzip_tb.vcd");
		$dumpvars(0, simplegzip_tb);

		$readmemh("testdata_gzip.hex", testdata_gzip);

		#5 clock = 0;
		repeat (20000) #5 clock = ~clock;

		$display("TIMEOUT");
		$stop;
	end

	integer icnt, ocnt;

	initial begin
		repeat (5) @(posedge clock);

		for (icnt = 0; icnt < 1000; icnt = icnt+1) begin
			rs1 <= testdata_gzip[icnt][71:40];
			rs2 <= testdata_gzip[icnt][39:32];
			@(posedge clock);
		end
	end

	initial begin
		repeat (7) @(posedge clock);

		for (ocnt = 0; ocnt < 1000; ocnt = ocnt+1) begin
			$display("%8d: rs1=%h rs2=%h rd=%h", ocnt, testdata_gzip[ocnt][71:40], testdata_gzip[ocnt][39:32], rd);
			if (rd !== testdata_gzip[ocnt][31:0]) begin
				$display("Expected rd=%h  =>  ERROR", testdata_gzip[ocnt][31:0]);
				$stop;
			end
			@(posedge clock);
		end

		$display("PASSED");
		$finish;
	end
endmodule
