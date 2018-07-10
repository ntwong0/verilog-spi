`timescale 1ns / 1ps
`default_nettype none
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 11/25/2017 05:41:12 PM
// Design Name:
// Module Name: QuadratureDecoder
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


module QuadratureDecoder #(
  parameter BUS_WIDTH = 32
)(
    input wire clk,
    input wire rst,
    input wire oe, // output enable
    input wire we, // write enable
    input wire ext_phase_a,
    input wire ext_phase_b,
    output wire direction,
    inout wire [BUS_WIDTH-1:0] data
);
// ==================================
//// Internal Parameter Field
// ==================================
// parameter param = 0;
// ==================================
//// Registers
// ==================================
reg [BUS_WIDTH-1:0] counter;
reg phase_a_prev;
// ==================================
//// Wires
// ==================================
//wire direction;
wire phase_a;
wire phase_b;
// ==================================
//// Wire Assignments
// ==================================
assign direction  = phase_a ~^ phase_b;
assign data       = oe ? counter : 32'bz;
// ==================================
//// Modules
// ==================================
ExtToIntSync U0(
    .clk(clk),
    .rst(rst),
    .ext_signal(ext_phase_a),
    .int_signal(phase_a)
);
ExtToIntSync U1(
    .clk(clk),
    .rst(rst),
    .ext_signal(ext_phase_b),
    .int_signal(phase_b)
);
// ==================================
//// Behavioral Block
// ==================================
always @(posedge clk or posedge rst) begin
    if (rst) begin
        counter = 32'h0;
        phase_a_prev = 0;
    end
    else if(we && !oe) begin
        counter = data;
    end
    else if(phase_a_prev != phase_a) begin
        if(direction == 0)
        begin
            counter = counter - 1;
        end
        if(direction == 1)
        begin
            counter = counter + 1;
        end
        phase_a_prev = phase_a;
    end
end

endmodule

module QuadratureTop(
	input wire clk,
	input wire rst,
	input wire ext_phase_a,
	input wire ext_phase_b,
	input wire off_led,
	input wire output_enable,
	output wire [15:0] leds
);

wire [31:0] data;
wire oe;
wire we;

assign oe = output_enable;
assign we = 0;
assign leds[14:0] = (oe && off_led) ? data[14:0] : 0;

QuadratureDecoder U0 (
    .clk(clk),
    .rst(rst),
    .oe(oe),
    .we(we),
    .ext_phase_a(ext_phase_a),
    .ext_phase_b(ext_phase_b),
    .direction(leds[15]),
    .data(data)
);

endmodule