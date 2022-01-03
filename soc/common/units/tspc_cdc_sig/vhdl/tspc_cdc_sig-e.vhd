
--    
--    Copyright Ing. Buero Gardiner, 2007 - 2021
--     
--------------------------------------------------------------------------------
--
-- File ID     : $Id: tspc_cdc_sig-e.vhd 5248 2021-01-16 00:03:56Z  $
-- Generated   : $LastChangedDate: 2021-01-16 01:03:56 +0100 (Sat, 16 Jan 2021) $
-- Revision    : $LastChangedRevision: 5248 $
--
--------------------------------------------------------------------------------
--
-- Description : Synchroniser for single signal
--    
--------------------------------------------------------------------------------
Library IEEE;
Use IEEE.std_logic_1164.all;

Entity tspc_cdc_sig is
   Generic (
      g_stages    : positive := 1
      );
   Port ( 
      i_clk       : in  std_logic;
      i_rst_n     : in  std_logic;
      
      i_cdc_in    : in  std_logic;
      
      o_cdc_out   : out std_logic
      );
End tspc_cdc_sig;
      
