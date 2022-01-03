
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
-- File ID     : $Id: tspc_fifo_sync-a_rtl.vhd 4196 2018-05-22 13:08:18Z  $
-- Generated   : $LastChangedDate: 2018-05-22 15:08:18 +0200 (Tue, 22 May 2018) $
-- Revision    : $LastChangedRevision: 4196 $
--
--------------------------------------------------------------------------------
--
-- Description : Synchronous FIFO Wrapper for Lattice PMI Memories
--
--------------------------------------------------------------------------------

Library IEEE;
 
Use IEEE.numeric_std.all;
Use WORK.tspc_fifo_sync_comps.all;

Architecture Rtl of tspc_fifo_sync is
   constant c_fifo_wr_latency : natural := 1;
   
   constant c_tie_high     : std_logic := '1';
   constant c_tie_low      : std_logic := '0';
   
   signal s_u1_mem_rd_adr     : std_logic_vector(f_vec_msb(g_mem_words - 1) downto 0);
   signal s_u1_mem_wr_adr     : std_logic_vector(f_vec_msb(g_mem_words - 1) downto 0);
   signal s_u1_mem_wr_en      : std_logic;
   signal s_u1_rd_aempty      : std_logic;
   signal s_u1_rd_count       : std_logic_vector(f_vec_msb(g_mem_words) downto 0);
   signal s_u1_rd_empty       : std_logic;
   signal s_u1_rd_en          : std_logic;
   signal s_u1_rd_last        : std_logic;
   signal s_u1_wr_afull       : std_logic;
   signal s_u1_wr_free        : std_logic_vector(f_vec_msb(g_mem_words) downto 0);
   signal s_u1_wr_full        : std_logic;
   signal s_u1_wr_last        : std_logic;
   
Begin
   o_rd_aempty    <= s_u1_rd_aempty;
   o_rd_count     <= f_cp_resize(s_u1_rd_count, o_rd_count'length);
   o_rd_empty     <= s_u1_rd_empty;
   o_rd_last      <= s_u1_rd_last;
   o_wr_afull     <= s_u1_wr_afull;
   o_wr_free      <= f_cp_resize(s_u1_wr_free, o_wr_free'length);
   o_wr_full      <= s_u1_wr_full;
   o_wr_last      <= s_u1_wr_last;
   
      --    ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   U1_CTL: tspc_fifo_ctl_sync
      Generic Map (
         g_flag_rd_threshold  => g_threshold_rd,
         g_flag_wr_threshold  => g_threshold_wr,
         g_rd_latency         => g_rd_latency,
         g_mem_words          => g_mem_words,
         g_wr_latency         => c_fifo_wr_latency
         ) 
      Port Map ( 
         i_rst_n        => i_rst_n,
         i_clk          => i_clk,
         i_clk_en       => c_tie_high,
         i_clr          => i_clr,

         i_rd_en        => i_rd_pop,
         i_wr_en        => i_wr_push,

         o_rd_adr       => s_u1_mem_rd_adr,
         o_rd_aempty    => s_u1_rd_aempty,
         o_rd_count     => s_u1_rd_count,
         o_rd_empty     => s_u1_rd_empty,
         o_rd_en        => s_u1_rd_en,
         o_rd_last      => s_u1_rd_last,
         o_wr_adr       => s_u1_mem_wr_adr,
         o_wr_afull     => s_u1_wr_afull,
         o_wr_en        => s_u1_mem_wr_en,
         o_wr_free      => s_u1_wr_free,
         o_wr_full      => s_u1_wr_full,
         o_wr_last      => s_u1_wr_last
         );

   U2_MEM:      
   tspc_fifo_sync_mem
      Generic Map (
         g_mem_dmram    => g_mem_dmram,
         g_mem_words    => g_mem_words,
         g_rd_latency   => g_rd_latency,
         g_tech_lib     => g_tech_lib,
         g_tech_type    => g_tech_type,
         g_wr_latency   => c_fifo_wr_latency
         ) 
      Port Map ( 
         i_clk       => i_clk,
         i_rst_n     => i_rst_n,
         i_clr       => i_clr,

         i_rd_adr    => s_u1_mem_rd_adr,
         i_rd_clk_en => s_u1_rd_en,
         i_rd_reg_en => s_u1_rd_en,

         i_wr_adr    => s_u1_mem_wr_adr,
         i_wr_clk_en => c_tie_high,
         i_wr_din    => i_wr_din,
         i_wr_en     => s_u1_mem_wr_en,

         o_rd_dout   => o_rd_dout
         );         
End rtl;
