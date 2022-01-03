
--
--    Copyright Ingenieurbuero Gardiner, 2013 - 2014
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
-- File ID     : $Id: tspc_fifo_ctl_sync-e.vhd 4351 2018-07-07 14:50:25Z  $
-- Generated   : $LastChangedDate: 2018-07-07 16:50:25 +0200 (Sat, 07 Jul 2018) $
-- Revision    : $LastChangedRevision: 4351 $
--
--------------------------------------------------------------------------------
--
-- Description : Control Logic for Synchronous FIFO
--               - Single clock domain for rd and wr
--               - Configurable read and write latency
--               - Single enable for rd address and read data register
--
--------------------------------------------------------------------------------

Library IEEE;
Use IEEE.std_logic_1164.all;
Use WORK.tspc_utils.all;

Entity tspc_fifo_ctl_sync is
   Generic (
      g_flag_rd_threshold  : natural := 1;
      g_flag_wr_threshold  : natural := 1;
      g_rd_latency         : positive range 1 to 2 := 1;
      g_mem_words          : natural;
      g_wr_latency         : positive range 1 to 2 := 1
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
End tspc_fifo_ctl_sync;
