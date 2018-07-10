`timescale 1ns / 1ps

`define BREAK_CODE              8'hF0
`define SHIFT_CODE_LEFT         8'h12        
`define SHIFT_CODE_RIGHT        8'h59
`define A_SCAN_CODE             8'h1C
`define B_SCAN_CODE             8'h32
`define C_SCAN_CODE             8'h21
`define D_SCAN_CODE             8'h23
`define E_SCAN_CODE             8'h24
`define NEWLINE_SCAN_CODE       8'h5A
`define BACKSPACE_SCAN_CODE     8'h66

//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/10/2018 04:15:49 PM
// Design Name: 
// Module Name: TestMotherboard
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

module TestMotherboard;

integer clock_count;
reg clk;
reg rst;
reg ps2_clk;
reg ps2_data;

wire hsync;
wire vsync;
wire [3:0] r;
wire [3:0] g;
wire [3:0] b;

Motherboard #(.CLOCK_DIVIDER(1)) motherboard(
	//// input 100 MHz clock
    .clk100Mhz(clk),
    .rst(rst),
    .ps2_clk(ps2_clk),
    .ps2_data(ps2_data),
    //// Horizontal sync pulse for VGA controller
    .hsync(hsync),
    //// Vertical sync pulse for VGA controller
    .vsync(vsync),
    //// RGB 4-bit singal that go to a DAC (range 0V <-> 0.7V) to generate a color intensity
    .r(r),
    .g(g),
    .b(b),
    .clk_select(1'b1),
    .button_clock(1'b1)
);

reg [10:0] payload;

task PS2_TRANSMIT;
	input [7:0] send;
	integer k;
begin
    
    payload = {1'b1, ~^send, send[7], send[6], send[5], send[4], send[3], send[2], send[1], send[0], 1'b0};
    $display("payload = 0b%b",payload);
	for (k=0; k < 11; k = k + 1)
	begin
        CLOCK(2);
        ps2_data = payload[k];
        ps2_clk = 1;
        $display("payload = 0b%b :: send = 0b%b :: ps2_data = 0b%b :: k = %d", payload, send, ps2_data, k);
        CLOCK(2);
        ps2_clk = 0;
        CLOCK(2);
	end
    ps2_clk = 1;
    CLOCK(2);
end
endtask

task RESET;
begin
    rst = 0;
    clock_count = 0;
    clk = 0;
    ps2_clk = 1;
    ps2_data = 1;
    #5
    rst = 1;
    #5
    rst = 0;
    clk = 0;
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
		clock_count = clock_count + 1;
		#5
		clk = 0;
	end
end
endtask

parameter FULL_CYCLE = 32'd5000;

initial begin
    #10
    #10
	RESET;
	CLOCK(FULL_CYCLE);
    //// Send a A code
    PS2_TRANSMIT(`A_SCAN_CODE);
    CLOCK(10);
    PS2_TRANSMIT(`BREAK_CODE);
    CLOCK(10);
    PS2_TRANSMIT(`A_SCAN_CODE);
    //// Send a B code
    PS2_TRANSMIT(`B_SCAN_CODE);
    CLOCK(10);
    PS2_TRANSMIT(`BREAK_CODE);
    CLOCK(10);
    PS2_TRANSMIT(`B_SCAN_CODE);
    //// Send a C code
    PS2_TRANSMIT(`C_SCAN_CODE);
    CLOCK(10);
    PS2_TRANSMIT(`BREAK_CODE);
    CLOCK(10);
    PS2_TRANSMIT(`C_SCAN_CODE);
    //// Send a D code
    PS2_TRANSMIT(`D_SCAN_CODE);
    CLOCK(10);
    PS2_TRANSMIT(`BREAK_CODE);
    CLOCK(10);
    PS2_TRANSMIT(`D_SCAN_CODE);
    //// Send a Backspace code
    PS2_TRANSMIT(`BACKSPACE_SCAN_CODE);
    CLOCK(10);
    PS2_TRANSMIT(`BREAK_CODE);
    CLOCK(10);
    PS2_TRANSMIT(`BACKSPACE_SCAN_CODE);
    //// Send a D code
    PS2_TRANSMIT(`E_SCAN_CODE);
    CLOCK(10);
    PS2_TRANSMIT(`BREAK_CODE);
    CLOCK(10);
    PS2_TRANSMIT(`E_SCAN_CODE);
    //// Send a Backspace Code
    PS2_TRANSMIT(`BACKSPACE_SCAN_CODE);
    CLOCK(10);
    PS2_TRANSMIT(`BREAK_CODE);
    CLOCK(10);
    PS2_TRANSMIT(`BACKSPACE_SCAN_CODE);
    //// Send a Backspace Code
    PS2_TRANSMIT(`BACKSPACE_SCAN_CODE);
    CLOCK(10);
    PS2_TRANSMIT(`BREAK_CODE);
    CLOCK(10);
    PS2_TRANSMIT(`BACKSPACE_SCAN_CODE);
    //// Send a Newline Code
    PS2_TRANSMIT(`NEWLINE_SCAN_CODE);
    CLOCK(10);
    PS2_TRANSMIT(`BREAK_CODE);
    CLOCK(10);
    PS2_TRANSMIT(`NEWLINE_SCAN_CODE);
    CLOCK(20);
    //// Rest of the program should run after this.
	CLOCK(FULL_CYCLE);
    #10 $stop;
    #5 $finish;
end

endmodule