

//   ===========================================================================
//   >>>>>>>>>>>>>>>>>>>>>>> COPYRIGHT NOTICE <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
//   ---------------------------------------------------------------------------
//   Copyright (c) 2016 by Lattice Semiconductor Corporation
//   ALL RIGHTS RESERVED
//   ------------------------------------------------------------------
//
//   Permission:
//
//      Lattice SG Pte. Ltd. grants permission to use this code
//      pursuant to the terms of the Lattice Reference Design License Agreement.
//
//
//   Disclaimer:
//
//      This VHDL or Verilog source code is intended as a design reference
//      which illustrates how these types of functions can be implemented.
//      It is the user's responsibility to verify their design for
//      consistency and functionality through the use of formal
//      verification methods.  Lattice provides no warranty
//      regarding the use or functionality of this code.
//
//   ---------------------------------------------------------------------------
//
//                  Lattice SG Pte. Ltd.
//                  101 Thomson Road, United Square #07-02
//                  Singapore 307591
//
//
//                  TEL: 1-800-Lattice (USA and Canada)
//                       +65-6631-2000 (Singapore)
//                       +1-503-268-8001 (other locations)
//
//                  web: http://www.latticesemi.com/
//                  email: techsupport@latticesemi.com
//
//   ---------------------------------------------------------------------------
//
// =============================================================================
//                         FILE DETAILS
// Project               : RSL- Reset Sequence Logic
// File                  : rsl_core.v
// Title                 : Top-level file for RSL
// Dependencies          : 1.
//                       : 2.
// Description           :
// =============================================================================
//                        REVISION HISTORY
// Version               : 1.0
// Author(s)             : BM
// Mod. Date             : October 28, 2013
// Changes Made          : Initial Creation
// -----------------------------------------------------------------------------
// Version               : 1.1
// Author(s)             : BM
// Mod. Date             : November 06, 2013
// Changes Made          : Tx/Rx separation, ready port code exclusion
// -----------------------------------------------------------------------------
// Version               : 1.2
// Author(s)             : BM
// Mod. Date             : June 13, 2014
// Changes Made          : Updated Rx PCS reset method
// -----------------------------------------------------------------------------
// -----------------------------------------------------------------------------
// Version               : 1.3
// Author(s)             : UA
// Mod. Date             : Dec 19, 2014
// Changes Made          : Added new parameter fro PCIE
// -----------------------------------------------------------------------------
// Version               : 1.31
// Author(s)             : BM/UM
// Mod. Date             : Feb 23, 2016
// Changes Made          : Behavior of rx_rdy output modified. The output rx_rdy
//                         and the rx_rdy wait counter are reset to zero on
//                         LOL or LOS. Reverted back the counter value change for PCIE.
// -----------------------------------------------------------------------------
// Version               : 1.4
// Author(s)             : EB
// Mod. Date:            : March 21, 2017
// Changes Made          :
// -----------------------------------------------------------------------------
// Version               : 1.5
// Author(s)             : ES
// Mod. Date:            : May 8, 2017
// Changes Made          : Implemented common RSL behaviour as proposed by BM.
// =============================================================================

`timescale 1ns/10ps

module x_pcie_pcsrsl_core (
      // ------------ Inputs
      // Common
      rui_rst,               // Active high reset for the RSL module
      rui_serdes_rst_dual_c, // SERDES macro reset user command
      rui_rst_dual_c,        // PCS dual reset user command
      rui_rsl_disable,       // Active high signal that disables all reset outputs of RSL
      // Tx
      rui_tx_ref_clk,        // Tx reference clock
      rui_tx_serdes_rst_c,   // Tx SERDES reset user command
      rui_tx_pcs_rst_c,      // Tx lane reset user command
      rdi_pll_lol,           // Tx PLL Loss of Lock status input from the SERDES
      // Rx
      rui_rx_ref_clk,        // Rx reference clock
      rui_rx_serdes_rst_c,   // SERDES Receive channel reset user command
      rui_rx_pcs_rst_c,      // Rx lane reset user command
      rdi_rx_los_low_s,      // Receive loss of signal status input from SERDES
      rdi_rx_cdr_lol_s,      // Receive CDR loss of lock status input from SERDES

      // ------------ Outputs
      // Common
      rdo_serdes_rst_dual_c, // SERDES macro reset command output
      rdo_rst_dual_c,        // PCS dual reset command output
      // Tx
      ruo_tx_rdy,            // Tx lane ready status output
      rdo_tx_serdes_rst_c,   // SERDES Tx reset command output
      rdo_tx_pcs_rst_c,      // PCS Tx lane reset command output
      // Rx
      ruo_rx_rdy,            // Rx lane ready status output
      rdo_rx_serdes_rst_c,   // SERDES Rx channel reset command output
      rdo_rx_pcs_rst_c       // PCS Rx lane reset command output
      );

// ------------ Module parameters
`ifdef NUM_CHANNELS
   parameter pnum_channels = `NUM_CHANNELS;    // 1,2,4
`else
   parameter pnum_channels = 1;
`endif

`ifdef PCIE
   parameter pprotocol    = "PCIE";
`else
   parameter pprotocol    = "";
`endif

`ifdef RX_ONLY
   parameter pserdes_mode    = "RX ONLY";
`else
   `ifdef TX_ONLY
      parameter pserdes_mode = "TX ONLY";
   `else
      parameter pserdes_mode = "RX AND TX";
   `endif
`endif

`ifdef PORT_TX_RDY
   parameter pport_tx_rdy = "ENABLED";
`else
   parameter pport_tx_rdy = "DISABLED";
`endif

`ifdef WAIT_TX_RDY
   parameter pwait_tx_rdy = `WAIT_TX_RDY;
`else
   parameter pwait_tx_rdy = 3000;
`endif

`ifdef PORT_RX_RDY
   parameter pport_rx_rdy = "ENABLED";
`else
   parameter pport_rx_rdy = "DISABLED";
`endif

`ifdef WAIT_RX_RDY
   parameter pwait_rx_rdy = `WAIT_RX_RDY;
`else
   parameter pwait_rx_rdy = 3000;
`endif

// ------------ Local parameters
   localparam wa_num_cycles      = 1024;
   localparam dac_num_cycles     = 3;
   localparam lreset_pwidth      = 3;      // reset pulse width-1, default=4-1=3
   localparam lwait_b4_trst      = 781250; // 5ms wait with worst-case Fmax=156 MHz
   localparam lwait_b4_trst_s    = 781;    // for simulation
   localparam lplol_cnt_width    = 20;     // width for lwait_b4_trst
   localparam lwait_after_plol0  = 4;
   localparam lwait_b4_rrst      = 180224; // total calibration time
   localparam lrrst_wait_width   = 20;
   localparam lwait_after_rrst   = 800000; // For CPRI- unused
   localparam lwait_b4_rrst_s    = 460;    // wait cycles provided by design team
   localparam lrlol_cnt_width    = 19;     // width for lwait_b4_rrst
   localparam lwait_after_lols   = (16384 * dac_num_cycles) + wa_num_cycles;  // 16384 cycles * dac_num_cycles + 1024 cycles
   localparam lwait_after_lols_s = 150;    // wait cycles provided by design team
   localparam llols_cnt_width    = 18;     // lols count width
   localparam lrdb_max           = 15;     // maximum debounce count
   localparam ltxr_wait_width    = 12;     // width of tx ready wait counter
   localparam lrxr_wait_width    = 12;     // width of tx ready wait counter

// ------------ input ports
   input                         rui_rst;
   input                         rui_serdes_rst_dual_c;
   input                         rui_rst_dual_c;
   input                         rui_rsl_disable;

   input                         rui_tx_ref_clk;
   input                         rui_tx_serdes_rst_c;
   input  [3:0]                  rui_tx_pcs_rst_c;
   input                         rdi_pll_lol;

   input                         rui_rx_ref_clk;
   input  [3:0]                  rui_rx_serdes_rst_c;
   input  [3:0]                  rui_rx_pcs_rst_c;
   input  [3:0]                  rdi_rx_los_low_s;
   input  [3:0]                  rdi_rx_cdr_lol_s;

// ------------ output ports
   output                        rdo_serdes_rst_dual_c;
   output                        rdo_rst_dual_c;

   output                        ruo_tx_rdy;
   output                        rdo_tx_serdes_rst_c;
   output [3:0]                  rdo_tx_pcs_rst_c;

   output                        ruo_rx_rdy;
   output [3:0]                  rdo_rx_serdes_rst_c;
   output [3:0]                  rdo_rx_pcs_rst_c;

