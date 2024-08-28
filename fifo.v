module FIFO(
	input clk, // clk
	input rst_n, // active low reset
	input write_en, // write enable
	input read_en, // read enable
	input [7:0]data_in, // data written in FIFO
	output reg [7:0]data_out, // data read from FIFO
	output empty, // FIFO is empty when high
	output full // FIFO is full when high
);
	parameter DEPTH = 8;
	reg[7:0] mem [0:DEPTH-1];
	reg [2:0] wr_ptr;
	reg [2:0] rd_ptr;
	reg [3:0] count;
	
	// write process
	always @(posedge clk or negedge rst_n) begin
		if(!rst_n)
			wr_ptr <= 0;
		else begin
			if(write_en) begin
				mem[wr_ptr] <= data_in;
				wr_ptr <= wr_ptr + 1;
			end
		end
	end
	
	// read process
	always @(posedge clk or negedge rst_n) begin
		if(!rst_n)
			rd_ptr <= 0;
		else begin
			if(read_en) begin
				data_out <= mem[rd_ptr];
				rd_ptr <= rd_ptr + 1;
			end
		end
	end
	
	// count variable
	always @(posedge clk or negedge rst_n) begin
		if(!rst_n) 
			count <= 4'd0;
		else begin
			case({write_en, read_en})
				2'b00: count <= count;
				2'b01: count <= count - 1;
				2'b10: count <= count + 1;
				2'b11: count <= count;
				default: count <= count;
			endcase
		end
	end
	
	// assign full and empty
	assign full = (count == DEPTH);
	assign empty = (count == 0);
	
endmodule