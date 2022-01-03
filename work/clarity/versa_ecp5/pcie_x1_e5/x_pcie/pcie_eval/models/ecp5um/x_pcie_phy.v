
//`define EXERCISER_DEBUG
`define NULL 0
`timescale 1ns / 1 ps


module x_pcie_phy (
   input wire       pll_refclki,
   input wire       rxrefclk,
   input wire       RESET_n,
   input wire [1:0] PowerDown,
   input wire       TxDetectRx_Loopback,

   output wire      pcie_ip_rstn,
   output wire      PCLK,
      output wire   PCLK_by_2,
   output reg    PhyStatus,
   output wire   ffs_plol,

      input wire             hdinp0,
      input wire             hdinn0,
      output wire            hdoutp0,
      output wire            hdoutn0,

   input wire [8-1:0]  TxData_0,
   input wire [1-1:0]   TxDataK_0,
   input wire                   TxCompliance_0,
   input wire                   TxElecIdle_0,
   input wire                   RxPolarity_0,
   output wire [8-1:0] RxData_0,
   output wire [1-1:0]  RxDataK_0,
   output reg                   RxValid_0,
   output wire                  RxElecIdle_0,
   output wire [2:0]            RxStatus_0,
   output wire                  ffs_rlol_ch0,


      // For SoftLOL
         output         tx_pwrup_c,
         output wire     serdes_pdb,
         output wire     serdes_rst_dual_c,
         output wire     tx_serdes_rst_c,
         input wire      sli_rst,

      // For SCI
      input [7:0]          sci_wrdata,
      input [5:0]          sci_addr,
            output[7:0]       sci_rddata,
            input             sci_en_dual,
            input             sci_sel_dual,
            input             sci_wrn,
            input             sci_rd,
            output            sci_int,
            input wire        sci_sel,
            input wire        sci_en,

   input wire               phy_l0,
   input wire [3:0]         phy_cfgln,
   input wire               ctc_disable,
   input wire               flip_lanes
   ) ;

// =============================================================================
// Parameters
// =============================================================================
   localparam  ONE_US         = 8'b11111111;   // 1 Micro sec = 256 clks
   localparam  ONE_US_4BYTE   = 8'b00000101;   // 1 us + 6 clks

localparam  PCIE_DET_IDLE   = 2'b00;
localparam  PCIE_DET_EN     = 2'b01;
localparam  PCIE_CT         = 2'b10;
localparam  PCIE_DONE       = 2'b11;

// =============================================================================
// Wires & Regs
// =============================================================================
wire          clk_250;
wire          clk_125;

wire [19:0]   cout;
wire          ffs_rlol_ch1;
wire          ffs_rlol_ch2;
wire          ffs_rlol_ch3;


wire          fpsc_vlo;
wire  [11:0]  cin;
wire          ffc_trst;
wire          ffc_macro_rst;
wire          ffc_lane_tx_rst;
wire   [3:0]  ffc_lane_rx_rst;
wire          ffc_signal_detect;
wire          ffc_enb_cgalign;

reg           sync_rst;
wire          ff_tx_f_clk;
wire          ff_tx_h_clk;
wire          ff_tx_f_clk_0;
wire          ff_tx_f_clk_1;
wire          ff_tx_f_clk_2;
wire          ff_tx_f_clk_3;
wire          ff_tx_h_clk_0;
wire          ff_tx_h_clk_1;
wire          ff_tx_h_clk_2;
wire          ff_tx_h_clk_3;

      wire                      ffs_pcie_done_0;
      wire                      ffs_pcie_con_0;
      wire                      RxValid_0i;
      wire                      RxValid_0_in;
      wire                      RxElecIdle_0_in;
      wire  [7:0]               RxData_0_in;
      wire                      RxDataK_0_in;
      wire  [2:0]               RxStatus_0_in;
      wire  [7:0]               TxData_0_out;
      wire                      TxDataK_0_out;

      wire                       flip_RxValid_0;
      wire    [8-1:0]   flip_RxData_0;
      wire    [1-1:0]    flip_RxDataK_0;
      wire                       flip_RxElecIdle_0;
      wire    [2:0]              flip_RxStatus_0;
      wire    [8-1:0]   flip_TxData_0;
      wire    [1-1:0]    flip_TxDataK_0;
      //wire                       flip_TxElecIdle_0;
      wire                       flip_TxElecIdle_0;
      wire                       flip_TxCompliance_0;
      wire                       flip_scisel_0;
      wire                       flip_scien_0;
      wire                       flip_RxPolarity_0;

      assign RxValid_0i          = flip_RxValid_0;
      assign RxData_0            = flip_RxData_0;
      assign RxDataK_0           = flip_RxDataK_0;
      assign RxElecIdle_0        = flip_RxElecIdle_0;
      assign RxStatus_0          = flip_RxStatus_0;
      assign flip_TxData_0       = TxData_0;
      assign flip_TxDataK_0      = TxDataK_0;
      assign flip_TxElecIdle_0   = TxElecIdle_0;
      assign flip_TxCompliance_0 = TxCompliance_0;
      assign flip_RxPolarity_0   = RxPolarity_0;
      assign flip_scisel_0       = sci_sel;
      assign flip_scien_0        = sci_en;

// =============================================================================
// =============================================================================
//For PowerDown
      wire                    ffc_pwdnb_0;
      wire                    ffc_pwdnb_1;
      wire                    ffc_pwdnb_2;
      wire                    ffc_pwdnb_3;

