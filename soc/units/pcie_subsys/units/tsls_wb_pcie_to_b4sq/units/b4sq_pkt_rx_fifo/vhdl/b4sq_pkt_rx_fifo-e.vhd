
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
-- File ID     : $Id: b4sq_pkt_rx_fifo-e.vhd 4261 2018-06-17 21:56:32Z  $
-- Generated   : $LastChangedDate: 2018-06-17 23:56:32 +0200 (Sun, 17 Jun 2018) $
-- Revision    : $LastChangedRevision: 4261 $
--
--------------------------------------------------------------------------------
--
-- Description : Accepts packets from Lattice PCIe core and forwards these to
--               32-bit bus for further processing
--
--------------------------------------------------------------------------------

Library IEEE;
Use IEEE.std_logic_1164.all;
Use WORK.tspc_utils.all;

Entity b4sq_pkt_rx_fifo is
   Generic (
      g_mem_words    : positive;
      g_tech_lib     : string := "ECP3"
      );
   Port (
      i_clk                : in  std_logic;
      i_rst_n              : in  std_logic;

      i_dl_up              : in  std_logic;
      i_rx_bar_hit         : in  std_logic_vector(6 downto 0);
      i_rx_data            : in  std_logic_vector;
      i_rx_end             : in  std_logic;
      i_rx_pop             : in  std_logic;
      i_rx_st              : in  std_logic;

      o_cpld_rx_data       : out std_logic_vector(31 downto 0);
      o_cpld_rx_push       : out std_logic;
      o_cpld_rx_sta_err    : out std_logic;
      o_cpld_rx_tag        : out std_logic_vector(7 downto 0);
      o_rx_aempty          : out std_logic;
      o_rx_bar_hit         : out std_logic_vector(2 downto 0);
      o_rx_count           : out std_logic_vector(f_vec_msb(g_mem_words) downto 0);
      o_rx_data            : out std_logic_vector(31 downto 0);
      o_rx_empty           : out std_logic;
      o_rx_sof             : out std_logic
      );
End b4sq_pkt_rx_fifo;
