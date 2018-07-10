`timescale 1ns / 1ps
`default_nettype none
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 11/28/2017 01:25:09 AM
// Design Name:
// Module Name: Test_PWMCapture
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


module Test_PWMCapture;

reg success_flag;

reg clk, rst;
reg oe, clr;
reg ext_pwm;
reg trigger;
reg int_clr;
wire [31:0] data;
wire int;

integer i;

PWMCapture U0 (
    .clk(clk),
    .rst(rst),
    .oe(oe), 			// output enable
    .clr(clr), 		// clear
    .trigger(trigger), 	// start a capture
    .ext_pwm(ext_pwm),		// external pwm signal
    .int_clr(int_clr),		// interrupt flag clear signal
    .int(int), 		// interrupt flag when capture event occurs
    .data(data)
);

task STROBE_TRIGGER; // task definition starts here
begin
	trigger = 0;
	#1000
	trigger = 1;
    CLOCK(1);
	#1000
	trigger = 0;
end
endtask

task CHECK_OUTPUT;
	input [31:0] value;
begin
	oe = 1;
	#1000
	if(data != value)
	begin
		success_flag = 0;
		$display("!!ERROR!! @ %d 0x%X !== 0x%X", $time, data, value);
	end
	#1
	oe = 0;
end
endtask;

task CHECK_INTERRUPT;
	input bit_value;
begin
	#1
	if(int != bit_value)
	begin
		success_flag = 0;
		$display("!!ERROR!! @ %d INTERRUPT FLAG %d !== %d", $time, int, bit_value);
	end
	#1
	oe = 0;
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

initial
begin
	success_flag = 1;
    rst = 0;
    clk = 0;
    oe = 0;
    trigger = 0;
    #5
    rst = 1;
    #5
    rst = 0;
	#5

	ext_pwm = 0;
	STROBE_TRIGGER;
	ext_pwm = 1;
	CLOCK(1000);
	ext_pwm = 0;
	CLOCK(1);
    CHECK_OUTPUT(1000);
	CHECK_INTERRUPT(1);

	CLOCK(1000);

	ext_pwm = 0;
	STROBE_TRIGGER;
	CHECK_INTERRUPT(0);
	ext_pwm = 1;
	CLOCK(2000);
	CHECK_INTERRUPT(0);
	CLOCK(5000);
	ext_pwm = 0;
	CLOCK(1);
	CHECK_OUTPUT(7000);
	CHECK_INTERRUPT(1);

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