// ------------ Internal registers and wires
   // inputs
   wire                          rui_rst;
   wire                          rui_serdes_rst_dual_c;
   wire                          rui_rst_dual_c;
   wire                          rui_rsl_disable;
   wire                          rui_tx_ref_clk;
   wire                          rui_tx_serdes_rst_c;
   wire   [3:0]                  rui_tx_pcs_rst_c;
   wire                          rdi_pll_lol;
   wire                          rui_rx_ref_clk;
   wire   [3:0]                  rui_rx_serdes_rst_c;
   wire   [3:0]                  rui_rx_pcs_rst_c;
   wire   [3:0]                  rdi_rx_los_low_s;
   wire   [3:0]                  rdi_rx_cdr_lol_s;

   // outputs
   wire                          rdo_serdes_rst_dual_c;
   wire                          rdo_rst_dual_c;
   wire                          ruo_tx_rdy;
   wire                          rdo_tx_serdes_rst_c;
   wire   [3:0]                  rdo_tx_pcs_rst_c;
   wire                          ruo_rx_rdy;
   wire   [3:0]                  rdo_rx_serdes_rst_c;
   wire   [3:0]                  rdo_rx_pcs_rst_c;

   // internal signals
   // common
   wire                          rsl_enable;
   wire   [lplol_cnt_width-1:0]  wait_b4_trst;
   wire   [lrlol_cnt_width-1:0]  wait_b4_rrst;
   wire   [llols_cnt_width-1:0]  wait_after_lols;
   reg                           pll_lol_p1;
   reg                           pll_lol_p2;
   reg                           pll_lol_p3;
   // ------------ Tx
   // rdo_tx_serdes_rst_c
   reg    [lplol_cnt_width-1:0]  plol_cnt;
   wire                          plol_cnt_tc;

   reg    [2:0]                  txs_cnt;
   reg                           txs_rst;
   wire                          txs_cnt_tc;
   // rdo_tx_pcs_rst_c
   wire                          plol_fedge;
   wire                          plol_redge;
   reg                           waita_plol0;
   reg    [2:0]                  plol0_cnt;
   wire                          plol0_cnt_tc;
   reg    [2:0]                  txp_cnt;
   reg                           txp_rst;
   wire                          txp_cnt_tc;
   // ruo_tx_rdy
   wire                          dual_or_serd_rst;
   wire                          tx_any_pcs_rst;
   wire                          tx_any_rst;
   reg                           txsr_appd /* synthesis syn_keep=1 */;
   reg                           txdpr_appd;
   reg    [pnum_channels-1:0]    txpr_appd;
   reg                           txr_wt_en;
   reg    [ltxr_wait_width-1:0]  txr_wt_cnt;
   wire                          txr_wt_tc;
   reg                           ruo_tx_rdyr;

   // ------------ Rx
   wire                          comb_rlos;
   wire                          comb_rlol;
   //wire                          rlols;
   wire                          rx_all_well;

   //reg                           rlols_p1;
   //reg                           rlols_p2;
   //reg                           rlols_p3;

   reg                           rlol_p1;
   reg                           rlol_p2;
   reg                           rlol_p3;
   reg                           rlos_p1;
   reg                           rlos_p2;
   reg                           rlos_p3;

   //reg    [3:0]                  rdb_cnt;
   //wire                          rdb_cnt_max;
   //wire                          rdb_cnt_zero;
   //reg                           rlols_db;
   //reg                           rlols_db_p1;

   reg    [3:0]                  rlol_db_cnt;
   wire                          rlol_db_cnt_max;
   wire                          rlol_db_cnt_zero;
   reg                           rlol_db;
   reg 	                         rlol_db_p1;

   reg    [3:0]                  rlos_db_cnt;
   wire                          rlos_db_cnt_max;
   wire                          rlos_db_cnt_zero;
   reg                           rlos_db;
   reg 	                         rlos_db_p1;

   // rdo_rx_serdes_rst_c
   reg    [lrlol_cnt_width-1:0]  rlol1_cnt;
   wire                          rlol1_cnt_tc;
   reg    [2:0]                  rxs_cnt;
   reg                           rxs_rst;
   wire                          rxs_cnt_tc;
   reg    [lrrst_wait_width-1:0] rrst_cnt;
   wire                          rrst_cnt_tc;
   reg                           rrst_wait;
   // rdo_rx_pcs_rst_c
   //wire                          rlols_fedge;
   //wire                          rlols_redge;
   wire                          rlol_fedge;
   wire                          rlol_redge;
   wire                          rlos_fedge;
   wire                          rlos_redge;

   reg                           wait_calib;
   reg                           waita_rlols0;
   reg    [llols_cnt_width-1:0]  rlols0_cnt;
   wire                          rlols0_cnt_tc;
   reg    [2:0]                  rxp_cnt;
   reg                           rxp_rst;
   wire                          rxp_cnt_tc;

   wire                          rx_any_serd_rst;
   reg    [llols_cnt_width-1:0]  rlolsz_cnt;
   wire                          rlolsz_cnt_tc;
   reg [2:0] 			 rxp_cnt2;
   reg                           rxp_rst2;
   wire                          rxp_cnt2_tc;
   reg [15:0]                    data_loop_b_cnt;
   reg                           data_loop_b;
   wire                          data_loop_b_tc;

   // ruo_rx_rdy
   reg    [pnum_channels-1:0]    rxsr_appd;
   reg    [pnum_channels-1:0]    rxpr_appd;
   reg                           rxsdr_appd /* synthesis syn_keep=1 */;
   reg                           rxdpr_appd;
   wire                          rxsdr_or_sr_appd;
   wire                          dual_or_rserd_rst;
   wire                          rx_any_pcs_rst;
   wire                          rx_any_rst;
   reg                           rxr_wt_en;
   reg    [lrxr_wait_width-1:0]  rxr_wt_cnt;
   wire                          rxr_wt_tc;
   reg                           ruo_rx_rdyr;

// ==================================================================
//                          Start of code
// ==================================================================
   assign rsl_enable = ~rui_rsl_disable;

// ------------ rdo_serdes_rst_dual_c
   assign rdo_serdes_rst_dual_c = (rui_rst&rsl_enable) | rui_serdes_rst_dual_c;

// ------------ rdo_rst_dual_c
   assign rdo_rst_dual_c = rui_rst_dual_c;

