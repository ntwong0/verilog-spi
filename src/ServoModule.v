`timescale 1ns / 1ps
`default_nettype none
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 11/25/2017 06:31:21 PM
// Design Name:
// Module Name: ServoModule
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

module ServoModule(
	input wire clk,
	input wire rst,
	input wire load,
	input wire [15:0] data,
	output reg signal
);
// ==================================
//// Internal Parameter Field
// ==================================
parameter MAX_COUNT    = 20000*100;
//// Bits required to reach 2,000,000
parameter COUNT_WIDTH  = 32;
// ==================================
//// Registers
// ==================================
reg  [COUNT_WIDTH-1:0] counter;
reg  [COUNT_WIDTH-1:0] compare_value;
reg  [COUNT_WIDTH-1:0] tmp_compare_value;
// ==================================
//// Wires
// ==================================
// wire [PWM_SIGNAL_COUNT-1:0] select;
// ==================================
//// Wire Assignments
// ==================================
// assign select[0]  = (2'b00) ? 1 : 0;
// ==================================
//// Modules
// ==================================
// ==================================
//// Behavioral Block
// ==================================
always @(posedge clk or
		 posedge rst) begin
    if (rst) begin
        counter = 0;
        compare_value = 0;
        tmp_compare_value = 0;
    end
    else if(load) begin
        tmp_compare_value = data;
    end
    else begin
        if(counter > MAX_COUNT) begin
        	compare_value = tmp_compare_value;
	        counter = 0;
        	signal = 1;
        end
        if(counter >= compare_value*100) begin
        	signal = 0;
        end
	    counter = counter + 1;
    end
end

endmodule