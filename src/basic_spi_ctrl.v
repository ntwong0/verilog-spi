`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/09/2018
// Design Name: 
// Module Name: basic_spi_ctrl
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

module basic_spi_ctrl(
    // SPI-specific ports
    output  wire            ss,
    output  reg             sck,
    // clocking and functionality
    input   wire            clk,
    input   wire            rst,
    input   wire            en,
    input   wire            we,
    input   wire            cpol,
    input   wire            cpha,
    input   wire    [ 3:0]  xfer_len,
    // status
    output  wire            busy, 
    output  wire            done, 
    // control
    output  wire            i_load, 
    output  wire            i_en, 
    output  wire            tbuf_mosi_oe,
    output  wire            miso_le
);

    parameter  STATE_SIZE  = 3;
    parameter  S_INIT      = 3'h0;
    parameter  S_START_00  = 3'h1;
    parameter  S_RX_00     = 3'h2;
    parameter  S_TX_00     = 3'h3;
    parameter  S_DONE_00   = 3'h4;

    reg     [STATE_SIZE:0]  state;
    reg              [4:0]  xfer_cnt;

    reg [ 6:0] controls;
    assign {ss, busy, done, i_load, i_en, tbuf_mosi_oe, miso_le} = controls;

    always @(state or xfer_cnt) begin
        case(state)                                                                                   // ss, busy, done, i_load, i_en, tbuf_mosi_oe, miso_le
            S_INIT:      begin if (cpol) begin sck <=  1;   end else begin sck <=  0; end controls <= 7'b_1_____0_____0_______1_____1_____________0________0; end
            S_START_00:  begin                 sck <=  sck;                               controls <= 7'b_0_____1_____0_______0_____0_____________1________0; end
            S_RX_00:     begin                 sck <= ~sck;                               controls <= 7'b_0_____1_____0_______0_____0_____________1________0; end
            S_TX_00:     begin                 sck <= ~sck;                               controls <= 7'b_0_____1_____0_______0_____1_____________1________0; end
            S_DONE_00:   begin                 sck <= ~sck;                               controls <= 7'b_0_____1_____1_______0_____0_____________0________0; end
        endcase
    end

    always @(posedge clk or rst) begin
        if     (rst) begin                                                                     state <= S_INIT;     end

        else if (en) begin 
            case (state)
                S_INIT:     begin xfer_cnt <= 0;            if (we)                      begin state <= S_START_00; end
                                                            else                         begin state <= S_INIT;     end end
                S_START_00: begin xfer_cnt <= xfer_cnt + 1;                                    state <= S_RX_00;    end
                S_RX_00:    begin                           if (xfer_cnt < xfer_len + 4) begin state <= S_TX_00;    end
                                                            else                         begin state <= S_DONE_00;  end end
                S_TX_00:    begin xfer_cnt <= xfer_cnt + 1;                                    state <= S_RX_00;    end
                S_DONE_00:  begin                                                              state <= S_INIT;     end
            endcase 
        end
        else begin 
            case (state)
                S_RX_00:    begin                           if (xfer_cnt < xfer_len + 4) begin state <= S_TX_00;    end
                                                            else                         begin state <= S_DONE_00;  end end
            endcase
        end
    end

endmodule
