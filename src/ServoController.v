`timescale 1ns / 1ps
`default_nettype none
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 11/25/2017 05:41:12 PM
// Design Name:
// Module Name: ServoController
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

module ServoController #(
    parameter SIGNAL_BIT_WIDTH  = 16,
    parameter ADDRESS_BIT_WIDTH = 2,
    parameter PWM_SIGNAL_COUNT  = 4
)
(
    input wire clk,
    input wire rst,
    input wire cs, // chip select
    input wire  [ADDRESS_BIT_WIDTH-1:0] addr,
    input wire  [SIGNAL_BIT_WIDTH-1:0]  data,
    output wire [PWM_SIGNAL_COUNT-1:0]  signal
);
// ==================================
//// Registers
// ==================================
// ==================================
//// Wires
// ==================================
wire [PWM_SIGNAL_COUNT-1:0] load_select;
// ==================================
//// Wire Assignments
// ==================================
assign load_select[0]  = (addr == 2'b00 && cs) ? 1 : 0;
assign load_select[1]  = (addr == 2'b01 && cs) ? 1 : 0;
assign load_select[2]  = (addr == 2'b10 && cs) ? 1 : 0;
assign load_select[3]  = (addr == 2'b11 && cs) ? 1 : 0;
// ==================================
//// Modules
// ==================================
ServoModule U0(
    .clk(clk),
    .rst(rst),
    .load(load_select[0]),
    .data(data),
    .signal(signal[0])
);
ServoModule U1(
    .clk(clk),
    .rst(rst),
    .load(load_select[1]),
    .data(data),
    .signal(signal[1])
);
ServoModule U2(
    .clk(clk),
    .rst(rst),
    .load(load_select[2]),
    .data(data),
    .signal(signal[2])
);
ServoModule U3(
    .clk(clk),
    .rst(rst),
    .load(load_select[3]),
    .data(data),
    .signal(signal[3])
);
// ==================================
//// Behavioral Block
// ==================================
endmodule