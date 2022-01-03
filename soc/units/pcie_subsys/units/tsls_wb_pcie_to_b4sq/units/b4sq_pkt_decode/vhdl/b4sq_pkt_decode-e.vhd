
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
-- File ID     : $Id: b4sq_pkt_decode-e.vhd 3846 2017-12-27 17:42:58Z  $
-- Generated   : $LastChangedDate: 2017-12-27 18:42:58 +0100 (Wed, 27 Dec 2017) $
-- Revision    : $LastChangedRevision: 3846 $
--
--------------------------------------------------------------------------------
--
-- Description : Decodes transaction from Lattice PCIe core
--               - Generates wishbone cycles for all requests targeting this
--                 device
--               - Extracts incoming completion packets and forwards these to
--                 packet FIFO
--
--------------------------------------------------------------------------------

Library IEEE;
Use IEEE.std_logic_1164.all;

Entity b4sq_pkt_decode is
   Port (
      i_clk                   : in  std_logic;
      i_rst_n                 : in  std_logic;

      i_ca_npd_infinite       : in  std_logic;
      i_ca_nph_infinite       : in  std_logic;
      i_ca_pd_infinite        : in  std_logic;
      i_ca_ph_infinite        : in  std_logic;
      i_cid_bus_nr            : in  std_logic_vector(7 downto 0);
      i_cid_dev_nr            : in  std_logic_vector(4 downto 0);
      i_cid_func_nr           : in  std_logic_vector(2 downto 0);
      i_cfg_io_space_en       : in  std_logic;
      i_cfg_io_space_sel      : in  std_logic_vector(6 downto 0);
      i_cfg_mem_space_en      : in  std_logic;
      i_ctl_max_payload_size  : in  std_logic_vector(2 downto 0);
      i_cplx_tx_free          : in  std_logic_vector;
      i_cplx_txq_ack          : in  std_logic;
      i_dec_cyc               : in  std_logic_vector;
      i_dec_cyc_local         : in  std_logic;
      i_tlp_rx_bar_hit        : in  std_logic_vector(2 downto 0);
      i_tlp_rx_count          : in  std_logic_vector;
      i_tlp_rx_data           : in  std_logic_vector(31 downto 0);
      i_tlp_rx_empty          : in  std_logic;
      i_wb_ack                : in  std_logic;
      i_wb_ack_local          : in  std_logic;
      i_wb_rdat               : in  std_logic_vector(31 downto 0);
      i_wb_rdat_local         : in  std_logic_vector(31 downto 0);

      o_cc_npd_num            : out std_logic_vector(7 downto 0);
      o_cc_pd_num             : out std_logic_vector(7 downto 0);
      o_cc_processed_npd      : out std_logic;
      o_cc_processed_nph      : out std_logic;
      o_cc_processed_pd       : out std_logic;
      o_cc_processed_ph       : out std_logic;
      o_cpld_rx_data          : out std_logic_vector(31 downto 0);
      o_cpld_rx_push          : out std_logic;
      o_cpld_rx_sta_err       : out std_logic;
      o_cpld_rx_tag           : out std_logic_vector(7 downto 0);
      o_cplx_tx_data          : out std_logic_vector(31 downto 0);
      o_cplx_tx_last          : out std_logic;
      o_cplx_tx_push          : out std_logic;
      o_cplx_txq_push         : out std_logic;
      o_dec_adr               : out std_logic_vector;
      o_dec_bar_hit           : out std_logic_vector(6 downto 0);
      o_tlp_rx_pop            : out std_logic;
      o_wb_adr                : out std_logic_vector;
      o_wb_bte                : out std_logic_vector(1 downto 0);
      o_wb_cti                : out std_logic_vector(2 downto 0);
      o_wb_cyc                : out std_logic_vector;
      o_wb_cyc_local          : out std_logic;
      o_wb_sel                : out std_logic_vector(3 downto 0);
      o_wb_stb                : out std_logic;
      o_wb_wdat               : out std_logic_vector(31 downto 0);
      o_wb_we                 : out std_logic;
      o_wb_we_local           : out std_logic
      );
End b4sq_pkt_decode;
