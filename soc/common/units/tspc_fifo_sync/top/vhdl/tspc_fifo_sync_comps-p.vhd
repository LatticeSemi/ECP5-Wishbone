

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
-- File ID     : $Id: tspc_fifo_sync_comps-p.vhd 4267 2018-06-17 22:12:50Z  $
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

Package tspc_fifo_sync_comps is
   Component tspc_fifo_ctl_sync
      Generic (
         g_flag_rd_threshold  : natural := 1;
         g_flag_wr_threshold  : natural := 1;
         g_rd_latency         : positive;
         g_mem_words          : natural;
         g_wr_latency         : positive
         );        
      Port ( 
         i_rst_n        : in std_logic;
         i_clk          : in std_logic;
         i_clk_en       : in std_logic;
         i_clr          : in  std_logic;

         i_rd_en        : in std_logic;        
         i_wr_en        : in std_logic;

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


   Component tspc_fifo_sync_mem
      Generic (
         g_mem_dmram    : boolean := false;
         g_mem_words    : natural;
         g_rd_latency   : positive := 1;
         g_tech_lib     : string := "ECP3";
         g_tech_type    : string := "ANY";
         g_wr_latency   : positive := 1
         );   
      Port ( 
         i_clk          : in  std_logic;
         i_rst_n        : in  std_logic;
         i_clr          : in  std_logic;

         i_rd_adr       : in  std_logic_vector;
         i_rd_clk_en    : in  std_logic;
         i_rd_reg_en    : in  std_logic;

         i_wr_adr       : in  std_logic_vector;
         i_wr_clk_en    : in  std_logic;
         i_wr_din       : in  std_logic_vector;
         i_wr_en        : in  std_logic;

         o_rd_dout      : out std_logic_vector
         );   
   End Component;
End tspc_fifo_sync_comps;
