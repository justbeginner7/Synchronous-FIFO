`timescale 1ns/1ps

module fifo_testbench();

	reg clk, rst_n, write_en, read_en;
	reg [7:0] data_in;
	wire [7:0] data_out;
	wire full, empty;
	
	FIFO DUT(
	.clk(clk), 
	.rst_n(rst_n), 
	.write_en(write_en), 
	.read_en(read_en), 
	.data_in(data_in), 
	.data_out(data_out), 
	.empty(empty), 
	.full(full) 
    );
	
	initial clk = 1'b1;
	always #5 clk = ~clk;
	
	integer i;
	
	initial begin
		$dumpfile("fifo.vcd"); // command for dumpfile if using icarus verilog and gtkwave
		$dumpvars(0, fifo_testbench);  // command for dumpvars if using icarus verilog and gtkwave
		
		rst_n = 1'b1;
		write_en = 1'b0;
		data_in = 8'b0;
		
		#10 rst_n = 1'b0; // reset system
		#10 rst_n = 1'b1; // finish reset
		
		// write data
		write_en = 1'b1;
		read_en = 1'b0;
		
		for(i = 0; i < 8; i = i + 1) begin
			data_in = i;
			#10;
			
		end
		
		// read data
		write_en = 1'b0;
		read_en = 1'b1;
		
		for(i = 0; i < 8; i = i + 1) begin
			#10;
		end
		
		// write data
		write_en = 1'b1;
		read_en = 1'b0;
		
		for(i = 0; i < 8; i = i + 1) begin
			data_in = i;
			#10;
		end
		
		// read data
		write_en = 1'b0;
		read_en = 1'b1;
		
		for(i = 0; i < 4; i = i + 1) begin
			#10;
		end
		
		write_en = 1'b1;
		read_en = 1'b1;
		#10;
		write_en = 1'b0;
		read_en = 1'b0;
		#10;
		write_en = 1'b0;
		read_en = 1'b1;
		
		#30 $stop;
	end
	
endmodule