wire                       ffc_rrst_0;
wire                       ffc_rrst_1;
wire                       ffc_rrst_2;
wire                       ffc_rrst_3;

reg  [1:0]                    cs_reqdet_sm;
reg                           detsm_done;
reg  [3:0]                    det_result;   // Only for RTL sim
reg                           pcie_con_0;
reg                           pcie_con_1;
reg                           pcie_con_2;
reg                           pcie_con_3;
reg                           ffc_pcie_ct;
reg                           ffc_pcie_det_en_0;
reg                           ffc_pcie_det_en_1;
reg                           ffc_pcie_det_en_2;
reg                           ffc_pcie_det_en_3;

reg                           cnt_enable;
reg                           cntdone_en;
reg                           cntdone_ct;
   reg  [7:0]                 detsm_cnt;   // 1 us (256 clks)

wire                          done_all_re;
wire                          done_0_re;
wire                          done_1_re;
wire                          done_2_re;
wire                          done_3_re;

reg                           done_0_reg;
reg                           done_0_d0 /* synthesis syn_srlstyle="registers" */;
reg                           done_0_d1 /* synthesis syn_srlstyle="registers" */;
reg                           done_1_reg;
reg                           done_1_d0 /* synthesis syn_srlstyle="registers" */;
reg                           done_1_d1 /* synthesis syn_srlstyle="registers" */;
reg                           done_2_reg;
reg                           done_2_d0 /* synthesis syn_srlstyle="registers" */;
reg                           done_2_d1 /* synthesis syn_srlstyle="registers" */;
reg                           done_3_reg;
reg                           done_3_d0 /* synthesis syn_srlstyle="registers" */;
reg                           done_3_d1 /* synthesis syn_srlstyle="registers" */;
reg                           done_all;
reg                           done_all_reg /* synthesis syn_srlstyle="registers" */;

reg                           detect_req;
reg                           detect_req_del /* synthesis syn_srlstyle="registers" */;

reg                           enable_det_ch0 ;
reg                           enable_det_ch1 ;
reg                           enable_det_ch2 ;
reg                           enable_det_ch3 ;
wire                          enable_det_int ;
wire                          enable_det_all ;

reg                           PLOL_sync;
reg                           PLOL_pclk /* synthesis syn_srlstyle="registers" */;
reg  [1:0]                    PowerDown_reg /* synthesis syn_srlstyle="registers" */;
reg                           PLOL_hsync;
reg                           PLOL_hclk;

// Signals for Masking RxValid for 4 MS
reg [16:0]                    count_ms;
reg                           count_ms_enable;
reg [2:0]                     num_ms;
reg                           pcs_wait_done;
reg                           detection_done;
reg                           start_count;
reg                           start_count_del;
reg [3:0]                     RxEI_sync;
reg [3:0]                     RxEI;
reg [3:0]                     RxEI_masked_sync;
reg [3:0]                     RxEI_masked;
wire                          EI_Det_0;
wire                          EI_Det_1;
wire                          EI_Det_2;
wire                          EI_Det_3;
reg [3:0]                     EI_low;
reg [3:0]                     EI_low_pulse;
reg                           reset_counter;
reg                           allEI_high;
reg [3:0]                     RxLOL_sync;
reg [3:0]                     RxLOL;
reg [3:0]                     RxLOL_del;
reg [3:0]                     RxLOL_posedge;

// Signals for Masking EI for 1 us   (false glitch)
reg                           check;
reg                           start_mask;
reg [6:0]                     ei_counter;

// Signals for sync_rst generation
reg [3:0]                     rlol_sync;
reg [3:0]                     rx_elec /* synthesis syn_srlstyle="registers" */;
reg [3:0]                     rlol_fclk /* synthesis syn_srlstyle="registers" */;
reg [3:0]                     rlol_rst_ch;

// For Default Values / RTL Simulation
reg                           Int_RxElecIdle_ch0;
reg                           Int_RxElecIdle_ch1;
reg                           Int_RxElecIdle_ch2;
reg                           Int_RxElecIdle_ch3;
reg                           Int_ffs_rlol_ch0;
reg                           Int_ffs_rlol_ch1;
reg                           Int_ffs_rlol_ch2;
reg                           Int_ffs_rlol_ch3;
wire                          ffs_rlol_ch0_int;

wire                          RxElecIdle_ch0_8;  //Required for 4 MS mask from PIPE TOP
wire                          RxElecIdle_ch1_8;
wire                          RxElecIdle_ch2_8;
wire                          RxElecIdle_ch3_8;

wire ff_rx_fclk_0 /* synthesis syn_keep=1 */;
wire ff_rx_fclk_1 /* synthesis syn_keep=1 */;
wire ff_rx_fclk_2 /* synthesis syn_keep=1 */;
wire ff_rx_fclk_3 /* synthesis syn_keep=1 */;

wire quad_rst;
wire lane_tx_rst;
wire   [3:0]  lane_rx_rst;
wire lane_rrst;

// =============================================================================
VLO fpsc_vlo_inst (.Z(fpsc_vlo));
VHI fpsc_vhi_inst (.Z(fpsc_vhi));

