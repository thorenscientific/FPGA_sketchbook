// altera_jesd204.v

// Generated using ACDS version 14.0 200 at 2014.07.17.13:20:16

`timescale 1 ps / 1 ps
module altera_jesd204 (
		input  wire         tx_pll_ref_clk,             //            tx_pll_ref_clk.clk
		input  wire         txlink_clk,                 //                txlink_clk.clk
		input  wire         txlink_rst_n_reset_n,       //              txlink_rst_n.reset_n
		input  wire         jesd204_tx_avs_clk,         //        jesd204_tx_avs_clk.clk
		input  wire         jesd204_tx_avs_rst_n,       //      jesd204_tx_avs_rst_n.reset_n
		input  wire         jesd204_tx_avs_chipselect,  //            jesd204_tx_avs.chipselect
		input  wire [7:0]   jesd204_tx_avs_address,     //                          .address
		input  wire         jesd204_tx_avs_read,        //                          .read
		output wire [31:0]  jesd204_tx_avs_readdata,    //                          .readdata
		output wire         jesd204_tx_avs_waitrequest, //                          .waitrequest
		input  wire         jesd204_tx_avs_write,       //                          .write
		input  wire [31:0]  jesd204_tx_avs_writedata,   //                          .writedata
		input  wire [63:0]  jesd204_tx_link_data,       //           jesd204_tx_link.data
		input  wire         jesd204_tx_link_valid,      //                          .valid
		output wire         jesd204_tx_link_ready,      //                          .ready
		output wire         jesd204_tx_int,             //            jesd204_tx_int.export
		input  wire         tx_sysref,                  //                 tx_sysref.export
		input  wire         sync_n,                     //                    sync_n.export
		output wire         tx_dev_sync_n,              //             tx_dev_sync_n.export
		input  wire         mdev_sync_n,                //               mdev_sync_n.export
		output wire         jesd204_tx_frame_ready,     //    jesd204_tx_frame_ready.export
		output wire [4:0]   tx_csr_l,                   //                  tx_csr_l.export
		output wire [7:0]   tx_csr_f,                   //                  tx_csr_f.export
		output wire [4:0]   tx_csr_k,                   //                  tx_csr_k.export
		output wire [7:0]   tx_csr_m,                   //                  tx_csr_m.export
		output wire [1:0]   tx_csr_cs,                  //                 tx_csr_cs.export
		output wire [4:0]   tx_csr_n,                   //                  tx_csr_n.export
		output wire [4:0]   tx_csr_np,                  //                 tx_csr_np.export
		output wire [4:0]   tx_csr_s,                   //                  tx_csr_s.export
		output wire         tx_csr_hd,                  //                 tx_csr_hd.export
		output wire [4:0]   tx_csr_cf,                  //                 tx_csr_cf.export
		output wire [1:0]   tx_csr_lane_powerdown,      //     tx_csr_lane_powerdown.export
		output wire [3:0]   csr_tx_testmode,            //           csr_tx_testmode.export
		output wire [31:0]  csr_tx_testpattern_a,       //      csr_tx_testpattern_a.export
		output wire [31:0]  csr_tx_testpattern_b,       //      csr_tx_testpattern_b.export
		output wire [31:0]  csr_tx_testpattern_c,       //      csr_tx_testpattern_c.export
		output wire [31:0]  csr_tx_testpattern_d,       //      csr_tx_testpattern_d.export
		input  wire         jesd204_tx_frame_error,     //    jesd204_tx_frame_error.export
		output wire [63:0]  jesd204_tx_dlb_data,        //       jesd204_tx_dlb_data.export
		output wire [7:0]   jesd204_tx_dlb_kchar_data,  // jesd204_tx_dlb_kchar_data.export
		output wire [1:0]   txphy_clk,                  //                 txphy_clk.tx_std_clkout
		output wire [1:0]   tx_serial_data,             //            tx_serial_data.tx_serial_data
		input  wire [0:0]   pll_powerdown,              //             pll_powerdown.pll_powerdown
		input  wire [1:0]   tx_analogreset,             //            tx_analogreset.tx_analogreset
		input  wire [1:0]   tx_digitalreset,            //           tx_digitalreset.tx_digitalreset
		output wire [1:0]   pll_locked,                 //                pll_locked.export
		output wire [1:0]   tx_cal_busy,                //               tx_cal_busy.export
		input  wire         rx_pll_ref_clk,             //            rx_pll_ref_clk.clk
		input  wire         rxlink_clk,                 //                rxlink_clk.clk
		input  wire         rxlink_rst_n_reset_n,       //              rxlink_rst_n.reset_n
		input  wire         jesd204_rx_avs_clk,         //        jesd204_rx_avs_clk.clk
		input  wire         jesd204_rx_avs_rst_n,       //      jesd204_rx_avs_rst_n.reset_n
		input  wire         jesd204_rx_avs_chipselect,  //            jesd204_rx_avs.chipselect
		input  wire [7:0]   jesd204_rx_avs_address,     //                          .address
		input  wire         jesd204_rx_avs_read,        //                          .read
		output wire [31:0]  jesd204_rx_avs_readdata,    //                          .readdata
		output wire         jesd204_rx_avs_waitrequest, //                          .waitrequest
		input  wire         jesd204_rx_avs_write,       //                          .write
		input  wire [31:0]  jesd204_rx_avs_writedata,   //                          .writedata
		output wire [63:0]  jesd204_rx_link_data,       //           jesd204_rx_link.data
		output wire         jesd204_rx_link_valid,      //                          .valid
		input  wire         jesd204_rx_link_ready,      //                          .ready
		input  wire [63:0]  jesd204_rx_dlb_data,        //       jesd204_rx_dlb_data.export
		input  wire [1:0]   jesd204_rx_dlb_data_valid,  // jesd204_rx_dlb_data_valid.export
		input  wire [7:0]   jesd204_rx_dlb_kchar_data,  // jesd204_rx_dlb_kchar_data.export
		input  wire [7:0]   jesd204_rx_dlb_errdetect,   //  jesd204_rx_dlb_errdetect.export
		input  wire [7:0]   jesd204_rx_dlb_disperr,     //    jesd204_rx_dlb_disperr.export
		input  wire         alldev_lane_aligned,        //       alldev_lane_aligned.export
		input  wire         rx_sysref,                  //                 rx_sysref.export
		input  wire         jesd204_rx_frame_error,     //    jesd204_rx_frame_error.export
		output wire         jesd204_rx_int,             //            jesd204_rx_int.export
		output wire [3:0]   csr_rx_testmode,            //           csr_rx_testmode.export
		output wire         dev_lane_aligned,           //          dev_lane_aligned.export
		output wire         rx_dev_sync_n,              //             rx_dev_sync_n.export
		output wire [3:0]   rx_sof,                     //                    rx_sof.export
		output wire [3:0]   rx_somf,                    //                   rx_somf.export
		output wire [7:0]   rx_csr_f,                   //                  rx_csr_f.export
		output wire [4:0]   rx_csr_k,                   //                  rx_csr_k.export
		output wire [4:0]   rx_csr_l,                   //                  rx_csr_l.export
		output wire [7:0]   rx_csr_m,                   //                  rx_csr_m.export
		output wire [4:0]   rx_csr_n,                   //                  rx_csr_n.export
		output wire [4:0]   rx_csr_s,                   //                  rx_csr_s.export
		output wire [4:0]   rx_csr_cf,                  //                 rx_csr_cf.export
		output wire [1:0]   rx_csr_cs,                  //                 rx_csr_cs.export
		output wire         rx_csr_hd,                  //                 rx_csr_hd.export
		output wire [4:0]   rx_csr_np,                  //                 rx_csr_np.export
		output wire [1:0]   rx_csr_lane_powerdown,      //     rx_csr_lane_powerdown.export
		output wire [1:0]   rxphy_clk,                  //                 rxphy_clk.rx_std_clkout
		input  wire [1:0]   rx_serial_data,             //            rx_serial_data.rx_serial_data
		input  wire [1:0]   rx_analogreset,             //            rx_analogreset.rx_analogreset
		input  wire [1:0]   rx_digitalreset,            //           rx_digitalreset.rx_digitalreset
		input  wire [209:0] reconfig_to_xcvr,           //          reconfig_to_xcvr.reconfig_to_xcvr
		output wire [137:0] reconfig_from_xcvr,         //        reconfig_from_xcvr.reconfig_from_xcvr
		output wire [1:0]   rx_islockedtodata,          //         rx_islockedtodata.export
		output wire [1:0]   rx_cal_busy,                //               rx_cal_busy.export
		input  wire [1:0]   rx_seriallpbken             //           rx_seriallpbken.rx_seriallpbken
	);

	altera_jesd204_0001 #(
		.DEVICE_FAMILY            ("Arria V"),
		.SUBCLASSV                (1),
		.PCS_CONFIG               ("JESD_PCS_CFG1"),
		.L                        (2),
		.M                        (2),
		.F                        (2),
		.N                        (14),
		.N_PRIME                  (16),
		.S                        (1),
		.K                        (32),
		.SCR                      (1),
		.CS                       (0),
		.CF                       (0),
		.HD                       (0),
		.ECC_EN                   (1),
		.DLB_TEST                 (0),
		.PHADJ                    (0),
		.ADJCNT                   (0),
		.ADJDIR                   (0),
		.OPTIMIZE                 (0),
		.DID                      (0),
		.BID                      (0),
		.LID0                     (0),
		.FCHK0                    (65),
		.LID1                     (1),
		.FCHK1                    (66),
		.LID2                     (2),
		.FCHK2                    (0),
		.LID3                     (3),
		.FCHK3                    (0),
		.LID4                     (4),
		.FCHK4                    (0),
		.LID5                     (5),
		.FCHK5                    (0),
		.LID6                     (6),
		.FCHK6                    (0),
		.LID7                     (7),
		.FCHK7                    (0),
		.JESDV                    (1),
		.PMA_WIDTH                (32),
		.SER_SIZE                 (4),
		.FK                       (64),
		.RES1                     (0),
		.RES2                     (0),
		.BIT_REVERSAL             (0),
		.BYTE_REVERSAL            (0),
		.ALIGNMENT_PATTERN        (658812),
		.PULSE_WIDTH              (2),
		.LS_FIFO_DEPTH            (32),
		.LS_FIFO_WIDTHU           (5),
		.UNUSED_TX_PARALLEL_WIDTH (8),
		.UNUSED_RX_PARALLEL_WIDTH (8),
		.XCVR_PLL_LOCKED_WIDTH    (1)
	) altera_jesd204_inst (
		.tx_pll_ref_clk             (tx_pll_ref_clk),             //            tx_pll_ref_clk.clk
		.txlink_clk                 (txlink_clk),                 //                txlink_clk.clk
		.txlink_rst_n_reset_n       (txlink_rst_n_reset_n),       //              txlink_rst_n.reset_n
		.jesd204_tx_avs_clk         (jesd204_tx_avs_clk),         //        jesd204_tx_avs_clk.clk
		.jesd204_tx_avs_rst_n       (jesd204_tx_avs_rst_n),       //      jesd204_tx_avs_rst_n.reset_n
		.jesd204_tx_avs_chipselect  (jesd204_tx_avs_chipselect),  //            jesd204_tx_avs.chipselect
		.jesd204_tx_avs_address     (jesd204_tx_avs_address),     //                          .address
		.jesd204_tx_avs_read        (jesd204_tx_avs_read),        //                          .read
		.jesd204_tx_avs_readdata    (jesd204_tx_avs_readdata),    //                          .readdata
		.jesd204_tx_avs_waitrequest (jesd204_tx_avs_waitrequest), //                          .waitrequest
		.jesd204_tx_avs_write       (jesd204_tx_avs_write),       //                          .write
		.jesd204_tx_avs_writedata   (jesd204_tx_avs_writedata),   //                          .writedata
		.jesd204_tx_link_data       (jesd204_tx_link_data),       //           jesd204_tx_link.data
		.jesd204_tx_link_valid      (jesd204_tx_link_valid),      //                          .valid
		.jesd204_tx_link_ready      (jesd204_tx_link_ready),      //                          .ready
		.jesd204_tx_int             (jesd204_tx_int),             //            jesd204_tx_int.export
		.tx_sysref                  (tx_sysref),                  //                 tx_sysref.export
		.sync_n                     (sync_n),                     //                    sync_n.export
		.tx_dev_sync_n              (tx_dev_sync_n),              //             tx_dev_sync_n.export
		.mdev_sync_n                (mdev_sync_n),                //               mdev_sync_n.export
		.jesd204_tx_frame_ready     (jesd204_tx_frame_ready),     //    jesd204_tx_frame_ready.export
		.tx_csr_l                   (tx_csr_l),                   //                  tx_csr_l.export
		.tx_csr_f                   (tx_csr_f),                   //                  tx_csr_f.export
		.tx_csr_k                   (tx_csr_k),                   //                  tx_csr_k.export
		.tx_csr_m                   (tx_csr_m),                   //                  tx_csr_m.export
		.tx_csr_cs                  (tx_csr_cs),                  //                 tx_csr_cs.export
		.tx_csr_n                   (tx_csr_n),                   //                  tx_csr_n.export
		.tx_csr_np                  (tx_csr_np),                  //                 tx_csr_np.export
		.tx_csr_s                   (tx_csr_s),                   //                  tx_csr_s.export
		.tx_csr_hd                  (tx_csr_hd),                  //                 tx_csr_hd.export
		.tx_csr_cf                  (tx_csr_cf),                  //                 tx_csr_cf.export
		.tx_csr_lane_powerdown      (tx_csr_lane_powerdown),      //     tx_csr_lane_powerdown.export
		.csr_tx_testmode            (csr_tx_testmode),            //           csr_tx_testmode.export
		.csr_tx_testpattern_a       (csr_tx_testpattern_a),       //      csr_tx_testpattern_a.export
		.csr_tx_testpattern_b       (csr_tx_testpattern_b),       //      csr_tx_testpattern_b.export
		.csr_tx_testpattern_c       (csr_tx_testpattern_c),       //      csr_tx_testpattern_c.export
		.csr_tx_testpattern_d       (csr_tx_testpattern_d),       //      csr_tx_testpattern_d.export
		.jesd204_tx_frame_error     (jesd204_tx_frame_error),     //    jesd204_tx_frame_error.export
		.jesd204_tx_dlb_data        (jesd204_tx_dlb_data),        //       jesd204_tx_dlb_data.export
		.jesd204_tx_dlb_kchar_data  (jesd204_tx_dlb_kchar_data),  // jesd204_tx_dlb_kchar_data.export
		.txphy_clk                  (txphy_clk),                  //                 txphy_clk.tx_std_clkout
		.tx_serial_data             (tx_serial_data),             //            tx_serial_data.tx_serial_data
		.pll_powerdown              (pll_powerdown),              //             pll_powerdown.pll_powerdown
		.tx_analogreset             (tx_analogreset),             //            tx_analogreset.tx_analogreset
		.tx_digitalreset            (tx_digitalreset),            //           tx_digitalreset.tx_digitalreset
		.pll_locked                 (pll_locked),                 //                pll_locked.export
		.tx_cal_busy                (tx_cal_busy),                //               tx_cal_busy.export
		.rx_pll_ref_clk             (rx_pll_ref_clk),             //            rx_pll_ref_clk.clk
		.rxlink_clk                 (rxlink_clk),                 //                rxlink_clk.clk
		.rxlink_rst_n_reset_n       (rxlink_rst_n_reset_n),       //              rxlink_rst_n.reset_n
		.jesd204_rx_avs_clk         (jesd204_rx_avs_clk),         //        jesd204_rx_avs_clk.clk
		.jesd204_rx_avs_rst_n       (jesd204_rx_avs_rst_n),       //      jesd204_rx_avs_rst_n.reset_n
		.jesd204_rx_avs_chipselect  (jesd204_rx_avs_chipselect),  //            jesd204_rx_avs.chipselect
		.jesd204_rx_avs_address     (jesd204_rx_avs_address),     //                          .address
		.jesd204_rx_avs_read        (jesd204_rx_avs_read),        //                          .read
		.jesd204_rx_avs_readdata    (jesd204_rx_avs_readdata),    //                          .readdata
		.jesd204_rx_avs_waitrequest (jesd204_rx_avs_waitrequest), //                          .waitrequest
		.jesd204_rx_avs_write       (jesd204_rx_avs_write),       //                          .write
		.jesd204_rx_avs_writedata   (jesd204_rx_avs_writedata),   //                          .writedata
		.jesd204_rx_link_data       (jesd204_rx_link_data),       //           jesd204_rx_link.data
		.jesd204_rx_link_valid      (jesd204_rx_link_valid),      //                          .valid
		.jesd204_rx_link_ready      (jesd204_rx_link_ready),      //                          .ready
		.jesd204_rx_dlb_data        (jesd204_rx_dlb_data),        //       jesd204_rx_dlb_data.export
		.jesd204_rx_dlb_data_valid  (jesd204_rx_dlb_data_valid),  // jesd204_rx_dlb_data_valid.export
		.jesd204_rx_dlb_kchar_data  (jesd204_rx_dlb_kchar_data),  // jesd204_rx_dlb_kchar_data.export
		.jesd204_rx_dlb_errdetect   (jesd204_rx_dlb_errdetect),   //  jesd204_rx_dlb_errdetect.export
		.jesd204_rx_dlb_disperr     (jesd204_rx_dlb_disperr),     //    jesd204_rx_dlb_disperr.export
		.alldev_lane_aligned        (alldev_lane_aligned),        //       alldev_lane_aligned.export
		.rx_sysref                  (rx_sysref),                  //                 rx_sysref.export
		.jesd204_rx_frame_error     (jesd204_rx_frame_error),     //    jesd204_rx_frame_error.export
		.jesd204_rx_int             (jesd204_rx_int),             //            jesd204_rx_int.export
		.csr_rx_testmode            (csr_rx_testmode),            //           csr_rx_testmode.export
		.dev_lane_aligned           (dev_lane_aligned),           //          dev_lane_aligned.export
		.rx_dev_sync_n              (rx_dev_sync_n),              //             rx_dev_sync_n.export
		.rx_sof                     (rx_sof),                     //                    rx_sof.export
		.rx_somf                    (rx_somf),                    //                   rx_somf.export
		.rx_csr_f                   (rx_csr_f),                   //                  rx_csr_f.export
		.rx_csr_k                   (rx_csr_k),                   //                  rx_csr_k.export
		.rx_csr_l                   (rx_csr_l),                   //                  rx_csr_l.export
		.rx_csr_m                   (rx_csr_m),                   //                  rx_csr_m.export
		.rx_csr_n                   (rx_csr_n),                   //                  rx_csr_n.export
		.rx_csr_s                   (rx_csr_s),                   //                  rx_csr_s.export
		.rx_csr_cf                  (rx_csr_cf),                  //                 rx_csr_cf.export
		.rx_csr_cs                  (rx_csr_cs),                  //                 rx_csr_cs.export
		.rx_csr_hd                  (rx_csr_hd),                  //                 rx_csr_hd.export
		.rx_csr_np                  (rx_csr_np),                  //                 rx_csr_np.export
		.rx_csr_lane_powerdown      (rx_csr_lane_powerdown),      //     rx_csr_lane_powerdown.export
		.rxphy_clk                  (rxphy_clk),                  //                 rxphy_clk.rx_std_clkout
		.rx_serial_data             (rx_serial_data),             //            rx_serial_data.rx_serial_data
		.rx_analogreset             (rx_analogreset),             //            rx_analogreset.rx_analogreset
		.rx_digitalreset            (rx_digitalreset),            //           rx_digitalreset.rx_digitalreset
		.reconfig_to_xcvr           (reconfig_to_xcvr),           //          reconfig_to_xcvr.reconfig_to_xcvr
		.reconfig_from_xcvr         (reconfig_from_xcvr),         //        reconfig_from_xcvr.reconfig_from_xcvr
		.rx_islockedtodata          (rx_islockedtodata),          //         rx_islockedtodata.export
		.rx_cal_busy                (rx_cal_busy),                //               rx_cal_busy.export
		.rx_seriallpbken            (rx_seriallpbken)             //           rx_seriallpbken.rx_seriallpbken
	);

endmodule