
--    
--    Copyright Ingenieurbuero Gardiner, 2021
--       https://www.ib-gardiner.eu
--       techsupport@ib-gardiner.eu
--
--    All Rights Reserved
--   
--------------------------------------------------------------------------------
--
-- File ID    : $Id: pcie_rsrc_decode-e.vhd 16 2021-10-05 12:33:32Z  $
-- Generated  : $LastChangedDate: 2021-10-05 14:33:32 +0200 (Tue, 05 Oct 2021) $
-- Revision   : $LastChangedRevision: 16 $
--
--------------------------------------------------------------------------------
--
-- Description : 
--
--------------------------------------------------------------------------------
Library IEEE;
Use IEEE.std_logic_1164.all;

Entity pcie_rsrc_decode is
   Port (
      i_decode_adr         : in  std_logic_vector;
      i_decode_bar_hit     : in  std_logic_vector(6 downto 0);
      
      o_decode_cyc         : out std_logic_vector
      );
End pcie_rsrc_decode;
