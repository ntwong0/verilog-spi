`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/21/2018 10:55:26 AM
// Design Name: 
// Module Name: Test_GlueLogic
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


module Test_GlueLogic;

`define INPUT_SIZE 4

reg [`INPUT_SIZE-1:0] inputs;
reg tribuffer_oe;
reg success_flag;
reg rst;
reg clk;

wire [`INPUT_SIZE-1:0] not_output;
wire [`INPUT_SIZE-1:0] tribuffer_output;
wire and_output;
wire or_output;
wire xor_output;
wire nand_output;
wire nor_output;
wire xnor_output;

NOT #(.WIDTH(`INPUT_SIZE)) not_GATE
(
	.in(inputs),
	.out(not_output)
);

task TEST_NOT;
begin
	#5
    inputs = `INPUT_SIZE'b1010;
    #5
    if(not_output != `INPUT_SIZE'b0101)
    begin
        success_flag = 0;
        #10 $stop;
        $display("!!ERROR!! @ %d", $time);
    end
	#5
    inputs = `INPUT_SIZE'b0101;
    #5
    if(not_output != `INPUT_SIZE'b1010)
    begin
        success_flag = 0;
        #10 $stop;
        $display("!!ERROR!! @ %d", $time);
    end
end
endtask

TRIBUFFER #(.WIDTH(`INPUT_SIZE)) tribuffer
(
	.oe(tribuffer_oe),
	.in(inputs),
	.out(tribuffer_output)
);

task TEST_TRIBUFFER;
begin
	#5
    tribuffer_oe = 1;
    inputs = `INPUT_SIZE'b1010;
    #5
    if(tribuffer_output != `INPUT_SIZE'b1010)
    begin
        success_flag = 0;
        #10 $stop;
        $display("!!ERROR!! @ %d", $time);
    end
	#5
    tribuffer_oe = 1;
    inputs = `INPUT_SIZE'b0101;
    #5
    if(tribuffer_output != `INPUT_SIZE'b0101)
    begin
        success_flag = 0;
        #10 $stop;
        $display("!!ERROR!! @ %d", $time);
    end
	#5
    tribuffer_oe = 0;
    inputs = `INPUT_SIZE'b10101;
    #5
    if(tribuffer_output != `INPUT_SIZE'bZ)
    begin
        success_flag = 0;
        #10 $stop;
        $display("!!ERROR!! @ %d", $time);
    end
end
endtask

//////////////////////////////////
// Non-Inverting Logic Functions
//////////////////////////////////

AND #(.WIDTH(`INPUT_SIZE)) and_gate
(
	.in(inputs),
	.out(and_output)
);

task TEST_AND;
begin
	#5
    inputs = `INPUT_SIZE'b0000;
    #5
    if(and_output != 1'b0)
    begin
        success_flag = 0;
        #10 $stop;
        $display("!!ERROR!! @ %d", $time);
    end

	#5
    inputs = `INPUT_SIZE'b1010;
    #5
    if(and_output != 1'b0)
    begin
        success_flag = 0;
        #10 $stop;
        $display("!!ERROR!! @ %d", $time);
    end

	#5
    inputs = `INPUT_SIZE'b1111;
    #5
    if(and_output != 1'b1)
    begin
        success_flag = 0;
        #10 $stop;
        $display("!!ERROR!! @ %d", $time);
    end
end
endtask

OR #(.WIDTH(`INPUT_SIZE)) or_gate
(
	.in(inputs),
	.out(or_output)
);

task TEST_OR;
begin
	#5
    inputs = `INPUT_SIZE'b0000;
    #5
    if(or_output != 1'b0)
    begin
        success_flag = 0;
        #10 $stop;
        $display("!!ERROR!! @ %d", $time);
    end

	#5
    inputs = `INPUT_SIZE'b1010;
    #5
    if(or_output != 1'b1)
    begin
        success_flag = 0;
        #10 $stop;
        $display("!!ERROR!! @ %d", $time);
    end

	#5
    inputs = `INPUT_SIZE'b1111;
    #5
    if(or_output != 1'b1)
    begin
        success_flag = 0;
        #10 $stop;
        $display("!!ERROR!! @ %d", $time);
    end
end
endtask

XOR #(.WIDTH(`INPUT_SIZE)) xor_gate
(
	.in(inputs),
	.out(xor_output)
);

