
//    
//    Copyright Ingenieurbuero Gardiner, 2007 - 2014
//
//    All Rights Reserved
//
//       This proprietary software may be used only as authorised in a licensing,
//       product development or training agreement.
//
//       Copies may only be made to the extent permitted by such an aforementioned
//       agreement. This entire notice above must be reproduced on
//       all copies.
//     
//------------------------------------------------------------------------------
//
// File ID     : $Id: b4sq_credit_config.v 3846 2017-12-27 17:42:58Z  $
// Generated   : $LastChangedDate: 2017-12-27 18:42:58 +0100 (Wed, 27 Dec 2017) $
// Revision    : $LastChangedRevision: 3846 $
//
//------------------------------------------------------------------------------
//
// Description : Extracts configuration information from config files generated
//               by IPexpress or Clarity
//   
//------------------------------------------------------------------------------

`include "pci_exp_params.v" 
 
`timescale 1 ns / 1 ps
module b4sq_credit_config (
   output wire          o_fc_cpld_infinite,
   output wire          o_fc_cplh_infinite,
   output wire          o_fc_npd_infinite, 
   output wire          o_fc_nph_infinite,
   output wire          o_fc_pd_infinite,    
   output wire          o_fc_ph_infinite,
   output wire [6:0]    o_io_space_sel,
   output wire [7:0]    o_hw_rev,
   output wire [15:0]   o_subsys_id
   );

   wire [31:0]    w_init_reg_8;
   wire [31:0]    w_init_reg_2c;
      
   assign o_fc_ph_infinite    = ( `INIT_PH_FC_VC0 == 0)   ? 1'b1 : 1'b0;
   assign o_fc_pd_infinite    = ( `INIT_PD_FC_VC0 == 0)   ? 1'b1 : 1'b0;
   assign o_fc_nph_infinite   = ( `INIT_NPH_FC_VC0 == 0)  ? 1'b1 : 1'b0;
   assign o_fc_npd_infinite   = ( `INIT_NPD_FC_VC0 == 0)  ? 1'b1 : 1'b0;
   
   assign o_io_space_sel[0]   = `INIT_REG_010 & 1'b1;
   assign o_io_space_sel[1]   = `INIT_REG_014 & 1'b1;
   assign o_io_space_sel[2]   = `INIT_REG_018 & 1'b1;
   assign o_io_space_sel[3]   = `INIT_REG_01C & 1'b1;
   assign o_io_space_sel[4]   = `INIT_REG_020 & 1'b1;
   assign o_io_space_sel[5]   = `INIT_REG_024 & 1'b1;
   assign o_io_space_sel[6]   = 1'b0;
   
   assign o_hw_rev            = w_init_reg_8[7:0];
   
   assign o_subsys_id         = w_init_reg_2c[31:16];
   
   `ifdef INIT_CPLH_FC_VC0
      assign o_fc_cplh_infinite  = ( `INIT_CPLH_FC_VC0 == 0) ? 1'b1 : 1'b0;
   `else
      assign o_fc_cplh_infinite  = 1'b1;
   `endif
   
   `ifdef INIT_CPLD_FC_VC0
      assign o_fc_cpld_infinite  = ( `INIT_CPLD_FC_VC0 == 0) ? 1'b1 : 1'b0;
   `else
      assign o_fc_cpld_infinite  = 1'b1;
   `endif
   
   assign w_init_reg_8  = `INIT_REG_008;
   assign w_init_reg_2c = `INIT_REG_02C;
   
endmodule
