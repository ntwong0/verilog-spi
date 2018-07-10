`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/23/2018 03:36:49 PM
// Design Name: 
// Module Name: Test_Memory
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module Test_Memory;

reg clk;
reg rst;
reg wr_cs;
reg wr_en;
reg rd_cs;
reg rd_en;
reg [7:0] in;
wire [7:0] out;
wire full;
wire empty;
wire overflow;
wire underflow;

FIFO #(.LENGTH(4), .WIDTH(8)) fifo (
    .clk(clk),
    .rst(rst),
    .wr_cs(wr_cs),
    .wr_en(wr_en),
    .rd_cs(rd_cs),
    .rd_en(rd_en),
    .overflow(overflow),
    .full(full),
    .empty(empty),
    .underflow(underflow),
    .out(out),
    .in(in)
);

task RESET;
begin
    rst = 0;
    clk = 0;
    
    wr_cs = 0;
    wr_en = 0;
    rd_cs = 0;
    rd_en = 0;
    
    #5
    rst = 1;
    #5
    rst = 0;
end
endtask;

task CLOCK;
	input [31:0] count;
	integer k;
begin
	for (k=0; k < count; k = k+1)
	begin
		#5
		clk = 1;
		#5
		clk = 0;
	end
end
endtask

task FIFO_PUSH;
	input [7:0] send;
begin
    wr_cs = 1;
    wr_en = 1;
    rd_cs = 0;
    rd_en = 0;
    in = send;    
    CLOCK(1);
    wr_cs = 0;
    wr_en = 0;
    in = 0;
end
endtask

task FIFO_POP;
    output [7:0] return;
    input [7:0] check;
begin
    wr_cs = 0;
    wr_en = 0;
    rd_cs = 1;
    rd_en = 1;
    CLOCK(1);
    return = out;
    rd_cs = 0;
    rd_en = 0;

    if(return !== check)
    begin
        $display("Error returned (0x%X) != check (0x%X)", return, check);
    end
end
endtask


task FIFO_PUSH_POP;
    input [7:0] send;
    output [7:0] return;
    input [7:0] check;
begin
    wr_cs = 1;
    wr_en = 1;
    rd_cs = 1;
    rd_en = 1;
    in = send;
    CLOCK(1);
    return = out;
    rd_cs = 0;
    rd_en = 0;
    wr_cs = 0;
    wr_en = 0;
end
endtask

parameter FULL_CYCLE = 32'd10_000_000;

reg [7:0] test_value;

initial begin
    #10
    #10
	RESET;
    CLOCK(1);
    FIFO_PUSH(8'h11);
    FIFO_PUSH(8'h22);
    FIFO_PUSH(8'h33);
    FIFO_PUSH(8'h44);
    
    FIFO_POP(test_value, 8'h11);
    FIFO_POP(test_value, 8'h22);
    FIFO_POP(test_value, 8'h33);
    FIFO_POP(test_value, 8'h44);
    CLOCK(5);
    //FIFO_POP(test_value, 8'hXX);
    //CLOCK(5);

    FIFO_PUSH_POP(8'h66, test_value, 8'h66);
    FIFO_PUSH_POP(8'h77, test_value, 8'h77);
    FIFO_PUSH_POP(8'h88, test_value, 8'h88);
    FIFO_PUSH_POP(8'h99, test_value, 8'h99);

    if(underflow != 1)
    begin
        $display("underflow no work!"); 
    end

    FIFO_PUSH(8'h55);
    FIFO_PUSH(8'h66);
    FIFO_PUSH(8'h77);
    FIFO_PUSH(8'h88);
    //// should be full at this point, should not insert these.
    FIFO_PUSH(8'h99);
    FIFO_PUSH(8'hAA);
    FIFO_PUSH(8'hBB);
    FIFO_PUSH(8'hCC);
    //// will begin to pop values from fifo now.
    FIFO_POP(test_value, 8'h55);
    FIFO_POP(test_value, 8'h66);
    FIFO_POP(test_value, 8'h77);
    FIFO_POP(test_value, 8'h88);

    FIFO_PUSH(8'h99);
    FIFO_PUSH(8'hAA);
    FIFO_PUSH(8'hBB);
    FIFO_POP(test_value, 8'h99);
    FIFO_POP(test_value, 8'hAA);

    FIFO_PUSH(8'hCC);
    FIFO_PUSH(8'hDD);
    FIFO_PUSH(8'hEE);
    FIFO_POP(test_value, 8'hBB);
    FIFO_POP(test_value, 8'hCC);
    FIFO_POP(test_value, 8'hDD);
    FIFO_POP(test_value, 8'hEE);

    CLOCK(10);
    #10 $stop;
    #5 $finish;
end

endmodule