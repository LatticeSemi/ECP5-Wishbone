
--    
--    Copyright Ingenieurbuero Gardiner, 2021
--       https://www.ib-gardiner.eu
--       techsupport@ib-gardiner.eu
--
--    All Rights Reserved
--   
--------------------------------------------------------------------------------
--
-- File ID    : $Id: pcie_rsrc_decode-a_rtl.vhd 16 2021-10-05 12:33:32Z  $
-- Generated  : $LastChangedDate: 2021-10-05 14:33:32 +0200 (Tue, 05 Oct 2021) $
-- Revision   : $LastChangedRevision: 16 $
--
--------------------------------------------------------------------------------
--
-- Description : 
--
--------------------------------------------------------------------------------
Library IEEE;
Use IEEE.numeric_std.all;

Architecture Rtl of pcie_rsrc_decode is
   constant c_num_resources   : natural := o_decode_cyc'length ;

   signal s_decode_cyc     : std_logic_vector(c_num_resources - 1 downto 0);

Begin
   o_decode_cyc   <= s_decode_cyc;

      --    ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   s_decode_cyc(0)   <= i_decode_bar_hit(0) and not i_decode_adr(12);
   s_decode_cyc(1)   <= i_decode_bar_hit(0) and i_decode_adr(12);

End Rtl;
