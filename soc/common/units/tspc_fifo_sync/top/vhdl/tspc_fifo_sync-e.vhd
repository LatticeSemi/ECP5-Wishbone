
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
-- File ID     : $Id: tspc_fifo_sync-e.vhd 4267 2018-06-17 22:12:50Z  $
-- Generated   : $LastChangedDate: 2018-06-18 00:12:50 +0200 (Mon, 18 Jun 2018) $
-- Revision    : $LastChangedRevision: 4267 $
--
--------------------------------------------------------------------------------
--
-- Description : Synchronous FIFO Wrapper for Lattice PMI Memories
--
--------------------------------------------------------------------------------

Library IEEE;
 
Use IEEE.std_logic_1164.all;
Use WORK.tspc_utils.all;

Entity tspc_fifo_sync is
   Generic (
      g_mem_dmram    : boolean := false;
      g_mem_words    : positive := 256; 
      g_tech_lib     : string := "ECP3";
      g_tech_type    : string := "ANY";
      g_rd_latency   : positive := 1;
      g_threshold_rd : positive := 1;
      g_threshold_wr : positive := 1
      );    
   Port ( 
      i_clk          : in  std_logic;
      i_rst_n        : in  std_logic;
      i_clr          : in  std_logic;

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
End tspc_fifo_sync;
