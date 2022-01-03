
--    
--    Copyright Ingenieurbuero Gardiner, 2021
--       https://www.ib-gardiner.eu
--       techsupport@ib-gardiner.eu
--
--    All Rights Reserved
--   
--------------------------------------------------------------------------------
--
-- File ID    : $Id: versa_ecp3-e.vhd 16 2021-10-05 12:33:32Z  $
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

Entity versa_ecp3 is
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
   attribute LOC of DL_UP              : signal is "U19";  
   attribute LOC of LTSSM_S0           : signal is "AA20";  -- USER0      
   attribute LOC of LTSSM_S1           : signal is "AB20";  -- USER1
   attribute LOC of LTSSM_S2           : signal is "V19";   -- USER2 
   attribute LOC of LTSSM_S3           : signal is "W19";   -- USER3    
   attribute LOC of PERST_N            : signal is "E18";
   
      --    ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   attribute PULLMODE   of PERST_N     : signal is "UP";   
End versa_ecp3;
