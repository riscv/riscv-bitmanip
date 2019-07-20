module simplebmat_tb;
	reg         clock;
	reg         xoren;
	reg  [63:0] rs1;
	reg  [63:0] rs2;
	wire [63:0] rd;

	simplebmat uut (
		.clock (clock),
		.xoren (xoren),
		.rs1   (rs1  ),
		.rs2   (rs2  ),
		.rd    (rd   )
	);

	reg [192:0] testdata_bmat [0:999];

	initial begin
		$dumpfile("simplebmat_tb.vcd");
		$dumpvars(0, simplebmat_tb);

		$readmemh("testdata_bmat.hex", testdata_bmat);

		#5 clock = 0;
		repeat (20000) #5 clock = ~clock;

		$display("TIMEOUT");
		$stop;
	end

	integer icnt, ocnt;

	initial begin
		repeat (5) @(posedge clock);

		for (icnt = 0; icnt < 1000; icnt = icnt+1) begin
			xoren <= testdata_bmat[icnt][192];
			rs1 <= testdata_bmat[icnt][191:128];
			rs2 <= testdata_bmat[icnt][127:64];
			@(posedge clock);
		end
	end

	initial begin
		repeat (7) @(posedge clock);

		for (ocnt = 0; ocnt < 1000; ocnt = ocnt+1) begin
			$display("%8d: xor=%b rs1=%h rs2=%h rd=%h", ocnt, testdata_bmat[ocnt][192], testdata_bmat[ocnt][191:128], testdata_bmat[ocnt][127:64], rd);

			if (rd !== testdata_bmat[ocnt][63:0]) begin
				$display("Expected rd=%h  =>  ERROR", testdata_bmat[ocnt][63:0]);
				$stop;
			end

			@(posedge clock);
		end

		$display("PASSED");
		$finish;
	end
endmodule
