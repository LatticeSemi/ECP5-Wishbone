
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
-- File ID     : $Id: b4sq_pkt_rx_fifo_comps-p.vhd 4296 2018-06-17 22:59:10Z  $
-- Generated   : $LastChangedDate: 2018-06-18 00:59:10 +0200 (Mon, 18 Jun 2018) $
-- Revision    : $LastChangedRevision: 4296 $
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

Package b4sq_pkt_rx_fifo_comps is
   Component b4sq_pkt_rx_fifo_istage
      Port (
         i_clk                : in  std_logic;
         i_rst_n              : in  std_logic;

         i_dl_up              : in  std_logic;
         i_rx_bar_hit         : in  std_logic_vector(6 downto 0);
         i_rx_data            : in  std_logic_vector(15 downto 0);
         i_rx_end             : in  std_logic;
         i_rx_st              : in  std_logic;

         o_cpld_rx_data       : out std_logic_vector(31 downto 0);
         o_cpld_rx_push       : out std_logic;
         o_cpld_rx_sta_err    : out std_logic;
         o_cpld_rx_tag        : out std_logic_vector(7 downto 0);
         o_rx_bar_hit         : out std_logic_vector(2 downto 0);
         o_rx_data            : out std_logic_vector(31 downto 0);
         o_rx_push            : out std_logic;
         o_rx_sof             : out std_logic
         );
   End Component;
   
   
   Component tspc_fifo_ctl_sync
      Generic (
         g_flag_rd_threshold  : natural := 1;
         g_flag_wr_threshold  : natural := 1;
         g_rd_latency         : positive := 1;
         g_mem_words          : natural;
         g_wr_latency         : positive := 1
         );
      Port (
         i_rst_n        : in  std_logic;
         i_clk          : in  std_logic;
         i_clr          : in  std_logic;
         i_clk_en       : in  std_logic;

         i_rd_en        : in  std_logic;
         i_wr_en        : in  std_logic;

         o_rd_adr       : out std_logic_vector;
         o_rd_aempty    : out std_logic;
         o_rd_count     : out std_logic_vector(f_vec_msb(g_mem_words) downto 0);
         o_rd_empty     : out std_logic;
         o_rd_en        : out std_logic;
         o_rd_last      : out std_logic;
         o_wr_adr       : out std_logic_vector;
         o_wr_afull     : out std_logic;
         o_wr_en        : out std_logic;
         o_wr_free      : out std_logic_vector(f_vec_msb(g_mem_words) downto 0);
         o_wr_full      : out std_logic;
         o_wr_last      : out std_logic
         );
   End Component;
End b4sq_pkt_rx_fifo_comps;
