
--    
--    Copyright Ingenieurbuero Gardiner, 2021
--       https://www.ib-gardiner.eu
--       techsupport@ib-gardiner.eu
--
--    All Rights Reserved
--   
--------------------------------------------------------------------------------
--
-- File ID    : $Id: evbx1_ep2m-e.vhd 43 2021-11-18 17:41:37Z  $
-- Generated  : $LastChangedDate: 2021-11-18 18:41:37 +0100 (Thu, 18 Nov 2021) $
-- Revision   : $LastChangedRevision: 43 $
--
--------------------------------------------------------------------------------
--
-- Description : 
--
--------------------------------------------------------------------------------

Library IEEE;
Use IEEE.std_logic_1164.all;

Entity evbx1_ep2m is
   Port (
      REFCLK_P          : in  std_logic;
      REFCLK_N          : in  std_logic;
      PERST_N           : in  std_logic;
      HDIN_P0           : in  std_logic;
      HDIN_N0           : in  std_logic;

      DL_UP             : out std_logic;
      HDOUT_N0          : out std_logic;
      HDOUT_P0          : out std_logic;
      LTSSM_S3          : out std_logic;
      LTSSM_S2          : out std_logic;
      LTSSM_S1          : out std_logic;
      LTSSM_S0          : out std_logic
      );
      
      --    ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   attribute DRIVE      : string;   -- 20, 16, 12 (def.), 8, 4
   attribute IO_TYPE    : string;   -- LVTTL33, LVCMOS33
   attribute LOC        : string;
   attribute PULLMODE   : string;   -- UP, DOWN, NONE
   attribute SLEWRATE   : string;   -- FAST, SLOW

      --    ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   attribute IO_TYPE of DL_UP          : signal is "LVCMOS33";
   attribute IO_TYPE of LTSSM_S0       : signal is "LVCMOS33";
   attribute IO_TYPE of LTSSM_S1       : signal is "LVCMOS33";
   attribute IO_TYPE of LTSSM_S2       : signal is "LVCMOS33";
   attribute IO_TYPE of LTSSM_S3       : signal is "LVCMOS33";
   attribute IO_TYPE of PERST_N        : signal is "LVCMOS33";

      --    ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   attribute LOC of DL_UP              : signal is "U3";  
   attribute LOC of LTSSM_S0           : signal is "U6";  -- USER0      
   attribute LOC of LTSSM_S1           : signal is "V2";  -- USER1
   attribute LOC of LTSSM_S2           : signal is "V1";   -- USER2 
   attribute LOC of LTSSM_S3           : signal is "U4";   -- USER3    
   attribute LOC of PERST_N            : signal is "C12";
   
      --    ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   attribute PULLMODE   of PERST_N     : signal is "UP";   
End evbx1_ep2m;
