`timescale 1ns / 1ps
`default_nettype none
 
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 12/06/2017 09:00:36 PM
// Design Name:
// Module Name: GlueLogic
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

//////////////////////////////////
// Buffers
//////////////////////////////////

module NOT #(parameter WIDTH = 1)(
	input wire [WIDTH-1:0] in,
	output wire [WIDTH-1:0] out
);

assign out = ~in;

endmodule

module TRIBUFFER #(parameter WIDTH = 1)(
	input wire oe,
	input wire [WIDTH-1:0] in,
	output wire [WIDTH-1:0] out
);

assign out = (oe) ? in : {(WIDTH){1'bZ}};

endmodule

//////////////////////////////////
// Non-Inverting Logic Functions
//////////////////////////////////

module AND #(parameter WIDTH = 2)(
	input wire [WIDTH-1:0] in,
	output wire out
);

assign out = &in;

endmodule

module OR #(parameter WIDTH = 2)(
	input wire [WIDTH-1:0] in,
	output wire out
);

assign out = |in;

endmodule

module XOR #(parameter WIDTH = 2)(
	input wire [WIDTH-1:0] in,
	output wire out
);

assign out = ^in;

endmodule

//////////////////////////////////
// Inverting Logic Functions
//////////////////////////////////

module NAND #(parameter WIDTH = 2)(
	input wire [WIDTH-1:0] in,
	output wire out
);

assign out = ~&in;

endmodule

module NOR #(parameter WIDTH = 2)(
	input wire [WIDTH-1:0] in,
	output wire out
);

assign out = ~|in;

endmodule

module XNOR #(parameter WIDTH = 2)(
	input wire [WIDTH-1:0] in,
	output wire out
);

assign out = ~^in;

endmodule

//////////////////////////////////
// Multiplex - Demultiplex
//////////////////////////////////

module MUX #(
    parameter WIDTH  = 1,
    parameter INPUTS = 2
)(
    input wire [$clog2(INPUTS)-1:0] select,
    input wire [(WIDTH*INPUTS)-1:0] in,
    output wire [WIDTH-1:0] out
);

assign out = (in >> (select*WIDTH));

endmodule

//////////////////////////////////
// Encoder - Decoder
//////////////////////////////////

module DECODER #(parameter INPUT_WIDTH = 4)
(
	input wire enable,
	input wire [INPUT_WIDTH-1:0] in,
	output wire [(2 ** INPUT_WIDTH)-1:0] out
);

assign out = (enable) ? (1 << in) : 0;

endmodule

module ENCODER #(parameter OUTPUT_WIDTH = 4)
(
	input wire enable,
	input wire [(2^OUTPUT_WIDTH)-1:0] in,
	output reg [OUTPUT_WIDTH-1:0] out
);

integer i;

always @(*)
begin
	if(enable)
	begin
		for (i = (2^OUTPUT_WIDTH)-1; i >= 0; i = i - 1)
		begin
			if(in[i] == 1)
			begin
				out <= i;
			end
		end
	end
	else
	begin
		out = 0;
	end
end

endmodule


//////////////////////////////////
// Latches
//////////////////////////////////

module RSLATCH (
	input wire rst,
	input wire R,
	input wire S,
	output wire Q,
	output wire nQ
);

NOR set (
	.in({ S, Q }),
	.out(nQ)
);

NOR reset (
	.in({ R, nQ }),
	.out(Q)
);

endmodule

module DLATCH #(parameter WIDTH = 1)(
	input wire rst,
	input wire C,
	input wire [WIDTH-1:0] D,
	output reg [WIDTH-1:0] Q
);

always @(*)
begin
    if (rst)
    begin
    	Q <= 0;
    end
    else if (C)
    begin
        Q <= D;
    end
end

endmodule

module TRIDLATCH #(parameter WIDTH = 1)(
	input wire rst,
	input wire C,
	input wire oe,
	input wire [WIDTH-1:0] D,
	output reg [WIDTH-1:0] Q
);

wire Q_int;

assign Q_int = (oe) ? Q : 'bZ;

DLATCH #(WIDTH) U0 (
	.rst(rst),
	.C(C),
	.D(D),
	.Q(Q)
);

endmodule

//////////////////////////////////
// Flip Flops
//////////////////////////////////

module DFLIPFLOP #(parameter WIDTH = 1)(
	input wire clk,
	input wire rst,
	input wire [WIDTH-1:0] D,
	output reg [WIDTH-1:0] Q
);

always @(posedge clk or posedge rst)
begin
    if (rst)
    begin
    	Q <= 0;
    end
    else
    begin
        Q <= D;
    end
end

endmodule

//////////////////////////////////
// COUNTERS
//////////////////////////////////

module COUNTER #(parameter WIDTH = 4)(
	input wire rst,
	input wire clk,
	input wire load,
	input wire increment,
	input wire enable,
	input wire [WIDTH-1:0] D,
	output reg [WIDTH-1:0] Q
);

always @(posedge clk or posedge rst)
begin
    if (rst)
    begin
    	Q <= 0;
    end
    else if(load && enable)
    begin
        Q <= D;
    end
    else if(enable)
    begin
    	if(increment)
    	begin
	        Q <= Q + 1;
    	end
    	else begin
    		Q <= Q - 1;
    	end
    end
end

endmodule

//////////////////////////////////
// External Signal Syncronizer
//////////////////////////////////

module Syncronizer #(
	parameter WIDTH = 1,
	parameter DEFAULT_DISABLED = 0
)
(
	input wire clk,
	input wire rst,
	input wire en,
	input wire [WIDTH-1:0] in,
	output reg [WIDTH-1:0] sync_out
);

always@(posedge clk)
begin
	if(en)
	begin
		sync_out = in;
	end
	else
	begin
		sync_out = DEFAULT_DISABLED;
	end
end

endmodule