`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 11/25/2017 06:51:05 PM
// Design Name:
// Module Name: Test_Motherboard
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

module Test_Motherboard;
reg success_flag;
reg rst, clk;

initial begin
	success_flag = 1;
    rst = 0;
    clk = 0;
    #5
    rst = 1;
    #5
    rst = 0;
	#5
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