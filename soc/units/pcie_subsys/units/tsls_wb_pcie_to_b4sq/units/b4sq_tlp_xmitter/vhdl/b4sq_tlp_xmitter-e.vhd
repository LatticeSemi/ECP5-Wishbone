
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
-- File ID     : $Id: b4sq_tlp_xmitter-e.vhd 4261 2018-06-17 21:56:32Z  $
-- Generated   : $LastChangedDate: 2018-06-17 23:56:32 +0200 (Sun, 17 Jun 2018) $
-- Revision    : $LastChangedRevision: 4261 $
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

Entity b4sq_tlp_xmitter is
   Generic (
      g_fifo_sz_cpl        : positive := 512;
      g_fifo_sz_np         : positive := 512;
      g_fifo_sz_p          : positive := 512;
      g_fifo_sz_txseq      : positive := 64;
      g_tech_lib           : string := "ECP3"
      );
   Port (
      i_clk             : in  std_logic;
      i_rst_n           : in  std_logic;

      i_ca_cpld         : in  std_logic_vector(12 downto 0);
      i_ca_cplh         : in  std_logic_vector(8 downto 0);
      i_ca_npd          : in  std_logic_vector(12 downto 0);
      i_ca_nph          : in  std_logic_vector(8 downto 0);
      i_ca_pd           : in  std_logic_vector(12 downto 0);
      i_ca_ph           : in  std_logic_vector(8 downto 0);
      i_dl_up           : in  std_logic;
      i_ctl_bus_mst_en  : in  std_logic;
      i_fc_cpl_recheck  : in  std_logic;
      i_fc_p_recheck    : in  std_logic;      
      i_ipx_rdy         : in  std_logic;
      i_tlp_data_cpl    : in  std_logic_vector(31 downto 0);
      i_tlp_data_np     : in  std_logic_vector(31 downto 0);
      i_tlp_data_p      : in  std_logic_vector(31 downto 0);
      i_tlp_push_cpl    : in  std_logic;
      i_tlp_push_np     : in  std_logic;
      i_tlp_push_p      : in  std_logic;
      i_txq_push_cplx   : in  std_logic;
      i_txq_push_np     : in  std_logic;
      i_txq_push_p      : in  std_logic;

      o_free_count_cpl  : out std_logic_vector(f_vec_msb(g_fifo_sz_cpl) downto 0);
      o_free_count_np   : out std_logic_vector(f_vec_msb(g_fifo_sz_np) downto 0);
      o_free_count_p    : out std_logic_vector(f_vec_msb(g_fifo_sz_p) downto 0);
      o_ipx_data        : out std_logic_vector(15 downto 0);
      o_ipx_end         : out std_logic;
      o_ipx_req         : out std_logic;
      o_ipx_start       : out std_logic;
      o_txq_ack_cplx    : out std_logic;
      o_txq_ack_np      : out std_logic;
      o_txq_ack_p       : out std_logic
      );
End b4sq_tlp_xmitter;
