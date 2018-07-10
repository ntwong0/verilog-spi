`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/20/2018 07:26:06 PM
// Design Name: 
// Module Name: Test_Keyboard
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


module Test_Keyboard;

reg clk;
reg rst;
reg clr;
reg ps2_clk;
reg ps2_data;

wire [7:0] data;
wire cs;
wire ready;

assign cs = 1;

Keyboard keyboard(
    .clk(clk),
    .rst(rst),
    .ps2_clk(ps2_clk),
    .ps2_data(ps2_data),
    .data(data),
    .cs(cs),
    .clr(clr),
    .ready(ready)
);

task RESET;
begin
    rst = 0;
    clk = 0;
    ps2_clk = 0;
    ps2_data = 0;
    clr = 0;
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

reg [10:0] payload;

task PS2_TRANSMIT;
	input [7:0] send;
	integer k;
begin
    
    payload = {1'b1, ~^send, send[7], send[6], send[5], send[4], send[3], send[2], send[1], send[0], 1'b0};
    $display("payload = 0b%b",payload);
	for (k=0; k < 11; k = k + 1)
	begin
        ps2_data = payload[k];
        ps2_clk = 1;
        $display("payload = 0b%b :: send = 0b%b :: ps2_data = 0b%b :: k = %d", payload, send, ps2_data, k);
        CLOCK(1);
        ps2_clk = 0;
        CLOCK(1);
	end
    ps2_clk = 1;
    CLOCK(1);
end
endtask

parameter FULL_CYCLE = 32'd10_000_000;

initial begin
    #10
    #10
	RESET;
    PS2_TRANSMIT(8'h1C);
    CLOCK(10);
    #10 $stop;
    #5 $finish;
end

endmodule