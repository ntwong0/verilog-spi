`timescale 1ns / 1ps

`define BREAK_CODE              8'hF0
`define SHIFT_CODE_LEFT         8'h12        
`define SHIFT_CODE_RIGHT        8'h59
`define A_SCAN_CODE             8'h1C
`define B_SCAN_CODE             8'h32
`define BACKSPACE_SCAN_CODE     8'h66
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


module Test_VGA_Keyboard;

reg clk, rst;
reg ps2_clk, ps2_data;
wire ready, hsync, vsync;
wire [3:0] r, g, b;
reg [63:0] counter;

Keyboard_DEMO demo(
    .clk(clk),
    .rst(rst),
    .ps2_clk(ps2_clk),
    .ps2_data(ps2_data),
    .ready(ready),
    .hsync(hsync),
    .vsync(vsync),
    .r(r),
    .g(g),
    .b(b)
);

task RESET;
begin
    rst = 0;
    clk = 0;
    ps2_clk = 1;
    ps2_data = 1;
    counter = 0;
    #5
    rst = 1;
    #5
    rst = 0;
end
endtask

task CLOCK;
	input [63:0] count;
	integer k;
begin
	for (k=0; k < count; k = k+1)
	begin
		#5
		clk = 1;
		#5
		clk = 0;
		counter = counter + 1;
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

parameter LOAD_RAM = 32'd2400;
parameter FULL_CYCLE = 32'd1_555_738;

initial begin
    #10
    #10
	RESET;
    CLOCK(LOAD_RAM);
    //// pressing A key
    CLOCK(5);
    PS2_TRANSMIT(`A_SCAN_CODE);
    CLOCK(10);
    PS2_TRANSMIT(`BREAK_CODE);
    CLOCK(10);
    PS2_TRANSMIT(`A_SCAN_CODE);
    CLOCK(10);
    //// press shift key
    PS2_TRANSMIT(`SHIFT_CODE_LEFT);
    CLOCK(10);
    //// press lowercase a key
    PS2_TRANSMIT(`A_SCAN_CODE);
    CLOCK(10);
    PS2_TRANSMIT(`BREAK_CODE);
    CLOCK(10);
    PS2_TRANSMIT(`A_SCAN_CODE);
    CLOCK(10);
    PS2_TRANSMIT(`BREAK_CODE);
    CLOCK(10);
    PS2_TRANSMIT(`SHIFT_CODE_LEFT);
    CLOCK(10);
    //// press B scancode
    PS2_TRANSMIT(`B_SCAN_CODE);
    CLOCK(10);
    PS2_TRANSMIT(`BREAK_CODE);
    CLOCK(10);
    PS2_TRANSMIT(`B_SCAN_CODE);
    CLOCK(10);
    //// press C scancode
    PS2_TRANSMIT(8'h21);
    CLOCK(10);
    PS2_TRANSMIT(`BREAK_CODE);
    CLOCK(10);
    PS2_TRANSMIT(8'h21);
    CLOCK(10);
    //// press backspace
    PS2_TRANSMIT(8'h66);
    CLOCK(10);
    CLOCK(FULL_CYCLE);
    PS2_TRANSMIT(8'h21);
    CLOCK(10);
    PS2_TRANSMIT(`BREAK_CODE);
    CLOCK(10);
    PS2_TRANSMIT(8'h21);
    CLOCK(10);
    CLOCK(FULL_CYCLE);
    #10 $stop;
    #5 $finish;
end

endmodule
