`timescale 1ns / 1ps

module SHIFTREGISTER #(parameter WIDTH = 8)(
	input   wire                    clk,
    input   wire                    rst,
    input   wire                    we,
    input   wire    [WIDTH-1:0]     datain,
    input   wire                    in,
    output  reg     [WIDTH-1:0]     Q
                                    
    );

    always @(posedge clk or posedge rst)
    begin
             if (rst)   Q <= 0;
        else if (we)    Q <= datain;
        else            Q <= { Q[7:1], in };
    end

endmodule

module TRIBUFFER #(parameter WIDTH = 1)(
        input wire oe,
        input wire [WIDTH-1:0] in,
        output wire [WIDTH-1:0] out
    );

    assign out = (oe) ? in : 'bZ;

endmodule
