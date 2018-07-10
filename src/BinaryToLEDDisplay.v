`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 11/26/2017 03:10:27 PM
// Design Name:
// Module Name: BinaryToLEDDisplay
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


module BinaryToLEDDisplay(
	input wire  clk,
	input wire  rst,
	input wire  [15:0] value,
	output wire [15:0] leds
);

assign leds = value;

//always @(posedge clk or posedge rst) begin
//	if (rst) begin
////		leds = 0;
//	end
//end

endmodule
