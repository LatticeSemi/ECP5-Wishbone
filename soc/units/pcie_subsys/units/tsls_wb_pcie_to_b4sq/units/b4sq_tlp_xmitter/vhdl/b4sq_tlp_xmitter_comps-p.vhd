
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
-- File ID     : $Id: b4sq_tlp_xmitter_comps-p.vhd 4263 2018-06-17 22:01:35Z  $
-- Generated   : $LastChangedDate: 2018-06-18 00:01:35 +0200 (Mon, 18 Jun 2018) $
-- Revision    : $LastChangedRevision: 4263 $
--
--------------------------------------------------------------------------------
--
-- Description : Generates PCIe Completion Responses, as well as posted /non-posted
--               Request Packets
--
--------------------------------------------------------------------------------

Library IEEE;
Use IEEE.std_logic_1164.all;
Use WORK.tspc_utils.all;

Package b4sq_tlp_xmitter_comps is
   Component b4sq_tlp_arbiter
      Port (
         i_clk             : in  std_logic;
         i_rst_n           : in  std_logic;

         i_ca_cpld         : in  std_logic_vector(12 downto 0);
         i_ca_cplh         : in  std_logic_vector(8 downto 0);
         i_ca_npd          : in  std_logic_vector(12 downto 0);
         i_ca_nph          : in  std_logic_vector(8 downto 0);
         i_ca_pd           : in  std_logic_vector(12 downto 0);
         i_ca_ph           : in  std_logic_vector(8 downto 0);
         i_ctl_bus_mst_en  : in  std_logic;
         i_dl_up           : in  std_logic;
         i_fc_cpl_recheck  : in  std_logic;
         i_fc_p_recheck    : in  std_logic;             
         i_ipx_rdy         : in  std_logic;
         i_tlp_data_cpl    : in  std_logic_vector(31 downto 0);
         i_tlp_data_np     : in  std_logic_vector(31 downto 0);
         i_tlp_data_p      : in  std_logic_vector(31 downto 0);
         i_tlp_empty_cpl   : in  std_logic;
         i_tlp_empty_np    : in  std_logic;
         i_tlp_empty_p     : in  std_logic;
         i_txq_data        : in  std_logic_vector(1 downto 0);
         i_txq_empty       : in  std_logic;

         o_ipx_data        : out std_logic_vector(15 downto 0);
         o_ipx_end         : out std_logic;
         o_ipx_req         : out std_logic;
         o_ipx_start       : out std_logic;
         o_tlp_pop_cpl     : out std_logic;
         o_tlp_pop_np      : out std_logic;
         o_tlp_pop_p       : out std_logic;
         o_txq_pop         : out std_logic
         );
   End Component;

      
   Component b4sq_tlp_queue
      Generic (
         g_queue_sz     : positive := 64;
         g_tech_lib     : string := "ECP3"
         );
      Port (
         i_clk             : in  std_logic;
         i_rst_n           : in  std_logic;

         i_txq_pop         : in  std_logic;
         i_txq_push_cplx   : in  std_logic;
         i_txq_push_np     : in  std_logic;
         i_txq_push_p      : in  std_logic;

         o_txq_ack_cplx    : out std_logic;
         o_txq_ack_np      : out std_logic;
         o_txq_ack_p       : out std_logic;
         o_txq_data        : out std_logic_vector(1 downto 0);
         o_txq_empty       : out std_logic
         );
   End Component;

      
   Component tspc_fifo_sync
      Generic (
         g_mem_dmram    : boolean := false;
         g_mem_words    : positive := 256;
         g_tech_lib     : string := "ECP3";
         g_threshold_rd : positive := 1;
         g_threshold_wr : positive := 1         
         );
      Port (
         i_clk          : in  std_logic;
         i_rst_n        : in  std_logic;
         i_clr          : in  std_logic := '0';

         i_rd_pop       : in  std_logic;
         i_wr_din       : in  std_logic_vector;
         i_wr_push      : in  std_logic;

         o_rd_aempty    : out std_logic;
         o_rd_count     : out std_logic_vector(f_vec_msb(g_mem_words) downto 0);
         o_rd_dout      : out std_logic_vector;
         o_rd_empty     : out std_logic;
         o_rd_last      : out std_logic;
         o_wr_afull     : out std_logic;
         o_wr_free      : out std_logic_vector(f_vec_msb(g_mem_words) downto 0);
         o_wr_full      : out std_logic;
         o_wr_last      : out std_logic
         );
   End Component;
End b4sq_tlp_xmitter_comps;
