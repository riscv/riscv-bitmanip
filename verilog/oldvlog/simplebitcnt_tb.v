module simplebitcnt_tb;
	reg         clock;
	reg         clz, ctz;
	reg  [31:0] rs1;
	wire [31:0] rd;

	simplebitcnt uut (
		.clock (clock),
		.clz   (clz  ),
		.ctz   (ctz  ),
		.rs1   (rs1  ),
		.rd    (rd   )
	);

	reg [63:0] testdata_clz [0:999];
	reg [63:0] testdata_ctz [0:999];
	reg [63:0] testdata_pcnt [0:999];

	initial begin
		$dumpfile("simplebitcnt_tb.vcd");
		$dumpvars(0, simplebitcnt_tb);

		$readmemh("testdata_clz.hex", testdata_clz);
		$readmemh("testdata_ctz.hex", testdata_ctz);
		$readmemh("testdata_pcnt.hex", testdata_pcnt);

		#5 clock = 0;
		repeat (20000) #5 clock = ~clock;

		$display("TIMEOUT");
		$stop;
	end

	integer icnt, ocnt;

	initial begin
		repeat (5) @(posedge clock);

		for (icnt = 0; icnt < 1000; icnt = icnt+1) begin
			clz <= 1;
			ctz <= 0;
			rs1 <= testdata_clz[icnt][63:32];
			@(posedge clock);
		end

		for (icnt = 0; icnt < 1000; icnt = icnt+1) begin
			clz <= 0;
			ctz <= 1;
			rs1 <= testdata_ctz[icnt][63:32];
			@(posedge clock);
		end

		for (icnt = 0; icnt < 1000; icnt = icnt+1) begin
			clz <= 0;
			ctz <= 0;
			rs1 <= testdata_pcnt[icnt][63:32];
			@(posedge clock);
		end
	end

	initial begin
		repeat (7) @(posedge clock);

		for (ocnt = 0; ocnt < 1000; ocnt = ocnt+1) begin
			$display("%8d: rs1=%h rd=%h", ocnt, testdata_clz[ocnt][63:32], rd);
			if (rd !== testdata_clz[ocnt][31:0]) begin
				$display("Expected rd=%h  =>  ERROR", testdata_clz[ocnt][31:0]);
				$stop;
			end
			@(posedge clock);
		end

		for (ocnt = 0; ocnt < 1000; ocnt = ocnt+1) begin
			$display("%8d: rs1=%h rd=%h", ocnt, testdata_ctz[ocnt][63:32], rd);
			if (rd !== testdata_ctz[ocnt][31:0]) begin
				$display("Expected rd=%h  =>  ERROR", testdata_ctz[ocnt][31:0]);
				$stop;
			end
			@(posedge clock);
		end

		for (ocnt = 0; ocnt < 1000; ocnt = ocnt+1) begin
			$display("%8d: rs1=%h rd=%h", ocnt, testdata_pcnt[ocnt][63:32], rd);
			if (rd !== testdata_pcnt[ocnt][31:0]) begin
				$display("Expected rd=%h  =>  ERROR", testdata_pcnt[ocnt][31:0]);
				$stop;
			end
			@(posedge clock);
		end

		$display("PASSED");
		$finish;
	end
endmodule