task TEST_XOR;
begin
	#5
    inputs = `INPUT_SIZE'b0000;
    #5
    if(xor_output != 1'b0)
    begin
        success_flag = 0;
        #10 $stop;
        $display("!!ERROR!! @ %d", $time);
    end

	#5
    inputs = `INPUT_SIZE'b1010;
    #5
    if(xor_output != 1'b0)
    begin
        success_flag = 0;
        #10 $stop;
        $display("!!ERROR!! @ %d", $time);
    end

	#5
    inputs = `INPUT_SIZE'b1110;
    #5
    if(xor_output != 1'b1)
    begin
        success_flag = 0;
        #10 $stop;
        $display("!!ERROR!! @ %d", $time);
    end

	#5
    inputs = `INPUT_SIZE'b0010;
    #5
    if(xor_output != 1'b1)
    begin
        success_flag = 0;
        #10 $stop;
        $display("!!ERROR!! @ %d", $time);
    end
end
endtask
//////////////////////////////////
// Inverting Logic Functions
//////////////////////////////////

NAND #(.WIDTH(`INPUT_SIZE)) nand_gate
(
	.in(inputs),
	.out(nand_output)
);

task TEST_NAND;
begin
	#5
    inputs = `INPUT_SIZE'b0000;
    #5
    if(nand_output != 1'b1)
    begin
        success_flag = 0;
        #10 $stop;
        $display("!!ERROR!! @ %d", $time);
    end

	#5
    inputs = `INPUT_SIZE'b1010;
    #5
    if(nand_output != 1'b1)
    begin
        success_flag = 0;
        #10 $stop;
        $display("!!ERROR!! @ %d", $time);
    end

	#5
    inputs = `INPUT_SIZE'b1111;
    #5
    if(nand_output != 1'b0)
    begin
        success_flag = 0;
        #10 $stop;
        $display("!!ERROR!! @ %d", $time);
    end
end
endtask

NOR #(.WIDTH(`INPUT_SIZE)) nor_gate
(
	.in(inputs),
	.out(nor_output)
);

task TEST_NOR;
begin
	#5
    inputs = `INPUT_SIZE'b0000;
    #5
    if(nor_output != 1'b1)
    begin
        success_flag = 0;
        #10 $stop;
        $display("!!ERROR!! @ %d", $time);
    end

	#5
    inputs = `INPUT_SIZE'b1010;
    #5
    if(nor_output != 1'b0)
    begin
        success_flag = 0;
        #10 $stop;
        $display("!!ERROR!! @ %d", $time);
    end

	#5
    inputs = `INPUT_SIZE'b1111;
    #5
    if(nor_output != 1'b0)
    begin
        success_flag = 0;
        #10 $stop;
        $display("!!ERROR!! @ %d", $time);
    end
end
endtask

XNOR #(.WIDTH(`INPUT_SIZE)) xnor_gate
(
	.in(inputs),
	.out(xnor_output)
);

task TEST_XNOR;
begin
	#5
    inputs = `INPUT_SIZE'b0000;
    #5
    if(xnor_output != 1'b1)
    begin
        success_flag = 0;
        #10 $stop;
        $display("!!ERROR!! @ %d", $time);
    end

	#5
    inputs = `INPUT_SIZE'b1010;
    #5
    if(xnor_output != 1'b1)
    begin
        success_flag = 0;
        #10 $stop;
        $display("!!ERROR!! @ %d", $time);
    end 

	#5
    inputs = `INPUT_SIZE'b1110;
    #5
    if(xnor_output != 1'b0)
    begin
        success_flag = 0;
        #10 $stop;
        $display("!!ERROR!! @ %d", $time);
    end

	#5
    inputs = `INPUT_SIZE'b0010;
    #5
    if(xnor_output != 1'b0)
    begin
        success_flag = 0;
        #10 $stop;
        $display("!!ERROR!! @ %d", $time);
    end
end
endtask

task RESET;
begin
    rst = 0;
    clk = 0;
    inputs = 0;
    tribuffer_oe = 0;
    success_flag = 1;
    #5
    rst = 1;
    #5
    rst = 0;
end
endtask;

task CLOCK;
	input [31:0] count;
	integer k;
begin
	for (k=0; k < count; k = k+1)
	begin
		#5
		clk = 1;
		#5
		clk = 0;
	end
end
endtask

initial begin
    #10
    #10
	RESET;
    TEST_NOT;
    TEST_TRIBUFFER;
    TEST_AND;
    TEST_OR;
    TEST_XOR;
    TEST_NAND;
    TEST_NOR;
    TEST_XNOR;
    CLOCK(10);

    if(success_flag == 1'b1)
    begin
        $display("Test Successful");
    end
    else
    begin
        $display("Test Failure");
    end

    #10 $stop;
    #5 $finish;
end

endmodule
