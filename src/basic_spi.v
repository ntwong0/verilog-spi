`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/09/2018
// Design Name: 
// Module Name: basic_spi
// Project Name: verilog-spi
// Target Devices: 
// Tool Versions: 
// Description: This module interfaces the CPU with the SPI bus
// 
// Dependencies: basic_spi_ctrl.v, basic_spi_dp.v 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module basic_spi(
    //  SPI-specific ports. This device is SPI master
    output  wire            ss,         // Optional, if not already provided by GPIO.
    output  wire            sck,        // Serial Clock
    output  wire            mosi,       // Master Out Slave In
    input   wire            miso,       // Master In Slave Out
    //  clocking and control from CPU
    input   wire            clk,        // System clock, can be fed by clock divider instead
    // functionality
    input   wire            rst,        // Resets the SPI module
    input   wire            en,         // If true, SPI I/F should proceed to TRANSFER
    input   wire            oe,         // If true, SPI I/F should output from rx_packet to data
    input   wire            we,         // If true, write from data to tx_packet
    input   wire            cpol,       // SPI Clock Polarity
    input   wire            cpha,       // SPI Clock Phase
    input   wire    [ 3:0]  xfer_len,   // Determines bit length of the SPI transaction
    //  status to CPU
    output  wire            busy,       // Indicates a SPI transaction is in progress
    output  wire            done,       // Indicates a SPI transaction has completed
    //  data I/O with CPU
    inout   wire    [15:0]  data        // Data in/out from/to microcontroller
    );

    wire                    i_load, i_en, tbuf_mosi_oe, miso_le;
    
    basic_spi_dp    DATAPATH   (    .mosi(mosi),
                                    .miso(miso),
                                    .clk(clk),
                                    .rst(rst),
                                    .oe(oe),
                                    .we(we),
                                    .done(done),
                                    .data(data),
                                    .i_load(i_load),
                                    .i_en(i_en),
                                    .tbuf_mosi_oe(tbuf_mosi_oe),
                                    .miso_le(miso_le)
                                );
    
    basic_spi_ctrl  CONTROLLER  (   .ss(ss),
                                    .sck(sck),
                                    .clk(clk),
                                    .rst(rst),
                                    .en(en),
                                    .we(we),
                                    .cpol(cpol),
                                    .cpha(cpha),
                                    .xfer_len(xfer_len),
                                    .busy(busy), 
                                    .done(done), 
                                    .i_load(i_load), 
                                    .i_en(i_en), 
                                    .tbuf_mosi_oe(tbuf_mosi_oe),
                                    .miso_le(miso_le)
                                );

endmodule

