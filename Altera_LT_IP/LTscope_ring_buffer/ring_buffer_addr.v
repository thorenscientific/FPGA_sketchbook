`timescale 1ns / 1ps

/*
    Created by: Noe Quintero
    E-mail: nquintero@linear.com

    Copyright (c) 2013, Linear Technology Corp.(LTC)
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
        The purpose of this module is to create a ring buffer addresser. The addresser
    will count up until the depth is reached. It will then reset to zero. 
        
*/

module ring_buffer_addr
(
    clk,
    rstn,
    en,
    addr
);
    parameter DEPTH = 32;
    input    clk;
    input    rstn;
    input    en;
    output [31:0] addr;
 
    assign addr[1:0] = 2'b0;
 
    // Internal signals
    wire [DEPTH-1:0] depth;
    assign depth = -1;
    wire cout;
    wire msb_en;
    reg count_rst;
 
    always @ (posedge clk)
        begin
            if(!rstn)
                count_rst = 1'b1;
            else if((addr == {depth[DEPTH-1:2],2'b0}) && en)
                count_rst = 1'b1;
            else
                count_rst = 1'b0;
        end
    assign msb_en = (!rstn)         ? 1'b0:
                    (cout && en)    ? 1'b1: 
                                      1'b0;
 
    // Generated by Altera's MegaWizard
    upcounter addr_lsb
    (
        .clock  (clk),
        .cnt_en (en),
        .aclr   (count_rst),
        .cout   (cout),
        .q      (addr[17:2])
    );
 
    // Generated by Altera's MegaWizard
    upcounter addr_msb
    (
        .clock  (clk),
        .cnt_en (msb_en),
        .aclr   (count_rst),
        .q      (addr[31:18])
    );
endmodule
 