// ------------ Setting counter values for RSL_SIM_MODE
   `ifdef RSL_SIM_MODE
      assign wait_b4_trst    = lwait_b4_trst_s;
      assign wait_b4_rrst    = lwait_b4_rrst_s;
      assign wait_after_lols = lwait_after_lols_s;
   `else
      assign wait_b4_trst    = lwait_b4_trst;
      assign wait_b4_rrst    = lwait_b4_rrst;
      assign wait_after_lols = lwait_after_lols;
   `endif

// ==================================================================
//                                 Tx
// ==================================================================
   generate
   if((pserdes_mode=="RX AND TX")||(pserdes_mode=="TX ONLY")) begin

// ------------ Synchronizing pll_lol to the tx clock
   always @(posedge rui_tx_ref_clk or posedge rui_rst) begin
      if(rui_rst==1'b1) begin
         pll_lol_p1 <= 1'd0;
         pll_lol_p2 <= 1'd0;
         pll_lol_p3 <= 1'd0;
      end
      else begin
         pll_lol_p1 <= rdi_pll_lol;
         pll_lol_p2 <= pll_lol_p1;
         pll_lol_p3 <= pll_lol_p2;
      end
   end

// ------------ rdo_tx_serdes_rst_c
   always @(posedge rui_tx_ref_clk or posedge rui_rst) begin
      if(rui_rst==1'b1)
         plol_cnt    <= 'd0;
      else if((pll_lol_p2==0)||(plol_cnt_tc==1)||(rdo_tx_serdes_rst_c==1))
         plol_cnt    <= 'd0;
      else
         plol_cnt    <= plol_cnt+1;
   end
   assign plol_cnt_tc = (plol_cnt==wait_b4_trst)?1'b1:1'b0;

   always @(posedge rui_tx_ref_clk or posedge rui_rst) begin
      if(rui_rst==1'b1) begin
         txs_cnt  <= 'd0;   // tx serdes reset pulse count
         txs_rst  <= 1'b0;  // tx serdes reset
      end
      else if(plol_cnt_tc==1)
         txs_rst  <= 1'b1;
      else if(txs_cnt_tc==1) begin
         txs_cnt  <= 'd0;
         txs_rst  <= 1'b0;
      end
      else if(txs_rst==1)
         txs_cnt  <= txs_cnt+1;
   end
   assign txs_cnt_tc = (txs_cnt==lreset_pwidth)?1'b1:1'b0;

   assign rdo_tx_serdes_rst_c = (rsl_enable&txs_rst)| rui_tx_serdes_rst_c;

// ------------ rdo_tx_pcs_rst_c
   assign plol_fedge = ~pll_lol_p2 & pll_lol_p3;
   assign plol_redge = pll_lol_p2 & ~pll_lol_p3;
   always @(posedge rui_tx_ref_clk or posedge rui_rst) begin
      if(rui_rst==1'b1)
         waita_plol0  <= 1'd0;
      else if(plol_fedge==1'b1)
         waita_plol0  <= 1'b1;
      else if((plol0_cnt_tc==1)||(plol_redge==1))
         waita_plol0  <= 1'd0;
   end
   always @(posedge rui_tx_ref_clk or posedge rui_rst) begin
      if(rui_rst==1'b1)
         plol0_cnt    <= 'd0;
      else if((pll_lol_p2==1)||(plol0_cnt_tc==1))
         plol0_cnt    <= 'd0;
      else if(waita_plol0==1'b1)
         plol0_cnt    <= plol0_cnt+1;
   end
   assign plol0_cnt_tc = (plol0_cnt==lwait_after_plol0)?1'b1:1'b0;

   always @(posedge rui_tx_ref_clk or posedge rui_rst) begin
      if(rui_rst==1'b1) begin
         txp_cnt  <= 'd0;   // tx serdes reset pulse count
         txp_rst  <= 1'b0;  // tx serdes reset
      end
      else if(plol0_cnt_tc==1)
         txp_rst  <= 1'b1;
      else if(txp_cnt_tc==1) begin
         txp_cnt  <= 'd0;
         txp_rst  <= 1'b0;
      end
      else if(txp_rst==1)
         txp_cnt  <= txp_cnt+1;
   end
   assign txp_cnt_tc = (txp_cnt==lreset_pwidth)?1'b1:1'b0;

   genvar i;
   for(i=0;i<pnum_channels;i=i+1) begin : ifor
      assign rdo_tx_pcs_rst_c[i] = (rsl_enable&txp_rst)| rui_tx_pcs_rst_c[i];
   end
   if(pnum_channels==1)
      assign rdo_tx_pcs_rst_c[3:1] = 3'b000;
   else if(pnum_channels==2)
      assign rdo_tx_pcs_rst_c[3:2] = 2'b00;

   // ------------ ruo_tx_rdy
   if(pport_tx_rdy=="ENABLED") begin
   assign dual_or_serd_rst = rdo_serdes_rst_dual_c|rdo_tx_serdes_rst_c;
   assign tx_any_pcs_rst = rdo_rst_dual_c|(|rdo_tx_pcs_rst_c[pnum_channels-1:0]);
   assign tx_any_rst = dual_or_serd_rst | tx_any_pcs_rst;

   always @(posedge rui_tx_ref_clk or posedge rui_rst) begin
      if(rui_rst==1'b1)
         txsr_appd <= 1'b1; // tx serdes reset applied
      else if(dual_or_serd_rst==1)
         txsr_appd <= 1'b1;
   end
   always @(posedge rui_tx_ref_clk or posedge rui_rst) begin
      if(rui_rst==1'b1)
         txdpr_appd <= 1'b0; // tx dual (pcs) reset applied
      else if(pll_lol_p2|rdo_serdes_rst_dual_c|rdo_tx_serdes_rst_c)
         txdpr_appd <= 1'b0;
      else if(rdo_rst_dual_c==1)
         txdpr_appd <= 1'b1;
   end

   genvar m;
   for(m=0;m<pnum_channels;m=m+1) begin :mfor
      always @(posedge rui_tx_ref_clk or posedge rui_rst) begin
      if(rui_rst==1'b1)
         txpr_appd[m] <= 1'b0; // tx pcs reset applied
      else if(pll_lol_p2|rdo_serdes_rst_dual_c|rdo_tx_serdes_rst_c)
         txpr_appd[m] <= 1'b0;
      else if(txsr_appd&(rdo_tx_pcs_rst_c[m]|txdpr_appd))
         txpr_appd[m] <= 1'b1;
      end
   end

   always @(posedge rui_tx_ref_clk or posedge rui_rst) begin
      if(rui_rst==1'b1)
         txr_wt_en  <= 0;  // tx ready wait counter enable
      else if((txr_wt_tc==1)||(dual_or_serd_rst==1))
         txr_wt_en  <= 0;
      else if((~ruo_tx_rdyr)&(~pll_lol_p2)&(&txpr_appd))
         txr_wt_en  <= 1;
   end
   always @(posedge rui_tx_ref_clk or posedge rui_rst) begin
      if(rui_rst==1'b1)
         txr_wt_cnt  <= 'd0;  // tx ready wait count
      else if((txr_wt_tc==1)||(tx_any_rst==1))
         txr_wt_cnt  <= 'd0;
      else if(txr_wt_en==1)
         txr_wt_cnt  <= txr_wt_cnt+1;
   end
   assign txr_wt_tc = (txr_wt_cnt==pwait_tx_rdy)?1'b1:1'b0;

   always @(posedge rui_tx_ref_clk or posedge rui_rst) begin
      if(rui_rst==1'b1)
         ruo_tx_rdyr <= 1'b0; // tx serdes reset applied
      else if((tx_any_rst==1)||(pll_lol_p2==1))
         ruo_tx_rdyr <= 1'b0;
      else if(txr_wt_tc==1)
         ruo_tx_rdyr <= 1'b1;
   end
   assign ruo_tx_rdy = ruo_tx_rdyr;
   end         // if pport_tx_rdy
   else
      assign ruo_tx_rdy = 1'b0;
   end         // generate if(Rx and Tx) or (Tx only)
   else begin  // generate else (Rx only)
      assign rdo_tx_serdes_rst_c = 1'b0;
      assign rdo_tx_pcs_rst_c = 4'd0;
      assign ruo_tx_rdy = 1'b0;
   end
   endgenerate

// ==================================================================
//                                 Rx
// ==================================================================
   generate
   if((pserdes_mode=="RX AND TX")||(pserdes_mode=="RX ONLY")) begin
   assign comb_rlos = |rdi_rx_los_low_s[pnum_channels-1:0];
   assign comb_rlol = |rdi_rx_cdr_lol_s[pnum_channels-1:0];
   //assign rlols     = comb_rlos|comb_rlol;

   // ------------ Synchronizing rlols to the rx ref clock
   always @(posedge rui_rx_ref_clk or posedge rui_rst) begin
      if(rui_rst==1'b1) begin
        //rlols_p1    <= 1'd0;
        //rlols_p2    <= 1'd0;
        //rlols_p3    <= 1'd0;
        //rlols_db_p1 <= 1'd1;

        rlol_p1     <= 1'd0;
        rlol_p2     <= 1'd0;
        rlol_p3     <= 1'd0;
        rlol_db_p1  <= 1'd1;

        rlos_p1    <= 1'd0;
        rlos_p2    <= 1'd0;
        rlos_p3    <= 1'd0;
        rlos_db_p1 <= 1'd1;
      end
      else begin
        //rlols_p1    <= rlols;
        //rlols_p2    <= rlols_p1;
        //rlols_p3    <= rlols_p2;
        //rlols_db_p1 <= rlols_db;

        rlol_p1     <= comb_rlol;
        rlol_p2     <= rlol_p1;
        rlol_p3     <= rlol_p2;
	rlol_db_p1  <= rlol_db;

        rlos_p1    <= comb_rlos;
        rlos_p2    <= rlos_p1;
        rlos_p3    <= rlos_p2;
        rlos_db_p1 <= rlos_db;
      end
   end
   assign rx_all_well = ~rlol_db && ~rlos_db;

//******************************************************************************
// [ES:05.03.17] Unused registers for clean-up
//------------------------------------------------------------------------------
// ------------ Debouncing rlols
//   always @(posedge rui_rx_ref_clk or posedge rui_rst) begin
//      if(rui_rst==1'b1) rdb_cnt  <= lrdb_max;
//      else if(rlols_p2==1) begin
//         if(!rdb_cnt_max) rdb_cnt <= rdb_cnt+1;
//      end
//      else if(!rdb_cnt_zero) rdb_cnt <= rdb_cnt-1;
//   end
//   assign rdb_cnt_max  = (rdb_cnt==lrdb_max);
//   assign rdb_cnt_zero = (rdb_cnt==0);
//   always @(posedge rui_rx_ref_clk or posedge rui_rst) begin
//      if(rui_rst==1'b1) rlols_db <= 1;
//      else if(rdb_cnt_max)  rlols_db <= 1;
//      else if(rdb_cnt_zero) rlols_db <= 0;
//   end
//******************************************************************************

// ------------ Debouncing rlol
   always @(posedge rui_rx_ref_clk or posedge rui_rst) begin
      if(rui_rst==1'b1) rlol_db_cnt  <= lrdb_max;
      else if(rlol_p2==1) begin
         if(!rlol_db_cnt_max) rlol_db_cnt <= rlol_db_cnt+1;
      end
      else if(!rlol_db_cnt_zero) rlol_db_cnt <= rlol_db_cnt-1;
   end
   assign rlol_db_cnt_max  = (rlol_db_cnt==lrdb_max);
   assign rlol_db_cnt_zero = (rlol_db_cnt==0);
   always @(posedge rui_rx_ref_clk or posedge rui_rst) begin
      if(rui_rst==1'b1) rlol_db <= 1;
      else if(rlol_db_cnt_max)  rlol_db <= 1;
      else if(rlol_db_cnt_zero) rlol_db <= 0;
   end

// ------------ Debouncing rlos
   always @(posedge rui_rx_ref_clk or posedge rui_rst) begin
      if(rui_rst==1'b1) rlos_db_cnt  <= lrdb_max;
      else if(rlos_p2==1) begin
         if(!rlos_db_cnt_max) rlos_db_cnt <= rlos_db_cnt+1;
      end
      else if(!rlos_db_cnt_zero) rlos_db_cnt <= rlos_db_cnt-1;
   end
   assign rlos_db_cnt_max  = (rlos_db_cnt==lrdb_max);
   assign rlos_db_cnt_zero = (rlos_db_cnt==0);
   always @(posedge rui_rx_ref_clk or posedge rui_rst) begin
      if(rui_rst==1'b1) rlos_db <= 1;
      else if(rlos_db_cnt_max)  rlos_db <= 1;
      else if(rlos_db_cnt_zero) rlos_db <= 0;
   end

// ------------ Calib time trigger
   always @(posedge rui_rx_ref_clk or posedge rui_rst) begin
     if (rui_rst==1'b1) begin
       wait_calib <= 1'd1;
     end
     else begin
       if (rlol1_cnt_tc) begin
         if (rlol_db)
           wait_calib <= 1'd1;
         else
           wait_calib <= 1'd0;
       end
       else if (rlos_redge)
         wait_calib <= 1'd0;
       else if (rlos_fedge) begin
         wait_calib <= 1'd1;
       end
     end
   end

   //***************************************************************************
   // Total calibration time counter
   // - this covers the band calibration time (256 cycles * 64) and
   //   DAC calibration time (16384 cycles * 10 bits)
   //---------------------------------------------------------------------------
   always @(posedge rui_rx_ref_clk or posedge rui_rst) begin
     if (rui_rst==1'b1) begin
       rlol1_cnt  <= 'd0;  // Counting when Rx LOL is 1 and Rx LOS is 0
     end
     else begin
       if(rxs_rst || rlol1_cnt_tc || rlos_redge)
         rlol1_cnt  <= 'd0;
       else if (wait_calib)
         rlol1_cnt <= rlol1_cnt+1;
     end
   end
   assign rlol1_cnt_tc = (rlol1_cnt==wait_b4_rrst);

// ------------ rdo_rx_serdes_rst_c
   always @(posedge rui_rx_ref_clk or posedge rui_rst) begin
     if (rui_rst==1'b1) begin
       rxs_cnt  <= 'd0;   // rx serdes reset pulse count
       rxs_rst  <= 1'b0;  // rx serdes reset
     end
     else begin
       if (rlos_db)
         rxs_rst <= 1'b0;
       else if (rlol1_cnt_tc && rlol_db)
         rxs_rst <= 1'b1;
       else if (rxs_cnt_tc==1) begin
         rxs_rst  <= 1'b0;
       end

       if (rxs_cnt_tc)
         rxs_cnt <= 'd0;
       else
         if (rxs_rst==1)
           rxs_cnt <= rxs_cnt+1;
     end
   end
   assign rxs_cnt_tc  = (rxs_cnt==lreset_pwidth)?1'b1:1'b0;

   //***************************************************************************
   // [ES:05.03.17] Unused logic from CPRI rrst_wait
   //---------------------------------------------------------------------------
   // always @(posedge rui_rx_ref_clk or posedge rui_rst) begin
   //    if(rui_rst==1'b1)
   //       rrst_cnt    <= 'd0;
   //    else if(rlol1_cnt_tc)
   //       rrst_cnt    <= 'd0;
   //    else if(rrst_wait)
   //       rrst_cnt    <= rrst_cnt+1;
   // end
   // assign rrst_cnt_tc = (rrst_cnt==lwait_after_rrst) ? 1'b1 : 1'b0;
   // always @(posedge rui_rx_ref_clk or posedge rui_rst) begin
   //    if(rui_rst==1'b1)
   //       rrst_wait    <= 0;
   //    else if(pprotocol != "CPRI")
   //       rrst_wait    <= 0;
   //    else if(rlol1_cnt_tc)
   //       rrst_wait    <= 1;
   //    else if(rrst_cnt_tc==1)
   //       rrst_wait    <= 0;
   // end
   //***************************************************************************

   genvar j;
   for(j=0;j<pnum_channels;j=j+1) begin :jfor
      assign rdo_rx_serdes_rst_c[j] = (rsl_enable&rxs_rst)| rui_rx_serdes_rst_c[j];
   end
   if(pnum_channels==1)
      assign rdo_rx_serdes_rst_c[3:1] = 3'b000;
   else if(pnum_channels==2)
      assign rdo_rx_serdes_rst_c[3:2] = 2'b00;

// ------------ rdo_rx_pcs_rst_c
   //assign rlols_fedge = ~rlols_db & rlols_db_p1;
   //assign rlols_redge = rlols_db & ~rlols_db_p1;

   assign rlol_fedge  = ~rlol_db & rlol_db_p1;
   assign rlol_redge  = rlol_db & ~rlol_db_p1;
   assign rlos_fedge  = ~rlos_db & rlos_db_p1;
   assign rlos_redge  = rlos_db & ~rlos_db_p1;

   always @(posedge rui_rx_ref_clk or posedge rui_rst) begin
      if (rui_rst==1'b1) begin
        waita_rlols0 <= 1'd0;
      end
      else begin
        if ((rlos_fedge && ~rlol_db) || (rlol_fedge && ~rlos_db))
          waita_rlols0 <= 1'b1;
        else if (rlos_redge || rlol_redge)
          waita_rlols0 <= 1'd0;
        else if (rlols0_cnt_tc==1)
          waita_rlols0 <= 1'd0;
      end
   end

   //***************************************************************************
   // Post RLOL check before pcs_rst deassertion
   // - allowance of 2-4 DAC calibration cycles + 1024 cycles for WA module
   //   (word alignment).
   //---------------------------------------------------------------------------
   always @(posedge rui_rx_ref_clk or posedge rui_rst) begin
     if (rui_rst==1'b1) begin
       rlols0_cnt <= 'd0;
     end
     else begin
       if (rlol_redge || rlos_redge || rlols0_cnt_tc)
         rlols0_cnt <= 'd0;
       else if (waita_rlols0==1)
         rlols0_cnt <= rlols0_cnt+1;
     end
   end
   assign rlols0_cnt_tc   = (rlols0_cnt == wait_after_lols);
   assign rx_any_serd_rst = rdo_serdes_rst_dual_c|(|rdo_rx_serdes_rst_c);

   //***************************************************************************
   // [ES:05.03.17] Unused registers for clean-up
   //---------------------------------------------------------------------------
   // always @(posedge rui_rx_ref_clk or posedge rui_rst) begin
   //    if(rui_rst==1'b1)
   //       rlolsz_cnt  <= 'd0;  // Counting when both Rx LOL is 0 and Rx LOS is 0
   //    else if((rlol_db|rx_any_serd_rst)||(rlolsz_cnt_tc==1))
   //       rlolsz_cnt  <= 'd0;
   //    else if((rlolsz_cnt_tc==0)&&(rlol_db==0))
   //       rlolsz_cnt  <= rlolsz_cnt+1;
   // end
   // assign rlolsz_cnt_tc = (rlolsz_cnt==wait_after_lols);
   //***************************************************************************

   always @(posedge rui_rx_ref_clk or posedge rui_rst) begin
     if (rui_rst==1'b1) begin
       rxp_cnt2  <= 'd0;   // pcs serdes reset pulse count
       rxp_rst2  <= 1'b1;  // rx pcs reset
     end
     else begin
       if (rx_any_serd_rst || rlos_redge) begin
         rxp_rst2 <= 1'b1;
       end
       else if (rlols0_cnt_tc) begin
         rxp_rst2 <= 1'b0;
       end
       //***********************************************************************
       // [ES:05.03.17] No need for pulse width
       //-----------------------------------------------------------------------
       // else if(rxp_cnt2_tc==1) begin
       //   rxp_cnt2  <= 'd0;
       //   rxp_rst2  <= 1'b0;
       // end
       //***********************************************************************
       // [ES:05.03.17] No need for pulse width
       //-----------------------------------------------------------------------
       // else if (rxp_rst2==1)
       //   rxp_cnt2 <= rxp_cnt2+1;
       //***********************************************************************
     end // else: !if(rui_rst==1'b1)
   end // always @ (posedge rui_rx_ref_clk or posedge rui_rst)
   //assign rxp_cnt2_tc = (rxp_cnt2==lreset_pwidth)?1'b1:1'b0;

   //***************************************************************************
   // [ES:05.03.17] No need for pulse width
   //---------------------------------------------------------------------------
   //else begin
   //   always @(posedge rui_rx_ref_clk or posedge rui_rst) begin
   //      if(rui_rst==1'b1)
   //         rxp_rst2  <= 1'b1;  // rx pcs reset
   //      else if(rx_any_serd_rst)
   //         rxp_rst2  <= 1'b1;
   //      else if(rlolsz_cnt_tc==1)
   //         rxp_rst2  <= 1'b0;
   //   end
   //end
   //***************************************************************************

   genvar k;
   for(k=0;k<pnum_channels;k=k+1) begin: kfor
      assign rdo_rx_pcs_rst_c[k] = (rsl_enable&rxp_rst2)| rui_rx_pcs_rst_c[k];
   end
   if(pnum_channels==1)
      assign rdo_rx_pcs_rst_c[3:1] = 3'b000;
   else if(pnum_channels==2)
      assign rdo_rx_pcs_rst_c[3:2] = 2'b00;

// ------------ ruo_rx_rdy
   if(pport_rx_rdy=="ENABLED") begin
   assign dual_or_rserd_rst = rdo_serdes_rst_dual_c|(|rdo_rx_serdes_rst_c[pnum_channels-1:0]);
   assign rx_any_pcs_rst = rdo_rst_dual_c|(|rdo_rx_pcs_rst_c[pnum_channels-1:0]);
   assign rx_any_rst = dual_or_rserd_rst | rx_any_pcs_rst;

   always @(posedge rui_rx_ref_clk or posedge rui_rst) begin
      if(rui_rst==1'b1)
         rxsdr_appd <= 1'b1;  // Serdes dual reset (macro reset) applied
      else if(rdo_serdes_rst_dual_c==1)
         rxsdr_appd <= 1'b1;
   end
   always @(posedge rui_rx_ref_clk or posedge rui_rst) begin
      if(rui_rst==1'b1)
         rxdpr_appd <= 1'b0;  // Rx dual PCS reset (dual reset) applied
      else if(~rx_all_well|dual_or_rserd_rst)
         rxdpr_appd <= 1'b0;
      else if(rdo_rst_dual_c==1)
         rxdpr_appd <= 1'b1;
   end

   genvar l;
   for(l=0;l<pnum_channels;l=l+1) begin : lfor
      always @(posedge rui_rx_ref_clk or posedge rui_rst) begin
         if(rui_rst==1'b1)
            rxsr_appd[l] <= 1'b0; // rx serdes reset applied
         else if(rdo_rx_serdes_rst_c[l]==1)
            rxsr_appd[l] <= 1'b1;
      end
      always @(posedge rui_rx_ref_clk or posedge rui_rst) begin
      if(rui_rst==1'b1)
         rxpr_appd[l] <= 1'b0; // rx pcs reset applied
      else if(rdi_rx_los_low_s[l]|rdi_rx_cdr_lol_s[l]|rdo_serdes_rst_dual_c|rdo_rx_serdes_rst_c[l])
         rxpr_appd[l] <= 1'b0;
      else if(rxsdr_or_sr_appd&(~rx_all_well)&rdo_rx_pcs_rst_c[l])
         rxpr_appd[l] <= 1'b1;
      end
   end

   assign rxsdr_or_sr_appd = rxsdr_appd|(&rxsr_appd);

   always @(posedge rui_rx_ref_clk or posedge rui_rst) begin
      if(rui_rst==1'b1)
         rxr_wt_en  <= 0;  // rx ready wait counter enable
      //else if((rxr_wt_tc==1)||(dual_or_rserd_rst==1))
      else if((rxr_wt_tc==1)||(dual_or_rserd_rst==1)||(rx_all_well==0)) // BM, 2/4/16
         rxr_wt_en  <= 0;
      else if(~ruo_rx_rdyr&rx_all_well&((&rxpr_appd)|rxdpr_appd))
         rxr_wt_en  <= 1;
   end
   always @(posedge rui_rx_ref_clk or posedge rui_rst) begin
      if(rui_rst==1'b1)
         rxr_wt_cnt  <= 'd0;  // rx ready wait count
      //else if((rxr_wt_tc==1)||(rx_any_rst==1))
      else if((rxr_wt_tc==1)||(rx_any_rst==1)||(rx_all_well==0)) // BM, 2/4/16
         rxr_wt_cnt  <= 'd0;
      else if(rxr_wt_en==1)
         rxr_wt_cnt  <= rxr_wt_cnt+1;
   end
   assign rxr_wt_tc = (rxr_wt_cnt==pwait_rx_rdy)?1'b1:1'b0;

   always @(posedge rui_rx_ref_clk or posedge rui_rst) begin
      if(rui_rst==1'b1)
         ruo_rx_rdyr <= 1'b0; // rx serdes reset applied
      else if((rx_any_rst==1)||(rx_all_well==0))
         ruo_rx_rdyr <= 1'b0;
      else if(rxr_wt_tc==1)
         ruo_rx_rdyr <= 1'b1;
   end
   assign ruo_rx_rdy = ruo_rx_rdyr;
   end         // if pport_rx_rdy
   else
      assign ruo_rx_rdy = 1'b0;
   end // if ((pserdes_mode=="RX AND TX")||(pserdes_mode=="RX ONLY"))

   else begin  // generate else (Tx only)
      assign rdo_rx_serdes_rst_c = 4'd0;
      assign rdo_rx_pcs_rst_c = 4'd0;
      assign ruo_rx_rdy = 1'b0;
   end // else: !if((pserdes_mode=="RX AND TX")||(pserdes_mode=="RX ONLY"))

   endgenerate

endmodule


//   ===========================================================================
//   >>>>>>>>>>>>>>>>>>>>>>> COPYRIGHT NOTICE <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
//   ---------------------------------------------------------------------------
//   Copyright (c) 2015 by Lattice Semiconductor Corporation
//   ALL RIGHTS RESERVED 
//   ------------------------------------------------------------------
//
//   Permission:
//
//      Lattice SG Pte. Ltd. grants permission to use this code
//      pursuant to the terms of the Lattice Reference Design License Agreement. 
//
//
//   Disclaimer:
//
//      This VHDL or Verilog source code is intended as a design reference
//      which illustrates how these types of functions can be implemented.
//      It is the user's responsibility to verify their design for
//      consistency and functionality through the use of formal
//      verification methods.  Lattice provides no warranty
//      regarding the use or functionality of this code.
//
//   ---------------------------------------------------------------------------
//
//                  Lattice SG Pte. Ltd.
//                  101 Thomson Road, United Square #07-02 
//                  Singapore 307591
//
//
//                  TEL: 1-800-Lattice (USA and Canada)
//                       +65-6631-2000 (Singapore)
//                       +1-503-268-8001 (other locations)
//
//                  web: http://www.latticesemi.com/
//                  email: techsupport@latticesemi.com
//
//   ---------------------------------------------------------------------------
//
// =============================================================================
//                         FILE DETAILS         
// Project               : SLL - Soft Loss Of Lock(LOL) Logic
// File                  : sll_core.v
// Title                 : Top-level file for SLL 
// Dependencies          : 1.
//                       : 2.
// Description           : 
// =============================================================================
//                         REVISION HISTORY
// Version               : 1.0
// Author(s)             : AV
// Mod. Date             : March 2, 2015
// Changes Made          : Initial Creation
// =============================================================================
//                         REVISION HISTORY
// Version               : 1.1
// Author(s)             : AV
// Mod. Date             : June 8, 2015
// Changes Made          : Following updates were made 
//                       : 1. Changed all the PLOL status logic and FSM to run
//                       :    on sli_refclk. 
//                       : 2. Added the HB logic for presence of tx_pclk 
//                       : 3. Changed the lparam assignment scheme for 
//                       :    simulation purposes. 
// =============================================================================
//                         REVISION HISTORY
// Version               : 1.2
// Author(s)             : AV
// Mod. Date             : June 24, 2015
// Changes Made          : Updated the gearing logic for SDI dynamic rate change
// =============================================================================
//                         REVISION HISTORY
// Version               : 1.3
// Author(s)             : AV
// Mod. Date             : July 14, 2015
// Changes Made          : Added the logic for dynamic rate change in CPRI
// =============================================================================
//                         REVISION HISTORY
// Version               : 1.4
// Author(s)             : AV
// Mod. Date             : August 21, 2015
// Changes Made          : Added the logic for dynamic rate change of 5G CPRI & 
//                         PCIe.
// =============================================================================
//                         REVISION HISTORY
// Version               : 1.5
// Author(s)             : ES/EB
// Mod. Date             : March 21, 2017
// Changes Made          : 1. Added pdiff_sync signal to syncrhonize pcount_diff 
//                       :    to sli_refclk.
//                       : 2. Updated terminal count logic for PCIe 5G
//                       : 3. Modified checking of pcount_diff in SLL state
//                       :    machine to cover actual count
//                       :    (from 16-bits to 22-bits)
// =============================================================================
//                         REVISION HISTORY
// Version               : 1.6
// Author(s)             : ES
// Mod. Date             : April 19, 2017
// Changes Made          : 1. Added registered lock and unlock signal from
//                            pdiff_sync to totally decouple pcount_diff from
//                            SLL state machine.
//                       : 2. Modified LPCLK_TC_4 to 1:1 clock ratio when CPRI
//                            is operating @ 4.9125Gbps data rate.
// =============================================================================
`timescale 1ns/10ps

