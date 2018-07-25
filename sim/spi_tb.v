`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/24/2018 11:07:11 AM
// Design Name: 
// Module Name: spi_tb
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


module spi_tb(

    );
    
    wire ss, sck, mosi, busy, done;
    reg miso, clk, rst, en, oe, we, cpol, cpha;
    reg [7:0] datain;
    wire [7:0] data;
    
    TRIBUFFER #(8) tbuf_data    (   .oe(we),
                                    .in(datain),
                                    .out(data)
                                );
    
    base_spi spi_dut (   .ss(ss),
                    .sck(sck),
                    .mosi(mosi),
                    .miso(miso),
                    .clk(clk),
                    .rst(rst),
                    .en(en),
                    .oe(oe),
                    .we(we),
                    .cpol(cpol),
                    .cpha(cpha),
                    .busy(busy),
                    .done(done),
                    .data(data)
                );
                
    initial
    begin
        miso = 1;
        clk  = 0;
        rst  = 1;
        en   = 0;
        oe   = 0;
        we   = 1;
        cpol = 0;
        cpha = 1;
        datain = 8'hAA;
        #5
            rst = 0;
        #10
            en = 1;
            we = 1;
        #10
            we = 0;
        #150
            miso = 0;
        #60
            oe = 1;
        #10 oe = 0;
        #20 $stop;
    end        
    always #5 clk = !clk;
    
endmodule