assign cin               = 12'h0;
assign ffc_trst          = fpsc_vlo;
assign ffc_macro_rst     = ~RESET_n;
assign ffc_quad_rst      =  quad_rst ;
assign ffc_lane_tx_rst   = lane_tx_rst;
assign ffc_lane_rx_rst   = lane_rx_rst;
assign ffc_signal_detect = 1'b0;
assign ffc_enb_cgalign   = 1'b1;

       assign ffc_rrst_0        = lane_rrst;

         assign ff_tx_f_clk = ff_tx_f_clk_0;
         assign ff_tx_h_clk = ff_tx_h_clk_0;

assign clk_250           = ff_tx_f_clk;
assign clk_125           = ff_tx_h_clk;

   assign PCLK           = ff_tx_f_clk;   // 250 Mhz clock
   assign PCLK_by_2      = ff_tx_h_clk;   // 125 Mhz clock

// =============================================================================
// Power down unused channels when in downgrade mode and when in L0
// =============================================================================
assign pwdn   = ~(PowerDown[1] & PowerDown[0]);

// Power down non configured lane
        assign ffc_pwdnb_0 = pwdn;  //Active LOW

// =============================================================================
// sync_rst generation :
// Generate LANE TX and RX reset to synchonise all the SERDES and CTC channels
// so that the any channel skew causes by delayed start of clocks are is removed
// Generate sync_rst is rst when
// when any channel LOS OF LOCK is seen, (Useful in X1 downgrade mode)
// when all channel LOS OF LOCK is seen, (Useful in X4 downgrade mode)
// =============================================================================
reg lol_all_d0 /* synthesis syn_srlstyle="registers" */;
reg lol_all_d1 /* synthesis syn_srlstyle="registers" */;
reg lol_all_d2 /* synthesis syn_srlstyle="registers" */;
reg lol_all_d3 /* synthesis syn_srlstyle="registers" */;
reg lol_all_d4 /* synthesis syn_srlstyle="registers" */;
reg lol_all_d5 /* synthesis syn_srlstyle="registers" */;
reg lol_all_d6 /* synthesis syn_srlstyle="registers" */;
reg lol_all_d7 /* synthesis syn_srlstyle="registers" */;
always @(posedge clk_250 or negedge RESET_n) begin
   if(!RESET_n) begin
      lol_all_d0 <= 1'b1;
      lol_all_d1 <= 1'b1;
      lol_all_d2 <= 1'b1;
      lol_all_d3 <= 1'b1;
      lol_all_d4 <= 1'b1;
      lol_all_d5 <= 1'b1;
      lol_all_d6 <= 1'b1;
      lol_all_d7 <= 1'b1;
      sync_rst   <= 1'b1;
   end
   else begin
            lol_all_d0 <= rlol_rst_ch[0];

      lol_all_d1 <= lol_all_d0;
      lol_all_d2 <= lol_all_d1;
      lol_all_d3 <= lol_all_d2;
      lol_all_d4 <= lol_all_d3;
      lol_all_d5 <= lol_all_d4;
      lol_all_d6 <= lol_all_d5;
      lol_all_d7 <= lol_all_d6;
      sync_rst   <= (~lol_all_d1 & lol_all_d7) ;
   end
end


// ======================= RK MODIFICATIONS START ==============================
// New signals :
// pcs_wait_done_ch0, 1,2,3  -- for Rx_valid
// rlol_ch0, 1,2,3           -- for sync_rst
// =============================================================================
// 1 MS Timer -- 18-bit : 250,000 clks (250Mhz)
// count_ms can go upto 262,144 clks (1 ms + 48 us)
// DETECT to POLLING (P1 to P0): the timer starts & after 4 MS,  RxValids
// are passed.
// =============================================================================


///// inputs : pcs_wait_done

///// inputs   : pcs_wait_done, start_mask, Int_RxElecIdle_ch0/1/2/3
///// outputs  : RxElecIdle_ch0_8 (masked EI)

///// inputs : detsm_done

// =============================================================================
// Make Default values in case of X1
// =============================================================================
always@* begin
   // If defined, take from PCS otherwise assign default values
   pcie_con_0  = 1'b0;
   pcie_con_1  = 1'b0;
   pcie_con_2  = 1'b0;
   pcie_con_3  = 1'b0;

   Int_RxElecIdle_ch0  = 1'b1;
   Int_RxElecIdle_ch1  = 1'b1;
   Int_RxElecIdle_ch2  = 1'b1;
   Int_RxElecIdle_ch3  = 1'b1;

   Int_ffs_rlol_ch0    = 1'b1;
   Int_ffs_rlol_ch1    = 1'b1;
   Int_ffs_rlol_ch2    = 1'b1;
   Int_ffs_rlol_ch3    = 1'b1;

     pcie_con_0          = ffs_pcie_con_0;
         Int_RxElecIdle_ch0  = RxElecIdle_0_in;
     Int_ffs_rlol_ch0    = ffs_rlol_ch0_int;
       // synopsys translate_off
           // PCS Sim. Model is not giving Result
           pcie_con_0  = det_result[0];
           pcie_con_1  = det_result[1];
           pcie_con_2  = det_result[2];
           pcie_con_3  = det_result[3];
       // synopsys translate_on
end

