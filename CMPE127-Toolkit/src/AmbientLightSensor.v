`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 12/03/2017 03:48:25 PM
// Design Name:
// Module Name: AmbientLightSensor
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

module AmbientLightSensorDemo(
	input wire clk,
	input wire rst,
	input wire oe,
	input wire trigger,
	input wire sdata,
	output wire cs,
	output wire sclk,
	output wire done
);

wire [31:0] data;
wire not_oe;
wire not_trigger;

assign not_oe = ~oe;
assign not_trigger = ~trigger;

AmbientLightSensor U0(
    .clk(clk),
    .rst(rst),
    .oe(not_oe),
    .trigger(not_trigger),
    .sdata(sdata),
    .sclk(sclk),
    .cs(cs),
    .done(done),
    .data(data)
);

endmodule

module AmbientLightSensor(
    input wire clk,
    input wire rst,
    input wire oe, 			// output enable
    input wire trigger, 	// trigger/start ADC conversion
    input wire sdata,		// ADC serial data output
    output reg sclk,		// ADC serial clock driver
    output reg cs,			// ADC chip select
    output reg done, 		// done flag when ADC conversion and serial transfer has completed
    inout wire [7:0] data
);
// ==================================
//// Internal Parameter Field
// ==================================
parameter IDLE 			= 0;
parameter ACQUIRE_DATA 	= 1;
parameter CLOCK_WAIT 	= 2;
parameter LATCH_DATA 	= 3;
parameter CLOCK_DIVIDER	= 500; // 10Mhz -> 100Khz
// ==================================
//// Registers
// ==================================
reg [15:0] out;
reg [15:0] shift_in;
reg [ 3:0] counter;
reg [ 3:0] clk_counter;
reg [ 1:0] state;
// ==================================
//// Wires
// ==================================
// ==================================
//// Wire Assignments
// ==================================
assign data       = oe ? out[7:0] : 8'bz;
// ==================================
//// Modules
// ==================================
// ==================================
//// Behavioral Block
// ==================================
always @(posedge clk or posedge rst)
begin
    if (rst)
    begin
    	out 		= 0;
        counter 	= 0;
        state 		= IDLE;
        clk_counter = 0;
        done 		= 0;
        sclk        = 0;
        shift_in    = 0;
    end
    else
    begin
        case(state)
        	IDLE:
        	begin
        		if(trigger)
        		begin
        			counter = 0;
			        done    = 0;
			        cs 		= 0;
			        state   = ACQUIRE_DATA;
        		end
        	end
        	ACQUIRE_DATA:
        	begin
        		if(counter == 16)
        		begin
        			state 		= LATCH_DATA;
        		end
        		else begin
        		    counter = counter + 1;
	        		clk_counter = 0;
	        		shift_in 	= { shift_in[14:1], sdata };
	        		state 		= CLOCK_WAIT;
        		end
        	end
        	CLOCK_WAIT:
        	begin
        		if(clk_counter >= CLOCK_DIVIDER*2)
        		begin
        			state = ACQUIRE_DATA;
        		end
        		else if(clk_counter >= CLOCK_DIVIDER)
        		begin
        			sclk = 1;
        		end
        		else begin
        			sclk = 0;
        		end
        		clk_counter = clk_counter + 1;
        	end
        	LATCH_DATA:
    		begin
		        cs 		= 0;
		        done 	= 1;
		        out 	= shift_in;
		        state 	= IDLE;
    		end
        endcase
    end
end
endmodule