module x_pcie_pcssll_core ( 
  //Reset and Clock inputs
  sli_rst,         //Active high asynchronous reset input
  sli_refclk,      //Refclk input to the Tx PLL
  sli_pclk,        //Tx pclk output from the PCS
  
  //Control inputs
  sli_div2_rate,   //Divide by 2 control; 0 - Full rate; 1 - Half rate
  sli_div11_rate,  //Divide by 11 control; 0 - Full rate; 1 - Div by 11
  sli_gear_mode,   //Gear mode control for PCS; 0 - 8/10; 1- 16/20
  sli_cpri_mode,   //Mode of operation specific to CPRI protocol
  sli_pcie_mode,   //Mode of operation specific to PCIe mode (2.5G or 5G)
  
  //LOL Output
  slo_plol         //Tx PLL Loss of Lock output to the user logic
  );
  
// Inputs
input       sli_rst;
input       sli_refclk;
input       sli_pclk;
input       sli_div2_rate;
input       sli_div11_rate;
input       sli_gear_mode;
input [2:0] sli_cpri_mode;
input       sli_pcie_mode;

// Outputs
output      slo_plol;


// Parameters
parameter PPROTOCOL              = "PCIE";     //Protocol selected by the User
parameter PLOL_SETTING           = 0;          //PLL LOL setting. Possible values are 0,1,2,3
parameter PDYN_RATE_CTRL         = "DISABLED"; //PCS Dynamic Rate control
parameter PPCIE_MAX_RATE         = "2.5";      //PCIe max data rate
parameter PDIFF_VAL_LOCK         = 20;         //Differential count value for Lock
parameter PDIFF_VAL_UNLOCK       = 39;         //Differential count value for Unlock
parameter PPCLK_TC               = 65535;      //Terminal count value for counter running on sli_pclk
parameter PDIFF_DIV11_VAL_LOCK   = 3;          //Differential count value for Lock for SDI Div11
parameter PDIFF_DIV11_VAL_UNLOCK = 3;          //Differential count value for Unlock for SDI Div11
parameter PPCLK_DIV11_TC         = 2383;       //Terminal count value (SDI Div11) for counter running on sli_pclk


