
--
--    Copyright Ingenieurbuero Gardiner, 2007 - 2014
--
--    All Rights Reserved
--
--       This proprietary software may be used only as authorised in a licensing,
--       product development or training agreement.
--
--       Copies may only be made to the extent permitted by such an aforementioned
--       agreement. This entire notice above must be reproduced on
--       all copies.
--
--------------------------------------------------------------------------------
--
-- File ID     : $Id: b4sq_tlp_queue-a_rtl.vhd 4261 2018-06-17 21:56:32Z  $
-- Generated   : $LastChangedDate: 2018-06-17 23:56:32 +0200 (Sun, 17 Jun 2018) $
-- Revision    : $LastChangedRevision: 4261 $
--
--------------------------------------------------------------------------------
--
-- Description : Tracks ordering in which PCIe posted/non-posted and completion
--               transactions were received from enclosing super-structure
--
--------------------------------------------------------------------------------

Use WORK.b4sq_tlp_queue_comps.all;
Use WORK.tspc_utils.all;

Architecture Rtl of b4sq_tlp_queue is
   signal s_u1_txq_ack_cplx   : std_logic;
   signal s_u1_txq_ack_np     : std_logic;
   signal s_u1_txq_ack_p      : std_logic;
   signal s_u1_txq_push       : std_logic;
   signal s_u1_txq_wdat       : std_logic_vector(1 downto 0);
   signal s_u2_txq_empty      : std_logic;
   signal s_u2_txq_full       : std_logic;
   signal s_u2_txq_rdat       : std_logic_vector(1 downto 0);
   
Begin
   o_txq_ack_cplx    <= s_u1_txq_ack_cplx;
   o_txq_ack_np      <= s_u1_txq_ack_np;
   o_txq_ack_p       <= s_u1_txq_ack_p;

   o_txq_data        <= s_u2_txq_rdat;
   o_txq_empty       <= s_u2_txq_empty;
   
      --    ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   U1_CTL:
   b4sq_tlp_queue_ctl
      Port Map (
         i_clk             => i_clk,
         i_rst_n           => i_rst_n,

         i_txq_full        => s_u2_txq_full,
         i_txq_push_cplx   => i_txq_push_cplx,
         i_txq_push_np     => i_txq_push_np,
         i_txq_push_p      => i_txq_push_p,

         o_txq_ack_cplx    => s_u1_txq_ack_cplx,
         o_txq_ack_np      => s_u1_txq_ack_np,
         o_txq_ack_p       => s_u1_txq_ack_p,
         o_txq_wdat        => s_u1_txq_wdat,
         o_txq_push        => s_u1_txq_push
         );

   U2_TXQ:
   tspc_fifo_sync 
      Generic Map (
         g_mem_dmram    => true,
         g_mem_words    => g_queue_sz,
         g_tech_lib     => g_tech_lib
         )
      Port Map (
         i_clk          => i_clk,
         i_rst_n        => i_rst_n,
         i_clr          => c_tie_low,

         i_rd_pop       => i_txq_pop,
         i_wr_din       => s_u1_txq_wdat,
         i_wr_push      => s_u1_txq_push,

         o_rd_aempty    => open,
         o_rd_count     => open,
         o_rd_dout      => s_u2_txq_rdat,
         o_rd_empty     => s_u2_txq_empty,
         o_rd_last      => open,
         o_wr_afull     => open,
         o_wr_free      => open,
         o_wr_full      => s_u2_txq_full,
         o_wr_last      => open
         );
End Rtl;
