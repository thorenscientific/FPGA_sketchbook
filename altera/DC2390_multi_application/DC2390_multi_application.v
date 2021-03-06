`timescale 1ns / 10ps   // Each unit time is 1ns and the time precision is 10ps

/*
    Created by: Mark Thoren
                Noe Quintero
    E-mail:     mthoren@linear.com
                nquintero@linear.com

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
        The purpose of this module is to interface with the DC2390. This is the top 
        level module which instantiates the fos control demo which will interface
        with linux and allow the user to run different experiment.
*/

module DC2390_multi_application
(
    input           clk,                    // Input OSC_50_B3B, // Original name...
    input           adc_clk_in,
    input   [3:0]   KEY ,                   // Keys are normally high, low when pressed
    output  [3:0]   LED,                    // HIGH to turn ON
    output          adc_clk_out,            // Raw ADC out
    output          adc_clk_nshift_out,     // PLL clock out 0 deg shift
    output          adc_clk_shift_out,      // PLL clock out -90 deg shift
    inout sda,  //PIN_AE29
    inout scl,  //PIN_AA28
	 input ext_trig_in, // External trigger input. Test point X10, HSMC RX8P, (FPGA pin F11)

    //////////// DDR3 /////////
    output  [14:0]  fpga_memory_mem_a,          // fpga_memory.mem_a
    output  [2:0]   fpga_memory_mem_ba,         //            .mem_ba
    output          fpga_memory_mem_ck,         //            .mem_ck
    output          fpga_memory_mem_ck_n,       //            .mem_ck_n
    output          fpga_memory_mem_cke,        //            .mem_cke
    output          fpga_memory_mem_cs_n,       //            .mem_cs_n
    output  [3:0]   fpga_memory_mem_dm,         //            .mem_dm
    output          fpga_memory_mem_ras_n,      //            .mem_ras_n
    output          fpga_memory_mem_cas_n,      //            .mem_cas_n
    output          fpga_memory_mem_we_n,       //            .mem_we_n
    output          fpga_memory_mem_reset_n,    //            .mem_reset_n
    inout   [31:0]  fpga_memory_mem_dq,         //            .mem_dq
    inout   [3:0]   fpga_memory_mem_dqs,        //            .mem_dqs
    inout   [3:0]   fpga_memory_mem_dqs_n,      //            .mem_dqs_n
    output          fpga_memory_mem_odt,        //            .mem_odt
    input           oct_rzqin,                  //         oct.rzqin

    //////////// HPS /////////
    output  [14:0]  hps_memory_mem_a,
    output  [2:0]   hps_memory_mem_ba,
    output          hps_memory_mem_ck,
    output          hps_memory_mem_ck_n,
    output          hps_memory_mem_cke,
    output          hps_memory_mem_cs_n,
    output          hps_memory_mem_ras_n,
    output          hps_memory_mem_cas_n,
    output          hps_memory_mem_we_n,
    output          hps_memory_mem_reset_n,
    inout   [31:0]  hps_memory_mem_dq,
    inout   [4:0]   hps_memory_mem_dqs,
    inout   [4:0]   hps_memory_mem_dqs_n,
    output          hps_memory_mem_odt,
    output  [4:0]   hps_memory_mem_dm,
    input           hps_memory_oct_rzqin,

    ////// DACs ////////////
    output  [15:0]  DAC_A,
    output  [15:0]  DAC_B,

    /////// ADCs //////////

    // LTC2500 ADCs
    output          mclk_u1,
    output          sync_u1,
    input           busy_u1,
    input           drdyl_u1,
    output          rdl_u1,
    output          sclk_u1,
    input           sdo_u1,
    output          rdl_filt_u1,
    output          sclk_filt_u1,
    input           sdo_filt_u1,
    output          sdi_filt_u1,

    output          mclk_u2,
    output          sync_u2,
    input           busy_u2,
    input           drdyl_u2,
    output          rdl_u2,
    output          sclk_u2,
    input           sdo_u2,
    output          rdl_filt_u2,
    output          sclk_filt_u2,
    input           sdo_filt_u2,
    output          sdi_filt_u2,

    // SPI port for LTC6954
    output          ltc6954_sync,
    output          ltc6954_cs,
    output          ltc6954_sck,
    output          ltc6954_sdi,
    input           ltc6954_sdo,

    output          linduino_cs,
    output          linduino_sck,
    output          linduino_mosi,
    input           linduino_miso,

    output          gpo0, // Test Point X7, HSMC LVDS RX_p15 (FPGA pin F13)
    output          gpo1  // Test Point X9, HSMC LVDS RX_p14 (FPGA pin H14)
);

//    `define  LTC2512_DEMO 1
		`define  LTC2500_DEMO 1
    // *********************************************************
    // Parameters

    `ifdef LTC2512_DEMO
        parameter   FPGA_TYPE = 16'hABCE;
        parameter   NYQ_TRUNK_VALUE = 8;
        parameter   FILT_TRUNK_VALUE = 32;
        parameter   NUM_OF_CLK_PER_BSY = 24;
    `else
        parameter   FPGA_TYPE = 16'hABCD; // FPGA project type identification. Accessible from register map.
        parameter   NYQ_TRUNK_VALUE = 32;
        parameter   FILT_TRUNK_VALUE = 54;
        parameter   NUM_OF_CLK_PER_BSY = 34;
    `endif

    parameter       FPGA_REV = 16'h1246;  // FPGA revision (also accessible from register.)
    // 123B: PLL lock status, alternate sources for PID setpoint.
	 // 123D: Overflow detector logic, changed counter pattern to a 32-bit up counter
	 // 123E: Rebuilding with updated LTC2500 controller (see SVN log...)
	 // 123F: Add I2C connections!
	 // 1240: Change PID feedback input from [31:12] to [30:11] to account for overflow bit in final silicon.
    // 1241: Rebuilding with updated LTC2500 controller again... register filt data from nonshifted clock
	 // 1242: SDI timing constraint adjustments
	 // 1245: Another LTC2500 controller update, add resync signals from blob.
	 // 1246: Further constraint file cleanup, false-path to I/O that is not directly related to clock signals.
    // *********************************************************
    // Internal Signal Declaration

    wire            reset;
    wire    [31:0]  mem_ctrl_addr;
    wire            mem_ctrl_go;
    wire    [31:0]  mem_ctrl_data;
    wire            mem_ctrl_ready;

    // Wires to/from Qsys blob
    wire    [31:0]  std_ctrl_wire;
    wire    [15:0]  pid_kp, pid_ki, pid_kd;
    wire    [31:0]  pulse_low, pulse_high;
    wire    [19:0]  pulse_val;
    wire    [15:0]  fos_tau, fos_gain;

    wire    [15:0]  system_clocks_per_sample;
    wire    [29:0]  num_samples;
    wire    [31:0]  tuning_word;
    wire    [31:0]  stop_address;
    wire    [31:0]  datapath_control;

    wire            start;
    wire            data_ready;
    wire            mem_adcA_nadcB;
    wire    [31:0]  adcA_data;
    wire    [31:0]  adcB_data;
    wire    [3:0]   LEDwire;
    wire    [13:0]  n;                  // For LTC2378-24, number of samples to average
    wire    [19:0]  control_sys_output;
    wire            adcA_done;
    wire            adc_go;             // Trigger to ADC controller
    wire    [1:0]   dac_a_select;
    wire    [1:0]   dac_b_select;
    wire    [1:0]   lut_addr_select;
    wire            en_trig;
    wire            delayed_trig;
    wire            lut_run_once;
    wire            lut_write_enable;
    wire    [15:0]  lut_output;         // Output of DAC lookup table
    wire    [15:0]  lut_addr_counter;   // Coutnter for sequencing through LUT memory
    wire    [15:0]  lut_addr;           // Input to lookup table address
    wire    [15:0]  lut_wraddress;
    wire    [15:0]  lut_wrdata;
    wire    [15:0]  nco_sin_out;
    wire    [15:0]  nco_cos_out;
    wire    [15:0]  dac_a_data_signed;
    wire    [15:0]  dac_b_data_signed;
    reg     [15:0]  dac_a_data_straight;
    reg     [15:0]  dac_b_data_straight;
    reg             old_trig;
    wire            trig_pulse;
    wire    [19:0]  setpoint;
    wire    [15:0]  pid_output;
    wire            pid_done;
    wire            adc_done;
    wire            reset_n;
    wire    [53:0]  filt_data_u1;
    wire    [53:0]  filt_data_u2;
    wire            valid_filt_u1;
    wire            valid_filt_u2;
    wire            overflow;
    wire            wrfull;
    wire            wrreq;
    wire            rdempty;
    wire            rdreq;
    wire    [31:0]  formatter_output;
    wire    [511:0] formatter_input;
    wire            formatter_valid;
    wire    [63:0]  nyquist_data;
    wire            wrfull_nyq;
    wire            wrreq_nyq;
    wire    [31:0]  formatter_nyq_output;
    wire            formatter_nyq_valid;
    reg     [29:0]  num_calculated;
    wire    [31:0]  counter_pattern;
    wire    [2:0]   fifo_data_select; // Multiplexer control signal
    wire            mem_ctrl_go_muxout;
    wire            adc_fifo_valid;
    wire            adc_fifo_rdreq;
    wire            adc_fifo_wrreq;
    wire            adc_fifo_ready;
    wire            adc_fifo_empty;
    wire            adc_fifo_full;
    wire    [31:0]  adc_fifo_data;
    wire            data_valid;
    wire    [9:0]   cfg;
    reg     [23:0]  counter;
    wire            force_trig_nosync;
    reg             force_trig, ft1, ft2;
	 reg             ext_trig, eti1, eti2;
    wire            lut_count_carry;
    wire            adcB_done;
    wire            rdreq_nyq;
    wire            rdempty_nyq;
    wire            adc_error_u1;
    wire            adc_error_u2;
    wire            adc_clk;
    wire            adc_clk_shift;
    wire            pll_lock;
    wire            lut_addr_div_cout;
    wire            spi_miso;
    wire            spi_mosi;
    wire            spi_sck;
    wire    [15:0]  lut_addr_div;
    wire    [1:0]   setpoint_source_select;
    wire    [19:0]  pulse_out;
    reg     [19:0]  pulse_val_trigd; // Pulse value changes state on start of data capture.

    // *********************************************************
    assign LED[3:0] = LEDwire[3:0];
    assign reset = !KEY[0];
    assign reset_n = ~reset;

	overflow_det overflow_detector_1
	(
		.q(overflow),      // status - asserted means overflow occurred after
		.qbar(),           // the most recent trigger
		.r(trig_pulse),    // Trigger rising edge resets
		.s(adc_fifo_full), // Any assertion of fifo full signal asserts
		.clk(adc_clk)
	);

    assign adc_clk_out = adc_clk_in;
    assign adc_clk_nshift_out = adc_clk;
    assign adc_clk_shift_out = adc_clk_shift;

    assign LEDwire[3] = pll_lock;
    assign LEDwire[2] = overflow;
    assign LEDwire[1] = adc_error_u1 | adc_error_u2;

    assign DAC_A = dac_a_data_straight;
    assign DAC_B = dac_b_data_straight;


    // ********************************************************
    // PLL for the LTC2500 controller
    DC2390_pll DC2390_pll_inst
    (
        .refclk     (adc_clk_in),       // refclk.clk
        .rst        (reset),            // reset.reset
        .outclk_0   (adc_clk),          // outclk0.clk
        .outclk_1   (adc_clk_shift),    // outclk1.clk
        .locked     (pll_lock),         // locked.export
    );

    // *********************************************************
    // DAC data signals and control
	 // Invert MSb to convert from 2's complement to straight binary
    always @ (posedge adc_clk)
        begin
            dac_a_data_straight <= {~dac_a_data_signed[15], dac_a_data_signed[14:0]};
            dac_b_data_straight <= {~dac_b_data_signed[15], dac_b_data_signed[14:0]};
        end

    // *********************************************************
    // DAC input MUX
    mux_4to1_16 mux_4to1_16_DAC_A_ins
    (
        .clock  (adc_clk),
        .data0x (nco_sin_out),
        .data1x (pid_output),
        .data2x (pulse_val_trigd[15:0]),
        .data3x (pulse_val[15:0]),
        .sel    (dac_a_select),
        .result (dac_a_data_signed)
    );

    mux_4to1_16 mux_4to1_16_DAC_B_inst
    (
        .clock  (adc_clk),
        .data0x (nco_cos_out),
        .data1x (lut_output),
        .data2x (16'hC000),
        .data3x (16'h4000),
        .sel    (dac_b_select),
        .result (dac_b_data_signed)
    );

    // *********************************************************
    // Create single trigger pulse from force_trig's posedge
    // Essentially an edge detector
    assign trig_pulse = force_trig & ~old_trig;
    always @ (posedge adc_clk)
        begin
            old_trig <= force_trig;
        end

    // *********************************************************
    // Counter to sequence through LUT.
    upcount_mem_addr  upcount_mem_addr_lut_addr_inst
    (
        .clock  (adc_clk), // Run once on start pulse, override with lut_run_once = 0 (default)
        .cnt_en ((lut_addr_div_cout & (~(lut_count_carry & lut_run_once)))),
        .sclr   (trig_pulse),
        .cout   (lut_count_carry),
        .q      (lut_addr_counter)
    );

    // Divide the LUT adderssor
    up_count_with_load up_count_with_load_inst
    (
        .clock  (adc_clk),
        .sclr   (reset),
        .cnt_en (1'b1),
        .data   (lut_addr_div),
        .sload  (lut_addr_div_cout | trig_pulse),
        .cout   (lut_addr_div_cout),
        .q      ()
    );

    // *********************************************************
    // Lookup table address mux
    mux_4to1_16 mux_4to1_16_lut_addr_inst
    (
        .clock  (adc_clk),
        .data0x (lut_addr_counter), // This is for pattern, pulse generation
        .data1x (dac_a_data_signed), // This is for distortion correction
        .data2x (16'h4000),
        .data3x (16'hC000),
        .sel    (lut_addr_select),
        .result (lut_addr)
    );

    // *********************************************************
    // Lookup table (16x16)
    ram_lut ram_lut_inst
    (
        .data       (lut_wrdata),
        .rdaddress  (lut_addr),
        .rdclock    (adc_clk),
        .wraddress  (lut_wraddress),
        .wrclock    (clk),
        .wren       (lut_write_enable), // High to enable writing
        .q          (lut_output)
    );

    // *********************************************************
    // Step generator
    pulse_gen #
    (
        .OUTPUT_WIDTH(20)
    )
    step
    (
        .clk(adc_clk),
        .reset(reset),
        .trig(trig_pulse),
        .low_period(pulse_low),
        .high_period(pulse_high),
        .value(pulse_val),
        .out(pulse_out)
    );

    // *********************************************************
    // NCO set up with data width of 18 to try to trick it into overkill ;)
    nco_iq_14_1 nco_iq_14_1_inst
    (
        .clk        (adc_clk),                      // clk.clk
        .reset_n    (1'b1),                         // rst.reset_n
        .clken      (lut_addr_div_cout),            // in.clken
        .phi_inc_i  (tuning_word),                  // phi_inc_i
        .fsin_o     ({nco_sin_out[15:0], 2'bzz}),   // Snag 16 MS bits...
        .fcos_o     ({nco_cos_out[15:0], 2'bzz}),
        .out_valid  (1'bz)                          // out valid
    );

    // Make version of pulse_val that updates when trig_pulse asserts
    always @ (posedge adc_clk) 
        begin
            if (trig_pulse) begin
                pulse_val_trigd <= pulse_val;
            end
            else begin
                pulse_val_trigd <= pulse_val_trigd;
            end
        end

    mux_4_to_1_20bit mux_4_to_1_20bit_inst 
    (
        .clock  ( adc_clk ),
        .data0x ( pulse_out ),          // Direct output from fancy pulse generator
        .data1x ( pulse_val_trigd ),    // Pulse value, but updated at start of capture
        .data2x ( pulse_val ),          // Pulse value, straight from blob register
        .data3x ( 20'b0 ),              // Zero.
        .sel    ( setpoint_source_select ),
        .result ( setpoint )            // Setpoint output to PID controller
    );

    // *********************************************************
    // PID controller
    pid #
    (
        .INPUT_WIDTH            (20),
        .OUTPUT_WIDTH           (16),
        .PID_PARAM_WIDTH        (16),
        .PID_PARAM_FP_PRECISION (8),    // fixed point decimal places (must be <= PID_PARAM_WIDTH-1)
        .MAX_OVF_SUM            (4)     // overflow bits for err_sum
    )
    ctrl
    (
        .clk        (adc_clk),
        .reset      (reset),
        //PID settings
        .kp         (pid_kp),       //signed binary fixed point
        .ki         (pid_ki),       //signed binary fixed point
        .kd         (pid_kd),       //signed binary fixed point
        .setpoint   (setpoint),     //signed integer
        //PID signals
        .feedback   (adcA_data[30:11]),    //signed integer, changed FROM [31:12] for final silicon!!!
        .sig_out    (pid_output),   //signed integer
        .trig       (adcA_done),    //triggers new calculation (1 clock pulse)
        .done       (pid_done)      //signals new valid data on output (1 clock pulse)
    );

    // *********************************************************
    // Controller for ADC A
    LTC2500_controller #
    (
        .DFF_CYCLE_COMP     (1'b0),
        .NUM_OF_CLK_PER_BSY (NUM_OF_CLK_PER_BSY),
        .NYQ_TRUNK_VALUE    (NYQ_TRUNK_VALUE),
        .FILT_TRUNK_VALUE   (FILT_TRUNK_VALUE)
    )
    LTC2500_u1
    (
        // Control 
        .sys_clk        (adc_clk),      // The digital clock
        .sck_in         (adc_clk_shift),// The serial clock from PLL to be gated for the sck of the LTC2500
        .reset_n        (reset_n),      // Reset active low
        .go             (adc_go),       // Start a ADC read
        .sync_req_recfg (sync_req_u1 | sync_req_both),         // Request a synchronisation or reconfigure ADC
        .cfg            (cfg),          // The configuration word 
        .n              (n),            // The averaging ratio

        // LTC2500 Signals
        // Port A
        .rdl_filt       (rdl_filt_u1),  // Read data low for the filtered data port
        .sck_filt       (sclk_filt_u1), // Gated clock for filtered data port
        .sdi_filt       (sdi_filt_u1),  // Serial data in for the ADC's filtered port
        .sdo_filt       (sdo_filt_u1),  // Serial data out for the ADC's filtered port
        // Port B
        .rdl_nyq        (rdl_u1),       // Read data low for the Nyquist data port
        .sck_nyq        (sclk_u1),      // Gated clock for Nyquist data port
        .sdo_nyq        (sdo_u1),       // Serial data out for the ADC's Nyquist port

        .busy           (busy_u1),      // The ADC is busy with a conversion
        .drdy_n         (drdyl_u1),     // The ADC is not ready for filtered data
        .mclk           (mclk_u1),      // The conversion clock
        .sync           (sync_u1),      // The synchronizing signal for the ADC

        // Streaming output
        .data_nyq       (adcA_data),    // Parallel Nyquist data out
        .valid_nyq      (adcA_done),    // The Nyquist data is valid

        .data_filt      (filt_data_u1), // Parallel filtered data out
        .valid_filt     (valid_filt_u1),// Parallel common mode filtered data out
        .error          (adc_error_u1)  // The filtered data is valid
    );

    // ADC controller for ADC B
    LTC2500_controller #
    (
        .DFF_CYCLE_COMP     (1'b0),
        .NUM_OF_CLK_PER_BSY (NUM_OF_CLK_PER_BSY),
        .NYQ_TRUNK_VALUE    (NYQ_TRUNK_VALUE),
        .FILT_TRUNK_VALUE   (FILT_TRUNK_VALUE)
    )
    LTC2500_u2
    (
        // Control 
        .sys_clk        (adc_clk),      // The digital clock
        .sck_in         (adc_clk_shift),// The serial clock from PLL to be gated for the sck of the LTC2500
        .reset_n        (reset_n),      // Reset active low
        .go             (adc_go),       // Start a ADC read
        .sync_req_recfg (sync_req_u2 | sync_req_both),         // Request a synchronisation or reconfigure ADC
        .cfg            (cfg),          // The configuration word 
        .n              (n),            // The averaging ratio

        // LTC2500 Signals
        // Port A
        .rdl_filt       (rdl_filt_u2),  // Read data low for the filtered data port
        .sck_filt       (sclk_filt_u2), // Gated clock for filtered data port
        .sdi_filt       (sdi_filt_u2),  // Serial data in for the ADC's filtered port
        .sdo_filt       (sdo_filt_u2),  // Serial data out for the ADC's filtered port
        // Port B
        .rdl_nyq        (rdl_u2),       // Read data low for the Nyquist data port
        .sck_nyq        (sclk_u2),      // Gated clock for Nyquist data port
        .sdo_nyq        (sdo_u2),       // Serial data out for the ADC's Nyquist port

        .busy           (busy_u2),      // The ADC is busy with a conversion
        .drdy_n         (drdyl_u2),     // The ADC is not ready for filtered data
        .mclk           (mclk_u2),      // The conversion clock
        .sync           (sync_u2),      // The synchronizing signal for the ADC

        // Streaming output
        .data_nyq       (adcB_data),    // Parallel Nyquist data out
        .valid_nyq      (adcB_done),    // The Nyquist data is valid

        .data_filt      (filt_data_u2), // Parallel filtered data out
        .valid_filt     (valid_filt_u2),// Parallel common mode filtered data out
        .error          (adc_error_u2)  // The filtered data is valid
    );

    // *********************************************************
    // Formatted data formatter

    // Converts the streaming control signals to the FIFO control signals
    LT_st_dcfifo_cntr steam_to_fifo_adapter
    (
        // Streaming interface
        .valid  (valid_filt_u1 & delayed_trig),    // Nominally, all valid signals should be the same
                                                    // Picked the first one for conviniance 
        // DC FIFO interface
        .wrfull (wrfull),
        .wrreq  (wrreq)
    );

    // A DC FIFO is used as a width adapter
    // 512 bits to 32 bits
    assign  formatter_input =  {filt_data_u1, 10'b0, adcA_data, 32'hDEAD_BEEF, 32'h8BAD_F00D, 32'hB105_F00D, 32'hDEAD_C0DE, 32'hD006_F00D,
                                filt_data_u2, 10'b0, adcB_data, 32'hDEAD_BEEF, 32'h8BAD_F00D, 32'hB105_F00D, 32'hDEAD_C0DE, 32'hD006_F00D};
    formatter adc_formatter
    (
        .aclr       (reset),
        .data       (formatter_input),
        .rdclk      (adc_clk),
        .rdreq      (rdreq),
        .wrclk      (adc_clk),
        .wrreq      (wrreq),
        .q          (formatter_output),
        .rdempty    (rdempty),
        .wrfull     (wrfull)
    );

    // Converts the FIFO control signals to streaming control signals
    LT_dcfifo_st_cntr  fifo_to_stream
    (
        // DC FIFO interface
        .rdempty    (rdempty),
        .rdreq      (rdreq),
        // Streaming interface
        .valid      (formatter_valid),
        .ready      (1'b1)
    );

    // *********************************************************
    // Nyquist data formatter

    // Converts the streaming control signals to the FIFO control signals
    LT_st_dcfifo_cntr steam_to_fifo_adapter_nyq
    (
        // Streaming interface
        .valid  (adcA_done & delayed_trig), // Nominally, all valid signals should be the same
                                            // Picked the first one for conviniance 
        // DC FIFO interface
        .wrfull (wrfull_nyq),
        .wrreq  (wrreq_nyq)
    );

    // A DC FIFO is used as a width adapter
    // 64 bits to 32 bits
    assign nyquist_data = {adcA_data, adcB_data};
    nyq_formatter nyquist_formatter
    (
        .aclr       (reset),
        .data       (nyquist_data),
        .rdclk      (adc_clk),
        .rdreq      (rdreq_nyq),
        .wrclk      (adc_clk),
        .wrreq      (wrreq_nyq),
        .q          (formatter_nyq_output),
        .rdempty    (rdempty_nyq),
        .wrfull     (wrfull_nyq)
    );

    // Converts the FIFO control signals to streaming control signals
    LT_dcfifo_st_cntr fifo_to_stream_nyq
    (
        // DC FIFO interface
        .rdempty    (rdempty_nyq),
        .rdreq      (rdreq_nyq),
        // Streaming interface
        .valid      (formatter_nyq_valid),
        .ready      (1'b1)
    );

    // *********************************************************
    // Sample rate generator
    sample_rate_controller sample_rate_controller_inst
    (
        .clk            (adc_clk),
        .reset_n        (reset_n),
        .en             (1'b1),
        .sample_rate    (system_clocks_per_sample),
        .go             (adc_go)
    );

    // *********************************************************
    // Generic counters for creating known data

////    16 bit up counter
    // updown_count16  updown_count16_inst1
    // (
        // .clock  (adc_clk),
        // .cnt_en (adc_go),
        // .updown (0),            // Zero for down
        // .q      (countdown)
    // );

////    16 bit down counter
    // updown_count16  updown_count16_inst2
    // (
        // .clock  (adc_clk),
        // .cnt_en (adc_go),
        // .updown (1),            // One for up
        // .q      (countup)
    // );

	upcount_32	upcount_32_inst
	(
			.clock ( adc_clk ),
			.cnt_en ( adc_go ),
			.data ( 32'b0 ),
			.sclr ( 1'b0 ),
			.sload ( 1'b0 ),
			.cout (  ),
			.q (counter_pattern)
		);


    // *********************************************************
    // This multiplexer is right in front of the clock-crossing FIFO.
    // Data inputs consist of the 32 bit data concatenated with the Valid
    // signal. KEEP VALID AT THE LSB SIDE SO IT IS CONSIDERED FIRST!!!
    mux_8to1_32stream mux_8to1_32stream_inst
    (
        .clock  (adc_clk),
        .data0x ({adcA_data, adcA_done & delayed_trig}),               // Holy smokes!!! Get things into 32 bit land
        .data1x ({adcB_data, adcB_done & delayed_trig}),               // ASAP!!!
        .data2x ({filt_data_u1[53:22], valid_filt_u1 & delayed_trig}),
        .data3x ({filt_data_u2[53:22], valid_filt_u2 & delayed_trig}),
        .data4x ({counter_pattern, adc_go & delayed_trig}),
        .data5x ({formatter_output, formatter_valid}),
        .data6x ({formatter_nyq_output, formatter_nyq_valid}),
        .data7x ({32'hDEAD_BEEF, adc_go}),              // Super simple test pattern
        .sel    (fifo_data_select),
        .result ({mem_ctrl_data, mem_ctrl_go_muxout})
    );

    assign adc_fifo_rdreq = (!adc_fifo_empty & adc_fifo_ready) ? 1'b1 : 1'b0;
    assign adc_fifo_wrreq =  mem_ctrl_go_muxout & (!adc_fifo_full);
    assign adc_fifo_valid = adc_fifo_rdreq;

    // *********************************************************
    // DC FIFO for going from ADC clock domain to systems 50MHz clock domain
    // Note: show ahead mode
    ADC_fifo adc_fifo
    (
        .aclr       (reset),
        .data       (mem_ctrl_data),
        .rdclk      (clk),
        .rdreq      (adc_fifo_rdreq),
        .wrclk      (adc_clk),
        .wrreq      (adc_fifo_wrreq),
        .q          (adc_fifo_data),
        .rdempty    (adc_fifo_empty),
        .wrfull     (adc_fifo_full)     // If this ever asserts, something went wrong!
    );

    // *********************************************************
    // Synchronizers for trigger pulse, external trigger intput
    always @ (posedge adc_clk)
        begin
            ft1<= force_trig_nosync;
            ft2<= ft1;
            force_trig <= ft2;

				eti1 <= ext_trig_in;
				eti2 <= eti1;
				ext_trig <= eti2;
			end

		  
		  
		  
    // *********************************************************
    // Used to switch data_valid_signals
    mux_8_to_1  data_valid_mux
    (
        .data0  (adcA_done),
        .data1  (adcB_done),
        .data2  (valid_filt_u1),
        .data3  (valid_filt_u2),
        .data4  (adc_go),
        .data5  (valid_filt_u1),
        .data6  (adcA_done),
        .data7  (adc_go),
        .sel    (fifo_data_select),
        .result (data_valid)
    );

    // *********************************************************
    // The trigger block ensures a complete read
    trigger_block trigger_block_inst
    (
        .clk                    (adc_clk),
        .reset_n                (reset_n),

        .data_valid             (data_valid),
        .trig_in                (~KEY[1] | (ext_trig_en & ext_trig)),
        .force_trig             (force_trig), // Pushbutton trigger

        .pre_trig_counter       (32'd128),
        .pre_trig_counter_value (),
        .post_trig_counter      (num_samples),

        .en_trig                (start),
        .delayed_trig           (delayed_trig)
    );

    // *********************************************************
    // SPI logic
    assign spi_miso = (ltc6954_sdo & (~ltc6954_cs)) | (linduino_miso & (~linduino_cs));
    assign ltc6954_sdi = spi_mosi;
    assign linduino_mosi = spi_mosi;
    assign ltc6954_sck = spi_sck;
    assign linduino_sck = spi_sck;

// Some additional control signals
wire sync_req_both, sync_req_u2, sync_req_u1, ext_trig_en;

    // *********************************************************
    // Initialize qsys generated system
    LTQsys_blob2 LTQsys_blob2_inst
    (
        .clk_clk                (clk),                               //         clk.clk
        .reset_reset_n          (!reset),                            //       reset.reset_n
        .hps_memory_mem_a       (hps_memory_mem_a),                  //  hps_memory.mem_a
        .hps_memory_mem_ba      (hps_memory_mem_ba),                 //            .mem_ba
        .hps_memory_mem_ck      (hps_memory_mem_ck),                 //            .mem_ck
        .hps_memory_mem_ck_n    (hps_memory_mem_ck_n),               //            .mem_ck_n
        .hps_memory_mem_cke     (hps_memory_mem_cke),                //            .mem_cke
        .hps_memory_mem_cs_n    (hps_memory_mem_cs_n),               //            .mem_cs_n
        .hps_memory_mem_ras_n   (hps_memory_mem_ras_n),              //            .mem_ras_n
        .hps_memory_mem_cas_n   (hps_memory_mem_cas_n),              //            .mem_cas_n
        .hps_memory_mem_we_n    (hps_memory_mem_we_n),               //            .mem_we_n
        .hps_memory_mem_reset_n (hps_memory_mem_reset_n),            //            .mem_reset_n
        .hps_memory_mem_dq      (hps_memory_mem_dq),                 //            .mem_dq
        .hps_memory_mem_dqs     (hps_memory_mem_dqs),                //            .mem_dqs
        .hps_memory_mem_dqs_n   (hps_memory_mem_dqs_n),              //            .mem_dqs_n
        .hps_memory_mem_odt     (hps_memory_mem_odt),                //            .mem_odt
        .hps_memory_mem_dm      (hps_memory_mem_dm),                 //            .mem_dm
        .hps_memory_oct_rzqin   (hps_memory_oct_rzqin),              //            .oct_rzqin
        .fpga_memory_mem_a      (fpga_memory_mem_a),                 // fpga_memory.mem_a
        .fpga_memory_mem_ba     (fpga_memory_mem_ba),                //            .mem_ba
        .fpga_memory_mem_ck     (fpga_memory_mem_ck),                //            .mem_ck
        .fpga_memory_mem_ck_n   (fpga_memory_mem_ck_n),              //            .mem_ck_n
        .fpga_memory_mem_cke    (fpga_memory_mem_cke),               //            .mem_cke
        .fpga_memory_mem_cs_n   (fpga_memory_mem_cs_n),              //            .mem_cs_n
        .fpga_memory_mem_dm     (fpga_memory_mem_dm),                //            .mem_dm
        .fpga_memory_mem_ras_n  (fpga_memory_mem_ras_n),             //            .mem_ras_n
        .fpga_memory_mem_cas_n  (fpga_memory_mem_cas_n),             //            .mem_cas_n
        .fpga_memory_mem_we_n   (fpga_memory_mem_we_n),              //            .mem_we_n
        .fpga_memory_mem_reset_n(fpga_memory_mem_reset_n),           //            .mem_reset_n
        .fpga_memory_mem_dq     (fpga_memory_mem_dq),                //            .mem_dq
        .fpga_memory_mem_dqs    (fpga_memory_mem_dqs),               //            .mem_dqs
        .fpga_memory_mem_dqs_n  (fpga_memory_mem_dqs_n),             //            .mem_dqs_n
        .fpga_memory_mem_odt    (fpga_memory_mem_odt),               //            .mem_odt
        .oct_rzqin              (oct_rzqin),                         //         oct.rzqin
        .mem_pll_pll_locked     (),                                  //            .pll_locked
        // User registers  .output_std_ctrl_export
        .rev_type_id_export     ({FPGA_REV, FPGA_TYPE}),             // rev_type_id.export
        .output_std_ctrl_export            ({22'b0, sync_req_both, sync_req_u2, sync_req_u1, ext_trig_en, lut_write_enable, ltc6954_sync , gpo1, gpo0, force_trig_nosync, start }),            //          output_std_ctrl.export
        .input_std_stat_export             ({29'b0, overflow, pll_lock, delayed_trig}),             //           input_std_stat.export
        .output_0x40_export                ({2'b0, n, cfg, 5'b0, LEDwire[0]}),                //              output_0x40.export
        .output_0x50_export                (num_samples),                //              output_0x50.export
        .output_0x60_export                ({16'b0, pid_kp}),                //              output_0x60.export
        .output_0x70_export                (pid_ki),                //              output_0x70.export
        .output_0x80_export                (pid_kd),                //              output_0x80.export
        .output_0x90_export                (pulse_low),                //              output_0x90.export
        .output_0xa0_export                (pulse_high),                //              output_0xa0.export
        .output_0xb0_export                (pulse_val),                //              output_0xb0.export
        .output_0xc0_export                ({lut_addr_div,system_clocks_per_sample}),                //              output_0xc0.export
        .output_0xd0_export                ({14'b0, setpoint_source_select,  lut_run_once, 1'b0, lut_addr_select[1:0], 2'b0, dac_a_select[1:0], 2'b0, dac_b_select[1:0],  1'b0, fifo_data_select[2:0]}), // First Order System model parameters
        .output_0xe0_export                ({lut_wraddress, lut_wrdata}),
        .output_0xf0_export                (tuning_word),  // DAC sinewave tuning word
        .input_0x100_export                ({2'b0, stop_address[29:0]}), // After capture, this is where to start reading
        // SPI port for configuring various things
        .spi_0_external_MISO               (spi_miso),               //           spi_0_external.MISO
        .spi_0_external_MOSI               (spi_mosi),               //                         .MOSI
        .spi_0_external_SCLK               (spi_sck),               //                         .SCLK
        .spi_0_external_SS_n               ({6'bz, linduino_cs, ltc6954_cs}),                //                         .SS_n
        .tie_me_off_data                    (8'bz),                    //                   tie_me_off.data
        .tie_me_off_valid                   (1'bz),                   //                             .valid
        .tie_me_off_ready                   (1'b0),                   //                             .ready
        .ltscope_data_input_data            (adc_fifo_data),            //           ltscope_data_input.data
        .ltscope_data_input_valid           (adc_fifo_valid),           //                             .valid
        .ltscope_data_input_ready           (adc_fifo_ready),           //                             .ready
        .ltscope_controller_ring_buff_go    (start),    //           ltscope_controller.ring_buff_go
        .ltscope_controller_ring_buff_addr  (stop_address),  //                             .ring_buff_addr
        .ltscope_controller_read_go         (1'b0),         //                             .read_go
        .ltscope_controller_read_start_addr (32'b0), //                             .read_start_addr
        .ltscope_controller_read_length     (32'b0),     //                             .read_length
        .ltscope_controller_read_done       (1'bz),        //                             .read_done
		  .i2c_outputs_export                 ({30'bz, scl_out, sda_out}),                 //        i2c_outputs.export
        .i2c_inputs_export                  ({30'b0, scl_in,  sda_in}) 
    );

wire sda_in, sda_out, scl_in, scl_out;
			 
tristate_iobuf	tristate_iobuf_sda (
	.datain ( 1'b0 ), // Data INTO the IO primitive... zero to emulate open-drain
	.oe ( ~sda_out ), // LOW to enable!!
	.dataio ( sda ), // The actual SDA pin
	.dataout ( sda_in ) // The state of the SDA signal
	);
tristate_iobuf	tristate_iobuf_scl (
	.datain ( 1'b0 ), // Data INTO the IO primitive... zero to emulate open-drain
	.oe ( ~scl_out ), // LOW to enable!!
	.dataio ( scl ),// The actual SCL pin
	.dataout ( scl_in ) // The actual state of the SCL signal
	);		


endmodule