// EIDet = 4'b1111 --> when ALL LANES are DETECTED & All lanes are NOT in Elec Idle
// ffs_pcie_con_0/1/2/3 are already stabilized & qualified with "detection_done"
assign EI_Det_0  = ~(RxEI_masked[0]) & pcie_con_0;
assign EI_Det_1  = ~(RxEI_masked[1]) & pcie_con_1;
assign EI_Det_2  = ~(RxEI_masked[2]) & pcie_con_2;
assign EI_Det_3  = ~(RxEI_masked[3]) & pcie_con_3;

always @(posedge clk_125 or negedge RESET_n) begin
   if(!RESET_n) begin
      count_ms        <= 17'b00000000000000000; // 17-bits for 1 MS
      count_ms_enable <= 1'b0;
      num_ms          <= 3'b000;
      pcs_wait_done   <= 1'b0;

      detection_done  <= 1'b0;
      start_count     <= 1'b0;
      start_count_del <= 1'b0;
      RxEI_sync       <= 4'b1111;
      RxEI            <= 4'b1111;
      RxEI_masked_sync <= 4'b1111;
      RxEI_masked     <= 4'b1111;

      EI_low          <= 4'b0000;
      EI_low_pulse    <= 4'b0000;

      reset_counter   <= 1'b0;
      allEI_high      <= 1'b0;
      RxLOL_sync      <= 4'b1111;
      RxLOL           <= 4'b1111;
      RxLOL_del       <= 4'b1111;
      RxLOL_posedge   <= 4'b0000;
   end
   else begin
      //Sync.
      RxLOL_sync <= {Int_ffs_rlol_ch3, Int_ffs_rlol_ch2, Int_ffs_rlol_ch1, Int_ffs_rlol_ch0};
      RxLOL      <= RxLOL_sync;

      //For "1us Masked RxElecIdle -> RxElecIdle_ch0_8"  Take PCS EI
      RxEI_sync  <= {Int_RxElecIdle_ch3, Int_RxElecIdle_ch2, Int_RxElecIdle_ch1, Int_RxElecIdle_ch0};
      RxEI       <= RxEI_sync;


      //Use "Masked RxElecIdle -> RxElecIdle_ch0_8"  for 4MS Mask
      RxEI_masked_sync <= {RxElecIdle_ch3_8, RxElecIdle_ch2_8, RxElecIdle_ch1_8, RxElecIdle_ch0_8};
      RxEI_masked      <= RxEI_masked_sync;

  // After COUNTER enabled, Reset conditions :
  // 1) Any EI going LOW
  // 2) ALL EI going HIGH
  //      keep reset ON until at least one EI goes LOW
  // 3) Any RLOL going HIGH (qualified with corresponding EI LOW)

  // 1) Any EI going LOW
      // ffs_pcie_con_0/1/2/3 stable & qualified with "count_ms_enable"
      EI_low[0]     <= count_ms_enable & EI_Det_0;
      EI_low[1]     <= count_ms_enable & EI_Det_1;
      EI_low[2]     <= count_ms_enable & EI_Det_2;
      EI_low[3]     <= count_ms_enable & EI_Det_3;

      // Generate "reset counter pulse" whenever EI goes on ANY channel
      EI_low_pulse[0] <= ~(EI_low[0]) & count_ms_enable & EI_Det_0;
      EI_low_pulse[1] <= ~(EI_low[1]) & count_ms_enable & EI_Det_1;
      EI_low_pulse[2] <= ~(EI_low[2]) & count_ms_enable & EI_Det_2;
      EI_low_pulse[3] <= ~(EI_low[3]) & count_ms_enable & EI_Det_3;

  // 2) ALL EI going HIGH
  //      keep reset ON until at least one EI goes LOW
  //Timer already started & then ALL EIs are HIGH
      if (count_ms_enable == 1'b1 && EI_low == 4'b0000)
         allEI_high   <= 1'b1;   // Means EI LOW gone
      else
         allEI_high   <= 1'b0;


  // 3) Any RLOL going HIGH (qualified with corresponding EI LOW)
      RxLOL_del     <= RxLOL;
      RxLOL_posedge[0] <= EI_low[0] & RxLOL[0] & ~(RxLOL_del[0]);
      RxLOL_posedge[1] <= EI_low[1] & RxLOL[1] & ~(RxLOL_del[1]);
      RxLOL_posedge[2] <= EI_low[2] & RxLOL[2] & ~(RxLOL_del[2]);
      RxLOL_posedge[3] <= EI_low[3] & RxLOL[3] & ~(RxLOL_del[3]);

      // Reset Counter = 1 + 2 + 3
      // ANY EI low pulse -OR- all EI high -OR- ANY RLOL Posedge
      if ((EI_low_pulse != 4'b0000) || (allEI_high == 1'b1) || (RxLOL_posedge != 4'b0000))
         reset_counter  <= 1'b1;
      else
         reset_counter  <= 1'b0;

      // Any lane DETECTED & NOT in EI
      //if (detsm_done == 1'b1)
         //detection_done  <= 1'b1
      //else if (start_count == 1'b1)
         //detection_done  <= 1'b0;

      if(detection_done == 1'b1) begin
         if (start_count == 1'b1)
            detection_done  <= 1'b0; // change the signal name
      end
      else if (RxEI_masked == 4'b1111 && count_ms_enable == 1'b0)
         detection_done  <= 1'b1;

      //Start Timer after DETECT & AT LEAST ONE Lane is not in EI
      // Reset the count with any EI LOW after that
      // ie counts from Last EI low
      //Any lane DETECTED & NOT in EI
      start_count     <= detection_done & (EI_Det_0 | EI_Det_1 | EI_Det_2 | EI_Det_3);
      start_count_del <= start_count;

      // 1 MS Timer
      if (count_ms_enable == 1'b1 && reset_counter == 1'b0)
         count_ms <= count_ms + 1'b1;
      else // EI gone LOW, start again
         count_ms <= 17'b00000000000000000;

      // 1 MS Timer Enable -- From DETECT to POLLING
      // After detect pulse & then ANY EI gone ZERO
      if ((start_count == 1'b1) && (start_count_del == 1'b0)) //Pulse
         count_ms_enable <= 1'b1;
      else if (num_ms == 3'b100) //4 MS
         count_ms_enable <= 1'b0;

      // No. of MS
      if (count_ms == 17'b11111111111111111)
         num_ms  <= num_ms + 1'b1;
      else if (num_ms == 3'b100) //4 MS
         num_ms  <= 3'b000;

      // pcs_wait_done  for bit lock & symbol lock
      // Waiting for PCS to give stabilized RxValid
      if (num_ms == 3'b100) //4 MS
         pcs_wait_done <= 1'b1;   // Enable passing the RX Valid
      //else if (detsm_done == 1'b1)
      else if (RxEI_masked == 4'b1111)
      //else if (RxEI_masked == "1111" && count_ms_enable == '0')
         pcs_wait_done <= 1'b0;   // Disable when in DETECT

             // synopsys translate_off
             // 1 MS Timer  ==> 8 clks Timer
             if (count_ms_enable == 1'b1 && reset_counter == 1'b0)
                count_ms[2:0] <= count_ms[2:0] + 1'b1;
             else // EI gone LOW, start again
                count_ms <= "00000000000000000";

             // No. of MS
             if (count_ms[2:0] == 3'b111)
                num_ms  <= num_ms + 1'b1;
             else if (num_ms == 3'b100) //4 MS  ==> 4x8=32 clks
                num_ms  <= 3'b000;
             // synopsys translate_on
   end
end

// =============================================================================
// Masking the RxEIDLE Glitch  (otherside Rcvr Detction)
// =============================================================================
always @(posedge clk_125 or negedge RESET_n) begin
   if(!RESET_n) begin
      check       <= 1'b0;
      start_mask  <= 1'b0;
      ei_counter  <= 7'b0000000;
      PLOL_hsync  <= 1'b1;
      PLOL_hclk   <= 1'b1;
   end
   else begin
      // Sync.
      PLOL_hsync <= ffs_plol;
      PLOL_hclk  <= PLOL_hsync;

      if (PLOL_hclk == 1'b0)  begin
            if (RxEI == 4'b1111)
               check <= 1'b1;

            if (ei_counter == 7'b1111111) begin // 128 clks (1us)
               start_mask   <= 1'b0;
               check        <= 1'b0;
            end
            else if (check == 1'b1 && RxEI != 4'b1111) // Any lane goes low
               start_mask  <= 1'b1;

             // synopsys translate_off
	    if (ei_counter[2:0] == 3'b111) begin // 7 clks (1us)
               start_mask   <= 1'b0;
               check        <= 1'b0;
            end
            else if (check == 1'b1 && RxEI != 4'b1111) // Any lane goes low
               start_mask  <= 1'b1;
             // synopsys translate_on
      end
      else begin
         check       <= 1'b0;
         start_mask  <= 1'b0;
      end

      if(start_mask == 1'b1)
         ei_counter  <= ei_counter + 1'b1;
      else
         ei_counter  <= 7'b0000000;

   end
end

// =============================================================================
// Sync_rst generation :
//    Qualify the RLOL with RxElecIdle
//    PCS RLOL is toggling even when ElecIdle is asserted
//    No data during this time
// =============================================================================
always @(posedge clk_250 or negedge RESET_n) begin
   if(!RESET_n) begin
      rlol_sync     <= 4'b1111;
      rx_elec       <= 4'b1111;
      rlol_fclk     <= 4'b1111;
      rlol_rst_ch   <= 4'b1111;  //RLOL qualifed with EI
   end
   else begin
      // Use Masked RxElecIdle
      rx_elec       <= {RxElecIdle_ch3_8, RxElecIdle_ch2_8, RxElecIdle_ch1_8, RxElecIdle_ch0_8};

      //Sync
      rlol_sync     <= {Int_ffs_rlol_ch3, Int_ffs_rlol_ch2, Int_ffs_rlol_ch1, Int_ffs_rlol_ch0};
      rlol_fclk     <= rlol_sync;

      // Combine LOL and ElecIdle for sync_rst
      rlol_rst_ch[0] <= rlol_fclk[0] | rx_elec[0];
      rlol_rst_ch[1] <= rlol_fclk[1] | rx_elec[1];
      rlol_rst_ch[2] <= rlol_fclk[2] | rx_elec[2];
      rlol_rst_ch[3] <= rlol_fclk[3] | rx_elec[3];
   end
end

// ======================= RK MODIFICATIONS END ===============================
// =============================================================================
// pipe_top instantiation per channel
// =============================================================================
   x_pcie_pipe pipe_top_0(
     .RESET_n                (RESET_n) ,
     .PCLK                   (PCLK) ,
     .clk_250                (clk_250),

     .ffs_plol               (ffs_plol) ,
     .TxDetectRx_Loopback    (TxDetectRx_Loopback) ,
     .PowerDown              (PowerDown) ,
     .ctc_disable            (ctc_disable),

     .TxData_in              (flip_TxData_0) ,
     .TxDataK_in             (flip_TxDataK_0) ,
     .TxElecIdle_in          (flip_TxElecIdle_0) ,
     .RxPolarity_in          (flip_RxPolarity_0) ,
     .RxData_in              (RxData_0_in) ,
     .RxDataK_in             (RxDataK_0_in) ,
     .RxStatus_in            (RxStatus_0_in) ,
     .RxValid_in             (RxValid_0_in) ,
     .RxElecIdle_in          (Int_RxElecIdle_ch0) ,

     .ff_rx_fclk_chx         (ff_rx_fclk_0) ,
     .pcie_con_x             (pcie_con_0),

     .pcs_wait_done          (pcs_wait_done),
     .start_mask             (start_mask),
     .detsm_done             (detsm_done),
     .RxElecIdle_chx_8       (RxElecIdle_ch0_8),

     .TxData_out             (TxData_0_out) ,
     .TxDataK_out            (TxDataK_0_out) ,
     .TxElecIdle_out         (TxElecIdle_0_out) ,
     .RxPolarity_out         (RxPolarity_0_out) ,
     .RxData_out             (flip_RxData_0) ,
     .RxDataK_out            (flip_RxDataK_0) ,
     .RxStatus_out           (flip_RxStatus_0) ,
     .RxValid_out            (flip_RxValid_0) ,
     .RxElecIdle_out         (flip_RxElecIdle_0) ,

     .ffc_fb_loopback        (ffc_fb_loopback_0)

     );



// =============================================================================
// pcs_top instantiation
// =============================================================================

   // Intantiate PCS
   x_pcie_pcs  pcs_top_0 (
           .hdoutp             (hdoutp0) ,
           .hdoutn             (hdoutn0) ,
           .hdinp              (hdinp0) ,
           .hdinn              (hdinn0) ,

	.tx_pcs_rst_c     (1'b0),
	.rx_pcs_rst_c     (1'b0),
	.rx_serdes_rst_c  (1'b0),

	.txdata           (TxData_0_out),
	.tx_k             (TxDataK_0_out),
	.tx_force_disp    (flip_TxCompliance_0),
	.tx_disp_sel      (1'b0),
	.pci_ei_en        (TxElecIdle_0_out),
	.tx_pwrup_c       (ffc_pwdnb_0),
	.rx_pwrup_c       (ffc_pwdnb_0),
	.pcie_ct_c        (ffc_pcie_ct),
	.pcie_det_en_c    (ffc_pcie_det_en_0),
        .fb_loopback_c    (ffc_fb_loopback_0),
	.rx_invert_c      (RxPolarity_0_out),
	.signal_detect_c  (1'b1),

	.rx_pclk          (ff_rx_fclk_0),
	.rxdata           (RxData_0_in),
	.rx_k             (RxDataK_0_in),
	.rxstatus0        (RxStatus_0_in),
	.lsm_status_s     (RxValid_0_in),
	.rx_los_low_s     (RxElecIdle_0_in),
	.rx_cdr_lol_s     (ffs_rlol_ch0_int),
	.tx_idle_c        (1'b0),
	.pcie_done_s      (ffs_pcie_done_0),
	.pcie_con_s       (ffs_pcie_con_0),

       // SCI Interface
     .sci_wrdata             (sci_wrdata),
     .sci_addr               (sci_addr) ,
        .sci_en_dual          (sci_en_dual) ,
        .sci_sel_dual         (sci_sel_dual) ,
        .sci_rddata           (sci_rddata ) ,
        .sci_int              (sci_int) ,
        .sci_wrn              (sci_wrn) ,
        .sci_rd               (sci_rd) ,
        .cyawstn              (1'b0) ,

        .sci_sel              (flip_scisel_0) ,
        .sci_en               (flip_scien_0) ,

   .rxrefclk             (rxrefclk),
   .txi_clk              (ff_tx_f_clk),
   .tx_pclk              (tx_pclk),
   .sli_rst              (sli_rst ),
   .rst_dual_c           (~RESET_n ),
   .serdes_rst_dual_c    (serdes_rst_dual_c),
   .serdes_pdb           (serdes_pdb),
   .tx_serdes_rst_c      (tx_serdes_rst_c),
   .rsl_disable          (1'b0),
   .rsl_rst              (~RESET_n ),
   .rsl_tx_rdy           (),
   .rsl_rx_rdy           (rsl_rx_rdy),
   .pll_refclki          (pll_refclki),
   .sli_pcie_mode        (1'b0),
   .pll_lol              (ffs_plol));

   PCSCLKDIV pcs_clkdiv (
      .CLKI    ( tx_pclk ),
      .RST     ( ~RESET_n ),
      .SEL2    ( 1'b0 ),
      .SEL1    ( 1'b1 ),
      .SEL0    ( 1'b0 ),
           .CDIV1   ( ff_tx_f_clk_0 ),
           .CDIVX   ( ff_tx_h_clk_0 ));

	assign tx_pwrup_c = ffc_pwdnb_0;
   assign serdes_rst_dual_c = ~RESET_n ;
   assign serdes_pdb        = 1'b1 ;
   assign tx_serdes_rst_c   = 1'b0 ;

// =============================================================================
// Enable detect signal for detect statemachine
// =============================================================================

assign enable_det_int = (PowerDown == 2'b10) & TxDetectRx_Loopback ;
// =============================================================================
//Assert enable det as long as TxDetectRx_Loopback is asserted by FPGA side
//when Serdes is in normal mode and TxElecIdle_ch0/1/2/3 is active.
// =============================================================================
always @(posedge PCLK or negedge RESET_n) begin //PIPE signals : Use hclk  -- RK
   if(!RESET_n) begin
      enable_det_ch0 <= 1'b0;
      enable_det_ch1 <= 1'b0;
      enable_det_ch2 <= 1'b0;
      enable_det_ch3 <= 1'b0;
      detect_req     <= 1'b0;
      detect_req_del <= 1'b0;
   end
   else begin
            enable_det_ch0 <= (enable_det_int & flip_TxElecIdle_0) ? 1'b1 : 1'b0;
            detect_req     <= enable_det_ch0;
    detect_req_del <= detect_req; // For Rising Edge
   end
end

// Use Flopped signals to see raising edge to remove any setup issues for data comming from PCS
assign done_0_re  = (done_0_d0 & !done_0_d1);
assign done_1_re  = (done_1_d0 & !done_1_d1);
assign done_2_re  = (done_2_d0 & !done_2_d1);
assign done_3_re  = (done_3_d0 & !done_3_d1);
assign done_all_re = done_all & !done_all_reg;
// =============================================================================
// The Following state machine generates the "ffc_pcie_det_done" and
// "ffc_pcie_ct" as per T-Spec page 81.
// =============================================================================
always @(posedge PCLK or negedge RESET_n) begin  //125 or 250 Mhz
   if (!RESET_n) begin
      detsm_done         <= 0;
      ffc_pcie_ct        <= 0;
      ffc_pcie_det_en_0  <= 0;
      ffc_pcie_det_en_1  <= 0;
      ffc_pcie_det_en_2  <= 0;
      ffc_pcie_det_en_3  <= 0;
      cs_reqdet_sm       <= PCIE_DET_IDLE;
      cnt_enable         <= 1'b0;
      done_0_reg         <= 1'b0;
      done_0_d0          <= 1'b0;
      done_0_d1          <= 1'b0;
      done_1_reg         <= 1'b0;
      done_1_d0          <= 1'b0;
      done_1_d1          <= 1'b0;
      done_2_reg         <= 1'b0;
      done_2_d0          <= 1'b0;
      done_2_d1          <= 1'b0;
      done_3_reg         <= 1'b0;
      done_3_d0          <= 1'b0;
      done_3_d1          <= 1'b0;
      done_all           <= 1'b0;
      done_all_reg       <= 1'b0;
      det_result         <= 0;  // Only for RTL sim
   end
   else begin
      // Sync the async signal from PCS (dont use _reg signals)
         done_0_reg   <= ffs_pcie_done_0;
         done_0_d0    <= done_0_reg;
         done_0_d1    <= done_0_d0;

      done_all_reg <= done_all;

               done_all  <=  done_0_d1;

      case(cs_reqdet_sm) //----- Wait for Det Request
      PCIE_DET_IDLE: begin
         ffc_pcie_det_en_0 <= 1'b0;
         ffc_pcie_det_en_1 <= 1'b0;
         ffc_pcie_det_en_2 <= 1'b0;
         ffc_pcie_det_en_3 <= 1'b0;
         ffc_pcie_ct       <= 1'b0;
         cnt_enable        <= 1'b0;
         detsm_done        <= 1'b0;

         // Rising Edge of Det Request
	 if (detect_req == 1'b1 && detect_req_del == 1'b0) begin
            cs_reqdet_sm      <= PCIE_DET_EN;
            ffc_pcie_det_en_0 <= 1'b1;
            ffc_pcie_det_en_1 <= 1'b1;
            ffc_pcie_det_en_2 <= 1'b1;
            ffc_pcie_det_en_3 <= 1'b1;
            cnt_enable        <= 1'b1;
         end
      end
      // Wait for 120 Ns
      PCIE_DET_EN: begin
	 if (cntdone_en) begin
	    cs_reqdet_sm <= PCIE_CT;
            ffc_pcie_ct  <= 1'b1;
            //cnt_enable   <= 1'b0;   //Reset the counter
         end
      end
      // Wait for 4 Byte Clocks
      PCIE_CT: begin
         //cnt_enable    <= 1'b1;  // Enable for Count 2
	 if (cntdone_ct) begin
	    cs_reqdet_sm <= PCIE_DONE;
            ffc_pcie_ct  <= 1'b0;
         end
                  // synopsys translate_off
                    det_result <= 4'b0000;
                  // synopsys translate_on
      end
      // Wait for done to go high for all channels
      PCIE_DONE: begin
         cnt_enable  <= 1'b0;

         // ALL DONEs are asserted   (Rising Edge)
         if (done_all_re) begin //pulse
            cs_reqdet_sm   <= PCIE_DET_IDLE;
            detsm_done     <= 1'b1;
         end

         // DONE makes det_en ZERO individually (DONE Rising Edge)
         if (done_0_re) begin //pulse
            ffc_pcie_det_en_0   <= 1'b0;
                  // synopsys translate_off
                  det_result[0] <= 1'b1;
                  // synopsys translate_on
         end
         if (done_1_re) begin //pulse
            ffc_pcie_det_en_1   <= 1'b0;
                  // synopsys translate_off
                  det_result[1] <= 1'b1;
                  // synopsys translate_on
         end
         if (done_2_re) begin //pulse
            ffc_pcie_det_en_2   <= 1'b0;
                  // synopsys translate_off
                  det_result[2] <= 1'b1;
                  // synopsys translate_on
         end
         if (done_3_re) begin //pulse
            ffc_pcie_det_en_3   <= 1'b0;
                  // synopsys translate_off
                  det_result[3] <= 1'b1;
                  // synopsys translate_on
         end
      end
      endcase

   end
end

always @(posedge PCLK or negedge RESET_n) begin  //125 or 250 Mhz
   if(!RESET_n) begin
      detsm_cnt  <= 'd0;
      cntdone_en <= 1'b0;
      cntdone_ct <= 1'b0;
   end
   else begin
      // Detect State machine Counter
      if (cnt_enable)
          detsm_cnt <= detsm_cnt + 1'b1;
      else
          detsm_cnt <= 0;

      // pcie_det_en time
      if (detsm_cnt == ONE_US) // 1 us
          cntdone_en <= 1'b1;
      else
          cntdone_en <= 1'b0;

      // pcie_ct time
      if (detsm_cnt == ONE_US_4BYTE) // 2 clks = 16 ns -> 4 byte clks
          cntdone_ct <= 1'b1;
      else
          cntdone_ct <= 1'b0;

      // synopsys translate_off
            // pcie_det_en time -- after 16 clks
            if (detsm_cnt[4:0] == 5'b10000) // 1 us --> 16 clks
                cntdone_en <= 1'b1;
            else
                cntdone_en <= 1'b0;

            // pcie_ct time -- after 19 clks
            if (detsm_cnt[4:0] == 5'b10011) // 2 clks = 16 ns -> 4 byte clks
                cntdone_ct <= 1'b1;
            else
                cntdone_ct <= 1'b0;
      // synopsys translate_on

   end
end

// =============================================================================
// PhyStatus Generation - Det Result and State Changes
// =============================================================================
always @(posedge PCLK or negedge RESET_n) begin  //125 or 250 Mhz
   if(!RESET_n) begin
      PhyStatus         <= 1'b1;
      PowerDown_reg     <= 2'b00;
      PLOL_sync         <= 1'b1;
      PLOL_pclk         <= 1'b1;
   end
   else begin
      // Sync.
      PLOL_sync <= ffs_plol;
      PLOL_pclk <= PLOL_sync;

      PowerDown_reg <= PowerDown;

      if (PLOL_pclk == 1'b0) begin // wait for PLL LOCK
          if ((PowerDown_reg == 2'b00 && PowerDown == 2'b11) ||
              (PowerDown_reg == 2'b11 && PowerDown == 2'b10) ||
              (PowerDown_reg == 2'b00 && PowerDown == 2'b01) ||
              (PowerDown_reg == 2'b01 && PowerDown == 2'b00) ||
              (PowerDown_reg == 2'b00 && PowerDown == 2'b10) ||
              (PowerDown_reg == 2'b10 && PowerDown == 2'b00) ||
              (detsm_done == 1'b1))
              PhyStatus     <= 1'b1;
          else
              PhyStatus     <= 1'b0;
      end
   end
end

         assign ffs_rlol    = ffs_rlol_ch0_int;

/*****************************************************
 *  Reset sequencing logic
*****************************************************/

reg core_rstn_1, core_rstn_2;
   reg rlol_r1, rlol_r2;
   reg [9:0] rsl_rdy_cnt;
   `ifdef SIMULATE
      localparam RSL_RDY_CNT = 10'd100;
   `else
      localparam RSL_RDY_CNT = 10'd1000;
   `endif
   always @ (posedge PCLK or negedge RESET_n) begin
      if (!RESET_n) begin
         core_rstn_1 <=  1'b0 ;
         core_rstn_2 <=  1'b0;
         rlol_r1 <=  1'b0 ;
         rlol_r2 <=  1'b0;
      end else begin
         core_rstn_1 <= rsl_rx_rdy;
         core_rstn_2 <= core_rstn_1;
         rlol_r1 <=  ffs_rlol_ch0_int;
         rlol_r2 <=  rlol_r1;
      end
   end
   assign pcie_ip_rstn = core_rstn_2;
   assign ffs_rlol_ch0 = rlol_r2;

   always @ (posedge PCLK or negedge RESET_n) begin
      if (!RESET_n) begin
         rsl_rdy_cnt <= 0;
         RxValid_0 <= 1'b0;
      end
      else begin
         if (pcie_ip_rstn &&
               RxValid_0i && !RxElecIdle_0 && !ffs_rlol && (RxStatus_0 == 3'b000))
            rsl_rdy_cnt <= rsl_rdy_cnt + 1'b1;
         else rsl_rdy_cnt <= 0;


         if (phy_l0 && RxValid_0i && !RxElecIdle_0 && !ffs_rlol_ch0_int)          RxValid_0 <= RxValid_0i;
         else if (RxValid_0i && rsl_rdy_cnt == RSL_RDY_CNT)                       RxValid_0 <= 1'b1;
         else if (!pcie_ip_rstn || !RxValid_0i || RxElecIdle_0 ||ffs_rlol_ch0_int) RxValid_0 <= 1'b0;
      end
   end

endmodule
