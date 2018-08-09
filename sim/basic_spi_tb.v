`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/21/2018 15:00
// Design Name: 
// Module Name: basic_spi_tb
// Project Name: verilog-spi
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: basic_spi.v
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module basic_spi_tb();
    
    wire ss, sck, mosi, busy, done;
    reg miso, clk, rst, en, oe, we, cpol, cpha;
    reg [15:0] datain;
    reg [3:0] xfer_len;
    wire [15:0] data;
    
    TRIBUFFER #(16) tbuf_data    (   .oe(we),
                                    .in(datain),
                                    .out(data)
                                );
    
    basic_spi SPI (  .ss(ss),
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
                    .xfer_len(xfer_len),
                    .busy(busy),
                    .done(done),
                    .data(data)
                );
                
    initial
    begin
        xfer_len = 12;
        miso = 1;
        clk  = 0;
        rst  = 1;
        en   = 0;
        oe   = 0;
        we   = 1;
        cpol = 0;
        cpha = 0;
        datain = 16'hAAAA;
        #5
            rst = 0;
        #10
            en = 1;
            we = 1;
        #70
            en = 0;
        #70
            en = 1;
        #10
            we = 0;
        #155
            en = 0;
            datain = 16'h7777;
            we = 1;
        #30
            we = 0;
            en = 1;
        #90
            en = 0;
        #30
            oe = 1;
            miso = 0;
        #10
            oe = 0;
            we = 1;
        #10
            en = 1;
        #70 $stop;
    end        
    always #5 clk = !clk;
    
endmodule
