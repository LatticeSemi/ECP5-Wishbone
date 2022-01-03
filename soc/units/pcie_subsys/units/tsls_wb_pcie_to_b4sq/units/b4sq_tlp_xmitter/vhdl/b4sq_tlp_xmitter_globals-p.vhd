
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
-- File ID     : $Id: b4sq_tlp_xmitter_globals-p.vhd 4261 2018-06-17 21:56:32Z  $
-- Generated   : $LastChangedDate: 2018-06-17 23:56:32 +0200 (Sun, 17 Jun 2018) $
-- Revision    : $LastChangedRevision: 4261 $
--
--------------------------------------------------------------------------------
--
-- Description : Container package for global definitions and constants 
--
--------------------------------------------------------------------------------

Library IEEE;
Use IEEE.std_logic_1164.all;

Package b4sq_tlp_xmitter_globals is

   constant c_tlp_id_cplx     : std_logic_vector(1 downto 0) := "01";
   constant c_tlp_id_np       : std_logic_vector(1 downto 0) := "00";
   constant c_tlp_id_p        : std_logic_vector(1 downto 0) := "10";
   
End b4sq_tlp_xmitter_globals;
