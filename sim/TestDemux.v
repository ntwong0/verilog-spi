`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 12/12/2017 05:08:28 PM
// Design Name:
// Module Name: TestDemux
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


module TestDemux;

reg success_flag;
integer i;

reg [7:0] select;
reg [7:0] in;
wire [7:0] a;
wire [7:0] b;

DEMUX #(8, 2) D0 (
    .select(select),
    .in(in),
    .out({b, a})
);

task TEST_DEMUX;
begin
    in = 'hAA;
    select = 0;
    #1
    if(a != 'hAA && b != 0)
    begin
    	success_flag = 0;
		$display("!!ERROR!! @ %d A == 0x%X :: B == 0x%X :: select == %d", $time, a, b, select);
    end
    #10
    select = 1;
    #1
    if(b != 'hAA && a != 0)
    begin
    	success_flag = 0;
		$display("!!ERROR!! @ %d A == 0x%X :: B == 0x%X :: select == %d", $time, a, b, select);
    end
end
endtask;

reg enable;
reg [2:0] d_in;
wire [7:0] out;

DECODER #(3) D1 (
    .enable(enable),
    .in(d_in),
    .out(out)
);

task TEST_DECODER;
begin
    enable = 1;
    d_in = 0;
    #1
    for (i = 0; i < 8; i = i + 1)
    begin
        d_in = i;
        #1
        if(out != (1 << i))
        begin
        	success_flag = 0;
    		$display("!!ERROR!! @ %d Out == 0x%X", $time, out);
        end
    end
    enable = 0;
    #1
    if(out != 0)
    begin
        success_flag = 0;
        $display("!!ERROR!! @ %d Out == 0x%X", $time, out);
    end
end
endtask;

initial begin
	success_flag = 1;
    TEST_DEMUX;
    #10
    TEST_DECODER;
    #10 $stop;
    #5 $finish;
end

endmodule
