

module x_pcie_pipe (
   input wire                   RESET_n, 
   input wire                   PCLK,
   input wire                   clk_250,

   input wire                   ffs_plol,
   input wire                   TxDetectRx_Loopback,
   input wire [1:0]             PowerDown,
   input wire                   ctc_disable,

   input wire                   TxElecIdle_in,

   input wire                   RxPolarity_in, 
   input wire [7:0]             RxData_in,
   input wire                   RxDataK_in, 
   input wire [2:0]             RxStatus_in,  
   input wire                   RxValid_in,
   input wire                   RxElecIdle_in,

   input wire                   ff_rx_fclk_chx, 

   //----------------- RK BEGIN ------------------------------
   input wire                   pcie_con_x,
   input wire                   pcs_wait_done,
   input wire                   start_mask,
   input wire                   detsm_done,

   output reg                   RxElecIdle_chx_8,  //Not from CTC
   //----------------- RK END --------------------------------
  
   output wire [7:0]           TxData_out,
   output wire                 TxDataK_out, 
   output wire                 TxElecIdle_out,

   output wire                 RxPolarity_out,

      input wire [7:0]         TxData_in,
      input wire               TxDataK_in,

      output wire [7:0]        RxData_out,
      output wire              RxDataK_out, 

   output wire [2:0]           RxStatus_out,  
   output wire                 RxValid_out,
   output wire                 RxElecIdle_out,

   output reg                  ffc_fb_loopback 

  );
  
// =============================================================================
// Parameters
// =============================================================================
localparam  PCS_EDB         = 8'hFE;
localparam  PCS_COMMA       = 8'hBC;


// =============================================================================
// Wires & Regs
// =============================================================================
   wire                     ctc_skip_added;
   wire                     ctc_skip_removed;
   wire                     ctc_over_flow;
   wire                     ctc_under_flow;

   reg [7:0]                RxData_chx_reg /* synthesis syn_srlstyle="registers" */;
   reg                      RxDataK_chx_reg /* synthesis syn_srlstyle="registers" */; 
   reg                      RxValid_chx_reg /* synthesis syn_srlstyle="registers" */;
   reg [2:0]                RxStatus_chx_reg /* synthesis syn_srlstyle="registers" */; 

// =============================================================================
integer                   i, m;

wire [7:0]                RxData_chx_s;
wire                      RxDataK_chx_s; 
wire                      RxValid_chx_s;
wire                      RxElecIdle_chx_s;
wire [2:0]                RxStatus_chx_s; 

reg [7:0]                 TxData_chx_s /* synthesis syn_srlstyle="registers" */;
reg                       TxDataK_chx_s /* synthesis syn_srlstyle="registers" */;
   reg [7:0]              RxData_chx /* synthesis syn_srlstyle="registers" */;
   reg                    RxDataK_chx /* synthesis syn_srlstyle="registers" */;
   wire [7:0]             TxData_chx;
   wire                   TxDataK_chx;

reg                       RxElecIdle_chx /* synthesis syn_srlstyle="registers" */;
reg                       RxValid_chx /* synthesis syn_srlstyle="registers" */;
reg [2:0]                 RxStatus_chx /* synthesis syn_srlstyle="registers" */;

   // COMMA alignment with RxValid Rising Edge
   wire                   comma_chx;

// CTC Outputs
wire[7:0]                 RxData_chx_8;
wire                      RxDataK_chx_8;
wire[2:0]                 RxStatus_chx_8;
//reg                       RxElecIdle_chx_8;  //Not from CTC   OUTPUT
wire                      RxValid_chx_8;


// Recoverd clks
reg                       pcs_wait_done_chx_sync;
reg                       ei_ctc_chx_sync;
reg                       ei_ctc_chx /* synthesis syn_srlstyle="registers" */;
wire                      chx_RESET_n;

reg                       pcs_wait_done_chx /* synthesis syn_srlstyle="registers" */;
reg                       ctc_reset_chx;


reg                       start_mask_sync;
reg                       start_mask_fclk /* synthesis syn_srlstyle="registers" */;
reg [20:0]                rxelec_ctc_delay_chx /* synthesis syn_srlstyle="registers" */;

reg [20:0]                rxvalid_delay_chx /* synthesis syn_srlstyle="registers" */;

reg                       TxElecIdle_chx_s /* synthesis syn_srlstyle="registers" */;



// =============================================================================
//-------- RX PATH INPUTS
//From SERDES (Inputs)
assign RxData_chx_s     = RxData_in;
assign RxDataK_chx_s    = RxDataK_in;
assign RxValid_chx_s    = RxValid_in;
assign RxStatus_chx_s   = RxStatus_in;
assign RxElecIdle_chx_s = RxElecIdle_in;

