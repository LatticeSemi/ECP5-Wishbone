
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
-- File ID     : $Id: tsls_wb_bmram-e.vhd 3872 2017-12-29 01:01:20Z  $
-- Generated   : $LastChangedDate: 2017-12-29 02:01:20 +0100 (Fri, 29 Dec 2017) $
-- Revision    : $LastChangedRevision: 3872 $
--
--------------------------------------------------------------------------------
--
-- Description : Wishbone Interface around Lattice PMI memory
--
--------------------------------------------------------------------------------

Library IEEE;
Use IEEE.std_logic_1164.all;

Entity tsls_wb_bmram is
   Generic (
      g_array_sz        : positive;
      g_char_sz         : positive := 8;  
      g_mem_reset_mode  : string := "async";  
      g_tech_lib        : string := "ECP3";
      g_word_sz         : positive := 4
      );
   Port (
      i_clk       : in  std_logic;
      i_rst_n     : in  std_logic;
      
      i_wb_adr    : in  std_logic_vector;
      i_wb_bte    : in  std_logic_vector(1 downto 0); 
      i_wb_cti    : in  std_logic_vector(2 downto 0);
      i_wb_cyc    : in  std_logic;
      i_wb_dat    : in  std_logic_vector;
      i_wb_lock   : in  std_logic;
      i_wb_sel    : in  std_logic_vector;
      i_wb_stb    : in  std_logic;
      i_wb_we     : in  std_logic;
           
      o_wb_ack    : out std_logic;      
      o_wb_dat    : out std_logic_vector
      );
End tsls_wb_bmram;
