
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
-- File ID     : $Id: tspc_wb_ebr_ctl-e.vhd 3850 2017-12-28 00:34:07Z  $
-- Generated   : $LastChangedDate: 2017-12-28 01:34:07 +0100 (Thu, 28 Dec 2017) $
-- Revision    : $LastChangedRevision: 3850 $
--
--------------------------------------------------------------------------------
--
-- Description : Wishbone Interface around Lattice PMI memory
--
--------------------------------------------------------------------------------

Library IEEE;
Use IEEE.std_logic_1164.all;

Entity tspc_wb_ebr_ctl is
   Generic (
      g_array_sz     : positive;
      g_char_sz      : positive := 8;   
      g_prescale     : positive := 1; 
      g_rd_pipe_sz   : natural := 1;
      g_word_sz      : positive := 4
      );
   Port (
      i_clk       : in  std_logic;
      i_rst_n     : in  std_logic;
      
      i_ram_dq    : in  std_logic_vector;
      i_ram_err   : in  std_logic := '0';
      i_ram_rty   : in  std_logic := '0';
      i_ram_wait  : in  std_logic := '0';
      i_wb_adr    : in  std_logic_vector;
      i_wb_bte    : in  std_logic_vector(1 downto 0); 
      i_wb_cti    : in  std_logic_vector(2 downto 0);
      i_wb_cyc    : in  std_logic;
      i_wb_wdat   : in  std_logic_vector;
      i_wb_lock   : in  std_logic := '0';
      i_wb_sel    : in  std_logic_vector;
      i_wb_stb    : in  std_logic;
      i_wb_we     : in  std_logic;
      
      o_ram_addr  : out std_logic_vector;
      o_ram_be    : out std_logic_vector;
      o_ram_wdat  : out std_logic_vector;
      o_ram_we    : out std_logic;
      o_wb_ack    : out std_logic;
      o_wb_err    : out std_logic;
      o_wb_rdat   : out std_logic_vector;
      o_wb_rty    : out std_logic   
      );
End tspc_wb_ebr_ctl;
