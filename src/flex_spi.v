`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/03/2018 10:31:56 PM
// Design Name: 
// Module Name: flex_spi
// Project Name: verilog-spi
// Target Devices: 
// Tool Versions: 
// Description: This module interfaces the CPU with the SPI bus
// 
// Dependencies: spi_ctrl.v
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module flex_spi(
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

    wire                    i_load, i_en, tbuf_mosi_oe;
    
    spi_dp                  DATAPATH        (   
                                                .mosi(mosi),
                                                .miso(miso),
                                                .clk(clk),
                                                .rst(rst),
                                                .en(en),
                                                .oe(oe),
                                                .we(we),
                                                .done(done),
                                                .data(data),
                                                .i_load(i_load),
                                                .i_en(i_en),
                                                .tbuf_mosi_oe(tbuf_mosi_oe)
                                            );
    
    spi_ctrl                CONTROLLER      (   .ss(ss),
                                                .sck(sck),
                                                .clk(clk),
                                                .rst(rst),
                                                .en(en),
                                                .cpol(cpol),
                                                .cpha(cpha),
                                                .xfer_len(xfer_len),
                                                .busy(busy), 
                                                .done(done), 
                                                .i_load(i_load), 
                                                .i_en(i_en), 
                                                .tbuf_mosi_oe(tbuf_mosi_oe)
                                            );

endmodule

