
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
-- File ID     : $Id: b4sq_tlp_xmitter-a_rtl.vhd 4261 2018-06-17 21:56:32Z  $
-- Generated   : $LastChangedDate: 2018-06-17 23:56:32 +0200 (Sun, 17 Jun 2018) $
-- Revision    : $LastChangedRevision: 4261 $
--
--------------------------------------------------------------------------------
--
-- Description : Generates PCIe Completion Responses, as well as posted /non-posted
--               Request Packets
--
--------------------------------------------------------------------------------

Use WORK.b4sq_tlp_xmitter_comps.all;

Architecture Rtl of b4sq_tlp_xmitter is

   signal s_u1_ipx_data       : std_logic_vector(15 downto 0);
   signal s_u1_ipx_end        : std_logic;
   signal s_u1_ipx_req        : std_logic;
   signal s_u1_ipx_start      : std_logic;
   signal s_u1_tlp_pop_cpl    : std_logic;
   signal s_u1_tlp_pop_np     : std_logic;
   signal s_u1_tlp_pop_p      : std_logic;
   signal s_u1_txq_pop        : std_logic;
   signal s_u2_txq_ack_cplx   : std_logic;
   signal s_u2_txq_ack_np     : std_logic;
   signal s_u2_txq_ack_p      : std_logic;
   signal s_u2_txq_data       : std_logic_vector(1 downto 0);
   signal s_u2_txq_empty      : std_logic;
   signal s_u3_dout_cplx      : std_logic_vector(31 downto 0);
   signal s_u3_empty_cplx     : std_logic;
   signal s_u3_wrfree_cplx    : std_logic_vector(f_vec_msb(g_fifo_sz_cpl) downto 0);
   signal s_u4_dout_np        : std_logic_vector(31 downto 0);
   signal s_u4_empty_np       : std_logic;
   signal s_u4_wrfree_np      : std_logic_vector(f_vec_msb(g_fifo_sz_np) downto 0);
   signal s_u5_dout_p         : std_logic_vector(31 downto 0);
   signal s_u5_empty_p        : std_logic;
   signal s_u5_wrfree_p       : std_logic_vector(f_vec_msb(g_fifo_sz_p) downto 0);
         