//--------- RX PATH OUTPUTS 
//From CTC/RX_GEAR (Outputs) TO PIPE
assign RxData_out       = RxData_chx;
assign RxDataK_out      = RxDataK_chx;
assign RxValid_out      = RxValid_chx ;
assign RxStatus_out     = RxStatus_chx;
assign RxElecIdle_out   = RxElecIdle_chx;


//-------- TX PATH INPUTS 
//From PIPE (Inputs)
assign TxData_chx       = TxData_in;
assign TxDataK_chx      = TxDataK_in;
assign TxElecIdle_chx   = TxElecIdle_in;

//-------- TX PATH OUTPUTS 
//From Input/TX_GEAR (Outputs) TO SERDES
assign TxData_out       = TxData_chx_s;
assign TxDataK_out      = TxDataK_chx_s;
assign TxElecIdle_out   = TxElecIdle_chx_s;

// =============================================================================

//CTC --> Recovered clks
always @(posedge ff_rx_fclk_chx or negedge RESET_n) begin
   if(!RESET_n) begin
      pcs_wait_done_chx_sync <= 1'b0;
      pcs_wait_done_chx      <= 1'b0;
      ei_ctc_chx_sync        <= 1'b1;
      ei_ctc_chx             <= 1'b1;
      ctc_reset_chx          <= 1'b0;
   end
   else begin
      // For CTC write enable/RESET (RLOL qualified with EI)
      // RxEI should be LOW & pcs_wait_done should be HIGH for CTC 
      // to start, otherwise CTC will be held in RESET
      ctc_reset_chx          <= ~ei_ctc_chx & pcs_wait_done_chx;

      //Sync.
      // For RxValid Mask
      pcs_wait_done_chx_sync <= pcs_wait_done;
      pcs_wait_done_chx      <= pcs_wait_done_chx_sync;

      ei_ctc_chx_sync        <= rxelec_ctc_delay_chx[20];   //Unmasked RxElecIdle to reset ctc
      ei_ctc_chx             <= ei_ctc_chx_sync;
   end
end

// =============================================================================
// EI bypass CTC : Create equal delay  (250 PLL clk)
// No CDR clk when EI is HIGH
// =============================================================================
always @(posedge clk_250 or negedge RESET_n) begin
   if(!RESET_n) begin
      start_mask_sync       <= 1'b0;
      start_mask_fclk       <= 1'b0;
      RxElecIdle_chx_8      <= 1'b1;
      rxelec_ctc_delay_chx  <= 20'hFFFFF;
   end
   else begin
      start_mask_sync  <= start_mask;
      start_mask_fclk  <= start_mask_sync;

      // Min. 12 : 250 clks for EI Mask
      // RxElecIdle_chx_8 is the Masked RxElecIdle siganl
      RxElecIdle_chx_8 <= rxelec_ctc_delay_chx[20] | start_mask_fclk;
      rxelec_ctc_delay_chx[20:0] <= {rxelec_ctc_delay_chx[19:0],RxElecIdle_chx_s};
   end
end

// =============================================================================
//                          ====TX PATH===
// =============================================================================
always @(posedge clk_250 or negedge RESET_n) begin
   if(!RESET_n) begin
      TxData_chx_s     <= 0;
      TxDataK_chx_s    <= 0;
      TxElecIdle_chx_s <= 1'b1;
   end
   else begin  
      TxData_chx_s     <= TxData_chx;
      TxDataK_chx_s    <= TxDataK_chx;
      TxElecIdle_chx_s <= TxElecIdle_chx;
   end
end

// =============================================================================
//                          ====RX PATH===
// =============================================================================
// =============================================================================
// The RxValid_chx signal is going low early before the data comming
// out of PCS, so delay this signal
// Delayed by 21 Clocks * 4 ns = 84 ns;
// =============================================================================
always @(posedge ff_rx_fclk_chx or negedge RESET_n) begin  // Recovered clk
   if(!RESET_n) begin
      RxDataK_chx_reg     <= 1'b0;
      RxData_chx_reg      <= 8'h00;
      RxValid_chx_reg     <= 1'b0; 
      rxvalid_delay_chx   <= 0;
      RxStatus_chx_reg    <= 3'b000;
   end
   else begin  
      RxDataK_chx_reg     <= RxDataK_chx_s;
      RxData_chx_reg      <= RxData_chx_s;

      RxValid_chx_reg     <= rxvalid_delay_chx[20]; 
      RxStatus_chx_reg    <= RxStatus_chx_s;

      rxvalid_delay_chx[20:0] <= {rxvalid_delay_chx[19:0],(RxValid_chx_s & pcs_wait_done_chx)};
   end
