`timescale 100ns / 1ps
`default_nettype none
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 11/26/2017 12:52:42 PM
// Design Name:
// Module Name: Test_ServoController
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


module Test_ServoController;

parameter SIGNAL_BIT_WIDTH  = 15;
parameter ADDRESS_BIT_WIDTH = 2;
parameter PWM_SIGNAL_COUNT  = 4;
parameter FULL_CYCLE 		= 32'd20_000;

reg success_flag;

reg clk, rst, cs;

reg [31:0] data_reg;
wire [31:0] data;
reg test_write_enable;

reg  [ADDRESS_BIT_WIDTH-1:0] addr;
wire  [PWM_SIGNAL_COUNT-1:0] signal;

ServoController servo(
    .clk(clk),
    .rst(rst),
    .cs(cs), // chip select
    .addr(addr[1:0]),
    .data(data[14:0]),
    .signal(signal)
);

assign data = (test_write_enable) ? data_reg : 32'bZ;

integer i;

task RESET;
begin
	success_flag = 1;
    rst = 0;
    clk = 0;
    cs = 0;
    test_write_enable = 0;
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

task CHECK_OUTPUT;
	input [2:0] select;
	input level;
begin
	if(signal[select] != level)
	begin
		success_flag = 0;
		$display("!!ERROR!! @ %d signal[%d] = 0x%X !== 0x%X", $time, select, signal[select], level);
	end
end
endtask;

task LOAD_COMPARE_VALUE; // task definition starts here
	input [31:0] select;
	input [31:0] value;
begin
	#1
	cs = 1;
	addr = select;
	test_write_enable = 1;
	data_reg = value;
	CLOCK(1);
	#1
	test_write_enable = 0;
	cs = 0;
	#1
	addr = 0;
end
endtask

initial begin
    #10
    #10
	RESET;
	LOAD_COMPARE_VALUE(2'b00, 32'd1000);
	CLOCK(FULL_CYCLE);
	CLOCK(500);
	CHECK_OUTPUT(2'b00, 1);
	CLOCK(505);
	CHECK_OUTPUT(2'b00, 0);
	CLOCK(500);
	CHECK_OUTPUT(2'b00, 0);
	CLOCK(FULL_CYCLE-1505);

	LOAD_COMPARE_VALUE(2'b00, 32'd1500);
    LOAD_COMPARE_VALUE(2'b01, 32'd1500);
	CLOCK(FULL_CYCLE);
	CLOCK(500);
	CHECK_OUTPUT(2'b00, 1);
	CHECK_OUTPUT(2'b01, 1);
	CLOCK(500);
	CHECK_OUTPUT(2'b00, 1);
	CHECK_OUTPUT(2'b01, 1);
	CLOCK(400);
	CHECK_OUTPUT(2'b00, 1);
	CHECK_OUTPUT(2'b01, 1);
	CLOCK(200);
	CHECK_OUTPUT(2'b00, 0);
	CHECK_OUTPUT(2'b01, 0);
	CLOCK(FULL_CYCLE-(500+500+400+200));

	LOAD_COMPARE_VALUE(2'b00, 32'd2500);
    LOAD_COMPARE_VALUE(2'b01, 32'd2500);
    LOAD_COMPARE_VALUE(2'b10, 32'd2500);
    LOAD_COMPARE_VALUE(2'b11, 32'd2500);
	CLOCK(FULL_CYCLE);
	CLOCK(FULL_CYCLE);
    LOAD_COMPARE_VALUE(2'b00, 32'd500);
    LOAD_COMPARE_VALUE(2'b01, 32'd1000);
    LOAD_COMPARE_VALUE(2'b10, 32'd1500);
    LOAD_COMPARE_VALUE(2'b11, 32'd2000);
    CLOCK(FULL_CYCLE);
    CLOCK(500);
	CHECK_OUTPUT(2'b00, 1);
	CHECK_OUTPUT(2'b01, 1);
	CHECK_OUTPUT(2'b10, 1);
	CHECK_OUTPUT(2'b11, 1);
	CLOCK(500);
	CHECK_OUTPUT(2'b00, 0);
	CHECK_OUTPUT(2'b01, 0);
	CHECK_OUTPUT(2'b10, 1);
	CHECK_OUTPUT(2'b11, 1);
	CLOCK(500);
	CHECK_OUTPUT(2'b00, 0);
	CHECK_OUTPUT(2'b01, 0);
	CHECK_OUTPUT(2'b10, 0);
	CHECK_OUTPUT(2'b11, 1);
	CLOCK(500);
	CHECK_OUTPUT(2'b00, 0);
	CHECK_OUTPUT(2'b01, 0);
	CHECK_OUTPUT(2'b10, 0);
	CHECK_OUTPUT(2'b11, 0);
	CLOCK(500);
	CHECK_OUTPUT(2'b00, 0);
	CHECK_OUTPUT(2'b01, 0);
	CHECK_OUTPUT(2'b10, 0);
	CHECK_OUTPUT(2'b11, 0);
	CLOCK(FULL_CYCLE-(500*5));

	// Print out Success/Failure message
	if (success_flag == 0) begin
		$display("*FAILED* TEST!");
	end
	else begin
		$display("**PASSED** TEST!");
	end

    #10 $stop;
    #5 $finish;
end

endmodule