Begin
   o_free_count_cpl  <= s_u3_wrfree_cplx;
   o_free_count_np   <= s_u4_wrfree_np;
   o_free_count_p    <= s_u5_wrfree_p;
         
   o_ipx_data        <= s_u1_ipx_data;
   o_ipx_end         <= s_u1_ipx_end;
   o_ipx_req         <= s_u1_ipx_req;
   o_ipx_start       <= s_u1_ipx_start;

   o_txq_ack_cplx    <= s_u2_txq_ack_cplx;
   o_txq_ack_np      <= s_u2_txq_ack_np;
   o_txq_ack_p       <= s_u2_txq_ack_p;
   
      --    ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~   
   U1_ARB:
      -- Co-ordinates access to Lattice PCIe Core
   b4sq_tlp_arbiter
      Port Map (
         i_clk             => i_clk,
         i_rst_n           => i_rst_n,

         i_ca_cpld         => i_ca_cpld,
         i_ca_cplh         => i_ca_cplh,
         i_ca_npd          => i_ca_npd,
         i_ca_nph          => i_ca_nph,
         i_ca_pd           => i_ca_pd,
         i_ca_ph           => i_ca_ph,
         i_ctl_bus_mst_en  => i_ctl_bus_mst_en,
         i_dl_up           => i_dl_up,
         i_fc_cpl_recheck  => i_fc_cpl_recheck,
         i_fc_p_recheck    => i_fc_p_recheck,
         i_ipx_rdy         => i_ipx_rdy,
         i_tlp_data_cpl    => s_u3_dout_cplx,
         i_tlp_data_np     => s_u4_dout_np,
         i_tlp_data_p      => s_u5_dout_p,
         i_tlp_empty_cpl   => s_u3_empty_cplx,
         i_tlp_empty_np    => s_u4_empty_np,
         i_tlp_empty_p     => s_u5_empty_p,
         i_txq_data        => s_u2_txq_data,
         i_txq_empty       => s_u2_txq_empty,

         o_ipx_data        => s_u1_ipx_data,
         o_ipx_end         => s_u1_ipx_end,
         o_ipx_req         => s_u1_ipx_req,
         o_ipx_start       => s_u1_ipx_start,
         o_tlp_pop_cpl     => s_u1_tlp_pop_cpl,
         o_tlp_pop_np      => s_u1_tlp_pop_np,
         o_tlp_pop_p       => s_u1_tlp_pop_p,
         o_txq_pop         => s_u1_txq_pop
         );

   U2_TXQ:
      -- Tracks order in which PCIe requests/completion are scheduled for transmission
   b4sq_tlp_queue 
      Generic Map (
         g_queue_sz     => g_fifo_sz_txseq,
         g_tech_lib     => g_tech_lib
         )
      Port Map (
         i_clk             => i_clk,
         i_rst_n           => i_rst_n,

         i_txq_pop         => s_u1_txq_pop,
         i_txq_push_cplx   => i_txq_push_cplx,
         i_txq_push_np     => i_txq_push_np,
         i_txq_push_p      => i_txq_push_p,

         o_txq_ack_cplx    => s_u2_txq_ack_cplx,
         o_txq_ack_np      => s_u2_txq_ack_np,
         o_txq_ack_p       => s_u2_txq_ack_p,
         o_txq_data        => s_u2_txq_data,
         o_txq_empty       => s_u2_txq_empty
         );

   U3_FCPL:
      -- FIFO for Completion transactions   
   tspc_fifo_sync
      Generic Map (
         g_mem_words    => g_fifo_sz_cpl,
         g_tech_lib     => g_tech_lib
         )
      Port Map (
         i_clk          => i_clk,
         i_rst_n        => i_rst_n,
         i_clr          => c_tie_low,

         i_rd_pop       => s_u1_tlp_pop_cpl,
         i_wr_din       => i_tlp_data_cpl,
         i_wr_push      => i_tlp_push_cpl,

         o_rd_aempty    => open,
         o_rd_count     => open,
         o_rd_dout      => s_u3_dout_cplx,
         o_rd_empty     => s_u3_empty_cplx,
         o_rd_last      => open,
         o_wr_afull     => open,
         o_wr_free      => s_u3_wrfree_cplx,
         o_wr_full      => open,
         o_wr_last      => open
         );

   U4_FNP:
      -- FIFO for non-posted transactions
   tspc_fifo_sync
      Generic Map (
         g_mem_words    => g_fifo_sz_np,
         g_tech_lib     => g_tech_lib
         )
      Port Map (
         i_clk          => i_clk,
         i_rst_n        => i_rst_n,
         i_clr          => c_tie_low,
         
         i_rd_pop       => s_u1_tlp_pop_np,
         i_wr_din       => i_tlp_data_np,
         i_wr_push      => i_tlp_push_np,

         o_rd_aempty    => open,
         o_rd_count     => open,
         o_rd_dout      => s_u4_dout_np,
         o_rd_empty     => s_u4_empty_np,
         o_rd_last      => open,
         o_wr_afull     => open,
         o_wr_free      => s_u4_wrfree_np,
         o_wr_full      => open,
         o_wr_last      => open
         );

   U5_FP:
      -- FIFO for posted transactions
   tspc_fifo_sync
      Generic Map (
         g_mem_words    => g_fifo_sz_p,
         g_tech_lib     => g_tech_lib
         )
      Port Map (
         i_clk          => i_clk,
         i_rst_n        => i_rst_n,
         i_clr          => c_tie_low,

         i_rd_pop       => s_u1_tlp_pop_p,
         i_wr_din       => i_tlp_data_p,
         i_wr_push      => i_tlp_push_p,

         o_rd_aempty    => open,
         o_rd_count     => open,
         o_rd_dout      => s_u5_dout_p,
         o_rd_empty     => s_u5_empty_p,
         o_rd_last      => open,
         o_wr_afull     => open,
         o_wr_free      => s_u5_wrfree_p,
         o_wr_full      => open,
         o_wr_last      => open
         );            
End Rtl;
