`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/24/2018 08:17:53 AM
// Design Name: 
// Module Name: Test_ShiftLoadRegister
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


module Test_ShiftLoadRegister(

    );
    
    reg i_rst, sck, load, i_we, miso;
    reg [7:0] tx_packet;
    wire [7:0] rx_packet;
    
    SHIFTLOADREG #(8) buff  (   .rst(i_rst),
                                .clk(sck),
                                .load(load),
                                .en(i_we),
                                .in(miso),
                                .D(tx_packet),
                                .Q(rx_packet)
                            );
                            
    initial
    begin
        i_rst = 1;
        sck = 0;
        load = 0;
        i_we = 0;
        miso = 0;
        tx_packet = 8'h01;
        #5
        i_rst = 0;
        #25
        load = 1;
        #10
        load = 0;
        i_we = 1;
        #80
        $stop;
    end
    
    always #5 sck = !sck;
    
endmodule
