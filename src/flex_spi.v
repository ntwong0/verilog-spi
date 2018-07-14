`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/03/2018 10:31:56 PM
// Design Name: 
// Module Name: SPI
// Project Name: 
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


module flex_spi(
    //  SPI-specific ports. This device is SPI master
    output  reg             ss,
    output  reg             sck,
    output  wire            mosi,
    input   wire            miso,
    //  clocking and control from CPU
    input   wire            clk,
    // functionality
    input   wire            rst,
    input   wire            en,         // If true, SPI I/F should proceed to TRANSFER
    input   wire            oe,         // If true, SPI I/F should output from rx_packet to data
    input   wire            we,         // If true, write from data to tx_packet
    input   wire            cpol,
    input   wire            cpha,
    input   wire    [ 3:0]  xfer_len,   // Determines bit length of the SPI transaction
    //  status to CPU
    output  reg             busy,
    output  reg             done,
    //  data I/O with CPU
    inout   wire    [15:0]  data
    );


    wire            [15:0]  datain, dataout, tx_wire, rx_wire;
    wire                    tbuf_mosi_in;
    
    
    reg                     i_clk;
    reg                     i_load;
    reg                     i_en;
    reg                     tbuf_mosi_oe;

    REGISTER        #(16)    rx_buf         (   .rst(rst),
                                                .clk(clk),
                                                .load(done),
                                                .D(rx_wire),
                                                .Q(dataout)
                                            );

    SHIFTLOADREG    #(16)    active_buffer  (   .rst(rst),
                                                .clk(clk),
                                                .load(i_load),
                                                .en(i_en),
                                                .in(miso),
                                                .D(datain),
                                                .Q(rx_wire)
                                            );
                                            
    DFLIPFLOP       #( 1)    mosi_buf       (   .rst(rst),
                                                .clk(clk),
                                                .D(rx_wire[15]),
                                                .Q(tbuf_mosi_in)
                                            );

    TRIBUFFER       #(16)    tbuf_datain    (   .oe(we),
                                                .in(data),
                                                .out(datain)
                                            );

    TRIBUFFER       #(16)    tbuf_dataout   (   .oe(oe),
                                                .in(dataout),
                                                .out(data)
                                            );

    TRIBUFFER       #( 1)    tbuf_mosi      (   .oe(tbuf_mosi_oe),
                                                .in(tbuf_mosi_in),
                                                .out(mosi)
                                            );
    
    parameter  STATE_SIZE  = 3;
    parameter  S_IDLE0     = 3'h0;
    parameter  S_LOAD0     = 3'h1;
    parameter  S_WRITE0    = 3'h2;
    parameter  S_READ      = 3'h3;
    parameter  S_DONE      = 3'h4;
    parameter  S_LOAD1     = 3'h5;
    parameter  S_WRITE1    = 3'h6;

    reg     [STATE_SIZE:0]  state;
    reg              [3:0]  xfer_cnt;

    reg [ 5:0] controls;
    assign {ss, busy, done, i_load, i_en, tbuf_mosi_oe} = controls;

    always @(state or xfer_cnt) begin
        case(state)                                                                                  // ss, busy, done, i_load, i_en, tbuf_mosi_oe
            S_IDLE0:  begin if (cpol) begin sck <=  1;   end else begin sck <=  0; end   controls <= 6'b_1_____0_____0_______1_____0_____________0; end
            S_LOAD0:  begin                 sck <=  sck;                                 controls <= 6'b_1_____1_____0_______0_____0_____________0; end
            S_LOAD1:  begin                 sck <=  sck;                                 controls <= 6'b_0_____1_____0_______0_____0_____________0; end
            S_WRITE0: begin                 sck <=  sck;                                 controls <= 6'b_0_____1_____0_______0_____1_____________1; end
            S_WRITE1: begin                 sck <= ~sck;                                 controls <= 6'b_0_____1_____0_______0_____1_____________1; end
            S_READ:   begin                 sck <= ~sck; if (xfer_cnt < xfer_len)  begin controls <= 6'b_0_____1_____0_______0_____0_____________1; end
                                                         else                      begin controls <= 6'b_0_____1_____1_______0_____0_____________1; end end
            S_DONE:   begin                 sck <= ~sck;                                 controls <= 6'b_0_____1_____1_______0_____0_____________0; end
        endcase
    end

    always @(posedge clk or rst) begin
        if     (rst) begin                                                                             state <= S_IDLE0; end
        
        else if (en) begin case (state)
                            S_IDLE0:    begin                           xfer_cnt <= 0;                 state <= S_LOAD0; end
                            
                            S_LOAD0:    begin                           xfer_cnt <= 0; if (cpha) begin state <= S_LOAD1; end
                                                                                       else      begin state <= S_WRITE0; end end
                            
                            S_LOAD1:    begin                                                          state <= S_WRITE1; end
                            
                            S_WRITE0:   begin                           xfer_cnt <= xfer_cnt + 1;      state <= S_READ; end
                            
                            S_WRITE1:   if (xfer_cnt < xfer_len)  begin xfer_cnt <= xfer_cnt + 1;      state <= S_READ; end
                                        else                      begin                                state <= S_READ; end
                            
                            S_READ:     if (xfer_cnt < xfer_len)  begin                                state <= S_WRITE1; end 
                                        else                      begin if (cpha) begin                state <= S_IDLE0;  end
                                                                        else      begin                state <= S_DONE;   end end
                            
                            S_DONE:     begin                                                          state <= S_IDLE0; end
                        endcase 
        end
    end
endmodule
