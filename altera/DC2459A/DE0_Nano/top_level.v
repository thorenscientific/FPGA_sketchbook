`timescale 1ns / 10ps   // Each unit time is 1ns and the time precision is 10ps

/*
    Created by: Noe Quintero
    E-mail: nquintero@linear.com

    Copyright (c) 2015, Linear Technology Corp.(LTC)
    All rights reserved.

    Redistribution and use in source and binary forms, with or without
    modification, are permitted provided that the following conditions are met:

    1. Redistributions of source code must retain the above copyright notice, this
       list of conditions and the following disclaimer.
    2. Redistributions in binary form must reproduce the above copyright notice,
       this list of conditions and the following disclaimer in the documentation
       and/or other materials provided with the distribution.

    THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
    ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
    WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
    DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR
    ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
    (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
    LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
    ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
    (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
    SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

    The views and conclusions contained in the software and documentation are those
    of the authors and should not be interpreted as representing official policies,
    either expressed or implied, of Linear Technology Corp.


    Description:
        The purpose of this module is to interface with the DC2459A demo board as 
        a digital signal generator.
*/

module top_level
(
    // System signals
    sys_clk,
    reset_btn,
    trig,

    // SPI interface
    spi_ss,
    spi_sck,
    spi_miso,
    spi_mosi,

    // LTC1668 interface
    ltc1668_data
);

    ///////////////////////////////////////////////////////////////////////////
    // Port declaration
    ///////////////////////////////////////////////////////////////////////////

    // System signals
    input               sys_clk;
    input               reset_btn;
    output              trig;

    // SPI interface
    input               spi_ss;
    input               spi_sck;
    output              spi_miso;
    input               spi_mosi;

    // LTC1668 interface
    output  [15:0]  ltc1668_data;

    ///////////////////////////////////////////////////////////////////////////
    // Module parameters
    ///////////////////////////////////////////////////////////////////////////

    localparam NCO_DEFAULT_TUNING_WORD = 32'd858993; // 10 KHz

    ///////////////////////////////////////////////////////////////////////////
    // Internal signals
    ///////////////////////////////////////////////////////////////////////////

    reg         [31:0]  shift_reg;
    wire                reset_n;
    wire        [17:0]  nco_sin;
    reg         [31:0]  dff;

    //*************************************************************************

    // Connect the reset to the reset button
    assign reset_n = reset_btn;

    //*************************************************************************

    // SPI MISO
    assign spi_miso = shift_reg[31];

    //*************************************************************************

    // Shift register
    integer i;
    always @ (posedge spi_sck or negedge reset_n)
        begin
            if(!reset_n)
                shift_reg <= NCO_DEFAULT_TUNING_WORD;
            else if (!spi_ss)
                begin
                    shift_reg[0] <= spi_mosi;
                    for(i = 0; i< 31 ; i = i + 1)
                        shift_reg[i+1] <= shift_reg[i];
                end
            else
                shift_reg <= shift_reg;
        end

    //*************************************************************************

    // DFF used to keep data the same when changing the shift registers
    always @ (posedge sys_clk or negedge reset_n)
        begin
            if(!reset_n)
                dff <= NCO_DEFAULT_TUNING_WORD;
            else if(spi_ss)
                dff <= shift_reg;
            else
                dff <= dff;
        end

    //*************************************************************************

    assign ltc1668_data[15] = ~nco_sin[17];
    assign ltc1668_data[14:0] = nco_sin[16:2];
    assign trig =  ~nco_sin[17];

    // NCO
    nco_signal_gen nco_signal_gen_inst
    (
        .clk       (sys_clk),   // clk.clk
        .clken     (1'b1),      //  in.clken
        .phi_inc_i (dff),       //    .phi_inc_i
        .fsin_o    (nco_sin),   // out.fsin_o
        .out_valid (),          //    .out_valid
        .reset_n   (reset_n)    // rst.reset_n
    );

endmodule
