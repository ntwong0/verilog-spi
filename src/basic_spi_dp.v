`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/09/2018
// Design Name: 
// Module Name: basic_spi_dp
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

module basic_spi_dp(
    output  wire            mosi,
    input   wire            miso,
    input   wire            clk,
    input   wire            rst,
 // input   wire            en,
    input   wire            oe,
    input   wire            we,
    input   wire            done,
    inout   wire    [15:0]  data,
    input   wire            i_load,
    input   wire            i_en,
    input   wire            tbuf_mosi_oe,
    input   wire            miso_le
    );

    wire            [15:0]  datain, dataout, rx_wire;
    // wire                    tbuf_mosi_in;
    wire                    miso_delayed1;
                                            
    DFLIPFLOP       #( 1)   miso_buf        (   .rst(rst),
                                                .clk(miso_le),
                                                .D(miso),
                                                .Q(miso_delayed1)
                                            );

    TRIBUFFER       #(16)   tbuf_datain     (   .oe(we),
                                                .in(data),
                                                .out(datain)
                                            );

    SHIFTLOADREG2   #(16)   active_buffer   (   .rst(rst),
                                                .clk(i_en),
                                                .load(i_load),
                                                .en(1'b1),
                                                .in(miso_delayed1),
                                                .D(datain),
                                                .Q(rx_wire)
                                            );
    
    REGISTER        #(16)   rx_buf          (   .rst(rst),
                                                .clk(clk),
                                                .load(done),
                                                .D(rx_wire),
                                                .Q(dataout)
                                            );

    TRIBUFFER       #( 1)   tbuf_mosi       (   .oe(tbuf_mosi_oe),
                                                .in(rx_wire[15]),
                                                .out(mosi)
                                            );

    TRIBUFFER       #(16)   tbuf_dataout    (   .oe(oe),
                                                .in(dataout),
                                                .out(data)
                                            );

endmodule