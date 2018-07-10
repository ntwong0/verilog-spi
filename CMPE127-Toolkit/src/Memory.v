`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 02/20/2018 05:22:16 PM
// Design Name:
// Module Name: Memory
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

/*
module RAM #(
    parameter LENGTH = 32'h1000,
    parameter WIDTH = 32,
    parameter USE_FILE = 0,
    parameter FILE_NAME = "ram.mem"
)
(
    input wire clk,
    input wire we,
    input wire cs,
    input wire oe,
    input wire [ADDRESS_WIDTH-1:0] address,
    inout wire [WIDTH-1:0] data
);
// ==================================
//// Internal Parameter Field
// ==================================
parameter ADDRESS_WIDTH = $clog2(LENGTH);
// ==================================
//// Registers
// ==================================
reg [WIDTH-1:0] ram [0:LENGTH];
reg [WIDTH-1:0] data_out;
// ==================================
//// Wires
// ==================================
// ==================================
//// Wire Assignments
// ==================================
assign data = (cs && oe && !we) ? data_out : {(WIDTH){1'bz}};
// ==================================
//// Modules
// ==================================
// ==================================
//// Behavioral Block
// ==================================
integer i;
initial
begin
    if(USE_FILE)
    begin
        $readmemh(FILE_NAME, ram);
    end
    else
    begin
        data_out = {(WIDTH){ 1'b0 }};
		for (i=0; i<32; i=i+1)
        begin
			ram[i] = {(WIDTH){ 1'b0 }};
        end
    end
end
always @(posedge clk)
begin
    if (cs && we)
    begin
       ram[address] = data;
    end
    else if (cs && oe && !we)
    begin
        data_out = ram[address];
    end
end
endmodule
*/

module RAM #(
    parameter LENGTH = 32'h1000,
    parameter USE_FILE = 0,
    parameter WIDTH = 32,
    parameter MINIMUM_SECTIONAL_WIDTH = 8,
    parameter FILE_NAME = "ram.mem"
)
(
    input wire clk,
    input wire [BYTE_ENABLES-1:0] we,
    input wire cs,
    input wire oe,
    input wire [ADDRESS_WIDTH-1:0] address,
    inout wire [WIDTH-1:0] data
);

// ==================================
//// Internal Parameter Field
// ==================================
parameter ADDRESS_WIDTH = $clog2(LENGTH);
parameter BYTE_ENABLES = WIDTH/MINIMUM_SECTIONAL_WIDTH;
// ==================================
//// Registers
// ==================================
reg [WIDTH-1:0] ram [0:LENGTH];
reg [WIDTH-1:0] data_out;
// ==================================
//// Wires
// ==================================
// ==================================
//// Wire Assignments
// ==================================
assign data = (cs && oe && !we) ? data_out : {(WIDTH){1'bz}};
// ==================================
//// Modules
// ==================================
// ==================================
//// Behavioral Block
// ==================================
integer i;
initial
begin
    if(USE_FILE)
    begin
        $readmemh(FILE_NAME, ram);
    end
    else
    begin
        data_out = {(WIDTH){ 1'b0 }};
        memory_in = {(WIDTH){ 1'b0 }};
		for (i = 0; i < LENGTH; i = i+1)
        begin
			ram[i] = {(WIDTH){ 1'b0 }};
        end
    end
end

reg [WIDTH-1:0] memory_in; // wire reg
`define SECTION_RANGES (MINIMUM_SECTIONAL_WIDTH*(c+1))-1 : MINIMUM_SECTIONAL_WIDTH*c

genvar c;
generate
    for (c = 0; c < BYTE_ENABLES; c = c + 1) begin: test
        always @(*)
        begin
            if(we[c])
            begin
                memory_in[`SECTION_RANGES] = data[`SECTION_RANGES];
            end
            else
            begin
                memory_in[`SECTION_RANGES] = ram[address][`SECTION_RANGES];
            end
        end
    end
endgenerate

always @(posedge clk)
begin
    if (cs && |we)
    begin
       ram[address] = memory_in;
    end
    else if (cs && oe && !(|we))
    begin
        data_out = ram[address];
    end
end

endmodule

module ROM #(
    parameter LENGTH = 32'h1000,
    parameter WIDTH = 32,
    parameter FILE_NAME = "rom.mem"
)
(
	input wire [$clog2(LENGTH)-1:0] a,
	output wire [WIDTH-1:0] out
);

// ==================================
//// Internal Parameter Field
// ==================================
// ==================================
//// Wires
// ==================================
// ==================================
//// Wire Assignments
// ==================================
assign out = rom[a];
// ==================================
//// Modules
// ==================================
// ==================================
//// Registers
// ==================================
reg [WIDTH:0] rom[0:LENGTH];
// ==================================
//// Behavioral Block
// ==================================
//initialize rom from memfile_s.dat
initial
begin
    $readmemh(FILE_NAME, rom);
end

endmodule

