`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 11/28/2017 05:41:25 PM
// Design Name:
// Module Name: PWMCaptureTop
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


module PWMCaptureTop(
	input wire clk,
	input wire rst,
	input wire ext_pwm,
	input wire switch,
	input wire select,
	input wire trigger,
	input wire int_clr,
	input wire oe,
	output wire [15:0] leds
);

wire 		pwm;
wire 		int;
wire [31:0] data;

assign pwm 			= (select) ? ext_pwm : switch;
assign leds[14:0] 	= (oe) ? data[31:17] : 0;
assign leds[15] 	= int;

PWMCapture U0 (
    .clk(clk),
    .rst(rst),
    .oe(oe), 			// output enable
    .trigger(trigger), 	// start a capture
    .ext_pwm(pwm),		// external pwm signal
    .int_clr(int_clr),		// interrupt flag clear signal
    .int(int), 		// interrupt flag when capture event occurs
    .data(data)
);

endmodule