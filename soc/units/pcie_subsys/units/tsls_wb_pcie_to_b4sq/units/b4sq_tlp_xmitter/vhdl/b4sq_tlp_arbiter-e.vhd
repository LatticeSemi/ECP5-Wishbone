
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
-- File ID     : $Id: b4sq_tlp_arbiter-e.vhd 3881 2018-01-05 16:50:29Z  $
-- Generated   : $LastChangedDate: 2018-01-05 17:50:29 +0100 (Fri, 05 Jan 2018) $
-- Revision    : $LastChangedRevision: 3881 $
--
--------------------------------------------------------------------------------
--
-- Description : Arbitrates between Completion FIFO, Posted FIFO and non-posted FIFO
--               for access to Lattice PCIe core
--               Receives ordering information from TLP Queue 
--
--------------------------------------------------------------------------------

Library IEEE;
Use IEEE.std_logic_1164.all;

Entity b4sq_tlp_arbiter is
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
End b4sq_tlp_arbiter;
