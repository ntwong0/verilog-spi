`timescale 1ns / 1ps
`default_nettype none
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/13/2015 09:25:44 AM
// Design Name: 
// Module Name: ExtToIntSync
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


module ExtToIntSync(
	input wire clk,
	input wire rst,
	input wire ext_signal,
	output reg int_signal
);

always @(posedge clk or posedge rst) begin
	if (rst) begin
		int_signal = 0;
	end
	else begin
		int_signal = ext_signal;
	end
end

endmodule