// Local Parameters
localparam [1:0]  LPLL_LOSS_ST         = 2'b00;       //PLL Loss state
localparam [1:0]  LPLL_PRELOSS_ST      = 2'b01;       //PLL Pre-Loss state
localparam [1:0]  LPLL_PRELOCK_ST      = 2'b10;       //PLL Pre-Lock state
localparam [1:0]  LPLL_LOCK_ST         = 2'b11;       //PLL Lock state
`ifdef RSL_SIM_MODE
localparam [15:0] LRCLK_TC             = 16'd63;   //Terminal count value for counter running on sli_refclk
`else
localparam [15:0] LRCLK_TC             = 16'd65535;   //Terminal count value for counter running on sli_refclk
`endif
localparam [15:0] LRCLK_TC_PUL_WIDTH   = 16'd50;      //Pulse width for the Refclk terminal count pulse
localparam [7:0]  LHB_WAIT_CNT         = 8'd255;      //Wait count for the Heartbeat signal

// Local Parameters related to the CPRI dynamic modes
// Terminal count values for the four CPRI modes
localparam LPCLK_TC_0 = 32768;
localparam LPCLK_TC_1 = 65536;
localparam LPCLK_TC_2 = 131072;
localparam LPCLK_TC_3 = 163840;
localparam LPCLK_TC_4 = 65536;

// Lock values count values for the four CPRI modes and four PLOL settings (4x5)
// CPRI rate mode 0                CPRI rate mode 1                   CPRI rate mode 2                    CPRI rate mode 3                     CPRI rate mode 4
localparam LPDIFF_LOCK_00 = 9;     localparam LPDIFF_LOCK_10 = 19;    localparam LPDIFF_LOCK_20 = 39;     localparam LPDIFF_LOCK_30 = 49;      localparam LPDIFF_LOCK_40 = 19;
localparam LPDIFF_LOCK_01 = 9;     localparam LPDIFF_LOCK_11 = 19;    localparam LPDIFF_LOCK_21 = 39;     localparam LPDIFF_LOCK_31 = 49;      localparam LPDIFF_LOCK_41 = 19;
localparam LPDIFF_LOCK_02 = 49;    localparam LPDIFF_LOCK_12 = 98;    localparam LPDIFF_LOCK_22 = 196;    localparam LPDIFF_LOCK_32 = 245;     localparam LPDIFF_LOCK_42 = 98;
localparam LPDIFF_LOCK_03 = 131;   localparam LPDIFF_LOCK_13 = 262;   localparam LPDIFF_LOCK_23 = 524;    localparam LPDIFF_LOCK_33 = 655;     localparam LPDIFF_LOCK_43 = 262;

// Unlock values count values for the four CPRI modes and four PLOL settings (4x5)
// CPRI rate mode 0                  CPRI rate mode 1                      CPRI rate mode 2                       CPRI rate mode 3                         CPRI rate mode 4
localparam LPDIFF_UNLOCK_00 = 19;    localparam LPDIFF_UNLOCK_10 = 39;     localparam LPDIFF_UNLOCK_20 = 78;      localparam LPDIFF_UNLOCK_30 = 98;        localparam LPDIFF_UNLOCK_40 = 39;
localparam LPDIFF_UNLOCK_01 = 65;    localparam LPDIFF_UNLOCK_11 = 131;    localparam LPDIFF_UNLOCK_21 = 262;     localparam LPDIFF_UNLOCK_31 = 327;       localparam LPDIFF_UNLOCK_41 = 131;
localparam LPDIFF_UNLOCK_02 = 72;    localparam LPDIFF_UNLOCK_12 = 144;    localparam LPDIFF_UNLOCK_22 = 288;     localparam LPDIFF_UNLOCK_32 = 360;       localparam LPDIFF_UNLOCK_42 = 144;
localparam LPDIFF_UNLOCK_03 = 196;   localparam LPDIFF_UNLOCK_13 = 393;    localparam LPDIFF_UNLOCK_23 = 786;     localparam LPDIFF_UNLOCK_33 = 983;       localparam LPDIFF_UNLOCK_43 = 393;

// Input and Output reg and wire declarations
wire       sli_rst;
wire       sli_refclk;
wire       sli_pclk;
wire       sli_div2_rate;
wire       sli_div11_rate;
wire       sli_gear_mode;
wire [2:0] sli_cpri_mode;
wire       sli_pcie_mode;
wire       slo_plol;

//-------------- Internal signals reg and wire declarations --------------------

//Signals running on sli_refclk
reg  [15:0] rcount;           //16-bit Counter
reg         rtc_pul;          //Terminal count pulse
reg         rtc_pul_p1;       //Terminal count pulse pipeline
reg         rtc_ctrl;         //Terminal count pulse control

reg  [7:0]  rhb_wait_cnt;     //Heartbeat wait counter

//Heatbeat synchronization and pipeline registers
wire        rhb_sync;
reg         rhb_sync_p2;
reg         rhb_sync_p1;

//Pipeling registers for dynamic control mode
wire        rgear;
wire        rdiv2;
wire        rdiv11;
reg         rgear_p1;
reg         rdiv2_p1;
reg         rdiv11_p1;

reg         rstat_pclk;        //Pclk presence/absence status

reg  [21:0] rcount_tc;         //Tx_pclk terminal count register
reg  [15:0] rdiff_comp_lock;   //Differential comparison value for Lock
reg  [15:0] rdiff_comp_unlock; //Differential compariosn value for Unlock

wire        rpcie_mode;        //PCIe mode signal synchronized to refclk
reg         rpcie_mode_p1;     //PCIe mode pipeline register

wire        rcpri_mod_ch_sync; //CPRI mode change synchronized to refclk
reg         rcpri_mod_ch_p1;   //CPRI mode change pipeline register
reg         rcpri_mod_ch_p2;   //CPRI mode change pipeline register
reg         rcpri_mod_ch_st;   //CPRI mode change status

reg  [1:0]  sll_state;         //Current-state register for LOL FSM

reg         pll_lock;          //PLL Lock signal

//Signals running on sli_pclk
//Synchronization and pipeline registers
wire        ppul_sync;
reg         ppul_sync_p1;
reg         ppul_sync_p2;
reg         ppul_sync_p3;

wire        pdiff_sync;
reg         pdiff_sync_p1;
   
reg  [21:0] pcount;            //22-bit counter
reg  [21:0] pcount_diff;       //Differential value between Tx_pclk counter and theoritical value

//Heartbeat counter and heartbeat signal running on pclk
reg  [2:0]  phb_cnt;
reg         phb;

//CPRI dynamic mode releated signals
reg  [2:0]  pcpri_mode;
reg         pcpri_mod_ch;

//Assignment scheme changed mainly for simulation purpose
wire [15:0] LRCLK_TC_w;
assign LRCLK_TC_w = LRCLK_TC;

reg         unlock;
reg         lock;

//Heartbeat synchronization
sync # (.PDATA_RST_VAL(0)) phb_sync_inst ( 
  .clk     (sli_refclk),
  .rst     (sli_rst),
  .data_in (phb),
  .data_out(rhb_sync)
  );
  
  
//Terminal count pulse synchronization
sync # (.PDATA_RST_VAL(0)) rtc_sync_inst ( 
  .clk     (sli_pclk),
  .rst     (sli_rst),
  .data_in (rtc_pul),
  .data_out(ppul_sync)
  );

//Differential value logic update synchronization
sync # (.PDATA_RST_VAL(0)) pdiff_sync_inst ( 
  .clk     (sli_refclk),
  .rst     (sli_rst),
  .data_in (ppul_sync),
  .data_out(pdiff_sync)
  );

//Gear mode synchronization
sync # (.PDATA_RST_VAL(0)) gear_sync_inst ( 
  .clk     (sli_refclk),
  .rst     (sli_rst),
  .data_in (sli_gear_mode),
  .data_out(rgear)
  );
  
//Div2 synchronization
sync # (.PDATA_RST_VAL(0)) div2_sync_inst ( 
  .clk     (sli_refclk),
  .rst     (sli_rst),
  .data_in (sli_div2_rate),
  .data_out(rdiv2)
  );
  
//Div11 synchronization
sync # (.PDATA_RST_VAL(0)) div11_sync_inst ( 
  .clk     (sli_refclk),
  .rst     (sli_rst),
  .data_in (sli_div11_rate),
  .data_out(rdiv11)
  );
  
//CPRI mode change synchronization
sync # (.PDATA_RST_VAL(0)) cpri_mod_sync_inst ( 
  .clk     (sli_refclk),
  .rst     (sli_rst),
  .data_in (pcpri_mod_ch),
  .data_out(rcpri_mod_ch_sync)
  );
  
//PCIe mode change synchronization
sync # (.PDATA_RST_VAL(0)) pcie_mod_sync_inst ( 
  .clk     (sli_refclk),
  .rst     (sli_rst),
  .data_in (sli_pcie_mode),
  .data_out(rpcie_mode)
  );  

// =============================================================================
// Synchronized Lock/Unlock signals
// =============================================================================
always @(posedge sli_refclk or posedge sli_rst) begin
  if (sli_rst == 1'b1) begin
    unlock        <= 1'b0;
    lock          <= 1'b0;
    pdiff_sync_p1 <= 1'b0;
  end
  else begin
    pdiff_sync_p1 <= pdiff_sync;
    if (unlock) begin
      unlock <= ~pdiff_sync && pdiff_sync_p1 ? 1'b0 : unlock;
    end
    else begin
      unlock <= pdiff_sync ? (pcount_diff[21:0] > {6'd0, rdiff_comp_unlock}) : 1'b0;
    end
    if (lock) begin
      lock <= ~pdiff_sync && pdiff_sync_p1 ? 1'b0 : lock;
    end
    else begin
      lock <= pdiff_sync ? (pcount_diff[21:0] <= {6'd0, rdiff_comp_lock}) : 1'b0;
    end
  end
end

// =============================================================================
// Refclk Counter, pulse generation logic and Heartbeat monitor logic
// =============================================================================
always @(posedge sli_refclk or posedge sli_rst) begin
  if (sli_rst == 1'b1) begin
    rcount     <= 16'd0;
    rtc_pul    <= 1'b0;
    rtc_ctrl   <= 1'b0;
    rtc_pul_p1 <= 1'b0;
  end
  else begin
    //Counter logic
    if ((rgear_p1^rgear == 1'b1) || (rdiv2_p1^rdiv2 == 1'b1) || (rdiv11_p1^rdiv11 == 1'b1) || (rcpri_mod_ch_p1^rcpri_mod_ch_p2 == 1'b1) || (rpcie_mode_p1^rpcie_mode == 1'b1)) begin
      if (rtc_ctrl == 1'b1) begin
        rcount <= LRCLK_TC_PUL_WIDTH;
      end  
    end
    else begin
      if (rcount != LRCLK_TC_w) begin
        rcount <= rcount + 1;
      end
      else begin
        rcount <= 16'd0;   
      end
    end
    
    //Pulse control logic
    if (rcount == LRCLK_TC_w - 1) begin
      rtc_ctrl <= 1'b1;
    end
    
    //Pulse Generation logic
    if (rtc_ctrl == 1'b1) begin
      if ((rcount == LRCLK_TC_w) || (rcount < LRCLK_TC_PUL_WIDTH)) begin
        rtc_pul <= 1'b1;
    end  
      else begin
        rtc_pul <= 1'b0;  
      end
    end
    
    rtc_pul_p1 <= rtc_pul;  
  end  
end


// =============================================================================
// Heartbeat synchronization & monitor logic and Dynamic mode pipeline logic 
// =============================================================================
always @(posedge sli_refclk or posedge sli_rst) begin
  if (sli_rst == 1'b1) begin
    rhb_sync_p1     <= 1'b0;
    rhb_sync_p2     <= 1'b0;
    rhb_wait_cnt    <= 8'd0;
    rstat_pclk      <= 1'b0;
    rgear_p1        <= 1'b0;
    rdiv2_p1        <= 1'b0;
    rdiv11_p1       <= 1'b0;
    rcpri_mod_ch_p1 <= 1'b0;
    rcpri_mod_ch_p2 <= 1'b0;
    rcpri_mod_ch_st <= 1'b0;
    rpcie_mode_p1   <= 1'b0;
    
  end
  else begin
    //Pipeline stages for the Heartbeat
    rhb_sync_p1 <= rhb_sync;
    rhb_sync_p2 <= rhb_sync_p1;
    
    //Pipeline stages of the Dynamic rate control signals
    rgear_p1  <= rgear;
    rdiv2_p1  <= rdiv2;
    rdiv11_p1 <= rdiv11;
    
    //Pipeline stage for PCIe mode
    rpcie_mode_p1 <= rpcie_mode;
    
    //Pipeline stage for CPRI mode change
    rcpri_mod_ch_p1 <= rcpri_mod_ch_sync;
    rcpri_mod_ch_p2 <= rcpri_mod_ch_p1;
    
    //CPRI mode change status logic
    if (rcpri_mod_ch_p1^rcpri_mod_ch_sync == 1'b1) begin
      rcpri_mod_ch_st <= 1'b1;
    end 
    
    //Heartbeat wait counter and monitor logic
    if (rtc_ctrl == 1'b1) begin
      if (rhb_sync_p1 == 1'b1 && rhb_sync_p2 == 1'b0) begin
        rhb_wait_cnt <= 8'd0;
        rstat_pclk   <= 1'b1;
      end
      else if (rhb_wait_cnt == LHB_WAIT_CNT) begin
        rhb_wait_cnt <= 8'd0;
        rstat_pclk   <= 1'b0;
      end
      else begin
        rhb_wait_cnt <= rhb_wait_cnt + 1;
      end
    end
  end  
end


// =============================================================================
// Pipleline registers for the TC pulse and CPRI mode change logic
// =============================================================================
always @(posedge sli_pclk or posedge sli_rst) begin
  if (sli_rst == 1'b1) begin
    ppul_sync_p1 <= 1'b0;
    ppul_sync_p2 <= 1'b0;
    ppul_sync_p3 <= 1'b0;
    pcpri_mode   <= 3'b0;
    pcpri_mod_ch <= 1'b0;
  end
  else begin
    ppul_sync_p1 <= ppul_sync;
    ppul_sync_p2 <= ppul_sync_p1;
    ppul_sync_p3 <= ppul_sync_p2;
    
    //CPRI mode change logic
    pcpri_mode <= sli_cpri_mode;
    
    if (pcpri_mode != sli_cpri_mode) begin
      pcpri_mod_ch <= ~pcpri_mod_ch;
    end 
  end  
end
   

// =============================================================================
// Terminal count logic
// =============================================================================

//For SDI protocol with Dynamic rate control enabled
generate
if ((PDYN_RATE_CTRL == "ENABLED") && (PPROTOCOL == "SDI")) begin
always @(posedge sli_refclk or posedge sli_rst) begin
  if (sli_rst == 1'b1) begin
    rcount_tc         <= 22'd0;
    rdiff_comp_lock   <= 16'd0;
    rdiff_comp_unlock <= 16'd0;
  end
  else begin
    //Terminal count logic
    //Div by 11 is enabled
    if (rdiv11 == 1'b1) begin
      //Gear mode is 16/20
      if (rgear == 1'b1) begin
        rcount_tc         <= PPCLK_DIV11_TC;
        rdiff_comp_lock   <= PDIFF_DIV11_VAL_LOCK;
        rdiff_comp_unlock <= PDIFF_DIV11_VAL_UNLOCK;
      end
      else begin
        rcount_tc         <= {PPCLK_DIV11_TC[20:0], 1'b0};
        rdiff_comp_lock   <= {PDIFF_DIV11_VAL_LOCK[14:0], 1'b0};
        rdiff_comp_unlock <= {PDIFF_DIV11_VAL_UNLOCK[14:0], 1'b0};
      end
    end
    //Div by 2 is enabled
    else if (rdiv2 == 1'b1) begin
      //Gear mode is 16/20
      if (rgear == 1'b1) begin
        rcount_tc         <= {1'b0,PPCLK_TC[21:1]};
        rdiff_comp_lock   <= {1'b0,PDIFF_VAL_LOCK[15:1]};
        rdiff_comp_unlock <= {1'b0,PDIFF_VAL_UNLOCK[15:1]};
      end
      else begin
        rcount_tc         <= PPCLK_TC;
        rdiff_comp_lock   <= PDIFF_VAL_LOCK;
        rdiff_comp_unlock <= PDIFF_VAL_UNLOCK;
      end
    end
    //Both div by 11 and div by 2 are disabled
    else begin
      //Gear mode is 16/20
      if (rgear == 1'b1) begin
        rcount_tc         <= PPCLK_TC;
        rdiff_comp_lock   <= PDIFF_VAL_LOCK;
        rdiff_comp_unlock <= PDIFF_VAL_UNLOCK;
      end
      else begin
        rcount_tc         <= {PPCLK_TC[20:0],1'b0};
        rdiff_comp_lock   <= {PDIFF_VAL_LOCK[14:0],1'b0};
        rdiff_comp_unlock <= {PDIFF_VAL_UNLOCK[14:0],1'b0};
      end
    end
  end  
end
end
endgenerate

//For G8B10B protocol with Dynamic rate control enabled
generate
if ((PDYN_RATE_CTRL == "ENABLED") && (PPROTOCOL == "G8B10B")) begin
always @(posedge sli_refclk or posedge sli_rst) begin
  if (sli_rst == 1'b1) begin
    rcount_tc         <= 22'd0;
    rdiff_comp_lock   <= 16'd0;
    rdiff_comp_unlock <= 16'd0;
  end
  else begin
    //Terminal count logic
    //Div by 2 is enabled
    if (rdiv2 == 1'b1) begin
      rcount_tc         <= {1'b0,PPCLK_TC[21:1]};
      rdiff_comp_lock   <= {1'b0,PDIFF_VAL_LOCK[15:1]};
      rdiff_comp_unlock <= {1'b0,PDIFF_VAL_UNLOCK[15:1]};
    end
    else begin
      rcount_tc         <= PPCLK_TC;
      rdiff_comp_lock   <= PDIFF_VAL_LOCK;
      rdiff_comp_unlock <= PDIFF_VAL_UNLOCK;
    end
  end  
end
end
endgenerate


//For CPRI protocol with Dynamic rate control is disabled
generate
if ((PDYN_RATE_CTRL == "DISABLED") && (PPROTOCOL == "CPRI")) begin
always @(posedge sli_refclk or posedge sli_rst) begin
  if (sli_rst == 1'b1) begin
    rcount_tc         <= 22'd0;
    rdiff_comp_lock   <= 16'd0;
    rdiff_comp_unlock <= 16'd0;
  end
  else begin
    //Terminal count logic for CPRI protocol
    //Only if there is a change in the rate mode from the default
    if (rcpri_mod_ch_st == 1'b1) begin
      if (rcpri_mod_ch_p1^rcpri_mod_ch_p2 == 1'b1) begin
        case(sli_cpri_mode)
          3'd0 : begin //For 0.6Gbps
            rcount_tc         <= LPCLK_TC_0;
            case(PLOL_SETTING)
              'd0 : begin
                rdiff_comp_lock   <= LPDIFF_LOCK_00;
                rdiff_comp_unlock <= LPDIFF_UNLOCK_00;
              end
              
              'd1 : begin
                rdiff_comp_lock   <= LPDIFF_LOCK_01;
                rdiff_comp_unlock <= LPDIFF_UNLOCK_01;
              end
              
              'd2 : begin
                rdiff_comp_lock   <= LPDIFF_LOCK_02;
                rdiff_comp_unlock <= LPDIFF_UNLOCK_02;
              end
              
              'd3 : begin
                rdiff_comp_lock   <= LPDIFF_LOCK_03;
                rdiff_comp_unlock <= LPDIFF_UNLOCK_03;
              end
              
              default : begin
                rdiff_comp_lock   <= LPDIFF_LOCK_00;
                rdiff_comp_unlock <= LPDIFF_UNLOCK_00;
              end
            endcase
          end
          
          3'd1 : begin //For 1.2Gbps
            rcount_tc         <= LPCLK_TC_1;
            case(PLOL_SETTING)
              'd0 : begin
                rdiff_comp_lock   <= LPDIFF_LOCK_10;
                rdiff_comp_unlock <= LPDIFF_UNLOCK_10;
              end
              
              'd1 : begin
                rdiff_comp_lock   <= LPDIFF_LOCK_11;
                rdiff_comp_unlock <= LPDIFF_UNLOCK_11;
              end
              
              'd2 : begin
                rdiff_comp_lock   <= LPDIFF_LOCK_12;
                rdiff_comp_unlock <= LPDIFF_UNLOCK_12;
              end
              
              'd3 : begin
                rdiff_comp_lock   <= LPDIFF_LOCK_13;
                rdiff_comp_unlock <= LPDIFF_UNLOCK_13;
              end
              
              default : begin
                rdiff_comp_lock   <= LPDIFF_LOCK_10;
                rdiff_comp_unlock <= LPDIFF_UNLOCK_10;
              end
            endcase
          end
          
          3'd2 : begin //For 2.4Gbps
            rcount_tc         <= LPCLK_TC_2;
            case(PLOL_SETTING)
              'd0 : begin
                rdiff_comp_lock   <= LPDIFF_LOCK_20;
                rdiff_comp_unlock <= LPDIFF_UNLOCK_20;
              end
              
              'd1 : begin
                rdiff_comp_lock   <= LPDIFF_LOCK_21;
                rdiff_comp_unlock <= LPDIFF_UNLOCK_21;
              end
              
              'd2 : begin
                rdiff_comp_lock   <= LPDIFF_LOCK_22;
                rdiff_comp_unlock <= LPDIFF_UNLOCK_22;
              end
              
              'd3 : begin
                rdiff_comp_lock   <= LPDIFF_LOCK_23;
                rdiff_comp_unlock <= LPDIFF_UNLOCK_23;
              end
              
              default : begin
                rdiff_comp_lock   <= LPDIFF_LOCK_20;
                rdiff_comp_unlock <= LPDIFF_UNLOCK_20;
              end
            endcase
          end
          
          3'd3 : begin //For 3.07Gbps
            rcount_tc         <= LPCLK_TC_3;
            case(PLOL_SETTING)
              'd0 : begin
                rdiff_comp_lock   <= LPDIFF_LOCK_30;
                rdiff_comp_unlock <= LPDIFF_UNLOCK_30;
              end
              
              'd1 : begin
                rdiff_comp_lock   <= LPDIFF_LOCK_31;
                rdiff_comp_unlock <= LPDIFF_UNLOCK_31;
              end
              
              'd2 : begin
                rdiff_comp_lock   <= LPDIFF_LOCK_32;
                rdiff_comp_unlock <= LPDIFF_UNLOCK_32;
              end
              
              'd3 : begin
                rdiff_comp_lock   <= LPDIFF_LOCK_33;
                rdiff_comp_unlock <= LPDIFF_UNLOCK_33;
              end
            endcase
          end    
              
          3'd4 : begin //For 4.9125bps
            rcount_tc         <= LPCLK_TC_4;
            case(PLOL_SETTING)
              'd0 : begin
                rdiff_comp_lock   <= LPDIFF_LOCK_40;
                rdiff_comp_unlock <= LPDIFF_UNLOCK_40;
              end
              
              'd1 : begin
                rdiff_comp_lock   <= LPDIFF_LOCK_41;
                rdiff_comp_unlock <= LPDIFF_UNLOCK_41;
              end
              
              'd2 : begin
                rdiff_comp_lock   <= LPDIFF_LOCK_42;
                rdiff_comp_unlock <= LPDIFF_UNLOCK_42;
              end
              
              'd3 : begin
                rdiff_comp_lock   <= LPDIFF_LOCK_43;
                rdiff_comp_unlock <= LPDIFF_UNLOCK_43;
              end  
            
              default : begin
                rdiff_comp_lock   <= LPDIFF_LOCK_40;
                rdiff_comp_unlock <= LPDIFF_UNLOCK_40;
              end
            endcase
          end
        
          default : begin
            rcount_tc         <= LPCLK_TC_0;
            rdiff_comp_lock   <= LPDIFF_LOCK_00;
            rdiff_comp_unlock <= LPDIFF_UNLOCK_00;
          end
        endcase
      end
    end
    else begin
      //If there is no change in the CPRI rate mode from default
      rcount_tc         <= PPCLK_TC;
      rdiff_comp_lock   <= PDIFF_VAL_LOCK;
      rdiff_comp_unlock <= PDIFF_VAL_UNLOCK;
    end  
  end  
end
end
endgenerate

//For PCIe protocol with Dynamic rate control disabled
generate
if ((PDYN_RATE_CTRL == "DISABLED") && (PPROTOCOL == "PCIE")) begin
always @(posedge sli_refclk or posedge sli_rst) begin
  if (sli_rst == 1'b1) begin
    rcount_tc         <= 22'd0;
    rdiff_comp_lock   <= 16'd0;
    rdiff_comp_unlock <= 16'd0;
  end
  else begin
    //Terminal count logic
    if (PPCIE_MAX_RATE == "2.5") begin
      //2.5G mode is enabled
      rcount_tc         <= PPCLK_TC;
      rdiff_comp_lock   <= PDIFF_VAL_LOCK;
      rdiff_comp_unlock <= PDIFF_VAL_UNLOCK;
    end
    else begin
      //5G mode is enabled
      if (rpcie_mode == 1'b1) begin
        rcount_tc         <= PPCLK_TC;
        rdiff_comp_lock   <= PDIFF_VAL_LOCK;
        rdiff_comp_unlock <= PDIFF_VAL_UNLOCK;
      end
      else begin
        //2.5G mode is enabled
        rcount_tc         <= {1'b0,PPCLK_TC[21:1]};
        rdiff_comp_lock   <= {1'b0,PDIFF_VAL_LOCK[15:1]};
        rdiff_comp_unlock <= {1'b0,PDIFF_VAL_UNLOCK[15:1]};
      end 
    end 	  
  end  
end
end
endgenerate

//For all protocols other than CPRI & PCIe
generate
if ((PDYN_RATE_CTRL == "DISABLED") && ((PPROTOCOL != "CPRI") && (PPROTOCOL != "PCIE"))) begin
always @(posedge sli_refclk or posedge sli_rst) begin
  if (sli_rst == 1'b1) begin
    rcount_tc         <= 22'd0;
    rdiff_comp_lock   <= 16'd0;
    rdiff_comp_unlock <= 16'd0;
  end
  else begin
    //Terminal count logic for all protocols other than CPRI & PCIe
    rcount_tc         <= PPCLK_TC;
    rdiff_comp_lock   <= PDIFF_VAL_LOCK;
    rdiff_comp_unlock <= PDIFF_VAL_UNLOCK;
  end  
end
end
endgenerate


// =============================================================================
// Tx_pclk counter, Heartbeat and Differential value logic
// =============================================================================
always @(posedge sli_pclk or posedge sli_rst) begin
  if (sli_rst == 1'b1) begin
    pcount      <= 22'd0;
    pcount_diff <= 22'd65535;
    phb_cnt     <= 3'd0;
    phb         <= 1'b0;
  end
  else begin
    //Counter logic
    if (ppul_sync_p1 == 1'b1 && ppul_sync_p2 == 1'b0) begin
      pcount <= 22'd0;
    end
    else begin
      pcount <= pcount + 1;
    end
    
    //Heartbeat logic
    phb_cnt <= phb_cnt + 1;
    
    if ((phb_cnt < 3'd4) && (phb_cnt >= 3'd0)) begin
      phb <= 1'b1;
    end  
    else begin
      phb <= 1'b0;  
    end 
    
    //Differential value logic
    if (ppul_sync_p1 == 1'b1 && ppul_sync_p2 == 1'b0) begin
      pcount_diff <= rcount_tc + ~(pcount) + 1;
    end  
    else if (ppul_sync_p2 == 1'b1 && ppul_sync_p3 == 1'b0) begin
      if (pcount_diff[21] == 1'b1) begin
        pcount_diff <= ~(pcount_diff) + 1;
      end
    end
  end  
end


// =============================================================================
// State transition logic for SLL FSM
// =============================================================================
always @(posedge sli_refclk or posedge sli_rst) begin
  if (sli_rst == 1'b1) begin
    sll_state <= LPLL_LOSS_ST; 
  end
  else begin
    //Reasons to declare an immediate loss - Absence of Tx_pclk, Dynamic rate change for SDI or CPRI
    if ((rstat_pclk == 1'b0) || (rgear_p1^rgear == 1'b1) || (rdiv2_p1^rdiv2 == 1'b1) || 
    (rdiv11_p1^rdiv11 == 1'b1) || (rcpri_mod_ch_p1^rcpri_mod_ch_p2 == 1'b1) || (rpcie_mode_p1^rpcie_mode == 1'b1)) begin
      sll_state <= LPLL_LOSS_ST;
    end
    else begin  
      case(sll_state)
        LPLL_LOSS_ST : begin
          if (rtc_pul_p1 == 1'b1 && rtc_pul == 1'b0) begin
            if (unlock) begin
              sll_state <= LPLL_LOSS_ST;
            end
            else if (lock) begin
              if (PLOL_SETTING == 2'd0) begin
                sll_state <= LPLL_PRELOCK_ST;
              end
              else begin
                sll_state <= LPLL_LOCK_ST;
              end
            end
          end
        end
        
        LPLL_LOCK_ST : begin
          if (rtc_pul_p1 == 1'b1 && rtc_pul == 1'b0) begin
            if (lock) begin
              sll_state <= LPLL_LOCK_ST;
            end
            else begin
              if (PLOL_SETTING == 2'd0) begin
                sll_state <= LPLL_LOSS_ST;
              end
              else begin
                sll_state <= LPLL_PRELOSS_ST;
              end
            end
          end
        end
        
        LPLL_PRELOCK_ST : begin
          if (rtc_pul_p1 == 1'b1 && rtc_pul == 1'b0) begin
            if (lock) begin
              sll_state <= LPLL_LOCK_ST;
            end
            else begin
              sll_state <= LPLL_PRELOSS_ST;
            end
          end
        end
        
        LPLL_PRELOSS_ST : begin
          if (rtc_pul_p1 == 1'b1 && rtc_pul == 1'b0) begin
            if (unlock) begin
              sll_state <= LPLL_PRELOSS_ST;
            end
            else if (lock) begin
              sll_state <= LPLL_LOCK_ST;
            end
          end
        end
        
        default: begin
          sll_state <= LPLL_LOSS_ST;
        end
      endcase
    end  
  end  
end


// =============================================================================
// Logic for Tx PLL Lock
// =============================================================================
always @(posedge sli_refclk or posedge sli_rst) begin
  if (sli_rst == 1'b1) begin
    pll_lock <= 1'b0; 
  end
  else begin
    case(sll_state)
      LPLL_LOSS_ST : begin
        pll_lock <= 1'b0;
      end
      
      LPLL_LOCK_ST : begin
        pll_lock <= 1'b1;
      end
      
      LPLL_PRELOSS_ST : begin
        pll_lock <= 1'b0;
      end
      
      default: begin
        pll_lock <= 1'b0;
      end
    endcase
  end  
end

assign slo_plol = ~(pll_lock);

endmodule  


//   ===========================================================================
//   >>>>>>>>>>>>>>>>>>>>>>> COPYRIGHT NOTICE <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
//   ---------------------------------------------------------------------------
//   Copyright (c) 2015 by Lattice Semiconductor Corporation
//   ALL RIGHTS RESERVED 
//   ------------------------------------------------------------------
//
//   Permission:
//
//      Lattice SG Pte. Ltd. grants permission to use this code
//      pursuant to the terms of the Lattice Reference Design License Agreement. 
//
//
//   Disclaimer:
//
//      This VHDL or Verilog source code is intended as a design reference
//      which illustrates how these types of functions can be implemented.
//      It is the user's responsibility to verify their design for
//      consistency and functionality through the use of formal
//      verification methods.  Lattice provides no warranty
//      regarding the use or functionality of this code.
//
//   ---------------------------------------------------------------------------
//
//                  Lattice SG Pte. Ltd.
//                  101 Thomson Road, United Square #07-02 
//                  Singapore 307591
//
//
//                  TEL: 1-800-Lattice (USA and Canada)
//                       +65-6631-2000 (Singapore)
//                       +1-503-268-8001 (other locations)
//
//                  web: http://www.latticesemi.com/
//                  email: techsupport@latticesemi.com
//
//   ---------------------------------------------------------------------------
//
// =============================================================================
//                         FILE DETAILS
// Project               : Synchronizer Logic
// File                  : sync.v
// Title                 : Synchronizer module
// Description           : 
// =============================================================================
//                         REVISION HISTORY
// Version               : 1.0
// Author(s)             : AV
// Mod. Date             : July 7, 2015
// Changes Made          : Initial Creation
// -----------------------------------------------------------------------------
// Version               : 1.1
// Author(s)             : EB
// Mod. Date             : March 21, 2017
// Changes Made          : 
// =============================================================================

`ifndef PCS_SYNC_MODULE
`define PCS_SYNC_MODULE
module sync ( 
  clk,
  rst,
  data_in,
  data_out
  );
  
input  clk;                  //Clock in which the async data needs to be synchronized to
input  rst;                  //Active high reset
input  data_in;              //Asynchronous data
output data_out;             //Synchronized data

parameter PDATA_RST_VAL = 0; //Reset value for the registers

reg data_p1;
reg data_p2;

// =============================================================================
// Synchronization logic
// =============================================================================
always @(posedge clk or posedge rst) begin
  if (rst == 1'b1) begin
    data_p1 <= PDATA_RST_VAL;
    data_p2 <= PDATA_RST_VAL; 
  end
  else begin
    data_p1 <= data_in;
    data_p2 <= data_p1;
  end  
end

assign data_out = data_p2; 

endmodule    
`endif

