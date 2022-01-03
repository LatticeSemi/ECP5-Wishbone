
--    
--    Copyright Ingenieurbuero Gardiner, 2021
--       https://www.ib-gardiner.eu
--       techsupport@ib-gardiner.eu
--
--    All Rights Reserved
--   
--------------------------------------------------------------------------------
--
-- File ID    : $Id: core_ae53-e.vhd 16 2021-10-05 12:33:32Z  $
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

Entity core_ae53 is
   Port (
      i_rst_n              : in  std_logic;
      
      i_refclkp            : in  std_logic;
      i_refclkn            : in  std_logic;
      i_hdinp0             : in  std_logic;
      i_hdinn0             : in  std_logic;
      o_hdoutp0            : out std_logic;
      o_hdoutn0            : out std_logic;  
      
      o_dl_up              : out std_logic;
      o_ltssm_state        : out std_logic_vector(3 downto 0);
      o_rtc_ev             : out std_logic
      );
End core_ae53;
