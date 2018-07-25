`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/21/2018 14:39:56 PM
// Design Name: 
// Module Name: spi_dp
// Project Name: verilog-spi
// Target Devices: 
// Tool Versions: 
// Description: This module interfaces the CPU with the SPI bus
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module spi_dp(
    output  wire            mosi,
    input   wire            miso,
    input   wire            clk,
    input   wire            rst,
    input   wire            en,
    input   wire            oe,
    input   wire            we,
    input   wire            done,
    inout   wire    [15:0]  data,
    input   wire            i_load,
    input   wire            i_en,
    input   wire            tbuf_mosi_oe
    );

    wire            [15:0]  datain, dataout, rx_wire;
    wire                    tbuf_mosi_in;
    
    REGISTER        #(16)   rx_buf          (   .rst(rst),
                                                .clk(clk),
                                                .load(done),
                                                .D(rx_wire),
                                                .Q(dataout)
                                            );

    SHIFTLOADREG    #(16)   active_buffer   (   .rst(rst),
                                                .clk(clk),
                                                .load(i_load),
                                                .en(i_en),
                                                .in(miso),
                                                .D(datain),
                                                .Q(rx_wire)
                                            );
                                            
    DFLIPFLOP       #( 1)   mosi_buf        (   .rst(rst),
                                                .clk(clk),
                                                .D(rx_wire[15]),
                                                .Q(tbuf_mosi_in)
                                            );

    TRIBUFFER       #(16)   tbuf_datain     (   .oe(we),
                                                .in(data),
                                                .out(datain)
                                            );

    TRIBUFFER       #(16)   tbuf_dataout    (   .oe(oe),
                                                .in(dataout),
                                                .out(data)
                                            );

    TRIBUFFER       #( 1)   tbuf_mosi       (   .oe(tbuf_mosi_oe),
                                                .in(tbuf_mosi_in),
                                                .out(mosi)
                                            );

endmodule