module FIFO #(
    parameter LENGTH = 16,
    parameter WIDTH = 32
)
(
    input wire clk,
    input wire rst,
    input wire wr_cs,
    input wire wr_en,
    input wire rd_cs,
    input wire rd_en,
    output reg full,
    output reg empty,
    output reg [WIDTH-1:0] out,
    input wire [WIDTH-1:0] in
);
// ==================================
//// Internal Parameter Field
// ==================================
parameter ADDRESS_WIDTH = $clog2(LENGTH);
// ==================================
//// Registers
// ==================================
reg [ADDRESS_WIDTH-1:0] write_position;
reg [ADDRESS_WIDTH-1:0] read_position;
reg [ADDRESS_WIDTH:0] status_count;
reg [WIDTH-1:0] mem [0:LENGTH];
// ==================================
//// Wires
// ==================================
// ==================================
//// Wire Assignments
// ==================================
// assign full  = (status_count == (LENGTH));
// assign empty = (status_count == 0);
// ==================================
//// Modules
// ==================================
// ==================================
//// Behavioral Block
// ==================================
always @(posedge clk or posedge rst)
begin
    if(rst)
    begin
        write_position = 0;
        read_position = 0;
        status_count = 0;
        mem[write_position] = 0;
        write_position = 0;
        out = 0;
        full = 0;
        empty = 1;
    end
    else
    begin
        if(status_count == 0)
        begin
            empty = 1;
        end
        if(status_count == LENGTH)
        begin
            full = 1;
        end
        //// Enqueue data
        if (wr_cs && wr_en && !full)
        begin
            mem[write_position] = in;
            if(write_position == LENGTH-1)
            begin
                write_position = 0;
            end
            else
            begin
                write_position = write_position + 1;
            end
            status_count = status_count + 1;
            empty = 0;
        end
        //// Dequeue data
        if (rd_cs && rd_en && !empty)
        begin
            out = mem[read_position];
            if(read_position == LENGTH-1)
            begin
                read_position = 0;
            end
            else
            begin
                read_position = read_position + 1;
            end
            status_count = status_count - 1;
            full = 0;
        end
    end
end

endmodule

/* TODO: dis still a fifo!! */
module STACK #(
    parameter LENGTH = 16,
    parameter WIDTH = 8
)
(
    input wire clk,
    input wire rst,
    input wire wr_cs,
    input wire wr_en,
    input wire rd_cs,
    input wire rd_en,
    output reg full,
    output reg empty,
    output reg [WIDTH-1:0] out,
    input wire [WIDTH-1:0] in
);
// ==================================
//// Internal Parameter Field
// ==================================
parameter ADDRESS_WIDTH = $clog2(LENGTH);
// ==================================
//// Registers
// ==================================
reg [ADDRESS_WIDTH-1:0] write_position;
reg [ADDRESS_WIDTH-1:0] read_position;
reg [ADDRESS_WIDTH:0] status_count;
reg [WIDTH-1:0] mem [0:LENGTH];
// ==================================
//// Wires
// ==================================
// ==================================
//// Wire Assignments
// ==================================
// assign full  = (status_count == (LENGTH));
// assign empty = (status_count == 0);
// ==================================
//// Modules
// ==================================
// ==================================
//// Behavioral Block
// ==================================
always @(posedge clk or posedge rst)
begin
    if(rst)
    begin
        write_position = 0;
        read_position = 0;
        status_count = 0;
        mem[write_position] = 0;
        write_position = 0;
        full = 0;
        empty = 1;
    end
    else
    begin
        if(status_count == 0)
        begin
            empty = 1;
        end
        if(status_count == LENGTH)
        begin
            full = 1;
        end
        //// Enqueue data
        if (wr_cs && wr_en && !full)
        begin
            mem[write_position] = in;
            if(write_position == LENGTH-1)
            begin
                write_position = 0;
            end
            else
            begin
                write_position = write_position + 1;
            end
            status_count = status_count + 1;
            empty = 0;
        end
        //// Dequeue data
        if (rd_cs && rd_en && !empty)
        begin
            out = mem[read_position];
            if(read_position == LENGTH-1)
            begin
                read_position = 0;
            end
            else
            begin
                read_position = read_position + 1;
            end
            status_count = status_count - 1;
            full = 0;
        end
    end
end

endmodule

//////////////////////////////////
// Registers
//////////////////////////////////

module SHIFTREGISTER #(parameter WIDTH = 8)(
	input wire rst,
	input wire clk,
	input wire en,
	input wire in,
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
        Q <= { Q[WIDTH-2:0], in };
    end
end

endmodule

module REGISTER #(parameter WIDTH = 8)(
	input wire rst,
	input wire clk,
	input wire load,
	input wire [WIDTH-1:0] D,
	output reg [WIDTH-1:0] Q
);

always @(posedge clk or posedge rst)
begin
    if (rst)
    begin
    	Q <= 0;
    end
    else if(load)
    begin
        Q <= D;
    end
end

endmodule


module SHIFTLOADREG #(parameter WIDTH = 8)(
	input wire rst,
	input wire clk,
    input wire load,
	input wire en,
	input wire in,
    input wire [WIDTH-1:0] D,
	output reg [WIDTH-1:0] Q
);

always @(posedge clk or posedge rst)
begin
    if (rst)
    begin
    	Q <= 0;
    end
    else if(load)
    begin
        Q <= D;
    end
    else if(en)
    begin
        Q <= { Q[WIDTH-2:0], in };
    end
end

endmodule
