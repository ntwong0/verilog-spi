`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/03/2018 10:31:56 PM
// Design Name: 
// Module Name: spi_ctrl
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

module spi_ctrl(
    // SPI-specific ports
    output  wire            ss,
    output  reg             sck,
    // clocking and functionality
    input   wire            clk,
    input   wire            rst,
    input   wire            en,
    input   wire            cpol,
    input   wire            cpha,
    input   wire    [ 3:0]  xfer_len,
    // status
    output  wire            busy, 
    output  wire            done, 
    // control
    output  wire            i_load, 
    output  wire            i_en, 
    output  wire            tbuf_mosi_oe
);

    parameter  STATE_SIZE  = 3;
    parameter  S_INIT      = 3'h0;
    parameter  S_LOAD0     = 3'h1;
    parameter  S_WRITE0    = 3'h2;
    parameter  S_READ      = 3'h3;
    parameter  S_DONE      = 3'h4;
    parameter  S_LOAD1     = 3'h5;
    parameter  S_WRITE1    = 3'h6;

    reg     [STATE_SIZE:0]  state;
    reg              [4:0]  xfer_cnt;

    reg [ 5:0] controls;
    assign {ss, busy, done, i_load, i_en, tbuf_mosi_oe} = controls;

    always @(state or xfer_cnt) begin
        case(state)                                                                                      // ss, busy, done, i_load, i_en, tbuf_mosi_oe
            S_INIT:   begin if (cpol) begin sck <=  1;   end else begin sck <=  0; end       controls <= 6'b_1_____0_____0_______1_____0_____________0; end
            S_LOAD0:  begin                 sck <=  sck;                                     controls <= 6'b_1_____1_____0_______0_____0_____________0; end
            S_LOAD1:  begin                 sck <=  sck;                                     controls <= 6'b_0_____1_____0_______0_____0_____________0; end
            S_WRITE0: begin                 sck <=  sck;                                     controls <= 6'b_0_____1_____0_______0_____1_____________1; end
            S_WRITE1: begin                 sck <= ~sck;                                     controls <= 6'b_0_____1_____0_______0_____1_____________1; end
            S_READ:   begin                 sck <= ~sck; if (xfer_cnt < xfer_len + 4)  begin controls <= 6'b_0_____1_____0_______0_____0_____________1; end
                                                         else                          begin controls <= 6'b_0_____1_____1_______0_____0_____________1; end end
            S_DONE:   begin                 sck <= ~sck;                                     controls <= 6'b_0_____1_____1_______0_____0_____________0; end
        endcase
    end

    always @(posedge clk or rst) begin
        if     (rst) begin                                                                                 state <= S_INIT; end

        else if (en) begin case (state)
                            S_INIT:    begin                                xfer_cnt <= 0;                 state <= S_LOAD0; end
                            
                            S_LOAD0:    begin                               xfer_cnt <= 0; if (cpha) begin state <= S_LOAD1; end
                                                                                           else      begin state <= S_WRITE0; end end
                            
                            S_LOAD1:    begin                                                              state <= S_WRITE1; end
                            
                            S_WRITE0:   begin                               xfer_cnt <= xfer_cnt + 1;      state <= S_READ; end
                            
                            S_WRITE1:   if (xfer_cnt < xfer_len + 4)  begin xfer_cnt <= xfer_cnt + 1;      state <= S_READ; end
                                        else                          begin                                state <= S_READ; end
                            
                            S_READ:     if (xfer_cnt < xfer_len + 4)  begin                                state <= S_WRITE1; end 
                                        else                          begin if (cpha) begin                state <= S_INIT;  end
                                                                            else      begin                state <= S_DONE;   end end
                            
                            S_DONE:     begin                                                              state <= S_INIT; end
                        endcase 
        end
    end

endmodule
