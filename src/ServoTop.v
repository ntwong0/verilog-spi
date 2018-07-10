`timescale 1ns / 1ps
`default_nettype none
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 11/26/2017 08:22:01 PM
// Design Name:
// Module Name: ServoTop
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


module ServoTop(
	input wire clk,
	input wire rst,
	output wire [3:0] signal
);

wire [31:0] data;

reg cs;
reg [1:0] addr;
reg [15:0] data_reg;

assign data = (cs) ? data_reg : 0;

ServoController servo(
    .clk(clk),
    .rst(rst),
    .cs(cs), // chip select
    .addr(addr[1:0]),
    .data(data[15:0]),
    .signal(signal)
);

reg [2:0] init;

always @(posedge clk or posedge rst) begin
	if (rst)
	begin
		init = 0;
		cs = 1;
	end
	else if(init < 3'b100)
	begin
		addr = init;
		case(addr)
			3'b000: begin
				data_reg = 32'd500;
			end
			3'b001: begin
				data_reg = 32'd1000;
			end
			3'b010: begin
				data_reg = 32'd1500;
			end
			3'b011: begin
				data_reg = 32'd2000;
			end
		endcase
		init = init + 1;
	end
	else begin
		cs = 0;
	end
end

endmodule