end

// =================================================================
// RxData Input (From SERDES TO CTC )           -  8-bit PIPE
// RxData output (From CTC)                     -- 8-bit PIPE
//
// RxData Input (From SERDES TO CTC TO Rx_gear) - 16-bit PIPE
// RxData output (From Rx_gear)                 - 16-bit PIPE
// =============================================================================
   assign comma_chx = (RxDataK_chx_8 && (RxData_chx_8 == PCS_COMMA)) ? 1'b1 : 1'b0;

   always @(posedge PCLK  or negedge RESET_n) begin  //250 PLL clk
      if(!RESET_n) begin
         RxDataK_chx     <= 1'b0;
         RxData_chx      <= 8'h0;
         RxElecIdle_chx  <= 1'b1; 
         RxValid_chx     <= 1'b0; 
         RxStatus_chx    <= 3'b000;
      end
      else begin  
         RxData_chx  <= RxData_chx_8;
         RxDataK_chx <= RxDataK_chx_8;

         // RxValid Rising Edge should be with COMMA 
         if (RxValid_chx_8 && comma_chx)
            RxValid_chx     <= 1'b1;
         else if (~RxValid_chx_8)
            RxValid_chx     <= 1'b0;

         if (detsm_done) begin
            if (pcie_con_x) //No Sync. is required
               RxStatus_chx  <= 3'b011;  //DETECTED
            else
               RxStatus_chx  <= 3'b000;  //NOT DETECTED
         end
	 else begin
            RxStatus_chx  <= RxStatus_chx_8;
         end

         RxElecIdle_chx  <= RxElecIdle_chx_8; 
      end
   end



// =================================================================
// CTC instantiation 
// =================================================================

   //8-bit/16-bit
   //Both should be HIGH for CTC to start
   assign chx_RESET_n = RESET_n & ctc_reset_chx; 

   x_pcie_ctc u0_ctc
      (
      //------- Inputs 
      .rst_n                  (chx_RESET_n),          
      .clk_in                 (ff_rx_fclk_chx),           
      .clk_out                (clk_250),         
      .ctc_disable            (ctc_disable),         
      .data_in                (RxData_chx_reg),        
      .kcntl_in               (RxDataK_chx_reg),        
      .status_in              (RxStatus_chx_reg),       
      .lanesync_in            (RxValid_chx_reg),

      //------- Outputs 
      .ctc_read_enable        (),
      .ctc_skip_added         (ctc_skip_added),     
      .ctc_skip_removed       (ctc_skip_removed),  
      .ctc_data_out           (RxData_chx_8),        
      .ctc_kcntl_out          (RxDataK_chx_8),        
      .ctc_status_out         (RxStatus_chx_8),       
      .ctc_lanesync_out       (RxValid_chx_8),
      .ctc_under_flow         (ctc_under_flow),  
      .ctc_over_flow          (ctc_over_flow)
    );

// =============================================================================
// Rxdata : From CTC --> Rx_gear   -- 16-bit PIPE  -- 
// =============================================================================

// =============================================================================
//Assert slave loopback as long as TxDetectRx_Loopback is asserted by FPGA side
//when Serdes is in normal mode and TxElecIdle_ch0 is inactive.
// =============================================================================
always @(posedge PCLK or negedge RESET_n) begin
   if(!RESET_n) begin
      ffc_fb_loopback <= 1'b0;
   end
   else begin  
      ffc_fb_loopback <= ((PowerDown == 2'b00) & TxDetectRx_Loopback & !TxElecIdle_chx) ? 1'b1: 1'b0;
   end
end

// =============================================================================
// synchronize RxPolarity signal to RX recovered clock  (all modes)
// =============================================================================
reg sync1_RxPolarity ;
reg sync2_RxPolarity  /* synthesis syn_srlstyle="registers" */;
always @(posedge ff_rx_fclk_chx or negedge RESET_n) begin
   if(!RESET_n) begin
      sync1_RxPolarity <= 'h0;
      sync2_RxPolarity <= 'h0;
   end
   else begin
      sync1_RxPolarity <= RxPolarity_in ;
      sync2_RxPolarity <= sync1_RxPolarity ;
   end
end
assign RxPolarity_out = sync2_RxPolarity ;


endmodule
// =============================================================================


