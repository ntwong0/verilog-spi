`timescale 1ns / 1ps
`default_nettype none
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 11/26/2017 12:52:42 PM
// Design Name:
// Module Name: Test_QuadratureDecoder
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


module Test_QuadratureDecoder;

reg success_flag;

reg clk, rst;
reg oe, we;
reg ext_phase_a, ext_phase_b;
reg [31:0] data_reg;
reg test_write_enable;
wire [31:0] data;

QuadratureDecoder U0 (
    .clk(clk),
    .rst(rst),
    .oe(oe),
    .we(we),
    .ext_phase_a(ext_phase_a),
    .ext_phase_b(ext_phase_b),
    .data(data)
);

assign data = (test_write_enable) ? data_reg : 32'bZ;

integer i;

task CLOCK;
begin
	#1
	clk = 0;
	#1
	clk = 1;
    #1
    clk = 0;
end
endtask

task QUADRATURE_ENCODER_STEP; // task definition starts here
	input [31:0] distance;
	input direction;
	integer k;
begin
	oe = 0;
	we = 0;
	#1
	ext_phase_b = direction;
	ext_phase_a = 0;
	#1
	for (k=0; k < distance-1; k = k +1)
	begin
	   #1
		ext_phase_a = ~ext_phase_a;
		CLOCK;
		ext_phase_b = ~ext_phase_b;
		CLOCK;
	end
end
endtask

task STROBE_OUTPUT_ENABLE; // task definition starts here
begin
	oe = 0;
	#1000
	oe = 1;
	#1000
	oe = 0;
end
endtask

task CHECK_OUTPUT;
	input [31:0] value;
begin
	oe = 1;
	#1000
	if(data != value)
	begin
		success_flag = 0;
		$display("!!ERROR!! @ %d 0x%X !== 0x%X", $time, data, value);
	end
	#1
	oe = 0;
end
endtask;

task LOAD_QUADRATURE_ENCODER; // task definition starts here
	input [31:0] value;
begin
	#1000
	data_reg = value;
	test_write_enable = 1;
	we = 1;
	CLOCK;
	we = 0;
	test_write_enable = 0;
end
endtask

initial begin
	success_flag = 1;
    rst = 0;
    clk = 0;
    oe = 0;
    we = 0;
    test_write_enable = 0;
    #5
    rst = 1;
    #5
    rst = 0;
	#5
	//// Increment quadrature encoder to FF
	QUADRATURE_ENCODER_STEP(32'hFF, 1);
	//// Test that the quad decoder incremented to FF
	CHECK_OUTPUT(32'hFE);
	//// Decrement quadrature encoder to 0
	QUADRATURE_ENCODER_STEP(32'hFF, 0);
	//// Test that the quad decoder decremented to 0
	CHECK_OUTPUT(32'h0);
	//// Load 0xABCD into encoder
	LOAD_QUADRATURE_ENCODER(32'hABCD);
	//// Check that load 0xABCD was successful
	CHECK_OUTPUT(32'hABCD);
	//// Load 0
	LOAD_QUADRATURE_ENCODER(32'h0);
	//// Decrement to get underflow
	QUADRATURE_ENCODER_STEP(32'h2, 0);
	//// Check that underflow was successful
	CHECK_OUTPUT(32'hFFFFFFFF);

	// Print out Success/Failure message
	if (success_flag == 0) begin
		$display("*FAILED* TEST!");
	end
	else begin
		$display("**PASSED** TEST!");
	end

    #10 $stop;
    #5 $finish;
end

endmodule
