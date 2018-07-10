`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 12/03/2017 11:45:50 PM
// Design Name:
// Module Name: Test_AmbientLightSensor
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


module Test_AmbientLightSensor;

parameter FULL_CYCLE = 32'd16_000;

reg success_flag;

reg clk, rst;
wire [31:0] data;

reg  oe;
reg  trigger;
reg  sdata;
wire cs;
wire sclk;
wire done;

AmbientLightSensor U0(
    .clk(clk),
    .rst(rst),
    .oe(oe),
    .trigger(trigger),
    .sdata(sdata),
    .sclk(sclk),
    .cs(cs),
    .done(done),
    .data(data)
);

integer i;

task RESET;
begin
	success_flag = 1;
    rst = 0;
    oe  = 0;
    clk = 0;
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

// task CHECK_OUTPUT;
// 	input [2:0] select;
// 	input level;
// begin
// 	if(signal[select] != level)
// 	begin
// 		success_flag = 0;
// 		$display("!!ERROR!! @ %d signal[%d] = 0x%X !== 0x%X", $time, select, signal[select], level);
// 	end
// end
// endtask;

initial begin
    #10
    #10
	RESET;
	trigger = 1;
	sdata 	= 1;
    CLOCK(FULL_CYCLE/2);
	trigger = 0;
    CLOCK(FULL_CYCLE/2);
    oe = 1;
    CLOCK(FULL_CYCLE);

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

